;(SortTable	'(	("379287469" "C797" "10" "1255" "2" "34" 	"300" "300" "S355J2W" "03/12/2020" "Antioraria") 
;				("101586901" "C797" "10" "1254" "2" "35" 	"400" "360" "S355J2W" "03/12/2020" "Antioraria") 
;				("300273004" "C798" "1" "1253" "2" "37.50" 	"550" "410" "S355J2W" "03/12/2020" "Antioraria") 
;				("424072550" "C795" "1" "1257" "2" "37.50" 	"350" "260" "S355J2W" "03/12/2020" "Antioraria") 
;				("509740645" "C797" "1" "1256" "2" "39.50" 	"420" "280" "S355J2W" "03/12/2020" "Antioraria")
;			)
;			'(0 1 2 3 0 0 0 0 0 0 0)
;			"<")
;(0 0 0 0 0 0 0 0 0 0 0) nessun ordinameto
;(0 1 2 3 0 0 0 0 0 0 0) ordina per commessa quindi per fase quindi per marca
;(0 0 0 0 1 0 0 0 0 0 0) ordina per quantita
;(0 0 0 2 0 1 0 0 0 0 0) ordina per spessore quindi per marca 
;(0 0 0 0 0 1 0 0 0 0 0) ordina per quantita
;(SortTable	'(("C797" "10" "1255")("C797" "10" "1254")("C798" "1" "1253")("C795" "1" "1257")("C797" "1" "1256")) '(1 0 0) "<")
;(vl-sort '(("C797" "10" "1255")("C797" "10" "1254")("C798" "1" "1253")("C795" "1" "1257")("C797" "1" "1256")) (function (lambda (e1 e2)  (< (car e1) (car e2)))))


(defun SortTable (LstTable LstSequenceSort TypeSort / GetNthSequenceSort
													  MaxRecordSort itm Chk1 Chk2)

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
	; Main
	;
	(setq MaxRecordSort 20)
	(if LstTable
		(setq LstTable 
			(vl-sort LstTable 
				(function 
					(lambda (e1 e2)
						(setq Chk1 "")
						(setq Chk2 "")
						
						(foreach itm (GetNthSequenceSort LstSequenceSort)
							
							(cond 
								((numberp (read (nth itm e1)))
									(setq Chk1 (strcat Chk1 (CompleteString (LM:rtos (* (atof (nth itm e1)) 100) 2 0) MaxRecordSort "0")))
								)
								(t
								(setq Chk1 (strcat Chk1 (CompleteString (nth itm e1) MaxRecordSort "0")))
								)
							)
							(cond 
								((numberp (read (nth itm e2)))
									(setq Chk2 (strcat Chk2 (CompleteString (LM:rtos (* (atof (nth itm e2)) 100) 2 0) MaxRecordSort "0")))
								)
								(t
									(setq Chk2 (strcat Chk2 (CompleteString (nth itm e2) MaxRecordSort "0")))
								)
							)
						)
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
(defun GuiSelPiecesShape (LstTableNesting OutFileName / MakeButtons UpDateButtons FormatTableNesting PutFilterListTable GetFilterTorchList 
														GetFilterList SelectItmBoxList SelectAllBoxList GetDataBoxList LoadTable GetTileList BoxToList ListToBox SortBox
														xx LstButtonKey LstSort$
														LstTableNesting LstTableFiltered RtnListBox RtnFile)
	;
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
			(fill_image 0 0 XKey YKey -15)
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
	;
	;
	(defun UpDateButtons (Key LstButtonKey LstStatusButton / NthVal Rtn)
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
	;
	;
	(defun FormatTableNesting (LstTable / Num itm Rtn)
	
		(setq Num 1)
		(foreach itm LstTable
			(setq Rtn (append Rtn (list (LM:lst->str (cons (LM:rtos Num 2 0) itm) "\t"))))
			(setq Num (1+ Num))
		)
		Rtn
	)
	;
	;
	;
	(defun PutFilterListTable (LstTableNesting Sort /  itm LstFilter ErrorFilter 
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
												ErrorTorchFilter
												Value
												Conta LstSort TypeSort Num itm Rtn)
	
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
				(setq $ActiveFilterTorch$  		(get_tile "ActiveFilterTorch"))
				
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
				; ---------------------------------- TorchFilter
				(if (= $ActiveFilterTorch$ "1")
					(progn
						(mode_tile "TorchFilter" 0) ; attivo
						(setq Value (get_tile "TorchFilter"))
						(if (or (= Value "0") (= Value ""))
							(setq ErrorTorchFilter T)
							(setq $TorchFilter$ Value)
						)
					)
					(mode_tile "TorchFilter" 1) ; disattivo
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
							(not ErrorTorchFilter)
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
							(if ErrorTorchFilter		(alert "Possibile errore di sintassi numero torce TORCH"))
						)
				)
					
				
				;(princ (strcat "\n" (nth 0 LstFilter) "--" (nth 1 LstFilter) "--" (nth 2 LstFilter) "--" (nth 3 LstFilter) "--" (nth 4 LstFilter)))
				
				(if (null ErrorFilter)
					(progn
						(set_tile "box_info" "")
						(setq Rtn (GetFilterList LstTableNesting LstFilter))
						(if (= $ActiveFilterTorch$ "1")
							(setq Rtn (GetFilterTorchList Rtn (get_tile "TorchFilter")))
						)
						
						(if (and Sort LstSort$)
							(progn
								(setq LstSort LstSort$)
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
								(setq Rtn (ListToBox (SortTable (BoxToList Rtn) LstSort TypeSort)))
							)
						)
						(LoadTable Rtn nil)
					)
				)
			)
		)
		Rtn
	)
	;
	;
	;
	(defun GetFilterTorchList (LstTableNesting NumTorch / itm Record Qta NTrh Rtn)
		;	0	     1		  2      3      4      5    6    7        8       9
		; ("01" "026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2"
		;
		(if (and LstTableNesting NumTorch)
			(foreach itm  LstTableNesting
				(setq Record (LM:str->lst itm "\t"))
				(setq Qta  (atof (nth 5 Record)))
				(setq NTrh (atof NumTorch))
				(if (= (- (/ Qta NTrh) (fix (/ Qta NTrh))) 0)
					(setq Rtn (append Rtn (list (strcat	(nth 0 Record) 			"\t"
														(nth 1 Record) 			"\t"
														(nth 2 Record) 			"\t"
														(nth 3 Record) 			"\t"
														(nth 4 Record) 			"\t"
														(rtos (/ Qta NTrh) 2 0) "\t"
														(nth 6 Record) 			"\t"
														(nth 7 Record) 			"\t"
														(nth 8 Record) 			"\t"
														(nth 9 Record) 			"\t"))))
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
														(nth 6 Split) (nth 7 Split) (nth 8 Split) (nth 9 Split) ;(nth 10 Split) (nth 11 Split)
														(nth 0 LstFilter)
														(nth 1 LstFilter)
														(nth 2 LstFilter)
														(nth 3 LstFilter)
														(nth 4 LstFilter)
														(nth 5 LstFilter)
														(nth 6 LstFilter)
														(nth 7 LstFilter)
														(nth 8 LstFilter)
														(nth 9 LstFilter))
														;(nth 10 LstFilter)
														;(nth 11 LstFilter))
						(setq Rtn (append Rtn (list (strcat (rtos Conta 2 0) "\t"
															(nth 1 Split) "\t"
															(nth 2 Split) "\t"
															(nth 3 Split) "\t"
															(nth 4 Split) "\t"
															(nth 5 Split) "\t"
															(nth 6 Split) "\t"
															(nth 7 Split) "\t"
															(nth 8 Split) "\t"
															(nth 9 Split)
															;(nth 10 Split) "\t"
															;(nth 11 Split)
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
					(set_tile KeyName (rtos conta 2 0))
					(setq Select (strcat Select (rtos conta 2 0) " "))
					(setq conta (1+ conta))
				)
				;(set_tile KeyName Select)
			)
		)
	)
	;
	;
	;
	(defun GetTileList (KeyName / itm itemsplit Rtn)
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
	(defun GetDataBoxList (KeyName LstTableNesting Nth_ / LstItmSelect itm SplitRow Rtn TmpLst)
	
		;
		;
		;
		(if (and KeyName LstTableNesting)
			(progn
				(setq LstItmSelect (GetTileList KeyName))
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
	(defun LoadTable (LstTable Index / Num itm Rtn)

		(if LstTable
			(cond 
				((= Index T)
					(setq Num 1)
					(foreach itm LstTable
						(setq Rtn (append Rtn (list (LM:lst->str (LM:SubstNth (LM:rtos Num 2 0) 0 (LM:str->lst itm "\t")) "\t"))))
						(setq Num (1+ Num))
					)
					(start_list "box_info")
						(mapcar 'add_list Rtn)
					(end_list)
					Rtn
				)
				(t
					(start_list "box_info")
						(mapcar 'add_list LstTable)
					(end_list)
					LstTable
				)
			)
		)
	)
	;
	;
	;
	(defun BoxToList (LstBox / itm Rtn)
		(foreach itm LstBox
			(setq Rtn (append Rtn (list (LM:str->lst itm "\t"))))
		)
	)
	;
	;
	;
	(defun ListToBox (LstBox / itm Rtn)
		(foreach itm LstBox
			(setq Rtn (append Rtn (list (LM:lst->str itm "\t"))))
		)
		Rtn
	)
	;
	;
	;
	(defun SortBox (LstTableNesting Button LstButtonKey LstStatusButton / LstSort TypeSort Num itm Rtn)

		(if (and LstTableNesting Button LstButtonKey LstStatusButton)
			(progn
				(setq LstSort$ (UpDateButtons Button LstButtonKey LstStatusButton))
				(setq LstSort LstSort$)
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
				(setq Rtn (SortTable (BoxToList (PutFilterListTable LstTableNesting nil)) LstSort TypeSort))
				(LoadTable (ListToBox Rtn) T)
			)
		)
	)
	;
	;
	;
	(setq LstButtonKey 		'("Button1" "Button2" "Button3" "Button4" "Button5" "Button6" "Button7" "Button8" "Button9" "Button10"))
	(setq LstSort$ 			'(0 0 0 0 0 0 0 0 0 0))
	(setq LstTableNesting 	(FormatTableNesting LstTableNesting))
	
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
	(setq $ActiveFilterTorch$		"0")
	
	(if (not $PrgFilter$)		(setq $PrgFilter$ 		"<>"))			
	(if (not $IdFilter$)		(setq $IdFilter$ 		"<>"))			
	(if (not $OrderFilter$)		(setq $OrderFilter$ 	"<>"))			
    (if (not $PhaseFilter$)	 	(setq $PhaseFilter$ 	"<>"))			
    (if (not $FamilyFilter$)	(setq $FamilyFilter$ 	"<>"))	
	(if (not $MarkFilter$)		(setq $MarkFilter$ 		"<>"))
	(if (not $QuantityFilter$)	(setq $QuantityFilter$ 	"<>"))
	(if (not $NameFilter$)		(setq $NameFilter$ 		"<>"))
	(if (not $MaterialFilter$)	(setq $MaterialFilter$ 	"<>"))
	(if (not $ThiknessFilter$)	(setq $ThiknessFilter$ 	"<>"))
	(if (not $LengthFilter$)	(setq $LengthFilter$	"<>"))
	(if (not $HeightFilter$)	(setq $HeightFilter$	"<>"))
	(if (not $CutFilter$)		(setq $CutFilter$		"<>"))
	(if (not $DateFilter$)		(setq $DateFilter$		"<>"))
	(if (not $Flag1Filter$)		(setq $Flag1Filter$		"<>"))
	(if (not $Flag2Filter$)		(setq $Flag2Filter$		"<>"))
	(if (not $Flag3Filter$)		(setq $Flag3Filter$		"<>"))
	(if (not $TorchFilter$)		(setq $TorchFilter$		"1"))

	(if LstTableNesting
		(progn
			(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
			(new_dialog "InfoTableNestingCut" xx "" (cond ( *InfoTableNestingCut* ) ( '(-1 -1) )))
			(LoadTable LstTableNesting nil)
			
			(MakeButtons LstButtonKey LstSort$)
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
			(set_tile  "ActiveFilterTorch"		    $ActiveFilterTorch$)
		
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
			(set_tile  "TorchFilter"				$TorchFilter$)

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
			(mode_tile "CutFilter" 		1)
			(mode_tile "TorchFilter"	1)
			
			(setq LstTableFiltered (PutFilterListTable LstTableNesting T)) ; LstTableFiltered = ("1\t782139489\tC792\t1\t1252\t2\t33\t550\t410\tS355J2W\t" ....)

			(action_tile "ActiveFilterPrg" 		"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ActiveFilterId" 		"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ActiveFilterOrder" 	"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ActiveFilterPhase"	"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ActiveFilterMark"		"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ActiveFilterQuantity"	"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ActiveFilterThikness"	"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ActiveFilterLength"	"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ActiveFilterHeight"	"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ActiveFilterMaterial"	"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ActiveFilterDate"		"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ActiveFilterCut"		"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ActiveFilterTorch"	"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")

			(action_tile "PrgFilter"			"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "IdFilter"				"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "OrderFilter"			"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "PhaseFilter"			"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "MarkFilter"			"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "QuantityFilter"		"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "ThiknessFilter"		"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "LengthFilter"			"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "HeightFilter"			"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "MaterialFilter"		"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "DateFilter"			"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "CutFilter"			"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			(action_tile "TorchFilter"			"(setq LstTableFiltered (PutFilterListTable LstTableNesting T))")
			
			(action_tile "Button2"  			"(setq LstTableFiltered (SortBox LstTableNesting \"Button2\" LstButtonKey LstSort$))") ; LstTableFiltered = ("1\t782139489\tC792\t1\t1252\t2\t33\t550\t410\tS355J2W\t" ....)
			(action_tile "Button3"  			"(setq LstTableFiltered (SortBox LstTableNesting \"Button3\" LstButtonKey LstSort$))")
			(action_tile "Button4"  			"(setq LstTableFiltered (SortBox LstTableNesting \"Button4\" LstButtonKey LstSort$))")
			(action_tile "Button5"  			"(setq LstTableFiltered (SortBox LstTableNesting \"Button5\" LstButtonKey LstSort$))")
			(action_tile "Button6"  			"(setq LstTableFiltered (SortBox LstTableNesting \"Button6\" LstButtonKey LstSort$))")
			(action_tile "Button7"  			"(setq LstTableFiltered (SortBox LstTableNesting \"Button7\" LstButtonKey LstSort$))")
			(action_tile "Button8"  			"(setq LstTableFiltered (SortBox LstTableNesting \"Button8\" LstButtonKey LstSort$))")
			(action_tile "Button9"  			"(setq LstTableFiltered (SortBox LstTableNesting \"Button9\" LstButtonKey LstSort$))")
			(action_tile "Button10" 			"(setq LstTableFiltered (SortBox LstTableNesting \"Button10\" LstButtonKey LstSort$))") 

			(action_tile "HelpPrg" 				"(alert \"esempio 1,2 oppure <> -1\")")
			(action_tile "HelpId" 				"(alert \"esempio 012563584,555872369 oppure <> -15235877\")")
			(action_tile "HelpOrder" 			"(alert \"esempio C800,C900 oppure <> oppure -C900,-C901\")")
			(action_tile "HelpPhase" 			"(alert \"esempio 100,101 oppure <> oppure -100\")")
			(action_tile "HelpMark" 			"(alert \"esempio CT100,OP101 oppure <> oppure -17552\")")
			(action_tile "HelpQuantity" 		"(alert \"esempio <1,10>,-9,25  oppure <> oppure -1,-2\")")
			(action_tile "HelpThikness" 		"(alert \"esempio <1,10>,-9,25  oppure <> oppure -1,-2\")")
			(action_tile "HelpLength" 			"(alert \"esempio <1,10>,-9,25  oppure <> oppure -1100.2\")")
			(action_tile "HelpHeight" 			"(alert \"esempio <1,10>,-9,25  oppure <> oppure -1100.2\")")
			(action_tile "HelpMaterial" 		"(alert \"esempio S355J0,S275JR  oppure <> oppure -S275JR \")")
			(action_tile "HelpTorch" 			"(alert \"Imposta il numero di torce in modalita' pantografo\")")
			
			(action_tile "box_info"				"(SelectItmBoxList \"box_info\")")

			(action_tile "selectall"			"(SelectAllBoxList \"box_info\" LstTableFiltered)")
			(action_tile "import"				(strcat "(if (/= (get_tile \"box_info\") \"\")
														    (progn 
																(setq RtnListBox (GetDataBoxList \"box_info\" LstTableFiltered nil))
																(WriteFileNesting \"SHAPE\" RtnListBox OutFileName)
																(setq RtnFile OutFileName)
																(setq *InfoTableNesting* (done_dialog)) (unload_dialog xx)
															)
															(alert \"Nessun contorno selezionato\")
														)"))
			(action_tile "save"					(strcat "(if (/= (get_tile \"box_info\") \"\")
															(progn 
																(setq RtnListBox (GetDataBoxList \"box_info\" LstTableFiltered nil))
																(if (setq OutFileName (getfiled \"Select File Shape\" DxfNestingEasyCut$ \"shp\" 1))
																	(progn
																		(WriteFileNesting \"SHAPE\" RtnListBox OutFileName)
																		(setq RtnFile OutFileName)
																	)
																)
															)
														    (alert \"Nessun contorno selezionato\")
														 )"))
			(action_tile "list"					(strcat "(if (/= (get_tile \"box_info\") \"\")
															 (ListNesting \"SHAPE\" (GetDataBoxList  \"box_info\" LstTableFiltered nil))
															 (alert \"Nessun contorno selezionato\")
														 )"))
			(action_tile "cancel"				(strcat "(setq *InfoTableNestingCut* (done_dialog))
														 (unload_dialog xx)"
												))

			(start_dialog)
		)
		(progn
			(vl-file-delete OutFileName)
			(LM:popup "avvertimento" "Non ci sono pezzi disponibili" (+ 0 48 4096))
		)
	)
	; Rtn = (("1" "782139489" "C792" "1" "1252" "2" "33" "550" "410" "S355J2W") ....)
	(list RtnFile RtnListBox)
)
;
;
;
