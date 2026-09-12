(defun TsEasyCut()
	(CreateSheet)
)
;
; Gui Sheet ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GuiTecnoSheet (EnameSheet / 	GetDataSheetDcl 
									LstDataSheet xx Loop
									IdSheet$ NameSheet$ WidthSheet$ HeightSheet$ ThickSheet$
									SurfaceSheet$ WeightSheet$ MatSheet$ Rtn)


	(defun GetDataSheetDcl (/ MemeberStr NameSheet WidthSheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet Rtn LstName)

	
		(defun MemeberStr (Str LstStr / itm Rtn)
	
			(if (and Str LstStr)
				(progn
					(foreach itm LstStr
						(if (= (strcase itm) (strcase Str))
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
		(setq IdSheet       (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "idsheet")))) 
		(setq NameSheet     (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "namesheet"))))
		(setq WidthSheet    (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "widthsheet"))))
		(setq HeightSheet   (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "heightsheet"))))
		(setq ThickSheet    (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "thicksheet"))))
		(setq SurfaceSheet  (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "surfacesheet"))))
		(setq WeightSheet   (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "weightsheet"))))
		(setq MatSheet      (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "matsheet"))))
	
		(if (= NameSheet "")   (alert "Inserire nome lamiera")		(setq NameSheet$ 	NameSheet))
		(if (= ThickSheet "")  (alert "Inserire spessore lamiera")	(setq ThickSheet$ 	ThickSheet))
		(if (= MatSheet "")    (alert "Inserire qualita' lamiera")	(setq MatSheet$ 	MatSheet))
		(if (= WidthSheet "")  (alert "Inserire larghezza lamiera")	(setq WidthSheet$ 	WidthSheet))
		(if (= HeightSheet "") (alert "Inserire lunghezza lamiera")	(setq WidthSheet$ 	WidthSheet))
		
		
		(if (and (/= NameSheet "") (/= ThickSheet "")  (/= MatSheet "") (/= WidthSheet "") (/= HeightSheet ""))
			(progn
				(setq LstName   (GetListNameSheet))
				(setq LstName 	(vl-remove NameSheet LstName))
				(if (MemeberStr NameSheet LstName)
					(alert (strcat "Nome lamiera [" NameSheet "] esistente"))
					(setq Rtn (list IdSheet NameSheet WidthSheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet))
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if EnameSheet
		(progn
			(setq LstDataSheet (GetDataSheetByEname EnameSheet))
			(if LstDataSheet
				(progn
				
					;(IdSheet NameSheet Widthsheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet))
					
					(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
					(new_dialog "GeoSheet" xx "" (cond ( *GeoSheet* ) ( '(-1 -1) )))
			
					(set_tile "idsheet"			(nth 0 LstDataSheet)) 
					(set_tile "surfacesheet"	(nth 5 LstDataSheet))
					(set_tile "weightsheet"		(nth 6 LstDataSheet))
					
					(if NameSheet$   (set_tile "namesheet"	 NameSheet$) 	(set_tile "namesheet"	(nth 1 LstDataSheet)))
					(if MatSheet$    (set_tile "matsheet"	 MatSheet$) 	(set_tile "matsheet"	(nth 7 LstDataSheet)))
					(if ThickSheet$  (set_tile "thicksheet"	 ThickSheet$) 	(set_tile "thicksheet"	(nth 4 LstDataSheet)))
					(if WidthSheet$  (set_tile "widthsheet"	 WidthSheet$)	(set_tile "widthsheet"	(nth 2 LstDataSheet)))
					(if HeightSheet$ (set_tile "heightsheet" HeightSheet$)	(set_tile "heightsheet" (nth 3 LstDataSheet)))

					(if (IsRectangle EnameSheet)
						(progn
							(mode_tile "widthsheet"		0)
							(mode_tile "heightsheet"	0)
						)
						(progn
							(mode_tile "widthsheet"		1)
							(mode_tile "heightsheet"	1)
						)
					)
										
					(mode_tile "idsheet"		1)
					(mode_tile "surfacesheet"	1)
					(mode_tile "weightsheet"	1)
	
					; azioni

					(action_tile "cancel"   "(setq Rtn nil)               (setq *GeoSheet* (done_dialog))")
					(action_tile "apply"    "(setq Rtn (GetDataSheetDcl)) (setq *GeoSheet* (done_dialog))")
					(action_tile "select"   "(setq Rtn T)                 (setq *GeoSheet* (done_dialog))")

					(start_dialog)
			
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GuiCreateSheet (/ GetDataSheetDcl
						 xx Loop ModSh 
						 IdSheet
						 IdSheet$ NameSheet$ WidthSheet$ HeightSheet$ ThickSheet$
						 SurfaceSheet$ WeightSheet$ MatSheet$ LstIdSheet Rtn)


	(defun GetDataSheetDcl (/ MemeberStr 
							  IdSheet NameSheet WidthSheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet Rtn LstName)

	
		(defun MemeberStr (Str LstStr / itm Rtn)
	
			(if (and Str LstStr)
				(progn
					(foreach itm LstStr
						(if (= (strcase itm) (strcase Str))
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
		(setq IdSheet       (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "idsheet")))) 
		(setq NameSheet     (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "namesheet"))))
		(setq WidthSheet    (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "widthsheet"))))
		(setq HeightSheet   (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "heightsheet"))))
		(setq ThickSheet    (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "thicksheet"))))
		(setq MatSheet      (vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "matsheet"))))

		(if (= HeightSheet "") (alert "Inserire larghezza lamiera")	(setq HeightSheet$ 	HeightSheet))
		(if (= WidthSheet "")  (alert "Inserire altezza lamiera")	(setq WidthSheet$	WidthSheet))
		(if (= ThickSheet "")  (alert "Inserire spessore lamiera")	(setq ThickSheet$	ThickSheet))
		(if (= NameSheet "")   (alert "Inserire nome lamiera")		(setq NameSheet$	NameSheet))
		(if (= MatSheet "")    (alert "Inserire qualita' lamiera")	(setq MatSheet$		MatSheet))
	
		(if (and (/= NameSheet "") (/= ThickSheet "")  (/= MatSheet "") (/= HeightSheet "") (/= WidthSheet ""))
			(progn
				(setq LstName   (GetListNameSheet))
				(if (MemeberStr NameSheet LstName)
					(alert (strcat "Nome lamiera [" NameSheet "] esistente"))
					(progn
						(setq SurfaceSheet (rtos (/ (* (atof HeightSheet) (atof WidthSheet)) 1000000.0) 2 2))
						(setq WeightSheet  (rtos (* (* 7.85 (atof SurfaceSheet)) (atof ThickSheet)) 2 2))
						(setq Rtn (list IdSheet NameSheet WidthSheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet))
					)
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq LstIdSheet (GetListIdSheet))
	(setq Loop T)
	(while Loop
		(if (not (member (setq IdSheet (Random_Str 5)) LstIdSheet))
			(progn
				(setq LstIdSheet (append LstIdSheet (list IdSheet)))
				(setq Loop nil)
			)
		)
	)
	;
	;
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq Loop T)
	(while Loop
		(new_dialog "info_lam" xx "" (cond ( *info_lam* ) ( '(-1 -1) )))
	
		(if IdSheet$		(set_tile "idsheet"			IdSheet$)		(set_tile "idsheet"	IdSheet))
		(if NameSheet$		(set_tile "namesheet"		NameSheet$))
		(if WidthSheet$		(set_tile "widthsheet"		WidthSheet$))
		(if HeightSheet$	(set_tile "heightsheet"		HeightSheet$))
		(if ThickSheet$		(set_tile "thicksheet"		ThickSheet$))
		(if MatSheet$		(set_tile "matsheet"		MatSheet$))
				
		(mode_tile "idsheet"		1)
		(mode_tile "surfacesheet"	1)
		(mode_tile "weightsheet"	1)
		
		; azioni
					
		(action_tile "accept"   (strcat "(setq ModSh T Rtn (GetDataSheetDcl)) (setq *info_lam* (done_dialog))"))
		(action_tile "cancel"   (strcat "(setq Loop nil) (setq *info_lam* (done_dialog)) (unload_dialog xx)"))
		(start_dialog)
		
		(if ModSh (if Rtn (setq Loop nil) (setq ModSh nil)))
	)
	(redraw)
	Rtn
)
;
;
;
(defun GuiStockSheet (/ IfExistStockSheet AddStockList UpdateInofStock RemoveStockList
						stock_lam MakeStock StockList Rtn)

	;
	;
	;
	(defun IfExistStockSheet (StockName / LstName itm SplitStock Conta NameStock Rtn)
	
		(if StockName
			(progn
		
				(setq LstName (GetListNameSheet))
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
		(setq MatSheet    (vl-string-right-trim  " " (vl-string-left-trim " " (strcase (get_tile "matsheet")))))
		
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
	(defun UpdateInofStock (StockList / IdSelect LstData)
	
		(if StockList
			(progn
				(setq IdSelect (get_tile "box_info"))
				(if (/= IdSelect "")
					(progn
						(setq LstData (nth (atoi IdSelect) StockList))
						(princ LstData)
						(set_tile "namesheet"   (nth 1 (LM:str->lst (nth  0 LstData) "_")))
						(set_tile "widthsheet"  (nth 1 LstData))
						(set_tile "heightsheet" (nth 2 LstData))
						(set_tile "thicksheet"  (nth 3 LstData))
						(set_tile "qtasheet"    (nth 4 LstData))
						(set_tile "matsheet"    (nth 5 LstData))
					)
				)
			)
		)
	)
	;
	;
	;
	(defun RemoveStockList (StockList / IdSelect itm)
	
		(if StockList
			(progn
				(setq IdSelect (get_tile "box_info"))
				(if (/= IdSelect "")
					(progn
						(setq StockList (LM:RemoveNth (atoi IdSelect) StockList))
						(start_list "box_info")
						(if StockList
							(foreach itm StockList
								(add_list (strcat (nth 0 itm) "\t" (nth 1 itm) "\t" (nth 2 itm) "\t" (nth 3 itm) "\t" (nth 4 itm) "\t" (nth 5 itm)))
							)
							(add_list "")
						)
						(end_list)
					)
				)
			)
		)
		StockList
	)
	;
	; procedura genera/modifica stock lamiera
	;
	(setq stock_lam (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	
	
		(new_dialog "stock_lam" stock_lam "" (cond ( *stock_lam* ) ( '(-1 -1) )))
		
		; azioni
		
		(action_tile "box_info"		  "(UpdateInofStock StockList)")
		(action_tile "cancel"         "(setq *stock_lam* (done_dialog)) (unload_dialog stock_lam)")
		(action_tile "addstock"       "(setq StockList (AddStockList    StockList))")
		(action_tile "removestock"    "(setq StockList (RemoveStockList StockList))")
		(action_tile "createstock"    "(setq MakeStock T *stock_lam* (done_dialog)) (unload_dialog stock_lam)")
		(start_dialog)
		
		(if MakeStock 
			StockList
			nil
		)
)
;
;
;
(defun GuiRegionToSheet (EnameRegion / LstEname Loop Picked LstPicked Ename TypUpdate Rtn)

	(if EnameRegion
		(progn
			(setq LstEname (RegionToPolyLine EnameRegion nil))
			(if LstEname
				(if (= (length LstEname) 1)
					(progn
						(entdel EnameRegion)
						(TcEasyCut (car LstEname))
					)
					(progn
						(DeleteEntity LstEname)
						(LM:popup "Errore" "Impossibile generare la lamiera\nLamiera con contorni interni" (+ 0 16 4096))
					)
				)
			)
		)
	)
)
;
; Update Sheet ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun UpDateSheet (EnameSheet TypeUpdate / Rtn EnameSheet DataInfoBlock LstEnameRule)

	(cond
		((= TypeUpdate 200) 
			(setq Rtn (GuiTecnoSheet EnameSheet))
			(if (= (type Rtn) 'LIST)
				(progn
					(UpdateInfoSheet EnameSheet Rtn)
					(if (setq EnameBom (GetEnameBlockSheetByEnameSheet EnameSheet))
						(UpdateFormSheet EnameSheet)
						(progn
							(setq LstEnameRule (PrintRuleSheet EnameSheet))
							(LogoSheet EnameSheet LstEnameRule)
						)
					)
					(setq Rtn EnameSheet)
				)
			)
		)
		((= TypeUpdate 2)
			(vla-StartUndoMark 	(vla-get-activedocument (vlax-get-acad-object)))
			(setq EnameSheet	(SetSheet EnameSheet))
			(setq Rtn        	(GuiTecnoSheet EnameSheet))
			(vla-EndUndoMark 	(vla-get-activedocument (vlax-get-acad-object)))	
			(if (= (type Rtn) 'LIST)
				(progn
					(UpdateInfoSheet EnameSheet Rtn)
					(setq LstEnameRule (PrintRuleSheet EnameSheet))
					(LogoSheet EnameSheet LstEnameRule)
					(setq Rtn EnameSheet)
				)
				(command "_undo" "1")
			)
		)
	)
	(Regen_)
	Rtn
)
;
;
;
(defun UpDateSheetByBlock (EnameBlock / DataInfoBlock EnameSheet Rtn)

		(setq DataInfoBlock (GetInfoBlockSheet EnameBlock))
		(setq EnameSheet (GetEnameSheetById (car DataInfoBlock)))
		(setq Rtn (GuiTecnoSheet EnameSheet))
		(if (= (type Rtn) 'LIST)
			(progn
				(UpdateInfoSheet EnameSheet Rtn)
				(setq Rtn (UpdateFormSheet EnameSheet))
			)
		)
		(Regen_)
		Rtn
)
;
;
;
(defun UpdateInfoSheet (EnameSheet LstInfoDcl / NewNameSheet NewIdSheet NewTkSheet NewMatSheet
												pmnl pmxl Widthsheet Heightsheet Dx Dy p1 p2 p3 mnl mxl EnameRule IdRule LstVert)


		;0	"idsheet"
		;1	"namesheet"
		;2	"widthsheet"
		;3	"heightsheet"
		;4	"thicksheet"
		;5	"surfacesheet"
		;6	"weightsheet"
		;7	"matsheet"

		(if (and EnameSheet LstInfoDcl)
			(progn
					
				(setq NewNameSheet   		(nth 1 LstInfoDcl))
				(setq NewIdSheet   			(nth 0 LstInfoDcl))
				(setq NewTkSheet   			(nth 4 LstInfoDcl))
				(setq NewMatSheet   		(nth 7 LstInfoDcl))
				(ChangeRecordSheet EnameSheet 1 NewNameSheet)
				(ChangeRecordSheet EnameSheet 2 NewIdSheet)
				(ChangeRecordSheet EnameSheet 3 NewTkSheet)
				(ChangeRecordSheet EnameSheet 4 NewMatSheet)
					
				(if (/= NewTkSheet "")
					(progn
						(setq ColorSheet (set_color NewTkSheet))
						(ChangeColor EnameSheet (nth 0 ColorSheet) (nth 1 ColorSheet))
					)
				)
				
				; change dimension sheet
				
				(if (IsRectangle EnameSheet)
					(progn
						
						(vla-getboundingbox (vlax-ename->vla-object EnameSheet) 'mnl 'mxl)
						(setq pmnl (vlax-safearray->list mnl))
						(setq pmxl (vlax-safearray->list mxl))
		
						(setq Widthsheet   (abs (- (nth 0 pmxl) (nth 0 pmnl))))
						(setq Heightsheet  (abs (- (nth 1 pmxl) (nth 1 pmnl))))
						(setq Dx (- (atof (nth 2 LstInfoDcl)) Widthsheet))
						(setq Dy (- (atof (nth 3 LstInfoDcl)) Heightsheet))
				
						(setq p1 (list (+ (nth 0 pmxl) Dx) (nth 1 pmnl)))
						(setq p2 (list (+ (nth 0 pmxl) Dx) (+ (nth 1 pmxl) Dy)))
						(setq p3 (list (nth 0 pmnl)        (+ (nth 1 pmxl) Dy)))
						
						;(movevertex (vlax-ename->vla-object EnameSheet) 1 p1)
						;(movevertex (vlax-ename->vla-object EnameSheet) 2 p2)
						;(movevertex (vlax-ename->vla-object EnameSheet) 3 p3)
						
						(setq LstVert (GetCoordinateDummyEname EnameSheet))
						(movevertex (vlax-ename->vla-object EnameSheet) (FindNthValToList LstVert (list (nth 0 pmxl) (nth 1 pmnl)) 0.01) p1)
						(movevertex (vlax-ename->vla-object EnameSheet) (FindNthValToList LstVert (list (nth 0 pmxl) (nth 1 pmxl)) 0.01) p2)
						(movevertex (vlax-ename->vla-object EnameSheet) (FindNthValToList LstVert (list (nth 0 pmnl) (nth 1 pmxl)) 0.01) p3)
					)
				)
			)
		)
		(Regen_)
)
;
;
;
(defun UpdateFormSheet (EnameSheet / DataSheet EnameBomSheet NameBomSheet EnameRule EnameBom)
      
	(if EnameSheet
		(progn
		
			;(setq EnameRule  (GetEnameRuleByEnameSheet EnameSheet))
			;(setq IdRule     (GetIdRule EnameRule))
			;(EnameSheet->UpdateBlockInfoSheet EnameSheet)
			;(entdel EnameRule)
			;(PurgeBlock (strcat $RgpRule "_" IdRule))
			;(PrintRuleSheet EnameSheet)
			
			
			(setq DataSheet     (GetDataSheetByEname EnameSheet))
			(setq EnameBomSheet (GetEnameBlockSheetById (car DataSheet)))
			(setq NameBomSheet  (LM:al-effectivename EnameBomSheet))
			(entdel EnameBomSheet)
			(PurgeBlock NameBomSheet)
			(setq EnameRule  (PrintRuleSheet EnameSheet))
			(setq EnameBom   (LogoSheet EnameSheet EnameRule))
			(EnameSheet->UpdateBlockInfoSheet EnameSheet)
			(Regen_)
			EnameBom
		)
	)
)
;
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
;(defun SelectSheet (EnameSheet)
;
;	(if EnameSheet
;			(ssadd EnameSheet (ssadd))
;	)
;)
;
;
;
(defun FilterLstEnameSequenceByDataSelectWithFilterSetup (EnameSheet LstEnameSequence / CheckZoom Sheet Ssel LstEnameFiltered itm Rtn)

	(if (and EnameSheet LstEnameSequence)
		(progn
			(setq CheckZoom (VisibleEname EnameSheet))
			;(setq Sheet (DiscretizeShape EnameSheet))
			(setq Sheet (DiscretizeShapeNoControl EnameSheet))
			;(setq Ssel  (ssget "_CP" Sheet (GetDataSelectWithFilterSetup)))
			(setq Ssel  (SsgetWithFilterSetup "_CP" Sheet (GetDataSelectWithFilterSetup)))
			(if Ssel
				(progn
					(setq LstEnameFiltered (LM:ss->ent Ssel))
					(foreach itm LstEnameSequence
						(if (member itm LstEnameFiltered)
							(setq Rtn (append Rtn (list itm)))
						)
					)
				)
			)
			(ZoomPrevius CheckZoom)	
		)
	)
	Rtn
)
;
;
;
(defun CreateStockSheet (/ Rtn GetInsSheet)

		(setq Rtn (GuiStockSheet))
		(if Rtn
			(progn
				(setq GetInsSheet (getpoint "\nPunto basso/sx inserimento lamiera .....="))
				(MakeStockSheet GetInsSheet Rtn)
				(Regen_)
			)
		)
)
;
;
;
(defun CreateSheet (/ Rtn GetInsSheet)

	(setq Rtn (GuiCreateSheet))
	(if Rtn 
		(progn
			(setq GetInsSheet (getpoint "\nPunto basso/sx inserimento lamiera .....="))
			(MakeSheet Rtn GetInsSheet T)
			(Regen_)
		)
	)
)
;
;
;
(defun EnameSheet->UpdateBlockInfoSheet (EnameSheet / DataInfoSheet EnameBlockSheet pmnl pmxl WidthSheet HeightSheet Find)

	(if EnameSheet
		(progn
			(setq DataInfoSheet (GetDataSheetByEname EnameSheet))
			;	0		1			2			3			4			5			6			7
			;(IdSheet NameSheet Widthsheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet)
			;
			(setq Find nil)
			(if DataInfoSheet
				(progn
					;(setq LstBlk (GetLstBlock NameBlockSheet$))
					(if (setq EnameBlockSheet (GetEnameBlockSheetById (car DataInfoSheet)))
						(progn
							(setq Find T)
							(vla-getboundingbox (vlax-ename->vla-object EnameSheet) 'mnl 'mxl)
							(setq pmnl			(vlax-safearray->list mnl))
							(setq pmxl 			(vlax-safearray->list mxl))
							(setq WidthSheet   	(rtos (abs (- (nth 0 pmxl) (nth 0 pmnl))) 2 1))
							(setq HeightSheet  	(rtos (abs (- (nth 1 pmxl) (nth 1 pmnl))) 2 1))
								
								
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockSheet) "ID_SHEET" 		(nth 0  DataInfoSheet))
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockSheet) "NAME_SHEET" 		(nth 1  DataInfoSheet))
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockSheet) "THICKNESS_SHEET"	(nth 4  DataInfoSheet))
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockSheet) "MATERIAL_SHEET"	(nth 7  DataInfoSheet))
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockSheet) "DIMENSION_SHEET"	(strcat WidthSheet "x" HeightSheet))
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
(defun LogoSheet (EnameSheet EnameRule / DataSheet DimSheet MatSheet ThkSheet NameSheet IDSheet NameRule Ssel
										Px BlockName EnameBlock ultent xd_list nuova_entita OffsetLogo ObjBlock)

		(setq OffsetLogo 0.0)
		(if (and EnameSheet EnameRule)
			(progn
				(setq DataSheet (GetDataSheetByEname EnameSheet))
				;	0		1			2			3			4			5			6			7
				;(IdSheet NameSheet Widthsheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet)
				;
				(setq DimSheet  (strcat (nth 2 DataSheet) "x" (nth 3 DataSheet)))
				(setq MatSheet  (nth 7 DataSheet))
				(setq ThkSheet  (nth 4 DataSheet))
				(setq NameSheet (nth 1 DataSheet))
				(setq IDSheet   (nth 0 DataSheet))
				
				(vla-getboundingbox (vlax-ename->vla-object EnameSheet) 'mnl 'mxl)
				(setq Px (vlax-safearray->list mnl))
				
				(setq BlockName     (strcat LibPathEasyCut$ FileBlockSheet$))
				(setq ObjBlock 	    (InsertBlock BlockName Px nil))
				(AttributeFill      ObjBlock (list DimSheet ThkSheet NameSheet IDSheet MatSheet))
				;(command "._-insert" BlockName Px 1.0 1.0 0 DimSheet ThkSheet NameSheet IDSheet MatSheet)
				;(setq EnameBlock (entlast))
				(setq EnameBlock (vlax-vla-object->ename ObjBlock))
				(setq ultent  (entget EnameBlock))
				(setq xd_list (list '(1002 . "}")))
				(setq xd_list (cons '(1002 . "{")  xd_list))
				(setq xd_list (cons $RgpSheetTarget xd_list))
				(setq xd_list (list -3 xd_list))
				(setq nuova_entita (append ultent (list xd_list)))
				(entmod nuova_entita)
				(entupd EnameBlock)
				; New Add +++++++++++++++++++++++++++++++++++++++++++++
				;(setq NameRule (LM:al-effectivename EnameRule))
				(MakeLabelSheet EnameBlock EnameRule)
				;(PurgeBlock NameRule)
				; +++++++++++++++++++++++++++++++++++++++++++++++++++++
			)
		)
		EnameBlock
)
;
;
;
(defun MakeLabelSheet (EnameBomSheet SselRule / IdSheet NameLabel)
	(if (and EnameBomSheet SselRule)
		(progn
			(setq IdSheet (LM:vl-getattributevalue (vlax-ename->vla-object EnameBomSheet) "ID_SHEET"))
			(setq NameLabel (strcat "LogoSheet_" IdSheet))
			(PurgeBlock NameLabel)
			(RenameNameBlock EnameBomSheet NameLabel)
			(LM:AddObjectstoBlock EnameBomSheet SselRule)
		)
	)
	EnameBomSheet
)
;
;
;
(defun ChangeRecordSheet (EnameSheet IdRecord NewRecord / NameSheet IdSheet ThkSheet MatSheet IdRecord ultent xd_list nuova_entita Rtn conta loop itm)
	
		(if (and EnameSheet IdRecord NewRecord)
			(if (assoc -3 (entget EnameSheet (list "*")))
				(if (= (nth 0 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))) $RgpSheet)			
					(progn

						; (-3 ("LAMIERA" (1002 . "{") 
						;                   (1000 . nome lamiera  			-valore stringa-)
						;                   (1000 . id lamiera    			-valore stringa-)
						;                   (1000 . spessore lamiera    	-valore stringa-)
						;                   (1000 . materiale 		    	-valore stringa-)
						;                   (1000 . tipo sequenza 	   		-valore stringa-)
						;                   (1000 . nome gruppo contorno 1  -valore stringa-)
						;                   (1000 . nome gruppo contorno 2  -valore stringa-)
						;                   (1000 . nome gruppo contorno 3  -valore stringa-)
						;                   (1002 . "}") 
						;     )
						; )
					
						(setq NameSheet (cdr (nth 2 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))))) ; 1
						(setq IdSheet   (cdr (nth 3 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))))) ; 2
						(setq ThkSheet  (cdr (nth 4 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))))) ; 3
						(setq MatSheet  (cdr (nth 5 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))))) ; 4
						; check other
						(setq conta 6)
						(setq Rtn nil loop T)
						(while loop
							(setq Data (cdr (nth conta (nth 1 (assoc -3 (entget EnameSheet (list "*")))))))
							(if (= Data "}")
								(setq loop nil)
								(setq Rtn (append Rtn (list Data)))
							)
							(setq conta (1+ conta))
						)						
						; ++++++++++++++
						
						(cond 
							((= IdRecord 1) (setq NameSheet  NewRecord))
							((= IdRecord 2) (setq IdSheet    NewRecord))
							((= IdRecord 3) (setq ThkSheet   NewRecord))
							((= IdRecord 4) (setq MatSheet   NewRecord))
						)
						
						(setq ultent    (entget EnameSheet)
							  xd_list (list '(1002 . "}"))
						)
						(if Rtn
							(foreach itm (reverse Rtn)
								(setq xd_list (cons (cons 1000 itm) xd_list))
							)
						)	
						(setq xd_list (cons (cons 1000 MatSheet)  xd_list)
							  xd_list (cons (cons 1000 ThkSheet)  xd_list)
							  xd_list (cons (cons 1000 IdSheet)   xd_list)
							  xd_list (cons (cons 1000 NameSheet) xd_list)
						)
						(setq xd_list (cons '(1002 . "{") xd_list)
							  xd_list (cons $RgpSheet xd_list)
							  xd_list (list -3 xd_list)
							  nuova_entita (append ultent (list xd_list))
						)
						(entmod nuova_entita)
						(entupd EnameSheet)
					)
				)
			)
		)
)
;
;
;
(defun SetSheet (EnameSheet / Rtn Name Mat Tk)

	(if EnameSheet
		(progn
			(setq Ename (UpdateEntityType (list EnameSheet)))
			(if (IntegrityGeometricalShape Ename)
				(progn
					(if (CheckIfEasyCutSheet EnameSheet)
						(progn
							(setq Name	(GetNameSheet EnameSheet))
							(setq Mat	(GetMatSheet  EnameSheet))
							(setq Tk 	(GetTkSheet   EnameSheet))
						)
						(progn
							(setq Name	"---")
							(setq Mat	"---")
							(setq Tk	"---")
						)
					)
					(setq Rtn (AssignNameSheet (car Ename) (list	Name 	 	;nome lamiera
																	Tk 	 		;spessore lamiera
																	Mat)) 		;qualita lamiera
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
(defun CloneSheet (EnameMaster EnameSlave / LstDataSheet Rtn)

	(if (and EnameMaster EnameSlave)
		(progn
			(setq LstDataSheet (GetDataSheetByEname EnameMaster)) ; ("56615" "jjjj" "2500" "5000" "10" "12.5" "981.25" "àààà")
			(setq Rtn          (AssignNameSheet EnameSlave (list (nth 1 LstDataSheet) (nth 4 LstDataSheet) (nth 7 LstDataSheet))))
		)
	)
	Rtn
)
;
;
;
(defun AssignNameSheet (EnameSheet RecordSheet / ultent xd_list nuova_entita ColorSheet)

	(if (and EnameSheet RecordSheet)
		(progn
			;	0			1		2
			;(NameSheet ThkSheet MatSheet)
			(setq ultent (entget EnameSheet)
				xd_list (list '(1002 . "}"))
				xd_list (cons (cons 1000 (nth 2 RecordSheet))  xd_list) ; materiale
				xd_list (cons (cons 1000 (nth 1 RecordSheet))  xd_list) ; spessore
				xd_list (cons (cons 1000 (Random_Str 5))   	   xd_list) ; id
				xd_list (cons (cons 1000 (nth 0 RecordSheet))  xd_list) ; nome
				xd_list (cons '(1002 . "{") xd_list)
				xd_list (cons $RgpSheet xd_list)
				xd_list (list -3 xd_list)
				nuova_entita (append ultent (list xd_list))
			)
			(entmod nuova_entita)
			(entupd EnameSheet)
			(if (/= (nth 1 RecordSheet) "")
				(progn
					(setq ColorSheet (set_color (nth 1 RecordSheet)))
					(ChangeColor EnameSheet (nth 0 ColorSheet) (nth 1 ColorSheet))
				)
			)
		)
	)
	EnameSheet
)
;
;
;
(defun MakeSheet (DataSheet Px Rotate / IdSheet NameSheet WidthSheet HeightSheet 
										ThkSheet SurfaceSheet WeightSheet MatSheet DimSheet
										xstart ystart x1 y1 x2 y2 x3 y3 x4 y4 mspace anarray myobj EnameRule Tmp)
		;				0		1			2			3		4			5		       6        7
		;DataSheet = IdSheet NameSheet WidthSheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet
		;
		(setq IdSheet   	(nth 0 DataSheet))
		(setq NameSheet 	(nth 1 DataSheet))
		(setq WidthSheet 	(nth 2 DataSheet))
		(setq HeightSheet 	(nth 3 DataSheet))
		(setq ThkSheet  	(nth 4 DataSheet))
		(setq SurfaceSheet	(nth 5 DataSheet))
		(setq WeightSheet 	(nth 6 DataSheet))
		(setq MatSheet  	(nth 7 DataSheet))
		
		(if Rotate
			(if (> (atof WidthSheet) (atof HeightSheet))
				(progn
					(setq Tmp WidthSheet		)
					(setq WidthSheet HeightSheet)
					(setq HeightSheet Tmp		)
				)
			)
		)
		
		(setq DimSheet  (strcat WidthSheet "x" HeightSheet))
		
		(setq 	xstart (nth 0 px)
				ystart (nth 1 px)
				x1 xstart
				y1 ystart
				x2 (+ x1 (atof WidthSheet))
				y2 y1
				x3 x2
				y3 (+ y2 (atof HeightSheet))
				x4 x1
				y4 y3
		)
		
		(setq mspace (vla-get-modelSpace (vla-get-activeDocument (vlax-get-acad-object))))
		(setq arraypt (list x1 y1 x2 y2 x3 y3 x4 y4))
		(setq anarray (vlax-make-safearray vlax-vbDouble '(0 . 7)))
		(vlax-safearray-fill anarray arraypt)
		(setq myobj (vla-addLightweightPolyline mspace anarray))
		(vla-put-Closed myobj :vlax-true)

		(AssignNameSheet (vlax-vla-object->ename myobj) (list NameSheet ThkSheet MatSheet))
		(setq EnameRule (PrintRuleSheet (vlax-vla-object->ename myobj)))
		(LogoSheet (vlax-vla-object->ename myobj) EnameRule)
)
;
;
;
(defun MakeStockSheet (Px LstInfoStock / Conta itm MargineX MargineY PStartStockSheet NameSheet Loop IdSheet LstIdSheet Pinsert)
		;		0		  1		  2		3	4		5	
		; (("STOCK_FFF" "2500" "5000" "10" "11" "ascasda"))
		;				0		1			2			3		4			5		       6        7
		;DataSheet = IdSheet NameSheet WidthSheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet
		;
		(setq LstIdSheet (GetListIdSheet))
		(setq MargineX 800.0)
		(setq MargineY 1500.0)
		(setq Pinsert Px)
		(if (and Px LstInfoStock)
			(progn
				(setq PStartStockSheet Px)
				(foreach itm LstInfoStock
					
					(setq Conta 1)
					(setq NSheet (atoi (nth 4 itm)))
					(StartProgressBar "Sheet Stock:" NSheet)
					
					(repeat NSheet
					
						(UpDateProgressBar)
						
						(cond 
							((< NSheet 100)
								(cond
									((< Conta 10) 
										(setq NameSheet (strcat (nth 0 itm) "_0" (LM:rtos Conta 2 0)))
									)
									(t 
										(setq NameSheet (strcat (nth 0 itm) "_"  (LM:rtos Conta 2 0)))
									)
								)
							)
							((>= NSheet 100)
								(cond
									((< Conta 10) 
										(setq NameSheet (strcat (nth 0 itm) "_00" (LM:rtos Conta 2 0)))
									)
									((and (>= Conta 10) (<= Conta 99)) 
										(setq NameSheet (strcat (nth 0 itm) "_0"  (LM:rtos Conta 2 0)))
									)
									(t 
										(setq NameSheet (strcat (nth 0 itm) "_"   (LM:rtos Conta 2 0)))
									)
								)
							)
						)
						
						(setq Loop T)
						(while Loop
							(if (not (member (setq IdSheet (Random_Str 5)) LstIdSheet))
								(progn
									(setq LstIdSheet (append LstIdSheet (list IdSheet)))
									(setq Loop nil)
								)
							)
						)
						
						(MakeSheet 	(list 	IdSheet											;Id Sheet
											NameSheet										;Name Sheet
											(nth 1 itm)										;Width Sheet
											(nth 2 itm)										;Height Sheet
											(nth 3 itm)										;Thick Sheet
											"-"												;SurfaceSheet
											"-"												;WeightSheet
											(nth 5 itm)										;Mat Sheet
									)
									Pinsert
									T
						)
						(setq Conta (1+ Conta))
						(setq Pinsert (list (+ (car Pinsert) (atof (nth 1 itm)) MargineX) (cadr Pinsert)))
						(setq HSheet (atof (nth 2 itm)))
					)
					(ClearProgressBar)
					(setq Pinsert (list (car Px) (+ (cadr Pinsert) HSheet MargineY)))
				)
			)
		)
)
;
;
;
(defun IsRectangle (Ename / Info p1 p2 p3 p4 ang1 ang2 ang3 ang4 Chk Rtn)
	(if Ename
		(progn
			(setq Chk (CheckPoly Ename))
			(if (or (= (nth 0 Chk) 2) (= (nth 0 Chk) 3))
				(progn
					(setq Info (LM:lwvertices (entget Ename)))
					;(
					;	((10  8041.8 -753.856) (40 . 0.0) (41 . 0.0) (42 . 0.0)) 
					;	((10 10541.8 -753.856) (40 . 0.0) (41 . 0.0) (42 . 0.0)) 
					;	((10 10541.8  4246.14) (40 . 0.0) (41 . 0.0) (42 . 0.0)) 
					;	((10 8041.83  4246.14) (40 . 0.0) (41 . 0.0) (42 . 0.0))
					;)
					(if (= (length Info) 4)
						(progn
							(setq p1 (cdr (assoc 10 (nth 0 info))))
							(setq p2 (cdr (assoc 10 (nth 1 info))))
							(setq p3 (cdr (assoc 10 (nth 2 info))))
							(setq p4 (cdr (assoc 10 (nth 3 info))))
							(setq ang1 (abs (- (angle p1 p2) (angle p2 p3))))
							(setq ang2 (abs (- (angle p2 p3) (angle p3 p4))))
							(setq ang3 (abs (- (angle p3 p4) (angle p4 p1))))
							(setq ang4 (abs (- (angle p4 p1) (angle p1 p2))))
				
							(if (and (or (equal ang1 (/ pi 2.0) 0.001) (equal ang1 (* (/ pi 2.0) 3.0) 0.001))  
									 (or (equal ang2 (/ pi 2.0) 0.001) (equal ang2 (* (/ pi 2.0) 3.0) 0.001)) 
									 (or (equal ang3 (/ pi 2.0) 0.001) (equal ang3 (* (/ pi 2.0) 3.0) 0.001)) 
									 (or (equal ang4 (/ pi 2.0) 0.001) (equal ang4 (* (/ pi 2.0) 3.0) 0.001)) 
									 (= (cdr (assoc 42 (nth 0 info))) 0.0)
									 (= (cdr (assoc 42 (nth 1 info))) 0.0)
									 (= (cdr (assoc 42 (nth 2 info))) 0.0)
									 (= (cdr (assoc 42 (nth 3 info))) 0.0)
								)
								(setq Rtn T)
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
(defun PrintRuleSheet (EnameSheet / CreatRule
									UnitsRuleX UnitsRuleY TargetX SubTargetX TargetY SubTargetY
									LenghtUnits	LenghtSubTarget	LenghtTarget
									ColorUnits ColorSubTarget ColorTarget
									HtextUnits HtextSubTarget HtextTarget
									ColorTextUnits ColorTextSubTarget ColorTextTarget
									OffsetRule LstInfoShape IdSheet
									Width Height PO POx POy NdivX NdivY
									Units SubMultiple Multiple Pt LstEnameX LstEnameY LstTmp NameBlock EnameBlock
									LstData xd_list Rtn)
	;
	;
	(defun CreateRule (StartRule LenghtRule RotateRule ColorRule HtextRule ColorTextRule StyleTextRule TextRule IdSheet / 
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
								;(setq LstData (entget (vlax-vla-object->ename lineObj))
								;	  xd_list (list '(1002 . "}"))
								;	  xd_list (cons (cons 1000 IdSheet)  xd_list) ; id 
								;	  xd_list (cons '(1002 . "{") xd_list)
								;	  xd_list (cons $RgpRule xd_list)
								;	  xd_list (list -3 xd_list)
								;	  LstData (append LstData (list xd_list))
								;)
								;(entmod LstData)
								;(entupd (vlax-vla-object->ename lineObj))
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
						(if (CheckExistStyle $StyleEasyCut)	(vlax-put-property textObj 'StyleName StyleTextRule))
						(vlax-put-property textObj 'ScaleFactor 0.80)
						(vlax-put-property textObj 'Color ColorTextRule)

						(if (and (>= RotateRule 0.0)  (<= RotateRule 90.0))	    (vlax-put-property textObj 'Rotation (/ (* pi RotateRule) 180.0)))
						(if (and (> RotateRule 90.0)  (<= RotateRule 270.0))	(vlax-put-property textObj 'Rotation (/ (* pi (- RotateRule 180.0)) 180.0)))
						(if (and (> RotateRule 270.0) (<= RotateRule 360.0))	(vlax-put-property textObj 'Rotation (/ (* pi (- RotateRule 360.0)) 180.0)))

						(if lineObj
							(progn
								;(setq LstData (entget (vlax-vla-object->ename textObj))
								;	  xd_list (list '(1002 . "}"))
								;	  xd_list (cons (cons 1000 IdSheet)  xd_list) ; id 
								;	  xd_list (cons '(1002 . "{") xd_list)
								;	  xd_list (cons $RgpRule xd_list)
								; 	  xd_list (list -3 xd_list)
								;	  LstData (append LstData (list xd_list))
								;)
								;(entmod LstData)
								;(entupd (vlax-vla-object->ename lineObj))
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

			(setq LstEnameX (CreateRule POx LenghtTarget 270.0  ColorTarget HtextTarget ColorTextTarget $StyleEasyCut "0" IdSheet))
			(setq LstEnameY (CreateRule POy LenghtTarget 180.0  ColorTarget HtextTarget ColorTextTarget $StyleEasyCut "0" IdSheet))
			
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
						(setq LstTmp (CreateRule Pt LenghtTarget 270.0 ColorTarget HtextTarget ColorTextTarget $StyleEasyCut (rtos Units 2 0) IdSheet))
						(setq Multiple     0.0)
						(setq SubMultiple  0.0)
					)
					((= SubMultiple SubTargetX)
						(setq LstTmp (CreateRule Pt LenghtSubTarget 270.0 ColorSubTarget HtextSubTarget ColorTextSubTarget $StyleEasyCut (rtos Units 2 0) IdSheet))
						(setq SubMultiple  0.0)
					)
					(t
						(setq LstTmp (CreateRule Pt LenghtUnits 270.0 ColorUnits HtextUnits ColorTextUnits $StyleEasyCut (rtos Units 2 0) IdSheet))
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
						(setq LstTmp (CreateRule Pt LenghtTarget 180.0 ColorTarget HtextTarget ColorTextTarget $StyleEasyCut (rtos Units 2 0) IdSheet))
					    (setq Multiple     0.0)
						(setq SubMultiple  0.0)
					)
					((= SubMultiple SubTargetX)
						(setq LstTmp (CreateRule Pt LenghtSubTarget 180.0 ColorSubTarget HtextSubTarget ColorTextSubTarget $StyleEasyCut (rtos Units 2 0) IdSheet))
						(setq SubMultiple  0.0)
					)
					(t
						(setq LstTmp (CreateRule Pt LenghtUnits 180.0 ColorUnits HtextUnits ColorTextUnits $StyleEasyCut (rtos Units 2 0) IdSheet))
					)
				)
				(if LstTmp (setq LstEnameY (append LstEnameY LstTmp)))
			)
			
			(if (and  LstEnameX LstEnameY)
				(progn
					;(setq NameBlock (strcat "RULE_" IdSheet))
					;(setq EnameBlock (MakeBlock NameBlock (append LstEnameX LstEnameY) PO))
					;(if EnameBlock
					;	(progn
					;		(setq EnameBlock (InsertBlock NameBlock PO nil))
					;		(setq Rtn (vlax-vla-object->ename EnameBlock))
					;		(DeleteEntity (append LstEnameX LstEnameY))
					;	)
					(setq Rtn (LstEname->Ssget (append LstEnameX LstEnameY)))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun CompleteEnameCopySheet (LstEnameAlredyCopied / IsSheet IsBlock itm LstEnameSheet DataSheet 
													  NameBomSheet
													  EnameSheet EnameRule EnameBlock)

	(defun IsSheet (EnameSheet)
		(if EnameSheet
			(if (assoc -3 (entget EnameSheet (list "*")))
				(if (= (nth 0 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))) $RgpSheet)
					T
					nil
				)
			)
		)
	)
	;
	(defun IsBlock (EnameBlockSheet)
		(if EnameBlockSheet
			(if (assoc -3 (entget EnameBlockSheet (list "*")))
				(if (= (nth 0 (nth 1 (assoc -3 (entget EnameBlockSheet (list "*"))))) $RgpSheetTarget)
					T
					nil
				)
			)
		)
	)
	; 
	; Main
	;
	(if LstEnameAlredyCopied
		(progn
			
			(foreach itm LstEnameAlredyCopied
			
				(if (IsSheet itm)
					(setq LstEnameSheet (append LstEnameSheet (list itm)))
				)
				(if (IsBlock itm)
					(progn
						(setq NameBomSheet (LM:al-effectivename itm))
						(entdel itm)
						(PurgeBlock NameBomSheet)					
					)
				)
			)
			; 
			(foreach itm LstEnameSheet
				
				(setq EnameSheet itm)
				(setq DataSheet (GetDataSheetByEname EnameSheet))
				;("61518" "STK_XXX_4" "2500" "5000" "10" "12.5" "981.25" "10")
				(AssignNameSheet EnameSheet (list (nth 1 DataSheet) (nth 4 DataSheet) (nth 7 DataSheet)))
				(setq EnameRule  (PrintRuleSheet EnameSheet))
				(setq EnameBlock (LogoSheet EnameSheet EnameRule))

			)
		)
	)
)
;
;
;
(defun CompleteEnameMoveSheet (LstEnameAlredyMoved / IsSheet IsBlock IsAlignSheet->Bom IsAlignBom->Sheet AlignSheet->Bom AlignBom->Sheet
													 itm LstEnameSheet DataSheet 
													 NameBomSheet
													 EnameSheet EnameRule EnameBlock)

	(defun IsSheet (EnameSheet / Rtn)
		(if EnameSheet
			(if (assoc -3 (entget EnameSheet (list "*")))
				(if (= (nth 0 (nth 1 (assoc -3 (entget EnameSheet (list "*"))))) $RgpSheet)
					T
					nil
				)
			)
		)
	)
	;
	(defun IsBlock (EnameBlockSheet)
		(if EnameBlockSheet
			(if (assoc -3 (entget EnameBlockSheet (list "*")))
				(if (= (nth 0 (nth 1 (assoc -3 (entget EnameBlockSheet (list "*"))))) $RgpSheetTarget)
					T
					nil
				)
			)
		)
	)
	;
	(defun IsAlignSheet->Bom (EnameSheet / EnameBom)
		(if EnameSheet
			(progn
				(setq EnameBom (GetEnameBlockSheetById (GetIdSheet EnameSheet)))
				(if (equal (cdr (assoc 10 (entget EnameBom))) 
						   (append (car (BoundingBoxLstEname (list EnameSheet))) (list 0.0)) 0.5)
					T
					nil
				)
			)
		)
	)
	;
	(defun IsAlignBom->Sheet (EnameBom / IdSheet)
		(if EnameBom
			(progn
				(setq IdSheet	  (LM:vl-getattributevalue (vlax-ename->vla-object EnameBom) "ID_SHEET"))
				(if (equal (cdr (assoc 10 (entget EnameBom))) 
						   (append (car (BoundingBoxLstEname (list (GetEnameSheetById IdSheet)))) (list 0.0)) 0.5)
					T
					nil
				)
			)
		)
	)
	;
	(defun AlignSheet->Bom (EnameSheet / EnameBom)
		(if EnameSheet
			(progn
				(setq EnameBom    (GetEnameBlockSheetById (GetIdSheet EnameSheet)))
				(vla-move (vlax-ename->vla-object EnameBom) 
								  (vlax-3d-point (cdr (assoc 10 (entget EnameBom))))
								  (vlax-3d-point (car (BoundingBoxLstEname (list EnameSheet))))
				)
			)
		)
	)
	;
	(defun AlignBom->Sheet (EnameBom / IdSheet)
		(if EnameBom
			(progn
				(setq IdSheet	  (LM:vl-getattributevalue (vlax-ename->vla-object EnameBom) "ID_SHEET"))
				(vla-move (vlax-ename->vla-object (GetEnameSheetById IdSheet))
								  (vlax-3d-point (car (BoundingBoxLstEname (list (GetEnameSheetById IdSheet)))))
								  (vlax-3d-point (cdr (assoc 10 (entget EnameBom))))
				)
			)
		)
	)
		
	; 
	; Main
	;
	(foreach itm LstEnameAlredyMoved
		(if (IsSheet itm) (if (not (IsAlignSheet->Bom itm)) (AlignSheet->Bom itm)))
		(if (IsBlock itm) (if (not (IsAlignBom->Sheet itm)) (AlignBom->Sheet itm)))
	)
)
;
;
;
(defun GetDimensionBySurfaceSheet (Surface LstData / Dec MinWidth MaxWidth MinLength MaxLength Step 
													_Width _Length NumberStepWidth NumberStepLength Qta Scrap Rtn)

	;(setq MinWidth 	(/ (nth 0 LstData) 1000.0))
	;(setq MaxWidth 	(/ (nth 1 LstData) 1000.0))
	;(setq MinLength	(/ (nth 2 LstData) 1000.0))
	;(setq MaxLength	(/ (nth 3 LstData) 1000.0))
	;(setq Step		(/ (nth 4 LstData) 1000.0))
	;(setq MaxSheet  (nth 5 LstData))
	;(setq Dec 4)
	;
	;(StartProgressBar "Search Sheet:" (length NumSheet))
	;
	;(setq Qta 1)
	;(repeat MaxSheet
	;
	;	(if (<= (/ Surface Qta) (* MaxLength MaxWidth))
	;		(progn
	;			(setq Width  MinWidth)
	;			(while (<= Width MaxWidth)
	;				(if (and (>= (/ (/ (GetReal_ Surface Dec) Qta) Width) MinLength) 
	;						 (<= (/ (/ (GetReal_ Surface Dec) Qta) Width) MaxLength)
	;						 (>= (/ (/ (GetReal_ Surface Dec) Qta) Width) MinWidth)
	;					)
	;					(setq Rtn (append Rtn (list (list Qta Width (/ (/ (GetReal_ Surface Dec) Qta) Width)))))
	;				)
	;				(setq Width (GetReal_ (+ Width Step) 4))
	;			)
	;		)
	;	)
	;	(UpDateProgressBar)
	;	(setq Qta (1+ Qta))
	;)
	;(ClearProgressBar)
	;Rtn
	
	
	(setq Dec 4)
	(setq MinWidth 	(nth 0 LstData))
	(setq MaxWidth 	(nth 1 LstData))
	(setq MinLength	(nth 2 LstData))
	(setq MaxLength	(nth 3 LstData))
	(setq Step		(nth 4 LstData))

	(setq _Width  MinWidth)
	(setq _Length MinLength)
	
	(setq NumberStepWidth  (1+ (fix (/ (- MaxWidth  MinWidth)   Step))))
	(setq NumberStepLength (1+ (fix (/ (- MaxLength MinLength)  Step))))
	
	(StartProgressBar "Search Sheet:" (* NumberStepWidth (1+ NumberStepLength)))

	(repeat NumberStepWidth
			
		(repeat NumberStepLength
			(setq Qta (fix (LM:roundup (/ Surface (* (/ _Width 1000.0) (/ _Length 1000.0)))1)))
			(setq Scrap (- 1.0 (/ Surface (* Qta (/ _Width 1000.0) (/ _Length 1000.0)))))
			(setq Rtn (append Rtn (list (list Qta (GetReal_ (/ _Width 1000.0) Dec) (GetReal_ (/ _Length 1000.0) Dec) Scrap
										)
								  )
					  )
			)
			(setq _Length (+ _Length Step))
			(UpDateProgressBar)
		)
		(setq _Length MinLength)
		(setq _Width (+ _Width Step))
		(UpDateProgressBar)
	)
	(ClearProgressBar)
	Rtn
	
	
	
	
)
;
;
;
(defun GuiUseSheet (/ PutListSheet LstData DialogUseSheet DialogUseSheetListBox Rtn)


	(defun GetData (/ ParseVal
					  MinWidthUseSheet MaxWidthUseSheet MinLengthUseSheet MaxLengthUseSheet StepUseSheet 
					  SurfaceUse AddSurfaceUse AvailableSurfaceUse Err)
		
		(defun ParseVal (Val TypeRtn / StringToNumber
									   Rtn)
		
			(defun StringToNumber (String / Rtn)
				(if String
					(if (numberp (read String))
						(if (member 46 (vl-string->list String))  ;.
							(setq Rtn (atof String))
							(setq Rtn (atoi String))
						)
					)
				)
				Rtn
			)
			;
			; Main
 			;
			(if (and Val TypeRtn)
				(cond
					((= TypeRtn "STR")
						(if (= (setq Rtn (vl-string-right-trim " \t" (vl-string-left-trim " \t" Val))) "")
							(setq Rtn nil)
						)
					)
					((= TypeRtn "NUM")
						(setq Rtn (StringToNumber Val))
					)
				)
			)
			Rtn
		)
		;
		; Main 
		;
		(setq MinWidthUseSheet 	 (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "MinWidthUseSheet"))))
		(setq MaxWidthUseSheet 	 (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "MaxWidthUseSheet"))))
		(setq MinLengthUseSheet  (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "MinLengthUseSheet"))))
		(setq MaxLengthUseSheet  (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "MaxLengthUseSheet"))))
		(setq StepUseSheet 		 (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "StepUseSheet"))))
		(setq SurfaceUse 		 (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "SurfaceUse"))))
		(setq AddSurfaceUse 	 (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "AddSurfaceUse"))))
		(setq AvailableSurfaceUse (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "AvailableSurfaceUse"))))
		
		(setq Err nil)
		(if (not (setq MinWidthUseSheet   (ParseVal MinWidthUseSheet   "NUM"))) (setq MinWidthUseSheet   0))
		(if (not (setq MaxWidthUseSheet   (ParseVal MaxWidthUseSheet   "NUM"))) (setq MaxWidthUseSheet   0)) 
		(if (not (setq MinLengthUseSheet  (ParseVal MinLengthUseSheet  "NUM"))) (setq MinLengthUseSheet  0))
		(if (not (setq MaxLengthUseSheet  (ParseVal MaxLengthUseSheet  "NUM"))) (setq MaxLengthUseSheet  0))
		(if (not (setq StepUseSheet 	  (ParseVal StepUseSheet 	   "NUM"))) (setq StepUseSheet       0))
		(if (not (setq SurfaceUse 	 	  (ParseVal SurfaceUse 	 	   "NUM"))) (setq SurfaceUse         0))
		(if (not (setq AddSurfaceUse 	  (ParseVal AddSurfaceUse 	   "NUM"))) (setq AddSurfaceUse      0))
		(if (not (setq AvailableSurfaceUse (ParseVal AvailableSurfaceUse "NUM"))) (setq AvailableSurfaceUse 0))
		
		(if (= MinWidthUseSheet  0) (progn (setq Err T) (alert "Valore non corretto [Minima larghezza lamiera]")))
		(if (= MaxWidthUseSheet  0) (progn (setq Err T) (alert "Valore non corretto [Massima larghezza lamiera]")))
		(if (= MinLengthUseSheet 0) (progn (setq Err T) (alert "Valore non corretto [Minima lunghezza lamiera]")))
		(if (= MaxLengthUseSheet 0) (progn (setq Err T) (alert "Valore non corretto [Massima lunghezza lamiera]")))
		(if (= StepUseSheet      0) (progn (setq Err T) (alert "Valore non corretto [Incremento larghezza lamiera]")))
		(if (= SurfaceUse        0) (progn (setq Err T) (alert "Valore non corretto [Superficie da utilizzare]")))
		
		(if (> MinWidthUseSheet  MaxWidthUseSheet)  (progn (setq Err T) (alert "[Minima larghezza lamiera] maggiore [Massima larghezza lamiera] ")))
		(if (> MinLengthUseSheet MaxLengthUseSheet) (progn (setq Err T) (alert "[Minima lunghezza lamiera] maggiore [Massima lunghezza lamiera] ")))
		
		
		(if (not Err)
			(list MinWidthUseSheet MaxWidthUseSheet MinLengthUseSheet MaxLengthUseSheet StepUseSheet SurfaceUse AddSurfaceUse AvailableSurfaceUse)
			nil
		)
	)
	;
	;
	;
	(defun MakeStockUseSheet (StrStock / SplitStock LstSheet)
		(if StrStock
			(progn
				(setq SplitStock (SpliTxt StrStock " ")) ;("Mq" "1000.00\tN." "24" "lamiere\tda" "3000" "x" "13890\t" "sfrido"  "20")
				
				;"qtasheet"
				;"widthsheet"
				;"heightsheet"
				;"thicksheet"

				(if (setq LstSheet (GuiUseSheetToMakeStock (list (nth 2 SplitStock) (nth 4 SplitStock) (nth 6 SplitStock) "")))
					(progn
						(setq *UseSheetListBox* (done_dialog)) 
						(unload_dialog DialogUseSheetListBox)
						(setq *UseSheet* (done_dialog)) 
						(unload_dialog DialogUseSheet)
					)	
				)
			)
		)
		LstSheet
	)
	;
	;
	;
	(defun PutListSheet (/ LstData LstSheet itm LstBox TileBox DialogUseSheetListBox)

		(if (setq LstData (GetData))
			(progn 
			
				(setq MinWidthUseSheet$ 	(nth 0 LstData))
				(setq MaxWidthUseSheet$ 	(nth 1 LstData))
				(setq MinLengthUseSheet$	(nth 2 LstData))
				(setq MaxLengthUseSheet$	(nth 3 LstData))
				(setq StepUseSheet$			(nth 4 LstData))
				(setq SurfaceUse$			(nth 5 LstData))
				(setq AddSurfaceUse$		(nth 6 LstData))
				(setq AvailableSurfaceUse$	(nth 7 LstData))
				

				(setq LstSheet 	(GetDimensionBySurfaceSheet AvailableSurfaceUse$ (list MinWidthUseSheet$   MaxWidthUseSheet$ 
																					   MinLengthUseSheet$  MaxLengthUseSheet$
																					   StepUseSheet$ 	  MaxSheetUse$)))
				(setq LstSheet 	(vl-sort LstSheet (function (lambda (e1 e2)  (< (cadr e1) (cadr e2))))))	
		
				(foreach itm LstSheet
					(setq LstBox (append LstBox (list (strcat 	"Mq "	   (LM:rtos AvailableSurfaceUse$ 2 2) "\t" 
																"N. "	   (LM:rtos                (car itm) 2 0) "  lamiere\t" 
																"da  " 	   (LM:rtos                (* (cadr  itm) 1000.0) 2 0) 
																"  x  "	   (LM:rtos    (LM:roundup (* (caddr itm) 1000.0) 10) 2 0) "\t"
																" sfrido  "(LM:rtos                (* (cadddr itm) 100.0) 2 2) "%"))))
				)
				(setq DialogUseSheetListBox (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(new_dialog "UseSheetListBox" DialogUseSheetListBox "" (cond ( *UseSheetListBox* ) ( '(-1 -1) )))
				(start_list "UseSheetFormat") (mapcar 'add_list LstBox)  (end_list)
				(action_tile "createstock"	"(setq TileBox (get_tile \"UseSheetFormat\"))
											 (if (and TileBox (/= TileBox \"\"))
												 (setq LstSheet (MakeStockUseSheet (nth (atoi TileBox) LstBox)))
												 (alert \"Nessuna lamiera selezionata\")
											 )
											 (setq *UseSheetListBox* (done_dialog)) (unload_dialog DialogUseSheetListBox)"
				)
				(action_tile "cancel"		"(setq *UseSheetListBox* (done_dialog) LstSheet nil) (unload_dialog DialogUseSheetListBox)")
				(start_dialog)
			)
		)
		LstSheet
	)
	;
	; Main
	;
	(if (not MinWidthUseSheet$) 	(setq MinWidthUseSheet$ 	1000))
	(if (not MaxWidthUseSheet$)  	(setq MaxWidthUseSheet$ 	3000))
	(if (not MinLengthUseSheet$) 	(setq MinLengthUseSheet$	2000))
	(if (not MaxLengthUseSheet$)	(setq MaxLengthUseSheet$	6000))
	(if (not StepUseSheet$) 		(setq StepUseSheet$			50))
	(if (not SurfaceUse$) 			(setq SurfaceUse$		    0))
	(if (not AddSurfaceUse$) 		(setq AddSurfaceUse$	    0))
	(if (not MaxSheetUse$) 			(setq MaxSheetUse$		    50))
	(if (not AvailableSurfaceUse$) 	(setq AvailableSurfaceUse$	0))
	
	
	(setq DialogUseSheet (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "UseSheet" DialogUseSheet "" (cond ( *UseSheet* ) ( '(-1 -1) )))
	
	(mode_tile "AvailableSurfaceUse" 1)
	(set_tile "MinWidthUseSheet" 	(LM:rtos MinWidthUseSheet$ 	 2 1))
	(set_tile "MaxWidthUseSheet"	(LM:rtos MaxWidthUseSheet$ 	 2 1))
	(set_tile "MinLengthUseSheet" 	(LM:rtos MinLengthUseSheet$  2 1))
	(set_tile "MaxLengthUseSheet" 	(LM:rtos MaxLengthUseSheet$  2 1))
	(set_tile "StepUseSheet" 		(LM:rtos StepUseSheet$ 		 2 1))
	(set_tile "SurfaceUse"			(LM:rtos SurfaceUse$ 		 2 3))
	(set_tile "AddSurfaceUse"		(LM:rtos AddSurfaceUse$ 	 2 3))
	(set_tile "AvailableSurfaceUse"	(LM:rtos (+ SurfaceUse$ (/ (* SurfaceUse$ AddSurfaceUse$) 100.0)) 2 3))

	(action_tile "SurfaceUse"    	(strcat "(set_tile \"AvailableSurfaceUse\"
												(LM:rtos 
													(+ (atof (get_tile \"SurfaceUse\")) 
														(/ (* (atof (get_tile \"SurfaceUse\")) (atof (get_tile \"AddSurfaceUse\"))) 100.0)
													) 
													2 3
												)
											 )"))
	(action_tile "AddSurfaceUse"    (strcat "(set_tile \"AvailableSurfaceUse\"
												(LM:rtos 
													(+ (atof (get_tile \"SurfaceUse\")) 
														(/ (* (atof (get_tile \"SurfaceUse\")) (atof (get_tile \"AddSurfaceUse\"))) 100.0)
													) 
													2 3
												)
											 )"))
	(action_tile "calc" 			"(setq Rtn (PutListSheet) *UseSheet* (done_dialog)) (unload_dialog DialogUseSheet)")
	(action_tile "cancel"	  		"(setq *UseSheet* (done_dialog) Rtn nil) (unload_dialog DialogUseSheet)")
	(start_dialog)
	(if Rtn 
		(progn
			(setq GetInsSheet (getpoint "\nPunto basso/sx inserimento lamiera .....="))
			(MakeStockSheet GetInsSheet Rtn)
		)
	)
)
;
;
;
(defun GuiUseSheetToMakeStock (LstUseSheet  / IfExistStockSheet AddStockList UpdateInofStock RemoveStockList
											  UseSheetToMakeStock MakeStock StockList Rtn)

	;
	;
	;
	(defun IfExistStockSheet (StockName / LstName itm SplitStock Conta NameStock Rtn)
	
		(if StockName
			(progn
		
				(setq LstName (GetListNameSheet))
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
		(setq MatSheet    (vl-string-right-trim  " " (vl-string-left-trim " " (strcase (get_tile "matsheet")))))
		
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
	(defun UpdateInfoStock (StockList / IdSelect LstData)
	
		(if StockList
			(progn
				(setq IdSelect (get_tile "box_info"))
				(if (/= IdSelect "")
					(progn
						(setq LstData (nth (atoi IdSelect) StockList))
						(princ LstData)
						(set_tile "namesheet"   (nth 1 (LM:str->lst (nth  0 LstData) "_")))
						(set_tile "widthsheet"  (nth 1 LstData))
						(set_tile "heightsheet" (nth 2 LstData))
						(set_tile "thicksheet"  (nth 3 LstData))
						(set_tile "qtasheet"    (nth 4 LstData))
						(set_tile "matsheet"    (nth 5 LstData))
					)
				)
			)
		)
	)
	;
	;
	;
	(defun RemoveStockList (StockList / IdSelect itm)
	
		(if StockList
			(progn
				(setq IdSelect (get_tile "box_info"))
				(if (/= IdSelect "")
					(progn
						(setq StockList (LM:RemoveNth (atoi IdSelect) StockList))
						(start_list "box_info")
						(if StockList
							(foreach itm StockList
								(add_list (strcat (nth 0 itm) "\t" (nth 1 itm) "\t" (nth 2 itm) "\t" (nth 3 itm) "\t" (nth 4 itm) "\t" (nth 5 itm)))
							)
							(add_list "")
						)
						(end_list)
					)
				)
			)
		)
		StockList
	)
	;
	; procedura genera/modifica stock lamiera
	;
	(setq UseSheetToMakeStock (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	
	(new_dialog "UseSheetToMakeStock" UseSheetToMakeStock "" (cond ( *UseSheetToMakeStock* ) ( '(-1 -1) )))
	
	; azioni
	
	(set_tile "qtasheet"    (nth 0 LstUseSheet))
	(set_tile "widthsheet"  (nth 1 LstUseSheet))
	(set_tile "heightsheet" (nth 2 LstUseSheet))
	(set_tile "thicksheet"  (nth 3 LstUseSheet))

	(action_tile "box_info"		  "(UpdateInfoStock StockList)")
	(action_tile "cancel"         "(setq *UseSheetToMakeStock* (done_dialog)) (unload_dialog UseSheetToMakeStock)")
	(action_tile "addstock"       "(setq StockList (AddStockList StockList))")
	(action_tile "removestock"    "(setq StockList (RemoveStockList StockList))")
	(action_tile "createstock"    "(setq MakeStock T *UseSheetToMakeStock* (done_dialog)) (unload_dialog UseSheetToMakeStock)")
	(start_dialog)
	
	(if MakeStock 
		StockList
		nil
	)
)
; -------------------------------------