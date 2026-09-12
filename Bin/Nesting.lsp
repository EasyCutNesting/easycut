;(setq ECPartInPart$ T	; utilizzo sfrido fori pezzo
;	  ECScrapInPart$ T	; utilizzo sfrido controno pezzo
;	  ECMergeScrap$ nil	; ragruppamento di tutti gli sfridi lamiera
;)


(defun MyPrint (Text Data)
	(princ "\n--> ") (princ Text) (princ " ") (princ Data)
)

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
(defun GuiNesting (FileSaveShape FileSaveSheet Flag / 	MakeButtons UpDateButtons MakeListShape MakeListSheet GetSelectShape GetSelectSheet
														RestoreFile BoxToList ListToBox LoadTable SortBox UpdateBoxList UpDateFileShape UpDateFileSheet
														FileSaveShape FileSaveSheet LstButtonShapeKey LstSortShape LstSortSheet
														AlertShape$
														AlertSheet$
														xx LstBoxShape LstBoxSheet GoNesting FileShape FileSheet)
											   
	
	(defun MakeButtons (LstButtonKey LstStatusButton / XVect YVect Num Key XKey YKey XMKey YMKey X Y)
		
		(setq XVect (list (list -6 6 0)
						  (list -6 6 0)
					))
		(setq YVect (list (list -2 -2 2)
						  (list 2 2 -2)
					))
		(setq Num 0)
		(foreach Key LstButtonKey

			(setq XKey  (dimx_tile Key))
			(setq YKey  (dimy_tile Key))
			(setq XMKey (/ (dimx_tile Key) 2))
			(setq YMKey (/ (dimy_tile Key) 2))
			
			(start_image Key) 
			(if (> Num 0)
				(fill_image 0 0 XKey YKey -15)
			)
			
			(cond 
				((= (nth Num LstStatusButton) 1)
					(setq X (nth 0 XVect))
					(setq Y (nth 0 YVect))
				)	
				((= (nth Num LstStatusButton) -1)
					(setq X (nth 1 XVect))
					(setq Y (nth 1 YVect))
				)	
			)
			(if (and X Y)
				(progn
					(vector_image (+ XMKey (nth 0 X)) (+ YMKey (nth 0 Y)) (+ XMKey (nth 1 X)) (+ YMKey (nth 1 Y)) 250)
					(vector_image (+ XMKey (nth 1 X)) (+ YMKey (nth 1 Y)) (+ XMKey (nth 2 X)) (+ YMKey (nth 2 Y)) 250)
					(vector_image (+ XMKey (nth 2 X)) (+ YMKey (nth 2 Y)) (+ XMKey (nth 0 X)) (+ YMKey (nth 0 Y)) 250)
				)
			)
			(end_image)
			(setq Num (1+ Num))
			(setq X nil) (setq Y nil)
		)
	)
	;
	(defun UpDateButtons (Key LstButtonKey LstStatusButton / NthVal Num Rtn)
		(if (and Key LstStatusButton LstButtonKey)
			(progn
				(setq NthVal (GetNth LstButtonKey Key))
				(cond
					((= (nth NthVal LstStatusButton) 0)
						(setq Rtn (LM:SubstNth 1 NthVal LstStatusButton))
					)
					((= (nth NthVal LstStatusButton) 1)
						(setq Rtn (LM:SubstNth -1 NthVal LstStatusButton))
					)
					((= (nth NthVal LstStatusButton) -1)
						(setq Rtn (LM:SubstNth 1 NthVal LstStatusButton))
					)
				)
				(setq Num 0)
				(repeat (length LstStatusButton)
					(if (/= Num NthVal) (setq Rtn (LM:SubstNth 0 Num Rtn)))
					(setq Num (1+ Num))
				)
				(MakeButtons LstButtonKey Rtn)
			)
		)
		Rtn
	)
	;
	(defun MakeListShape (FileShape / EnameShape LstShape Pr itm LstIdShapeFromBom LstAssocIdEname Rtn)
	
		(setq Pr 1)
		(setq AlertShape$ nil)
		(if FileShape
			(if (setq LstShape (ReadFileNesting FileShape ";"))
				;Prg Id Order Phase Mark Qta Thik Length Height Mat n.torch
				;1 782139489 C792 1 1252 2 33 550 410 S355J2W 1
				(progn
					(foreach itm (GetLstBlockBomShapeByRgp $RgpShapeTarget NameBlockShape$)
						(setq LstIdShapeFromBom (append LstIdShapeFromBom (list (LM:vl-getattributevalue (vlax-ename->vla-object itm) "IDSHAPE"))))
					)
					(setq LstAssocIdEname (GetAssocIdEnameShspe))
					
					(foreach itm (cdr LstShape)
						(if (member (cadr itm) LstIdShapeFromBom)
							(progn
								(setq EnameShape (cadr (assoc (cadr itm) LstAssocIdEname)))
								(setq Rtn (append Rtn (list (list 	(LM:rtos Pr 2 0)
																	(cadr itm)					;Id
																	(GetComShape   EnameShape)	;Order
																	(GetPhaseShape EnameShape)	;Phase
																	(GetNameShape  EnameShape)	;Mark
																	(GetQtaShape   EnameShape)	;Qta
																	(GetTkShape    EnameShape)	;Tk
																	"OK"))))
							)
							(setq Rtn (append Rtn (list (list 	(LM:rtos Pr 2 0)
																(nth 1 itm)		;Id
																(nth 2 itm)		;Order
																(nth 3 itm)		;Phase
																(nth 4 itm)		;Mark
																(nth 5 itm)		;Qta
																(nth 6 itm)		;Tk
																"NO")))
								AlertShape$ T
							)
						)
						(setq Pr (1+ Pr))
					)
				)
			)
			(setq Rtn (SortTable Rtn '(0 0 1 2 4 0 3 0) "<"))
		)
		Rtn
	)
	;
	(defun MakeListSheet (FileSheet / EnameSheet DataSheet LstSheet itm Pr LstIdSheetFromBom LstAssocIdEname Rtn)
		
		(setq AlertSheet$ nil)
		(setq Pr 1)
		(if FileSheet
			(if (setq LstSheet (ReadFileNesting FileSheet ";"))
				;Prg Id Stok Width Length Thik Surface Weight Mat n.torch
				;2 02544 STK_GGG_02 2500 5000 10 12.5 981.25 FF 1
				(progn
					(foreach itm (GetLstBlockBomSheetByRgp)
						(setq LstIdSheetFromBom (append LstIdSheetFromBom (list (LM:vl-getattributevalue (vlax-ename->vla-object itm) "ID_SHEET"))))
					)
					(setq LstAssocIdEname (GetAssocIdEnameSheet))

					(foreach itm (cdr LstSheet)
						(if (member (cadr itm) LstIdSheetFromBom)
							(progn
								(setq EnameSheet (cadr (assoc (cadr itm) LstAssocIdEname)))
								(setq DataSheet  (GetDataSheetByEname EnameSheet))
								(setq Rtn (append Rtn (list (list  	(LM:rtos Pr 2 0)
																	(cadr itm)				;Id
																	(nth 1 DataSheet)		;Stock
																	(nth 2 DataSheet)		;Width
																	(nth 3 DataSheet)		;Length
																	(nth 4 DataSheet)		;Thik
																	"OK"))))
							)
							
							(setq Rtn (append Rtn (list (list  	(LM:rtos Pr 2 0)
																(nth 1 itm)		;Id
																(nth 2 itm)		;Stock
																(nth 3 itm)		;Width
																(nth 4 itm)		;Length
																(nth 5 itm)		;Thik
																"NO")))
								  AlertSheet$ T

							)
						)
						(setq Pr (1+ Pr))
					)
				)
				(setq Rtn (SortTable Rtn '(0 0 2 3 4 1 0) "<"))
			)
		)
		Rtn
	)
	;
	(defun GetSelectShape (OutFile Key TypeQuantity Flag / Rtn)
		(setq NameHeadDcl$ "Lista contorni")
		(if (not (CheckSameIdShape))
			(cond
				((= TypeQuantity "1")
					(setq Rtn (GuiSelPiecesShapeNesting (GetTableStockDeductShapeNesting) OutFile Flag 0))
				)
				((= TypeQuantity "0")
					(setq Rtn (GuiSelPiecesShapeNesting (GetTableStockShapeNesting)       OutFile Flag 0))
				)
			)
			(LM:popup "avvertimento" (strcat "esistono piu' contorni con lo stesso indice \n" (vl-prin1-to-string (CheckSameIdShape))) (+ 0 16 4096))
		)

		(if (car Rtn) 
			(set_tile  Key	(car Rtn)) 
			(set_tile  Key	"")
		)
	)	
	;
	(defun GetSelectSheet (OutFile Key / Rtn)
		(setq NameHeadDcl$ "Lista lamiere")
		(if (not (CheckSameIdSheet))
			(setq Rtn (GuiSelPiecesSheetNesting (GetTableStockSheetNesting 1) OutFile 0))
			(LM:popup "avvertimento" (strcat "esistono piu' lamiere con lo stesso indice \n" (vl-prin1-to-string (CheckSameIdSheet))) (+ 0 16 4096))
		)
		
		(if (car Rtn) 
			(set_tile  Key	(car Rtn)) 
			(set_tile  Key	"")
		)
	)
	;
	(defun RestoreFile (Key Ext / Rtn)
		(setq Rtn (LM:getfiles "Seleziona file Sheet" DxfNestingEasyCut$ Ext))
		(if Rtn 
			(set_tile  Key	(car Rtn)) 
			(set_tile  Key	"")
		)
		(car Rtn)
	)
	;
	(defun BoxToList (LstBox / itm Rtn)
		(foreach itm LstBox
			(setq Rtn (append Rtn (list (LM:str->lst itm "\t"))))
		)
	)
	;
	(defun ListToBox (LstBox / itm Rtn)
		(foreach itm LstBox
			(setq Rtn (append Rtn (list (LM:lst->str itm "\t"))))
		)
		Rtn
	)
	;
	(defun LoadTable (LstTable KeyBox)

		(if LstTable
			(progn
				(start_list KeyBox)
					(mapcar 'add_list LstTable)
				(end_list)
			)
		)
	)
	;
	(defun SortBox (LstTableNesting KeyBox LstSort / LstSort TypeSort Num itm Pos Rtn)

		(if (and LstTableNesting KeyBox LstSort)
			(progn
				(setq TypeSort ">")
				(setq Num 0)
				(foreach itm LstSort
					(if (= itm -1)
						(progn
							(setq TypeSort "<")
							(setq LstSort (LM:SubstNth 1 Num LstSort))
						)
					)
				)
				(setq Rtn (SortTable (BoxToList LstTableNesting) LstSort TypeSort))
				
				(setq Pos 1)
				(foreach itm Rtn
					(setq itm (LM:SubstNth (LM:rtos Pos 2 0) 0 itm))
					(setq Rtn (LM:SubstNth itm (1- Pos) Rtn))
					(setq Pos (1+ Pos))
				)
				(setq Rtn (ListToBox Rtn))
				(LoadTable Rtn KeyBox)
			)
		)
		Rtn
	)
	;
	(defun UpdateBoxList (KeyBox FileIn TypeEl / Lst Rtn)
		(if (and KeyBox FileIn)
			(if (findfile FileIn)
				(progn
					(cond 
						((= TypeEl "SHEET")
							(setq Lst  (MakeListSheet FileIn))
						)
						((= TypeEl "SHAPE")
							(setq Lst  (MakeListShape FileIn))
						)
					)
					(setq Rtn  (ListToBox Lst))
					(LoadTable Rtn KeyBox)
				)
			)
		)
		Rtn
	)
	
	;
	(defun UpDateFileShape (FileShape / LstShape itm LstIdShapeFromBom LstAssocIdEname wf EnameShape Prg Id 
									    Order Phase Mark Qta Tk DimSh Lg He Mat nT)
		

		(if (setq LstShape (ReadFileNesting FileShape ";"))
		
			; Prg     Id     Order Phase  Mark  Qta Thik  Length Height    Mat    n.torch
			;  1  782139489  C792    1    1252   2  33.0   550    410    S355J2W     1
			
			(progn
				(foreach itm (GetLstBlockBomShapeByRgp $RgpShapeTarget NameBlockShape$)
					(setq LstIdShapeFromBom (append LstIdShapeFromBom (list (LM:vl-getattributevalue (vlax-ename->vla-object itm) "IDSHAPE"))))
				)
				(setq LstAssocIdEname (GetAssocIdEnameShspe))

				(setq wf (open FileShape "w"))
				(foreach itm LstShape
					
					(if (member (cadr itm) LstIdShapeFromBom)
						(setq EnameShape (cadr (assoc (cadr itm) LstAssocIdEname))
							  Prg      	(nth 0 itm)
							  Id       	(nth 1 itm)
							  Order    	(GetComShape   EnameShape)
							  Phase    	(GetPhaseShape EnameShape)
							  Mark     	(GetNameShape  EnameShape)
							  Qta      	(GetQtaShape   EnameShape)
							  Tk       	(GetTkShape    EnameShape)
							  DimSh		(GetDimensionDummy EnameShape)
							  Lg       	(LM:rtos (nth 0 DimSh) 2 0)
							  He       	(LM:rtos (nth 1 DimSh) 2 0)
							  Mat      	(GetMatShape EnameShape)
							  nT       (nth 10 itm)
						)
						(setq Prg      (nth 0 itm)
							  Id       (nth 1 itm)
							  Order    (nth 2 itm)
							  Phase    (nth 3 itm)
							  Mark     (nth 4 itm)
							  Qta      (nth 5 itm)
							  Tk       (nth 6 itm)
							  Lg       (nth 7 itm)
							  He       (nth 8 itm)
							  Mat      (nth 9 itm)
							  nT       (nth 10 itm)
						)
					)	
					(princ (strcat Prg ";" Id ";" Order ";" Phase ";" Mark ";" Qta ";" Tk ";" Lg ";" He ";" Mat ";" nT "\n") wf)
				)
				(close wf)
			)
		)
	)
	;
	(defun UpDateFileSheet (FileSheet / LstSheet itm LstIdSheetFromBom LstAssocIdEname wf EnameSheet DataSheet
										Prg Id Stock Wd Lg Tk Surface Weight Mat)
		

		(if (setq LstSheet (ReadFileNesting FileSheet ";"))

			; Prg   Id      Stok     Width  Length  Thik  Surface  Weight  Mat
			;  2  02544  STK_GGG_02  2500   5000    10     12.5    981.25  FF

			(progn
				(foreach itm (GetLstBlockBomSheetByRgp)
					(setq LstIdSheetFromBom (append LstIdSheetFromBom (list (LM:vl-getattributevalue (vlax-ename->vla-object itm) "ID_SHEET"))))
				)
				(setq LstAssocIdEname (GetAssocIdEnameSheet))


				(setq wf (open FileSheet "w"))
				(foreach itm LstSheet
					(if (member (cadr itm) LstIdSheetFromBom)
						(setq EnameSheet (cadr (assoc (cadr itm) LstAssocIdEname))
						      DataSheet  (GetDataSheetByEname EnameSheet)
							  ;    0        1          2          3          4           5            6          7
							  ;(IdSheet NameSheet Widthsheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet)
							  Prg		(nth 0 itm)
							  Id		(nth 1 itm)
 							  Stock		(nth 1 DataSheet)		;Stock
							  Wd		(nth 2 DataSheet)		;Width
							  Lg		(nth 3 DataSheet)		;Length
							  Tk		(nth 4 DataSheet)		;Thick
							  Surface	(nth 5 DataSheet)		;Surface
							  Weight	(nth 6 DataSheet)		;Weight
							  Mat		(nth 7 DataSheet)		;Mat
						)
						(setq Prg      	(nth 0 itm)
							  Id       	(nth 1 itm)
 							  Stock		(nth 2 itm)
							  Wd		(nth 3 itm)
							  Lg		(nth 4 itm)
							  Tk		(nth 5 itm)
							  Surface	(nth 6 itm)
							  Weight	(nth 7 itm)
							  Mat		(nth 8 itm)
						)
					)	
					(princ (strcat Prg ";" Id ";" Stock ";" Wd ";" Lg ";" Tk ";" Surface ";" Weight ";" Mat "\n") wf)
				)
				(close wf)
			)
		)
	)	
	;
	; Main
	;
	(setq LstButtonShapeKey   '("BtShape1" "BtShape2" "BtShape3" "BtShape4" "BtShape5" "BtShape6" "BtShape7" "BtShape8"))
	(setq LstButtonSheetKey   '("BtSheet1" "BtSheet2" "BtSheet3" "BtSheet4" "BtSheet5" "BtSheet6" "BtSheet7"))
	(setq LstSortShape 	      '(0 0 0 0 0 0 0 0))
	(setq LstSortSheet 	      '(0 0 0 0 0 0 0))
	(setq AlertShape$ T)
	(setq AlertShape$ T)

	;
	; Set Torch 
	;(if (not $NumberTorch$) 	(setq $NumberTorch$ 1))
	; Set qtydeduct
	;(if (not CalcQtyDeduct$) 	(setq CalcQtyDeduct$ "1"))
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "NestingDialog" xx "" (cond ( *NestingDialog* ) ( '(-1 -1) )))
	
	(action_tile "SelectShape" 	(vl-prin1-to-string '(if (/= (GetSelectShape FileSaveShape "FileSelectShape" CalcQtyDeduct$ Flag) "")
														(setq LstBoxShape (UpdateBoxList "ListShape" FileSaveShape "SHAPE"))
													)))								
	(action_tile "SelectSheet" 	(vl-prin1-to-string '(if (/= (GetSelectSheet FileSaveSheet "FileSelectSheet") "")
														(setq LstBoxSheet (UpdateBoxList "ListSheet" FileSaveSheet "SHEET"))
													)))
	(foreach itm (cdr LstButtonShapeKey)
		(action_tile itm (strcat "(setq LstSortShape (UpDateButtons \"" itm "\" LstButtonShapeKey LstSortShape))
								  (setq LstBoxShape  (SortBox LstBoxShape \"ListShape\" LstSortShape))"))
	)
	(foreach itm (cdr LstButtonSheetKey)
		(action_tile itm (strcat "(setq LstSortSheet (UpDateButtons \"" itm "\" LstButtonSheetKey LstSortSheet))
								  (setq LstBoxSheet  (SortBox LstBoxSheet \"ListSheet\" LstSortSheet))")) 
	)
	(action_tile "RestoreShape"	(vl-prin1-to-string '(if (not (CheckSameIdShape))
														(progn  
															(setq FileSaveShape (RestoreFile   "FileSelectShape" "shp"))
															(UpDateFileShape FileSaveShape)
															(setq LstBoxShape   (UpdateBoxList "ListShape" FileSaveShape "SHAPE"))
														)
														(LM:popup "avvertimento" (strcat "esistono piu' contorni con lo stesso indice \n" (vl-prin1-to-string (CheckSameIdShape))) (+ 0 16 4096))
													)))
	(action_tile "RestoreSheet"	(vl-prin1-to-string '(if (not (CheckSameIdSheet))
														(progn 
															(setq FileSaveSheet (RestoreFile   "FileSelectSheet" "sht"))
															(UpDateFileSheet FileSaveSheet)
															(setq LstBoxSheet   (UpdateBoxList "ListSheet" FileSaveSheet "SHEET"))
														)
														(LM:popup "avvertimento" (strcat "esistono piu' lamiere con lo stesso indice \n" (vl-prin1-to-string (CheckSameIdSheet))) (+ 0 16 4096))
														
													)))															
	(action_tile "Nesting" 		(vl-prin1-to-string '(if (or AlertShape$ AlertSheet$)
														(LM:popup "Errore" "Contorni o lamiere non disponibili" (+ 0 16 4096))
															(progn
																(setq 	GoNesting T  
																		FileShape (get_tile "FileSelectShape")
																		FileSheet (get_tile "FileSelectSheet")
																		*NestingDialog* (done_dialog)
																)
																(unload_dialog xx)
															)
													)))
		
	(action_tile "cancel"		"(setq *NestingDialog* (done_dialog)) (unload_dialog xx)")
	(start_dialog)
	
	(if GoNesting
		(list FileShape FileSheet)
		nil
	)
)
;
;
;
(defun CreateNestingSimple (LstShape LstSheet / FormatListStockSheet FormatListStockShape UpdateLstShape MakeNesting NestingEvaluation DataStorageRectScrap
												itm LstEnameShape NewLstSheet InfoSheet IdSheet EnameSheet AngleCheck LstAngleCheck PosNesting DataNesting Rtn) 

	
	(defun FormatListStockSheet (LstSheet / itm SplitLst AssocItm Rcd L Rtn)
	
		; 0        1          2         3      4    5     6       7        8
		;"2" "162504882" "STK_GGG_2" "2500" "5000" "10" "12.5" "981.25" "S355J0"
        ;itm      id        nome      larg   lung   sp    mq     peso     qua

		(foreach itm LstSheet
		
			
			(setq SplitLst  itm)
			;(setq AssocItm  (strcat (nth 5 SplitLst) "|" (nth 8 SplitLst)))
			(setq AssocItm  "1|*")
			
			(if (setq Rcd (assoc AssocItm Rtn))
				;(setq L   (append (list AssocItm) (cdr Rcd) (list (list (+ (- (atof (nth 3 SplitLst)) $MargineLamieraDx $MargineLamieraSx) $MargineAccosto)
				;														(+ (- (atof (nth 4 SplitLst)) $MargineLamieraTp $MargineLamieraBt) $MargineAccosto)
				;														(nth 1 SplitLst))))
				;	  Rtn (subst L Rcd Rtn)
				;)
				;(setq Rtn 	(append Rtn (list 	(list "1|*"
				;									(list (+ (- (atof (nth 3 SplitLst)) $MargineLamieraDx $MargineLamieraSx) $MargineAccosto)
				;										  (+ (- (atof (nth 4 SplitLst)) $MargineLamieraTp $MargineLamieraBt) $MargineAccosto)
				;										  (nth 1 SplitLst)
				;									)
				;								)	
				;						)
				;			)
				;)
				(setq L   (append (list AssocItm) (cdr Rcd) (list (list (+ (- (atof (nth 3 SplitLst)) $MargineLamieraDx $MargineLamieraSx) 0.1)
																		(+ (- (atof (nth 4 SplitLst)) $MargineLamieraTp $MargineLamieraBt) 0.1)
																		(nth 1 SplitLst))))
					  Rtn (subst L Rcd Rtn)
				)
				(setq Rtn 	(append Rtn (list 	(list "1|*"
													(list (+ (- (atof (nth 3 SplitLst)) $MargineLamieraDx $MargineLamieraSx) 0.1)
														  (+ (- (atof (nth 4 SplitLst)) $MargineLamieraTp $MargineLamieraBt) 0.1)
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
	(defun FormatListStockShape (LstShape / itm SplitLst AssocItm Qta Rcd NewLst Rtn)
	
		; 0       1         2      3      4      5   6     7      8       9
		;"2" "516645398" "C872" "300" "178-370" "2" "1" "277.5" "290" "S355J0"
		;itm     id       comm   fase    mk     qta  sp   lung   larg    qua
		;
		(foreach itm LstShape

			(setq SplitLst itm)
			;(setq AssocItm  (strcat (nth 6 SplitLst) "|" (nth 9 SplitLst)))
			(setq AssocItm  "1|*")
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
					;(setq Rtn 	(append Rtn (list (append (list (strcat (nth 6 SplitLst) "|" (nth 9 SplitLst))) NewLst))))
					(setq Rtn 	(append Rtn (list (append (list "1|*") NewLst))))
				)	
			)
		)
		;( ("10|S355J0" (450.3 332.8 "162504882") (450.3 332.8 "015685") ...) ...)   
		Rtn
	)
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
	(defun MakeNesting (LstSheet LstShape / MergeScrap
											itm itm1 itm2 AssocItm DataShapes SheetWidth SheetHeight SheetId Prg
											OriginSheet TkSheet MatSheet Sheet Rtn LstShapeNotAllocated 
											LstNewSheet LstNestedShape DataNesting)
	
	
		(defun MergeScrap (LstNewSheet Verbose / itm Ori Rect LstCoo LstcooShapes)
		
			(foreach itm LstNewSheet
				(setq Ori	(cadr itm))
				(setq Rect	(car itm))
				(setq LstCoo (list 	(list (car Ori) 				(cadr Ori))
									(list  (+ (car Ori) (car Rect)) (cadr Ori))
									(list  (+ (car Ori) (car Rect))	(+ (cadr Ori) (cadr Rect)))
									(list  (car Ori)				(+ (cadr Ori) (cadr Rect)))
							))
				(setq LstCooShapes (append LstCooShapes (list (InfillingPoligon LstCoo 41.0 0.001))))
			)
			(setq NewSheet (PoligonToRectangle LstCooShapes 41.0 0.001 Verbose))
		)
		;
		; Main ++++++
		;
		(if (and LstSheet LstShape)
			(progn
			
				(foreach itm LstSheet				; ciclo per spessore e qualità
		
					(setq AssocItm (car itm))
					(setq DataShapes (cdr (assoc AssocItm LstShape)))
					(setq Prg 1)
					
					(foreach itm1 (cdr itm)			; ciclo per lamiera
						
						(setq SheetWidth	(car itm1))
						(setq SheetHeight	(cadr itm1))
						(setq SheetId 		(caddr itm1))
						(setq OriginSheet 	(GetOriginSheet (GetEnameSheetById SheetId)))
						(setq TkSheet    	(nth 0 (splitxt AssocItm "|")))
						(setq MatSheet    	(nth 1 (splitxt AssocItm "|")))
						(setq Sheet			(list SheetWidth SheetHeight))
						
						(princ (strcat "\n[" (LM:rtos Prg 2 0) "/" (LM:rtos (length (cdr itm)) 2 0) "]  "))
						(princ (strcat "ID Sheet " 	SheetId " - " 
													(LM:rtos (+ SheetWidth $MargineLamieraDx $MargineLamieraSx)  2 0) "x" 
													(LM:rtos (+ SheetHeight $MargineLamieraTp $MargineLamieraBt) 2 0)))
						(setq Prg (1+ Prg))

						(setq DataNesting 	(Nesting Sheet (list (+ (car OriginSheet) $MargineLamieraSx)(+ (cadr OriginSheet) $MargineLamieraBt))
													 DataShapes))
																	 
						(setq LstShapeNotAllocated 	(nth 0 DataNesting))
						(setq LstNewSheet 			(nth 1 DataNesting))
						(setq LstNestedShape		(nth 2 DataNesting))
						(setq DataShapes 			(UpdateLstShape DataShapes LstNestedShape))
						
						(setq  Rtn (append Rtn (list (list SheetWidth SheetHeight SheetId OriginSheet TkSheet MatSheet DataNesting))))
						
						; +++ Utilizzo Scrap ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
																	;	  b      h     xor.   yor.
						(if ECMergeScrap$
							(foreach itm2 (MergeScrap LstNewSheet nil)	; (((270.0 210.0) (725.0 15.0)) ((270.0 210.0) (725.0 225.0)) (....))
									
								(setq SheetWidth	(car  (car itm2)))
								(setq SheetHeight	(cadr (car itm2)))
								(setq OriginSheet 	(cadr itm2))
								(setq Sheet			(list SheetWidth SheetHeight))
								
								(setq DataNesting 	(Nesting Sheet (list (car OriginSheet)(cadr OriginSheet)) DataShapes))
																			
								(setq LstShapeNotAllocated 	(nth 0 DataNesting))
								(setq LstNewSheet 			(nth 1 DataNesting))
								(setq LstNestedShape		(nth 2 DataNesting))
								(setq DataShapes 			(UpdateLstShape DataShapes LstNestedShape))
								
								(setq  Rtn (append Rtn (list (list SheetWidth SheetHeight SheetId OriginSheet TkSheet MatSheet DataNesting))))
							)
						)
						; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					)
				)
			)
		)
		Rtn
	)
	;
	;
	(defun DataStorageRectScrap (LstShape / ResizeRectangle 
											IdShape	EnameShape MaxMin Pt1 Pt2 P1 P2 P3 CosDir0 CosDir90 RectScrap0 RectScrap90 Rtn0 Rtn90
											itm itm1 itm2 MinPtRect MaxPtRect RectScrap MaxMinScrap 
											LstIdEname LstXMarg1 LstYMarg1 LstXMarg2 LstYMarg2 Pos)

		;
		(defun ResizeRectangle (LstPt XMarg1 YMarg1 XMarg2 YMarg2)
			;(setq Pt1 (car LstPt))
			;(setq Pt2 (cadr LstPt))
			(setq LstPt (subst (list (+ (car (car LstPt))  XMarg1) (+ (cadr (car LstPt))  YMarg1)) (car LstPt)  LstPt))
			(setq LstPt (subst (list (- (car (cadr LstPt)) XMarg2) (- (cadr (cadr LstPt)) YMarg2)) (cadr LstPt) LstPt))
		 	(if (or (>= (car (car LstPt)) (car (cadr LstPt))) (>= (cadr (car LstPt)) (cadr (cadr LstPt))))
				nil
				LstPt
			)
		)
		;
		; Main
		;
		(if (or ECPartInPart$ ECScrapInPart$)
			(progn
				(foreach itm LstShape
					(setq 	IdShape			(cadr itm)
							EnameShape		(GetEnameShapeById IdShape)
							LstIdEname    	(append LstIdEname (list (list IdShape EnameShape)))
					)
				)
				(cond	
					((and ECPartInPart$ ECScrapInPart$)
						(StartProgressBar "Create Scrap & Part in Part Shape :" (length LstShape))
					)
					(ECPartInPart$
						(StartProgressBar "Create Part in Part Shape :" (length LstShape))
					)
					(ECScrapInPart$
						(StartProgressBar "Create Scrap Shape :" (length LstShape))
					)
				)
				(foreach itm LstIdEname
					(setq RectScrap0 nil)
					(setq RectScrap90 nil)
					
					(UpDateProgressBar)
					
					(setq 	IdShape		(car itm)
							EnameShape	(cadr itm)
							MaxMin 		(BoundingBoxLstEname (list EnameShape))
							;
							; Shift Origin Scrap $MargineAccosto +++++++++++++++++++++++++++++++++++++++
							;
							P1			(list (+ (car (car MaxMin)) 	$MargineAccosto) (+ (cadr (car MaxMin)) 	$MargineAccosto))
							P2			(list (- (car (cadr MaxMin)) 	$MargineAccosto) (+ (cadr (cadr MaxMin)) 	$MargineAccosto))
							P3			(list (+ (car (cadddr MaxMin)) 	$MargineAccosto) (- (cadr (cadddr MaxMin)) 	$MargineAccosto))
					)
					;---------------------------------------------------------------------------------------------------------------
					(setq CosDir0  (DefPiano (car P1) (cadr P1) 0.0 (car P2) (cadr P2) 0.0 (car P3) (cadr P3) 0.0))
					(setq CosDir90 (DefPiano (car P3) (cadr P3) 0.0 (car P1) (cadr P1) 0.0 (car P2) (cadr P2) 0.0))
					; ++++++++++++++++++++++++++++++++++
					;
					; Scrap Shape ++++++
					;
					;+++++++++++++++++++++++++++++++++++
					(if ECScrapInPart$
						(foreach itm1 (MaxRectangleOnScrapShape EnameShape nil)
						
							;(princ "\nECScrapInPart$") (princ " ") (princ IdShape)

							(if (setq itm1 (ResizeRectangle itm1 $MargineAccosto $MargineAccosto $MargineAccosto $MargineAccosto))
								(progn
									;
									; 0 degree +++++
									;
									(setq 	Pt1 (TransLPt (car  itm1) CosDir0)
											Pt2 (TransLPt (cadr itm1) CosDir0)
											MinPtRect  (list (min (nth 0 Pt1) (nth 0 Pt2)) (min (nth 1 Pt1) (nth 1 Pt2)))
											MaxPtRect  (list (max (nth 0 Pt1) (nth 0 Pt2)) (max (nth 1 Pt1) (nth 1 Pt2)))
									)
									(if (>= (* (abs (- (car MaxPtRect) (car MinPtRect))) (abs (- (cadr MaxPtRect) (cadr MinPtRect)))) $EasyCutMinGrossSurface)
										(setq RectScrap0 (append RectScrap0 (list (list MinPtRect MaxPtRect))))
									)
									;
									; 90 degree +++++
									;
									(setq 	Pt1 (TransLPt (car  itm1) CosDir90)
											Pt2 (TransLPt (cadr itm1) CosDir90)
											MinPtRect   (list (min (nth 0 Pt1) (nth 0 Pt2)) (min (nth 1 Pt1) (nth 1 Pt2)))
											MaxPtRect   (list (max (nth 0 Pt1) (nth 0 Pt2)) (max (nth 1 Pt1) (nth 1 Pt2)))
									)
									(if (>= (* (abs (- (car MaxPtRect) (car MinPtRect))) (abs (- (cadr MaxPtRect) (cadr MinPtRect)))) $EasyCutMinGrossSurface)
										(setq RectScrap90 (append RectScrap90 (list (list MinPtRect MaxPtRect))))
									)
								)
							)
						)
					)
					; ++++++++++++++++++++++++++++++++++
					;
					; Part in Part Shape ++++++
					;
					;+++++++++++++++++++++++++++++++++++
					(if ECPartInPart$
						(foreach itm1 (GetEnameInternalShapeByDummyEnameSelect EnameShape)
						
							;(princ "\nECPartInPart$") (princ " ") (princ IdShape)
							
							(setq RectScrap (MaxRectangleOnEnamePoligon itm1 41.0 0.001 nil))
							(cond
								((= (length RectScrap) 1) 
									(if (setq MaxMinScrap (ResizeRectangle (car RectScrap) $MargineAccosto $MargineAccosto $MargineAccosto $MargineAccosto))
										(progn
											;
											; 0 degree +++++
											;
											(setq 	Pt1 (TransLPt (car  MaxMinScrap) CosDir0)
													Pt2 (TransLPt (cadr MaxMinScrap) CosDir0)
													MinPtRect  (list (min (nth 0 Pt1) (nth 0 Pt2)) (min (nth 1 Pt1) (nth 1 Pt2)))
													MaxPtRect  (list (max (nth 0 Pt1) (nth 0 Pt2)) (max (nth 1 Pt1) (nth 1 Pt2)))
											)
											(if (>= (* (abs (- (car MaxPtRect) (car MinPtRect))) (abs (- (cadr MaxPtRect) (cadr MinPtRect)))) $EasyCutMinGrossSurface)
												(setq RectScrap0 (append RectScrap0 (list (list MinPtRect MaxPtRect))))
											)
											;
											; 90 degree +++++
											;
											(setq 	Pt1 (TransLPt (car  MaxMinScrap) CosDir90)
													Pt2 (TransLPt (cadr MaxMinScrap) CosDir90)
													MinPtRect  (list (min (nth 0 Pt1) (nth 0 Pt2)) (min (nth 1 Pt1) (nth 1 Pt2)))
													MaxPtRect  (list (max (nth 0 Pt1) (nth 0 Pt2)) (max (nth 1 Pt1) (nth 1 Pt2)))
											)
											(if (>= (* (abs (- (car MaxPtRect) (car MinPtRect))) (abs (- (cadr MaxPtRect) (cadr MinPtRect)))) $EasyCutMinGrossSurface)
												(setq RectScrap90 (append RectScrap90 (list (list MinPtRect MaxPtRect))))
											)
										)
									)
								)
								(T 	; circle
									(setq LstXMarg1 (list $MargineAccosto $MargineAccosto 0.0			  $MargineAccosto $MargineAccosto 	))
									(setq LstYMarg1 (list $MargineAccosto $MargineAccosto $MargineAccosto 0.0			  $MargineAccosto 	))
									(setq LstXMarg2 (list $MargineAccosto $MargineAccosto $MargineAccosto $MargineAccosto 0.0				))
									(setq LstYMarg2 (list $MargineAccosto 0.0			  $MargineAccosto $MargineAccosto $MargineAccosto 	))
									(setq Pos 0)
									
									(foreach itm2 RectScrap
										(if (setq MaxMinScrap (ResizeRectangle itm2 (nth Pos LstXMarg1) (nth Pos LstYMarg1) (nth Pos LstXMarg2) (nth Pos LstYMarg2)))
											(progn
												;
												; 0 degree +++++
												;
												(setq 	Pt1 (TransLPt (car  MaxMinScrap) CosDir0)
														Pt2 (TransLPt (cadr MaxMinScrap) CosDir0)
														MinPtRect  (list (min (nth 0 Pt1) (nth 0 Pt2)) (min (nth 1 Pt1) (nth 1 Pt2)))
														MaxPtRect  (list (max (nth 0 Pt1) (nth 0 Pt2)) (max (nth 1 Pt1) (nth 1 Pt2)))
												)
												(if (>= (* (abs (- (car MaxPtRect) (car MinPtRect))) (abs (- (cadr MaxPtRect) (cadr MinPtRect)))) $EasyCutMinGrossSurface)
													(setq RectScrap0 (append RectScrap0 (list (list MinPtRect MaxPtRect))))
												)
												;
												; 90 degree +++++
												;
												(setq 	Pt1 (TransLPt (car  MaxMinScrap) CosDir90)
														Pt2 (TransLPt (cadr MaxMinScrap) CosDir90)
														MinPtRect  (list (min (nth 0 Pt1) (nth 0 Pt2)) (min (nth 1 Pt1) (nth 1 Pt2)))
														MaxPtRect  (list (max (nth 0 Pt1) (nth 0 Pt2)) (max (nth 1 Pt1) (nth 1 Pt2)))
												)
												(if (>= (* (abs (- (car MaxPtRect) (car MinPtRect))) (abs (- (cadr MaxPtRect) (cadr MinPtRect)))) $EasyCutMinGrossSurface)
													(setq RectScrap90 (append RectScrap90 (list (list MinPtRect MaxPtRect))))
												)
											)
										)
										(setq Pos (1+ Pos))
									)
								)
							)
						)
					)
					(setq Rtn0  (append Rtn0  (list (list IdShape EnameShape RectScrap0))))
					(setq Rtn90 (append Rtn90 (list (list IdShape EnameShape RectScrap90))))
				)
				(ClearProgressBar)
			)
			(progn
				(foreach itm LstShape
					(setq 	IdShape			(cadr itm)
							EnameShape		(GetEnameShapeById IdShape)
							Rtn0	    	(append Rtn0 (list (list IdShape EnameShape nil)))
							Rtn90	    	Rtn0
					)
				)
			)
		)
		(list Rtn0 Rtn90)
	)	
	;
	;
	(defun NestingEvaluation (DataNesting / itm itm1 itm2 SheetWidth SheetHeight SheetId OriginSheet
											TkSheet MatSheet DataNesting LstShapeNotAllocated
											LstNewSheet LstNestedShape AreaShapeNotAllocated AreaScrap 
											AreaShapeAllocated LstScrap TotScrap Rtn)
		
		
		(foreach itm DataNesting
		
			(setq TotScrap 0.0)

			(foreach itm1 itm
				
				(setq SheetWidth 			(nth 0 itm1))			
				(setq SheetHeight 			(nth 1 itm1))
				(setq SheetId 				(nth 2 itm1))
				(setq OriginSheet 			(nth 3 itm1))
				(setq TkSheet 				(nth 4 itm1))
				(setq MatSheet 				(nth 5 itm1))
				(setq LstShapeNotAllocated 	(nth 0 (nth 6 itm1)))
				(setq LstNewSheet 			(nth 1 (nth 6 itm1)))
				(setq LstNestedShape		(nth 2 (nth 6 itm1)))
				; LstShapeNotAllocated ( (100 125 "123456") ....)
				; LstNewSheet		   ( ((1112 2534) (xori yori)) (....) )
				; LstNestedShape       ( ((1112 2534 "4566") (xori yori)) (....) )

				(setq AreaShapeNotAllocated 0.0)
				(setq AreaScrap 			0.0)
				(setq AreaShapeAllocated 	0.0)
				
			
				(if LstShapeNotAllocated
					(foreach itm2 LstShapeNotAllocated
						(setq AreaShapeNotAllocated (+ AreaShapeNotAllocated (* (car itm2) (cadr itm2))))
					)
				)
				; +++++++++++++++++++++++++++++++++++
				(if LstNewSheet
					(foreach itm1 LstNewSheet
						(setq AreaScrap (+ AreaScrap (* (car (car itm1)) (cadr (car itm1)))))
						(setq TotScrap  (+ TotScrap  (* (car (car itm1)) (cadr (car itm1)))))
					)
				)
				; +++++++++++++++++++++++++++++++++++	
				(if LstNestedShape
					(foreach itm1 LstNestedShape
						(setq AreaShapeAllocated (+ AreaShapeAllocated (* (car (car itm1)) (cadr (car itm1)))))
					)
				)
				; +++++++++++++++++++++++++++++++++++
			)
			(setq LstScrap (append LstScrap (list TotScrap)))
		)
		(princ "\n--> Scrap ") (princ LstScrap)
		
		(if LstScrap
			(vl-sort-i LstScrap '<)
			nil
		)
	)	
	;
	; Main +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(if (not LstSheet) (alert "Nessuna lamiera selezionata"))
	(if (not LstShape) (alert "Nessun controno selezionato"))

	(princ "\n")
	(princ "\nECPartInPart$  ")  (princ ECPartInPart$)
	(princ "\nECScrapInPart$ ")  (princ ECScrapInPart$)
	(princ "\nECMergeScrap$  ")  (princ ECMergeScrap$)
	(princ "\n")
	
	; Check format sheet --------------------------------------------------------------------------------------
	(foreach itm LstSheet
		; 0        1          2         3      4    5     6       7        8	
		;"2" "162504882" "STK_GGG_2" "2500" "5000" "10" "12.5" "981.25" "S355J0"
		;itm      id        nome      larg   lung   sp    mq     peso     qua	
		(setq IdSheet  	 (nth 1 itm))
		(setq EnameSheet (GetEnameSheetById IdSheet))
		;
		(cond 
			((not EnameSheet)
				(LM:popup "Avvertimento" (strcat "Lamiera id." IdSheet " esclusa dal nesting\n"
												 "La lamiera non esiste") (+ 0 64 4096))
				(princ (strcat "\nLamiera id. " IdSheet " esclusa del nesting, non esiste"))
			)
			((not (IsRectangle EnameSheet))
				(LM:popup "Avvertimento" (strcat "Lamiera id." IdSheet " esclusa dal nesting\n"
												 "La lamiera deve essere di forma rettangolare") (+ 0 64 4096))
				(princ (strcat "\nLamiera id. " IdSheet " esclusa del nesting, non e' di forma rettangolare"))
			)
			((GetEnameShapeByEnameSheet EnameSheet "CE+CI")
				(LM:popup "Avvertimento" (strcat "Lamiera id." IdSheet " esclusa dal nesting\n"
												 "La lamiera non e' vuota") (+ 0 64 4096))
				(princ (strcat "\nLamiera id. " IdSheet " esclusa del nesting, non e' vuota"))
			)
			(t
				(setq NewLstSheet (append NewLstSheet (list itm)))
			)
		)
	)
	; ---------------------------------------------------------------------------------------------------------
	(if (not NewLstSheet) (alert "Nessuna lamiera selezionata"))
	
	(if (and NewLstSheet LstShape)
		(progn
			;----- Storage scrap -------------------------------------
			(foreach itm LstShape (setq LstEnameShape (append LstEnameShape (list (GetEnameShapeById (cadr itm))))))
			(setq $EasyCutMinGrossSurface (car (GetSurfaceShape LstEnameShape)))
			(setq Rtn 				  (DataStorageRectScrap LstShape))
			(setq $EasyCutRectScrap0  (car Rtn))
			(setq $EasyCutRectScrap90 (cadr Rtn))
			
			;---------------------------------------------------------
			(setq DataNesting (append DataNesting (list (MakeNesting (FormatListStockSheet NewLstSheet)
																	 (FormatListStockShape LstShape)))))
			
			;(ReportNesting     (nth 0 DataNesting)) ;Sheet SheetId LstShapeNotAllocated LstNewSheet LstNestedShape)
			(PrintNestingSheet (nth 0 DataNesting)) ;OriginSheet LstNestedShape LstShapeNotAllocated AngleCheck)
			(alert "Finito !")
		)
	)
)
;
;
;
(defun Nesting (Sheet Origin LstShape / Rtn1 Rtn2 LstShapeNotAllocated LstNewSheet LstNestedShape itm itm1)

	;
	; Fase 1 ++++++++++++++++++++++++++++++++++
	;
	(setq LstShape 	(SortShape01 LstShape))
	(setq Rtn1 		(Nesting01 Sheet Origin LstShape))
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

	
	(list LstShapeNotAllocated LstNewSheet LstNestedShape)
)
;
;
;
(defun Nesting01 (Sheet Origin LstShape / GetSheetAfterCut
										  LstStock Loop ContaStock Rtn LstNestedShape LstShapeNotAlocated Shape LstSheet LstCoo itm)
	;
	;
	(defun GetSheetAfterCut (OriginSheet Sheet Shape / 	OriginRectangleOnScrapShape OffsetScrapRect GetAngleRotationShape
														BShape1 HShape1 BShape2 HShape2 IdShape BSheet HSheet 
														BScrap1 HScrap1 BScrap2 HScrap2
														BNSheet1 HNSheet1 BNSheet2 HNSheet2
														Scrap OScrap NSheet ONSheet Rotation
														DataScrap DataSheet DataShape DataScrapRect
														RectScrap0 RectScrap90
														Rtn)
		
		(defun OffsetScrapRect (LstRectScrap / itm MinPtRect MaxPtRect CheckArea Rtn)
		
			(foreach itm LstRectScrap
				(setq MinPtRect (car itm)
					  MaxPtRect (cadr itm)
					  
					  ; MinPtRect (list (- (car MinPtRect) (/ $MargineAccosto 2.0)) (- (cadr MinPtRect) (/ $MargineAccosto 2.0)))
					  ; MaxPtRect (list (+ (car MaxPtRect) (/ $MargineAccosto 2.0)) (+ (cadr MaxPtRect) (/ $MargineAccosto 2.0)))
					  
					  CheckArea (abs (*  (- (car MaxPtRect) (car MinPtRect)) (- (cadr MaxPtRect) (cadr MinPtRect))))
				)
				;(princ "\n") (princ (Double->SimpleDouble $EasyCutMinGrossSurface 2)) (princ " ") (princ (Double->SimpleDouble CheckArea 2))
				;(princ "\n") (princ (Double->SimpleDouble  (/ $EasyCutMinGrossSurface CheckArea) 2))
				;(princ "\n") (princ (Double->SimpleDouble  (/ CheckArea $EasyCutMinGrossSurface) 2))
				
				(if (>= (Double->SimpleDouble CheckArea 2) 
						(Double->SimpleDouble $EasyCutMinGrossSurface 2)
					)
					(setq Rtn (append Rtn (list (list MinPtRect MaxPtRect))))
				)
			)
			Rtn
		)
		;
		(defun OriginRectangleOnScrapShape (OriginSheet LstRectScrap / itm MinPtRect MaxPtRect LengthRect HeightRect OriRect Rtn)
		
		
			(foreach itm LstRectScrap
				(setq MinPtRect  (car itm)
					  MaxPtRect  (cadr itm)
					  LengthRect (abs (- (car  MaxPtRect) (car  MinPtRect)))
					  HeightRect (abs (- (cadr MaxPtRect) (cadr MinPtRect)))
					  OriRect    (list (+ (car  OriginSheet) (car  MinPtRect) $MargineAccosto)
									   (+ (cadr OriginSheet) (cadr MinPtRect) $MargineAccosto))
					  Rtn (append Rtn (list (list (list LengthRect HeightRect) OriRect)))
				)
			)
			Rtn
		)
		;
		(defun GetAngleRotationShape (BShape HShape BSheet HSheet / ScrapX0 ScrapX90 ScrapY0 ScrapY90 LstRotate Scrap1 Scarp2 NShape Rtn)
	
			(setq ScrapX0  1e8)
			(setq ScrapX90 1e8)
			(setq ScrapY0  1e8)
			(setq ScrapY90 1e8)
			(setq LstRotate '(0.0 90.0 0.0 90.0))
			;(if (and BShape HShape BSheet HSheet)
			;	(progn
			;		(if (and (<= BShape BSheet) (<= HShape HSheet)) ; 0°
			;			(progn
			;				(setq NShape (fix (/ BSheet BShape)))
			;				(setq Scrap1 (* (- HSheet HShape) NShape))
			;				(setq Scrap2 (- BSheet (* NShape BShape)))
			;				(if (< Scrap1 Scrap2) (setq ScrapX0 Scrap1) (setq ScrapX0 Scrap2))
			;			)
			;		)
			;		(if (and (<= HShape BSheet) (<= BShape HSheet)) ; 90°
			;			(progn
			;				(setq Nshape (fix (/ BSheet HShape)))
			;				(setq Scrap1 (* (- BSheet HShape) NShape))
			;				(setq Scrap2 (- BSheet (* NShape HShape)))
			;				(if (< Scrap1 Scrap2) (setq ScrapX90 Scrap1) (setq ScrapX90 Scrap2))
			;			)
			;		)
			;		(setq Rtn (nth (car (vl-sort-i (list ScrapX0 ScrapX90) '<)) LstRotate))
			;	)
			;)	
			(if (and BShape HShape BSheet HSheet)
				(progn
					(if (and (<= BShape BSheet) (<= HShape HSheet)) ; 0°
						(progn
							(if (= $EasyCutOptimizeScrap "x")
								(progn
									(setq Scrap1 (* (- HSheet HShape) BSheet))
									(setq Scrap2 (- (* BSheet HShape) (* BShape HShape (fix (/ BSheet BShape)))))
									(if (< Scrap1 Scrap2) (setq ScrapX0 Scrap1) (setq ScrapX0 Scrap2))
								)
							)
							(if (= $EasyCutOptimizeScrap "y") 
								(progn
									(setq Scrap1 (* (- BSheet BShape) HSheet))
									(setq Scrap2 (- (* HSheet BShape) (* BShape HShape (fix (/ HSheet HShape)))))
									
									;(princ "\nScrap1 Y0=") 	(princ Scrap1) 
									;(princ " Scrap2 Y0=")  	(princ Scrap2) 
									;(princ " Rip.=") 		(princ (fix (/ HSheet HShape)))
									;(princ "\n* HSheet BShape") 						(princ (* HSheet BShape))
									;(princ "\n* BShape HShape (fix (/ HSheet HShape))")	(princ (* BShape HShape (fix (/ HSheet HShape))))
									;(princ "\nBSheet x HSheet") (princ (strcat (LM:rtos BSheet 2 1) " " (LM:rtos HSheet 2 1)))
									;(princ "\nBShape x HShape") (princ (strcat (LM:rtos BShape 2 1) " " (LM:rtos HShape 2 1)))

									(if (< Scrap1 Scrap2) (setq ScrapY0 Scrap1) (setq ScrapY0 Scrap2))
								)
							)
						)
					)
					(if (and (<= HShape BSheet) (<= BShape HSheet)) ; 90°
						(progn
						
							(if (= $EasyCutOptimizeScrap "x") 
								(progn
									(setq Scrap1 (* (- HSheet BShape) BSheet))
									(setq Scrap2 (- (* BSheet BShape) (* BShape HShape (fix (/ BSheet HShape)))))
									(if (< Scrap1 Scrap2) (setq ScrapX90 Scrap1) (setq ScrapX90 Scrap2))
								)
							)
							(if (= $EasyCutOptimizeScrap "y") 
								(progn
									(setq Scrap1 (* (- BSheet HShape) HSheet))
									(setq Scrap2 (- (* HSheet HShape) (* BShape HShape (fix (/ HSheet BShape)))))

									;(princ "\nScrap1 Y90=") (princ Scrap1) 
									;(princ " Scrap2 Y90=") 	(princ Scrap2)
									;(princ " Rip.=") 		(princ (fix (/ HSheet BShape)))
									;(princ "\nBSheet x HSheet") (princ (strcat (LM:rtos BSheet 2 1) " " (LM:rtos HSheet 2 1)))
									;(princ "\nBShape x HShape") (princ (strcat (LM:rtos BShape 2 1) " " (LM:rtos HShape 2 1)))

									(if (< Scrap1 Scrap2) (setq ScrapY90 Scrap1) (setq ScrapY90 Scrap2))
								)
							)
						)
					)
					;(trace vl-sort-i)
					(setq Rtn (nth (car (vl-sort-i (list ScrapX0 ScrapX90 ScrapY0 ScrapY90) '<)) LstRotate))
					;(untrace vl-sort-i)
					
				)
			)			
			;(princ "\n") (princ Rtn) (getstring "-GetAngleRotationShape-")
			Rtn
		)
		;
		; Main 
		;
		(setq Rtn (list nil nil nil nil))
		
		(if (and OriginSheet Sheet Shape)
			(setq BShape1 (car  Shape) 	; 0°
				  HShape1 (cadr Shape)	; 0°
				  BShape2 HShape1		; 90°
				  HShape2 BShape1		; 90°
				  
			      IdShape 	 (caddr Shape)
				  BSheet  	 (car   Sheet)
				  HSheet  	 (cadr  Sheet)
				  
				  RectScrap0  (OffsetScrapRect (nth 2 (assoc IdShape $EasyCutRectScrap0)))
				  RectScrap90 (OffsetScrapRect (nth 2 (assoc IdShape $EasyCutRectScrap90)))
			)
		)

		(if (and OriginSheet Sheet Shape)
			(if (or (and (>= BSheet BShape1) (>= HSheet HShape1)) ; 0°
					(and (>= BSheet BShape2) (>= HSheet HShape2)) ; 90°
				)
				(progn
					(cond 												;
						((= $EasyCutOptimizeScrap "x")					;		+-----------+
							(setq BScrap1 (- BSheet BShape1)			;		|			|
								  HScrap1 HShape1						;		|			|
								  BScrap2 (- BSheet BShape2)			;		|			|
								  HScrap2 HShape2						;		|			|
							)											;		|			|
							(setq BNSheet1 BSheet						;		|			|
								  HNSheet1 (- HSheet HShape1)			;		|			|
								  BNSheet2 BSheet						;		|			|
								  HNSheet2 (- HSheet HShape2)			;		|			|
							)											;		+-----------+
						)												;
						((= $EasyCutOptimizeScrap "y")					;		
							(setq BScrap1 (- BSheet BShape1)			;		+-----------------------+
								  HScrap1 HSheet						;		|						|
								  BScrap2 (- BSheet BShape2)			;		|						|
								  HScrap2 HSheet						;		|						|
							)											;		|						|
							(setq BNSheet1 BShape1						;		|						|
								  HNSheet1 (- HSheet HShape1)			;		+-----------------------+			
								  BNSheet2 BShape2						;		
								  HNSheet2 (- HSheet HShape2)			;		
							)											;		
						)												;		
					)													;

					(setq Rotation (GetAngleRotationShape BShape1 HShape1 BSheet HSheet)) ; verifica rotazione su Sheet
					
					(cond 
						((= Rotation 0)
							(if RectScrap0 (setq DataScrapRect  (OriginRectangleOnScrapShape OriginSheet RectScrap0)))
						)
						((= Rotation 90)
							(if RectScrap90 (setq DataScrapRect (OriginRectangleOnScrapShape OriginSheet RectScrap90)))
						)
					)
					
					(cond
						((= Rotation 0)  ; ----> rotazione 0°
							(setq Scrap  	(list BScrap1 HScrap1)
								  Oscrap 	(list (+ (car OriginSheet) BShape1) (cadr OriginSheet)))
							(setq NSheet  	(list BNSheet1 HNSheet1)
								  ONSheet 	(list (car OriginSheet) (+ (cadr OriginSheet) HShape1)))
							(setq DataShape	(list BShape1 HShape1 IdShape Rotation))
						)
						((= Rotation 90) ; ----> rotazione 90°
							(setq Scrap  	(list BScrap2 HScrap2)
								  Oscrap 	(list (+ (car OriginSheet) BShape2) (cadr OriginSheet)))
							(setq NSheet  	(list BNSheet2 HNSheet2)
								  ONSheet 	(list (car OriginSheet) (+ (cadr OriginSheet) HShape2)))
							(setq DataShape	(list BShape2 HShape2 IdShape Rotation))
						)
					)
					
					(if (or (= (car  Scrap)  0) (= (cadr  Scrap)  0))	
						(setq DataScrap  nil)
						;(if (< (* (car  Scrap) (cadr  Scrap)) $EasyCutMinGrossSurface)
						;	(setq DataScrap nil)
							(setq DataScrap (list Scrap OScrap))
						;)
					)
					(if (or (= (car  NSheet) 0) (= (cadr  NSheet) 0))
						(setq DataSheet  nil)
						;(if (< (* (car  NSheet) (cadr  NSheet)) $EasyCutMinGrossSurface)
						;	(setq DataSheet nil)
							(setq DataSheet (list NSheet ONSheet))
						;)
					)
					
					;  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					;	(princ "\nSheet          ->") (princ Sheet)
					;	(princ "\nShape          ->") (princ Shape)
					;	(princ "\nScrap          ->") (princ Scrap)
					;	(princ "\nNSheet         ->") (princ NSheet)
					;	(princ "\nOScrap         ->") (princ OScrap)
					;	(princ "\nONSheet        ->") (princ ONSheet)
					;	(princ "\nDataShape      ->") (princ DataShape)
					;	(princ "\nDataScrapRect  ->") (princ DataScrapRect) (princ "\n")
					;  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					;				    0         1          2            3
					(setq Rtn (list DataScrap DataSheet DataScrapRect DataShape))
				)
				;(progn
				;	(princ "\nSheet scartato ->") (princ Sheet)
				;	(princ "\nShape scartato ->") (princ Shape) (princ "\n")
				;)
			)
		)

		Rtn
	)	
	;
	; Main
	;
	(if (<= (car Sheet) (cadr Sheet))
		(setq $EasyCutOptimizeScrap "x")
		(setq $EasyCutOptimizeScrap "y")
	)
	
	(setq LstStock (list (list Sheet Origin)))

	(foreach Shape LstShape
	
		(setq Loop T)
		(setq ContaStock 0)

		; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
		(while (and Loop  (nth ContaStock LstStock))

			(setq Rtn (GetSheetAfterCut (nth 1 (nth ContaStock LstStock)) (nth 0 (nth ContaStock LstStock)) Shape))
			;	  0			1			2			3
			;(DataScrap DataSheet DataScrapRect DataShape)
			;
			(if (nth 3 Rtn)
				(progn
					
					(setq Loop 	nil)
					(setq LstNestedShape (append LstNestedShape (list (list (nth 3 Rtn) (nth 1 (nth ContaStock LstStock))))))
					(setq LstStock       (LM:RemoveNth ContaStock LstStock))
					(if (nth 0 Rtn) (setq LstStock (append LstStock (list (nth 0 Rtn)))))  	;--> DataScrap
					(if (nth 1 Rtn) (setq LstStock (append LstStock (list (nth 1 Rtn)))))  	;--> DataSheet
					(foreach itm (nth 2 Rtn)
						(setq LstStock (append LstStock (list itm)))  						;--> DataScrapRect
					)

					(if LstStock
						(setq LstStock (vl-sort LstStock (function (lambda (e1 e2) (< (* (car (car e1)) (cadr (car e1))) (* (car (car e2)) (cadr (car e2))))))))
					)
					(setq Shape nil)
				)
			)
			(setq ContaStock (1+ ContaStock))
		)
		
		; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
		(if Shape (setq LstShapeNotAlocated (append LstShapeNotAlocated (list Shape))))
	)
	;
	; Filter Stock
	;
	(foreach itm LstStock
		(setq LstSheet (append LstSheet (list itm)))
		;					xy			base			altezza
		;(MakeRectangle (cadr itm) (car (car itm)) (cadr (car itm)))
	)
	
	
	(list LstShapeNotAlocated LstSheet LstNestedShape)
)
;
;
;
(defun ReportNesting (DataNesting / itm itm1 AreaShapeNotAllocated AreaScrap AreaShapeAllocated
									SheetWidth SheetHeight SheetId OriginSheet TkSheet MatSheet 
									DataNesting LstShapeNotAllocated LstNewSheet LstNestedShape Sheet FileName Stream)

	(setq FileName (strcat (getenv "LOCALAPPDATA") "\\EasyCut\\NestingSimple.txt"))
	(setq Stream (open FileName "w"))
	
	(foreach itm DataNesting
		(setq SheetWidth 			(nth 0 itm))
		(setq SheetHeight 			(nth 1 itm))
		(setq SheetId 				(nth 2 itm))
		(setq OriginSheet 			(nth 3 itm))
		(setq TkSheet 				(nth 4 itm))
		(setq MatSheet 				(nth 5 itm))
		(setq LstShapeNotAllocated 	(nth 0 (nth 6 itm)))
		(setq LstNewSheet 			(nth 1 (nth 6 itm)))
		(setq LstNestedShape		(nth 2 (nth 6 itm)))
		(setq Sheet 				(list SheetWidth SheetHeight))

		; Sheet (1000.0 2500.0)
		; LstShapeNotAllocated ( (100 125 "123456") ....)
		; LstNewSheet		   ( ((1112 2534) (xori yori)) (....) )
		; LstNestedShape       ( ((1112 2534 "4566") (xori yori)) (....) )
	
		(princ "\n+---------------------------------------------------------------+" 								Stream)
		(princ "\n" 																								Stream)
		(princ (strcat "\nReport Nesting Sheet " SheetID " " (rtos (car Sheet) 2 0) "x" (rtos (cadr Sheet) 2 0))  	Stream)
		(princ "\n" 																								Stream)
		(princ "\n+---------------------------------------------------------------+" 								Stream)

		(if (and (null LstShapeNotAllocated) (null LstNestedShape))
			(progn
				(princ "\n"  								Stream)
				(princ "\n******* Nothing Nesting *******" 	Stream)
				(princ "\nList shape not allocated --> nil" Stream)
				(princ "\nList shape allocated     --> nil" Stream)
			)
			(progn
				(princ "\n" 						Stream)
				(princ "\nList shape not allocated" Stream)
				(setq AreaShapeNotAllocated 0.0)
				(if LstShapeNotAllocated
					(foreach itm1 LstShapeNotAllocated
						(princ (strcat "\nDimension " (LM:rtos (car itm1) 2 1) " x " (LM:rtos (cadr itm1) 2 1) " id " (caddr itm1)) Stream)
						(setq AreaShapeNotAllocated (+ AreaShapeNotAllocated (* (car itm1) (cadr itm1))))
					)
					(princ "\nComplete !" Stream)
				)
				; +++++++++++++++++++++++++++++++++++
				(princ "\n" 			Stream)
				(princ "\nList scrap" 	Stream)
				(setq AreaScrap 0.0)
				(if LstNewSheet
					(foreach itm1 LstNewSheet
						(princ (strcat "\nDimension " (LM:rtos (car (car itm1)) 2 1) " x " (LM:rtos (cadr (car itm1)) 2 1))  Stream)
						(setq AreaScrap (+ AreaScrap (* (car (car itm1)) (cadr (car itm1)))))
					)
					(princ "\nNo Scrap !" Stream)
				)
				; +++++++++++++++++++++++++++++++++++	
				(princ "\n" 					Stream)
				(princ "\nList shape allocated" Stream)
				(setq AreaShapeAllocated 0.0)
				(if LstNestedShape
					(foreach itm1 LstNestedShape
						(princ (strcat "\nDimension " (LM:rtos (car (car itm1)) 2 1) " x " (LM:rtos (cadr (car itm1)) 2 1) " id " (caddr (car itm1)))  Stream)
						(setq AreaShapeAllocated (+ AreaShapeAllocated (* (car (car itm1)) (cadr (car itm1)))))
					)
					(princ "\nNo Nested Shape !" Stream)
				)
				; +++++++++++++++++++++++++++++++++++
				(princ "\n" Stream)
				(princ (strcat "\nScrap               " (LM:rtos  (* (/ AreaScrap (* (car Sheet) (cadr Sheet))) 100.0) 2 3) "%") Stream)
				(princ (strcat "\nSheet used          " (LM:rtos  (* (- 1.0 (/ AreaScrap 		(* (car Sheet) (cadr Sheet)))) 100.0) 2 3) "%") Stream)
				(princ (strcat "\nShape not allocated " (LM:rtos  (* (/ AreaShapeNotAllocated   (+ AreaShapeNotAllocated AreaShapeAllocated)) 100.0) 2 3) "%") Stream)
				(princ (strcat "\nShape allocated     " (LM:rtos  (* (/ AreaShapeAllocated 	    (+ AreaShapeNotAllocated AreaShapeAllocated)) 100.0) 2 3) "%") Stream)
				(princ "\n" Stream)
			
			)
		)
	)
	(close Stream)
	(EasyCutViewer FileName)
)
;
;
;
(defun SselCopy+RotateShape (Ssel Pstart Pend PtRotation Rotation / itm TypeEname Id LstId CopyObj LstEname Rtn l)

	(if (and Ssel Pstart Pend)
		(progn
			(foreach itm (LM:ss->ent Ssel)
				(setq TypeEname (GetTypeShape itm))
				(cond 
					((or (= TypeEname 1) (= TypeEname 2))  
						(setq Id (GetIdShape itm))
					)
					((or (= TypeEname 3) (= TypeEname 4))  
						(setq Id (GetIdTrigger itm))
					)
					(t
						(alert "Errore Sslecopy")
						(exit)
					)
				)
				(if (not (assoc Id LstId)) (setq LstId (append LstId (list (list Id (Random_Str 9))))))
			)
			
			(foreach itm (LM:ss->ent Ssel)
			
				(setq CopyObj (vlax-ename->vla-object (entmakex (entget itm))))
				
				(vla-Move CopyObj   (vlax-3d-point (car Pstart) (cadr Pstart) 0.0)
									(vlax-3d-point (car Pend)   (cadr Pend) 0.0))
									
				(if (/= Rotation 0)	(vla-Rotate CopyObj PtRotation Rotation))
									
				(setq TypeEname (GetTypeShape itm))
				(cond 
					((or (= TypeEname 1) (= TypeEname 2))  
						(setq Id (GetIdShape itm))
					)
					((or (= TypeEname 3) (= TypeEname 4))  
						(setq Id (GetIdTrigger itm))
					)
				)
				(CloneEname itm (vlax-vla-object->ename CopyObj) (cadr (assoc Id LstId)))
				(setq LstEname (append LstEname (list (vlax-vla-object->ename CopyObj))))
			)
			
			(setq l nil)
			(foreach  EnameShape LstEname
					(setq l (cons (vlax-ename->vla-object EnameShape) l))
			)
			(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) (Random_Str 9)) 'appenditems l)
			
			(setq Rtn (LstEname->Ssget LstEname))
		)
	)
	Rtn
)
;
;
;
(defun PrintNestingSheet (DataNesting / itm itm1 SheetWidth SheetHeight SheetId OriginSheet TkSheet MatSheet 
										DataNesting LstShapeNotAllocated LstNewSheet LstNestedShape
										Shape IdShape Rotation OriginNewShape EnameShape OriginOldShape
										Ssel PtRotation)
	
	;
	; Grafica nesting +++
	;
	(ListId->EnameDelete)
	(ListId->EnameCreate)
	
	(foreach itm DataNesting
		(setq SheetWidth 			(nth 0 itm))
		(setq SheetHeight 			(nth 1 itm))
		(setq SheetId 				(nth 2 itm))
		(setq OriginSheet 			(nth 3 itm))
		(setq TkSheet 				(nth 4 itm))
		(setq MatSheet 				(nth 5 itm))
		(setq LstShapeNotAllocated 	(nth 0 (nth 6 itm)))
		(setq LstNewSheet 			(nth 1 (nth 6 itm)))
		(setq LstNestedShape		(nth 2 (nth 6 itm)))
		
	
		; LstNestedShape       ( ((1112 2534 "4566" rotazione) (xori yori)) (....) )
	
		(if LstNestedShape
			(foreach itm1 LstNestedShape
				
				(setq Shape       	 (list (car (car itm1)) (cadr (car itm1)))) 		;(princ " ok1 \n")
				(setq IdShape 		 (caddr (car itm1))) 								;(princ " ok2 \n")
				(setq Rotation		 (cadddr (car itm1))) 								;(princ " ok3 \n")
				(setq OriginNewShape (cadr itm1)) 										;(princ " ok4 \n")
				(setq EnameShape 	 (nth 0 (GetEnameById IdShape)))
			
				(setq PtRotation 	 (vlax-3d-point (+ (car OriginNewShape)  (/ (- (car Shape) $MargineAccosto) 2.0))
													(+ (cadr OriginNewShape) (/ (- (car Shape) $MargineAccosto) 2.0))
													0.0))
													
				(vla-getboundingbox  (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
				(setq OriginOldShape (vlax-safearray->list mnl))
				(setq Ssel (SelectShape EnameShape))
				(redraw)
				(setq Ssel (SselCopy+RotateShape Ssel OriginOldShape OriginNewShape PtRotation (/ (* Rotation PI) 180.0)))
			)
		)
	)
	(ListId->EnameDelete)
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
						
					
						; ordinamento per base ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

						(setq Chk1 (strcat Chk1 (CompleteString (rtos (car e1) 2 0) MaxRecordSort "0")))
						(setq Chk2 (strcat Chk2 (CompleteString (rtos (car e2) 2 0) MaxRecordSort "0")))

					
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
(defun SortTable (LstTable LstSequenceSort TypeSort / GetNthSequenceSort CompleteString
													  MaxRecordSort FillChr Ndec Arround itm Chk1 Chk2)

	(defun GetNthSequenceSort (LstSequenceSort / Num LstNth Rtn)
		;LstSequenceSort (0 1 2 3 0 0 0 0 0 0 0)
		(setq Num 0)
		(foreach itm LstSequenceSort
			(if (= itm 0)
				(setq LstNth (append LstNth (list (list Num (+ (length LstSequenceSort) 1)))))
				(setq LstNth (append LstNth (list (list Num  itm))))
			)
			(setq Num (1+ Num))
		)
		(foreach itm (vl-sort LstNth (function (lambda (e1 e2)  (< (cadr e1) (cadr e2)))))
			(if (/= (cadr itm) (+ (length LstSequenceSort) 1))
				(setq Rtn (append Rtn (list (car itm))))
			)
		)
		Rtn
	)
	;
	(defun CompleteString (String MaxChar FirstChar Char / Rtn)
		(if (and String MaxChar Char)
			(progn
				(if (< (strlen String) MaxChar)
					(progn
						(setq Rtn "")
						(repeat (- (- MaxChar 1) (strlen String))
								(setq Rtn (strcat Rtn Char))
						)
						(setq Rtn (strcat FirstChar Rtn String))
					)
					(setq Rtn String)
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq MaxRecordSort 30)
	(setq FillChr "0")
	(setq Ndec 5)
	(cond 
		((= Ndec 1) (setq Arround 0.1))
		((= Ndec 2) (setq Arround 0.01))
		((= Ndec 3) (setq Arround 0.001))
		((= Ndec 4) (setq Arround 0.0001))
		((= Ndec 5) (setq Arround 0.00001))
	)

	(if LstTable
		(setq LstTable 
			(vl-sort LstTable 
				(function 
					(lambda (e1 e2)
						(setq Chk1 "")
						(setq Chk2 "")
						
						(foreach itm (GetNthSequenceSort LstSequenceSort)
							
							(cond 
								((numberp (nth itm e1))
									(cond 
										((= (type (nth itm e1)) 'INT)
											(setq Chk1 (strcat Chk1 (CompleteString  (LM:rtos (nth itm e1) 2 Ndec) MaxRecordSort "0" FillChr)))
										)
										((= (type (nth itm e1)) 'REAL)
											(setq Chk1 (strcat Chk1 (CompleteString (LM:rtos (LM:roundm (nth itm e1) Arround) 2 Ndec) MaxRecordSort "0" FillChr)))
										)
									)
								)
								((numberp (read (nth itm e1)))
									(cond 
										((= (type (read (nth itm e1))) 'INT)
											(setq Chk1 (strcat Chk1 (CompleteString (LM:rtos (read (nth itm e1)) 2 Ndec) MaxRecordSort "0" FillChr)))
										)
										((= (type (read (nth itm e1))) 'REAL)
											(setq Chk1 (strcat Chk1 (CompleteString (LM:rtos (LM:roundm (read (nth itm e1)) Arround) 2 Ndec) MaxRecordSort  "0" FillChr)))
										)
									)
								)
								(t
									(setq Chk1 (strcat Chk1 (CompleteString (nth itm e1) MaxRecordSort  "1" FillChr)))
								)
							)
							(cond 
								((numberp (nth itm e2))
									(cond
										((= (type (nth itm e2)) 'INT)
											(setq Chk2 (strcat Chk2 (CompleteString (LM:rtos (nth itm e2) 2 Ndec) MaxRecordSort  "0" FillChr)))
										)
										((= (type (nth itm e2)) 'REAL)
											(setq Chk2 (strcat Chk2 (CompleteString (LM:rtos (LM:roundm (nth itm e2) Arround) 2 Ndec) MaxRecordSort  "0" FillChr)))
										)
									)
								)
								((numberp (read (nth itm e2)))
									(cond 
										((= (type (read (nth itm e2))) 'INT)
											(setq Chk2 (strcat Chk2 (CompleteString (LM:rtos (read (nth itm e2)) 2 Ndec) MaxRecordSort "0" FillChr)))
										)
										((= (type (read (nth itm e2))) 'REAL)
											(setq Chk2 (strcat Chk2 (CompleteString (LM:rtos (LM:roundm (read (nth itm e2)) Arround) 2 Ndec) MaxRecordSort  "0" FillChr)))
										)
									)
								)
								(t
									(setq Chk2 (strcat Chk2 (CompleteString (nth itm e2) MaxRecordSort  "1" FillChr)))
								)
							)
						)
						;(princ Chk1) (terpri)
						;(princ Chk2) (terpri)
						(if (= TypeSort ">")
							(> Chk1 Chk2)
							(< Chk1 Chk2)
						)
					)
				)
			)
		)
	)
)
;
;
;
(defun GetTableStockShapeNesting (/ LstInfoTable LstTmp Rtn itm itm1)

	; ("026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2" "20/12/2018")
	;
	(setq LstInfoTable (list "IDSHAPE" "ORDERSHAPE" "PHASESHAPE" "MKSHAPE" "QTASHAPE" "TKSHAPE" "LENGTHSHAPE" "HEIGHTSHAPE" "MATSHAPE" "LASTMODIFYSHAPE" "JOUSHAPE"))
	
	(foreach itm (GetLstBlockBomShapeByRgp $RgpShapeTarget NameBlockShape$)
	
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
	(SortTable Rtn '(0 1 2 0 4 3 0 0 0 0 0 0 0 0 0 0) "<")
)
;
;
;
(defun GetTableStockSheetNesting (Flag / LstNameSheet itm  Rtn)

	;
	; Flag 	1-> Void 	2-> Fill 	3-> Void+Fill 
	;
	;(IdSheet 		NameSheet 		Widthsheet 	HeightSheet  ThickSheet  SurfaceSheet  WeightSheet  MatSheet)
	;("072488826" 	"STK_GGGG_2" 	"2500" 		"5000" 		 "20" 		 "12.5" 	   "1962.5" 	"dddd")
	;
	;
	;
	(cond 
		((= Flag 1)
			(foreach itm (GetNameStockSheet)
				(if (null (GetEnameShapeByEnameSheet itm "CE+CI"))
					(setq LstNameSheet (cons itm LstNameSheet))
				)
			)
		)
		((= Flag 2)
			(foreach itm (GetNameStockSheet)
				(if (GetEnameShapeByEnameSheet itm "CE+CI")
					(setq LstNameSheet (cons itm LstNameSheet))
				)
			)
		)
		((= Flag 3)
			(setq LstNameSheet (GetNameStockSheet))
		)
	)
	

	;(foreach itm LstNameSheet
	;	(if $TorchFilter$	
	;		(if (> (atoi $TorchFilter$) 1)
	;			(if (IsRectangle itm)
	;				;IdSheet NameSheet Widthsheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet	
	;				(setq Rtn (append Rtn (list (GetDataSheetByEname itm))))
	;				
	;			)
	;			(setq Rtn (append Rtn (list (GetDataSheetByEname itm))))
	;		)
	;	)
	;)
	(foreach itm LstNameSheet
		(setq Rtn (append Rtn (list (GetDataSheetByEname itm))))
	)
	
	;(if (not $TorchFilter$)
	;	(alert "Selezionare prima i contorni")
		(SortTable Rtn '(0 2 0 0 1 0 0 0) "<")
	;)
	
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
(defun GetNameStockSheet (/ LstEname Rtn)
		
	(setq LstEname (GetEnameSheet))
	(setq Rtn LstEname)
	Rtn
)
;
;
;
(defun VoidStockListSheet (/ LstStockSheet itm Rtn)
	
	(setq LstStockSheet (GetNameStockSheet))
	(foreach itm LstStockSheet
		;(if (null (GetEnameShapeByEnameSheet (GetEnameSheetByName itm) "*"))
		(if (null (GetEnameShapeByEnameSheet itm "CE+CI"))
			(setq Rtn (append Rtn (list itm)))
		)
	)
	Rtn
)
;
;
;
(defun ListNesting (TypeP LstDataNesting LstKey / conta FileOut Stream itm tm1 SplitLstDataDstv)
	
	;(princ LstDataDst)
	(setq Sep $DivideCsv)
	(if (and TypeP LstDataNesting LstKey)
		(progn
			(setq conta 1)
			(setq FileOut 	(strcat HtmlStorageEasyCut$ ECFolderShapePreview$ "list.txt"))
			(setq Stream 	(open FileOut "w"))
			(cond
				((= TypeP "SHAPE")
					
					;(princ (strcat "Prg" 	Sep 
					;			   "Id"  	Sep 
					;			   "Order"	Sep 
					;			   "Phase" 	Sep 
					;			   "Mark" 	Sep 
					;			   "Qta" 	Sep 
					;			   "Thik" 	Sep 
					;			   "Length"	Sep
					;			   "Height"	Sep
					;			   "Mat\n") Stream)
					(write-line (LM:lst->str LstKey Sep) Stream)
					(foreach itm LstDataNesting
						(write-line (LM:lst->str itm Sep) Stream)
					)
					;(foreach itm LstDataNesting
					;	(foreach itm1 itm
					;		(princ (strcat itm1 Sep) Stream)
					;	)
					;	(princ "\n" Stream)
					;)
					(close Stream)
				)
				((= TypeP "SHEET")
					;(princ (strcat "Prg"		Sep
					;				"Id"		Sep
					;				"Stok"		Sep
					;				"Width" 	Sep
					;				"Length" 	Sep
					;				"Thik" 		Sep
					;				"Surface" 	Sep
					;				"Weight"	Sep
					;				"Mat\n") 	Stream)
					;(foreach itm LstDataNesting
					;	(foreach itm1 itm
					;		(princ (strcat itm1 Sep) Stream)
					;	)
					;	(princ "\n" Stream)
					;)
					(write-line (LM:lst->str LstKey Sep) Stream)
					(foreach itm LstDataNesting
						(write-line (LM:lst->str itm Sep) Stream)
					)
					(close Stream)
				)
			)
			(close Stream)
			(ViewHtmlPage01 FileOut  (strcat TypeP " List") Sep)
			(vl-file-delete  FileOut)
		)	
	)
)
;
;
;
(defun DxfOutShape (Ssel FileNameDxf / Go StartPt EndPt LstObject itm NewSsel Rtn)

	(if (and Ssel FileNameDxf)
		(progn
			(setq Go T)
			(if (findfile FileNameDxf)
				(if (not (vl-file-delete FileNameDxf))
					(progn
						(setq Go nil)
						(setq Rtn 1)
						;(princ (strcat "\n Problem to deleted File " FileNameDxf))
					)
					(setq Rtn 2)
					;(princ (strcat "\n Deleted File " FileNameDxf))
				)
			)
			(if Go
				(progn 
					(setq StartPt (vlax-3d-point (car (LM:SSBoundingBox Ssel))))
					(setq EndPt   (vlax-3d-point (list 0.0 0.0)))
					(foreach itm  (LM:ss->ent Ssel)
						(setq LstObject (append LstObject (list (vla-Copy (vlax-ename->vla-object itm)))))
					)
					(setq NewSsel (ssadd))

					(foreach itm LstObject
						(vla-Move itm StartPt EndPt)
						(if (= (cdr (assoc 0 (entget (vlax-vla-object->ename itm)))) "LWPOLYLINE") 
							(SimpleLwPolyLine (vlax-vla-object->ename itm) nil)
						)
						(ssadd (vlax-vla-object->ename itm) NewSsel)
					)
					
					(command "_DxfOut" FileNameDxf "_Objects" NewSsel "" "_Version" "2007" "16")
					;(princ (strcat "\n Create File " FileNameDxf))
					(foreach itm LstObject
						(vla-Delete itm)
					)
					(setq Rtn 3)
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun CloneShapeOnSheet (CodeMessageOnSheet / IdGroup MatrixOri LstEnameShape itm Ename LstEname Rtn)
	
	; (<Entity name: 1e9631dfec0> "890474931" "C" (12886.8 107326.0) (12883.0 107326.0) (12886.8 107326.0))
	
	(if CodeMessageOnSheet
		(progn
			(setq IdGroup        (cadr CodeMessageOnSheet))
			;(setq MatrixOri     (GetMatrixShape (strcat SetupPathEasyCut$ "Tmp\\" IdGroup ".out")))
			;(setq LstEnameShape (Genames IdGroup))
			(if (setq LstEnameShape (GetShapeByGroup IdGroup))
				(if (setq MatrixOri (PutPosLineMessageShape (car LstEnameShape)))
					(progn
						(foreach itm LstEnameShape
							(setq Ename (AlignObject 	itm
														;(cdr itm)
														(car MatrixOri)
														(cadr MatrixOri)
														(caddr MatrixOri) 
														(nth 3 CodeMessageOnSheet)
														(nth 4 CodeMessageOnSheet)
														(nth 5 CodeMessageOnSheet)
														T))
							(setq LstEname (append LstEname (list Ename)))
						)
						(setq Rtn (CloneShape LstEname))
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
(defun GetMatrixShape (FileInfo / Stream Line P1G P2G P3G Rtn)

	(if FileInfo
		(progn
			(setq Stream (open FileInfo "r"))
			(if Stream
				(progn
					(setq Line (LM:str->lst (read-line Stream) " "))
					(setq P1G (list (atof (car Line)) (atof (cadr Line)) (atof (caddr Line))))
					(setq Line (LM:str->lst (read-line Stream) " "))
					(setq P2G (list (atof (car Line)) (atof (cadr Line)) (atof (caddr Line))))
					(setq Line (LM:str->lst (read-line Stream) " "))
					(setq P3G (list (atof (car Line)) (atof (cadr Line)) (atof (caddr Line))))
					(setq Rtn (list P1G P2G P3G))
					(close Stream)
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun PutMatrixShape (FileInfo P1G P2G P3G / Stream)

	(if (and FileInfo P1G P2G P3G)
		(progn
			(setq Stream (open FileInfo "w"))
			(if Stream
				(progn
					(princ (strcat (LM:rtos (car P1G) 2 5) " " (LM:rtos (cadr P1G) 2 5) " " (LM:rtos (caddr P1G) 2 5) "\n") Stream)
					(princ (strcat (LM:rtos (car P2G) 2 5) " " (LM:rtos (cadr P2G) 2 5) " " (LM:rtos (caddr P2G) 2 5) "\n") Stream)
					(princ (strcat (LM:rtos (car P3G) 2 5) " " (LM:rtos (cadr P3G) 2 5) " " (LM:rtos (caddr P3G) 2 5) "\n") Stream)
				)
				(princ (strcat "\nImpossibile aprire il file " FileInfo))
			)
			(close Stream)
		)
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

	(setq DistCatch (+ (/ $MargineAccosto 2.0) 10.0))
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
                            (if (vl-some '(lambda ( p ) (or (equal (car v) p 1e-6) (equal (cadr v) p 1e-6))) l1)
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
		(sssetfirst nil s2)
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
(defun WriteFileNesting (TypeP LstData FileOut Sep NumberTorch / itm Stream Tch)

	(if FileOut
		(if (findfile FileOut)
			(if (not (vl-file-delete FileOut))
				(progn
					(alert (strcat "Problema nella cancellazione del file " FileOut))
					(exit)
				)
			)
		)
	)
	(if (setq Stream (open FileOut "w"))
		(cond
			((= TypeP "SHAPE")
				(write-line (strcat "Prg"		Sep 
									"Id"		Sep
									"Order"		Sep
									"Phase"		Sep
									"Mark"		Sep
									"Qta"		Sep
									"Thik"		Sep
									"Length"	Sep
									"Height"	Sep
									"Mat"		Sep
									"n.torch"
								)
							   Stream
				)
			)
			((= TypeP "SHEET")
				(write-line (strcat "Prg"		Sep
									"Id"		Sep
									"Stok"		Sep
									"Width"		Sep
									"Length"	Sep
									"Thik"		Sep
									"Surface"	Sep
									"Weight"	Sep
									"Mat"
									;"n.torch"
							   )
							   Stream
				)
			)
		)
		(progn
			(alert (strcat "Problema nella creazione del file " FileOut))
			(exit)
		)
	)

	(cond
		((= TypeP "SHAPE")
			;(if (= $ActiveFilterTorch$ "1")
			;	(setq Tch $TorchFilter$)
			;	(setq Tch "1")
			;)							
			(foreach itm LstData
				; 0		  1			2	  3		  4	     5	 6	  7	      8		9
				;"2" "516645398" "C872" "300" "178-370" "2" "1" "277.5" "290" "S355J0"
				;itm     id       comm   fase    mk     qta  sp   lung   larg    qua
				(write-line (strcat (LM:lst->str itm ";") ";" (Lm:rtos NumberTorch 2 0)) Stream)
			)
			(close Stream)
		)
		((= TypeP "SHEET")
			;(if (= $ActiveFilterTorch$ "1")
			;	(setq Tch $TorchFilter$)
			;	(setq Tch "1")
			;)							
			(foreach itm LstData
				; 0        1          2         3      4    5     6       7        8
				;"2" "162504882" "STK_GGG_2" "2500" "5000" "10" "12.5" "981.25" "S355J0"
				;itm      id        nome      larg   lung   sp    mq     peso     qua
				(write-line (strcat (LM:lst->str itm ";")) Stream)
			)
			(close Stream)
		)
	)
)
;
;
;
(defun ReadFileNesting (FileIn Sep / Stream Line SplitLine Rtn)

	(if FileIn
		(if (/= FileIn "")
			(if (findfile FileIn)
				(progn
					(setq Stream (open FileIn "r"))
					(if Stream
						(progn
							(setq Line (read-line Stream))
							(while Line
								(if (/= (setq Line (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))) "")
									(progn
										(setq SplitLine	(SpliTxt Line Sep))
										(setq Rtn (append Rtn (list SplitLine)))
									)
								)
								(setq Line (read-line Stream))
							)
							(close Stream)
						)
						(alert (strcat "Problema lettura del file " FileIn))
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
(defun test ()
	(setq ename (car (entsel)))
	
	(setq aa (PutPosLineMessageShape ename))
	(PutLineMessageShape Ename "O" aa)
)
;(setq LstCodeLine (GetLineMessageShape (ssget)))
;
;
(defun GetFileInfoShape (FileInfo / Stream Jou Line LineSplit LstCo)

	(if FileInfo
		(progn
			(setq Stream (open FileInfo "r"))
			(if Stream
				(progn
					(setq Line (read-line Stream))
					(while Line
						(setq LineSplit (splitxt Line " "))
						(if (/= (nth 0 LineSplit) "")
							(setq LstCo (append LstCo (list (list (atof (car LineSplit)) (atof (cadr LineSplit)) (atof (caddr LineSplit))))))
						)
						(setq Line (read-line Stream))
					)
					(close Stream)
				)
			)
		)
	)
	(list LstCo)
)
;
;
;
(defun PutFileInfoShape (FileInfo EnameShape P1G P2G P3G / FileInfo Co CosDir Stream itm Plocal)

		(if (and FileInfo EnameShape P1G P2G P3G)
			(progn
				;(setq Co (DiscretizeShape EnameShape))
				(setq Co (DiscretizeShapeNoControl EnameShape))
				
				(setq CosDir (DefPiano (car P1G) (cadr P1G) 0.0 (car P2G) (cadr P2G) 0.0 (car P3G) (cadr P3G) 0.0))
				(setq Stream (open FileInfo "w"))
				(if Stream
					(progn
						(foreach itm Co
							(setq Plocal (TransL (car itm) (cadr itm) 0.0 CosDir))
							(princ (strcat (LM:rtos (car Plocal) 2 2) " " (LM:rtos (cadr Plocal) 2 2) " " (LM:rtos (caddr Plocal) 2 2) "\n") Stream)
						)
					)
					(princ (strcat "\nImpossibile aprire il file " FileInfo))
				)
				(close Stream)
			)
		)
)
;
;(setq LstCodeLine (GetLineMessageShape Ssel))
;
(defun GetShapeNestProfessor (NameFile LstCodeLine / MargXZoom MargYZoom Conta
													FileName Stream Error itm
													TypeP IdShape Pt1 Pt2 Pt3 Alfa MaxMin 
													InfoShape LstX LstY 
													MinX MinY MaxX MaxY CosDir 
													P1g P2g P3g P4g SelCheK
													RtnSel EnameShape RtnOffset	Ssel RefShape Rtn)
											
							
	
	;(("O/A/L" "927897745" (28269.5 19405.0) Angle (MinX MinY MaxX MaxY) ) 
	; ("O/A/L" "927897745" (27114.5 19395.0) Angle (MinX MinY MaxX MaxY) ))
	
	;	O = shapa controno orario
	;	A = shape contorno antiorario
	;   L = lamiera
	
	(setq MargXZoom 100.0)
	(setq MargYZoom 100.0)
	(setq Conta 1)
	;
	;
	;
	(if LstCodeLine
		(progn
			(setq FileName (vl-filename-mktemp))
			(setq Stream (open FileName "w"))
			(setq Error nil)
			(princ "\n")
			
			(StartProgressBar "Trattamento Contorni:" (length LstCodeLine))
			(foreach itm LstCodeLine
				
				(UpDateProgressBar)
				
				(setq TypeP	 		(nth 0 itm))
				(setq IdShape 		(nth 1 itm)
				      Pt1			(nth 2 itm)
				      Alfa			(nth 3 itm)
				      MaxMin 		(nth 4 itm)
				      Pt2			(polar Pt1 Alfa 1.0)
				)
				
				(cond
					((= TypeP "O")
						(setq Pt3 (per (car Pt2) (cadr Pt2) (car Pt1) (cadr Pt1) (*  1.0 1.0)))
					)
					((= TypeP "A")
						(setq Pt3 (per (car Pt2) (cadr Pt2) (car Pt1) (cadr Pt1) (* -1.0 1.0)))
					)
				)
				
				(setq InfoShape (GetFileInfoShape (strcat SetupPathEasyCut$ "Tmp\\" IdShape ".out")))
				
				
				

				(setq LstX nil LstY nil)
				(foreach itm (car InfoShape)
						(setq LstX (append LstX (list (car itm))))
						(setq LstY (append LstY (list (cadr itm))))
				)
				(setq MinX (- (apply 'min LstX) MargXZoom)
				      MinY (- (apply 'min LstY) MargYZoom)
				      MaxX (+ (apply 'max LstX) MargXZoom)
				      MaxY (+ (apply 'max LstY) MargYZoom)
				)				

				(setq CosDir (DefPiano (car Pt1) (cadr Pt1) 0.0 (car Pt2) (cadr Pt2) 0.0 (car Pt3) (cadr Pt3) 0.0))
				(setq P1g (TransG MinX MinY 0.0 CosDir)
				      P2g (TransG MaxX MinY 0.0 CosDir) 
				      P3g (TransG MaxX MaxY 0.0 CosDir) 
			          P4g (TransG MinX MaxY 0.0 CosDir)
				) 
				
				(ZoomWindow01 	(list   (min (nth 0 P1g) (nth 0 P2g) (nth 0 P3g) (nth 0 P4g))
										(min (nth 1 P1g) (nth 1 P2g) (nth 1 P3g) (nth 1 P4g)))
								(list   (max (nth 0 P1g) (nth 0 P2g) (nth 0 P3g) (nth 0 P4g))
										(max (nth 1 P1g) (nth 1 P2g) (nth 1 P3g) (nth 1 P4g))))
										
				(princ (strcat "\r" NameFile " Trattamento Shape [" (rtos Conta 2 0) "/" (rtos (length LstCodeLine) 2 0) "] Id " IdShape))
				(setq Conta (1+ Conta))
				
 				;(command "_line" P1g P2g P3g P4g P1g "")
				(setq SelCheK (ssget "_CP" (list P1g P2g P3g P4g) '((-4 . "<OR") (0 . "Arc") (0 . "Line") (-4 . "OR>"))))
				(if SelCheK
					(progn
						(setq RtnSel 		(MyBoundary Pt1 SelCheK))
						(setq EnameShape	(ForceShapeToPolyline RtnSel))
						(if EnameShape
							(progn
								
								(setq RtnOffset  (OffsetShape (car EnameShape) (- 0.0 (abs (/ $MargineAccosto 2.0)))))
								;(setq RtnOffset (GeneralOffset (car EnameShape) (- 0.0 (abs (/ $MargineAccosto 2.0)))))
								
								(if RtnOffset
									(progn
										(setq RtnOffset  (PurgePolyline RtnOffset))
										;(setq Ssel (ssget "_CP" (DiscretizeShape RtnOffset) '((-4 . "<OR") (0 . "Arc") (0 . "Line") (-4 . "OR>"))))
										(setq Ssel (ssget "_CP" (DiscretizeShapeNoControl RtnOffset) '((-4 . "<OR") (0 . "Arc") (0 . "Line") (-4 . "OR>"))))
										(entdel (car EnameShape))
										(ForceShapeToPolyline Ssel)
										(setq RefShape (GetEnameById IdShape))
										
										(if (car RefShape)
											(setq Rtn 	(append Rtn (list (AssignNameShape RtnOffset (list 	(GetNameShape  (car RefShape)) 		;nome piatto
																											(GetCutShape   (car RefShape)) 		;compensazione taglio
																											(GetComShape   (car RefShape)) 		;nome commessa
																											(GetPhaseShape (car RefShape)) 		;nome fase
																											(GetMatShape   (car RefShape)) 		;nome qualita
																											(GetTkShape    (car RefShape)) 		;spessore
																											(Today)								;ultima modifica
																											(GetQtaShape   (car RefShape)))) 	;quantita
																	)
														)
											)
											(progn
												(setq Error T)
												(princ (strcat "Non trovo la corrispondenza del contorno id " IdShape "\n") Stream)
											)
										)
										(princ " Ok")
									)
									(princ " Errore")
								)
							)
						)
					)
				)
			)
			(ClearProgressBar)
		)
	)
	(close Stream)
	(if Error
		(EasyCutViewer FileName)
		Rtn
	)
)
;
;
;
(defun GetTableStockDeductShapeNesting (/ itm itm1 LstEnameSheet LstShapeOnSheet LstMarkOnSheet Mark Qty NewQty
										  TableShapeonSheet TableShape LstAssoc LstExtend
										  SplitItm Order Phase Rtn)

	;("026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2" "20/12/2018")

	(foreach itm (GetLstBlockBomSheetByRgp)
		(setq LstEnameSheet (cons (GetEnameSheetById (LM:vl-getattributevalue (vlax-ename->vla-object itm) "ID_SHEET")) LstEnameSheet))
	)
	(setq LstShapeOnSheet (FindShapeOnSheet LstEnameSheet "<>" "<>" "<>"))
	;	(	(<Entity name Sheet> ("C000H|2|1152" <Entity name Shape> <Entity name Shape>)  ("C000H|2|XXX" <....>))
	;		(<Entity name Sheet> ("C000H|2|1153" <Entity name Shape> <Entity name Shape>)  ("C000H|2|XXX" <....>))
	;	)
	;
	; grouping quantity mark on sheet ++++++
	;
	(foreach itm LstShapeOnSheet
		(setq LstMarkOnSheet (cdr itm))
		(foreach itm1 LstMarkOnSheet
			(setq Mark (car itm1))
			(setq Qty  (- (length itm1) 1))
			(if (assoc Mark TableShapeonSheet)
				(setq TableShapeonSheet (subst (list Mark (+ (cadr (assoc Mark TableShapeonSheet)) Qty))
											   (assoc Mark TableShapeonSheet)
											   TableShapeonSheet
										))
				(setq TableShapeonSheet (cons (list Mark Qty) TableShapeonSheet))
			)
		)
	)
	;	(	("C000H|2|1152" 28)
	;		("C000H|2|1153" 11)
	;	)
	(setq TableShape (GetTableStockShapeNesting))
	;	(	("026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2" "20/12/2018")
	;		("026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2" "20/12/2018")
	;	)
	(foreach itm TableShape
		(setq LstAssoc (append LstAssoc (list (list (strcat (nth 1 itm) "|" (nth 2 itm) "|" (nth 3 itm)) (atoi (nth 4 itm))))))
	)
	(foreach itm LstAssoc
		(repeat (cadr itm)
			(setq LstExtend (cons (car itm) LstExtend))
		)
	)
	(setq LstAssoc (LM:CountItems LstExtend))
	
	(foreach itm TableShapeonSheet
		;(princ itm) (terpri)
		(setq SplitItm (Splitxt (car itm) "|"))
		(setq Order (car SplitItm))
		(setq Phase (cadr SplitItm))
		(setq Mark  (caddr SplitItm))
		(setq Qty   (cadr itm))
		
		(foreach itm1 TableShape
			;(princ itm1) (terpri)
			(if (and (= (nth 1 itm1) Order)
					 (= (nth 2 itm1) Phase)
					 (= (nth 3 itm1) Mark)
					 (> Qty 0))
				(progn
					(setq NewQty (- (atoi (nth 4 itm1)) Qty))
					(if (< NewQty 0)
						(progn 
							(setq NewQty 0)
							(setq Qty (- Qty (atoi (nth 4 itm1))))
						)
						(setq Qty 0)
					)
					(setq TableShape (subst (list 	(nth 0 itm1) ;"026611999"
													(nth 1 itm1) ;"C872"
													(nth 2 itm1) ;"100"
													(nth 3 itm1) ;"011124"
													(LM:rtos NewQty 2 0)
													(nth 5 itm1) ;"15"
													(nth 6 itm1) ;"1183.5"
													(nth 7 itm1) ;"1540"
													(nth 8 itm1) ;"S355J2"
													(nth 9 itm1) ;"20/12/2018"
											)
											itm1
											TableShape))
				)
			)
		)
		;(princ "\nEntro popup")
		;(if (and (> Qty 0) LstAssoc)
		;	(LM:popup "Errore" 
		;			  (strcat "\nControllo quantita'\n\nCommessa " Order " Fase "  Phase " Marca " Mark 
		;				"\n\nPezzi in lamiera n. "  (LM:rtos (cadr itm) 2 0)
		;				"\n\nPezzi disponibili n. " (LM:rtos (cadr (assoc (car itm) LstAssoc)) 2 0)
		;			   ) 
		;			   (+ 0 16 4096)
		;	)
		;)
		;(princ "\nEsco popup")

	)
	(foreach itm TableShape (if (/= (nth 4 itm) "0") (setq Rtn (append Rtn (list itm)))))
	Rtn
)
;
;
;
(defun GuiMergeNesting (/ MakeButtons UpDateButtons MakeListShape MakeListSheet RestoreFile BoxToList 
						  ListToBox LoadTable SortBox UpdateBoxList
						  AlertShape$ 
						  AlertSheet$						  
						  LstButtonShapeKey LstButtonSheetKey LstSortShape LstSortSheet
						  xx FileSaveShape FileSaveSheet LstBoxShape LstBoxSheet Merge itm)
	;
	;
	(defun MakeButtons (LstButtonKey LstStatusButton / XVect YVect Num Key XKey YKey XMKey YMKey X Y)
		
		(setq XVect (list (list -6 6 0)
						  (list -6 6 0)
					))
		(setq YVect (list (list -2 -2 2)
						  (list 2 2 -2)
					))
		(setq Num 0)
		(foreach Key LstButtonKey
			(setq XKey  (dimx_tile Key))
			(setq YKey  (dimy_tile Key))
			(setq XMKey (/ (dimx_tile Key) 2))
			(setq YMKey (/ (dimy_tile Key) 2))
			(start_image Key) 

			(if (> Num 0)
				(fill_image 0 0 XKey YKey -15)
			)
			
			(cond 
				((= (nth Num LstStatusButton) 1)
					(setq X (nth 0 XVect))
					(setq Y (nth 0 YVect))
				)	
				((= (nth Num LstStatusButton) -1)
					(setq X (nth 1 XVect))
					(setq Y (nth 1 YVect))
				)	
			)
			(if (and X Y)
				(progn
					(vector_image (+ XMKey (nth 0 X)) (+ YMKey (nth 0 Y)) (+ XMKey (nth 1 X)) (+ YMKey (nth 1 Y)) 250)
					(vector_image (+ XMKey (nth 1 X)) (+ YMKey (nth 1 Y)) (+ XMKey (nth 2 X)) (+ YMKey (nth 2 Y)) 250)
					(vector_image (+ XMKey (nth 2 X)) (+ YMKey (nth 2 Y)) (+ XMKey (nth 0 X)) (+ YMKey (nth 0 Y)) 250)
				)
			)
			(end_image)
			(setq Num (1+ Num))
			(setq X nil) (setq Y nil)
		)
	)
	;
	(defun UpDateButtons (Key LstButtonKey LstStatusButton / NthVal Num Rtn)
		(if (and Key LstStatusButton LstButtonKey)
			(progn
				(setq NthVal (GetNth LstButtonKey Key))
				(cond
					((= (nth NthVal LstStatusButton) 0)
						(setq Rtn (LM:SubstNth 1 NthVal LstStatusButton))
					)
					((= (nth NthVal LstStatusButton) 1)
						(setq Rtn (LM:SubstNth -1 NthVal LstStatusButton))
					)
					((= (nth NthVal LstStatusButton) -1)
						(setq Rtn (LM:SubstNth 1 NthVal LstStatusButton))
					)
				)
				(setq Num 0)
				(repeat (length LstStatusButton)
					(if (/= Num NthVal) (setq Rtn (LM:SubstNth 0 Num Rtn)))
					(setq Num (1+ Num))
				)
				(MakeButtons LstButtonKey Rtn)
			)
		)
		Rtn
	)
	;
	(defun MakeListShape (FileShape / EnameShape Pr itm LstIdShapeFromBom Rtn)
		
		(setq Pr 1)
		(setq AlertShape$ nil)
		(if FileShape
			(if (setq LstShape (ReadFileNesting FileShape ";"))
				;Prg Id Order Phase Mark Qta Thik Length Height Mat n.torch
				;1 782139489 C792 1 1252 2 33 550 410 S355J2W 1
				(progn
					(foreach itm (GetLstBlockBomShapeByRgp $RgpShapeTarget NameBlockShape$)
						(setq LstIdShapeFromBom (append LstIdShapeFromBom (list (LM:vl-getattributevalue (vlax-ename->vla-object itm) "IDSHAPE"))))
					)
				
					(foreach itm (cdr LstShape)
						(if (member (cadr itm) LstIdShapeFromBom)
							(setq Rtn (append Rtn (list (list 	(LM:rtos Pr 2 0)
																(nth 1 itm)		;Id
																(nth 2 itm)		;Order
																(nth 3 itm)		;Phase
																(nth 4 itm)		;Mark
																(nth 5 itm)		;Qta
																(nth 6 itm)		;Tk
																"OK"))))
							(setq Rtn (append Rtn (list (list 	(LM:rtos Pr 2 0)
																(nth 1 itm)		;Id
																(nth 2 itm)		;Order
																(nth 3 itm)		;Phase
																(nth 4 itm)		;Mark
																(nth 5 itm)		;Qta
																(nth 6 itm)		;Tk
																"NO")))
								AlertShape$ T
							)
						)
						(setq Pr (1+ Pr))
					)
				)
			)
			(setq Rtn (SortTable Rtn '(0 0 1 2 4 0 3 0) "<"))
		)
		Rtn
	)
	;
	(defun MakeListSheet (FileSheet / EnameSheet itm Pr LstIdSheetFromBom Rtn)
		
		(setq AlertSheet$ nil)
		(setq Pr 1)
		(if FileSheet
			(if (setq LstSheet (ReadFileNesting FileSheet ";"))
				;Prg Id Stok Width Length Thik Surface Weight Mat n.torch
				;2 02544 STK_GGG_02 2500 5000 10 12.5 981.25 FF 1
				(progn
					(foreach itm (GetLstBlockBomSheetByRgp)
						(setq LstIdSheetFromBom (append LstIdSheetFromBom (list (LM:vl-getattributevalue (vlax-ename->vla-object itm) "ID_SHEET"))))
					)
				
					(foreach itm (cdr LstSheet)
						(if (member (cadr itm) LstIdSheetFromBom)
							(setq Rtn (append Rtn (list (list  	(LM:rtos Pr 2 0)
																(nth 1 itm)		;Id
																(nth 2 itm)		;Stock
																(nth 3 itm)		;Width
																(nth 4 itm)		;Length
																(nth 5 itm)		;Thik
																"OK"))))
							(setq Rtn (append Rtn (list (list  	(LM:rtos Pr 2 0)
																(nth 1 itm)		;Id
																(nth 2 itm)		;Stock
																(nth 3 itm)		;Width
																(nth 4 itm)		;Length
																(nth 5 itm)		;Thik
																"NO")))
								  AlertSheet$ T

							)
						)
						(setq Pr (1+ Pr))
					)
				)
				(setq Rtn (SortTable Rtn '(0 0 2 3 4 1 0) "<"))
			)
		)
		Rtn
	)
	;
	(defun RestoreFile (Type Key Ext / Rtn)
	
		(cond 
			((= Type "SHAPE")
				(setq Rtn (OpenFileDialog  (list DxfNestingEasyCut$ nil "*.shp|*.*" "Seleziona file Shape" nil T)))
			)
			((= Type "SHEET")
				(setq Rtn (OpenFileDialog  (list DxfNestingEasyCut$ nil "*.sht|*.*" "Seleziona file Sheet" nil T)))
			)
		)
		;(setq Rtn (LM:getfiles "Seleziona file Sheet" DxfNestingEasyCut$ Ext))
		(if Rtn 
			(set_tile  Key	(strcat (car Rtn) "\\" (cadr Rtn))) 
			(set_tile  Key	"")
		)
		(if Rtn
			(strcat (car Rtn) "\\" (cadr Rtn))
			nil
		)
	)
	;
	(defun BoxToList (LstBox / itm Rtn)
		(foreach itm LstBox
			(setq Rtn (append Rtn (list (LM:str->lst itm "\t"))))
		)
	)
	;
	(defun ListToBox (LstBox / itm Rtn)
		(foreach itm LstBox
			(setq Rtn (append Rtn (list (LM:lst->str itm "\t"))))
		)
		Rtn
	)
	;
	(defun LoadTable (LstTable KeyBox)

		(if LstTable
			(progn
				(start_list KeyBox)
					(mapcar 'add_list LstTable)
				(end_list)
			)
		)
	)
	;
	(defun SortBox (LstTableNesting KeyBox LstSort / LstSort TypeSort Num itm Rtn Pos)

		(if (and LstTableNesting KeyBox LstSort)
			(progn
				(setq TypeSort ">")
				(setq Num 0)
				(foreach itm LstSort
					(if (= itm -1)
						(progn
							(setq TypeSort "<")
							(setq LstSort (LM:SubstNth 1 Num LstSort))
						)
					)
				)
				(setq Rtn (SortTable (BoxToList LstTableNesting) LstSort TypeSort))
				
				(setq Pos 1)
				(foreach itm Rtn
					(setq itm (LM:SubstNth (LM:rtos Pos 2 0) 0 itm))
					(setq Rtn (LM:SubstNth itm (1- Pos) Rtn))
					(setq Pos (1+ Pos))
				)
				(setq Rtn (ListToBox Rtn))
				(LoadTable Rtn KeyBox)
			)
		)
		Rtn
	)
	;
	(defun UpdateBoxList (KeyBox FileIn TypeEl / Lst Rtn)
		(if (and KeyBox FileIn)
			(if (findfile FileIn)
				(progn
					(cond 
						((= TypeEl "SHEET")
							(setq Lst  (MakeListSheet FileIn))
						)
						((= TypeEl "SHAPE")
							(setq Lst  (MakeListShape FileIn))
						)
					)
					(setq Rtn  (ListToBox Lst))
					(LoadTable Rtn KeyBox)
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq LstButtonShapeKey   '("BtShape1" "BtShape2" "BtShape3" "BtShape4" "BtShape5" "BtShape6" "BtShape7" "BtShape8"))
	(setq LstButtonSheetKey   '("BtSheet1" "BtSheet2" "BtSheet3" "BtSheet4" "BtSheet5" "BtSheet6" "BtSheet7"))
	(setq LstSortShape 	      '(0 0 0 0 0 0 0 0))
	(setq LstSortSheet 	      '(0 0 0 0 0 0 0))
	(setq AlertShape$ T)
	(setq AlertShape$ T)
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "MergeNestingDialog" xx "" (cond ( *GuiMergeNesting* ) ( '(-1 -1) )))

	(action_tile "SelectFileShape"	(vl-prin1-to-string '(if (setq FileSaveShape (RestoreFile   "SHAPE"    "FileSelectShape" "shp"))
															 (setq LstBoxShape   (UpdateBoxList "ListShape" FileSaveShape "SHAPE"))
															)))
	(action_tile "SelectFileSheet"	(vl-prin1-to-string '(if (setq FileSaveSheet (RestoreFile   "SHEET"    "FileSelectSheet" "sht"))
															 (setq LstBoxSheet   (UpdateBoxList "ListSheet" FileSaveSheet "SHEET"))
														 )))
											 
	(foreach itm (cdr LstButtonShapeKey)
		(action_tile itm (strcat "(setq LstSortShape (UpDateButtons \"" itm "\" LstButtonShapeKey LstSortShape))
								  (setq LstBoxShape  (SortBox LstBoxShape \"ListShape\" LstSortShape))"))
	)
	(foreach itm (cdr LstButtonSheetKey)
		(action_tile itm (strcat "(setq LstSortSheet (UpDateButtons \"" itm "\" LstButtonSheetKey LstSortSheet))
								  (setq LstBoxSheet  (SortBox LstBoxSheet \"ListSheet\" LstSortSheet))")) 
	)

	
	(action_tile "accept" 		(vl-prin1-to-string '(if (or AlertShape$ AlertSheet$)
														(LM:popup "Errore" "Contorni o lamiere non disponibili" (+ 0 16 4096))
														(progn
															(setq Merge T
																  FileSaveShape (get_tile "FileSelectShape")
																  FileSaveSheet (get_tile "FileSelectSheet")
																  *GuiMergeNesting* (done_dialog)
															)
															(unload_dialog xx)
														)
													)))
	(action_tile "cancel"		"(setq *GuiMergeNesting* (done_dialog)) (unload_dialog xx)")
	(start_dialog)
		
	(if Merge
		(list FileSaveShape FileSaveSheet)
		nil
	)
)
;
;
;
(defun MergeNesting (LstShape LstSheet / DataShape DataSheet SselShape ContaShape EnameShape LstEname->Id itm LstMarKShape
										 EnameSheet LstEnameSheet LstFindSheet Mark
										 MarkShape EnameShape QtaShape NewQtaShape LstMarKSheet NameReport)


	(if (and LstShape LstSheet)
		(progn

			; LstShape ---> Prg Id Order Phase Mark Qta Thik Length Height Mat n.torch
			; LstSheet ---> Prg Id Stok Width Length Thik Surface Weight Mat n.torch

			; ----------------------------------
			
			(foreach itm (LM:ss->ent (setq SselShape (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShape))))))
				(setq LstEname->Id (append LstEname->Id (list (list (cdr (nth 3  (nth 1 (assoc -3 (entget itm (list "*")))))) itm))))
			)
			; ( ("180137543" <Entity name: 321eb160>) ("487340199" <Entity name: 321eb150>) ....)
			
			(foreach  itm LstShape
				(if (setq EnameShape (cadr (assoc (cadr itm) LstEname->Id)))
					(setq LstMarKShape (append LstMarKShape (list (list (strcat (nth 2 itm) "|" (nth 3 itm) "|" (nth 4 itm)) EnameShape (* (atoi (nth 5 itm)) (atoi (nth 10 itm)))))))
				)
			)
			; ( ("123|456|789" EnameRef 10) ("123|456|111" EnameRef 8) ...... )
			; ----------------------------------
			(foreach itm LstSheet
				(if (setq EnameSheet (GetEnameSheetById (cadr itm)))
					(setq LstEnameSheet (append LstEnameSheet (list EnameSheet)))
				)
			)
			(setq LstFindSheet (FindShapeOnSheet LstEnameSheet "<>" "<>" "<>"))
			(setq xxx LstFindSheet)
			(foreach itm LstFindSheet
				(foreach Mark (cdr itm)
					
					; ( ("123|456|789" EnameRef 10) ("123|456|111" EnameRef 8) ...... )
					
					(if (assoc (car Mark) LstMarKSheet)
						(progn
							(setq MarkShape   (car   (assoc (car Mark) LstMarKSheet)))
							(setq EnameShape  (cadr  (assoc (car Mark) LstMarKSheet)))
							(setq QtaShape    (caddr (assoc (car Mark) LstMarKSheet)))
							(setq NewQtaShape (+ QtaShape (length (cdr Mark))))
							(setq LstMarKSheet (subst (list MarkShape EnameShape NewQtaShape)
													  (list MarkShape EnameShape QtaShape) LstMarKSheet))
						)
						(setq LstMarKSheet (append LstMarKSheet (list (list (car Mark) (car (cdr Mark)) (length (cdr Mark))))))
					)
				)
			)
		)
	)
	(if (and LstMarKShape LstMarKSheet)
		(progn
			(if (setq NameReport (ReportCheckNesting LstMarKShape LstMarKSheet))
				(DefaultBrowser NameReport)
				;(command "browser" NameReport)
			)
		)
	)
	(if (not LstMarKShape)
		(LM:popup "Errore" "Non ho trovato contorni nel nesting [MergeNesting]" (+ 0 16 4096))
	)
	(if (not LstMarKSheet)
		(LM:popup "Errore" "Non ho trovato lamiere completate nel nesting [MergeNesting]" (+ 0 16 4096))
	)
	
)
;
;
;
(defun MergeSheet (LstEnameSheet / itm itm1 LstTableShape LstShapeOnSheet Mark Ename Qta 
														LstMarKSheet LstMarKShape LstDataShape)

	;
	(foreach itm (GetListEnameShapeTable)
		(setq LstTableShape (append LstTableShape (list (list (strcat (GetComShape itm) "|" (GetPhaseShape itm) "|" (GetNameShape itm))	itm
																	  (atoi (GetQtaShape itm))))))
	)
	;	LstTableShape ((Order|Phase|Mark Ename Qta) (Order|Phase|Mark Ename Qta ) ....

	(setq LstShapeOnSheet (FindShapeOnSheet LstEnameSheet "<>" "<>" "<>"))
	;	(	(<Entity name Sheet> ("C000H|2|1152" <Entity name Shape> <Entity name Shape>)  ("C000H|2|XXX" <....>))
	;		(<Entity name Sheet> ("C000H|2|1153" <Entity name Shape> <Entity name Shape>)  ("C000H|2|XXX" <....>))
	;	)
	;
	; grouping quantity mark on sheet ++++++
	;
	(foreach itm LstShapeOnSheet
		(foreach itm1 (cdr itm)
			(setq Mark  (car itm1))
			(setq Ename (cadr itm1))
			(setq Qta   (- (length itm1) 1))
			(if (assoc Mark LstMarKSheet)
				(setq LstMarKSheet (subst (list Mark Ename (+ (caddr (assoc Mark LstMarKSheet)) Qta))
											   (assoc Mark LstMarKSheet)
											   LstMarKSheet
										))
				(setq LstMarKSheet (cons (list Mark Ename Qta) LstMarKSheet))
			)
		)
	)
	; LstMarKSheet ( (Order|Phase|Mark Ename Qta) (Order|Phase|Mark Ename Qta) ...... )
	
	(foreach itm LstMarKSheet
		(if (setq LstDataShape (assoc (car itm) LstTableShape))
			(setq LstMarKShape	(append LstMarKShape (list LstDataShape)))
			(setq LstMarKShape 	(append LstMarKShape (list (list (car itm) (cadr itm) 0))))
		)
	)
	
	; LstMarKShape
	; ( ("123|456|789" EnameRef 10) ("123|456|111" EnameRef 8) ...... )
	
	; LstMarKSheet
	; ( ("123|456|789" EnameRef 10) ("123|456|111" EnameRef 8) ...... )

	(if (and LstMarKShape LstMarKSheet)
		(progn
			(if (setq NameReport (ReportCheckNesting LstMarKShape LstMarKSheet))
				(DefaultBrowser NameReport)
				;(command "browser" NameReport)
			)
		)
	)
	(if (not LstMarKShape)
		(LM:popup "Errore" "Non ho trovato contorni nel nesting [MergeSheet]" (+ 0 16 4096))
	)
	(if (not LstMarKSheet)
		(LM:popup "Errore" "Non ho trovato lamiere completate nel nesting [MergeSheet]" (+ 0 16 4096))
	)
	
)
;
;
;
(defun MergeShape (/ LstShape NameReport) 
	
	(if (GetLstBlockBomSheetByRgp)
		(progn
			
			(if (not (CheckSameIdShape))
				(setq LstShape (SortTable (GetTableStockDeductShapeNesting) '(0 2 3 4 0 1 0 0 0 0 0) "<"))
				(LM:popup "Avvertimento" (strcat "esistono piu' contorni con lo stesso indice \n" (vl-prin1-to-string (CheckSameIdShape))) (+ 0 16 4096))
			)

			(if LstShape
				(if (setq NameReport (ReportDeductNesting LstShape))
					(DefaultBrowser NameReport)
				)
				(LM:popup "Avvertimento" "Tutti i contorni sono contenuti nelle lamiere" (+ 0 64 4096))
			)
		)
		(LM:popup "Errore" "Nessun contorno presente nel disegno" (+ 0 16 4096))
	)
)
;
;
;
(defun GuiAvailabilitySheet (FileSaveShape FileSaveSheet / MakeButtons UpDateButtons MakeListShape MakeListSheet GetSelectShape GetSelectSheet
														   RestoreFile BoxToList ListToBox LoadTable SortBox UpdateBoxList
														   FileSaveShape FileSaveSheet LstButtonShapeKey LstSortShape LstSortSheet
														   AlertShape$
														   AlertSheet$
														   xx LstBoxShape LstBoxSheet FileShape FileSheet itm GoAvailability)
											   
	
	(defun MakeButtons (LstButtonKey LstStatusButton / XVect YVect Num Key XKey YKey XMKey YMKey X Y)
		
		(setq XVect (list (list -6 6 0)
						  (list -6 6 0)
					))
		(setq YVect (list (list -2 -2 2)
						  (list 2 2 -2)
					))
					
		(setq Num 0)
		
		(foreach Key LstButtonKey
		
			(setq XKey  (dimx_tile Key))
			(setq YKey  (dimy_tile Key))
			(setq XMKey (/ (dimx_tile Key) 2))
			(setq YMKey (/ (dimy_tile Key) 2))
			
			(start_image Key) 
			
			(if (> Num 0)
				(fill_image 0 0 XKey YKey -15)
			)
			
			(cond 
				((= (nth Num LstStatusButton) 1)
					(setq X (nth 0 XVect))
					(setq Y (nth 0 YVect))
				)	
				((= (nth Num LstStatusButton) -1)
					(setq X (nth 1 XVect))
					(setq Y (nth 1 YVect))
				)	
			)
			(if (and X Y)
				(progn
					(vector_image (+ XMKey (nth 0 X)) (+ YMKey (nth 0 Y)) (+ XMKey (nth 1 X)) (+ YMKey (nth 1 Y)) 250)
					(vector_image (+ XMKey (nth 1 X)) (+ YMKey (nth 1 Y)) (+ XMKey (nth 2 X)) (+ YMKey (nth 2 Y)) 250)
					(vector_image (+ XMKey (nth 2 X)) (+ YMKey (nth 2 Y)) (+ XMKey (nth 0 X)) (+ YMKey (nth 0 Y)) 250)
				)
			)
			
			(end_image)
			
			(setq Num (1+ Num))
			(setq X nil) (setq Y nil)
		)
	)
	;
	(defun UpDateButtons (Key LstButtonKey LstStatusButton / NthVal Num Rtn)
		(if (and Key LstStatusButton LstButtonKey)
			(progn
				(setq NthVal (GetNth LstButtonKey Key))
				(cond
					((= (nth NthVal LstStatusButton) 0)
						(setq Rtn (LM:SubstNth 1 NthVal LstStatusButton))
					)
					((= (nth NthVal LstStatusButton) 1)
						(setq Rtn (LM:SubstNth -1 NthVal LstStatusButton))
					)
					((= (nth NthVal LstStatusButton) -1)
						(setq Rtn (LM:SubstNth 1 NthVal LstStatusButton))
					)
				)
				(setq Num 0)
				(repeat (length LstStatusButton)
					(if (/= Num NthVal) (setq Rtn (LM:SubstNth 0 Num Rtn)))
					(setq Num (1+ Num))
				)
				(MakeButtons LstButtonKey Rtn)
			)
		)
		Rtn
	)
	;
	(defun MakeListShape (FileShape / EnameShape Pr itm LstIdShapeFromBom Rtn)
		
		(setq Pr 1)
		(setq AlertShape$ nil)
		(if FileShape
			(if (setq LstShape (ReadFileNesting FileShape ";"))
				;Prg Id Order Phase Mark Qta Thik Length Height Mat n.torch
				;1 782139489 C792 1 1252 2 33 550 410 S355J2W 1
				(progn
					(foreach itm (GetLstBlockBomShapeByRgp $RgpShapeTarget NameBlockShape$)
						(setq LstIdShapeFromBom (append LstIdShapeFromBom (list (LM:vl-getattributevalue (vlax-ename->vla-object itm) "IDSHAPE"))))
					)
				
					(foreach itm (cdr LstShape)
						(if (member (cadr itm) LstIdShapeFromBom)
							(setq Rtn (append Rtn (list (list 	(LM:rtos Pr 2 0)
																(nth 1 itm)		;Id
																(nth 2 itm)		;Order
																(nth 3 itm)		;Phase
																(nth 4 itm)		;Mark
																(nth 5 itm)		;Qta
																(nth 6 itm)		;Tk
																"OK"))))
							(setq Rtn (append Rtn (list (list 	(LM:rtos Pr 2 0)
																(nth 1 itm)		;Id
																(nth 2 itm)		;Order
																(nth 3 itm)		;Phase
																(nth 4 itm)		;Mark
																(nth 5 itm)		;Qta
																(nth 6 itm)		;Tk
																"NO")))
								AlertShape$ T
							)
						)
						(setq Pr (1+ Pr))
					)
				)
			)
			(setq Rtn (SortTable Rtn '(0 0 1 2 4 0 3 0) "<"))
		)
		Rtn
	)
	;
	(defun MakeListSheet (FileSheet / EnameSheet itm Pr LstIdSheetFromBom Rtn)
		
		(setq AlertSheet$ nil)
		(setq Pr 1)
		(if FileSheet
			(if (setq LstSheet (ReadFileNesting FileSheet ";"))
				;Prg Id Stok Width Length Thik Surface Weight Mat n.torch
				;2 02544 STK_GGG_02 2500 5000 10 12.5 981.25 FF 1
				(progn
					(foreach itm (GetLstBlockBomSheetByRgp)
						(setq LstIdSheetFromBom (append LstIdSheetFromBom (list (LM:vl-getattributevalue (vlax-ename->vla-object itm) "ID_SHEET"))))
					)
				
					(foreach itm (cdr LstSheet)
						(if (member (cadr itm) LstIdSheetFromBom)
							(setq Rtn (append Rtn (list (list  	(LM:rtos Pr 2 0)
																(nth 1 itm)		;Id
																(nth 2 itm)		;Stock
																(nth 3 itm)		;Width
																(nth 4 itm)		;Length
																(nth 5 itm)		;Thik
																"OK"))))
							(setq Rtn (append Rtn (list (list  	(LM:rtos Pr 2 0)
																(nth 1 itm)		;Id
																(nth 2 itm)		;Stock
																(nth 3 itm)		;Width
																(nth 4 itm)		;Length
																(nth 5 itm)		;Thik
																"NO")))
								  AlertSheet$ T

							)
						)
						(setq Pr (1+ Pr))
					)
				)
				(setq Rtn (SortTable Rtn '(0 0 2 3 4 1 0) "<"))
			)
		)
		Rtn
	)
	;
	(defun GetSelectShape (OutFile Key TypeQuantity / Rtn)
		(setq NameHeadDcl$ "Lista contorni")
		
		(if (IfExistShape)
			(progn
				(if (not (CheckSameIdShape))
					(cond
						((= TypeQuantity "1")
							(setq Rtn (GuiSelPiecesShape (GetTableStockDeductShapeNesting) OutFile 0))
						)
						((= TypeQuantity "0")
							(setq Rtn (GuiSelPiecesShape (GetTableStockShapeNesting)       OutFile 0))
						)
					)
					(LM:popup "avvertimento" (strcat "esistono piu' contorni con lo stesso indice \n" (vl-prin1-to-string (CheckSameIdShape))) (+ 0 16 4096))
				)
			)
			(LM:popup "avvertimento" "Non ci sono pezzi disponibili" (+ 0 48 4096))
		)
		
		(if (car Rtn) 
			(set_tile  Key	(car Rtn)) 
			(set_tile  Key	"")
		)
	)
	;
	(defun GetSelectSheet (OutFile Key / Rtn)
		(setq NameHeadDcl$ "Lista lamiere")
		
		(if (IfExistSheet)
			(progn
				(if (not (CheckSameIdSheet))
					(setq Rtn (GuiSelPiecesSheet (GetTableStockSheetNesting 1) OutFile 0))
					(LM:popup "avvertimento" (strcat "esistono piu' lamiere con lo stesso indice \n" (vl-prin1-to-string (CheckSameIdSheet))) (+ 0 16 4096))
				)
			)
			(LM:popup "avvertimento" "Non ci sono lamiere disponibili" (+ 0 48 4096))
		)
		
		(if (car Rtn) 
			(set_tile  Key	(car Rtn)) 
			(set_tile  Key	"")
		)
	)
	;
	(defun RestoreFile (Key Ext / Rtn)
		(setq Rtn (LM:getfiles "Seleziona file Sheet" DxfNestingEasyCut$ Ext))
		(if Rtn 
			(set_tile  Key	(car Rtn)) 
			(set_tile  Key	"")
		)
		(car Rtn)
	)
	;
	(defun BoxToList (LstBox / itm Rtn)
		(foreach itm LstBox
			(setq Rtn (append Rtn (list (LM:str->lst itm "\t"))))
		)
	)
	;
	(defun ListToBox (LstBox / itm Rtn)
		(foreach itm LstBox
			(setq Rtn (append Rtn (list (LM:lst->str itm "\t"))))
		)
		Rtn
	)
	;
	(defun LoadTable (LstTable KeyBox)

		(if LstTable
			(progn
				(start_list KeyBox)
					(mapcar 'add_list LstTable)
				(end_list)
			)
		)
	)
	;
	(defun SortBox (LstTableNesting KeyBox LstSort / LstSort TypeSort Num itm Rtn Pos)

		(if (and LstTableNesting KeyBox LstSort)
			(progn
				(setq TypeSort ">")
				(setq Num 0)
				(foreach itm LstSort
					(if (= itm -1)
						(progn
							(setq TypeSort "<")
							(setq LstSort (LM:SubstNth 1 Num LstSort))
						)
					)
				)
				(setq Rtn (SortTable (BoxToList LstTableNesting) LstSort TypeSort))
				
				(setq Pos 1)
				(foreach itm Rtn
					(setq itm (LM:SubstNth (LM:rtos Pos 2 0) 0 itm))
					(setq Rtn (LM:SubstNth itm (1- Pos) Rtn))
					(setq Pos (1+ Pos))
				)
				(setq Rtn (ListToBox Rtn))
				(LoadTable Rtn KeyBox)
			)
		)
		Rtn
		
	)
	;
	(defun UpdateBoxList (KeyBox FileIn TypeEl / Lst Rtn)
		(if (and KeyBox FileIn)
			(if (findfile FileIn)
				(progn
					(cond 
						((= TypeEl "SHEET")
							(setq Lst  (MakeListSheet FileIn))
						)
						((= TypeEl "SHAPE")
							(setq Lst  (MakeListShape FileIn))
						)
					)
					(setq Rtn  (ListToBox Lst))
					(LoadTable Rtn KeyBox)
				)
				(LoadTable (list "") KeyBox)
			)
		)
		Rtn
	)
	
	;
	; Main
	;
	(setq FileSaveShape 	  (strcat DxfNestingEasyCut$ "AvailabilityShape.shp"))
	(setq FileSaveSheet       (strcat DxfNestingEasyCut$ "AvailabilitySheet.sht"))
	(vl-file-delete FileSaveShape)
	(vl-file-delete FileSaveSheet)
	
	(setq LstButtonShapeKey   '("BtShape1" "BtShape2" "BtShape3" "BtShape4" "BtShape5" "BtShape6" "BtShape7" "BtShape8"))
	(setq LstButtonSheetKey   '("BtSheet1" "BtSheet2" "BtSheet3" "BtSheet4" "BtSheet5" "BtSheet6" "BtSheet7"))
	(setq LstSortShape 	      '(0 0 0 0 0 0 0 0))
	(setq LstSortSheet 	      '(0 0 0 0 0 0 0))
	(setq AlertShape$ T)
	(setq AlertShape$ T)

	;(if (not CalcQtyDeduct$)
	;	(setq CalcQtyDeduct$ "1")
	;)
	;
	; Main
	;
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "AvailabilityUseSheet" xx "" (cond ( *GuiAvailabilitySheet* ) ( '(-1 -1) )))

	(action_tile "SelectShape" 	(vl-prin1-to-string '(if (/= (GetSelectShape FileSaveShape "FileSelectShape" CalcQtyDeduct$) "")
														(setq LstBoxShape (UpdateBoxList "ListShape" FileSaveShape "SHAPE"))
													)))								
	(action_tile "SelectSheet" 	(vl-prin1-to-string '(if (/= (GetSelectSheet FileSaveSheet "FileSelectSheet") "")
														(setq LstBoxSheet (UpdateBoxList "ListSheet" FileSaveSheet "SHEET"))
													)))
	(foreach itm (cdr LstButtonShapeKey)
		(action_tile itm (strcat "(setq LstSortShape (UpDateButtons \"" itm "\" LstButtonShapeKey LstSortShape))
								  (setq LstBoxShape  (SortBox LstBoxShape \"ListShape\" LstSortShape))"))
	)
	(foreach itm (cdr LstButtonSheetKey)
		(action_tile itm (strcat "(setq LstSortSheet (UpDateButtons \"" itm "\" LstButtonSheetKey LstSortSheet))
								  (setq LstBoxSheet  (SortBox LstBoxSheet \"ListSheet\" LstSortSheet))")) 
	)
	(action_tile "RestoreShape"	(vl-prin1-to-string '(progn (setq FileSaveShape (RestoreFile "FileSelectShape" "shp"))
															(setq LstBoxShape   (UpdateBoxList "ListShape" FileSaveShape "SHAPE")))))
	(action_tile "RestoreSheet"	(vl-prin1-to-string '(progn (setq FileSaveSheet (RestoreFile "FileSelectSheet" "sht"))
															(setq LstBoxSheet   (UpdateBoxList "ListSheet" FileSaveSheet "SHEET")))))
	(action_tile "Availability" (vl-prin1-to-string '(if (or AlertShape$ AlertSheet$)
														(LM:popup "Errore" "Contorni o lamiere non disponibili" (+ 0 16 4096))
															(progn
																(setq 	GoAvailability T  
																		FileShape (get_tile "FileSelectShape")
																		FileSheet (get_tile "FileSelectSheet")
																		*GuiAvailabilitySheet* (done_dialog)
																)
																(unload_dialog xx)
															)
													)))
		
	(action_tile "cancel"		"(setq *GuiAvailabilitySheet* (done_dialog)) (unload_dialog xx)")
	(start_dialog)
	
	
	(if GoAvailability
		(list FileShape FileSheet)
		nil
	)
)
;
;
;
(defun AvailabilitySheet (LstShape LstSheet Flag / DataShape DataSheet itm SurfaceShape SurfaceSheet)

;	(if (and LstShape LstSheet)
	(if LstShape
		(progn
			;                 0   1   2     3     4     5    6       7      8      9        10
			; LstShape ---> Prg Id Order Phase Mark   Qta  Thik   Length  Height Mat     n.torch
			; LstSheett ---> Prg Id Stok  Width Length Thik Surface Weight Mat    n.torch
			
			(setq SurfaceShape 0.0)
			(setq SurfaceSheet 0.0)
			(foreach itm LstShape
				(setq SurfaceShape (+ SurfaceShape (* (atoi (nth 5 itm)) (atof (nth 7 itm)) (atof (nth 8 itm)))))
			)
			(foreach itm LstSheet
				(setq SurfaceSheet (+ SurfaceSheet (* (atof (nth 3 itm)) (atof (nth 4 itm)))))
			)
			(if (<= SurfaceSheet SurfaceShape)
				(progn
					(LM:popup "avvertimento" (strcat "Quantita' lamiere insufficienti per il nesting" 
													 "\n\nSuperficie lamiere  Mq " (LM:rtos (/ SurfaceSheet 1000000.0) 2 3)
													 "\nSuperficie pezzi      Mq " (LM:rtos (/ SurfaceShape 1000000.0) 2 3)
													 "\nDifferenza               Mq " (LM:rtos (/ (- SurfaceSheet SurfaceShape) 1000000.0) 2 3)
													 "\n\nIl calcolo viene eseguito sulla superficie lorda (BxH) e non sulla reale sagoma"
											 ) 
											 (+ 0 16 4096))
					(if Flag
						(progn
							(setq SurfaceUse$ (/ (- SurfaceShape SurfaceSheet) 1000000.0))
							(GuiUseSheet)
						)
					)
				)
				(LM:popup "avvertimento" (strcat "Quantita' lamiere sufficienti per il nesting"
												 "\n\nSuperficie lamiere Mq " (LM:rtos (/ SurfaceSheet 1000000.0) 2 3)
												 "\nSuperficie pezzi     Mq "  (LM:rtos (/ SurfaceShape 1000000.0) 2 3)
												 "\nDifferenza              Mq " (LM:rtos (/ (- SurfaceSheet SurfaceShape) 1000000.0) 2 3)
												 "\n\nIl calcolo viene eseguito sulla superficie lorda (BxH) e non sulla reale sagoma"
										 ) (+ 0 64 4096))
			)
			
		)
	)
)
;
;
;
(defun GuiScrapSheet ( / xx x y Td Ssel)

	(setq DefaultMenuEasyCut$ GuiScrapSheet)

	(if (not (findfile 	(strcat SetupPathEasyCut$ "ScrapSheet01.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "ScrapSheet01.sld") 
						(strcat SetupPathEasyCut$ "ScrapSheet01.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "ScrapSheet02.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "ScrapSheet02.sld") 
						(strcat SetupPathEasyCut$ "ScrapSheet02.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "ScrapSheet03.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "ScrapSheet03.sld") 
						(strcat SetupPathEasyCut$ "ScrapSheet03.sld")))


	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "ScrapSheet" xx "" (cond ( *ScrapSheet* ) ( '(-1 -1) )))
	(setq x (dimx_tile "image1")) ;get image tile width
	(setq y (dimy_tile "image1")) ;get image tile heigth
	(start_image "image1")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "ScrapSheet01.sld"))
	(end_image)			
	(start_image "image2")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "ScrapSheet02.sld"))
	(end_image)
	(start_image "image3")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "ScrapSheet03.sld"))
	(end_image)

	(action_tile "image1" (strcat "(setq Td 1)"
								  "(setq *ScrapSheet* (done_dialog)) (unload_dialog xx)"))	
	(action_tile "image2" (strcat "(setq Td 2)"
								  "(setq *ScrapSheet* (done_dialog)) (unload_dialog xx)"))	
	(action_tile "image3" (strcat "(setq Td 3)"
								  "(setq *ScrapSheet* (done_dialog)) (unload_dialog xx)"))	
	(action_tile "return" (strcat "(setq Td 4)"
								  "(setq *ScrapSheet* (done_dialog)) (unload_dialog xx)"))
	(action_tile "cancel" "(setq *ScrapSheet* (done_dialog)) (unload_dialog xx)")
	(start_dialog)
	
	(cond
		((= Td 1)
			(GuiScrapeCut)
		)
		((= Td 2)
			(GuiSplitScrapCut)
		)
		((= Td 3)
			(if (setq Ssel (ssget "_+.:E:S" '((0 . "REGION"))))
				(GuiRegionToSheet (ssname Ssel 0))
			)
		)
		((= Td 4)
			(MainMenu)
		)
	)
)
;
;
;
(defun GuiSplitScrapCut ( / SplitRegion RegionTrace
							LstPt Ssel itm Punch)
	
	
	(defun SplitRegion (SselRegion / Num LstEname Delete itm)
	
		(setq Num 0)
		(if SselRegion
			(progn
				(repeat (sslength SselRegion)
					(if (entget (ssname SselRegion Num))
						(progn
							(setq LstEname (mapcar 'vlax-vla-object->ename (vlax-safearray->list 
															(vlax-variant-value (vla-Explode (vlax-ename->vla-object (ssname SselRegion Num)))))))
							(setq Delete nil)
							(foreach itm LstEname
								(if (/= (cdr (assoc 0 (entget itm))) "REGION")
									(setq Delete T)
								)
							)
							(if Delete 
								(DeleteEntity LstEname)
								(entdel (ssname SselRegion Num))
							)
						)
					)
					(setq Num (1+ Num))
				)
			)
		)
	)
	;
	(defun RegionTrace (LstPt / EnamePline Punch Trace itm ThkTr)
	
		(setq ThkTr 0.1)
		(if LstPt
			(cond 
				((or (= (car LstPt) 0) (= (car LstPt) 1))
					(if (setq EnamePline (MakePolyline (cdr LstPt) T))
						(progn
							(setq Punch  (AddRegion EnamePline))
							(entdel EnamePline)
						)
					)
				)
				((= (car LstPt) 2)
					(if (setq EnamePline (MakePolyline (cdr LstPt) nil))
						(progn 
							(vla-put-constantwidth (vlax-ename->vla-object EnamePline) ThkTr)
							(setq Trace (LM:PolyOutline EnamePline))
							(if (= (length Trace) 1)
								(setq Punch (AddRegion (car Trace)))
							)
							(foreach itm Trace
								(entdel itm)
							)
							(entdel EnamePline)
						)
					)
				)
			)
		)
		Punch
	)
	;
	; Main
	;
	(if (setq LstPt (GetTrace))
		(cond
			((or (= (car LstPt) 0) (= (car LstPt) 1))
				(setq Ssel 	(ssget "_CP" (cdr LstPt) '((0 . "REGION"))))
			)
			((= (car LstPt) 2)
				(setq Ssel 	(ssget "_F"  (cdr LstPt) '((0 . "REGION"))))
			)
		)
	)
	(if (setq Punch (RegionTrace LstPt))
		(progn
			(foreach itm (LM:ss->ent Ssel)
				(vla-boolean (vlax-ename->vla-object itm) acSubtraction (vlax-ename->vla-object Punch))
				(if (not (entget Punch)) (setq Punch (RegionTrace LstPt)))
			)
			(entdel Punch)
			(SplitRegion Ssel)
		)
	)
	(princ)
)
;
;(vla-boolean (vlax-ename->vla-object (getent)) acSubtraction (vlax-ename->vla-object (getent)))
;
(defun GuiScrapeCut (/ MinArea Ssel EnameSheet LstEname LstHatch EnameHatch MinMaxSsel itm)
	
	(setq MinArea 150000.0)
	(prompt "\nSelezionare la lamiera..")
	(setq Ssel (ssget "_+.:E:S" (list (list -3 (list (strcat $RgpSheet "," $RgpSheetTarget))))))
	(if Ssel	
		(setq EnameSheet (GetEnameSheetByDummyEname (ssname Ssel 0)))
	)
	
	
	(if EnameSheet
		(progn
			(setq LstEname (GetScrapeCut EnameSheet))
			
			(foreach itm LstEname
				(if (< (vla-get-area (vlax-ename->vla-object itm)) MinArea)
					(entdel itm)
					(progn
						(command "_Hatch" "Solid" itm "")
						(while (> (getvar 'cmdactive) 0))
						(if (setq EnameHatch (entlast))
							(if (= (cdr (assoc 0 (entget EnameHatch))) "HATCH")
								(setq LstHatch (append LstHatch (list EnameHatch)))
							)
						)
					)
				)
			)
			;(command "._Move" (LstEname->Ssget LstEname) "" pause pause)
			(setq MinMaxSsel	(LM:SSBoundingBox (LstEname->Ssget (append LstEname LstHatch))))
			(setq $DeleteEntityCommandCancel T)
				(command "._Move" (LstEname->Ssget (append LstEname LstHatch)) "" (car MinMaxSsel) pause)
				(while (> (getvar 'cmdactive) 0))
				(DeleteEntity LstHatch)

		)
	)
	(princ)
)
;
;
;
(defun GetScrapeCut (EnameSheet / LstEname Sheet Scrap itm EnameOffset Delete Rtn)

	
	(if EnameSheet
		(progn
			(setq LstEname 	(GetEnameShapeByEnameSheet EnameSheet "CE"))
			(setq Sheet 	(AddRegion EnameSheet))
			
			(foreach itm LstEname
				(if (null (setq EnameOffset	(OffsetShape02 itm $MargineAccosto)))
					(setq EnameOffset (OffsetShape03 itm $MargineAccosto))
				)
				
				(setq Scrap 		(AddRegion EnameOffset))
				(vla-boolean 		(vlax-ename->vla-object Sheet) acSubtraction (vlax-ename->vla-object Scrap))
				(entdel EnameOffset)
			)
			
			(setq LstEname (mapcar 'vlax-vla-object->ename (vlax-safearray->list (vlax-variant-value (vla-Explode (vlax-ename->vla-object Sheet))))))
			(setq Delete nil)
			(foreach itm LstEname
				(if (/= (cdr (assoc 0 (entget itm))) "REGION")
					(setq Delete T)
				)
			)
			(if Delete 
				(progn 
					(DeleteEntity LstEname)
					(setq Rtn (list Sheet))
				)
				(progn
					(entdel Sheet)
					(setq Rtn LstEname)
				)
			)
		)
	)
	Rtn
)
;
;
;
;(setq LstData (list '("1" "001" "C792" "1" "10" "20" "33" "550" "410" "S355J2W")
;					'("2" "002" "C792" "2" "11" "21" "34" "551" "411" "S355J3W")
;					'("3" "003" "C792" "3" "12" "22" "35" "552" "412" "S355J4W")
;					'("3" "003" "C792" "3" "12" "22" "35" "552" "412" "S355J4W")
;					'("3" "003" "C792" "3" "12" "22" "35" "552" "412" "S355J4W")
;					'("3" "003" "C792" "3" "12" "22" "35" "552" "412" "S355J4W")
;					'("3" "003" "C792" "3" "12" "22" "35" "552" "412" "S355J4W")
;					'("3" "003" "C792" "3" "12" "22" "35" "552" "412" "S355J4W")
;					'("3" "003" "C792" "3" "12" "22" "35" "552" "412" "S355J4W")
;					'("3" "003" "C792" "3" "12" "22" "35" "552" "412" "S355J4W")
;					'("3" "003" "C792" "3" "12" "22" "35" "552" "412" "S355J4W")))
;(setq LstTypeData	'("int" "str" "str" "str" "str" "int" "int" "real" "real" "str"))
;(setq LstTitleData  '("Itm" "Ident" "Comm." "Fase" "Marca" "Qta" "Spes." "Lung." "Alt." "Mat."))
;(setq LstModeData   '(1 1 0 0 0 0 0 1 1 0))
;(setq Nrow 10)
;(GuiScrollList LstData LstTypeData LstTitleData LstModeData NRow)
(defun GuiScrollList (LstData LstTypeData LstTitleData LstDimButton LstModeData NRow / 	LstDataToBuffer BufferToLstData GetLoop MakeDialog MyNth
																						FillDialog GetDataBoxRow CheckErrorOnBuffer 
																						ActionNext  ActionPrevious ActionLast 
																						ActionFirst ActionAccept   ActionCancel
																						NameDialog TitleLablel PosBuffer StreamDcl xx Row)
	;
	;LstData 		(("1"		"782139489"	"C792"  "1"   	"1252"  "2"    	"33"   	"550"  	"410"  	"S355J2W") (...))
	;LstTypeData	 ("int"		"str"		"str"	"str"	"str"	"int"	"int"	"real"	"real"	"str")
	;LstTitleData    ("Itm"		"Ident"		"Comm."	"Fase"	"Marca"	"Qta"	"Spes."	"Lung."	"Alt."	"Mat.")
	;LstModeData     ( 1         1        	0       0     	 0      0      	0     	1       1      	0)	1= no change 0=change
	;
	(defun LstDataToBuffer (LstData NRow / Pos Buffer)
	
		(if (and LstData NRow)
			(progn
				(setq Pos 0)
				(repeat (GetLoop LstData NRow)
					(setq Buffer (append Buffer (list (LM:SubLst LstData Pos NRow))))
					(setq Pos (+ Pos NRow))
				)
			)
		)
		Buffer
	)
	;
	(defun BufferToLstData (Buffer / itm itm1 Rtn)
			
		(if Buffer
			(foreach itm Buffer
				(foreach itm1 itm
					(setq Rtn (append Rtn (list itm1)))
				)
			)
		)
		Rtn
	)
	;	
	(defun GetLoop (LstData NRow)
		(if (and LstData NRow)
			(if (> (- (/ (float (length LstData)) NRow)
					  (/ (length LstData) NRow)
				   ) 0)
				(+ (/ (length LstData) NRow) 1)
				(/ (length LstData) NRow)
			)
		)
	)
	;(MakeDialog "TestDialog" "TestLablel" 10 (list "a" "b" "c" "d" "e") 1 T)
	(defun MakeDialog (NameDialog TitleLablel NRow LstTitleData LstDimButton FlagButton Check / dcl des Prog LgCel WidthDialog itm Pos)
	
		(if (and NameDialog TitleLablel LstDimButton NRow LstTitleData FlagButton)
			(progn
				(setq dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq des (open dcl "w"))
				
				(write-line "ok_mybutton : retirement_button {" 			des)
				(write-line "        label           = \"  OK  \";" 		des)
				(write-line "        key             = \"accept\";" 		des)
				(write-line "        is_default      = true;" 				des)
				(write-line "}" 											des)
				(write-line "cancel_mybutton : retirement_button {" 		des)
				(write-line "        label           = \"Cancel\";" 		des)
				(write-line "        key             = \"cancel\";" 		des)
				(write-line "        is_cancel       = true;" 				des)
				(write-line "}" 											des)
				(write-line "next_mybutton : retirement_button {" 			des)
				(write-line "        label           = \">\";"	 			des)
				(write-line "        key             = \"next\";" 			des)
				(write-line "}" 											des)
				(write-line "restore_mybutton : retirement_button {"		des)
				(write-line "        label           = \"<\";" 				des)
				(write-line "        key             = \"restore\";" 		des)
				(write-line "}" 											des)
				(write-line "last_mybutton : retirement_button {" 			des)
				(write-line "        label           = \">>\";"	 			des)
				(write-line "        key             = \"last\";" 			des)
				(write-line "}" 											des)
				(write-line "first_mybutton : retirement_button {"			des)
				(write-line "        label           = \"<<\";" 			des)
				(write-line "        key             = \"first\";" 			des)
				(write-line "}" 											des)
				(write-line "ok_last_next_restore_first_cancel : column {"	des)
				(write-line "    : row {" 									des)
				(write-line "       fixed_width = true;" 					des)
				(write-line "       alignment = centered;" 					des)
				(write-line "       ok_mybutton;" 							des)
				(write-line "       : spacer { width = 2; }" 				des)
				(write-line "       next_mybutton;" 						des)
				(write-line "       : spacer { width = 2; }" 				des)
				(write-line "       restore_mybutton;" 						des)
				(write-line "       : spacer { width = 2; }" 				des)
				(write-line "       last_mybutton;" 						des)
				(write-line "       : spacer { width = 2; }" 				des)
				(write-line "       first_mybutton;" 						des)
				(write-line "       : spacer { width = 2; }" 				des)
				(write-line "        cancel_mybutton;" 						des)
				(write-line "    }" 										des)
				(write-line "}" 											des)
				(write-line "ok_last_next_cancel : column {"				des)
				(write-line "    : row {" 									des)
				(write-line "       fixed_width = true;" 					des)
				(write-line "       alignment = centered;" 					des)
				(write-line "       ok_mybutton;" 							des)
				(write-line "       : spacer { width = 2; }" 				des)
				(write-line "       next_mybutton;" 						des)
				(write-line "       : spacer { width = 2; }" 				des)
				(write-line "       last_mybutton;" 						des)
				(write-line "       : spacer { width = 2; }" 				des)
				(write-line "        cancel_mybutton;" 						des)
				(write-line "    }" 										des)
				(write-line "}" 											des)
				(write-line "ok_restore_first_cancel : column {"			des)
				(write-line "    : row {" 									des)
				(write-line "       fixed_width = true;" 					des)
				(write-line "       alignment = centered;" 					des)
				(write-line "       ok_mybutton;" 							des)
				(write-line "       : spacer { width = 2; }" 				des)
				(write-line "       restore_mybutton;" 						des)
				(write-line "       : spacer { width = 2; }" 				des)
				(write-line "       first_mybutton;" 						des)
				(write-line "       : spacer { width = 2; }" 				des)
				(write-line "        cancel_mybutton;" 						des)
				(write-line "    }" 										des)
				(write-line "}" 											des)


				(setq WidthDialog 0)
				(foreach itm LstDimButton
					(setq WidthDialog (+ WidthDialog itm))
				)
					
				;(setq LgCel 13)
				;(setq WidthDialog (fix (* LgCel (length LstTitleData))))
				
				(write-line (strcat	NameDialog ":dialog{")								 				des)
				(write-line (strcat	"   label=\"" TitleLablel "\";") 									des)
				(write-line 		"   :row {" 														des)
				;(write-line 		"       fixed_width=true;" 											des) 
				;(write-line (strcat	"       width=" (LM:rtos WidthDialog 2 0) ";")		des)
				
				(setq Pos 0)
				(foreach itm LstTitleData
					;(write-line (strcat	"       :text_part {width=10; fixed_width=true; label=\"" itm "\" ;}") 	des)
					(write-line (strcat	"       :text {width=" (LM:rtos (1+ (nth Pos LstDimButton)) 2 0) " ; fixed_width=true; label=\"" itm "\" ;}") 	des)
					(setq Pos (1+ Pos))
				)	
				(write-line 		"   }" 																des)

				
				(setq Prog 0)
				(repeat NRow
					(write-line "   :row {" des)
					(write-line (strcat "       width=" (LM:rtos WidthDialog 2 0) " ;") Des)
		            (write-line "        fixed_width=true;" Des)

					(setq Pos 0)
					(foreach itm LstTitleData
						;(write-line (strcat "       :edit_box {key=\"" itm (LM:rtos Prog 2 0) "\";  edit_width=10;}") des)
						(write-line (strcat "       :edit_box {key=\"" itm (LM:rtos Prog 2 0) "\";  edit_width=" (LM:rtos (nth Pos LstDimButton) 2 0) "; fixed_width=true;}") des)
						(setq Pos (1+ Pos))
					)
					(write-line "   }" des)
					(setq Prog (1+ Prog))
				)
				(cond 
					((= FlagButton 1) (write-line "   ok_last_next_restore_first_cancel;" 	des))
					((= FlagButton 2) (write-line "   ok_last_next_cancel;" 				des))
					((= FlagButton 3) (write-line "   ok_restore_first_cancel;" 			des))
					((= FlagButton 0) (write-line "   ok_cancel;" 							des))
				)
				(write-line "}" des)
				(setq des (close des))
				(if Check (EasyCutViewer dcl))
				dcl
			)
		)
	)
	;
	(defun MyNth (N Lst)
		(if (and Lst (> N -1))
			(if (<= (1+ N) (length Lst))
				(nth N Lst)
			)
		)
	)
	;
	(defun FillDialog (LstRow NRow LstTitleData LstModeData / itm Prog PosValue PosMode)
	
		(if (and LstRow NRow LstTitleData LstModeData)
			(progn
				(setq Prog 0)
				(repeat NRow
					(if (MyNth Prog LstRow)
						(progn
							(setq PosValue 0)
							(foreach itm LstTitleData
								(SetTile (strcat itm (LM:rtos Prog 2 0)) (MyNth PosValue (MyNth Prog LstRow)))
								(setq PosValue (1+ PosValue))
							)
							(setq PosMode 0)
							(foreach itm LstTitleData
								(mode_tile (strcat itm (LM:rtos Prog 2 0)) (nth PosMode LstModeData))
								(setq PosMode (1+ PosMode))
							)
						)	
						(foreach itm LstTitleData
							(SetTile 	(strcat itm (LM:rtos Prog 2 0))	"-")
							(mode_tile 	(strcat itm (LM:rtos Prog 2 0))	1)
						)
					)
					(setq Prog (1+ Prog))
				)
			)
		)
	)
	;	
	(defun GetDataBoxRow (NRow LstTitleData / Pos itm NameCel LstValueCel Rtn)
									 
		(setq Pos 0)
		(if (and NRow LstTitleData)
			(repeat NRow
				(setq LstValueCel nil)
				(foreach itm LstTitleData
					(setq NameCel 	  (strcat itm (LM:rtos Pos 2 0)))
					(setq LstValueCel (append LstValueCel (list (GetTextBox NameCel))))
				)
				(setq Rtn (append Rtn (list LstValueCel)))
				(setq Pos (1+ Pos))
			)
		)
		Rtn
	)
	;	
	(defun CheckErrorOnBuffer (LstData LstTypeData LstTitleData / Row itm Pos Value Error)
		
		;(setq LstTitleData (list "Itm" "Ident" "Order" "Phase" "Mark" "Quantity" "Thikness" "Length" "Height" "Material"))
		;(setq LstTypeData  (list "int" "str"   "str"   "str"    "str"   "int"     "real"      "real"   "real"    "str"))
		(setq Row 1)
		(foreach itm LstData
			(setq Pos 0)
			(repeat (length itm)
				(setq Value (vl-string-right-trim " \t" (vl-string-left-trim " \t" (nth Pos itm))))
				(if (/= Value "")
					(progn
						(cond 
							((= (nth Pos LstTypeData) "int")
								(if (not (numberp (read Value)))
									(setq Error (append Error (list "\nRiga " (LM:rtos Row 2 0) " <" (nth Pos LstTitleData) "> il valore deve essere un numero")))
									(if (/= (- (atof Value) (atoi Value)) 0)
										(setq Error (append Error (list "\nRiga " (LM:rtos Row 2 0) " <" (nth Pos LstTitleData) "> il valore deve essere un intero")))
										(if (<= (read Value) 0)
											(setq Error (append Error (list "\nRiga " (LM:rtos Row 2 0) " <" (nth Pos LstTitleData) "> il valore deve > 0")))
										)
									)
								)
							)
							((= (nth Pos LstTypeData) "real")
								(if (not (numberp (read Value)))
									(setq Error (append Error (list "\nRiga " (LM:rtos Row 2 0) " <" (nth Pos LstTitleData) "> il valore deve essere un numero")))
									(if (<= (read Value) 0)
										(setq Error (append Error (list "\nRiga " (LM:rtos Row 2 0) " <" (nth Pos LstTitleData) "> il valore deve > 0")))
									)
								)
							)
						)
					)
					(setq Error (append Error (list "\nRiga " (LM:rtos Row 2 0) " <" (nth Pos LstTitleData) "> campo vuoto")))
				)
				(setq Pos (1+ Pos))
			)
			(setq Row (1+ Row))
		)
		Error
	)
	;	
	(defun ActionNext ()

		; Global variable
		
		(setq Buffer (LM:SubstNth (GetDataBoxRow (length Row) LstTitleData) PosBuffer Buffer))
		(setq PosBuffer (1+ PosBuffer))
		(if (> PosBuffer (- (length Buffer) 1))	
			(setq PosBuffer (- (length Buffer) 1))
			(progn
				(setq Row (MyNth PosBuffer Buffer))
				(FillDialog Row NRow LstTitleData LstModeData)
			)
		)
	)
	;
	(defun ActionPrevious ()

		; Global variable
		
		(setq Buffer (LM:SubstNth (GetDataBoxRow (length Row) LstTitleData) PosBuffer Buffer))
		(setq PosBuffer (1- PosBuffer))
		(if (< PosBuffer 0)
			(setq PosBuffer 0)
			(progn
				(setq Row (MyNth PosBuffer Buffer))
				(FillDialog Row NRow LstTitleData LstModeData)
			)
		)
	)
	;
	(defun ActionLast ()

		; Global variable

		(setq Buffer (LM:SubstNth (GetDataBoxRow (length Row) LstTitleData) PosBuffer Buffer))
		(if (/= PosBuffer (- (length Buffer) 1))
			(progn 
				(setq PosBuffer (- (length Buffer) 1))
				(setq Row (MyNth PosBuffer Buffer))
				(FillDialog Row NRow LstTitleData LstModeData)
			)
		)
	)
	;
	(defun ActionFirst ()

		; Global variable

		(setq Buffer (LM:SubstNth (GetDataBoxRow (length Row) LstTitleData) PosBuffer Buffer))
		(if (/= PosBuffer 0)
			(progn
				(setq PosBuffer 0)
				(setq Row (MyNth PosBuffer Buffer))
				(FillDialog Row NRow LstTitleData LstModeData)
			)
		)
	)
	;
	(defun ActionAccept (/ Rtn)

		; Global variable

		(setq Buffer (LM:SubstNth (GetDataBoxRow (length Row) LstTitleData) PosBuffer Buffer))
		(setq Rtn 	 (BufferToLstData Buffer))
		(setq *GuiScrollList* (done_dialog)) 
		(unload_dialog xx)
		(vl-file-delete StreamDcl)
		Rtn
	)
	;
	(defun ActionCancel ()

		; Global variable

		(setq *GuiScrollList* (done_dialog)) 
		(unload_dialog xx)
		(vl-file-delete StreamDcl)
	)
	;
	; Main
	;
	(if (and LstData LstTypeData LstTitleData LstModeData NRow)
		(progn
			(setq NameDialog "DialogScroll")
			(setq TitleLablel "Lista")
			(setq PosBuffer 0)
			(setq Buffer    (LstDataToBuffer LstData NRow))
			
			(setq LstTitleData (cons "Itm" 	LstTitleData))
			(setq LstTypeData  (cons "int"  LstTypeData))
			(setq LstDimButton (cons 4 		LstDimButton))
			(setq LstModeData  (cons 1 		LstModeData))
			
			(setq StreamDcl (MakeDialog NameDialog TitleLablel NRow LstTitleData LstDimButton 1 nil))
			(setq xx (load_dialog StreamDcl))
			(new_dialog NameDialog  xx  "" (cond ( *GuiScrollList* ) ( '(-1 -1) )))
			(setq Row (MyNth PosBuffer Buffer))
			(FillDialog Row NRow LstTitleData LstModeData)
				
			(action_tile "accept"  (vl-prin1-to-string '(if (not (setq LstError (CheckErrorOnBuffer (GetDataBoxRow (length Row) LstTitleData) LstTypeData LstTitleData)))
															(setq Rtn (ActionAccept))
															(LM:popup "avvertimento" (LM:lst->str LstError "") (+ 1 48 4096))
														)))
			(action_tile "last"   (vl-prin1-to-string '(if (not (setq LstError (CheckErrorOnBuffer (GetDataBoxRow (length Row) LstTitleData) LstTypeData LstTitleData)))
															(ActionLast)
															(LM:popup "avvertimento" (LM:lst->str LstError "") (+ 1 48 4096))
														)))
			(action_tile "next"	   (vl-prin1-to-string '(if (not (setq LstError (CheckErrorOnBuffer (GetDataBoxRow (length Row) LstTitleData) LstTypeData LstTitleData)))
															(ActionNext)
															(LM:popup "avvertimento" (LM:lst->str LstError "") (+ 1 48 4096))
														)))
			(action_tile "first"   (vl-prin1-to-string '(if (not (setq LstError (CheckErrorOnBuffer (GetDataBoxRow (length Row) LstTitleData) LstTypeData LstTitleData)))
															(ActionFirst)
															(LM:popup "avvertimento" (LM:lst->str LstError "") (+ 1 48 4096))
														)))
			(action_tile "restore" (vl-prin1-to-string '(if (not (setq LstError (CheckErrorOnBuffer (GetDataBoxRow (length Row) LstTitleData) LstTypeData LstTitleData)))
															(ActionPrevious)
															(LM:popup "avvertimento" (LM:lst->str LstError "") (+ 1 48 4096))
														)))
			(action_tile "cancel"  "(ActionCancel)")
			(start_dialog)
			
				
			(if Rtn 
				Rtn
				LstData
			)
		)
	)
)
;
;(setq LstData (list '("1"    "001" "C792"   "1"   "10"   			"20"   			"33" "550" "410" "S355J2W")
;					 '("2"    "002" "C792"   "2"   "11"   			"21"   			"34" "551" "411" "S355J3W")
;					 '("3"    "003" "C792"   "3"   "12"   			"22"   			"35" "552" "412" "S355J4W")
;					 '("3"    "003" "C792"   "3"   "12"   			"23"   			"35" "552" "412" "S355J4W")
;					 '("3"    "003" "C792"   "3"   "12"   			"24"   			"35" "552" "412" "S355J4W")
;					 '("3"    "003" "C792"   "3"   "12"   			"25"   			"35" "552" "412" "S355J4W")
;					 '("3"    "003" "C792"   "3"   "12"   			"26"   			"35" "552" "412" "S355J4W")
;					 '("3"    "003" "C792"   "3"   "12"   			"27"   			"35" "552" "412" "S355J4W")
;					 '("3"    "003" "C792"   "3"   "12"   			"28"   			"35" "552" "412" "S355J4W")
;					 '("3"    "003" "C792"   "3"   "12"   			"29"   			"35" "552" "412" "S355J4W")
;					 '("3"    "003" "C792"   "3"   "12"   			"30"   			"35" "552" "412" "S355J4W")))
;
;
(defun FilterList (LstData LstItmFilter LstTypeFilter LstFilter VerboseDcl / GetNthsFromList
																			 Pos LstTmp LstFiltered LstRef Chk itm itm1 LstRecord Rtn)
	

	(defun GetNthsFromList (LstRecords LstValue / itm Rtn)
		(foreach itm LstValue 
			(setq Rtn (append Rtn (GetNths itm LstRecords)))
		)
		(LM:Unique Rtn)
	)
	;
	; Main
	;
	(if (and LstData LstItmFilter LstTypeFilter LstFilter)
		(progn
			(setq Pos 0)
			(if VerboseDcl
				(progn
					(ClearProgressBarDcl "$progbarsearch$")
					(StartProgressBarDcl "$progbarsearch$" (length LstTypeFilter))
				)
			)
			(repeat (length LstTypeFilter)
				(if VerboseDcl (UpDateProgressBarDcl "$progbarsearch$"))
				
				(setq LstTmp    (GetLstRecord Lstdata (nth Pos LstItmFilter))) 
				(setq LstFiltered (append LstFiltered (list (GetNthsFromList LstTmp (EvalBoolean LstTmp (nth Pos LstFilter) (nth Pos LstTypeFilter))))))
				(setq Pos (1+ Pos))
			)
			(setq LstRef (car (vl-sort LstFiltered (function (lambda (e1 e2)  (< (length e1) (length e2)))))))
			
			(foreach itm LstRef
				(setq Chk T)
				(foreach itm1 LstFiltered
					(if (not (member itm itm1))
						(setq Chk nil)
					)
				)
				(if Chk	(setq LstRecord (append LstRecord (list itm))))
			)
			(foreach itm LstRecord
				(setq Rtn (append Rtn (list (nth itm LstData))))
			)
		)
	)
	Rtn
)
;
;
;
(defun GetLstRecord (LstInfoData PosData / Rtn)
	(if (and LstInfoData PosData)
		(foreach itm LstInfoData
			(setq Rtn (append Rtn (list (nth PosData itm)))) 
		)	
	)
)
;
;
;
(defun SortLstByType (LstValue TypeValue)

	(if (and LstValue TypeValue)
		(progn
			(cond
				((= TypeValue "int")
					(mapcar
						'(lambda (x) (nth x LstValue))
							(vl-sort-i LstValue '(lambda (a b) (< (atoi a) (atoi b))))
					)
					;(setq LstValue-i (vl-sort-i LstValue '(lambda (a b) (< (atoi a) (atoi b)))))
				)
				((= TypeValue "real")
					(mapcar
						'(lambda (x) (nth x LstValue))
							(vl-sort-i LstValue '(lambda (a b) (< (atof a) (atof b))))
					)
					;(setq LstValue-i (vl-sort-i LstValue '(lambda (a b) (< (atof a) (atof b)))))
				)
				((= TypeValue "str")
					(mapcar
						'(lambda (x) (nth x LstValue))
							(vl-sort-i LstValue '<)
					)
				)
			)
		)
	)
)
;
;
;
(defun DclHandleDummyList (DummyList TypeValue / SetTileList GetTileList
												 AddedItemList RemoveItemList
												 MoveAllItemList RemoveAllItemList FillBox
												 ListIn ListOut
												 StreamDcl xx Rtn)

	;
	(defun SetTileList (KeyName ListName)
		(start_list KeyName 3)
			(mapcar 'add_list ListName)
		(end_list)
	)
	;
	(defun GetTileList (KeyName / LstNth Rtn)
	
		(if (/= (setq LstNth (get_tile KeyName)) "")
			(setq Rtn (LM:str->lst LstNth " "))
		)
		Rtn
	)
	;
	(defun AddedItemList (/ LstNth itm SelectListIn)
	
		
		(if (setq LstNth (GetTileList "BoxIn"))
			(progn
				(foreach itm LstNth
					(setq SelectListIn (append SelectListIn (list (nth (atoi itm) ListIn))))
				)
				(foreach itm SelectListIn
					(setq ListIn  (LM:RemoveOnce itm ListIn))
					(setq ListOut (append ListOut (list itm)))
				)

				;(SetTileList "BoxIn"  (vl-sort ListIn '<))
				;(SetTileList "BoxOut" (vl-sort ListOut '<))
				;
			)
		)
	)
	;
	(defun RemoveItemList (/ LstNth itm SelectListOut)

		(if (setq LstNth (GetTileList "BoxOut"))
			(progn
				(foreach itm LstNth
					(setq SelectListOut (append SelectListOut (list (nth (atoi itm) ListOut))))
				)
				(foreach itm SelectListOut
					(setq ListOut (LM:RemoveOnce itm ListOut))
					(setq ListIn (append ListIn (list itm)))
				)
				
				;(SetTileList "BoxIn"  (vl-sort ListIn  '<))
				;(SetTileList "BoxOut" (vl-sort ListOut '<))
			)
		)
	)
	;
	(defun MoveAllItemList ()

		(setq ListOut (append ListIn ListOut))
		(setq ListIn nil)
		;(SetTileList "BoxOut" (vl-sort ListOut '<))
		;(EmptyBox "BoxIn")
	)
	;
	(defun RemoveAllItemList ()

		(setq ListIn (append ListOut ListIn))
		(setq ListOut nil)
		;(SetTileList "BoxIn" (vl-sort ListIn '<))
		;(EmptyBox "BoxOut")
	)
	;
	(defun FillBox (TypeValue)
		(setq ListIn  (SortLstByType ListIn  TypeValue))
		(setq ListOut (SortLstByType ListOut TypeValue))
		(SetTileList "BoxIn"   ListIn)
		(SetTileList "BoxOut"  ListOut)
	)
	;
	(defun MakeDialog (NameDialog TitleLablel Check / dcl des)
		
	
		(if (and NameDialog TitleLablel)
			(progn
				(setq dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq des (open dcl "w"))
				
				(write-line "move_mybutton : button {"					des)
				(write-line "        label           = \">\";"			des)
				(write-line "        key             = \"move\";"		des)
				(write-line "}"											des)
				(write-line "move_all_mybutton : button {"				des)
				(write-line "        label           = \">>\";"			des)
				(write-line "        key             = \"move_all\";"	des)
				(write-line "}"											des)
				(write-line "remove_mybutton : button {"				des)
				(write-line "        label           = \"<\";"	des)
				(write-line "        key             = \"remove\";"		des)
				(write-line "}"											des)
				(write-line "empty_mybutton : button {"					des)
				(write-line "        label           = \"<<\";"			des)
				(write-line "        key             = \"remove_all\";"	des)
				(write-line "}"											des)
				(write-line "move_moveall : column {"					des)
				(write-line "    : row {"								des)
				(write-line "        fixed_width = true;"				des)
				(write-line "        alignment = centered;"				des)
				(write-line "        move_mybutton;"					des)
				(write-line "        : spacer { width = 2; }"			des)
				(write-line "        move_all_mybutton;"				des)
				(write-line "    }"										des)
				(write-line "}"											des)
				(write-line "remove_removeall : column {"				des)
				(write-line "    : row {"								des)
				(write-line "        fixed_width = true;"				des)
				(write-line "        alignment = centered;"				des)
				(write-line "        remove_mybutton;"					des)
				(write-line "        : spacer { width = 2; }"			des)
				(write-line "        empty_mybutton;"					des)
				(write-line "    }"										des)
				(write-line "}"											des)
				(write-line (strcat NameDialog ":dialog {")									des)
				(write-line 		  	"    key=\"title\";"								des)
				(write-line (strcat   	"    label=\"" TitleLablel "\";")					des)
				(write-line           	"    :row {"										des)
				(write-line 			"          :boxed_column {"							des)
				(write-line 			"              :list_box 	{"						des)
				(write-line 			"                    label=\"Lista Attiva\";"		des)
				(write-line 			"                    key=\"BoxIn\";"				des)
				; "tabs="5 35 70";
				(write-line 			"                    width=50;"						des)
				(write-line 			"                    height=20;"					des)
				(write-line 			"                    multiple_select = true;"		des)
				(write-line 			"              }"									des)   
				(write-line 			"              move_moveall;"						des)
				(write-line 			"          }"										des)
				(write-line 			"          :boxed_column {"							des)
				(write-line 			"              :list_box {"							des)
				(write-line 			"                    label=\"Lista Selezionata\";"	des)
				(write-line 			"                    key=\"BoxOut\";"				des)
				;"tabs="5 35 70";
				(write-line 			"                    width=50;"						des)
				(write-line 			"                    height=20;"					des)
				(write-line 			"                    multiple_select = true;"		des)
				(write-line 			"              }"									des)    
				(write-line 			"              remove_removeall;"					des)
				(write-line 			"          }"										des)
				(write-line 			"    }"												des)
				(write-line 			"    ok_cancel;"									des)
				(write-line 			"}"													des)
				(close des)
				(if Check (EasyCutViewer dcl))
				dcl
			)
		)
	)
	;
	; Main
	;
	(if DummyList
		(progn
			(setq ListIn DummyList)
			(setq ListOut nil)
			(setq StreamDcl (MakeDialog "Test1" "Test2" nil))
			(setq xx (load_dialog StreamDcl))
			(new_dialog "Test1" xx)
			(set_tile "title" "Nc Files")

			
			;(SetTileList "BoxIn" ListIn)
			(FillBox TypeValue)
			(action_tile "move"        "(AddedItemList)     (FillBox TypeValue)")		;action box_active --> box_select
			(action_tile "move_all"    "(MoveAllItemList)   (FillBox TypeValue)")		;action box_active --> box_select
			(action_tile "remove"      "(RemoveItemList)    (FillBox TypeValue)")		;action box_select
			(action_tile "remove_all"  "(RemoveAllItemList) (FillBox TypeValue)")		;action box_select
			(action_tile "accept" 	   "(setq Rtn ListOut) 	(done_dialog) (unload_dialog xx) (vl-file-delete StreamDcl)")
			(action_tile "cancel"      "(setq Rtn nil)      (done_dialog) (unload_dialog xx) (vl-file-delete StreamDcl)")
			(start_dialog)
		)
	)
	(SortLstByType Rtn TypeValue)
)
;
;
; 
(defun ValueToBoolean (LstData LstSelect TypeValue / MakeBoolean
													 LstData LstSelect Pos LstMaster LstSlave Bubble Rtn)

	; (ValueToBoolean LstData LstSelect)
	; (setq LstData   '("1" "2" "3" "4" "5" "6" "7" "8" "9"))
	; (setq LstSelect '("1" "3" "5" "2" "7" "6"))
	; Result    "<1,3>,<5,7>"
	
	; (setq LstData   '("1" "2" "3" "4" "5" "6" "7" "8" "9")	
	; (setq LstSelect '("8" "5" "1" "4" "7" "2" "3" "6" "9")	
	; Result    "*" or "<>"

	; LstData   ("1" "2" "3" "4" "5" "6" "7" "8" "9")	
	; LstSelect ("1" "3" "5" "2")	
	; Result    "<1,3>,5"

	(defun MakeBoolean (LstValue LstData / itm itm1 LstVal Rtn)
		
		(setq Rtn "")
		(foreach itm LstValue
		
			(setq LstVal nil)
			(foreach itm1 itm
				(setq LstVal (append LstVal (list (nth itm1 LstData))))
			)
			;;(princ "\n") (princ LstVal) (princ "\n")
			
			(cond
				((>= (length LstVal) 2) 
					(setq Rtn (strcat Rtn "<" (car LstVal) "," (last LstVal) ">,"))
				)	
				((= (length LstVal) 1) (setq Rtn (strcat Rtn (car LstVal) ",")))
			)
		)
		(if (/= Rtn "")
			(if (= (substr Rtn (strlen rtn) 1) ",") (setq Rtn (substr Rtn 1 (- (strlen rtn) 1))))
			nil
		)
	)
	;
	; Main
	;
	(if (and LstData LstSelect TypeValue)
		(progn  
			(setq LstData  (SortLstByType (LM:Unique LstData)   TypeValue))
			(setq LstSelet (SortLstByType (LM:Unique LstSelect) TypeValue))
			(setq Pos 0)
			(foreach itm LstData
				(setq LstMaster (append LstMaster (list (list Pos itm))))
				(if (member itm LstSelet)
					(setq LstSlave  (append LstSlave (list (list Pos itm))))
				)
				(setq Pos (1+ Pos))
			)
			
			(setq Pos 0)
			(foreach itm LstSlave
				(if (= Pos (car itm))
					(setq Bubble (append Bubble (list Pos)))
					(progn
						(if Bubble (setq Rtn    (append Rtn (list Bubble))))
						(setq Bubble (list (car itm)))
						(setq Pos 	 (car itm))
					)
				)
				(setq Pos (1+ Pos))
			)
			(if Bubble (setq Rtn (append Rtn (list Bubble))))
		)
	)
	(MakeBoolean Rtn LstData)
)
;
;
(defun EvalBoolean (LstData Arg TypeData / SplitFilterOperators 
										   LstOperators Data itm LstTmp Rtn)
											
	; LstData ("1" "2" "3" "4" "5" "6" "7" "8" "9")
	; Arg     "<1,3>,5,<7,9>,<>,*"
	; TypeData "str" "int" "real"

	;(setq LstTypeOperator	'(("<>") ("<>") ("<>") ("<>") ("<>") ("<20-22>,<28-30>,25,26") ("<>") ("<>") ("<>") ("<>")))
	;(EvalBoolean '("1" "2" "3" "4" "5" "6" "7" "8" "9") "<1,3>,5,<7,9>" "str")
 
	(defun SplitFilterOperators (Arg TypeData / RemoveCharToString
												Arg ArgSplit itm MinMax Min Max Rtn)

		(defun RemoveCharToString (String LstAscii / String)
			(if (and String LstAscii)
				(foreach itm LstAscii
					(setq String (vl-list->string (vl-remove itm (vl-string->list String))))
				)
			)
			String
		)
		;
		; Main
		;
		(if (and Arg TypeData)
			(progn
				(setq Arg (RemoveCharToString Arg '(9 32))) ; tab + space
				(setq ArgSplit (splitxt Arg ","))	;"<1,3>,5,<7,9>,<>,*"  -> "<1" "3>" "5" "<7" "9>" "<>" "*"
				(foreach itm ArgSplit
					(cond 
						((and (= (substr itm 1 1) "<") (= (substr itm 2 1) ">"))
							(setq Rtn (append Rtn (list "*")))
						)
						((= (substr itm 1 1) "<")
							(setq Min (substr itm 2 (strlen itm)))
						)
						((= (substr itm (strlen itm) 1) ">")	
							(setq Max (substr itm 1 (- (strlen itm) 1)))
							(cond
								((= TypeData "int")
									(if (and (numberp (read Min)) (numberp (read Max)))
										(setq Rtn (append Rtn (list (list (atoi Min) (atoi Max)))))
									)
								)
								((= TypeData "real")
									(if (and (numberp (read Min)) (numberp (read Max)))
										(setq Rtn (append Rtn (list (list (atof Min) (atof Max)))))
									)
								)
								(t
									(setq Rtn (append Rtn (list (list Min Max))))
								)
							)
							
						)
						((= itm "*")
							(setq Rtn (append Rtn (list "*")))
						)
						(t
							(cond
								((= TypeData "int")
									(if (numberp (read itm)) (setq Rtn (append Rtn (list (atoi itm)))))
								)
								((= TypeData "real")
									(if (numberp (read itm)) (setq Rtn (append Rtn (list (atof itm)))))
								)
								(t 
									(setq Rtn (append Rtn (list itm)))
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
	; Main
	;
	(if (and LstData Arg TypeData)
		(progn
			;(setq LstData  		(vl-sort LstData '<))
			(setq LstOperators  (SplitFilterOperators Arg TypeData))
			(foreach Data LstData
				(cond 
					((= TypeData "int")
						(if (numberp (read Data)) (setq Data (list (atoi Data) Data)))
					)
					((= TypeData "real")
						(if (numberp (read Data)) (setq Data (list (atof Data) Data)))
					)
					((= TypeData "str")
						(setq Data (list Data Data))
					)
				)
		
				(foreach itm LstOperators
					(cond	
						((= (Type itm) 'LIST) 				; Max Min data
							(if (and (>= (car Data) (nth 0 itm)) 
									 (<= (car Data) (nth 1 itm))
								)
								(if (not (member (cadr Data) LstTmp)) (setq LstTmp (append LstTmp (list (cadr Data)))))
							)
						)
						((= itm "*")						; All data
							(if (not (member (cadr Data) LstTmp)) (setq LstTmp (append LstTmp (list (cadr Data)))))
						)
						(t 									; Value data
							(if (= (car Data) itm)
								(if (not (member (cadr Data) LstTmp)) (setq LstTmp (append LstTmp (list (cadr Data)))))
							)
						)
					)
				)
			)
			(foreach itm LstData
				(if (member itm LstTmp) (setq Rtn (append Rtn (list itm))))
			)
		)
	)
	Rtn
)
;
;
(defun MaxRectangleOnPoligon (LstCoo Verbose / PointInside Double->SimpleDouble01 Double->SimpleDouble02 MakeStatusInside MatrixStatus
							  DataCircle Center Radius p1 p2
							  AccuracyReal LstStatusInside MatrixPixel MatrixRectangle LstRectangle)


	(defun PointInside (Pt LstCoo Ray / IsCollinear 
										xrandom yrandom PEnd PtInt LstInt Pos Rtn)
		;
		(defun IsCollinear (Pt LstCoo / Collinear-p
										Loop Pos Rtn)
		
			(setq Loop T
				  Pos 0
			)
			(while Loop
				(if (equal (+ (distance (nth Pos      LstCoo) Pt) 
							  (distance (nth (1+ Pos) LstCoo) Pt))
							  (distance (nth Pos      LstCoo) 
										(nth (1+ Pos) LstCoo)) 1e-8)
					(setq Rtn T Loop nil)
					(setq Pos (1+ Pos))
				)
				(if (= (1+ Pos) (length LstCoo)) (setq Loop nil))
			)
			Rtn
		)
		;
		(setq Pos 0)
		(cond
			((IsCollinear Pt LstCoo)
				T
			)
			(T
				(setq xrandom 	(atof (Random_Str 5))
					  yrandom 	(+ (atof (Random_Str 5)) xrandom)
					  PEnd		(polar Pt (/ xrandom yrandom) (* 1.5 Ray))
				)
				;(setq Pend (list (atof (LM:Rtos (+ (car Pt) 10000) 2 1)) (cadr Pt)))
				
				(repeat (- (length LstCoo) 1)
					(if (setq PtInt (inters (nth Pos LstCoo) (nth (1+ Pos) LstCoo) Pt PEnd T))
						(progn
							(setq PtInt	(list (atof (Rtos (car  PtInt) 2 AccuracyReal))
											  (atof (Rtos (cadr PtInt) 2 AccuracyReal))))
							(if (not (member PtInt LstInt))
								(setq LstInt (append LstInt (list PtInt)))
							)
						)
					)
					(setq Pos (1+ Pos))
				)
				(if LstInt
					(if (= (rem (length LstInt) 2) 0)
						nil
						T
					)
					nil
				)
			)
		)
	)
	;
	(defun Double->SimpleDouble01 (LstCoo AccuracyReal / Rtn)
		(foreach itm LstCoo
			(setq Rtn (append Rtn (list (list (atof (Rtos (car  itm) 2 AccuracyReal))
											  (atof (Rtos (cadr itm) 2 AccuracyReal))))))
		)
		Rtn
	)
	;
	(defun Double->SimpleDouble02 (LstVal AccuracyReal / Rtn)
		(foreach itm LstVal
			(setq Rtn (append Rtn (list (atof (Rtos itm 2 AccuracyReal)))))
		)
		Rtn
	)
	;
	(defun MakeStatusInside (LstCoo LstX LstY / PosX PosY Ray LstTmp Rtn)

		(if LstCoo
			(progn
				(setq PosY 	0
					  Ray	(distance (list (car LstX) (car LstY)) (list (last LstX) (last LstY)))
				)
				(repeat (length LstY)
					(setq PosX 0 LstTmp nil)
					(repeat (length LstX)
						;(LM:MakePoint (list (nth PosX LstX) (nth PosY LstY)))
						(setq LstTmp (append LstTmp (list (PointInside (list (nth PosX LstX) (nth PosY LstY)) LstCoo Ray)))  PosX (1+ PosX))
					)
					(setq Rtn (append Rtn (list LstTmp)) PosY (1+ PosY))
				)
			)
		)
		Rtn
	)
	;
	(defun MatrixStatus (LstStatusInside / PosX PosY Row1 Row2 LstX Rtn)

		(setq PosY 0)
		(repeat (- (length LstStatusInside) 1)
			(setq Row1 (nth PosY 		LstStatusInside))
			(setq Row2 (nth (1+ PosY) 	LstStatusInside))
			
			(setq PosX 0
				  LstX nil
			)
			(repeat (- (length Row1) 1)
			
				(if (and (nth PosX Row1) (nth (1+ PosX) Row1) (nth PosX Row2) (nth (1+ PosX) Row2))
					(setq LstX (append LstX (list 1)))
					(setq LstX (append LstX (list 0)))
				)
				(setq PosX (1+ PosX))
			)
			(setq Rtn (append Rtn (list LstX)))
			(setq PosY (1+ PosY))
		)
		Rtn
	)
	;
	; Main +++++
	;
	(if (and LstCoo)
		(progn
			(setq AccuracyReal 1)
			(setq LstCoo 	(Double->SimpleDouble01 (append LstCoo (list (car LstCoo))) AccuracyReal)
				  LstX   	(Double->SimpleDouble02 (vl-sort (LM:Unique (mapcar 'car  LstCoo)) '<) AccuracyReal)
				  LstY   	(Double->SimpleDouble02 (vl-sort (LM:Unique (mapcar 'cadr LstCoo)) '<) AccuracyReal)
			)
			;(foreach itm LstCoo (LM:MakePoint itm))
			;
			; Core ++++++
			;
			(setq LstStatusInside 	(MakeStatusInside LstCoo LstX LstY))
			(setq MatrixPixel	  	(MatrixStatus LstStatusInside))
			(setq MatrixRectangle	(ResolveRectangle02 MatrixPixel))
			(DiscoverySurfaceRectangle MatrixRectangle LstX LstY Verbose)
			
		)
	)
)
;
;
(defun MaxRectangleOnEnamePoligon (EnameShape Discretize Preci Verbose / DataCircle Center Radius p1 p2
																		 LstShape LstStatusInside MatrixPixel MatrixRectangle LstRectangle)


	(if (and EnameShape Discretize Preci)
		(progn
			(cond
				((or (= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
					    (IsLwPolylineCircle EnameShape)
					)
					(MaxRectangOnCirculaSegment EnameShape Verbose)
				)
				(t 
					(setq LstCoord 	(InfillingShape EnameShape Discretize Preci))
					(list (MaxRectangleOnPoligon LstCoord Verbose))
				)
			)
		)
	)
)
;
;
(defun MaxRectangOnCirculaSegment (EnameShape Verbose / B Base Height Xc Yc Xh Yh)

	(if EnameShape
		(progn
			(cond
				((setq DataCircle (IsLwPolylineCircle EnameShape))
					(setq Center (car DataCircle))
					(setq Radius (cadr DataCircle))
					(setq p1 (polar Center (* Pi (/ 5.0 4.0)) Radius))
					(setq p2 (polar Center (/ Pi 4.0) Radius))
					(if Verbose
						(MakePolyline (list (list (car p1) (cadr p1)) (list (car p2) (cadr p1)) (list (car p2) (cadr p2)) (list (car p1) (cadr p2))) T)
					)
				)
				((= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
					(setq Center (cdr (assoc 10 (entget EnameShape))))
					(setq Radius (cdr (assoc 40 (entget EnameShape))))
					(setq p1 (polar Center (* Pi (/ 5.0 4.0)) Radius))
					(setq p2 (polar Center (/ Pi 4.0) Radius))
					(if Verbose
						(MakePolyline (list (list (car p1) (cadr p1)) (list (car p2) (cadr p1)) (list (car p2) (cadr p2)) (list (car p1) (cadr p2))) T)
					)
				)
			)
		)
	)
	(if (and Center Radius)
		(progn
			(setq B 		(/ (- (cadr p2) (cadr p1)) 2.0))
			(setq Heigth 	(/ (- (sqrt (+ (* B B) (* 8.0 (* Radius Radius)))) (* 3.0 B)) 4.0))
			(setq Base 		(* (sqrt (* Heigth (+ Heigth B))) 2.0))
			
			;(setq Base 	(* (* Radius (cos (/ (* 65.0 Pi) 180.0))) 2.0))
			;(setq Heigth 	(- (* Radius (sin (/ (* 65.0 Pi) 180.0))) (* Radius (sin (/ (* 45.0 Pi) 180.0)))))
			
			
			(setq Xc (car Center) Yc (cadr Center))
			(setq Xh (/ Base 2.0) Yh (* Radius (sin (/ (* 45.0 Pi) 180.0))))
			
			(if Verbose
				(progn
					(MakeRectangle02 (list (- Xc Xh) 		(- Yc Yh Heigth)) 	(list (+ Xc Xh) 		(- Yc Yh)))
					(MakeRectangle02 (list (+ Xc Yh) 		(- Yc Xh)) 			(list (+ Xc Yh Heigth) 	(+ Yc Xh)))
					(MakeRectangle02 (list (- Xc Xh) 		(+ Yc Yh)) 			(list (+ Xc Xh) 		(+ Yc Yh Heigth)))
					(MakeRectangle02 (list (- Xc Yh Heigth) (- Yc Xh)) 			(list (- Xc Yh)		 	(+ Yc Xh)))
				)
			)
			
			(list (list (list (car p1) (cadr p1)) (list (car p2) (cadr p2)))
				  (list (list (- Xc Xh) 		(- Yc Yh Heigth)) 	(list (+ Xc Xh) 		(- Yc Yh)))
				  (list (list (+ Xc Yh) 		(- Yc Xh)) 			(list (+ Xc Yh Heigth) 	(+ Yc Xh)))
				  (list (list (- Xc Xh) 		(+ Yc Yh)) 			(list (+ Xc Xh) 		(+ Yc Yh Heigth)))
				  (list (list (- Xc Yh Heigth) 	(- Yc Xh)) 			(list (- Xc Yh)		 	(+ Yc Xh)))
			)
		)
	)
)
;
;
(defun DiscoverySurfaceRectangle (MatrixRectangle LstX LstY GraphicsRect / GetArea MaxRectangle
																			LstX LstY MaxArea Area Pos PosArray itm1 itm2 Row NthValue)

	(defun GetArea (Row Column LstX LstY / Y1 Y2 X1 X2)
	
		(setq Y1 (nth Row LstY)
			  Y2 (nth (1+ Row) LstY)
			  X1 (nth Column LstX)
			  X2 (nth (1+ Column) LstX)
		)
		(* (abs (- Y2 Y1)) (abs (- X2 X1)))
	)
	;
	;
	(defun MaxRectangle (DataRectangle LstX LstY GraphicsRect / itm Row Column X Y x1 x2 y1 y2)
		;DataRectangle  ((1 9 10) (2 9 10) (3 9 10) (4 9 10) (5 9 10) (6 9 10) (7 9 10) (8 9 10) (9 9 10))
		(if (and DataRectangle LstX LstY)
			(progn
				(foreach itm DataRectangle
					(setq Row (car itm))
					(foreach Column (cdr itm)
						(setq Y (append Y	(list (nth Row LstY) 	(nth (1+ Row) LstY)))
							  X (append X (list (nth Column LstX) (nth (1+ Column) LstX)))
						)
					)
				)
				(setq x1 (apply 'min X))
				(setq x2 (apply 'max X))
				(setq y1 (apply 'min Y))
				(setq y2 (apply 'max Y))
				(if GraphicsRect (MakePolyline (list (list x1 y1) (list x2 y1) (list x2 y2) (list x1 y2)) T))
				(list (list x1 y1) (list x2 y2))
			)
		)
	)
	;
	; Main
	;
	(if MatrixRectangle
		(progn

			(setq MaxArea 0.0)
			(setq PosArray 0)
			(foreach itm1 MatrixRectangle
				(setq Area 0)
				(foreach itm2 itm1
					(setq Row (car itm2))
					(foreach itm3 (cdr itm2)
						(setq Area (+ Area (GetArea Row itm3 LstX LstY)))
					)
				)
				(if (> Area MaxArea)
					(setq MaxArea Area
						  NthValue PosArray
					)
				)
				(setq PosArray (1+ PosArray))
			)
		)
	)
	(MaxRectangle (nth NthValue MatrixRectangle) LstX LstY GraphicsRect)
)
;
;
(defun MakeMatrix (/ Rtn)
	(setq Matrix (reverse (list 	'(1 1 0 1 1 0)
									'(0 0 0 1 0 0)
									'(1 1 1 1 1 1)
									'(0 1 1 0 1 1)
						)
				)
	)
)
;
;
(defun ResolveRectangle01 (Matrix / vl-positions FindNode FilterSequence MemberLst RemoveDuplicates
									Pos1 Pos2 itm1 itm2 LstTmp Rtn)

	(defun vl-positions ( x l / i )
		(setq i -1)
		(vl-remove nil (mapcar '(lambda ( y ) (setq i (1+ i)) (if (= x y) i)) l))
	)
	;
	;
	(defun FilterSequence (Lst / LstTmp LastValue Pos Rtn)
		; (1 2 3 5)
		; return ((1 2 3) (5))
		(if Lst
			(progn
				(setq 	LstTmp 	(list (car Lst))
						LastValue (car Lst)
						Pos 1
				)
				(repeat (- (length Lst) 1)
					(cond 
						((= (- (nth Pos Lst) LastValue) 1)
							(setq 	LastValue (nth Pos Lst)
									LstTmp	(append LstTmp (list LastValue))
							)
						)
						(t 
							(setq Rtn 	(append Rtn (list LstTmp))
										LastValue (nth Pos Lst)
										LstTmp 	(list LastValue)
							)
						)
					)
					(setq Pos (1+ Pos))
				)
				(append Rtn (list LstTmp))
			)
		)
	)
	;
	;
	(defun MemberLst (LstCheck LstMaster / Loop Pos Rtn)
		;
		; LstCheck (1 2 3) 		LstMaster (1 2 3 4)  	Return nil
		; LstCheck (1 2 3 4) 	LstMaster (1 2 3)  		Return T
		;
		(setq Loop T)
		(setq Pos 0)
		(setq Rtn T)
		(if (>= (length LstCheck) (length LstMaster))
			(while Loop
				(if (not (member (nth Pos LstMaster) LstCheck))
					(setq Loop nil Rtn nil)
					(setq Pos (1+ Pos))
				)
				;(if (= (1+ Pos) (length LstMaster))	(setq Loop nil))
				(if (= Pos (length LstMaster))	(setq Loop nil))
			)
			(setq Rtn nil)
		)
		Rtn
	)
	;
	;
	(defun RemoveDuplicates ( lst / foo temp )
		(defun foo (x)
			(cond
				((vl-position x temp) t)
				((setq temp (cons x temp)) nil)
			)
		)
		(vl-remove-if 'foo lst)
	)
	;
	; Main +++++++++++++++++++++++
	;
	(setq Pos1 0)
	(foreach itm1 Matrix
		(if (setq Node1 (FilterSequence (vl-positions 1 itm1)))
			(progn
				(setq LstTmp (append LstTmp (list (cons Pos1 (car Node1)))))
				(setq Pos2 0)
				(foreach itm2 Matrix
					(if (setq Node2 (FilterSequence (vl-positions 1 itm2)))
						(progn
							(if (MemberLst (car Node2) (car Node1))
								(if (not (member (cons Pos2 (car Node1)) LstTmp))
									(setq LstTmp (append LstTmp (list (cons Pos2 (car Node1)))))
								)
							)
						)
					)
					(setq Pos2 (1+ Pos2))
				)
				(if LstTmp
					(progn
						(setq Rtn (append Rtn (list (vl-sort LstTmp (function (lambda (e1 e2) (< (car e1) (car e2))))))))
						(setq LstTmp nil)
					)
				)
			)
		)
		(setq Pos1 (1+ Pos1))
	)
	
	(if LstTmp
		(progn
			(setq Rtn (append Rtn (list (vl-sort LstTmp (function (lambda (e1 e2) (< (car e1) (car e2))))))))
			(setq LstTmp nil)
		)
	)
	(if Rtn
		(RemoveDuplicates Rtn)
		nil
	)
)
;
;
(defun ResolveRectangle02 (Matrix / vl-positions FilterSequence MemberLst RegroupSequence
									SplitMtx Pos1 Pos2 Itm1 Itm2 LstTmp Rtn)

	(defun vl-positions ( x l / i )
		(setq i -1)
		(vl-remove nil (mapcar '(lambda ( y ) (setq i (1+ i)) (if (= x y) i)) l))
	)
	;
	;
	(defun FilterSequence (Lst / LstTmp LastValue Pos Rtn)
		; (1 2 3 5)
		; return ((1 2 3) (5))
		(if Lst
			(progn
				(setq 	LstTmp 	(list (car Lst))
						LastValue (car Lst)
						Pos 1
				)
				(repeat (- (length Lst) 1)
					(cond 
						((= (- (nth Pos Lst) LastValue) 1)
							(setq 	LastValue (nth Pos Lst)
									LstTmp	(append LstTmp (list LastValue))
							)
						)
						(t 
							(setq Rtn 	(append Rtn (list LstTmp))
										LastValue (nth Pos Lst)
										LstTmp 	(list LastValue)
							)
						)
					)
					(setq Pos (1+ Pos))
				)
				(append Rtn (list LstTmp))
			)
		)
	)
	;
	;
	(defun MemberLst (LstCheck LstMaster / Loop Pos Rtn)
		;
		; LstCheck (1 2 3) 		LstMaster (1 2 3 4)  	Return nil
		; LstCheck (1 2 3 4) 	LstMaster (1 2 3)  		Return T
		;
		(setq Loop T)
		(setq Pos 0)
		(setq Rtn T)
		(if (>= (length LstCheck) (length LstMaster))
			(while Loop
				(if (not (member (nth Pos LstMaster) LstCheck))
					(setq Loop nil Rtn nil)
					(setq Pos (1+ Pos))
				)
				;(if (= (1+ Pos) (length LstMaster))	(setq Loop nil))
				(if (= Pos (length LstMaster))	(setq Loop nil))
			)
			(setq Rtn nil)
		)
		Rtn
	)
	;
	;
	(defun RegroupSequence (Lst / Pos LstTmp Num1 Num2 Rtn)
		;( (1 3 4)  (3 3 4)  (4 3 4)  (6 3 4) )
		;( ((1 3 4))  ( (3 3 4)  (4 3 4) )  ((6 3 4)) )
		(if Lst
			(progn
				(setq Pos 0)
				(setq LstTmp (list (car Lst)))
				
				(repeat (1- (length Lst))
				
					(setq Num1 (car (nth Pos 	  Lst)))
					(setq Num2 (car (nth (1+ Pos) Lst)))
					
					(cond
						((= (- Num2 Num1) 1)
							(setq LstTmp (append LstTmp (list (nth (1+ Pos) Lst))))
						)
						((/= (- Num2 Num1) 1)
							(setq Rtn    (append Rtn (list LstTmp)))
							(setq LstTmp (list (nth (1+ Pos) Lst)))
						)
					)
					
					(setq Pos (1+ Pos))
				)
				(setq Rtn (append Rtn (list LstTmp)))
			)
		)
		Rtn
	)
	;
	; Main +++++++++++++++++++++++
	;
	(setq Pos1 0)
	(foreach Itm1 Matrix
		(foreach Itm2 (FilterSequence (vl-positions 1 Itm1))
			(setq SplitMtx (append SplitMtx (list (append (list Pos1) Itm2))))
		)
		(setq Pos1 (1+ Pos1))
	)
	
	(setq Pos1 0)
	(repeat (length SplitMtx)
		(setq Itm1 (nth Pos1 SplitMtx))
		(setq LstTmp (list Itm1))
		
		(setq Pos2 0)
		(repeat (length SplitMtx)
			(if (/= Pos1 Pos2)
				(progn
					(setq Itm2 (nth Pos2 SplitMtx))
					(if (MemberLst (cdr Itm2) (cdr Itm1))
						(setq LstTmp (append LstTmp (list (append (list (car Itm2)) (cdr Itm1)))))
					)
				)
			)
			(setq Pos2 (1+ Pos2))
		)

		(setq Rtn (append Rtn (RegroupSequence (vl-sort LstTmp (function (lambda (e1 e2) (< (car e1) (car e2))))))))
		(setq Pos1 (1+ Pos1))
	)
	Rtn
)
;
;
(defun GetScrapShape (EnameShape / 	MaxMin EnameRectangle EnameRegion1 EnameRegion2 itm Rtn)

	;
	; Main
	;
	(if EnameShape
		(progn
			(if (not (IsLwComplanar EnameShape)) (FlattLwPolyline EnameShape))

			(setq MaxMin 			(BoundingBoxLstEname (list EnameShape)))
			(setq EnameRectangle 	(MakePolyline (list (car MaxMin) (cadr MaxMin) (caddr MaxMin) (cadddr MaxMin)) T))

			(setq EnameRegion1 (AddRegion EnameRectangle))
			(setq EnameRegion2 (AddRegion EnameShape))
			
			(vla-boolean (vlax-ename->vla-object EnameRegion1) 2 (vlax-ename->vla-object EnameRegion2))
			
			(if (not (zerop (vla-get-area (vlax-ename->vla-object EnameRegion1))))
				(foreach itm (Region2Polyline EnameRegion1 T)
					;(princ "\n") (princ (vla-get-area (vlax-ename->vla-object itm)))
					(if (> (vla-get-area (vlax-ename->vla-object itm)) 10)
						(progn 
							;(princ "\nsalvo")
							(setq Rtn (append Rtn (list itm)))
						)
						(progn
							;(princ "\nnon salvo")
							(DeleteEntity (list itm))
						)
					)
				)
			)
			(DeleteEntity 			(list EnameRectangle))
		)
	)
	Rtn
)
;
;
(defun MaxRectangleOnScrapShape (EnameShape Verbose / itm Accuracy Rtn)

	;
	; Main
	;
	(foreach itm (GetScrapShape EnameShape)
		;(cond 
		;	((<= (vla-get-area (vlax-ename->vla-object itm)) 100.0) 	; 10x10
		;		(setq Accuracy 5.0)
		;	)
		;	((<= (vla-get-area (vlax-ename->vla-object itm)) 10000.0) 	; 100x100
		;		(setq Accuracy 15.0)
		;	)
		;	((<= (vla-get-area (vlax-ename->vla-object itm)) 50000.0) 	; 500x100
		;		(setq Accuracy 20.0)
		;	)
		;	((<= (vla-get-area (vlax-ename->vla-object itm)) 100000.0) 	; 5000x5000
		;		(setq Accuracy 25.0)
		;	)
		;	(t
		;		(setq Accuracy 40.0)
		;	)
		;)
		;(RectangleToEnamePoligon itm Accuracy T)
		;(setq Rtn (append Rtn (list (MaxRectangleOnEnamePoligon itm 41.0 0.001 Verbose))))
		(setq Rtn (append Rtn (MaxRectangleOnEnamePoligon itm 41.0 0.001 Verbose)))
		(DeleteEntity (list itm))
	)
	Rtn
)
;
;					0		1		2		3		4
; LstCoShape1 ((x1 y1) (x2 y2) (x3 y3) (x4 y4) (x1 y1))
; LstCoShape2 ((x1 y1) (x2 y2) (x3 y3) (x4 y4) (x1 y1))
;
;(setq LstCoShape1 '((0.0 0.0) (100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0)))
;(setq LstCoShape2 '((50.0 -50.0)  (60.0 -50.0) (60.0 30.0) (70.0 30.0) (70.0 -50.0) (150.0 -50.0) (150.0 50.0) (50.0 50.0) (50.0 -50.0)))
;
;(setq LstCoShape1 '((0.0 0.0) (100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0)))
;(setq LstCoShape2 '((0.0 -10.0) (0.0 -100.0) (100.0 -100.0) (100.0 -10.0) (0.0 -10.0)))
;
;(setq LstCoShape1 '((0.0 0.0) (100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0)))
;(setq LstCoShape2 '((0.0 0.0) (0.0 -100.0) (100.0 -100.0) (100.0 0.0) (0.0 0.0)))
;
;(setq LstCoShape1 '((0.0 0.0) (100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0)))
;(setq LstCoShape2 '((50.0 0.0)  (50.0 -50.0) (150.0 -50.0) (150.0 0.0) (50.0 0.0)))
;
;(setq LstCoShape1 '((100.0 0.0) (200.0 100.0) (100.0 200.0) (0.0 100.0) (100.0 0.0)))
;(setq LstCoShape2 '((100.0 100.0) (200.0 200.0) (100.0 300.0) (0.0 200.0) (100.0 100.0)))
;
;(MergePoligon LstCoShape1 LstCoShape2 0.001)
;
(defun MergePoligon (LstCoShape1 LstCoShape2 Preci / IntShape MaxMinCo ClockWise NextPointOnList GetStartVertext GetTurnAngle RemoveCollinear-p
													 LstIntersectionShape LstShape1 LstShape2 DataStart Loop ListMaster ListSlave PtAct
													 NextPointMaster NextPointSlave LastPt Tmp Rtn)
	
	(defun IntShape (LstCoShape1 LstCoShape2 Preci / SortIntersectionSegment
													 AssocLst1 AssocLst2 Pos1 Pos2 Pt1 Pt2 Pt3 Pt4 PtInt Rtn)
	
		(defun SortIntersectionSegment (LstShape LstIntersection Preci / Pos itm itm1 LstCo LstDist Rtn)
		
			(if (and LstShape LstIntersection)
				(progn
					(setq Pos 0)
					(foreach itm LstShape
						(setq LstCo (list itm))
						
						(if (setq AssocLst (assoc Pos LstIntersection))
							(progn
								(setq LstDist nil)
								(foreach itm1 (cdr AssocLst)
									(setq LstDist (append LstDist (list (distance itm itm1))))
								)
								(foreach itm1 (vl-sort-i LstDist '<)
									(setq LstCo (append LstCo (list (nth itm1 (cdr AssocLst)))))
								)
							)
						)
						
						(setq Rtn (append Rtn LstCo))
						(setq Pos (1+ Pos))
					)
					(append (LM:UniqueFuzz Rtn Preci) (list (car Rtn)))
					;(append (LM:Unique Rtn) (list (car Rtn)))
				)
			)
		)
		;
		; Main +++++
		;
		(if (and LstCoShape1 LstCoShape2)
			(progn
				
				(setq Pos1 0)
				
				(repeat (- (length LstCoShape1) 1)
					(setq Pt1 (nth Pos1 LstCoShape1))
					(setq Pt2 (nth (1+ Pos1) LstCoShape1))
				

				
					;(setq AssocLst nil)
					(setq Pos2 0)					
					
					(repeat (- (length LstCoShape2) 1)
						(setq Pt3 (nth Pos2 LstCoShape2))
						(setq Pt4 (nth (1+ Pos2) LstCoShape2))
						
						(if (setq PtInt (inters pt1 pt2 pt3 pt4 T))
							(progn
								(if (assoc Pos1 AssocLst1)
									(setq AssocLst1 (subst (append (assoc Pos1 AssocLst1) (list Ptint)) (assoc Pos1 AssocLst1) AssocLst1))
									(setq AssocLst1 (append AssocLst1 (list (list Pos1 Ptint))))
								)
								(if (assoc Pos2 AssocLst2)
									(setq AssocLst2 (subst (append (assoc Pos2 AssocLst2) (list Ptint)) (assoc Pos2 AssocLst2) AssocLst2))
									(setq AssocLst2 (append AssocLst2 (list (list Pos2 Ptint))))
								)
							)
						)
						(setq Pos2 (1+ Pos2))
					)
					;(if AssocLst (setq Rtn (append Rtn (list (list Pos1 AssocLst)))))
					(setq Pos1 (1+ Pos1))
				)
			)
		)
		(list (SortIntersectionSegment LstCoShape1 AssocLst1 Preci) (SortIntersectionSegment LstCoShape2 AssocLst2 Preci))
		
	)
	;
	(defun MaxMinCo (LstCoo)
		(list 	(list (apply 'min (mapcar 'car LstCoo))	(apply 'min (mapcar 'cadr LstCoo)))
				(list (apply 'max (mapcar 'car LstCoo))	(apply 'max (mapcar 'cadr LstCoo)))
		)
	)
	;
	(defun ClockWise ( p1 p2 p3 )
		(<  (* (- (car  p2) (car  p1)) (- (cadr p3) (cadr p1)))
			(* (- (cadr p2) (cadr p1)) (- (car  p3) (car  p1)))
		)
	)
	;
	(defun NextPointOnList (Pt LstPt Preci / NextNth NextPoint)
		(if (and Pt LstPt)
			(progn
				;(setq NextNth   (+ (GetNth LstPt Pt) 1))
				(setq NextNth   (+ (FindNthValToList LstPt Pt Preci) 1))
				(setq NextPoint (nth NextNth LstPt))
			)
		)
	)
	;
	(defun GetStartVertext (LstCoShape1 LstCoShape2 / Rtn)
		(if (and LstCoShape1 LstCoShape2)
			(progn
				(setq LstBox  (MaxMinCo (append LstShape1 LstShape2)))
				(cond 
					((and (setq Rtn (GetNth (mapcar  '(lambda (x) (car x))  LstShape1) (car (car LstBox))))
						  (not (member (nth Rtn LstShape1) LstShape2)))
						(list 1 Rtn)
					)
					((and (setq Rtn (GetNth (mapcar  '(lambda (x) (car x))  LstShape1) (car (cadr LstBox))))
						(not (member (nth Rtn LstShape1) LstShape2)))
						(list 1 Rtn)
					)
					((and (setq Rtn (GetNth (mapcar  '(lambda (x) (car x))  LstShape2) (car (car LstBox))))
						(not (member (nth Rtn LstShape2) LstShape1)))
						(list 2 Rtn)
					)
					((and (setq Rtn (GetNth (mapcar  '(lambda (x) (car x))  LstShape2) (car (cadr LstBox))))
						(not (member (nth Rtn LstShape2) LstShape1)))
						(list 2 Rtn)
					)
					((and (setq Rtn (GetNth (mapcar  '(lambda (x) (cadr x))  LstShape1) (cadr (car LstBox))))
						(not (member (nth Rtn LstShape1) LstShape2)))
						(list 1 Rtn)
					)
					((and (setq Rtn (GetNth (mapcar  '(lambda (x) (cadr x))  LstShape1) (cadr (cadr LstBox))))
						(not (member (nth Rtn LstShape1) LstShape2)))
						(list 1 Rtn)
					)
					((and (setq Rtn (GetNth (mapcar  '(lambda (x) (cadr x))  LstShape2) (cadr (car LstBox))))
						(not (member (nth Rtn LstShape2) LstShape1)))
						(list 2 Rtn)
					)
					((and (setq Rtn (GetNth (mapcar  '(lambda (x) (cadr x))  LstShape2) (cadr (cadr LstBox))))
						(not (member (nth Rtn LstShape2) LstShape1)))
						(list 2 Rtn)
					)
				)
			)
		)
	)
	;
	(defun GetTurnAngle (P1 P2 P3 / Ang)
		(if (and P1 P2 P3)
			(progn
				(setq Ang (CarnotAng P1 P2 P3))
				(cond
					((ClockWise P1 P2 P3)	
						Ang
					)
					(t
						(if (< Ang Pi)
							(- (* 2 pi) Ang)
							Pi
						)
					)
				)
			)
		)
	)
	;
	(defun RemoveCollinear-p (LstPt Accuracy / Loop Pos P1 P2 P3)
        (setq Loop T)
        (setq Pos 0)
        (if LstPt
            (while Loop
                (setq P1 (nth (+ Pos 0) LstPt))
                (setq P2 (nth (+ Pos 1) LstPt))
                (setq P3 (nth (+ Pos 2) LstPt))
                (if (and P1 P2 P3)
                    (progn
                        (if (LM:Collinear-p P1 P2 P3 Accuracy)
                            (progn
                                (setq LstPt (LM:RemoveNth (+ Pos 1) LstPt))
                                (setq LstPt (RemoveCollinear-p LstPt Accuracy))
                            )
                        )
                        (setq Pos (1+ Pos))
                    )
                    (setq Loop nil)
                )
            )
        )
        LstPt
    )
	;
	; Main ++++
	;
	;(setq Preci 0.001)
	(if (setq LstIntersectionShape (IntShape LstCoShape1 LstCoShape2 Preci))
		(progn
			(setq LstShape1 (car LstIntersectionShape))
			(setq LstShape2 (cadr LstIntersectionShape))
		)
	)
	
	(if (and  LstShape1 LstShape2)
		(progn
			(setq DataStart (GetStartVertext LstShape1 LstShape2))
			(cond 
				((= (car DataStart) 1)
					(setq ListMaster LstShape1)
					(setq ListSlave  LstShape2)
				)
				((= (car DataStart) 2)
					(setq ListMaster LstShape2)
					(setq ListSlave  LstShape1)
				)
			)
		
			(setq Loop 	T)
			(setq Rtn 	(list (nth (cadr DataStart) ListMaster)))
			(setq PtAct (nth (cadr DataStart) ListMaster))
	
			(while Loop
				;(if (member PtAct ListSlave)
				(if (MemberWithAccuracy PtAct ListSlave Preci)
					(progn
						(setq NextPointMaster (NextPointOnList PtAct ListMaster Preci))
						(setq NextPointSlave  (NextPointOnList PtAct ListSlave Preci))
			
						(if (< (GetTurnAngle LastPt PtAct NextPointMaster) (GetTurnAngle LastPt PtAct NextPointSlave))
							(progn
								(setq Rtn (append Rtn (list NextPointMaster)))
							)
							(progn
								(setq Rtn (append Rtn (list NextPointSlave)))
								(setq Tmp ListMaster)
								(setq ListMaster ListSlave)
								(setq ListSlave Tmp)
							)
						)
						(setq LastPt PtAct)
						(setq PtAct (last Rtn))
					)
					(progn
						(setq LastPt PtAct)
						(setq PtAct (NextPointOnList PtAct ListMaster Preci))
						(setq Rtn (append Rtn (list PtAct)))
					)
				)
				;(princ Rtn) (getstring "<>")
				(if (equal (last Rtn) (car Rtn)) (setq Loop nil))
			)
			(RemoveCollinear-p Rtn Preci)
		)
	)
)
;
;(setq LstShapes '( ((50.0 100.0) (150.0 100.0) (150.0 200.0) (50.0 200.0) (50.0 100.0))
;					((50.0 0.0) (50.0 -100.0) (150.0 -100.0) (150.0 0.0) (50.0 0.0))
;					((100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0) (100.0 0.0))
;				  ))
;
;(setq LstShapes '( ((50.0 200.0) (150.0 200.0) (150.0 300.0) (50.0 300.0) (50.0 200.0))
;					((50.0 0.0) (50.0 -100.0) (150.0 -100.0) (150.0 0.0) (50.0 0.0))
;					((100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0) (100.0 0.0))
;				  ))
; (MergePoligons LstCoShapes 0.001)
;
;
;
(defun MergePoligons02 (LstCoShapes Preci Verbose / itm LstRegion EnamePoly Rtn)

	(if (and LstCoShapes Preci)
		(progn
			(foreach itm  LstCoShapes
				(setq EnamePoly (MakePolyline itm T))
				(setq LstRegion (append LstRegion (list (AddRegion EnamePoly))))
				(DeleteEntity (list EnamePoly))
			)
			(command "_Union" (LstEname->Ssget LstRegion) "")
			(setq Rtn (RegionToPolyLine (car LstRegion) T))
		)
	)
	Rtn
)
;
;
;
(defun MergePoligons (LstCoShapes Preci Verbose / MakeCombineList
												  LstChk Combine PosComb Pos1 Pos2 Rtn LstShapes itm)
	
	(defun MakeCombineList (LengthList / Pos Rtn)
		(setq Pos 0)
		(repeat LengthList
			(setq Rtn (append Rtn (list Pos)))
			(setq Pos (1+ Pos))
		)
		Rtn
	)
	;
	; Main
	;
	(if LstCoShapes
		(progn
			
			(setq LstChk (MakeCombineList (length LstCoShapes)))
			(setq Combine (CombineList LstChk 2))
			(setq PosComb 0)
			
			(while Combine
				(setq Pos1 (car  (nth PosComb Combine)))
				(setq Pos2 (cadr (nth PosComb Combine)))
				
				(if (setq Rtn (MergePoligon (nth Pos1 LstCoShapes) (nth Pos2 LstCoShapes) Preci))
					(progn
						(setq LstCoShapes (append LstcoShapes (list Rtn)))
						(setq LstCoShapes (LM:RemoveNth Pos1 (LM:RemoveNth Pos2 LstCoShapes)))
						(setq LstChk (MakeCombineList (length LstCoShapes)))
						(setq Combine (CombineList LstChk 2))
						(setq PosComb 0)
					)
					(progn
						(setq PosComb (1+ PosComb))
						(if (= PosComb (length Combine)) (setq Combine nil))
					)
				)
			)
			(if Verbose	(foreach itm LstCoShapes (MakePolyline itm T)))
		)
	)
	LstCoShapes
)
;
;
;
(defun MeregeShapes (LstEname Verbose / itm Rtn LstCoShapes Preci Rtn)

	(if LstEname
		(progn
			(setq Preci 0.001)
			(foreach itm LstEname
				(setq Rtn (DiscretizeShapeNoControl itm))
				(if (LM:ListClockwise-p Rtn)
					(progn
						(setq Rtn (reverse Rtn))
						(setq LstCoShapes (append LstCoShapes (list (append Rtn (list (car Rtn))))))
					)
					(setq LstCoShapes (append LstCoShapes (list (append Rtn (list (car Rtn))))))
				)
			)
			(setq Rtn (MergePoligons LstCoShapes Preci Verbose))
		)
	)
	Rtn
)
;
;
;
; (setq LstCoShape1 '((0.0 0.0) (100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0)))
; (setq LstCoShape2 '((50.0 50.0) (150.0 50.0) (150.0 150.0) (50.0 150.0) (50.0 50.0)))

; (setq LstCoShape1 '((0.0 0.0) (100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0)))
; (setq LstCoShape2 '((30.0 -30.0) (60.0 -30.0) (60.0 130.0) (30.0 130.0) (30.0 -30.0)))

; (setq LstCoShape1 '((0.0 0.0) (100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0)))
; (setq LstCoShape2 '((0.0 0.0) (100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0)))

; (setq LstCoShape1 '((0.0 0.0) (100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0)))
; (setq LstCoShape2 '((50.0 0.0) (100.0 0.0) (100.0 100.0) (50.0 100.0) (50.0 0.0)))

; (setq LstCoShape1 '((0.0 0.0) (100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0)))
; (setq LstCoShape2 '((100.0 100.0) (200.0 100.0) (200.0 200.0) (100.0 200.0) (100.0 100.0)))

; (setq LstCoShape1 '((0.0 0.0) (100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0)))
; (setq LstCoShape2 '((0.0 100.0) (100.0 100.0) (100.0 200.0) (0.0 200.0) (0.0 100.0)))

; (setq LstCoShape1 '((0.0 0.0) (100.0 0.0) (100.0 100.0) (0.0 100.0) (0.0 0.0)))
; (setq LstCoShape2 '((-50.0 100.0) (50.0 100.0) (50.0 200.0) (-50.0 200.0) (-50.0 100.0)))

; (SplitPoligon LstCoShape1 LstCoShape2 0.001)
(defun NONFUNZIONASplitPoligon (LstCoShape1 LstCoShape2 Preci / IntShape ClockWise MaxMinCo NextPointOnList PrevPointOnList GetTurnAngle 
													 RemoveCollinear-p IsCollinear PointInside RemoveFirstMemberListWithAccuracy StartPoint
													 LstIntersectionShape LstShape1 LstShape2 MaxMin Ray itm StPt
													 LstOutSidePoint
													 Loop LstTmp Rtn PtAct ListMaster ListSlave Tmp NextPoint PrevPoint)

	(defun IntShape (LstCoShape1 LstCoShape2 Preci / SortIntersectionSegment
													 AssocLst1 AssocLst2 Pos1 Pos2 Pt1 Pt2 Pt3 Pt4 PtInt Rtn)
	
		(defun SortIntersectionSegment (LstShape LstIntersection Preci / Pos itm itm1 LstCo LstDist Rtn)
		
			(if (and LstShape LstIntersection)
				(progn
					(setq Pos 0)
					(foreach itm LstShape
						(setq LstCo (list itm))
						
						(if (setq AssocLst (assoc Pos LstIntersection))
							(progn
								(setq LstDist nil)
								(foreach itm1 (cdr AssocLst)
									(setq LstDist (append LstDist (list (distance itm itm1))))
								)
								(foreach itm1 (vl-sort-i LstDist '<)
									(setq LstCo (append LstCo (list (nth itm1 (cdr AssocLst)))))
								)
							)
						)
						
						(setq Rtn (append Rtn LstCo))
						(setq Pos (1+ Pos))
					)
					(append (LM:UniqueFuzz Rtn Preci) (list (car Rtn)))
					;(append (LM:Unique Rtn) (list (car Rtn)))
				)
			)
		)
		;
		; Main +++++
		;
		(if (and LstCoShape1 LstCoShape2)
			(progn
				
				(setq Pos1 0)
				
				(repeat (- (length LstCoShape1) 1)
					(setq Pt1 (nth Pos1 LstCoShape1))
					(setq Pt2 (nth (1+ Pos1) LstCoShape1))
				

				
					;(setq AssocLst nil)
					(setq Pos2 0)					
					
					(repeat (- (length LstCoShape2) 1)
						(setq Pt3 (nth Pos2 LstCoShape2))
						(setq Pt4 (nth (1+ Pos2) LstCoShape2))
						
						(if (setq PtInt (inters pt1 pt2 pt3 pt4 T))
							(progn
								(if (assoc Pos1 AssocLst1)
									(setq AssocLst1 (subst (append (assoc Pos1 AssocLst1) (list Ptint)) (assoc Pos1 AssocLst1) AssocLst1))
									(setq AssocLst1 (append AssocLst1 (list (list Pos1 Ptint))))
								)
								(if (assoc Pos2 AssocLst2)
									(setq AssocLst2 (subst (append (assoc Pos2 AssocLst2) (list Ptint)) (assoc Pos2 AssocLst2) AssocLst2))
									(setq AssocLst2 (append AssocLst2 (list (list Pos2 Ptint))))
								)
							)
						)
						(setq Pos2 (1+ Pos2))
					)
					;(if AssocLst (setq Rtn (append Rtn (list (list Pos1 AssocLst)))))
					(setq Pos1 (1+ Pos1))
				)
			)
		)
		(list (SortIntersectionSegment LstCoShape1 AssocLst1 Preci) (SortIntersectionSegment LstCoShape2 AssocLst2 Preci))
		
	)
	;
	(defun CheckNearIntShape (LstCoShape1 LstCoShape2 LstCoIntShape1 LstCoIntShape2 Preci / itm)

		;(setq Rtn1 nil Rtn2 nil)
		
		(if (and LstCoShape1 LstCoShape2 LstCoIntShape1 LstCoIntShape2)
			(cond 
				((and (equal LstCoShape1 LstCoIntShape1 Preci) (equal LstCoShape2 LstCoIntShape2 Preci))
					(setq Rtn1 T Rtn2 T)
				)
				((equal LstCoShape1 LstCoIntShape1 Preci)
					(setq Rtn1 nil Rtn2 nil)
				)
				((equal LstCoShape2 LstCoIntShape2 Preci)
					(setq Rtn1 nil Rtn2 nil)
				)
				(T
					(foreach itm LstCoIntShape1
						(if (MemberWithAccuracy itm LstCoShape2 Preci)
							(setq Rtn1 T)
						)
					)
					(if Rtn1
						(foreach itm LstCoIntShape2
							(if (MemberWithAccuracy itm LstCoShape1 Preci)
								(setq Rtn2 T)
							)
						)
					)
				)
			)
		)
		(cond 
			((and Rtn1 Rtn2) T)
			(T nil)
		)
	)
	;
	(defun ClockWise ( p1 p2 p3 )
		(<  (* (- (car  p2) (car  p1)) (- (cadr p3) (cadr p1)))
			(* (- (cadr p2) (cadr p1)) (- (car  p3) (car  p1)))
		)
	)
	;
	(defun MaxMinCo (LstCoo)
		(list 	(list (apply 'min (mapcar 'car LstCoo))	(apply 'min (mapcar 'cadr LstCoo)))
				(list (apply 'max (mapcar 'car LstCoo))	(apply 'max (mapcar 'cadr LstCoo)))
		)
	)
	;
	(defun NextPointOnList (Pt LstPt Preci / NextNth NextPoint)
		(if (and Pt LstPt)
			(progn
				(setq NextNth   (+ (FindNthValToList LstPt Pt Preci) 1))
				(setq NextPoint (nth NextNth LstPt))
			)
		)
	)
	;
	(defun PrevPointOnList (Pt LstPt Preci / NextNth NextPoint)
		(if (and Pt LstPt)
			(progn
				(setq NextNth   (- (FindNthValToList LstPt Pt Preci) 1))
				(cond 
					((= NextNth -1)
						(setq NextPoint (nth (- (length LstPt) 2) LstPt))
					)
					(setq NextPoint (nth NextNth LstPt))
				)
			)
		)
	)
	;
	(defun GetTurnAngle (P1 P2 P3 / Ang)
		(if (and P1 P2 P3)
			(progn
				(setq Ang (CarnotAng P1 P2 P3))
				(cond
					((ClockWise P1 P2 P3)	
						Ang
					)
					(t
						(if (< Ang Pi)
							(- (* 2 pi) Ang)
							Pi
						)
					)
				)
			)
		)
	)
	;
	(defun RemoveCollinear-p (LstPt Accuracy / Loop Pos P1 P2 P3)
        (setq Loop T)
        (setq Pos 0)
        (if LstPt
            (while Loop
                (setq P1 (nth (+ Pos 0) LstPt))
                (setq P2 (nth (+ Pos 1) LstPt))
                (setq P3 (nth (+ Pos 2) LstPt))
                (if (and P1 P2 P3)
                    (progn
                        (if (LM:Collinear-p P1 P2 P3 Accuracy)
                            (progn
                                (setq LstPt (LM:RemoveNth (+ Pos 1) LstPt))
                                (setq LstPt (RemoveCollinear-p LstPt Accuracy))
                            )
                        )
                        (setq Pos (1+ Pos))
                    )
                    (setq Loop nil)
                )
            )
        )
        LstPt
    )
	;
	(defun IsCollinear (Pt LstCoo / Loop Pos Rtn)
	
		(if (and Pt LstCoo)
			(progn
				(setq Loop T
					  Pos 0
				)
				(while Loop
					(if (equal (+ (distance (nth Pos      LstCoo) Pt) 
								  (distance (nth (1+ Pos) LstCoo) Pt))
								  (distance (nth Pos      LstCoo) 
											(nth (1+ Pos) LstCoo)) 1e-8)
						(setq Rtn T Loop nil)
						(setq Pos (1+ Pos))
					)
					(if (= (1+ Pos) (length LstCoo)) (setq Loop nil))
				)
			)
		)
		Rtn
	)
	;
	(defun PointInside (Pt LstCoo Ray Flag Accuracy / xrandom yrandom PEnd PtInt LstInt Pos Rtn)
		;
		;
		(setq Pos 0)
		(cond
			((IsCollinear Pt LstCoo) ; punto nel contorno
				(if Flag
					(if (not (MemberWithAccuracy PtInt LstInt Accuracy)) 
						(setq LstInt (append LstInt (list PtInt)))
					)
				)
			)
			(T
				(setq xrandom 	(atof (Random_Str 5))
					  yrandom 	(+ (atof (Random_Str 5)) xrandom)
					  PEnd		(polar Pt (/ xrandom yrandom) (* 1.5 Ray))
				)
				(repeat (- (length LstCoo) 1)
					(if (setq PtInt (inters (nth Pos LstCoo) (nth (1+ Pos) LstCoo) Pt PEnd T))
						(if (not (MemberWithAccuracy PtInt LstInt Accuracy)) 
							(setq LstInt (append LstInt (list PtInt)))
						)
					)
					(setq Pos (1+ Pos))
				)

			)
		)
		(if LstInt
			(if (= (rem (length LstInt) 2) 0)
				nil
				T
			)
			nil
		)
	)
	;
	(defun RemoveFirstMemberListWithAccuracy (itm LstElement Preci)
		(if (setq NthItm (FindNthValToList LstElement itm Preci))
			(LM:RemoveNth NthItm LstElement)
		)
	)
	;
	(defun StartPoint (LstMaster LstOutSidePoint / PosNth)
	
		(if (and LstMaster LstOutSidePoint)
			(progn
				(setq PosNth 0)
				(while (IsCollinear (nth PosNth LstOutSidePoint) LstMaster)
					(setq PosNth (1+ PosNth))
				)
				(nth PosNth LstOutSidePoint)
			)
		)
	)
	;
	; Main ++++
	;
	; LstCoShape1-LstCoShape2
	;
	;(setq Preci 0.001)
	
	(if (setq LstIntersectionShape (IntShape LstCoShape1 LstCoShape2 Preci))
		(progn
			(setq LstShape1 (car  LstIntersectionShape))
			(setq LstShape2 (reverse (cadr LstIntersectionShape)))
			(setq MaxMin  	(MaxMinCo LstShape2))
			(setq Ray		(* (distance (car MAxMin) (cadr MaxMin)) 1.5))
		)
	)
	
	(if (not (CheckNearIntShape LstCoShape1 LstCoShape2 LstShape1 LstShape1 Preci))
	
	;(if (and LstShape1 LstShape2)
		(progn
			(foreach itm LstShape1
				(if (not (PointInside itm LstShape2 Ray nil Preci))
					(setq LstOutSidePoint (append LstOutSidePoint (list itm)))
				)
			)
			
			(while (setq StPt (StartPoint LstShape2 LstOutSidePoint))
				(setq Loop 	T)
				(setq LstTmp (list StPt))
				(setq PtAct  (car LstTmp))


				(setq ListMaster LstShape1)
				(setq ListSlave  LstShape2)

				(while Loop
					(if (MemberWithAccuracy PtAct ListSlave Preci)
						(progn
							; swap list
							(setq Tmp ListMaster)
							(setq ListMaster ListSlave)
							(setq ListSlave Tmp)
							(setq NextPoint (NextPointOnList PtAct ListMaster Preci))
							(setq PrevPoint (PrevPointOnList PtAct ListMaster Preci))
							
							(if (> (GetTurnAngle LastPoint PtAct NextPoint) (GetTurnAngle LastPoint PtAct PrevPoint))
								(setq LstTmp (append LstTmp (list NextPoint)))
								(setq LstTmp (append LstTmp (list PrevPoint)))
							)
							(setq LastPoint PtAct)
							(setq PtAct (last LstTmp))
						)
						(progn
							(setq LastPoint PtAct)
							(setq PtAct (NextPointOnList PtAct ListMaster Preci))
							(setq LstTmp (append LstTmp (list PtAct)))
							;(princ LstTmp) (getstring "<00>")
						)
					)
					(if (equal (car LstTmp) (last LstTmp))
						(progn
							(setq Loop nil)
							(setq Rtn (append Rtn (list LstTmp)))
						)
					)
					;(princ LstTmp) (getstring "<0>")
				)
				;(getstring "<1>") (princ Rtn) (getstring "<1>")
				(foreach itm LstTmp (setq LstOutSidePoint (RemoveFirstMemberListWithAccuracy itm LstOutSidePoint Preci)))
			)
		)
	)
	Rtn
)
;
;
;
(defun AssemblyPoligons (LstCooShapes Discretize Preci Verbose / itm LstEnamePolyMarge LstCoo
															   MaxRectangle LstEnameMaxRect EnameRect)
	
	;
	; Main
	;
	(if (and LstCooShapes Discretize Preci)
		(progn
			(setq LstEnamePolyMarge (MergePoligons02 LstCooShapes Preci nil))
			;
			(StartProgressBar "Merge Scrap" (length LstEnamePolyMarge))
			(foreach itm LstEnamePolyMarge
				(UpDateProgressBar)
				(setq LstCoo (InfillingShape itm Discretize Preci))
				(setq MaxRectangle (MaxRectangleOnPoligon (append LstCoo (list (car LstCoo))) Verbose))
				(setq EnameRect (MakeRectangle02 (car MaxRectangle) (cadr MaxRectangle)))
				(redraw EnameRect 3) 
				(setq LstEnameMaxRect (append LstEnameMaxRect (list EnameRect)))
			)
			(ClearProgressBar)
		)
	)
	(DeleteEntity LstEnamePolyMarge)
	LstEnameMaxRect
)
;
;
;
(defun PoligonToRectangle (LstCooShapes Discretize Preci Verbose / GetDimensionDummy GetOriginShape
												itm Ori Rect Rtn)

	(defun GetDimensionDummy (EnameDummyShape / Width Height Rtn)

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
	(defun GetOriginShape (EnameDummyShape / Rtn)
		(if EnameDummyShape
			(progn
				(vla-getboundingbox (vlax-ename->vla-object EnameDummyShape) 'mnl 'mxl)
				(setq Rtn (vlax-safearray->list mnl))
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if (and LstCooShapes Discretize Preci)
		(progn
			(foreach itm (AssemblyPoligons LstCooShapes Discretize Preci Verbose)
				(setq Ori	(GetOriginShape    itm))
				(setq Rect	(GetDimensionDummy itm))
				(setq Rtn 	(append Rtn (list (list Rect Ori))))
				(DeleteEntity (list itm))
			)
		)
	)
	Rtn
)
;
