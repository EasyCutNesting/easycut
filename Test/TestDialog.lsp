;(setq FileListDataShapeCfg (strcat SetupPathEasyCut$ "tmp\\ListDataShapeCfg.cfg"))
;
;LstFilterShape$	'("<>"  "<>"   "<>"   "<>"   "<>"  "<>"   "<>"   "<>"   "<>")
;LstTypeValue$		'("int" "str"  "str"  "str"  "int" "real" "real" "real" "str")
;LstButtonKey	 	'("Id"  "Comm" "Fase" "Nome" "Qta" "Spes" "Lung" "Larg" "Mat")
;LstSort$ 			'( 0     0      0       0      0     0      0      0      0)
;LstDimButton		'(12    12     12      50     12    12     12     12     12)
;
(defun Dialog01Macro ()

	(defun Dialog01ValidateList (LstInfoData LstValidData / LstValidData itm ItmValid LstValid Rtn)
		
		;
		;LstInfoData
		;
		;	   0         1      2      3     4    5     6        7       8        9           10       
		;("026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2" "20/10/2018" "Antioraria")
		;
		(if (and LstInfoData LstValidData)
			(foreach itm LstInfoData
				(setq LstValid nil)
				(foreach ItmValid LstValidData
					(setq LstValid (cons (nth ItmValid itm) LstValid))
				)
				(setq Rtn (append Rtn (list (reverse LstValid))))
				
			)
		)
		Rtn
	)
	;
	(defun Dialog01MakeButtons (LstButtonKey LstStatusButton / XVect YVect Num Key XKey YKey XMKey YMKey X Y)
		
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
	(defun Dialog01UpDateButtons (Key LstButtonKey LstStatusButton / NthVal Num Rtn)
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
				(Dialog01MakeButtons LstButtonKey Rtn)
			)
		)
		Rtn
	)
	;
	(defun Dialog01FormatTableNesting (LstTable / Num itm Tmp Rtn)
	
		(setq Num 1)
		(foreach itm LstTable
			
			;	   0         1      2      3     4    5     6        7       8        9           10       
			;("026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2" "20/10/2018" "Antioraria")
		
			;(setq Tmp (LM:RemoveNth 9 itm))
			;(setq Tmp (LM:RemoveNth 9 Tmp))
			(setq Rtn (append Rtn (list (LM:lst->str (cons (LM:rtos Num 2 0) itm) "\t"))))
			;(setq Rtn (append Rtn (list (LM:lst->str (cons (LM:rtos Num 2 0) Tmp) "\t"))))
			(setq Num (1+ Num))
			
			; ("01\t026611999\tC872\t100\t011124\t1\t15\t1183.5\t1540\tS355J2\t20/10/2018\tAntioraria")
		)
		Rtn
	)
	;
	(defun Dialog01SelectAllBoxList (KeyName LstTableNesting / Select conta)

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
		Select
	)
	;
	(defun Dialog01PutSelectBoxList (KeyName LstNth / itm)
		(set_tile KeyName (LM:lst->str LstNth " "))
	)
	;
	(defun Dialog01GetTileList (KeyName / itm itemsplit Rtn)
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
	(defun Dialog01GetDataBoxList (KeyName LstTableNesting / Prg itm Rtn)
		;
		(if (and KeyName LstTableNesting)
			(progn
				(setq Prg 1)
				(foreach itm (Dialog01GetTileList KeyName)
					(setq Rtn (append Rtn (list (cons (LM:rtos Prg 2 0)
												      (nth (atoi itm) LstTableNesting)))))
					
					(setq Prg (1+ Prg))
				)			
			)
		)
		Rtn
	)
	;
	(defun Dialog01LoadTable (LstTable Index / Num itm Rtn)

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
			(EmptyBox "box_info")
		)
	)
	;
	(defun Dialog01SortBox (LstTableNesting Button LstButtonKey LstStatusButton LstTypeValue / SortTable 
																					   Rtn)

		(defun SortTable (LstTable LstSequenceSort LstTypeValue / GetNthSequenceSort
																  Pos itm TypeValue Rtn)
			(setq Pos 0)
			(if LstTable
				(foreach itm LstSequenceSort
					(setq TypeValue (nth Pos LstTypeValue))
					(cond
						((= itm 1)
							(cond
								((= TypeValue "int")
									(setq Rtn	(mapcar
													'(lambda (x) (nth x LstTable))
														(vl-sort-i LstTable (function (lambda (e1 e2) (> (atoi (nth Pos e1)) (atoi (nth Pos e2))))))
												)
									)
								)
								((= TypeValue "real")
									(setq Rtn	(mapcar
													'(lambda (x) (nth x LstTable))
														(vl-sort-i LstTable (function (lambda (e1 e2)  (> (atof (nth Pos e1)) (atof (nth Pos e2))))))
												)
									)
								)
								(t
									(setq Rtn 	(mapcar
													'(lambda (x) (nth x LstTable))
														(vl-sort-i LstTable (function (lambda (e1 e2)  (> (nth Pos e1) (nth Pos e2)))))
												)
									)
								)
							)
						)
						((= itm -1)
							(cond
								((= TypeValue "int")
									(setq Rtn	(mapcar
													'(lambda (x) (nth x LstTable))
														(vl-sort-i LstTable (function (lambda (e1 e2) (< (atoi (nth Pos e1)) (atoi (nth Pos e2))))))
												)
									)
								)
								((= TypeValue "real")
									(setq Rtn	(mapcar
													'(lambda (x) (nth x LstTable))
														(vl-sort-i LstTable (function (lambda (e1 e2) (< (atof (nth Pos e1)) (atof (nth Pos e2))))))
												)
									)
								)
								(t
									(setq Rtn 	(mapcar
													'(lambda (x) (nth x LstTable))
														(vl-sort-i LstTable (function (lambda (e1 e2)  (< (nth Pos e1) (nth Pos e2)))))
												)
									)
								)
							)
						)
					)
					(setq Pos (1+ Pos))
				)
			)
			Rtn
		)
		;
		; Main +++
		;
		(if (and LstTableNesting Button LstButtonKey LstStatusButton)
			(progn
				(setq LstSort$ (Dialog01UpDateButtons Button LstButtonKey LstStatusButton))
				(setq Rtn (SortTable LstTableNesting LstSort$ LstTypeValue))
				(Dialog01LoadTable (Dialog01FormatTableNesting Rtn) nil)
				(setq LstTableFiltered$ Rtn)
			)
		)
	)
	;
	(defun Dialog01ModifiedLstShape (LstShape LstNth / LstShapeToLstSelected LstSelectedToLstShape
											   NRow
											   LstSelected
											   LstTitleData
											   LstTypeData
											   LstModeData
											   Rtn)
		
		;
		(defun LstShapeToLstSelected (LstShape LstNth / itm NewRow LstSelected)
			(foreach itm LstNth
				(setq NewRow (append (list (LM:rtos (1+ (atoi itm)) 2 0)) (nth (atoi itm) LstShape)))
				(setq LstSelected (append LstSelected (list NewRow)))
			)
		)
		;
		(defun LstSelectedToLstShape (LstSelected LstNth LstShape / itm Pos LstShape)
			
			(if (and LstSelected LstNth LstShape)
				(progn
					(setq Pos 0)
					(foreach itm LstNth
						(setq LstShape (LM:SubstNth (cdr (nth Pos LstSelected)) (atoi itm) LstShape))
						(setq Pos (1+ Pos))
					)
				)
			)
			LstShape
		)
		;
		; Main
		;
		(if (and LstShape LstNth)
			(progn
				(setq NRow 10)
				(setq LstSelected   (LstShapeToLstSelected LstShape LstNth))
				(setq LstTitleData  '("Itm" "Ident" "Comm" "Fase" "Marca" "Qta" "Spes" "Lung" "Larg" "Mat"))
				(setq LstTypeData	'("int" "str"   "str"  "str"  "str"   "int" "int"  "real" "real" "str"))
				(setq LstModeData   '(1 1 0 0 0 0 0 1 1 0))
				(if (setq RtnLstSelected (GuiScrollList LstSelected LstTypeData LstTitleData LstModeData NRow))
					(setq Rtn (LstSelectedToLstShape RtnLstSelected LstNth LstShape))
				)
			)
		)
		Rtn 
	)	
	;
	(defun Dialog01UpDateInfoShape (LstTable / LstShape itm LstShapeTable Ident Change Data)
	

		(if LstTable
			(if (setq LstShape (GetListEnameShapeTable))
				(progn
					(foreach itm LstShape
						(setq LstShapeTable (append LstShapeTable (list (list 	(GetIdShape    itm) 	;-> Ident
																				itm   					;-> Ename
						))))
					)
					(foreach itm LstTable
						(setq Ident (nth 0 itm))					; Ident
				
						(if (setq Data (assoc Ident LstShapeTable))
							(progn
								(if (/= (nth 1 itm) (GetComShape   (nth 1 Data))) (progn (ChangeRecordShape (nth 1 Data) 6  (nth 1 itm)) (setq Change T))) ; Order
								(if (/= (nth 2 itm) (GetPhaseShape (nth 1 Data))) (progn (ChangeRecordShape (nth 1 Data) 7  (nth 2 itm)) (setq Change T))) ; Phase
								(if (/= (nth 3 itm) (GetNameShape  (nth 1 Data))) (progn (ChangeRecordShape (nth 1 Data) 4  (nth 3 itm)) (setq Change T))) ; Name
								(if (/= (nth 4 itm) (GetQtaShape   (nth 1 Data))) (progn (ChangeRecordShape (nth 1 Data) 11 (nth 4 itm)) (setq Change T))) ; quantity
								(if (/= (nth 5 itm) (GetTkShape    (nth 1 Data))) (progn (ChangeRecordShape (nth 1 Data) 9  (nth 5 itm)) (setq Change T))) ; Thikness
								(if (/= (nth 8 itm) (GetMatShape   (nth 1 Data))) (progn (ChangeRecordShape (nth 1 Data) 8  (nth 8 itm)) (setq Change T))) ; Thikness
								(if Change
									(progn
										(EnameShape->UpdateBlockInfoShape (nth 1 Data))
										(setq Change nil)
									)
								)
							)
						)
					)
				)
			)
		)
	)
	;
	(defun Dialog01UpLstTableNesting (LstTableNesting LstTableFiltered / itm Rtn)
		
		(if (and LstTableNesting LstTableFiltered)
			(foreach itm LstTableFiltered
				(if (not Rtn)
					(setq Rtn (subst itm (assoc (car itm) LstTableNesting) LstTableNesting))
					(setq Rtn (subst itm (assoc (car itm) Rtn) Rtn))
				)
			)
		)
		Rtn
	)
	;
	(defun Dialog01SetDclFilter (/ ModeIdent ModeOrder ModePhase ModeMark ModeQuantity ModeThickness ModeLength ModeWidth ModeMaterial)
		

		(foreach itm LstVarBool$
			(setq Var (car (splitxt itm "_")))
			(eval (read  (strcat "(set_tile \"" Var "_FilterBool\" " itm ")")))
		)
		(foreach itm LstVarActive$
			(setq Var (car (splitxt itm "_")))
			(eval (read  (strcat "(set_tile \"" Var "_FilterActive\" " itm ")")))
		)
	
		;(set_tile "Id.BoolFilter"		$BoolIdentFilter$		)
		;(set_tile "Comm.BoolFilter"	$BoolOrderFilter$		)
		;(set_tile "Fase.BoolFilter"	$BoolPhaseFilter$		)
		;(set_tile "Nome.BoolFilter"	$BoolMarkFilter$		)
		;(set_tile "Qta.BoolFilter"		$BoolQuantityFilter$	)
		;(set_tile "Spes.BoolFilter"	$BoolThiknessFilter$	)
		;(set_tile "Lung.BoolFilter"	$BoolLengthFilter$		)
		;(set_tile "Larg.BoolFilter"	$BoolWidthFilter$		)
		;(set_tile "Mat.BoolFilter"		$BoolMaterialFilter$	)
		
		;(set_tile "Id.ActiveFilter"		$ActiveFilterIdent$	)
		;(set_tile "Comm.ActiveFilter"	$ActiveFilterOrder$		)
		;(set_tile "Fase.ActiveFilter"	$ActiveFilterPhase$		)
		;(set_tile "Nome.ActiveFilter"	$ActiveFilterMark$		)
		;(set_tile "Qta.ActiveFilter"	$ActiveFilterQuantity$	)
		;(set_tile "Spes.ActiveFilter"	$ActiveFilterThickness$	)
		;(set_tile "Lung.ActiveFilter"	$ActiveFilterLength$	)
		;(set_tile "Larg.ActiveFilter"	$ActiveFilterWidth$		)
		;(set_tile "Mat.ActvieFilter"	$ActiveFilterMaterial$	)
		
	)
	;
	(defun Dialog01GetDclFilter (/ itm Var LstTmp)
	
		(foreach itm LstVarBool$
			(setq Var (car (splitxt itm "_")))
			(eval (read  (strcat "(setq " itm " (get_tile \"" Var "_FilterBool\"))")))
		)
		
		;(setq $BoolIdentFilter$ 		(get_tile "Id.BoolFilter"	))
		;(setq $BoolOrderFilter$ 		(get_tile "Comm.BoolFilter"	))
		;(setq $BoolPhaseFilter$ 		(get_tile "Fase.BoolFilter"	))
		;(setq $BoolMarkFilter$ 		(get_tile "Nome.BoolFilter"	))
		;(setq $BoolQuantityFilter$ 	(get_tile "Qta.BoolFilter"	))
		;(setq $BoolThiknessFilter$ 	(get_tile "Spes.BoolFilter"	))
		;(setq $BoolLengthFilter$ 		(get_tile "Lung.BoolFilter"	))
		;(setq $BoolWidthFilter$ 		(get_tile "Larg.BoolFilter"	))
		;(setq $BoolMaterialFilter$ 	(get_tile "Mat.BoolFilter"	))

		
		(foreach itm LstVarActive$
			(setq Var (car (splitxt itm "_")))
			(setq LstTmp (append LstTmp (list (eval (read  (strcat "(setq " itm "(get_tile \"" Var "_FilterActive\"))"))))))
		)
		(setq LstValBool$ LstTmp)
		
		;(setq $ActiveFilterIdent$ 		(get_tile "Id.ActiveFilter"		))
		;(setq $ActiveFilterOrder$ 		(get_tile "Comm.ActiveFilter"	))
		;(setq $ActiveFilterPhase$ 		(get_tile "Fase.ActiveFilter"	))
		;(setq $ActiveFilterMark$ 		(get_tile "Nome.ActiveFilter"	))
		;(setq $ActiveFilterQuantity$ 	(get_tile "Qta.ActvieFilter"	))
		;(setq $ActiveFilterThickness$ 	(get_tile "Spes.ActiveFilter"	))
		;(setq $ActiveFilterLength$		(get_tile "Lung.ActiveFilter"	))
		;(setq $ActiveFilterWidth$	 	(get_tile "Larg.ActiveFilter"	))
		;(setq $ActiveFilterMaterial$ 	(get_tile "Mat.ActvieFilter"	))

			
		(eval (read  (strcat "(list " (substr (vl-princ-to-string LstVarBool$) 2 (- (strlen (vl-princ-to-string LstVarBool$)) 2)) ")")))
			
		;(list 	$BoolIdentFilter$
		;		$BoolOrderFilter$
		;		$BoolPhaseFilter$
		;		$BoolMarkFilter$
		;		$BoolQuantityFilter$
		;		$BoolThiknessFilter$
		;		$BoolLengthFilter$
		;		$BoolWidthFilter$
		;		$BoolMaterialFilter$
		;)
	)
	;
	(defun Dialog01SetMode (/ itm Var)
	
	;(alert (vl-prin1-to-string LstVarBool$))
	;(alert (vl-prin1-to-string LstVarActive$))

		(foreach itm LstVarActive$
			(setq Var (car (splitxt itm "_")))
			(eval (read  (strcat "(if (= " itm " \"0\") (mode_tile \"" Var "_FilterBool\"   1) (mode_tile \"" Var "_FilterBool\"   0))")))
			(eval (read  (strcat "(if (= " itm " \"0\") (mode_tile \"" Var "_FilterButton\" 1) (mode_tile \"" Var "_FilterButton\" 0))")))
		)	
	

		;(if (= $ActiveFilterIdent$     "0") (setq ModeIdent     1) (setq ModeIdent     0)) 
		;(if (= $ActiveFilterOrder$     "0") (setq ModeOrder     1) (setq ModeOrder     0))
		;(if (= $ActiveFilterPhase$     "0") (setq ModePhase     1) (setq ModePhase     0))
		;(if (= $ActiveFilterMark$      "0") (setq ModeMark      1) (setq ModeMark      0))
		;(if (= $ActiveFilterQuantity$  "0") (setq ModeQuantity  1) (setq ModeQuantity  0))
		;(if (= $ActiveFilterThickness$ "0") (setq ModeThickness 1) (setq ModeThickness 0))
		;(if (= $ActiveFilterLength$    "0") (setq ModeLength    1) (setq ModeLength    0))
		;(if (= $ActiveFilterWidth$     "0") (setq ModeWidth     1) (setq ModeWidth     0))
		;(if (= $ActiveFilterMaterial$  "0") (setq ModeMaterial  1) (setq ModeMaterial  0))
		
	
		;(mode_tile "Id.BoolFilter"		ModeIdent	 )
		;(mode_tile "Comm.BoolFilter"	ModeOrder	 )
		;(mode_tile "Fase.BoolFilter"	ModePhase	 )
		;(mode_tile "Nome.BoolFilter"	ModeMark	 )
		;(mode_tile "Qta.BoolFilter"	ModeQuantity )
		;(mode_tile "Spes.BoolFilter"	ModeThickness)
		;(mode_tile "Lung.BoolFilter"	ModeLength	 )
		;(mode_tile "Larg.BoolFilter"	ModeWidth	 )
		;(mode_tile "Mat.BoolFilter"	ModeMaterial )
		
		;(mode_tile "Id.ButtonFilter"	ModeIdent	 )
		;(mode_tile "Comm.ButtonFilter"	ModeOrder	 )
		;(mode_tile "Fase.ButtonFilter"	ModePhase	 )
		;(mode_tile "Nome.ButtonFilter"	ModeMark	 )
		;(mode_tile "Qta.ButtonFilter"	ModeQuantity )
		;(mode_tile "Spes.ButtonFilter"	ModeThickness)
		;(mode_tile "Lung.ButtonFilter"	ModeLength	 )
		;(mode_tile "Larg.ButtonFilter"	ModeWidth	 )
		;(mode_tile "Mat.ButtonFilter"	ModeMaterial )
	)
	;
	(defun Dialog01GetActiveFilter (/ itm Var)


		(foreach itm LstVarActive$
			(setq Var (car (splitxt itm "_")))
			(eval (read  (strcat "(setq " itm "(get_tile \"" Var "_FilterActive\"))")))
		)

		;(setq $ActiveFilterIdent$ 		(get_tile "Id.ActiveFilter"		))
		;(setq $ActiveFilterOrder$		(get_tile "Comm.ActiveFilter"	))
		;(setq $ActiveFilterPhase$		(get_tile "Fase.ActiveFilter"	))
		;(setq $ActiveFilterMark$		(get_tile "Nome.ActiveFilter"	))
		;(setq $ActiveFilterQuantity$	(get_tile "Qta.ActiveFilter"	))
		;(setq $ActiveFilterThickness$	(get_tile "Spes.ActiveFilter"	))
		;(setq $ActiveFilterLength$		(get_tile "Lung.ActiveFilter"	))
		;(setq $ActiveFilterWidth$		(get_tile "Larg.ActiveFilter"	))
		;(setq $ActiveFilterMaterial$	(get_tile "Mat.ActiveFilter"	))
	)
	;
	(defun Dialog01GetDataBox (/ itm Var Pos Rtn)
	
		
		(foreach itm LstVarActive$
			(setq Var (car (splitxt itm "_")))
			(setq Rtn (append Rtn (list (eval (read  (strcat "(GetTextBox " Var "_FilterBool)"))))))
		)
					
		;(setq Rtn (list (GetTextBox "Id.BoolFilter"   ) (GetTextBox "Comm.BoolFilter" ) (GetTextBox "Fase.BoolFilter")
		;				(GetTextBox "Nome.BoolFilter" ) (GetTextBox "Qta.BoolFilter"  ) (GetTextBox "Spes.BoolFilter")
		;				(GetTextBox "Lung.BoolFilter" ) (GetTextBox "Larg.BoolFilter" ) (GetTextBox "Mat.BoolFilter" )
		;		  )
		;)
		
		(setq Pos 0)
		(foreach itm LstVarBool$
			(eval (read  (strcat "(setq " itm " (nth " (LM:rtos Pos 2 0) " Rtn))"))) 
			(setq Pos (1+ Pos))
		)
		
		;(setq $BoolIdentFilter$ 		(nth 0 Rtn))
		;(setq $BoolOrderFilter$ 		(nth 1 Rtn))
		;(setq $BoolPhaseFilter$ 		(nth 2 Rtn))
		;(setq $BoolMarkFilter$ 		(nth 3 Rtn))
		;(setq $BoolQuantityFilter$ 	(nth 4 Rtn))
		;(setq $BoolThicknessFilter$ 	(nth 5 Rtn))
		;(setq $BoolLengthFilter$		(nth 6 Rtn))
		;(setq $BoolWidthFilter$		(nth 7 Rtn))
		;(setq $BoolMaterialFilter$ 	(nth 8 Rtn))
		Rtn
	)
	;
	(defun Dialog01GetFilterDataBox (LstFilter / Pos itm)

		(setq Pos 0)
		(foreach itm LstVarActive$
			(eval (read  (strcat "(if (= " itm "\"0\") (setq LstFilter (LM:SubstNth \"<>\" " (LM:rtos Pos 2 0) " LstFilter)))")))
			(setq Pos (1+ Pos))
		)


		;(if (= $ActiveFilterIdent$		"0") (setq LstFilter (LM:SubstNth "<>" 0 LstFilter)))
		;(if (= $ActiveFilterOrder$		"0") (setq LstFilter (LM:SubstNth "<>" 1 LstFilter)))
		;(if (= $ActiveFilterPhase$		"0") (setq LstFilter (LM:SubstNth "<>" 2 LstFilter)))
		;(if (= $ActiveFilterMark$ 		"0") (setq LstFilter (LM:SubstNth "<>" 3 LstFilter)))
		;(if (= $ActiveFilterQuantity$	"0") (setq LstFilter (LM:SubstNth "<>" 4 LstFilter)))
		;(if (= $ActiveFilterThickness$ "0") (setq LstFilter (LM:SubstNth "<>" 5 LstFilter)))
		;(if (= $ActiveFilterLength$	"0") (setq LstFilter (LM:SubstNth "<>" 6 LstFilter)))
		;(if (= $ActiveFilterWidth$		"0") (setq LstFilter (LM:SubstNth "<>" 7 LstFilter)))
		;(if (= $ActiveFilterMaterial$	"0") (setq LstFilter (LM:SubstNth "<>" 8 LstFilter)))
		
		LstFilter
	)
	;
	(defun Dialog01FillArray (Val Nitm / Rtn)
		(if (and Val Nitm)
			(repeat Nitm
				(setq Rtn (append Rtn (list Val)))
			)
		)
		Rtn
	)
	;
	(defun Dialog01SetLstFiltered (LstTableNesting NumberTorch / NewLstTableNesting LstFilter LstChk)
	
		(setq LstFilter 			(Dialog01GetFilterDataBox (Dialog01GetDclFilter)))
		(setq NewLstTableNesting	(Dialog01GetListByNTorch LstTableNesting NumberTorch))
		(setq LstChk 				(Dialog01FillArray "<>" (length LstFilter)))		
	
		(if (equal LstFilter LstChk) ;("<>" "<>" "<>" "<>" "<>" "<>" "<>" "<>" "<>")
			(setq LstTableFiltered$ NewLstTableNesting)
			(setq LstTableFiltered$ (Dialog01GetFilterList NewLstTableNesting LstFilter))
		)
		(setq LstFilter$ LstFilter)
	)
	;
	(defun Dialog01SetDclList (LstTableNesting NumberTorch)
	
		(Dialog01SetLstFiltered LstTableNesting NumberTorch)
		(Dialog01LoadTable (Dialog01FormatTableNesting LstTableFiltered$) nil)
		(Dialog01MakeButtons LstButtonKey LstSort$)
	)
	;
	(defun Dialog01ActionFilter (TypeAction LstTableNesting LstButtonKey KeyOut LstTypeValue NumberTorch / GetFilterBool 
																											PosData Rtn)
				
		(defun GetFilterBool (LstData TypeValue / LstSelect Rtn)
			(if (and LstData TypeValue)
				(progn
					(setq LstSelect (DclHandleDummyList (LM:Unique LstData) TypeValue))
					(if LstSelect
						(setq Rtn (ValueToBoolean LstData LstSelect TypeValue))
					)
				)
			)
			Rtn
		)
		;
		; Main
		;
		(cond 
			((= TypeAction 1)
				(Dialog01GetActiveFilter)
				(Dialog01SetMode)
			)
			((= TypeAction 2)
				(setq PosData (GetNth LstButtonKey (car (splitxt KeyOut "_"))))
				(if (setq Rtn (GetFilterBool (GetLstRecord LstTableNesting PosData) (nth PosData LstTypeValue)))
					(SetTile (strcat (car (splitxt KeyOut "_")) "_FilterBool") Rtn)
				)
				(Dialog01GetActiveFilter)
				(Dialog01SetMode)
			)
			((= TypeAction 3)
				(Dialog01GetActiveFilter)
				(Dialog01SetMode)
			)
		)
		(Dialog01SetDclList LstTableNesting NumberTorch)
	)
	;
	(defun Dialog01GetFilterList (LstInfoData LstFilterSearch / LstTypeFilter LstItmFilter Pos Rtn)
	
		(setq LstTypeFilter LstTypeValue$)
		;(setq LstTypeFilter (list "int" "str" "str" "str" "int" "real" "real" "real" "str"))
		;(setq LstItmFilter  (list 0 1 2 3 4 5 6 7 8))
		(setq Pos 0)
		(repeat (length LstFilterSearch)
			(setq LstItmFilter (append LstItmFilter (list Pos)))
			(setq Pos (1+ Pos))
		)
		(setq Rtn (FilterList LstInfoData LstItmFilter LstTypeFilter LstFilterSearch T))
		(if (not Rtn)
			(progn
				(LM:popup "Avvertimento" "Nessun filtro soddisfa la ricerca" (+ 1 48 4096))
				nil
			)
			Rtn
		)
		
	)
	;
	(defun Dialog01MakeDialog (TitleLablel LstButton LstDimButton / Dcl Des NameDialog Pos itm Lg LstTabs WidthBox)
	
		;
		; Main
		;
		(if TitleLablel
			(progn
				(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq Des (open Dcl "w"))
				(setq NameDialog (strcat "EasyCut_" (Random_Str 5)))
				(write-line (strcat NameDialog ":dialog {")																										Des)
				(write-line (strcat "label=\"" TitleLablel "\";")																								Des)
				(write-line "           :row {"			                																						Des)
				(write-line "               :boxed_column {"																									Des)
				(write-line "                  label=\"List\";"																									Des)
				(write-line "                  :row {:toggle {key = \"DeductShape\";  label = \"Scontare le quantita' presenti nelle lamiere\"; value = 1;}}"	Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "                  :row {:text_part {width=4 ; fixed_width=true; label=\"Itm\"; }"	Des)
				(setq Pos 0)
				(foreach itm LstButton
					(setq Lg (LM:rtos (nth Pos LstDimButton) 2 0))
					(write-line (strcat "                        :text_part {width=" Lg "; fixed_width=true; label=\"" itm "\";  }") Des)
					(setq Pos (1+ Pos))
				)	
				(write-line "                  }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "                  :row {:image_button {key=\"Itm\";  height=1.2; width=4.0;  vertical_margin=none; horizontal_margin=none;}"	Des)
				(setq Pos 0)
				(foreach itm LstButton
					(setq Lg (LM:rtos (nth Pos LstDimButton) 2 0))
					(write-line (strcat "                        :image_button {key=\"" itm "\";   height=1.2; width=" Lg "; vertical_margin=none; horizontal_margin=none;}")	Des)
					(setq Pos (1+ Pos))
				)
				(write-line "                  }"																												Des)
				; --------------------------------------------------------------------------------------------------
				
				(setq LstTabs (list 4))
				(foreach itm LstDimButton
					(setq LstTabs (append LstTabs (list (+ (last LstTabs) itm))))
				)
				(setq WidthBox (LM:rtos (last LstTabs) 2 0))
				(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				
				(write-line "                  :row {:list_box {key=\"box_info\";"							Des)
				;(write-line "                                   width=150;"									Des)
				(write-line (strcat "                                   width=" WidthBox ";")				Des)
				(write-line "                                   height=35;"									Des)
				(write-line "                                   fixed_width=true;"							Des)
				(write-line "                                   vertical_margin=none; "						Des)
				(write-line "                                   horizontal_margin=none;"					Des)
				;(write-line "                                   tabs=\"4 16 28 40 90 102 114 126 138\";"	Des)
				(write-line (strcat "                                   tabs=\"" LstTabs "\";")				Des)
				(write-line "                                   multiple_select = true;"					Des)
				(write-line "                        }"														Des)
				(write-line "                  }  "															Des)
				(write-line "              }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "              :boxed_column {label=\"Filter\";"														Des)
				(write-line "                             fixed_height=true;"														Des)
				(write-line "                             alignment =top;"															Des)
				
				(foreach itm LstButton
					(write-line "                             :row {"																	Des)
					(write-line (strcat "                                   :toggle   {                     	      key=\"" itm "_FilterActive\";    }")	Des)
					(write-line (strcat "                                   :button   {width=16;  label=\"" itm "\";  key=\"" itm "_FilterButton\";    }")	Des)
					(write-line (strcat "                                   :edit_box {width=35;                	  key=\"" itm "_FilterBool\";      }")	Des)
					(write-line "                             }"																		Des)
				)
				; --------------------------------------------------------------------------------------------------
				(write-line "                             :boxed_radio_column {fixed_height=true;"																Des)
				(write-line "                                                  alignment =top;"																	Des)
				(write-line "                                                  :text{ label=\"Filtra\";}"														Des)
				(write-line "                                                  :image {key = \"$progbarsearch$\";"												Des)
				(write-line "                                                          fixed_width  = 50;"														Des)
				(write-line "                                                          height = 1;"																Des)
				(write-line "                                                          color = -15;"															Des)
				(write-line "                                                  }"																				Des)
				(write-line "                             }"																									Des)
				(write-line "             }"																													Des)
				(write-line "           }"																														Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "           Selezionatutto_Modifica_Lista_Ok_Esci;"	Des)
				(write-line "       }"										Des)
				; --------------------------------------------------------------------------------------------------
				
				(write-line "selectall_mybutton : retirement_button {label= \"Seleziona tutto\";key= \"selectall\";}"				Des)
				(write-line "modified_mybutton  : retirement_button {label= \"Modifica\";       key= \"modified\";}"				Des)
				(write-line "list_mybutton      : retirement_button {label= \"List\";           key= \"list\";}"				    Des)
				(write-line "ok_mybutton        : retirement_button {label= \"Ok\";             key= \"ok\";}"	                    Des)
				(write-line "exit_mybutton      : retirement_button {label= \"Esci\";           key= \"cancel\";is_cancel= true;}"	Des)
				(write-line "Selezionatutto_Modifica_Lista_Ok_Esci : column {"   	Des)
				(write-line "               :row {fixed_width = true;"   	Des)
				(write-line "                     alignment = centered;"   	Des)
				(write-line "                     selectall_mybutton;"   	Des)
				(write-line "                     :spacer { width = 2; }"   Des)
				(write-line "                     modified_mybutton;"   	Des)
				(write-line "                     :spacer { width = 2; }"   Des)
				(write-line "                     list_mybutton;"   		Des)
				(write-line "                     :spacer { width = 2; }"   Des)
				(write-line "                     ok_mybutton;"   		    Des)
				(write-line "                     :spacer { width = 2; }"   Des)
				(write-line "                     exit_mybutton;"   		Des)
				(write-line "              }"   							Des)
				(write-line "}"    											Des)
				(close Des)
			)
		)
		(list Dcl NameDialog)
	)
	;
	(defun Dialog01LoadVar (LstName LstVal / FolderTmp File Stream PosVar PosVal Rtn Chk)

		(setq File 		(strcat SetupPathEasyCut$ "Tmp\\var.lsp"))
		(setq Stream	(open File "w"))

			(setq PosVar 0)
		(repeat (length LstName)
			(setq PosVal 1)
			(setq Chk (nth PosVar LstVal))
			(setq Rtn "")
			(repeat (strlen Chk)
				(cond 
					((= (ascii (substr Chk PosVal 1)) 92)
						(setq Rtn (strcat Rtn (chr 92) (chr 92)))
					)
					(T
						(setq Rtn (strcat Rtn (substr Chk PosVal 1)))
					)
				)
				(setq PosVal (1+ PosVal))
			)
			(write-line (strcat "(setq " (nth PosVar LstName) " \"" Rtn "\")")	Stream)
			(setq PosVar (1+ PosVar))
		)
		(close Stream)
		(load File)
		
	)
	;
	(defun Dialog01GetListByNTorch (LstTableNesting NumberTorch / itm Qta Rtn)
		;		0	     1		2      3      4    5    6        7        8 
		; ("026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2"
		;
		(if (and LstTableNesting NumberTorch)
			(foreach itm  LstTableNesting
				(setq Qta  (atoi (nth 4 itm)))
				
				(if (> (/ Qta NumberTorch) 0)
					(progn
						(setq itm 	(LM:SubstNth (LM:rtos (/ Qta NumberTorch) 2 0) 4 itm))
						(setq Rtn 	(append Rtn (list itm)))
					)
				)
			)
			(setq Rtn LstTableNesting)
		)
		Rtn
	)
	;
	(defun Dialog01GetSelectShape (TypeQuantity / Rtn)
		(cond
			((= TypeQuantity "1")
				(GetTableStockDeductShapeNesting)
			)
			((= TypeQuantity "0")
				(GetTableStockShapeNesting)
			)
		)
	)
)
;
(defun Dialog02Macro ()

	(defun Dialog02MakeDialog (TitleLablel LstButton LstDimButton / Dcl Des NameDialog Pos itm Lg LstTabs WidthBox)
	
		;
		; Main
		;
		(if TitleLablel
			(progn
				(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq Des (open Dcl "w"))
				(setq NameDialog (strcat "EasyCut_" (Random_Str 5)))
				(write-line (strcat NameDialog ":dialog {")																										Des)
				(write-line (strcat "label=\"" TitleLablel "\";")																								Des)
				(write-line "           :row {"			                																						Des)
				(write-line "               :boxed_column {"																									Des)
				(write-line "                  label=\"List\";"																									Des)
				;(write-line "                  :row {:toggle {key = \"DeductShape\";  label = \"Scontare le quantita' presenti nelle lamiere\"; value = 1;}}"	Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "                  :row {:text_part {width=4 ; fixed_width=true; label=\"Itm\"; }"	Des)
				(setq Pos 0)
				(foreach itm LstButton
					(setq Lg (LM:rtos (nth Pos LstDimButton) 2 0))
					(write-line (strcat "                        :text_part {width=" Lg "; fixed_width=true; label=\"" itm "\";  }") Des)
					(setq Pos (1+ Pos))
				)	
				(write-line "                  }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "                  :row {:image_button {key=\"Itm\";  height=1.2; width=4.0;  vertical_margin=none; horizontal_margin=none;}"	Des)
				(setq Pos 0)
				(foreach itm LstButton
					(setq Lg (LM:rtos (nth Pos LstDimButton) 2 0))
					(write-line (strcat "                        :image_button {key=\"" itm "\";   height=1.2; width=" Lg "; vertical_margin=none; horizontal_margin=none;}")	Des)
					(setq Pos (1+ Pos))
				)
				(write-line "                  }"																												Des)
				; --------------------------------------------------------------------------------------------------
				
				(setq LstTabs (list 4))
				(foreach itm LstDimButton
					(setq LstTabs (append LstTabs (list (+ (last LstTabs) itm))))
				)
				(setq WidthBox (LM:rtos (last LstTabs) 2 0))
				(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				
				(write-line "                  :row {:list_box {key=\"box_info\";"							Des)
				;(write-line "                                   width=150;"									Des)
				(write-line (strcat "                                   width=" WidthBox ";")				Des)
				(write-line "                                   height=35;"									Des)
				(write-line "                                   fixed_width=true;"							Des)
				(write-line "                                   vertical_margin=none; "						Des)
				(write-line "                                   horizontal_margin=none;"					Des)
				;(write-line "                                   tabs=\"4 16 28 40 90 102 114 126 138\";"	Des)
				(write-line (strcat "                                   tabs=\"" LstTabs "\";")				Des)
				(write-line "                                   multiple_select = true;"					Des)
				(write-line "                        }"														Des)
				(write-line "                  }  "															Des)
				(write-line "              }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "              :boxed_column {label=\"Filter\";"														Des)
				(write-line "                             fixed_height=true;"														Des)
				(write-line "                             alignment =top;"															Des)
				
				(foreach itm LstButton
					(write-line "                             :row {"																	Des)
					(write-line (strcat "                                   :toggle   {                     	      key=\"" itm "_FilterActive\";    }")	Des)
					(write-line (strcat "                                   :button   {width=16;  label=\"" itm "\";  key=\"" itm "_FilterButton\";    }")	Des)
					(write-line (strcat "                                   :edit_box {width=35;                	  key=\"" itm "_FilterBool\";      }")	Des)
					(write-line "                             }"																		Des)
				)
				; --------------------------------------------------------------------------------------------------
				(write-line "                             :boxed_radio_column {fixed_height=true;"																Des)
				(write-line "                                                  alignment =top;"																	Des)
				(write-line "                                                  :text{ label=\"Filtra\";}"														Des)
				(write-line "                                                  :image {key = \"$progbarsearch$\";"												Des)
				(write-line "                                                          fixed_width  = 50;"														Des)
				(write-line "                                                          height = 1;"																Des)
				(write-line "                                                          color = -15;"															Des)
				(write-line "                                                  }"																				Des)
				(write-line "                             }"																									Des)
				(write-line "             }"																													Des)
				(write-line "           }"																														Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "           Selectall_Show_Import_List_Exit;"	Des)
				(write-line "       }"										Des)
				; --------------------------------------------------------------------------------------------------
				
				
				(write-line "selectall_mybutton : retirement_button {label= \"Seleziona tutto\";key= \"selectall\";}"				Des)
				(write-line "show_mybutton      : retirement_button {label= \"Show\";           key= \"show\";}"					Des)
				(write-line "import_mybutton    : retirement_button {label= \"Importa\";        key= \"import\";}"					Des)
				(write-line "list_mybutton      : retirement_button {label= \"List\";           key= \"list\";}"					Des)
				(write-line "exit_mybutton      : retirement_button {label= \"Esci\";           key= \"cancel\";  is_cancel=true;}"	Des)
				(write-line "Selectall_Show_Import_List_Exit : column {"	Des)
				(write-line "  : row {fixed_width = true;"					Des)
				(write-line "         alignment = centered;"				Des)
				(write-line "         selectall_mybutton;"					Des)
				(write-line "         :spacer { width = 2; }"				Des)
				(write-line "         show_mybutton;"						Des)
				(write-line "         :spacer { width = 2; }"				Des)
				(write-line "         import_mybutton;"						Des)
				(write-line "         :spacer { width = 2; }"				Des)
				(write-line "         list_mybutton;"						Des)
				(write-line "         :spacer { width = 2; }"				Des)
				(write-line "         exit_mybutton;"						Des)
				(write-line "  }"											Des)
				(write-line "}"												Des)
				(close Des)
			)
		)
		(list Dcl NameDialog)
	)
)
;
(defun Dialog03Macro ()

	(defun Dialog03MakeDialog (TitleLablel LstButton LstDimButton / Dcl Des NameDialog Pos itm Lg LstTabs WidthBox)
	
		;
		; Main
		;
		(if TitleLablel
			(progn
				(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq Des (open Dcl "w"))
				(setq NameDialog (strcat "EasyCut_" (Random_Str 5)))
				(write-line (strcat NameDialog ":dialog {")																										Des)
				(write-line (strcat "label=\"" TitleLablel "\";")																								Des)
				(write-line "           :row {"			                																						Des)
				(write-line "               :boxed_column {"																									Des)
				(write-line "                  label=\"List\";"																									Des)
				;(write-line "                  :row {:toggle {key = \"DeductShape\";  label = \"Scontare le quantita' presenti nelle lamiere\"; value = 1;}}"	Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "                  :row {:text_part {width=4 ; fixed_width=true; label=\"Itm\"; }"	Des)
				(setq Pos 0)
				(foreach itm LstButton
					(setq Lg (LM:rtos (nth Pos LstDimButton) 2 0))
					(write-line (strcat "                        :text_part {width=" Lg "; fixed_width=true; label=\"" itm "\";  }") Des)
					(setq Pos (1+ Pos))
				)	
				(write-line "                  }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "                  :row {:image_button {key=\"Itm\";  height=1.2; width=4.0;  vertical_margin=none; horizontal_margin=none;}"	Des)
				(setq Pos 0)
				(foreach itm LstButton
					(setq Lg (LM:rtos (nth Pos LstDimButton) 2 0))
					(write-line (strcat "                        :image_button {key=\"" itm "\";   height=1.2; width=" Lg "; vertical_margin=none; horizontal_margin=none;}")	Des)
					(setq Pos (1+ Pos))
				)
				(write-line "                  }"																												Des)
				; --------------------------------------------------------------------------------------------------
				
				(setq LstTabs (list 4))
				(foreach itm LstDimButton
					(setq LstTabs (append LstTabs (list (+ (last LstTabs) itm))))
				)
				(setq WidthBox (LM:rtos (last LstTabs) 2 0))
				(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				
				(write-line "                  :row {:list_box {key=\"box_info\";"							Des)
				;(write-line "                                   width=150;"									Des)
				(write-line (strcat "                                   width=" WidthBox ";")				Des)
				(write-line "                                   height=35;"									Des)
				(write-line "                                   fixed_width=true;"							Des)
				(write-line "                                   vertical_margin=none; "						Des)
				(write-line "                                   horizontal_margin=none;"					Des)
				;(write-line "                                   tabs=\"4 16 28 40 90 102 114 126 138\";"	Des)
				(write-line (strcat "                                   tabs=\"" LstTabs "\";")				Des)
				(write-line "                                   multiple_select = true;"					Des)
				(write-line "                        }"														Des)
				(write-line "                  }  "															Des)
				(write-line "              }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "              :boxed_column {label=\"Filter\";"														Des)
				(write-line "                             fixed_height=true;"														Des)
				(write-line "                             alignment =top;"															Des)
				(foreach itm LstButton
					(write-line "                             :row {"																	Des)
					(write-line (strcat "                                   :toggle   {                     	      key=\"" itm "_FilterActive\";    }")	Des)
					(write-line (strcat "                                   :button   {width=16;  label=\"" itm "\";  key=\"" itm "_FilterButton\";    }")	Des)
					(write-line (strcat "                                   :edit_box {width=35;                	  key=\"" itm "_FilterBool\";      }")	Des)
					(write-line "                             }"																		Des)
				)
				; --------------------------------------------------------------------------------------------------
				(write-line "                             :boxed_radio_column {fixed_height=true;"																Des)
				(write-line "                                                  alignment =top;"																	Des)
				(write-line "                                                  :text{ label=\"Filtra\";}"														Des)
				(write-line "                                                  :image {key = \"$progbarsearch$\";"												Des)
				(write-line "                                                          fixed_width  = 50;"														Des)
				(write-line "                                                          height = 1;"																Des)
				(write-line "                                                          color = -15;"															Des)
				(write-line "                                                  }"																				Des)
				(write-line "                             }"																									Des)
				(write-line "             }"																													Des)
				(write-line "           }"																														Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "           Selectall_Import_Save_List_Exit;"	Des)
				(write-line "       }"										Des)
				; --------------------------------------------------------------------------------------------------
				
				
				(write-line "selectall_mybutton : retirement_button {label= \"Seleziona tutto\";key= \"selectall\";}"				Des)
				(write-line "save_mybutton      : retirement_button {label= \"Salva\";          key= \"save\";}"					Des)
				(write-line "import_mybutton    : retirement_button {label= \"Importa\";        key= \"import\";}"					Des)
				(write-line "list_mybutton      : retirement_button {label= \"List\";           key= \"list\";}"					Des)
				(write-line "exit_mybutton      : retirement_button {label= \"Esci\";           key= \"cancel\";  is_cancel=true;}"	Des)
				(write-line "Selectall_Import_Save_List_Exit : column {"	Des)
				(write-line "  : row {fixed_width = true;"					Des)
				(write-line "         alignment = centered;"				Des)
				(write-line "         selectall_mybutton;"					Des)
				(write-line "         :spacer { width = 2; }"				Des)
				(write-line "         import_mybutton;"						Des)
				(write-line "         :spacer { width = 2; }"				Des)
				(write-line "         save_mybutton;"						Des)
				(write-line "         :spacer { width = 2; }"				Des)
				(write-line "         list_mybutton;"						Des)
				(write-line "         :spacer { width = 2; }"				Des)
				(write-line "         exit_mybutton;"						Des)
				(write-line "  }"											Des)
				(write-line "}"												Des)
				(close Des)
			)
		)
		(list Dcl NameDialog)
	)
)
;
(defun Dialog04Macro ()

	(defun Dialog04MakeDialog (TitleLablel LstButton LstDimButton / Dcl Des NameDialog Pos itm Lg LstTabs WidthBox)
	
		;
		; Main
		;
		(if TitleLablel
			(progn
				(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq Des (open Dcl "w"))
				(setq NameDialog (strcat "EasyCut_" (Random_Str 5)))
				(write-line (strcat NameDialog ":dialog {")																										Des)
				(write-line (strcat "label=\"" TitleLablel "\";")																								Des)
				(write-line "           :row {"			                																						Des)
				(write-line "               :boxed_column {"																									Des)
				(write-line "                  label=\"List\";"																									Des)
				;(write-line "                  :row {:toggle {key = \"DeductShape\";  label = \"Scontare le quantita' presenti nelle lamiere\"; value = 1;}}"	Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "                  :row {:text_part {width=4 ; fixed_width=true; label=\"Itm\"; }"	Des)
				(setq Pos 0)
				(foreach itm LstButton
					(setq Lg (LM:rtos (nth Pos LstDimButton) 2 0))
					(write-line (strcat "                        :text_part {width=" Lg "; fixed_width=true; label=\"" itm "\";  }") Des)
					(setq Pos (1+ Pos))
				)	
				(write-line "                  }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "                  :row {:image_button {key=\"Itm\";  height=1.2; width=4.0;  vertical_margin=none; horizontal_margin=none;}"	Des)
				(setq Pos 0)
				(foreach itm LstButton
					(setq Lg (LM:rtos (nth Pos LstDimButton) 2 0))
					(write-line (strcat "                        :image_button {key=\"" itm "\";   height=1.2; width=" Lg "; vertical_margin=none; horizontal_margin=none;}")	Des)
					(setq Pos (1+ Pos))
				)
				(write-line "                  }"																												Des)
				; --------------------------------------------------------------------------------------------------
				
				(setq LstTabs (list 4))
				(foreach itm LstDimButton
					(setq LstTabs (append LstTabs (list (+ (last LstTabs) itm))))
				)
				(setq WidthBox (LM:rtos (last LstTabs) 2 0))
				(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				
				(write-line "                  :row {:list_box {key=\"box_info\";"							Des)
				;(write-line "                                   width=150;"									Des)
				(write-line (strcat "                                   width=" WidthBox ";")				Des)
				(write-line "                                   height=35;"									Des)
				(write-line "                                   fixed_width=true;"							Des)
				(write-line "                                   vertical_margin=none; "						Des)
				(write-line "                                   horizontal_margin=none;"					Des)
				;(write-line "                                   tabs=\"4 16 28 40 90 102 114 126 138\";"	Des)
				(write-line (strcat "                                   tabs=\"" LstTabs "\";")				Des)
				(write-line "                                   multiple_select = true;"					Des)
				(write-line "                        }"														Des)
				(write-line "                  }  "															Des)
				(write-line "              }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "              :boxed_column {label=\"Filter\";"														Des)
				(write-line "                             fixed_height=true;"														Des)
				(write-line "                             alignment =top;"															Des)
				(foreach itm LstButton
					(write-line "                             :row {"																	Des)
					(write-line (strcat "                                   :toggle   {                     	      key=\"" itm "_FilterActive\";    }")	Des)
					(write-line (strcat "                                   :button   {width=16;  label=\"" itm "\";  key=\"" itm "_FilterButton\";    }")	Des)
					(write-line (strcat "                                   :edit_box {width=35;                	  key=\"" itm "_FilterBool\";      }")	Des)
					(write-line "                             }"																		Des)
				)
				(write-line "                             :row {:toggle {key = \"DeductShape\";  label = \"Scontare le quantita' presenti nelle lamiere\"; value = 1;}}"	Des)
				(write-line "                             :row {"																	Des)
				(write-line "                             	:popup_list {"															Des)
				(write-line "                             		label=\"Numero torce:\";"											Des)
				(write-line "                             		key=\"NumberTorch\";"												Des)
				(write-line "                             		value=\"1\";"														Des)
				(write-line "                             		edit_width=16;"														Des)
				(write-line "                             	}"																		Des)
				(write-line "                             }"																		Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "                             :boxed_radio_column {fixed_height=true;"																Des)
				(write-line "                                                  alignment =top;"																	Des)
				(write-line "                                                  :text{ label=\"Filtra\";}"														Des)
				(write-line "                                                  :image {key = \"$progbarsearch$\";"												Des)
				(write-line "                                                          fixed_width  = 50;"														Des)
				(write-line "                                                          height = 1;"																Des)
				(write-line "                                                          color = -15;"															Des)
				(write-line "                                                  }"																				Des)
				(write-line "                             }"																									Des)
				(write-line "             }"																													Des)
				(write-line "           }"																														Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "           Selectall_Import_Save_List_Exit;"	Des)
				(write-line "       }"										Des)
				; --------------------------------------------------------------------------------------------------
				
				
				(write-line "selectall_mybutton : retirement_button {label= \"Seleziona tutto\";key= \"selectall\";}"				Des)
				(write-line "save_mybutton      : retirement_button {label= \"Salva\";          key= \"save\";}"					Des)
				(write-line "import_mybutton    : retirement_button {label= \"Importa\";        key= \"import\";}"					Des)
				(write-line "list_mybutton      : retirement_button {label= \"List\";           key= \"list\";}"					Des)
				(write-line "exit_mybutton      : retirement_button {label= \"Esci\";           key= \"cancel\";  is_cancel=true;}"	Des)
				(write-line "Selectall_Import_Save_List_Exit : column {"	Des)
				(write-line "  : row {fixed_width = true;"					Des)
				(write-line "         alignment = centered;"				Des)
				(write-line "         selectall_mybutton;"					Des)
				(write-line "         :spacer { width = 2; }"				Des)
				(write-line "         import_mybutton;"						Des)
				(write-line "         :spacer { width = 2; }"				Des)
				(write-line "         save_mybutton;"						Des)
				(write-line "         :spacer { width = 2; }"				Des)
				(write-line "         list_mybutton;"						Des)
				(write-line "         :spacer { width = 2; }"				Des)
				(write-line "         exit_mybutton;"						Des)
				(write-line "  }"											Des)
				(write-line "}"												Des)
				(close Des)
			)
		)
		(list Dcl NameDialog)
	)
	;
	
)
;
(Dialog01Macro)
(Dialog02Macro)
(Dialog03Macro)
(Dialog04Macro)
;
(defun ManagementShape (/ GetSelectShape LstTableNesting)

	(defun GetSelectShape (TypeQuantity / Rtn)
		(cond
			((= TypeQuantity "1")
				(GetTableStockDeductShapeNesting)
			)
			((= TypeQuantity "0")
				(GetTableStockShapeNesting)
			)
		)
	)
	;
	; Main ++++++++++++++++++++++++++++++++++++++++++
	;
	(if (not CalcQtyDeduct$) (setq CalcQtyDeduct$ "0"))
	(GuiSelPiecesShapeReduce LstTableNesting)
)
;
(defun GuiSelPiecesShapeReduce (LstTableNesting / 	ValidateList
													
													LstVarBool$
													LstVarActive$
												
													LstTypeValue$
													LstSort$
													LstTableFiltered$
													LstButtonKey
													LstDimButton
													LstTableNesting$
													InfoDialog xx itm
													LstNth Rtn)

	; +--------------------------+
	; 	VRRIABILI GLOBALI
	;	LstFilterShapeReduce$
	;	LstActiveShapeReduce$
	;   Dialog > Dialog01MakeDialog
	; +--------------------------+
	;
	; Main
	;
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstTableNesting	
		(Dialog01ValidateList   		  LstTableNesting 		'( 0      1      2      3      4      5      6      7      8  )))
	(if (not LstFilterShapeReduce$) (setq LstFilterShapeReduce$	'("<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>")))
	(if (not LstActiveShapeReduce$) (setq LstActiveShapeReduce$	'("0"    "0"    "0"    "0"    "0"    "0"    "0"    "0"    "0" )))
	
									(setq LstTypeValue$			'("int"  "str"  "str"  "str"  "int"  "real" "real" "real" "str"))
									(setq LstButtonKey	 		'("Id"   "Comm" "Fase" "Nome" "Qta"  "Spes" "Lung" "Larg" "Mat"))
									(setq LstSort$ 				'( 0      0      0      0      0      0      0      0      0))
									(setq LstDimButton			'(12     12     12     50     12     12     12     12     12))
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								(setq LstTableNesting$  LstTableNesting)
								(setq LstFilter$		LstFilterShapeReduce$)
								(setq LstValBool$		LstActiveShapeReduce$)
	;
	; Make Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(foreach itm LstButtonKey
		(setq LstVarBool$   (append LstVarBool$   (list (strcat itm "_FilterBool$"))))
		(setq LstVarActive$ (append LstVarActive$ (list (strcat itm "_FilterActive$"))))
	)
	
	(Dialog01LoadVar LstVarActive$ LstValBool$)
	(Dialog01LoadVar LstVarBool$   LstFilter$)

	;(setq Pos 0)
	;(foreach itm LstVarBool$
	;	;(eval (read  (strcat "(if (not " itm ") (setq " itm " \"<>\"))")))
	;	(eval (read  (strcat "(setq " itm " \"" (nth Pos LstFilter$) "\")")))
	;	(setq Pos (1+ Pos))
	;)
	;(setq Pos 0)
	;(foreach itm LstVarActive$
	;	;(eval (read  (strcat "(if (not " itm ") (setq " itm " \"0\"))")))
	;	(eval (read  (strcat "(setq " itm " \"" (nth Pos LstValBool$) "\")")))
	;	(setq Pos (1+ Pos))
	;)
	;
	; End Set ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(if (not NameHeadDcl$) (setq NameHeadDcl$ "Lista pezzi"))
	(setq InfoDialog (Dialog01MakeDialog NameHeadDcl$ LstButtonKey LstDimButton))
		
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *InfoTableNesting* ) ( '(-1 -1) )))
	;
	; Set DCL +++++
	;
	(Dialog01SetDclFilter)
	(Dialog01SetMode)
	(Dialog01SetDclList LstTableNesting$ nil)
	(set_tile "DeductShape" CalcQtyDeduct$)

	; Start Action Filter ---------------------------------------------------------------------------------
	(action_tile "DeductShape"	(strcat "(setq CalcQtyDeduct$   (get_tile \"DeductShape\"))"
										"(setq LstTableNesting$ (ValidateList (Dialog01GetSelectShape CalcQtyDeduct$)))"
										"(setq LstTableFiltered$ nil)"
										"(Dialog01SetDclList LstTableNesting$ 1)"))

	(foreach itm LstButtonKey
		(action_tile itm "(Dialog01SortBox LstTableFiltered$ $key LstButtonKey LstSort$ LstTypeValue$)")
	)
	(foreach itm LstButtonKey
		(action_tile (strcat itm "_FilterActive") 					"(Dialog01ActionFilter 1 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil)")
		(action_tile (strcat itm "_FilterButton") 					"(Dialog01ActionFilter 2 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil)")
		(action_tile (strcat itm "_FilterBool")   "(if (= $reason 1) (Dialog01ActionFilter 3 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil))")
	)
	; End Action Filter -----------------------------------------------------------------------------------

	(action_tile "selectall"			"(Dialog01SelectAllBoxList \"box_info\" LstTableFiltered$)")
	(action_tile "box_info" (vl-prin1-to-string '(if (= $reason 4)
													(progn
														(setq LstNth (list $value))
														(setq LstTableFiltered$ (Dialog01ModifiedLstShape LstTableFiltered$ LstNth))
														(Dialog01LoadTable (Dialog01FormatTableNesting LstTableFiltered$) nil)
														(Dialog01UpDateInfoShape LstTableFiltered$)
														(setq LstTableNesting$ (Dialog01UpLstTableNesting LstTableNesting$ LstTableFiltered$))
														(set_tile "box_info" "")
														(Dialog01PutSelectBoxList "box_info" LstNth)
													)
												  )))
	
	(action_tile "modified"	(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(progn
														(setq LstNth (LM:str->lst (get_tile "box_info") " "))
														(setq LstTableFiltered$ (Dialog01ModifiedLstShape LstTableFiltered$ LstNth))
														(Dialog01LoadTable (Dialog01FormatTableNesting LstTableFiltered$) nil)
														(Dialog01UpDateInfoShape LstTableFiltered$)
														(setq LstTableNesting$ (Dialog01UpLstTableNesting LstTableNesting$ LstTableFiltered$))
														(set_tile "box_info" "")
														(Dialog01PutSelectBoxList "box_info" LstNth)
													)
													(alert "Nessun contorno selezionato")
												)))
	(action_tile "list"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													 (ListNesting "SHAPE" (Dialog01GetDataBoxList "box_info" LstTableFiltered$))
													 (alert "Nessun contorno selezionato")
												 )))
	(action_tile "cancel"	"(setq Rtn nil)               (setq *InfoTableNesting* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(action_tile "ok"	    "(setq Rtn LstTableFiltered$) (setq *InfoTableNesting* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(start_dialog)
	
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstFilterShapeReduce$ LstFilter$)
	(setq LstActiveShapeReduce$ LstValBool$)
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	Rtn
)
;
(defun GuiSelPiecesShapeNesting (LstTableNesting OutFileName / 	LstVarBool$
																LstVarActive$
												
																LstTypeValue$
																LstSort$
																LstTableFiltered$
																LstButtonKey
																LstDimButton
																LstTableNesting$
																InfoDialog xx itm SaveFileName LstTorch
																LstNth RtnFile RtnLst)

	; +--------------------------+
	; 	VRRIABILI GLOBALI
	;	LstFilterShape$
	;	LstActiveShape$
	;   Dialog > Dialog04MakeDialog
	; +--------------------------+
	;
	; Main
	;
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstTableNesting	
		(Dialog01ValidateList   	  LstTableNesting 	'( 0      1      2      3      4      5      6      7      8  )))
	(if (not LstFilterShape$) 	(setq LstFilterShape$	'("<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>")))
	(if (not LstActiveShape$) 	(setq LstActiveShape$	'("0"    "0"    "0"    "0"    "0"    "0"    "0"    "0"    "0" )))
	
								(setq LstTypeValue$		'("int"  "str"  "str"  "str"  "int"  "real" "real" "real" "str"))
								(setq LstButtonKey	 	'("Id"   "Comm" "Fase" "Nome" "Qta"  "Spes" "Lung" "Larg" "Mat"))
								(setq LstSort$ 			'( 0      0      0      0      0      0      0      0      0  ))
								(setq LstDimButton		'(12     12     12      50     12    12     12     12     12  ))
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								(setq LstTableNesting$  LstTableNesting)
								(setq LstFilter$		LstFilterShape$)
								(setq LstValBool$		LstActiveShape$)
								(setq SaveFileName 		OutFileName)
	; Set Torch 
	(if (not $NumberTorch$) 	(setq $NumberTorch$ 1))
	; Set qtydeduct
	(if (not CalcQtyDeduct$) 	(setq CalcQtyDeduct$ "1"))
	;							
	; Make Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(foreach itm LstButtonKey
		(setq LstVarBool$   (append LstVarBool$   (list (strcat itm "_FilterBool$"))))
		(setq LstVarActive$ (append LstVarActive$ (list (strcat itm "_FilterActive$"))))
	)
	
	(Dialog01LoadVar LstVarActive$ LstValBool$)
	(Dialog01LoadVar LstVarBool$   LstFilter$)
	;
	; End Set ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(if (not NameHeadDcl$) (setq NameHeadDcl$ "Lista pezzi"))
	(setq InfoDialog (Dialog04MakeDialog NameHeadDcl$ LstButtonKey LstDimButton))
		
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *InfoTableNesting* ) ( '(-1 -1) )))
	;
	; Set DCL +++++
	;
	(Dialog01SetDclFilter)
	(Dialog01SetMode)
	(Dialog01SetDclList LstTableNesting$ $NumberTorch$)
	
	(setq LstTorch '("1" "2" "3" "4"))
	(start_list "NumberTorch")
    (mapcar 'add_list LstTorch)
    (end_list)
	(set_tile "NumberTorch" (itoa (1- $NumberTorch$)))
	(set_tile "DeductShape" CalcQtyDeduct$)
	;
	; Start Action Filter ---------------------------------------------------------------------------------
	;
	(action_tile "DeductShape"	(vl-prin1-to-string '(progn 
														(setq CalcQtyDeduct$    (get_tile "DeductShape"))
														(setq LstTableNesting$  (Dialog01ValidateList (Dialog01GetSelectShape CalcQtyDeduct$) '(0 1 2 3 4 5 6 7 8)))
														(Dialog01GetActiveFilter)
														(Dialog01SetMode)
														(Dialog01SetDclList LstTableNesting$ $NumberTorch$))))
														
	
	(foreach itm LstButtonKey
		(action_tile itm "(Dialog01SortBox LstTableFiltered$ $key LstButtonKey LstSort$ LstTypeValue$)")
	)

	(foreach itm LstButtonKey
		(action_tile (strcat itm "_FilterActive") 					"(Dialog01ActionFilter 1 LstTableNesting$ LstButtonKey $key LstTypeValue$ $NumberTorch$)")
		(action_tile (strcat itm "_FilterButton") 					"(Dialog01ActionFilter 2 LstTableNesting$ LstButtonKey $key LstTypeValue$ $NumberTorch$)")
		(action_tile (strcat itm "_FilterBool")   "(if (= $reason 1) (Dialog01ActionFilter 3 LstTableNesting$ LstButtonKey $key LstTypeValue$ $NumberTorch$))")
	)
	
	(action_tile "NumberTorch"	(vl-prin1-to-string '(progn 
															(setq $NumberTorch$ (atoi (nth (atoi (get_tile "NumberTorch")) LstTorch)))
															(Dialog01GetActiveFilter)
															(Dialog01SetMode)
															(Dialog01SetDclList LstTableNesting$ $NumberTorch$)
													)))
	
	; End Action Filter -----------------------------------------------------------------------------------

	(action_tile "selectall" "(Dialog01SelectAllBoxList \"box_info\" LstTableFiltered$)")
	(action_tile "import"	(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
												    (progn 
														(setq RtnLst (Dialog01GetDataBoxList "box_info" LstTableFiltered$))
														(if (not OutFileName) (setq OutFileName SaveFileName))
														(WriteFileNesting "SHAPE" RtnLst OutFileName ";" $NumberTorch$)
														(setq RtnFile OutFileName)
														(setq *InfoTableNesting* (done_dialog)) (unload_dialog xx)
													)
													(alert "Nessun contorno selezionato")
												)))
	(action_tile "save"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(progn 
														(setq RtnLst (Dialog01GetDataBoxList "box_info" LstTableFiltered$))
														(if (setq OutFileName (OpenFileDialog (list DxfNestingEasyCut$ nil "*.shp|*.*" "Save File Shape" nil T)))
															(progn
																(setq OutFileName (strcat (car OutFileName) "\\" (vl-filename-base (cadr OutFileName)) ".shp"))
																(WriteFileNesting "SHAPE" RtnLst OutFileName ";" $NumberTorch$)
																(setq RtnFile OutFileName)
															)
														)
													)
												    (alert "Nessun contorno selezionato")
												 )))
	(action_tile "list"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													 (ListNesting "SHAPE" (Dialog01GetDataBoxList "box_info" LstTableFiltered$))
													 (alert "Nessun contorno selezionato")
												 )))
	(action_tile "cancel"	"(setq *InfoTableNesting* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(start_dialog)
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstFilterShape$ LstFilter$)
	(setq LstActiveShape$ LstValBool$)
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	(list RtnFile RtnListBox)

)
;
(defun GuiSelPiecesSheetNesting (LstTableNesting OutFileName / 	LstVarBool$
																LstVarActive$
												
																LstTypeValue$
																LstSort$
																LstTableFiltered$
																LstButtonKey
																LstDimButton
																LstTableNesting$
																InfoDialog xx itm SaveFileName
																RtnFile RtnLst)

	; +--------------------------+
	; 	VRRIABILI GLOBALI
	;	LstFilterSheet$
	;	LstActiveSheet$
	;   Dialog > Dialog03MakeDialog
	; +--------------------------+
	;
	; Main
	;
	(if (not LstTableNesting)
		(progn
			(vl-file-delete OutFileName)
			(LM:popup "avvertimento" "Non ci sono lamiere disponibili" (+ 0 48 4096))
		)
	)
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstTableNesting	
		(Dialog01ValidateList   	  LstTableNesting	'( 0        1 	     2         3 	     4	       5	     6        7  )))
	(if (not LstFilterSheet$) 	(setq LstFilterSheet$	'("<>"     "<>"     "<>"      "<>"      "<>"      "<>"      "<>"     "<>")))
	(if (not LstActiveSheet$) 	(setq LstActiveSheet$	'("0"      "0"      "0"       "0"       "0"       "0"       "0"      "0" )))
	
								(setq LstTypeValue$		'("int"	   "str"    "real"    "real"	"real"    "real"    "real"   "str"))
								(setq LstButtonKey	 	'("Id"	   "Stock"  "Width"   "Length"  "Thk"     "Surface" "Weight" "Mat"))
								(setq LstSort$ 			'( 0        0        0         0         0         0         0        0))
								(setq LstDimButton		'( 12       25    	 12        12        12        12        12       12))
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								(setq LstTableNesting$  LstTableNesting)
								(setq LstFilter$		LstFilterSheet$)
								(setq LstValBool$		LstActiveSheet$)
								(setq SaveFileName 		OutFileName)
	;							
	; Make Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(if (not NameHeadDcl$) (setq NameHeadDcl$ "Lista lamiere nesting"))
	
	(foreach itm LstButtonKey
		(setq LstVarBool$   (append LstVarBool$   (list (strcat itm "_FilterBool$"))))
		(setq LstVarActive$ (append LstVarActive$ (list (strcat itm "_FilterActive$"))))
	)
	(Dialog01LoadVar LstVarActive$ LstValBool$)
	(Dialog01LoadVar LstVarBool$   LstFilter$)
	;
	; End Set ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(setq InfoDialog (Dialog03MakeDialog NameHeadDcl$ LstButtonKey LstDimButton))
		
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *InfoTableSheet* ) ( '(-1 -1) )))
	;
	; Set DCL +++++
	;
	(Dialog01SetDclFilter)
	(Dialog01SetMode)
	(Dialog01SetDclList LstTableNesting$ nil)

	(foreach itm LstButtonKey
		(action_tile itm "(Dialog01SortBox LstTableFiltered$ $key LstButtonKey LstSort$ LstTypeValue$)")
	)
	; Start Action Filter ---------------------------------------------------------------------------------
	(foreach itm LstButtonKey
		(action_tile (strcat itm "_FilterActive") 					"(Dialog01ActionFilter 1 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil)")
		(action_tile (strcat itm "_FilterButton") 					"(Dialog01ActionFilter 2 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil)")
		(action_tile (strcat itm "_FilterBool")   "(if (= $reason 1) (Dialog01ActionFilter 3 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil))")
	)
	; End Action Filter -----------------------------------------------------------------------------------

	(action_tile "selectall"			"(Dialog01SelectAllBoxList \"box_info\" LstTableFiltered$)")

	(action_tile "import"	(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(progn
														(setq RtnLst (Dialog01GetDataBoxList "box_info" LstTableFiltered$))
														(if (not OutFileName) (setq OutFileName SaveFileName))
														(WriteFileNesting "SHEET" RtnLst OutFileName ";" nil)
														(setq RtnFile OutFileName)
													    ;(setq RtnLst (mapcar 'cadr (Dialog01GetDataBoxList "box_info" LstTableFiltered$)))
													    (setq Import T *InfoTablSheet* (done_dialog))
													    (unload_dialog xx)
													)
													(alert "Nessun file selezionato")
												)))

	(action_tile "save"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(progn 
														(setq RtnLst (Dialog01GetDataBoxList "box_info" LstTableFiltered$))
														(if (setq OutFileName (OpenFileDialog (list DxfNestingEasyCut$ nil "*.sht" "Save File Sheet" nil T)))
															(progn
																(setq OutFileName (strcat (car OutFileName) "\\" (vl-filename-base (cadr OutFileName)) ".sht"))
																(WriteFileNesting "SHEET" RtnLst OutFileName ";" nil)
																(setq RtnFile OutFileName)
															)
														)
													)
												    (alert "Nessun contorno selezionato")
											     )))

	(action_tile "list"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													 (ListNesting "SHEET" (Dialog01GetDataBoxList "box_info" LstTableFiltered$))
													 (alert "Nessun contorno selezionato")
												 )))
	(action_tile "cancel"	"(setq *InfoTablSheet* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(start_dialog)
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstFilterSheet$ LstFilter$)
	(setq LstActiveSheet$ LstValBool$)
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	(list RtnFile RtnLst)
	
)
;
(defun GuiSelPiecesShapeImport (LstTableNesting /	AssocFileName
													AddIdTableNesting
													RemoveIdTableNesting
													
													LstVarBool$
													LstVarActive$
												
													LstTypeValue$
													LstSort$
													LstTableFiltered$
													LstTableNesting$
													LstButtonKey
													LstDimButton
													
													InfoDialog xx itm Pos
													LstNth Import Rtn
													AssocFileGiuid LstFile )

	; +--------------------------+
	; 	VRRIABILI GLOBALI
	;	LstFilterImport$
	;	LstActiveImport$
	;   Dialog > Dialog02MakeDialog
	; +--------------------------+
	;
	; Main
	;
	(defun AssocFileName (LstNesting LstAssoc / Rtn)
		(if (and LstNesting LstAssoc)
			(foreach itm LstNesting
				(setq Rtn (append Rtn (list (cadr (assoc (cadr itm) LstAssoc)))))
			)
		)
		Rtn
	)
	;
	(defun AddIdTableNesting (LstTableNesting / Pos itm IdName AssocFileGiuid LstTableNesting)
	
		(setq Pos 0)
		(foreach itm LstTableNesting
			(setq IdName (Random_Str 9))
			(setq AssocFileGiuid 	(append AssocFileGiuid (list (list IdName (car itm)))))
			(setq itm 				(append  (list IdName) (LM:SubstNth (strcat (vl-filename-base (nth 0 itm)) (vl-filename-extension (nth 0 itm))) 0 itm) ))
			(setq LstTableNesting 	(LM:SubstNth itm Pos LstTableNesting))
			(setq Pos (1+ Pos))
		)
		(list AssocFileGiuid LstTableNesting)
	)
	;
	(defun RemoveIdTableNesting (LstTableNesting)
		(RemoveNthNestedList LstTableNesting (list 1))
	)
	;
	; Main
	;	
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstTableNesting	
		(Dialog01ValidateList    		  LstTableNesting 		'( 0      1      2      3      4      5      6      7      8         )))
	(if (not LstFilterImport$) 		(setq LstFilterImport$		'("<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>")))
	(if (not LstActiveImport$) 		(setq LstActiveImport$		'("0"    "0"    "0"    "0"    "0"    "0"    "0"    "0"    "0"    "0" )))
	
									(setq LstTypeValue$			'("int" "str"  "str"  "str"  "str"  "int"  "real" "real" "real" "str"))
									(setq LstButtonKey	 		'("Id"  "File" "Comm" "Fase" "Nome" "Qta"  "Spes" "Lung" "Larg" "Mat"))
									(setq LstSort$ 				'( 0     0      0      0      0      0      0      0      0      0))
									(setq LstDimButton			'( 12    30     10     10     15     5      5      8      8      8))
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									;
									; Add id to list
									;
									(setq Rtn 					(AddIdTableNesting LstTableNesting))
									(setq AssocFileGiuid  		(car Rtn))
									(setq LstTableNesting 		(cadr Rtn))
									(setq Rtn 					nil)
									(setq LstTableNesting$  	LstTableNesting)
									(setq LstFilter$			LstFilterImport$)
									(setq LstValBool$			LstActiveImport$)
	;
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(foreach itm LstButtonKey
		(setq LstVarBool$   (append LstVarBool$   (list (strcat itm "_FilterBool$"))))
		(setq LstVarActive$ (append LstVarActive$ (list (strcat itm "_FilterActive$"))))
	)
	(Dialog01LoadVar LstVarActive$ LstValBool$)
	(Dialog01LoadVar LstVarBool$   LstFilter$)
	;
	; End Set ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(if (not NameHeadDcl$) (setq NameHeadDcl$ "Lista Import"))
	(setq InfoDialog (Dialog02MakeDialog NameHeadDcl$ LstButtonKey LstDimButton))
		
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *InfoTableNesting* ) ( '(-1 -1) )))
	;
	; Set DCL +++++
	;
	(Dialog01SetDclFilter)
	(Dialog01SetMode)
	(Dialog01SetDclList LstTableNesting$ nil)

	(foreach itm LstButtonKey
		(action_tile itm "(Dialog01SortBox LstTableFiltered$ $key LstButtonKey LstSort$ LstTypeValue$)")
	)
	; Start Action Filter ---------------------------------------------------------------------------------
	(foreach itm LstButtonKey
		(action_tile (strcat itm "_FilterActive") 					"(Dialog01ActionFilter 1 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil)")
		(action_tile (strcat itm "_FilterButton") 					"(Dialog01ActionFilter 2 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil)")
		(action_tile (strcat itm "_FilterBool")   "(if (= $reason 1) (Dialog01ActionFilter 3 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil))")
	)
	; End Action Filter -----------------------------------------------------------------------------------

	(action_tile "selectall" "(Dialog01SelectAllBoxList \"box_info\" LstTableFiltered$)")
	
	(action_tile "list"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(ListNesting "SHAPE" (RemoveIdTableNesting (Dialog01GetDataBoxList "box_info" LstTableFiltered$)))
													(alert "Nessun contorno selezionato")
												 )))
	(action_tile "show"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(ShowDstv (AssocFileName (Dialog01GetDataBoxList "box_info" LstTableFiltered$) AssocFileGiuid))
													(alert "Nessun contorno selezionato")
												 )))

	(action_tile "import"	(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(progn
														(setq Rtn (AssocFileName (Dialog01GetDataBoxList "box_info" LstTableFiltered$) AssocFileGiuid))
													    ;(setq Rtn (mapcar 'cadr (Dialog01GetDataBoxList "box_info" LstTableFiltered$)))
													    (setq Import T *InfoTableNesting* (done_dialog))
													    (unload_dialog xx)
													)
													(alert "Nessun file selezionato")
												)))
	(action_tile "cancel"	"(setq Rtn nil) (setq *InfoTableNesting* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(start_dialog)

	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstFilterImport$ LstFilter$)
	(setq LstActiveImport$ LstValBool$)
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	Rtn	
)
