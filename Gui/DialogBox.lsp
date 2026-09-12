(defun Dialog01Lib ()

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
	(defun Dialog01ModifiedLstShape (LstShape LstNth LstButtonKey LstTypeValue LstDimButton LstModeData / LstShapeToLstSelected LstSelectedToLstShape
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
		(if (and LstShape LstNth LstButtonKey LstTypeValue LstDimButton LstModeData)
			(progn
				(setq NRow 10)
				(setq LstSelected   (LstShapeToLstSelected LstShape LstNth))
				;(setq LstTitleData  '("Itm" "Ident" "Comm" "Fase" "Marca" "Qta" "Spes" "Lung" "Larg" "Mat"))
				;(setq LstTypeData	'("int" "str"   "str"  "str"  "str"   "int" "int"  "real" "real" "str"))
				(setq LstTitleData  LstButtonKey)
				(setq LstTypeData	LstTypeValue)
				;(setq LstModeData   '(1 1 0 0 0 0 0 1 1 0))
				(if (setq RtnLstSelected (GuiScrollList LstSelected LstTypeData LstTitleData LstDimButton LstModeData NRow))
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
	(defun Dialog01LoadVar (LstName LstVal / FolderTmp File Stream PosVar PosVal Rtn Chk)

		;(setq File 		(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Tmp\\var.lsp"))
		;(setq File 		(strcat (vl-registry-read EasyCutRegistryPath$ "PathCfg") "\\var.lsp"))
		;(setq Stream	(open File "w"))

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
			;(write-line (strcat "(setq " (nth PosVar LstName) " \"" Rtn "\")")	Stream)
			(set (read (nth PosVar LstName)) Rtn)
			(setq PosVar (1+ PosVar))
		)
		;(close Stream)
		;(load File)
		
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
	;
	(defun Dialog01CheckList (LstChk LstDefault)
		(if (not LstChk)
			LstDefault
			(if (member nil LstChk)
				LstDefault
				LstChk
			)
		)
	)
)
;
(defun Dialog01Box ()

	(defun Dialog01MakeDialog (TitleLablel LstButton LstDimButton LstNameActionDcl / Dcl Des NameDialog Pos itm Lg LstTabs WidthBox PixelReduce Reduce)
	
		;
		; Main
		;
		(setq PixelReduce 6.0)

		(if TitleLablel
			(progn
				(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq Des (open Dcl "w"))
				(setq NameDialog (strcat "EasyCut_" (Random_Str 5)))
				(write-line (strcat NameDialog ":dialog {")																										Des)
				(write-line (strcat "label=\"" TitleLablel "\";")																								Des)
				(write-line "           :row {"			                																						Des)
				(write-line "               :boxed_column {"																									Des)
				(write-line "                  label=\"BoxList\";"																									Des)
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
				(setq Reduce (/ PixelReduce (- (length LstDimButton) 1)))
				(foreach itm LstDimButton
					(setq LstTabs (append LstTabs (list (- (+ (last LstTabs) itm) Reduce))))
				)
				(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				;(foreach itm LstDimButton
				;	(setq LstTabs (append LstTabs (list (+ (last LstTabs) itm))))
				;)
				;(setq WidthBox (LM:rtos (last LstTabs) 2 0))
				;(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))

				(write-line "                  :row {:list_box {key=\"box_info\";"							Des)
				;(write-line (strcat "                                   width=" WidthBox ";")				Des)--------------- modifica 22/02/2026
				(write-line "                                   height=35;"									Des)
				;(write-line "                                   fixed_width=true;"							Des)--------------- modifica 22/02/2026
				(write-line "                                   vertical_margin=none; "						Des)
				(write-line "                                   horizontal_margin=none;"					Des)
				(write-line (strcat "                                   tabs=\"" LstTabs "\";")		        Des)
				(write-line "                                   multiple_select = true;"					Des)
				(write-line "                        }"														Des)
				(write-line "                  }  "															Des)
				(write-line "              }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "              :boxed_column {label=\"BoxFilter\";"														Des)
				(write-line "                             fixed_height=true;"														Des)
				(write-line "                             alignment =top;"															Des)
				
				(foreach itm LstButton
					(write-line "                             :row {"																	Des)
					(write-line (strcat "                                   :toggle   {                     	      key=\"" itm "_FilterActive\";    }")	Des)
					(write-line (strcat "                                   :button   {width=20;  label=\"" itm "\";  key=\"" itm "_FilterButton\";    }")	Des)
					(write-line (strcat "                                   :edit_box {width=35;                	  key=\"" itm "_FilterBool\";      }")	Des)
					(write-line "                             }"																		Des)
				)
				(write-line "                             :row {:toggle {key = \"DeductShape\";  label = \"Scontare le quantita' presenti nelle lamiere\"; value = 1;}}"	Des)
				(write-line "                             :row {:button {width=16;  label=\"Ordina\";  key=\"SortButton\";    }}"											Des)
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
				(write-line "           Selezionatutto_Modifica_Lista_Esci;"	Des)
				(write-line "       }"										Des)
				; --------------------------------------------------------------------------------------------------
				
				(write-line "selectall_mybutton : retirement_button {label= \"Seleziona tutto\";key= \"selectall\";}"				Des)
				(write-line "modified_mybutton  : retirement_button {label= \"Modifica\";       key= \"modified\";}"				Des)
				(write-line "list_mybutton      : retirement_button {label= \"List\";           key= \"list\";}"				    Des)
				;(write-line "ok_mybutton        : retirement_button {label= \"Ok\";             key= \"ok\";}"	                    Des)
				(write-line "exit_mybutton      : retirement_button {label= \"Esci\";           key= \"cancel\";is_cancel= true;}"	Des)
				(write-line "Selezionatutto_Modifica_Lista_Esci : column {"   	Des)
				(write-line "               :row {fixed_width = true;"   		Des)
				(write-line "                     alignment = centered;"   		Des)
				(write-line "                     selectall_mybutton;"   		Des)
				(write-line "                     :spacer { width = 2; }"   	Des)
				(write-line "                     modified_mybutton;"   		Des)
				(write-line "                     :spacer { width = 2; }"   	Des)
				(write-line "                     list_mybutton;"   			Des)
				;(write-line "                     :spacer { width = 2; }"   	Des)
				;(write-line "                     ok_mybutton;"   		    	Des)
				(write-line "                     :spacer { width = 2; }"   	Des)
				(write-line "                     exit_mybutton;"   			Des)
				(write-line "              }"   								Des)
				(write-line "}"    												Des)
				(close Des)
			)
		)
		;(EasyCutViewer Dcl)
		(list Dcl NameDialog)
	)
)
;
(defun Dialog02Box ()

	(defun Dialog02MakeDialog (TitleLablel LstButton LstDimButton LstNameActionDcl / Dcl Des NameDialog Pos itm Lg LstTabs PixelReduce Reduce)
	
		;
		; Main
		;
		(setq PixelReduce 6.0)
		
		(if TitleLablel
			(progn
				(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq Des (open Dcl "w"))
				(setq NameDialog (strcat "EasyCut_" (Random_Str 5)))
				(write-line (strcat NameDialog ":dialog {")																										Des)
				(write-line (strcat "label=\"" TitleLablel "\";")																								Des)
				(write-line "           :row {"			                																						Des)
				(write-line "               :boxed_column {"																									Des)
				(write-line "                  label=\"BoxList\";"																									Des)
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
				
				(setq Reduce (/ PixelReduce (- (length LstDimButton) 1)))
				(foreach itm LstDimButton
					(setq LstTabs (append LstTabs (list (- (+ (last LstTabs) itm) Reduce))))
				)
				(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				
				(write-line "                  :row {:list_box {key=\"box_info\";"							Des)
				;(write-line (strcat "                                   width=" WidthBox ";")				Des)--------------- modifica 22/02/2026
				(write-line "                                   height=35;"									Des)
				;(write-line "                                   fixed_width=true;"							Des)--------------- modifica 22/02/2026
				(write-line "                                   vertical_margin=none; "						Des)
				(write-line "                                   horizontal_margin=none;"					Des)
				(write-line (strcat "                                   tabs=\"" LstTabs "\";")				Des)
				(write-line "                                   multiple_select = true;"					Des)
				(write-line "                        }"														Des)
				(write-line "                  }  "															Des)
				(write-line "              }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "              :boxed_column {label=\"BoxFilter\";"														Des)
				(write-line "                             fixed_height=true;"														Des)
				(write-line "                             alignment =top;"															Des)
				
				(foreach itm LstButton
					(write-line "                             :row {"																	Des)
					(write-line (strcat "                                   :toggle   {                     	      key=\"" itm "_FilterActive\";    }")	Des)
					(write-line (strcat "                                   :button   {width=20;  label=\"" itm "\";  key=\"" itm "_FilterButton\";    }")	Des)
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
				(write-line "list_mybutton      : retirement_button {label= \"Lista\";          key= \"list\";}"					Des)
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
				;(EasyCutViewer Dcl)
			)
		)
		(list Dcl NameDialog)
	)
)
;
(defun Dialog03Box ()

	(defun Dialog03MakeDialog (TitleLablel LstButton LstDimButton LstNameActionDcl / Dcl Des NameDialog Pos itm Lg LstTabs WidthBox PixelReduce Reduce)
	
		;
		; Main
		;
		(setq PixelReduce 6.0)
		
		(if TitleLablel
			(progn
				(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq Des (open Dcl "w"))
				(setq NameDialog (strcat "EasyCut_" (Random_Str 5)))
				(write-line (strcat NameDialog ":dialog {")																										Des)
				(write-line (strcat "label=\"" TitleLablel "\";")																								Des)
				(write-line "           :row {"			                																						Des)
				(write-line "               :boxed_column {"																									Des)
				(write-line "                  label=\"BoxList\";"																									Des)
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
				(setq Reduce (/ PixelReduce (- (length LstDimButton) 1)))
				(foreach itm LstDimButton
					(setq LstTabs (append LstTabs (list (- (+ (last LstTabs) itm) Reduce))))
				)
				(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))

				;(foreach itm LstDimButton
				;	(setq LstTabs (append LstTabs (list (+ (last LstTabs) itm))))
				;)
				;(setq WidthBox (LM:rtos (last LstTabs) 2 0))
				;(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				
				(write-line "                  :row {:list_box {key=\"box_info\";"							Des)
				;(write-line (strcat "                                   width=" WidthBox ";")				Des) --------------- modifica 22/02/2026
				(write-line "                                   height=35;"									Des)
				;(write-line "                                   fixed_width=true;"							Des) --------------- modifica 22/02/2026
				(write-line "                                   vertical_margin=none; "						Des)
				(write-line "                                   horizontal_margin=none;"					Des)
				(write-line (strcat "                                   tabs=\"" LstTabs "\";")				Des)
				(write-line "                                   multiple_select = true;"					Des)
				(write-line "                        }"														Des)
				(write-line "                  }  "															Des)
				(write-line "              }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "              :boxed_column {label=\"BoxFilter\";"														Des)
				(write-line "                             fixed_height=true;"														Des)
				(write-line "                             alignment =top;"															Des)
				(foreach itm LstButton
					(write-line "                             :row {"																	Des)
					(write-line (strcat "                                   :toggle   {                     	      key=\"" itm "_FilterActive\";    }")	Des)
					(write-line (strcat "                                   :button   {width=20;  label=\"" itm "\";  key=\"" itm "_FilterButton\";    }")	Des)
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
				
				
				(write-line (strcat "selectall_mybutton : retirement_button {label= \"" (nth 0 LstNameActionDcl) "\";key= \"selectall\";}"				 ) Des)
				(write-line (strcat "save_mybutton      : retirement_button {label= \"" (nth 1 LstNameActionDcl) "\";key= \"save\";}"					 ) Des)
				(write-line (strcat "import_mybutton    : retirement_button {label= \"" (nth 2 LstNameActionDcl) "\";key= \"import\";}"					 ) Des)
				(write-line (strcat "list_mybutton      : retirement_button {label= \"" (nth 3 LstNameActionDcl) "\";key= \"list\";}"					 ) Des)
				(write-line (strcat "exit_mybutton      : retirement_button {label= \"" (nth 4 LstNameActionDcl) "\";key= \"cancel\";  is_cancel=true;}" ) Des)
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
(defun Dialog04Box ()

	(defun Dialog04MakeDialog (TitleLablel LstButton LstDimButton LstNameActionDcl / Dcl Des NameDialog Pos itm Lg LstTabs WidthBox PixelReduce Reduce)
	
		;
		; Main
		;
		(setq PixelReduce 6.0)

		(if TitleLablel
			(progn
				(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq Des (open Dcl "w"))
				(setq NameDialog (strcat "EasyCut_" (Random_Str 5)))
				(write-line (strcat NameDialog ":dialog {")																										Des)
				(write-line (strcat "label=\"" TitleLablel "\";")																								Des)
				(write-line "           :row {"			                																						Des)
				(write-line "               :boxed_column {"																									Des)
				(write-line "                  label=\"BoxList\";"																									Des)
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
				(setq Reduce (/ PixelReduce (- (length LstDimButton) 1)))
				(foreach itm LstDimButton
					(setq LstTabs (append LstTabs (list (- (+ (last LstTabs) itm) Reduce))))
				)
				(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				;(foreach itm LstDimButton
				;	(setq LstTabs (append LstTabs (list (+ (last LstTabs) itm))))
				;)
				;(setq WidthBox (LM:rtos (last LstTabs) 2 0))
				;(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				
				(write-line "                  :row {:list_box {key=\"box_info\";"							Des)
				;(write-line (strcat "                                   width=" WidthBox ";")				Des) --------------- modifica 22/02/2026
				(write-line "                                   height=35;"									Des)
				;(write-line "                                   fixed_width=true;"							Des) --------------- modifica 22/02/2026
				(write-line "                                   vertical_margin=none; "						Des)
				(write-line "                                   horizontal_margin=none;"					Des)
				(write-line (strcat "                                   tabs=\"" LstTabs "\";")				Des)
				(write-line "                                   multiple_select = true;"					Des)
				(write-line "                        }"														Des)
				(write-line "                  }  "															Des)
				(write-line "              }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "              :boxed_column {label=\"BoxFilter\";"														Des)
				(write-line "                             fixed_height=true;"														Des)
				(write-line "                             alignment =top;"															Des)
				(foreach itm LstButton
					(write-line "                             :row {"																	Des)
					(write-line (strcat "                                   :toggle   {                     	      key=\"" itm "_FilterActive\";    }")	Des)
					(write-line (strcat "                                   :button   {width=20;  label=\"" itm "\";  key=\"" itm "_FilterButton\";    }")	Des)
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
				(write-line "list_mybutton      : retirement_button {label= \"Lista\";          key= \"list\";}"					Des)
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
(defun Dialog05Box ()

	(defun Dialog05MakeDialog (TitleLablel LstButton LstDimButton LstNameActionDcl / Dcl Des NameDialog Pos itm Lg LstTabs WidthBox PixelReduce Reduce)
	
		;
		; Main
		;
		(setq PixelReduce 6.0)

		(if TitleLablel
			(progn
				(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq Des (open Dcl "w"))
				(setq NameDialog (strcat "EasyCut_" (Random_Str 5)))
				(write-line (strcat NameDialog ":dialog {")																										Des)
				(write-line (strcat "label=\"" TitleLablel "\";")																								Des)
				(write-line "           :row {"			                																						Des)
				(write-line "               :boxed_column {"																									Des)
				(write-line "                  label=\"BoxList\";"																									Des)
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
				(setq Reduce (/ PixelReduce (- (length LstDimButton) 1)))
				(foreach itm LstDimButton
					(setq LstTabs (append LstTabs (list (- (+ (last LstTabs) itm) Reduce))))
				)
				(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				;(foreach itm LstDimButton
				;	(setq LstTabs (append LstTabs (list (+ (last LstTabs) itm))))
				;)
				;(setq WidthBox (LM:rtos (last LstTabs) 2 0))
				;(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				
				(write-line "                  :row {:list_box {key=\"box_info\";"							Des)
				;(write-line (strcat "                                   width=" WidthBox ";")				Des) --------------- modifica 22/02/2026
				(write-line "                                   height=35;"									Des)
				;(write-line "                                   fixed_width=true;"							Des) --------------- modifica 22/02/2026
				(write-line "                                   vertical_margin=none; "						Des)
				(write-line "                                   horizontal_margin=none;"					Des)
				(write-line (strcat "                                   tabs=\"" LstTabs "\";")				Des)
				(write-line "                                   multiple_select = true;"					Des)
				(write-line "                        }"														Des)
				(write-line "                  }  "															Des)
				(write-line "              }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "              :boxed_column {label=\"BoxFilter\";"														Des)
				(write-line "                             fixed_height=true;"														Des)
				(write-line "                             alignment =top;"															Des)
				(foreach itm LstButton
					(write-line "                             :row {"																	Des)
					(write-line (strcat "                                   :toggle   {                     	      key=\"" itm "_FilterActive\";    }")	Des)
					(write-line (strcat "                                   :button   {width=20;  label=\"" itm "\";  key=\"" itm "_FilterButton\";    }")	Des)
					(write-line (strcat "                                   :edit_box {width=35;                	  key=\"" itm "_FilterBool\";      }")	Des)
					(write-line "                             }"																		Des)
				)
				(write-line "                             :row {:toggle {key = \"DeductShape\";  label = \"Scontare le quantita' presenti nelle lamiere\"; value = 1;}}"	Des)
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
				
				
				(write-line (strcat "selectall_mybutton : retirement_button {label=\"" (nth 0 LstNameActionDcl) "\";key= \"selectall\";}"				) Des)
				(write-line (strcat "save_mybutton      : retirement_button {label=\"" (nth 1 LstNameActionDcl) "\";key= \"save\";}"					) Des)
				(write-line (strcat "import_mybutton    : retirement_button {label=\"" (nth 2 LstNameActionDcl) "\";key= \"import\";}"					) Des)
				(write-line (strcat "list_mybutton      : retirement_button {label=\"" (nth 3 LstNameActionDcl) "\";key= \"list\";}"					) Des)
				(write-line (strcat "exit_mybutton      : retirement_button {label=\"" (nth 4 LstNameActionDcl) "\";key= \"cancel\";  is_cancel=true;}"	) Des)
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
				;(EasyCutViewer Dcl)
			)
		)
		(list Dcl NameDialog)
	)
	;
	
)
;
(defun Dialog06Box ()

	(defun Dialog06MakeDialog (TitleLablel LstButton LstDimButton LstNameActionDcl / Dcl Des NameDialog Pos itm Lg LstTabs WidthBox PixelReduce Reduce)
	
		;
		; Main
		;
		(setq PixelReduce 6.0)
		
		(if TitleLablel
			(progn
				(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq Des (open Dcl "w"))
				(setq NameDialog (strcat "EasyCut_" (Random_Str 5)))
				(write-line (strcat NameDialog ":dialog {")																						Des)
				(write-line (strcat "label=\"" TitleLablel "\";")																				Des)
				(write-line "           :row {"																									Des)
				(write-line "               :boxed_column {"																					Des)
				(write-line "                  label=\"BoxList\";"																				Des)
				(write-line "                  :row {:text {key = \"FileCsv\";  label = \"File \";}}"											Des)
				(write-line "                  :row {width=4 ; fixed_width=true;"																Des)
				(write-line "                        :button   {width=25; fixed_width=true; label=\"Carica archivio\"; key=\"LoadCsv\";}"		Des)
				(write-line "                        :button   {width=25; fixed_width=true; label=\"Nuovo archivio\";  key=\"NewCsv\";}"		Des)
				(write-line "                        :button   {width=25; fixed_width=true; label=\"Aggiungi Dxf\";    key=\"AddDxf\";}"		Des)
				(write-line "                        :button   {width=25; fixed_width=true; label=\"Rimuovi Dxf\";     key=\"RemDxf\";}"		Des)
				(write-line "                        :button   {width=25; fixed_width=true; label=\"Salva archivio\";  key=\"SaveCsv\";}"		Des)
				(write-line "                  }"																								Des)
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
				(setq Reduce (/ PixelReduce (- (length LstDimButton) 1)))
				(foreach itm LstDimButton
					(setq LstTabs (append LstTabs (list (- (+ (last LstTabs) itm) Reduce))))
				)
				(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				;(foreach itm LstDimButton
				;	(setq LstTabs (append LstTabs (list (+ (last LstTabs) itm))))
				;)
				;(setq WidthBox (LM:rtos (last LstTabs) 2 0))
				;(setq LstTabs (substr (vl-princ-to-string LstTabs) 2 (- (strlen (vl-princ-to-string LstTabs)) 2)))
				
				(write-line "                  :row {:list_box {key=\"box_info\";"							Des)
				;(write-line (strcat "                                   width=" WidthBox ";")				Des) --------------- modifica 22/02/2026
				(write-line "                                   height=35;"									Des)
				;(write-line "                                   fixed_width=true;"							Des) --------------- modifica 22/02/2026
				(write-line "                                   vertical_margin=none; "						Des)
				(write-line "                                   horizontal_margin=none;"					Des)
				(write-line (strcat "                                   tabs=\"" LstTabs "\";")				Des)
				(write-line "                                   multiple_select = true;"					Des)
				(write-line "                        }"														Des)
				(write-line "                  }  "															Des)
				(write-line "              }"																Des)
				; --------------------------------------------------------------------------------------------------
				(write-line "              :boxed_column {label=\"BoxFilter\";"														Des)
				(write-line "                             fixed_height=true;"														Des)
				(write-line "                             alignment =top;"															Des)
				
				(foreach itm LstButton
					(write-line "                             :row {"																						Des)
					(write-line (strcat "                                   :toggle   {                     	      key=\"" itm "_FilterActive\";    }")	Des)
					(write-line (strcat "                                   :button   {width=20;  label=\"" itm "\";  key=\"" itm "_FilterButton\";    }")	Des)
					(write-line (strcat "                                   :edit_box {width=35;                	  key=\"" itm "_FilterBool\";      }")	Des)
					(write-line "                             }"																							Des)
				)
				;(write-line "                             :row {:toggle {key = \"DeductShape\";  label = \"Scontare le quantita' presenti nelle lamiere\"; value = 1;}}"	Des)
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
				(write-line "           Choise;"	Des)
				(write-line "       }"				Des)
				; --------------------------------------------------------------------------------------------------


				(write-line "selectall_mybutton : retirement_button {label= \"Seleziona tutto\";key= \"selectall\";}"				Des)
				(write-line "show_mybutton      : retirement_button {label= \"Show\";           key= \"showdxf\";}"					Des)
				(write-line "modified_mybutton  : retirement_button {label= \"Modifica\";       key= \"modified\";}"				Des)
				(write-line "list_mybutton      : retirement_button {label= \"Lista\";          key= \"list\";}"				    Des)
				(write-line "import_mybutton    : retirement_button {label= \"Salva e Importa\";key= \"import\";}"				    Des)
				(write-line "exit_mybutton      : retirement_button {label= \"Esci\";           key= \"cancel\";is_cancel= true;}"	Des)

				(write-line "Choise : column {"   					Des)
				(write-line "        :row {fixed_width = true;"   	Des)
				(write-line "              alignment = centered;"   Des)
				(write-line "              selectall_mybutton;"   	Des)
				(write-line "              :spacer { width = 2; }"  Des)
				(write-line "              show_mybutton;"   		Des)
				(write-line "              :spacer { width = 2; }"  Des)
				(write-line "              modified_mybutton;"   	Des)
				(write-line "              :spacer { width = 2; }"  Des)
				(write-line "              list_mybutton;"   		Des)
				(write-line "              :spacer { width = 2; }"  Des)
				(write-line "              import_mybutton;"   	    Des)
				(write-line "              :spacer { width = 2; }"  Des)
				(write-line "              exit_mybutton;"   		Des)
				(write-line "           }"   						Des)
				(write-line "}"    									Des)
				(close Des)
			)
		)
		;(EasyCutViewer Dcl)
		(list Dcl NameDialog)
	)
)
;
(Dialog01Lib)
(Dialog01Box)
(Dialog02Box)
(Dialog03Box)
(Dialog04Box)
(Dialog05Box)
(Dialog06Box)
;
(defun TestDialog (/ MakeDialog ActiveDialog
					 InfoDialog xx LstDialog NameDialog)

	(defun MakeDialog (TitleLablel / Dcl Des NameDialog)
		(if TitleLablel
			(progn
				(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
				(setq Des (open Dcl "w"))
				(setq NameDialog (strcat "EasyCut_" (Random_Str 5)))
				(write-line (strcat NameDialog ":dialog {")							Des)
				(write-line (strcat "label=\"" TitleLablel "\";")					Des)
				(write-line "           :row {"			                			Des)
				(write-line "                   :popup_list {"						Des)
				(write-line "                      		label=\"Dialogo n. :\";"		Des)
				(write-line "                     		key=\"DialogList\";"		Des)
				(write-line "                      		value=\"0\";"				Des)
				(write-line "                      		edit_width=20;"				Des)
				(write-line "                    }"									Des)
				(write-line "                }"										Des)
				(write-line "           ok_cancel;"	Des)
				(write-line "           }"											Des)
				(close Des)
				;(EasyCutViewer Dcl)
			)
		)
		(list Dcl NameDialog)
	)
	;
	(defun ActiveDialog (NameDialog / LstNameActionDcl File Stream Action DialogName NthAction LstAction)


			(setq LstNameActionDcl '(	("Seleziona tutto" "Salva" "Importa" "Lista" "Esci")
										("Seleziona tutto" "Salva" "Esporta" "Lista" "Esci")))

			(setq File 		(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Tmp\\var.lsp"))
			;(setq File 		(strcat SetupPathEasyCut$ "Tmp\\var.lsp"))
			(setq Stream	(open File "w"))
			(setq Action (splitxt NameDialog "."))
			(setq DialogName (nth 0 Action))
			(setq NthAction  (atoi (nth 1 Action)))
			(setq LstAction  (vl-prin1-to-string (nth NthAction LstNameActionDcl)))
			
			(write-line "(defun Test (/ LstButtonKey LstDimButton InfoDialog xx)" 																	Stream)
			(write-line "(setq LstButtonKey	 		'(\"Id\"  \"Comm\" \"Fase\" \"Nome\" \"Qta\" \"Spes\" \"Lung\" \"Larg\" \"Mat\"))" 				Stream)
			(write-line "(setq LstDimButton			'(  12      12       12       50       12      12       12       12       12))" 				Stream)
			(write-line "(if (not NameHeadDcl$) (setq NameHeadDcl$ \"Test dialogo\"))" 																Stream)
			(write-line (strcat "(setq InfoDialog (" DialogName " NameHeadDcl$ LstButtonKey LstDimButton '" LstAction "))")	Stream)
			(write-line "(setq xx (load_dialog (car InfoDialog)))" 																					Stream)
			(write-line "(new_dialog (cadr InfoDialog) xx \"\" (cond ( *TestDialog* ) ( '(-1 -1) )))" 												Stream)
			(write-line "(start_dialog)" 																											Stream)
			(write-line "(done_dialog)" 																											Stream)
			(write-line "(unload_dialog xx)"																										Stream)
			(write-line ")" 																														Stream)
			(close Stream)
			(EasyCutViewer File)
			(load File)
			(Test)
	)
	
	;
	; Main
	;
	(setq InfoDialog (MakeDialog "TestDialog"))
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *TestDialog* ) ( '(-1 -1) )))
	
	(setq LstDialog '("Dialog01MakeDialog.0" "Dialog02MakeDialog.0" "Dialog03MakeDialog.0" "Dialog03MakeDialog.1" 
					  "Dialog04MakeDialog.0" "Dialog05MakeDialog.0" "Dialog05MakeDialog.1" "Dialog06MakeDialog.0"))
					  
	(start_list "DialogList")
    (mapcar 'add_list LstDialog)
	;(set_tile "DialogList" "0")
    (end_list)	
	(action_tile "DialogList"	(vl-prin1-to-string '(progn 
															(setq NameDialog (nth (atoi (get_tile "DialogList")) LstDialog))
															(ActiveDialog NameDialog)
													)))
	(start_dialog)
	(action_tile "cancel"	"(setq *TestDialog* (done_dialog)) (unload_dialog xx)")
	(action_tile "accept"	"(setq *TestDialog* (done_dialog)) (unload_dialog xx)")
	

)
;
(defun GuiSelPiecesShapeReduce (LstTableNesting / 	CheckList
													LstVarBool$
													LstVarActive$
												
													LstTypeValue$
													LstSort$
													LstTableFiltered$
													LstButtonKey
													LstDimButton
													LstModeData
													LstTableNesting$
													InfoDialog xx itm
													LstNth Rtn)

	; +--------------------------+
	; 	Use: PopListManagementShape
	; 	VRRIABILI GLOBALI
	;	LstFilterShapeReduce$
	;	LstActiveShapeReduce$
	;   Dialog > Dialog01MakeDialog
	; +--------------------------+
	;
	; Main
	;
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstTableNesting       (Dialog01ValidateList  LstTableNesting	 '( 0      1      2      3      4      5      6      7      8  )))
	(setq LstFilterShapeReduce$	(Dialog01CheckList LstFilterShapeReduce$ '("<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>")))
	(setq LstActiveShapeReduce$	(Dialog01CheckList LstActiveShapeReduce$ '("0"    "0"    "0"    "0"    "0"    "0"    "0"    "0"    "0" )))
	(setq LstTypeValue$					 								 '("int"  "str"  "str"  "str"  "int"  "real" "real" "real" "str"))
	(setq LstButtonKey	 				 								 '("Id"   "Commessa" "Fase" "Nome" "Quantita"  "Spessore" "Lunghezza" "Larghezza" "Materiale"))
	(setq LstSort$ 						 								 '( 0      0      0      0      0      0      0      0      0))
	(setq LstDimButton					 								 '(12     12     12     50     12     12     12     12     12))
	(setq LstModeData   				 								 '( 1      0      0      0      0      0      1      1      0))

	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									(setq LstTableNesting$  LstTableNesting)
									(setq LstFilter$		LstFilterShapeReduce$)
									(setq LstValBool$		LstActiveShapeReduce$)
	; Set qtydeduct
	;(if (not CalcQtyDeduct$) 	(setq CalcQtyDeduct$ "1"))
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
	(setq InfoDialog (Dialog01MakeDialog NameHeadDcl$ LstButtonKey LstDimButton nil))
		
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *GuiSelPiecesShapeReduce* ) ( '(-1 -1) )))
	;
	; Set DCL +++++
	;
	(Dialog01SetDclFilter)
	(Dialog01SetMode)
	(Dialog01SetDclList LstTableNesting$ nil)

	;(if (and (/= CalcQtyDeduct$ "1") (/= CalcQtyDeduct$ "0"))
		(mode_tile "DeductShape" 1)
	;	(set_tile "DeductShape" CalcQtyDeduct$)
	;)

	; Start Action Filter ---------------------------------------------------------------------------------
	;(action_tile "DeductShape"	(vl-prin1-to-string '(progn 
	;													(setq CalcQtyDeduct$    (get_tile "DeductShape"))
	;													(setq LstTableNesting$  (Dialog01ValidateList (Dialog01GetSelectShape CalcQtyDeduct$) '(0 1 2 3 4 5 6 7 8)))
	;													(Dialog01GetActiveFilter)
	;													(Dialog01SetMode)
	;													(Dialog01SetDclList LstTableNesting$ nil))))

	(foreach itm LstButtonKey
		(action_tile itm "(Dialog01SortBox LstTableFiltered$ $key LstButtonKey LstSort$ LstTypeValue$)")
	)
	(foreach itm LstButtonKey
		(action_tile (strcat itm "_FilterActive") 					"(Dialog01ActionFilter 1 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil)")
		(action_tile (strcat itm "_FilterButton") 					"(Dialog01ActionFilter 2 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil)")
		(action_tile (strcat itm "_FilterBool")   "(if (= $reason 1) (Dialog01ActionFilter 3 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil))")
	)
	; End Action Filter -----------------------------------------------------------------------------------

	(action_tile "SortButton"	(vl-prin1-to-string '(progn 
														(setq LstTableNesting$ (GuiMultiLevelSort LstTableNesting$ LstButtonKey))
														(Dialog01GetActiveFilter)
														(Dialog01SetMode)
														(Dialog01SetDclList LstTableNesting$ nil))))
														
	(action_tile "selectall"			"(Dialog01SelectAllBoxList \"box_info\" LstTableFiltered$)")
	(action_tile "box_info" (vl-prin1-to-string '(if (= $reason 4)
													(progn
														(setq LstNth (list $value))
														;(setq LstTableFiltered$ (Dialog01ModifiedLstShape LstTableFiltered$ LstNth))
														(setq LstTableFiltered$ (Dialog01ModifiedLstShape LstTableFiltered$ LstNth 
																										  LstButtonKey LstTypeValue$ LstDimButton 
																										  LstModeData))														
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
														;(setq LstTableFiltered$ (Dialog01ModifiedLstShape LstTableFiltered$ LstNth))
														(setq LstTableFiltered$ (Dialog01ModifiedLstShape LstTableFiltered$ LstNth 
																										  LstButtonKey LstTypeValue$ LstDimButton 
																										  LstModeData))														
														(Dialog01LoadTable (Dialog01FormatTableNesting LstTableFiltered$) nil)
														(Dialog01UpDateInfoShape LstTableFiltered$)
														(setq LstTableNesting$ (Dialog01UpLstTableNesting LstTableNesting$ LstTableFiltered$))
														(set_tile "box_info" "")
														(Dialog01PutSelectBoxList "box_info" LstNth)
													)
													(alert "Nessun contorno selezionato")
												)))
	(action_tile "list"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													 (ListNesting "SHAPE" (Dialog01GetDataBoxList "box_info" LstTableFiltered$) (cons "Prog" LstButtonKey))
													 (alert "Nessun contorno selezionato")
												 )))
	(action_tile "cancel"	"(setq Rtn nil)               (setq *GuiSelPiecesShapeReduce* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(action_tile "ok"	    "(setq Rtn LstTableFiltered$) (setq *GuiSelPiecesShapeReduce* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(start_dialog)
	
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstFilterShapeReduce$ LstFilter$)
	(setq LstActiveShapeReduce$ LstValBool$)
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	Rtn
)
;
(defun GuiSelPiecesShapeNesting (LstTableNesting OutFileName Flag NameAction /  LstVarBool$
																				LstVarActive$
												
																				LstTypeValue$
																				LstSort$
																				LstTableFiltered$
																				LstButtonKey
																				LstDimButton
																				LstNameActionDcl
																				LstTableNesting$
																				InfoDialog xx itm SaveFileName LstTorch
																				LstNth RtnFile RtnLst)

	; +--------------------------+
	; 	Use: GuiNesting
	; 	VRRIABILI GLOBALI
	;	LstFilterShape$
	;	LstActiveShape$
	;   Dialog > Dialog04MakeDialog / Dialog05MakeDialog
	; +--------------------------+
	;
	; Main
	;
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstTableNesting	(Dialog01ValidateList LstTableNesting 	'( 0      1      2      3      4      5      6      7      8  )))
	(setq LstFilterShape$	(Dialog01CheckList LstFilterShape$ 		'("<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>")))
	(setq LstActiveShape$ 	(Dialog01CheckList LstActiveShape$		'("0"    "0"    "0"    "0"    "0"    "0"    "0"    "0"    "0" )))
	(setq LstTypeValue$												'("int"  "str"  "str"  "str"  "int"  "real" "real" "real" "str"))
	(setq LstButtonKey	 											'("Id"   "Commessa" "Fase" "Nome" "Quantita"  "Spessore" "Lunghezza" "Larghezza" "Materiale"))
	(setq LstSort$ 													'( 0      0      0      0      0      0      0      0      0  ))
	(setq LstDimButton												'(12     12     12      50     12    12     12     12     12  ))
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								(setq LstTableNesting$  LstTableNesting)
								(setq LstFilter$		LstFilterShape$)
								(setq LstValBool$		LstActiveShape$)
								(setq SaveFileName 		OutFileName)

	(setq LstNameActionDcl '(	("Seleziona tutto" "Salva" "Importa" "Lista" "Esci")
								("Seleziona tutto" "Salva" "Esporta" "Lista" "Esci")))
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
	
	(if (= Flag 1)
		(setq InfoDialog (Dialog04MakeDialog NameHeadDcl$ LstButtonKey LstDimButton nil))   								; non richiede action
		(setq InfoDialog (Dialog05MakeDialog NameHeadDcl$ LstButtonKey LstDimButton (nth NameAction LstNameActionDcl)))   	; richiede Action
	)
		
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *GuiSelPiecesShapeNesting* ) ( '(-1 -1) )))
	;
	; Set DCL +++++
	;
	(Dialog01SetDclFilter)
	(Dialog01SetMode)
	
	(if (= *FuntionCall* "c:PopListRectPackNesting")
		(progn
			(Dialog01SetDclList LstTableNesting$ 1)
			(setq LstTorch '("1"))
			(start_list "NumberTorch")
			(mapcar 'add_list LstTorch)
			(end_list)
			(set_tile "NumberTorch" (itoa 0))
		)
		(progn
			(Dialog01SetDclList LstTableNesting$ $NumberTorch$)
			(setq LstTorch '("1" "2" "3" "4"))
			(start_list "NumberTorch")
			(mapcar 'add_list LstTorch)
			(end_list)
			(set_tile "NumberTorch" (itoa (1- $NumberTorch$)))
		)
	)
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
														(WriteFileNesting "SHAPE" RtnLst OutFileName $DivideCsv $NumberTorch$)
														(setq RtnFile OutFileName)
														(setq *GuiSelPiecesShapeNesting* (done_dialog)) (unload_dialog xx)
														(vl-file-delete (car InfoDialog))
													)
													(alert "Nessun contorno selezionato")
												)))
	(action_tile "save"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(progn 
														(setq RtnLst (Dialog01GetDataBoxList "box_info" LstTableFiltered$))
														(if (setq OutFileName (OpenFileDialog (list DxfNestingEasyCut$ nil "*.shp|*.*" "Save File Shape" nil T)))
															(progn
																(setq OutFileName (strcat (car OutFileName) "\\" (vl-filename-base (cadr OutFileName)) ".shp"))
																(WriteFileNesting "SHAPE" RtnLst OutFileName $DivideCsv $NumberTorch$)
																(setq RtnFile OutFileName)
															)
														)
													)
												    (alert "Nessun contorno selezionato")
												 )))
	(action_tile "list"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													 (ListNesting "SHAPE" (Dialog01GetDataBoxList "box_info" LstTableFiltered$) (cons "Prog" LstButtonKey))
													 (alert "Nessun contorno selezionato")
												 )))
	(action_tile "cancel"	"(setq *GuiSelPiecesShapeNesting* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(start_dialog)
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstFilterShape$ LstFilter$)
	(setq LstActiveShape$ LstValBool$)
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	(list RtnFile RtnListBox)

)
;
(defun GuiSelPiecesSheetNesting (LstTableNesting OutFileName NameAction / 	LstVarBool$
																			LstVarActive$
												
																			LstTypeValue$
																			LstSort$
																			LstTableFiltered$
																			LstButtonKey
																			LstDimButton
																			LstNameActionDcl
																			LstTableNesting$
																			InfoDialog xx itm SaveFileName
																			RtnFile RtnLst)

	; +--------------------------+
	; 	Use: GuiNesting
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
	(setq LstTableNesting (Dialog01ValidateList LstTableNesting	'( 0        1 	     2         3 	     4	       5	     6        7  )))
	(setq LstFilterSheet$ (Dialog01CheckList LstFilterSheet$	'("<>"     "<>"     "<>"      "<>"      "<>"      "<>"      "<>"     "<>")))
	(setq LstActiveSheet$ (Dialog01CheckList LstActiveSheet$	'("0"      "0"      "0"       "0"       "0"       "0"       "0"      "0" )))
	(setq LstTypeValue$											'("int"	   "str"    "real"    "real"	"real"    "real"    "real"   "str"))
	(setq LstButtonKey	 										'("Id"	   "Stock"  "Larghezza"   "Lunghezza"  "Spessore"   "Superficie" "Peso" "Materiale"))
	(setq LstSort$ 												'( 0        0        0         0         0         0         0        0))
	(setq LstDimButton											'( 12       25    	 12        12        12        12        12       12))
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								(setq LstTableNesting$  LstTableNesting)
								(setq LstFilter$		LstFilterSheet$)
								(setq LstValBool$		LstActiveSheet$)
								(setq SaveFileName 		OutFileName)

	(setq LstNameActionDcl '(	("Seleziona tutto" "Salva" "Importa" "Lista" "Esci")
								("Seleziona tutto" "Salva" "Esporta" "Lista" "Esci")))

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
	(setq InfoDialog (Dialog03MakeDialog NameHeadDcl$ LstButtonKey LstDimButton (nth NameAction LstNameActionDcl)))
		
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *GuiSelPiecesSheetNesting* ) ( '(-1 -1) )))
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
														(WriteFileNesting "SHEET" RtnLst OutFileName $DivideCsv nil)
														(setq RtnFile OutFileName)
													    ;(setq RtnLst (mapcar 'cadr (Dialog01GetDataBoxList "box_info" LstTableFiltered$)))
													    (setq Import T *GuiSelPiecesSheetNesting* (done_dialog)) (unload_dialog xx)
														(vl-file-delete (car InfoDialog))
													)
													(alert "Nessun file selezionato")
												)))

	(action_tile "save"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(progn 
														(setq RtnLst (Dialog01GetDataBoxList "box_info" LstTableFiltered$))
														(if (setq OutFileName (OpenFileDialog (list DxfNestingEasyCut$ nil "*.sht" "Save File Sheet" nil T)))
															(progn
																(setq OutFileName (strcat (car OutFileName) "\\" (vl-filename-base (cadr OutFileName)) ".sht"))
																(WriteFileNesting "SHEET" RtnLst OutFileName $DivideCsv nil)
																(setq RtnFile OutFileName)
															)
														)
													)
												    (alert "Nessun contorno selezionato")
											     )))

	(action_tile "list"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													 (ListNesting "SHEET" (Dialog01GetDataBoxList "box_info" LstTableFiltered$) (cons "Prog" LstButtonKey))
													 (alert "Nessun contorno selezionato")
												 )))
	(action_tile "cancel"	"(setq *GuiSelPiecesSheetNesting* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
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
	; 	Use:	ImportShapeCam
	; 	Use:	ImportShapeDstv
	; 	VRRIABILI GLOBALI
	;	LstFilterImport$
	;	LstActiveImport$
	;   Dialog > Dialog02MakeDialog
	; +--------------------------+
	;
	; Main
	;
	(defun AssocFileName (LstNesting LstAssoc / itm Rtn)
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
	(setq LstTableNesting  (Dialog01ValidateList LstTableNesting 	'( 0      1      2      3      4      5      6      7      8      )))
	(setq LstFilterImport$ (Dialog01CheckList    LstFilterImport$	'("<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>")))
	(setq LstActiveImport$ (Dialog01CheckList    LstActiveImport$	'("0"    "0"    "0"    "0"    "0"    "0"    "0"    "0"    "0"    "0" )))
	(setq LstTypeValue$												'("int" "str"  "str"  "str"  "str"  "int"  "real" "real" "real" "str"))
	(setq LstButtonKey	 											'("Id"  "File" "Comm" "Fase" "Nome" "Qta"  "Spes" "Lung" "Larg" "Mat"))
	(setq LstSort$ 													'( 0     0      0      0      0      0      0      0      0      0))
	(setq LstDimButton												'( 12    30     10     10     15     5      5      12     12     12))
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
	(setq InfoDialog (Dialog02MakeDialog NameHeadDcl$ LstButtonKey LstDimButton nil))
		
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *GuiSelPiecesShapeImport* ) ( '(-1 -1) )))
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
													(ListNesting "SHAPE" (RemoveIdTableNesting (Dialog01GetDataBoxList "box_info" LstTableFiltered$)) LstButtonKey)
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
													    (setq Import T *GuiSelPiecesShapeImport* (done_dialog)) (unload_dialog xx)
														(vl-file-delete (car InfoDialog))
													)
													(alert "Nessun file selezionato")
												)))
	(action_tile "cancel"	"(setq Rtn nil) (setq *GuiSelPiecesShapeImport* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(start_dialog)

	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstFilterImport$ LstFilter$)
	(setq LstActiveImport$ LstValBool$)
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	Rtn	
)
;
(defun GuiSelPiecesShape (LstTableNesting OutFileName NameAction / 	LstVarBool$
																	LstVarActive$
												
																	LstTypeValue$
																	LstSort$
																	LstTableFiltered$
																	LstButtonKey
																	LstDimButton
																	LstNameActionDcl
																	LstTableNesting$
																	InfoDialog xx itm SaveFileName LstTorch
																	LstNth RtnFile RtnLst)

	; +--------------------------+
	;	Use: GuiShapeXls
	;		 GuiAvailabilitySheet
	;		 ExportShapeToSql
	;		 ImportShapeFromSql
	; 	VRRIABILI GLOBALI
	;	LstFilterShape$
	;	LstActiveShape$
	;   Dialog > Dialog05MakeDialog
	; +--------------------------+
	;
	; Main
	;
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstTableNesting (Dialog01ValidateList LstTableNesting '( 0      1      2      3      4      5      6      7      8  )))
	(setq LstFilterShape$ (Dialog01CheckList LstFilterShape$	'("<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>")))
	(setq LstActiveShape$ (Dialog01CheckList LstActiveShape$	'("0"    "0"    "0"    "0"    "0"    "0"    "0"    "0"    "0" )))
	(setq LstTypeValue$											'("int"  "str"  "str"  "str"  "int"  "real" "real" "real" "str"))
	(setq LstButtonKey	 										'("Id"   "Commessa" "Fase" "Nome" "Quantita"  "Spessore" "Lunghezza" "Larghezza" "Materiale"))
	(setq LstSort$ 												'( 0      0      0      0      0     0      0      0      0  ))
	(setq LstDimButton											'(12     12     12     50     12    12     14     14     12  ))

	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								(setq LstTableNesting$  LstTableNesting)
								(setq LstFilter$		LstFilterShape$)
								(setq LstValBool$		LstActiveShape$)
								(setq SaveFileName 		OutFileName)

	(setq LstNameActionDcl '(	("Seleziona tutto" "Salva" "Importa" "Lista" "Esci")
								("Seleziona tutto" "Salva" "Esporta" "Lista" "Esci")))

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
	(setq InfoDialog (Dialog05MakeDialog NameHeadDcl$ LstButtonKey LstDimButton (nth NameAction LstNameActionDcl)))
		
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *GuiSelPiecesShape* ) ( '(-1 -1) )))
	;
	; Set DCL +++++
	;
	(Dialog01SetDclFilter)
	(Dialog01SetMode)
	(Dialog01SetDclList LstTableNesting$ 1)
	
	(if (and (/= CalcQtyDeduct$ "1") (/= CalcQtyDeduct$ "0"))
		(mode_tile "DeductShape" 1)
		(set_tile "DeductShape" CalcQtyDeduct$)
	)
	;
	; Start Action Filter ---------------------------------------------------------------------------------
	;
	(action_tile "DeductShape"	(vl-prin1-to-string '(progn 
														(setq CalcQtyDeduct$    (get_tile "DeductShape"))
														(setq LstTableNesting$  (Dialog01ValidateList (Dialog01GetSelectShape CalcQtyDeduct$) '(0 1 2 3 4 5 6 7 8)))
														(Dialog01GetActiveFilter)
														(Dialog01SetMode)
														(Dialog01SetDclList LstTableNesting$ 1))))
														
	
	(foreach itm LstButtonKey
		(action_tile itm "(Dialog01SortBox LstTableFiltered$ $key LstButtonKey LstSort$ LstTypeValue$)")
	)

	(foreach itm LstButtonKey
		(action_tile (strcat itm "_FilterActive") 					"(Dialog01ActionFilter 1 LstTableNesting$ LstButtonKey $key LstTypeValue$ 1)")
		(action_tile (strcat itm "_FilterButton") 					"(Dialog01ActionFilter 2 LstTableNesting$ LstButtonKey $key LstTypeValue$ 1)")
		(action_tile (strcat itm "_FilterBool")   "(if (= $reason 1) (Dialog01ActionFilter 3 LstTableNesting$ LstButtonKey $key LstTypeValue$ 1))")
	)
	
	
	; End Action Filter -----------------------------------------------------------------------------------

	(action_tile "selectall" "(Dialog01SelectAllBoxList \"box_info\" LstTableFiltered$)")
	(action_tile "import"	(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
												    (progn 
														(setq RtnLst (Dialog01GetDataBoxList "box_info" LstTableFiltered$))
														(if (not OutFileName) (setq OutFileName SaveFileName))
														(WriteFileNesting "SHAPE" RtnLst OutFileName $DivideCsv 1)
														(setq RtnFile OutFileName)
														(setq *GuiSelPiecesShape* (done_dialog)) (unload_dialog xx)
														(vl-file-delete (car InfoDialog))
													)
													(alert "Nessun contorno selezionato")
												)))
	(action_tile "save"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(progn 
														(setq RtnLst (Dialog01GetDataBoxList "box_info" LstTableFiltered$))
														(if (setq OutFileName (OpenFileDialog (list DxfNestingEasyCut$ nil "*.shp|*.*" "Save File Shape" nil T)))
															(progn
																(setq OutFileName (strcat (car OutFileName) "\\" (vl-filename-base (cadr OutFileName)) ".shp"))
																(WriteFileNesting "SHAPE" RtnLst OutFileName $DivideCsv 1)
																(setq RtnFile OutFileName)
															)
														)
													)
												    (alert "Nessun contorno selezionato")
												 )))
	(action_tile "list"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													 (ListNesting "SHAPE" (Dialog01GetDataBoxList "box_info" LstTableFiltered$) (cons "Prog" LstButtonKey))
													 (alert "Nessun contorno selezionato")
												 )))
	(action_tile "cancel"	"(setq *GuiSelPiecesShape* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(start_dialog)
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstFilterShape$ LstFilter$)
	(setq LstActiveShape$ LstValBool$)
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	(list RtnFile RtnLst)

)
;
(defun GuiSelPiecesSheet (LstTableNesting OutFileName NameAction / 	LstVarBool$
																	LstVarActive$
												
																	LstTypeValue$
																	LstSort$
																	LstTableFiltered$
																	LstButtonKey
																	LstDimButton
																	LstNameActionDcl
																	LstTableNesting$
																	InfoDialog xx itm SaveFileName
																	RtnFile RtnLst)

	; +--------------------------+
	;	Use: GuiAvailabilitySheet
	;		 ExportSheetToSql
	;		 ImportSheetFromSql
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
	(setq LstTableNesting (Dialog01ValidateList LstTableNesting	'( 0        1 	     2         3 	     4	       5	     6        7  )))
	(setq LstFilterSheet$ (Dialog01CheckList    LstFilterSheet$	'("<>"     "<>"     "<>"      "<>"      "<>"      "<>"      "<>"     "<>")))
	(setq LstActiveSheet$ (Dialog01CheckList    LstActiveSheet$	'("0"      "0"      "0"       "0"       "0"       "0"       "0"      "0" )))
	(setq LstTypeValue$											'("int"	   "str"    "real"    "real"	"real"    "real"    "real"   "str"))
	(setq LstButtonKey	 										'("Id"	   "Stock"  "Larghezza" "Lunghezza" "Spessore"  "Superficie" "Peso" "Materiale"))
	(setq LstSort$ 												'( 0        0        0         0         0         0         0        0))
	(setq LstDimButton											'( 12       25    	 12        12        12        12        12       12))
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								(setq LstTableNesting$  LstTableNesting)
								(setq LstFilter$		LstFilterSheet$)
								(setq LstValBool$		LstActiveSheet$)
								(setq SaveFileName 		OutFileName)

	(setq LstNameActionDcl '(	("Seleziona tutto" "Salva" "Importa" "Lista" "Esci")
								("Seleziona tutto" "Salva" "Esporta" "Lista" "Esci")))

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
	(setq InfoDialog (Dialog03MakeDialog NameHeadDcl$ LstButtonKey LstDimButton (nth NameAction LstNameActionDcl)))
		
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *GuiSelPiecesSheet* ) ( '(-1 -1) )))
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
														(WriteFileNesting "SHEET" RtnLst OutFileName $DivideCsv nil)
														(setq RtnFile OutFileName)
													    ;(setq RtnLst (mapcar 'cadr (Dialog01GetDataBoxList "box_info" LstTableFiltered$)))
													    (setq Import T *GuiSelPiecesSheet* (done_dialog)) (unload_dialog xx)
														(vl-file-delete (car InfoDialog))
													)
													(alert "Nessun file selezionato")
												)))

	(action_tile "save"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(progn 
														(setq RtnLst (Dialog01GetDataBoxList "box_info" LstTableFiltered$))
														(if (setq OutFileName (OpenFileDialog (list DxfNestingEasyCut$ nil "*.sht" "Save File Sheet" nil T)))
															(progn
																(setq OutFileName (strcat (car OutFileName) "\\" (vl-filename-base (cadr OutFileName)) ".sht"))
																(WriteFileNesting "SHEET" RtnLst OutFileName $DivideCsv nil)
																(setq RtnFile OutFileName)
															)
														)
													)
												    (alert "Nessun contorno selezionato")
											     )))

	(action_tile "list"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													 (ListNesting "SHEET" (Dialog01GetDataBoxList "box_info" LstTableFiltered$) (cons "Prog" LstButtonKey))
													 (alert "Nessun contorno selezionato")
												 )))
	(action_tile "cancel"	"(setq *GuiSelPiecesSheet* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(start_dialog)
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstFilterSheet$ LstFilter$)
	(setq LstActiveSheet$ LstValBool$)
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	(list RtnFile RtnLst)
	
)
;
(defun GuiSelPiecesDxf (LstTableNesting  / 	RebuildTableNesting
											AddIdTableNesting
											AddFileDxf
											LoadArchive
											ChoiseSave
											SaveArchive
											EmptyBox_
											ResetFilter
											SetTileFileName
											
											LstVarBool$
											LstVarActive$
												
											LstTypeValue$
											LstSort$
											LstTableFiltered$
											LstButtonKey
											LstDimButton
											LstTableNesting$
											AssocFileGiuid$
											LstModeData
											InfoDialog xx itm
											LstNth Rtn)

	; +--------------------------+
	;	Use: ImportShapeDxf
	; 	VRRIABILI GLOBALI
	;	LstFilterShapeDxf$
	;	LstActiveShapeDxf$
	;   Dialog > Dialog06MakeDialog
	; +--------------------------+
	(defun RebuildTableNesting (LstNesting LstAssoc / itm FileName Rtn)
		(if (and LstNesting LstAssoc)
			(foreach itm LstNesting
				(if (setq FileName (cadr (assoc (cadr itm) LstAssoc)))
					(progn
						(setq Rtn (append Rtn (list (list FileName 
														(nth 3 itm)
														(nth 4 itm)
														(nth 5 itm)
														(nth 6 itm)
														(nth 7 itm)
														(nth 8 itm)))))
					)
				)
			)
		)
		Rtn
	)
	;
	(defun AddIdTableNesting (LstTableNesting / Pos itm IdName AssocFileGiuid LstTableNesting)
	
		(setq Pos 0)
		(foreach itm LstTableNesting
			(setq IdName 			(Random_Str 9))
			(setq AssocFileGiuid 	(append AssocFileGiuid (list (list IdName (strcase (car itm))))))
			(setq itm 				(append  (list IdName) (LM:SubstNth (strcat (vl-filename-base (nth 0 itm)) (vl-filename-extension (nth 0 itm))) 0 itm) ))
			(setq LstTableNesting 	(LM:SubstNth itm Pos LstTableNesting))
			(setq Pos (1+ Pos))
		)
		(setq AssocFileGiuid$  AssocFileGiuid)
		(setq LstTableNesting$ LstTableNesting)
	)
	;
	(defun AddFileDxf (/ AssocFileGiuid LstTableNesting LstFile itm GiuidFileAssoc Random)
		;
		;LstTableNesting (("753820657" "110.dxf" "-" "-" "109" "-" "-" "-" "Ok")   (...))
		;AssocFileGiuid  (("753820657" C:\\EasyCutBeta\\ExampleDxf\\Tekla\\110.dxf) (...))
		;
		;
		; Main
		;
		(setq LstFile (FillLstDxf (LM:getfiles "Seleziona file" (vl-registry-read EasyCutRegistryPath$ "PathDxfJob") "dxf")))
		; LstFile (("C:\\EasyCutBeta\\ExampleDxf\\Tekla\\109.dxf" "-" "-" "109" "-" "-" "-" "Ok") (...))
		
		
		(setq AssocFileGiuid AssocFileGiuid$)
		(setq LstTableNesting LstTableNesting$)
	
		; Reverse AssocFileGiuid
		(foreach itm AssocFileGiuid
			(setq GiuidFileAssoc (append GiuidFileAssoc (list (reverse itm))))
		)
		(if LstFile (vl-registry-write EasyCutRegistryPath$ "PathNc" (vl-filename-directory (car (car LstFile)))))
		
		(foreach itm LstFile
			(if (not (assoc (strcase (car itm)) GiuidFileAssoc))
				(progn
					(setq Random (Random_Str 9))
					(setq LstTableNesting (append LstTableNesting (list (cons Random (LM:SubstNth (strcat (vl-filename-base      (car itm)) 
																										  (vl-filename-extension (car itm))) 0 itm)))))
					(setq GiuidFileAssoc (append GiuidFileAssoc (list (list (strcase (car itm)) Random))))
				)
			)
		)
		; Reverse AssocFileGiuid
		(setq AssocFileGiuid nil)
		(foreach itm GiuidFileAssoc
			(setq AssocFileGiuid (append AssocFileGiuid (list (reverse itm))))
		)

		(setq LstTableNesting$  LstTableNesting)
		(setq AssocFileGiuid$   AssocFileGiuid)
		(Dialog01SetDclFilter)
		(Dialog01SetMode)
		(Dialog01SetDclList LstTableNesting$ nil)
	)
	;
	(defun RemFileDxf (/ LstBox UpdateFileGiuid)
		;
		(defun UpdateFileGiuid (AssocFileGiuid LstTableNesting / itm Rtn)
			(foreach itm LstTableNesting
				(if (assoc (car itm) AssocFileGiuid) (setq Rtn (append Rtn (list (assoc (car itm) AssocFileGiuid)))))
			)
			Rtn
		)
		;
		;LstTableNesting (("753820657" "110.dxf" "-" "-" "109" "-" "-" "-" "Ok")   (...))
		;AssocFileGiuid  (("753820657" C:\\EasyCutBeta\\ExampleDxf\\Tekla\\110.dxf) (...))
		;
		; Main
		;
		(if (setq LstBox (Dialog01GetTileList "box_info"))
			(setq LstTableFiltered$ (RemoveNthList LstTableFiltered$ (mapcar 'atoi LstBox)))
		)
		;(Dialog01LoadTable (Dialog01FormatTableNesting LstTableFiltered$) nil)
		(setq LstTableNesting$ LstTableFiltered$)
		(setq AssocFileGiuid$  (UpdateFileGiuid AssocFileGiuid$ LstTableNesting$))
		(Dialog01SetDclFilter)
		(Dialog01SetMode)
		(Dialog01SetDclList LstTableNesting$ nil)
	)
	;
	(defun LoadArchive (/ FileData LstData LstTableNesting)
		
		(if (setq FileData (OpenFileDialog  (list (vl-registry-read EasyCutRegistryPath$ "PathDxfJob") "" "*.csv|*.*" "FileDialog" nil T)))
			(progn
				(setq LstData (ReadFileInfoDxf (strcat (nth 0 FileData) "\\" (nth 1 FileData)) $DivideCsv))
				(setq LstTableNesting (Dialog01ValidateList LstData '(0 1 2 3 4 5 6 7)))
				(AddIdTableNesting LstTableNesting)
				(if (and AssocFileGiuid$ LstTableNesting$) 
					(progn 
						(vl-registry-write EasyCutRegistryPath$ "PathDxfJob" (nth 0 FileData))
						(vl-registry-write EasyCutRegistryPath$ "FileDxfJob" (nth 1 FileData))
						(Dialog01SetDclFilter)
						(Dialog01SetMode)
						(Dialog01SetDclList LstTableNesting$ nil)
					)
				)
				(set_tile "FileCsv" (StatusFileDxf))
			)
			(if (not LstTableNesting$) (set_tile "FileCsv" "-"))
		)
	)
	;
	(defun ChoiseSave (/ FileName FileData)
	
		(if LstTableNesting$
			(if (StatusFileDxf)
				(if (= (LM:popup "avvertimento" (strcat "Vuoi salvare la lista corrente ?\n" (StatusFileDxf)) (+ 1 48 4096)) 1)
					(setq FileName (StatusFileDxf))
				)
				(progn
					(if (= (LM:popup "avvertimento" "Vuoi salvare la lista corrente ?" (+ 1 48 4096)) 1)
						(if (setq FileData (OpenFileDialog  (list (vl-registry-read EasyCutRegistryPath$ "PathNc") 
															"out.csv" "*.csv|*.*" "SaveFileDialog" nil T)))
							(progn
								(vl-registry-write EasyCutRegistryPath$ "PathDxfJob" (nth 0 FileData))
								(vl-registry-write EasyCutRegistryPath$ "FileDxfJob" (nth 1 FileData))
								(setq FileName (strcat (nth 0 FileData) "\\" (nth 1 FileData)))
							)
						)
					)
				)
			)
		)
		(if FileName (SaveArchive FileName))
	)
	;
	(defun SaveArchive (FileName / Pos itm LstTmp Rtn)
	
		(if FileName
			(progn
				(setq Pos 1)
				(foreach itm LstTableNesting$
					(setq LstTmp (append LstTmp (list (cons (LM:rtos Pos 2 0) itm))))
					(setq Pos (1+ Pos))
				)
				(if LstTmp
					(progn
						(setq Rtn (RebuildTableNesting LstTmp AssocFileGiuid$))
						(SaveFileInfoDxf Rtn FileName $DivideCsv)
					)
				)
			)
		)
	)
	;
	(defun EmptyBox_(/ itm)
	
		(setq LstTableNesting$  nil)
		(setq AssocFileGiuid$   nil)
		
		(Dialog01SetDclFilter)
		(Dialog01SetMode)
		(Dialog01SetDclList nil nil)
		(vl-registry-write EasyCutRegistryPath$ "PathDxfJob" "")
		(vl-registry-write EasyCutRegistryPath$ "FileDxfJob" "")
		(set_tile "FileCsv" "-")
	)
	;
	(defun ResetFilter (LstButtonKey LstFilterShapeDxf LstActiveShapeDxf / itm)

		(setq LstVarBool$   nil)
		(setq LstVarActive$ nil)
		
		(foreach itm LstButtonKey
			(setq LstVarBool$   (append LstVarBool$   (list (strcat itm "_FilterBool$"))))
			(setq LstVarActive$ (append LstVarActive$ (list (strcat itm "_FilterActive$"))))
		)
		(setq LstFilter$			LstFilterShapeDxf$)
		(setq LstValBool$			LstActiveShapeDxf$)

		(Dialog01LoadVar LstVarActive$ LstValBool$)
		(Dialog01LoadVar LstVarBool$   LstFilter$)
	)
	;
	(defun SetTileFileName (/ FileName)
		(if (setq FileName (StatusFileDxf))
			(set_tile "FileCsv" FileName)
			(set_tile "FileCsv" "-")
		)
	)
	;
	; Main
	;
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstTableNesting	  (Dialog01ValidateList LstTableNesting  '( 0      1      2      3      4      5      6      7         )))
	(setq LstFilterShapeDxf$ (Dialog01CheckList  LstFilterShapeDxf$  '("<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>"   "<>")))
	(setq LstActiveShapeDxf$ (Dialog01CheckList LstActiveShapeDxf$	 '("0"    "0"    "0"    "0"    "0"    "0"    "0"    "0"    "0" )))
	(setq LstTypeValue$												 '("str" "str"  "str"  "str"  "str"  "int"  "real" "str"  "str"))
	(setq LstButtonKey	 											 '("Id"  "File" "Commessa" "Fase" "Nome" "Quantita"  "Spessore" "Materiale"  "Disponibile"))
	(setq LstSort$ 													 '( 0     0      0      0      0      0      0      0      0 ))
	(setq LstDimButton												 '( 12    50     10     10     35     8      8      12     12))
	(setq LstModeData   											 '( 1     1      0      0      0      0      0      0      1))
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	; Add id to list
	;
	(AddIdTableNesting LstTableNesting)
	(setq LstFilter$			LstFilterShapeDxf$)
	(setq LstValBool$			LstActiveShapeDxf$)
	;
	; Make Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(foreach itm LstButtonKey
		(setq LstVarBool$   (append LstVarBool$   (list (strcat itm "_FilterBool$"))))
		(setq LstVarActive$ (append LstVarActive$ (list (strcat itm "_FilterActive$"))))
	)
	;
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(Dialog01LoadVar LstVarActive$ LstValBool$)
	(Dialog01LoadVar LstVarBool$   LstFilter$)
	;
	; End Set ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(setq InfoDialog (Dialog06MakeDialog "Import DXF" LstButtonKey LstDimButton nil))
		
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *GuiSelPiecesShapeDxf* ) ( '(-1 -1) )))
	;
	; Set DCL +++++
	;
	(SetTileFileName)
	(Dialog01SetDclFilter)
	(Dialog01SetMode)
	(Dialog01SetDclList LstTableNesting$ nil)

	; Start Action Filter ---------------------------------------------------------------------------------

	(foreach itm LstButtonKey
		(action_tile itm "(Dialog01SortBox LstTableFiltered$ $key LstButtonKey LstSort$ LstTypeValue$)")
	)
	(foreach itm LstButtonKey
		(action_tile (strcat itm "_FilterActive") 					"(Dialog01ActionFilter 1 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil)")
		(action_tile (strcat itm "_FilterButton") 					"(Dialog01ActionFilter 2 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil)")
		(action_tile (strcat itm "_FilterBool")   "(if (= $reason 1) (Dialog01ActionFilter 3 LstTableNesting$ LstButtonKey $key LstTypeValue$ nil))")
	)
	
	; End Action Filter -----------------------------------------------------------------------------------
	
	(vl-registry-write EasyCutRegistryPath$ "Sentinel" "")
	
	(action_tile "AddDxf"	 (vl-prin1-to-string '(progn (AddFileDxf))))
	(action_tile "RemDxf"	 (vl-prin1-to-string '(progn (RemFileDxf))))
	(action_tile "LoadCsv"	 (vl-prin1-to-string '(progn (ChoiseSave) (ResetFilter LstButtonKey LstFilterShapeDxf$ LstActiveShapeDxf$)(LoadArchive))))
	(action_tile "NewCsv"	 (vl-prin1-to-string '(progn (ChoiseSave) (ResetFilter LstButtonKey LstFilterShapeDxf$ LstActiveShapeDxf$)(EmptyBox_))))
	(action_tile "SaveCsv"	 (vl-prin1-to-string '(progn (ChoiseSave) (SetTileFileName)))) 
	
	(action_tile "selectall" (vl-prin1-to-string '(progn (Dialog01SelectAllBoxList "box_info" LstTableFiltered$))))
	(action_tile "showdxf"	 (vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(progn         
														; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
														(setq Rtn (append (list AssocFileGiuid$) (Dialog01GetDataBoxList "box_info" LstTableFiltered$)))
														(setq LstFileDwg (DxfShapeToDwgBlock Rtn))
														(ShowDwgOpenDcl LstFileDwg)
														; Reset Value
														(setq $TmpLstFileDwg		nil)
														(setq EnameForm$ 			nil)
														(setq EnameBlockView$ 		nil)
														(setq EnameListBox$  		nil)
														(setq EnameTBox1$			nil)
														(setq EnameTBox2$			nil)
														(setq EnameTBox3$			nil)
														(setq EnameTBox4$			nil)
														(setq EnameTBox5$			nil)
														(setq EnameTBox6$			nil)
														(setq PosDwg$ 				nil)
														;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
														;(setq Rtn (RebuildTableNesting (Dialog01GetDataBoxList "box_info" LstTableFiltered$) AssocFileGiuid$))
														;(vl-registry-write EasyCutRegistryPath$ "Sentinel" "2")
														;(setq *GuiSelPiecesDxf* (done_dialog)) (unload_dialog xx) 
														;(vl-file-delete (car InfoDialog))
													)
													(alert "Nessun contorno selezionato")
												)))
												
	(action_tile "import"	 (vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(progn
														(setq Rtn (RebuildTableNesting (Dialog01GetDataBoxList "box_info" LstTableFiltered$) AssocFileGiuid$))
														(vl-registry-write EasyCutRegistryPath$ "Sentinel" "1")
														(ChoiseSave)
														(setq *GuiSelPiecesDxf* (done_dialog)) (unload_dialog xx) 
														(vl-file-delete (car InfoDialog))
													)
													(alert "Nessun contorno selezionato")
												)))
												
	
	(action_tile "box_info"  (vl-prin1-to-string '(if (= $reason 4) ; Double click
													(progn
														(setq Rtn (append (list AssocFileGiuid$) (Dialog01GetDataBoxList "box_info" LstTableFiltered$)))
														(setq LstFileDwg (DxfShapeToDwgBlock Rtn))
														(ShowDwgOpenDcl LstFileDwg)
														; Reset Value
														(setq $TmpLstFileDwg		nil)
														(setq EnameForm$ 			nil)
														(setq EnameBlockView$ 		nil)
														(setq EnameListBox$  		nil)
														(setq EnameTBox1$			nil)
														(setq EnameTBox2$			nil)
														(setq EnameTBox3$			nil)
														(setq EnameTBox4$			nil)
														(setq EnameTBox5$			nil)
														(setq EnameTBox6$			nil)
														(setq PosDwg$ 				nil)
													
														;(setq LstNth (list $value))
														;(setq LstTableFiltered$ (Dialog01ModifiedLstShape LstTableFiltered$ LstNth 
														;												  LstButtonKey LstTypeValue$ LstDimButton 
														;												  LstModeData))
														;(Dialog01LoadTable (Dialog01FormatTableNesting LstTableFiltered$) nil)
														;(Dialog01UpDateInfoShape LstTableFiltered$)
														;(setq LstTableNesting$ (Dialog01UpLstTableNesting LstTableNesting$ LstTableFiltered$))
														;(setq Rtn (RebuildTableNesting (Dialog01GetDataBoxList "box_info" LstTableFiltered$) AssocFileGiuid$))
														;(set_tile "box_info" "")
														;(Dialog01PutSelectBoxList "box_info" LstNth)
													)
												  )))
	
	(action_tile "modified"	(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													(progn
														(setq LstNth (LM:str->lst (get_tile "box_info") " "))
														; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
														(Dialog01ModifiedLstShapeOpenDcl LstTableFiltered$ LstNth 
																						 LstButtonKey LstTypeValue$ LstDimButton 
																						 LstModeData)
														(if $TmpLstTableFiltered
															(setq LstTableFiltered$ $TmpLstTableFiltered)
														)
														; Reset Value
														(setq EnameForm$ 			nil)
														(setq EnameGrid$ 			nil)
														(setq $TmpLstTableFiltered	nil)
														(setq $TmpLstNth			nil)
														(setq $TmpLstButtonKey		nil) 
														(setq $TmpLstTypeValue		nil)
														(setq $TmpLstDimButton		nil)
														(setq $TmpLstModeData		nil)
														;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
														;(setq LstTableFiltered$ (Dialog01ModifiedLstShapeExcel LstTableFiltered$ LstButtonKey LstTypeValue$ LstDimButton))
														;(setq LstTableFiltered$ (Dialog01ModifiedLstShape LstTableFiltered$ LstNth 
														;												  LstButtonKey LstTypeValue$ LstDimButton 
														;												  LstModeData))
														;												  
														(Dialog01LoadTable (Dialog01FormatTableNesting LstTableFiltered$) nil)
														(Dialog01UpDateInfoShape LstTableFiltered$)
														(setq LstTableNesting$ (Dialog01UpLstTableNesting LstTableNesting$ LstTableFiltered$))
														(setq Rtn (RebuildTableNesting (Dialog01GetDataBoxList "box_info" LstTableFiltered$) AssocFileGiuid$))
														(set_tile "box_info" "")
														(Dialog01PutSelectBoxList "box_info" LstNth)
													)
													(alert "Nessun contorno selezionato")
												)))


	(action_tile "list"		(vl-prin1-to-string '(if (/= (get_tile "box_info") "")
													 (ListNesting "SHAPE" (Dialog01GetDataBoxList "box_info" LstTableFiltered$) (cons "Prog" LstButtonKey))
													 (alert "Nessun contorno selezionato")
												 )))
	(action_tile "cancel"	"(setq Rtn nil) (setq *GuiSelPiecesDxf* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(action_tile "ok"	    "				(setq *GuiSelPiecesDxf* (done_dialog)) (unload_dialog xx) (vl-file-delete (car InfoDialog))")
	(start_dialog)
	
	; Set Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq LstFilterShapeDxf$ LstFilter$)
	(setq LstActiveShapeDxf$ LstValBool$)
	; End Var ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	Rtn
)
;
(defun GuiMultiLevelSort (LstTableNesting LstSort / MakeDialog FillPopupList ModePopupList ActivePopupList GetLstSort TypeSort
													itm InfoDialog xx Pos LstAction)

	;(SortMultiLevel '("Commessa" "Fase" "Nome" "Quantita'" "Spessore" "Lunghezza" "Larghezza" "Materiale"))

	(defun MakeDialog (LstSort / itm Pos)
		(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
		(setq Des (open Dcl "w"))
		(setq NameDialog (strcat "EasyCut_" (Random_Str 5)))
		(write-line (strcat NameDialog ":dialog {") 				Des)
		(write-line "   label=\"Ordina\";"							Des)
		(write-line "   :boxed_radio_column {"						Des)
		(write-line "                         label=\"Colonna\";"	Des)
		(write-line "                         fixed_height=true;"	Des)
		(write-line "                         alignment=top;"		Des)
		(setq Pos 0)
		(foreach itm LstSort
			(write-line "                        :row {"										Des)
			(write-line "                                 :toggle {"							Des)
			(write-line (strcat "                                           key=\"ActivePop" (LM:rtos Pos 2 0) "\";")		Des)
			(write-line "                                           fixed_width=true;"			Des)
			(write-line "                                 }"									Des)
			(write-line "                                 :popup_list {"						Des)
			(write-line (strcat "                                           key=\"Pop" (LM:rtos Pos 2 0) "\";")				Des)
			(write-line "                                           label=\"Ordina per:\";"		Des)
			(write-line "                                           value=\"0\";"				Des)
			(write-line "                                           edit_width=16;"				Des)
			(write-line "                                 }"									Des)
			(write-line "                        }"												Des)
			(setq Pos (1+ Pos))
	    )
		(write-line "                        }"													Des)
		(write-line "   :boxed_radio_column {"						Des)
		(write-line "                         label=\"Ordina\";"	Des)
		(write-line "                         fixed_height=true;"	Des)
		(write-line "                         alignment=top;"		Des)
		(write-line "                         :radio_button {"						Des)
		(write-line "                                           key=\"Min\";"		Des)
		(write-line "                                           label=\"Ordinamento crescente\";"	Des)
		(write-line "                         }"									Des)
		(write-line "                         :radio_button {"						Des)
		(write-line "                                           key=\"Max\";"		Des)
		(write-line "                                           label=\"Ordinamento decrescente\";"Des)
		(write-line "                         }"									Des)
		(write-line "   }"															Des)
		(write-line "   ok_cancel;"																Des)
		(write-line "}"																			Des)
		(close Des)
		(list Dcl NameDialog)
	)
	;
	(defun FillPopupList (LstSort / Pos itm)
		(setq Pos 0)
		(foreach itm LstSort
			(start_list (strcat "Pop" (LM:rtos Pos 2 0)))
			(mapcar 'add_list LstSort)
			(end_list)
			(setq Pos (1+ Pos))
		)	
	)
	;
	(defun ModePopupList (LstAction / Pos itm)
		(setq Pos 0)
		(foreach itm LstAction
			(mode_tile (strcat "Pop" (LM:rtos Pos 2 0)) itm)
			(setq Pos (1+ Pos))
		)
	)
	;
	(defun ActivePopupList (LstAction Key Val)
		
		(if (= Val "0")
			(mode_tile (strcat "Pop" (chr (last (vl-string->list Key)))) 1)
			(mode_tile (strcat "Pop" (chr (last (vl-string->list Key)))) 0)
		)
	)
	;
	(defun GetLstSort (LstSort / Pos Rtn Rank itm)
	
		;("Commessa" "Fase" "Nome" "Quantita'" "Spessore" "Lunghezza" "Larghezza" "Materiale")
		;     0         3      1       5           0           2          0            4
		(foreach itm LstSort
			(setq Rtn (append Rtn (list 0)))
		)
		(setq Pos 0)
		(foreach itm LstSort
			(if (= (get_tile (strcat "ActivePop" (LM:rtos Pos 2 0))) "1")
				(setq Rank (append Rank (list (1+ (atoi (get_tile (strcat "Pop" (LM:rtos Pos 2 0))))))))
			)
			(setq Pos (1+ Pos))
		)
		(setq Pos 1)
		(foreach itm Rank
			(setq Rtn (LM:SubstNth Pos (1- itm) Rtn))
			(setq Pos (1+ Pos))
		)
		Rtn
	)
	;
	(defun TypeSort ()
		(if (= (get_tile "Min") "1")
			"<"
			">"
		)
	)
	;
	; Main +++++
	;
	(foreach itm LstSort (setq LstAction (append LstAction (list 1))))
	
	(setq InfoDialog (MakeDialog LstSort))
	(setq xx (load_dialog (car InfoDialog)))
	(new_dialog (cadr InfoDialog) xx "" (cond ( *SortMultiLevel* ) ( '(-1 -1) )))
	;
	; Set DCL +++++
	;
	(FillPopupList LstSort)
	(ModePopupList LstAction)
	(set_tile "Min" "1")
	;
	; Active DCL +++++
	;
	(setq Pos 0)
	(foreach itm LstSort
		(action_tile (strcat "ActivePop" (LM:rtos Pos 2 0)) (vl-prin1-to-string '(progn (ActivePopupList LstAction $Key $Value))))
		(setq Pos (1+ Pos))
	)
	(action_tile "accept" (vl-prin1-to-string '(progn 
													(setq Rtn (SortTable LstTableNesting (GetLstSort LstSort) (TypeSort)))
													(setq *GuiSortMultiLevel* (done_dialog))
													(unload_dialog xx) (vl-file-delete (car InfoDialog)))))
													
	(action_tile "cancel" (vl-prin1-to-string '(progn 
													(setq Rtn LstTableNesting)
													(setq *GuiSortMultiLevel* (done_dialog))
													(unload_dialog xx) (vl-file-delete (car InfoDialog)))))
	(start_dialog)
	
	Rtn
	
)