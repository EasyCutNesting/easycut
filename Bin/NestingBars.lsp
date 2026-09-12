;
; Gui Import Shape From File
;
;(setq FileDcl$ "C:\\Users\\ut04\\Desktop\\Tmp\\EasyCutBeta_20220627_2252\\NewApp\\NestingBars\\PartsAndBars.dcl")
;(setq FileDcl$ "C:\\EasyCutBeta\\NewApp\\NestingBars\\PartsAndBars.dcl")
;
;
(defun IsEmptyBox (KeyBox)
	(= (GetTextBox KeyBox) "")
)
;
;
(defun IsOnlyNumberBox (KeyBox / Value)
	(if (numberp (read (GetTextBox KeyBox)))
		(read (GetTextBox KeyBox))
	)
)
;
;
(defun GetTextBox (KeyBox)
	(vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile KeyBox)))
)	
;
;
(defun SetTile (Key Value)
	(if Value (set_tile Key Value))
)
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
(defun EmptyBox (Key)
		(start_list Key) (end_list)
)
;
;
(defun GuiImportParts (FilePart / 	PutGui GetGui PutGuiInfo GetSheetsXls RefreshValueSeparator
									xx Loop ImportParts
									<LstSheet> <LstOrder> <LstPhase> <LstMark> <LstQuantity> <LstLength> <LstProfile> <LstMaterial>
									<LstSeparator> <Separator> <LstCol1> <LstCol2> <LstCol3> <LstCol4> <LstCol5> <LstCol6> <LstCol7>
									<LstColumnSeekXls> <LstColumnSeekCsv> <SheetBook> FileCheckXls FileCheckCsv LstDataParts)


	(defun PutGui (/ LastTime)

		(if (and FileToImportPartsXls$ (findfile FileToImportPartsXls$)) 
			(progn
				(set_tile "FileSelectPartsXls" FileToImportPartsXls$)
				(setq LastTime (GetFileLastModified FileToImportPartsXls$))
				(if (> LastTime LastTimeFileToImportPartsXls$)
					(progn
						(setq LastTimeFileToImportPartsXls$ LastTime)
						(setq LstSheet$  (GetSheetsXls))
						(setq <LstSheet> LstSheet$)
 					)
					(setq <LstSheet> LstSheet$)
				)
			)
		)
		(if FileToImportPartsCsv$ (set_tile "FileSelectPartsCsv" FileToImportPartsCsv$))
		
		(cond 
			((= TypeFileToImportParts$ "1")
				
				;(setq <LstSheet> 	 (GetSheetsXls))
				(if (or (not ValSheetImportParts$) (= ValSheetImportParts$ ""))		(setq ValSheetImportParts$ "0"))
				(if (not ValOrderImportParts$)		(setq ValOrderImportParts$		"0"))
				(if (not ValPhaseImportParts$)		(setq ValPhaseImportParts$		"1"))
				(if (not ValMarkImportParts$)		(setq ValMarkImportParts$		"2"))
				(if (not ValQuantityImportParts$)	(setq ValQuantityImportParts$	"3"))
				(if (not ValLengthImportParts$)		(setq ValLengthImportParts$		"4"))
				(if (not ValProfileImportParts$)	(setq ValProfileImportParts$	"5"))
				(if (not ValMaterialImportParts$)	(setq ValMaterialImportParts$	"6"))

				(start_list "ListSheet")(mapcar 'add_list <LstSheet>) 	(end_list)
				(start_list "Order") 	(mapcar 'add_list <LstOrder>) 	(end_list)
				(start_list "Phase") 	(mapcar 'add_list <LstPhase>) 	(end_list)
				(start_list "Mark") 	(mapcar 'add_list <LstMark>) 	(end_list)
				(start_list "Quantity") (mapcar 'add_list <LstQuantity>)(end_list)
				(start_list "Length") 	(mapcar 'add_list <LstLength>) 	(end_list)
				(start_list "Profile") 	(mapcar 'add_list <LstProfile>) (end_list)
				(start_list "Material") (mapcar 'add_list <LstMaterial>)(end_list)
				
				(set_tile   "ListSheet" ValSheetImportParts$)
				(set_tile   "Order" 	ValOrderImportParts$)
				(set_tile   "Phase" 	ValPhaseImportParts$)
				(set_tile   "Mark"		ValMarkImportParts$)
				(set_tile   "Quantity" 	ValQuantityImportParts$)
				(set_tile   "Length" 	ValLengthImportParts$)
				(set_tile   "Profile" 	ValProfileImportParts$)
				(set_tile   "Material" 	ValMaterialImportParts$)
			)
		
			((= TypeFileToImportParts$ "2")

				(if (not ValSeparatorImportParts$)	(setq ValSeparatorImportParts$	"0"))
				(if (not ValCol1ImportParts$)		(setq ValCol1ImportParts$		"0"))
				(if (not ValCol2ImportParts$)		(setq ValCol2ImportParts$		"1"))
				(if (not ValCol3ImportParts$)		(setq ValCol3ImportParts$		"2"))
				(if (not ValCol4ImportParts$)		(setq ValCol4ImportParts$		"3"))
				(if (not ValCol5ImportParts$)		(setq ValCol5ImportParts$		"4"))
				(if (not ValCol6ImportParts$)		(setq ValCol6ImportParts$		"5"))
				(if (not ValCol7ImportParts$)		(setq ValCol7ImportParts$		"6"))

				(start_list "Separator")(mapcar 'add_list <LstSeparator>) 	(end_list)
				(start_list "Col1") 	(mapcar 'add_list <LstCol1>) 		(end_list)
				(start_list "Col2") 	(mapcar 'add_list <LstCol2>) 		(end_list)
				(start_list "Col3") 	(mapcar 'add_list <LstCol3>) 		(end_list)
				(start_list "Col4") 	(mapcar 'add_list <LstCol4>) 		(end_list)
				(start_list "Col5") 	(mapcar 'add_list <LstCol5>) 		(end_list)
				(start_list "Col6") 	(mapcar 'add_list <LstCol6>) 		(end_list)
				(start_list "Col7") 	(mapcar 'add_list <LstCol7>) 		(end_list)
				
				(set_tile   "Separator" ValSeparatorImportParts$)
				(set_tile   "Col1" 		ValCol1ImportParts$)
				(set_tile   "Col2" 		ValCol2ImportParts$)
				(set_tile   "Col3" 		ValCol3ImportParts$)
				(set_tile   "Col4" 		ValCol4ImportParts$)
				(set_tile   "Col5" 		ValCol5ImportParts$)
				(set_tile   "Col6" 		ValCol6ImportParts$)
				(set_tile   "Col7" 		ValCol7ImportParts$)
				(RefreshValueSeparator)
			)
		)
	)
	;
	;
	(defun PutGuiInfo ()
	
		(princ "\nTypeFileToImportParts$   ")   (princ TypeFileToImportParts$)
		(princ "\nFileToImportPartsXls$    ")   (princ FileToImportPartsXls$)
		(princ "\nFileToImportPartsCsv$    ")  	(princ FileToImportPartsCsv$)
		(princ "\nLstSheet$                ")   (princ LstSheet$)
		(princ "\nValSheetImportParts$     ") 	(princ ValSheetImportParts$)
		(princ "\nValOrderImportParts$     ")	(princ ValOrderImportParts$)
		(princ "\nValPhaseImportParts$     ")	(princ ValPhaseImportParts$)
		(princ "\nValMarkImportParts$      ")	(princ ValMarkImportParts$)
		(princ "\nValQuantityImportParts$  ")	(princ ValQuantityImportParts$)
		(princ "\nValLengthImportParts$    ")	(princ ValLengthImportParts$)
		(princ "\nValProfileImportParts$     ")	(princ ValProfileImportParts$)
		(princ "\nValMaterialImportParts$  ")	(princ ValMaterialImportParts$)
		(princ "\nValSeparatorImportParts$ ")	(princ ValSeparatorImportParts$)
		(princ "\nValCol1ImportParts$      ")	(princ ValCol1ImportParts$)
		(princ "\nValCol2ImportParts$      ")	(princ ValCol2ImportParts$)
		(princ "\nValCol3ImportParts$      ")	(princ ValCol3ImportParts$)
		(princ "\nValCol4ImportParts$      ")	(princ ValCol4ImportParts$)
		(princ "\nValCol5ImportParts$      ")	(princ ValCol5ImportParts$)
		(princ "\nValCol6ImportParts$      ")	(princ ValCol6ImportParts$)
		(princ "\nValCol7ImportParts$      ")	(princ ValCol7ImportParts$)
		(princ "\nValOrderNAXls$           ")	(princ ValOrderNAXls$)	
		(princ "\nValPhaseNAXls$           ")	(princ ValPhaseNAXls$)			
		(princ "\nValMatNAXls$             ")	(princ ValMatNAXls$)		
		(princ "\nValOrderNACsv$           ")	(princ ValOrderNACsv$)
		(princ "\nValPhaseNACsv$           ")	(princ ValPhaseNACsv$)
		(princ "\nValMatNACsv$             ")	(princ ValMatNACsv$)		
		(princ "\n<LstColumnSeekXls>       ")	(princ <LstColumnSeekXls>)
		(princ "\n<LstColumnSeekCsv>       ")	(princ <LstColumnSeekCsv>)
		(princ "\n<SheetBook>              ")	(princ <SheetBook>)
		(princ "\n<LstNAXls>               ")	(princ <LstNAXls>)
		(princ "\n<LstNACsv>               ")	(princ <LstNACsv>) 
	)
	;
	;
	(defun GetGui ()
	
		(setq ValSheetImportParts$		(get_tile "ListSheet"))
		(setq ValOrderImportParts$		(get_tile "Order"))
		(setq ValPhaseImportParts$		(get_tile "Phase"))
		(setq ValMarkImportParts$		(get_tile "Mark"))
		(setq ValQuantityImportParts$	(get_tile "Quantity"))
		(setq ValLengthImportParts$		(get_tile "Length"))
		(setq ValProfileImportParts$	(get_tile "Profile"))
		(setq ValMaterialImportParts$	(get_tile "Material"))
		
		(setq ValSeparatorImportParts$	(get_tile "Separator"))
		(setq ValCol1ImportParts$		(get_tile "Col1"))
		(setq ValCol2ImportParts$		(get_tile "Col2"))
		(setq ValCol3ImportParts$		(get_tile "Col3"))
		(setq ValCol4ImportParts$		(get_tile "Col4"))
		(setq ValCol5ImportParts$		(get_tile "Col5"))
		(setq ValCol6ImportParts$		(get_tile "Col6"))
		(setq ValCol7ImportParts$		(get_tile "Col7"))

		(setq ValOrderNAXls$			(get_tile "OrderNAXls"))
		(setq ValPhaseNAXls$			(get_tile "PhaseNAXls"))
		(setq ValMatNAXls$				(get_tile "MatNAXls"))
		(setq ValOrderNACsv$			(get_tile "OrderNACsv"))
		(setq ValPhaseNACsv$			(get_tile "PhaseNACsv"))
		(setq ValMatNACsv$				(get_tile "MatNACsv"))

		(cond 
			((= TypeFileToImportParts$ "1")
				(setq <LstColumnSeekXls>	(list 
												(nth (atoi ValOrderImportParts$) 	<LstOrder>)
												(nth (atoi ValPhaseImportParts$) 	<LstPhase>)
												(nth (atoi ValMarkImportParts$) 	<LstMark>)
												(nth (atoi ValQuantityImportParts$) <LstQuantity>)
												(nth (atoi ValLengthImportParts$) 	<LstLength>)
												(nth (atoi ValProfileImportParts$) 	<LstProfile>)
												(nth (atoi ValMaterialImportParts$) <LstMaterial>)
											)
				)
				(if (and LstSheet$  <LstSheet>)   (setq <SheetBook> (nth (atoi ValSheetImportParts$) <LstSheet>)))
			)
			((= TypeFileToImportParts$ "2")
				(setq <LstColumnSeekCsv>	(list 
												(nth (atoi ValCol1ImportParts$) <LstCol1>)
												(nth (atoi ValCol2ImportParts$) <LstCol2>)
												(nth (atoi ValCol3ImportParts$) <LstCol3>)
												(nth (atoi ValCol4ImportParts$)	<LstCol4>)
												(nth (atoi ValCol5ImportParts$) <LstCol5>)
												(nth (atoi ValCol6ImportParts$)	<LstCol6>)
												(nth (atoi ValCol7ImportParts$) <LstCol7>)
											)
				)
				(setq <Separator> (nth (atoi ValSeparatorImportParts$) <LstSeparator>))
			)
		)
		
		
		
		;(setq <LstNAXls>  (list ValOrderNAXls$ ValPhaseNAXls$ ValMatNAXls$))
		;(setq <LstNACsv>  (list ValOrderNACsv$ ValPhaseNACsv$ ValMatNACsv$))

	)
	;
	;
	(defun GetSheetsXls (/ LstSheet Rtn)
		(if FileToImportPartsXls$
			(if (findfile FileToImportPartsXls$)
				(progn
					;(ProgressBar "" "Lettura Excel" 0.1)
					;(setq Reps~ 1)
					;(PrgBr 10)
					(OpenExcel FileToImportPartsXls$)
					;(PrgBr 10)
					(setq Rtn (GetListSheet)); (setq LstSheet$ MySheets$)
					;(PrgBr 10)
					(CloseExcel)
					;(EndProgressBar)	
				)
			)
		)
		Rtn
	)
	;
	;
	(defun RefreshValueSeparator ()
			(setq ValSeparatorImportParts$	(get_tile "Separator"))
			(set_tile "TextSeparator" (strcat "" (nth (atoi ValSeparatorImportParts$) <LstSeparator>)))
			(set_tile "TextSeparator" (strcat "Separatore -> " (nth (atoi ValSeparatorImportParts$) <LstSeparator>)))
	)

	;
	; Main
	;
	(setq <LstOrder>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstPhase>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstMark>		 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstQuantity>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstLength>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstProfile>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstMaterial>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))

	(setq <LstSeparator> '(";" "," "|"))
	(setq <LstCol1>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol2>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol3>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol4>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol5>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol6>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol7>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))


	(if FilePart
		(if (findfile FilePart)
			(cond
				((or (= (strcase (vl-filename-extension FilePart)) ".XLS")
					 (= (strcase (vl-filename-extension FilePart)) ".XLSX"))
					(setq xx (load_dialog (strcat GuiPathEasyCut$ "PartsAndBars.dcl")))
					(new_dialog "ImportPartsXls" xx "" (cond ( *ImportPartsXls* ) ( '(-1 -1) )))
					(setq FileToImportPartsXls$ FilePart)
					(setq FileToImportPartsCsv$ nil)
					(setq TypeFileToImportParts$ "1")
				)
				((= (strcase (vl-filename-extension FilePart)) ".CSV")
					(setq xx (load_dialog (strcat GuiPathEasyCut$ "PartsAndBars.dcl")))
					(new_dialog "ImportPartsCsv" xx "" (cond ( *ImportPartsCsv* ) ( '(-1 -1) )))
					(setq FileToImportPartsCsv$ FilePart)
					(setq FileToImportPartsXls$ nil)
					(setq TypeFileToImportParts$ "2")
				)
			)
		)
	)
	(if xx
		(progn
			(setq Loop T)
			(while Loop
				(PutGui)
				(action_tile "ChkFilePartsXls"		(strcat "(GetGui) 
															 (setq FileCheckXls T)
															 (setq	*ImportPartsXls* (done_dialog))
															 (unload_dialog xx)"))
				(action_tile "ChkFilePartsCsv"		(strcat "(GetGui) 
															 (setq FileCheckCsv T)
															 (setq	*ImportPartsXls* (done_dialog))
															 (unload_dialog xx)"))
				(action_tile "Separator"			"(RefreshValueSeparator)")
				(action_tile "cancel"    			(strcat "(setq *ImportPartsXls* (done_dialog))
															 (unload_dialog xx)
															 (setq Loop nil)"))
				(action_tile "accept"    			(strcat "(GetGui) 
															 (setq ImportParts T)
															 (setq *ImportPartsXls* (done_dialog)) 
															 (unload_dialog xx)
															 (setq Loop nil)"))
				(start_dialog)
		
				(cond 
					((= FileCheckXls T)
						(CheckPartsImportXls FileToImportPartsXls$ <SheetBook> <LstColumnSeekXls>)
						(setq xx (load_dialog (strcat GuiPathEasyCut$ "PartsAndBars.dcl")))
						(new_dialog "ImportPartsXls" xx "" (cond ( *ImportPartsXls* ) ( '(-1 -1) )))
						(setq FileCheckXls nil)
					)
					((= FileCheckCsv T)
						(CheckPartsImportCsv FileToImportPartsCsv$ <Separator> <LstColumnSeekCsv>)
						(setq xx (load_dialog (strcat GuiPathEasyCut$ "PartsAndBars.dcl")))
						(new_dialog "ImportPartsCsv" xx "" (cond ( *ImportPartsCsv* ) ( '(-1 -1) )))
						(setq FileCheckCsv nil)
					)
					((= ImportParts T)
						(cond 
							((= TypeFileToImportParts$ "1")
								(setq LstDataParts (ReadDataPartsFromXls FileToImportPartsXls$ <SheetBook> <LstColumnSeekXls>))
							)
							((= TypeFileToImportParts$ "2")
								(setq LstDataParts (ReadDataPartsFromCsv FileToImportPartsCsv$ <Separator> <LstColumnSeekCsv>))
							)
						)
						(setq ImportParts nil)
					)
				)
			)
		)
	)
	LstDataParts
)
;
;
;
(defun GuiImportBars (FileBar / PutGui GetGui PutGuiInfo GetSheetsXls RefreshValueSeparator
								xx Loop FileImport ImportBars LstDataShepe
								<LstSheet> <LstLength> <LstProfile> <LstMaterial>
								<LstSeparator> <Separator> <LstCol1> <LstCol2> <LstCol3>
								<LstColumnSeekXls> <LstColumnSeekCsv> <SheetBook> FileCheckXls FileCheckCsv LstDataBars)


	;
	(defun PutGui (/ LastTime)
		
		(if (and FileToImportBarsXls$ (findfile FileToImportBarsXls$)) 
			(progn
				(set_tile "FileSelectBarsXls" FileToImportBarsXls$)
				(setq LastTime (GetFileLastModified FileToImportBarsXls$))
				(if (> LastTime LastTimeFileToImportBarsXls$)
					(progn
						(setq LastTimeFileToImportBarsXls$ LastTime)
						(setq <LstSheet> (GetSheetsXls))
 					)
					(setq <LstSheet> LstSheet$)
				)
			)
		)
		(if FileToImportBarsCsv$ (set_tile "FileSelectBarsCsv" FileToImportBarsCsv$))
		
		(cond 
			((= TypeFileToImportBars$ "1")
				
				(if (or (not ValSheetImportBars$) (= ValSheetImportBars$ ""))		(setq ValSheetImportBars$ "0"))
				(if (not ValLengthImportBars$)		(setq ValLengthImportBars$		"0"))
				(if (not ValProfileImportBars$)		(setq ValProfileImportBars$		"1"))
				(if (not ValMaterialImportBars$)	(setq ValMaterialImportBars$	"2"))
				;(setq <LstSheet> 	 (GetSheetsXls))
				
				(start_list "ListSheet")(mapcar 'add_list <LstSheet>) 	(end_list)
				(start_list "Length") 	(mapcar 'add_list <LstLength>) 	(end_list)
				(start_list "Profile") 	(mapcar 'add_list <LstProfile>) (end_list)
				(start_list "Material") (mapcar 'add_list <LstMaterial>)(end_list)
				
				(set_tile   "ListSheet" ValSheetImportBars$)
				(set_tile   "Length" 	ValLengthImportBars$)
				(set_tile   "Profile" 	ValProfileImportBars$)
				(set_tile   "Material" 	ValMaterialImportBars$)

				
			)
			((= TypeFileToImportBars$ "2")

				(if (not ValSeparatorImportBars$)	(setq ValSeparatorImportBars$	"0"))
		
				(if (not ValCol1ImportBars$)		(setq ValCol1ImportBars$		"0"))
				(if (not ValCol2ImportBars$)		(setq ValCol2ImportBars$		"1"))
				(if (not ValCol3ImportBars$)		(setq ValCol3ImportBars$		"2"))
				
				(start_list "Separator")(mapcar 'add_list <LstSeparator>) 	(end_list)
				(start_list "Col1") 	(mapcar 'add_list <LstCol1>) 		(end_list)
				(start_list "Col2") 	(mapcar 'add_list <LstCol2>) 		(end_list)
				(start_list "Col3") 	(mapcar 'add_list <LstCol3>) 		(end_list)
				
				(set_tile   "Separator" ValSeparatorImportBars$)
				(set_tile   "Col1" 		ValCol1ImportBars$)
				(set_tile   "Col2" 		ValCol2ImportBars$)
				(set_tile   "Col3" 		ValCol3ImportBars$)
				(RefreshValueSeparator)
			)
		)
		
	)
	;
	;
	(defun PutGuiInfo ()
	
		(princ "\nTypeFileToImportBars$   ")    (princ TypeFileToImportBars$)
		(princ "\nFileToImportBarsXls$    ")    (princ FileToImportBarsXls$)
		(princ "\nFileToImportBarsCsv$    ")  	(princ FileToImportBarsCsv$)
		(princ "\nLstSheet$                ")   (princ LstSheet$)
		(princ "\nValSheetImportBars$     ") 	(princ ValSheetImportBars$)
		(princ "\nValLengthImportBars$    ")	(princ ValLengthImportBars$)
		(princ "\nValProfileImportBars$     ")	(princ ValProfileImportBars$)
		(princ "\nValMaterialImportBars$  ")	(princ ValMaterialImportBars$)
		(princ "\nValSeparatorImportBars$ ")	(princ ValSeparatorImportBars$)
		(princ "\nValCol1ImportBars$      ")	(princ ValCol1ImportBars$)
		(princ "\nValCol2ImportBars$      ")	(princ ValCol2ImportBars$)
		(princ "\nValCol3ImportBars$      ")	(princ ValCol3ImportBars$)
		
		(princ "\nValOrderNAXls$           ")	(princ ValOrderNAXls$)	
		(princ "\nValPhaseNAXls$           ")	(princ ValPhaseNAXls$)			
		(princ "\nValMatNAXls$             ")	(princ ValMatNAXls$)		
		(princ "\nValOrderNACsv$           ")	(princ ValOrderNACsv$)
		(princ "\nValPhaseNACsv$           ")	(princ ValPhaseNACsv$)
		(princ "\nValMatNACsv$             ")	(princ ValMatNACsv$)		
		(princ "\n<LstColumnSeekXls>       ")	(princ <LstColumnSeekXls>)
		(princ "\n<LstColumnSeekCsv>       ")	(princ <LstColumnSeekCsv>)
		(princ "\n<SheetBook>              ")	(princ <SheetBook>)
		(princ "\n<LstNAXls>               ")	(princ <LstNAXls>)
		(princ "\n<LstNACsv>               ")	(princ <LstNACsv>) 
	)
	;
	;
	(defun GetGui ()
	
		(setq ValLengthImportBars$		(get_tile "Length"))
		(setq ValProfileImportBars$		(get_tile "Profile"))
		(setq ValMaterialImportBars$	(get_tile "Material"))
	
		(cond 
			((= TypeFileToImportBars$ "1")
				(setq ValSheetImportBars$	(get_tile "ListSheet"))
				(setq <LstColumnSeekXls>	(list (nth (atoi ValLengthImportBars$) 	  <LstLength>)
												  (nth (atoi ValProfileImportBars$)   <LstProfile>)
												  (nth (atoi ValMaterialImportBars$)  <LstMaterial>)
											)
				)
				(if (and LstSheet$  <LstSheet>)   (setq <SheetBook> (nth (atoi ValSheetImportBars$) <LstSheet>)))
			)
			((= TypeFileToImportBars$ "2")
				(setq ValSeparatorImportBars$	(get_tile "Separator"))
				(setq ValCol1ImportBars$		(get_tile "Col1"))
				(setq ValCol2ImportBars$		(get_tile "Col2"))
				(setq ValCol3ImportBars$		(get_tile "Col3"))
				(setq <LstColumnSeekCsv>	(list (nth (atoi ValCol1ImportBars$) <LstCol1>)
												  (nth (atoi ValCol2ImportBars$) <LstCol2>)
												  (nth (atoi ValCol3ImportBars$) <LstCol3>)
											)
				)
				(setq <Separator> (nth (atoi ValSeparatorImportBars$) <LstSeparator>))
			)
		)
	)
	;
	;
	(defun GetSheetsXls (/ LstSheet)
		(setq LstSheet$ nil)
		(if FileToImportBarsXls$
			(if (findfile FileToImportBarsXls$)
				(progn
					;(ProgressBar "" "Lettura Excel" 0.1)
					;(setq Reps~ 1)
					;(PrgBr 10)
					(OpenExcel FileToImportBarsXls$)
					;(PrgBr 10)
					(GetListSheet) (setq LstSheet$ MySheets$)
					;(PrgBr 10)
					(CloseExcel)
					;(EndProgressBar)					
				)
			)
		)
		LstSheet$
	)
	;
	;
	(defun RefreshValueSeparator ()
			(setq ValSeparatorImportBars$	(get_tile "Separator"))
			(set_tile "TextSeparator" (strcat "" (nth (atoi ValSeparatorImportBars$) <LstSeparator>)))
			(set_tile "TextSeparator" (strcat "Separatore -> " (nth (atoi ValSeparatorImportBars$) <LstSeparator>)))
	)
	;
	; Main
	;
	(setq <LstLength>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstProfile>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstMaterial>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))

	(setq <LstSeparator> '(";" "," "|"))
	(setq <LstCol1>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol2>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol3>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	
	(if FileBar
		(if (findfile FileBar)
			(cond
				((or (= (strcase (vl-filename-extension FileBar)) ".XLS")
					 (= (strcase (vl-filename-extension FileBar)) ".XLSX"))
					(setq xx (load_dialog (strcat GuiPathEasyCut$ "PartsAndBars.dcl")))
					(new_dialog "ImportBarsXls" xx "" (cond ( *ImportBarsXls* ) ( '(-1 -1) )))
					(setq FileToImportBarsXls$ FileBar)
					(setq FileToImportBarsCsv$ nil)
					(setq TypeFileToImportBars$ "1")
				)
				((= (strcase (vl-filename-extension FileBar)) ".CSV")
					(setq xx (load_dialog (strcat GuiPathEasyCut$ "PartsAndBars.dcl")))
					(new_dialog "ImportBarsCsv" xx "" (cond ( *ImportBarsCsv* ) ( '(-1 -1) )))
					(setq FileToImportBarsCsv$ FileBar)
					(setq FileToImportBarsXls$ nil)
					(setq TypeFileToImportBars$ "2")
				)
			)
		)
	)
	(if xx
		(progn
			(setq Loop T)
			(while Loop
				
				(PutGui)
				(action_tile "ChkFileBarsXls"		(strcat "(GetGui) 
													 (setq FileCheckXls T)
													 (setq	*ImportBarsXls* (done_dialog))
													 (unload_dialog xx)"))
				(action_tile "ChkFileBarsCsv"		(strcat "(GetGui) 
													 (setq FileCheckCsv T)
													 (setq	*ImportBarsXls* (done_dialog))
													 (unload_dialog xx)"))
				(action_tile "Separator"			"(RefreshValueSeparator)")
				(action_tile "cancel"    			(strcat "(setq *ImportBarsXls* (done_dialog))
															 (unload_dialog xx)
															 (setq Loop nil)"))
				(action_tile "accept"    			(strcat "(GetGui) 
															 (setq ImportBars T)
															 (setq *ImportBarsXls* (done_dialog)) 
															 (unload_dialog xx)
															 (setq Loop nil)"))
				(start_dialog)
		
				(cond 
					((= FileCheckXls T)
						(setq FileCheckXls nil)
						(CheckBarsImportXls FileToImportBarsXls$ <SheetBook> <LstColumnSeekXls>)
						(setq xx (load_dialog (strcat GuiPathEasyCut$ "PartsAndBars.dcl")))
						(new_dialog "ImportBarsXls" xx "" (cond ( *ImportBarsXls* ) ( '(-1 -1) )))
					)
					((= FileCheckCsv T)
						(setq FileCheckCsv nil)
						(CheckBarsImportCsv FileToImportBarsCsv$ <Separator> <LstColumnSeekCsv>)
						(setq xx (load_dialog (strcat GuiPathEasyCut$ "PartsAndBars.dcl")))
						(new_dialog "ImportBarsCsv" xx "" (cond ( *ImportBarsCsv* ) ( '(-1 -1) )))
					)
					((= ImportBars T)
						(cond 
							((= TypeFileToImportBars$ "1")
								(setq LstDataBars (ReadDataBarsFromXls FileToImportBarsXls$ <SheetBook> <LstColumnSeekXls>))
							)
							((= TypeFileToImportBars$ "2")
								(setq LstDataBars (ReadDataBarsFromCsv FileToImportBarsCsv$ <Separator> <LstColumnSeekCsv>))
							)
						)
						(setq ImportBars nil)
					)
				)
			)
		)
	)
	LstDataBars
)
;
;
;
(defun ReadDataPartsFromXls (FileImportPartsXls SheetBook LstColumnSeek / CompleteXlsLine AssignValueDataXls ParseDataXls
																				   MaxLoopSearch LoopSearch LineRead Num LstRead)

	;     0     0     1     1     1     1        0
	;     A     B     C     D     E     F        G
	;   order phase  mark  qta  Length Profile Material
	;
	(defun CompleteXlsLine (ListLineRead / NumCol itm Rtn)
	
		(foreach itm ListLineRead
			(if (= (type itm) 'STR)
				(setq Rtn (append Rtn (list (vl-string-right-trim " \t" (vl-string-left-trim " \t" itm)))))
				(setq Rtn (append Rtn (list itm)))
			)
		)
		Rtn
	)
	;
	;
	;
	(defun AssignValueDataXls (ListDataXls LstColumnSeek / PrincToString
																	AlternativeOrder AlternativePhase AlternativeMat
																	NDOrder NDPhase NDMat
																	Num itm Order Phase Mat Mark Quantity Length Profile)

		(defun PrincToString (Val / Rtn)
		
			(if Val
				(cond
					((= (type Val) 'STR)
						(setq Rtn Val)
					)
					((= (type Val) 'INT)
						(setq Rtn (vl-princ-to-string Val))
					)
					((= (type Val) 'REAL)
						(if (= (- Val (fix Val)) 0)
							(setq Rtn (LM:rtos Val 2 0))
							(setq Rtn (vl-princ-to-string Val))
						)
					)
				)
			)
		)
		;
		; Main
		;
		
		(setq Num 0)
		(if (and ListDataXls LstColumnSeek)
			(progn
				(foreach itm LstColumnSeek
					(cond 
						((= Num 0)
							(if (= itm "N.D.")
								(setq Order NDOrder)
								(if (or (= (nth Num ListDataXls) "") (= (nth Num ListDataXls) nil))
									(setq Order  NDOrder)
									(setq Order  (PrincToString (nth Num ListDataXls)))
								)
							)
						)
						((= Num 1)
							(if (= itm "N.D.")
								(setq Phase NDPhase)
								(if (or (= (nth Num ListDataXls) "") (= (nth Num ListDataXls) nil))
									(setq Phase NDPhase)
									(setq Phase  (PrincToString (nth Num ListDataXls)))
								)
							)
						)
						((= Num 2)
							(setq Mark  	(PrincToString (nth Num  ListDataXls)))
						)
						((= Num 3)
							(setq Quantity 	(PrincToString (nth Num  ListDataXls)))
						)
						((= Num 4)
							(setq Length 	(PrincToString (nth Num  ListDataXls)))
						)
						((= Num 5)
							(setq Profile 	(PrincToString (nth Num  ListDataXls)))
						)
						((= Num 6)
							(if (= itm "N.D.")
								(setq Mat NDMat)
								(if (or (= (nth Num ListDataXls) "") (= (nth Num ListDataXls) nil))
									(setq Mat NDMat)
									(setq Mat (PrincToString (nth Num ListDataXls)))
								)
							)
						)
					)
					(setq Num (1+ Num))
				)
				(setq Rtn (list Order Phase Mark Quantity Length Profile Mat))
			)
		)
		Rtn
	)
	;
	;
	;
	(defun ParseDataXls (ListDataXls / Num Chk)
		
		(setq Num 0)
		(setq Chk T)
		(foreach itm ListDataXls
			(if itm
				(cond 
					((= Num 0) (if (= itm "") 		(setq Chk nil)))
					((= Num 1) (if (= itm "") 		(setq Chk nil)))
					((= Num 2) (if (= itm "") 		(setq Chk nil)))
					((= Num 3) (if (= (atoi itm) 0) (setq Chk nil)))
					((= Num 4) (if (= (atof itm) 0) (setq Chk nil)))
					((= Num 5) (if (= itm "") 		(setq Chk nil)))
					((= Num 6) (if (= itm "") 		(setq Chk nil)))
				)
				(setq Chk nil)
			)
			(setq Num (1+ Num))
		)
		Chk
	)
	;
	; Main
	;
	(setq MaxLoopSearch 10)
	(if (and FileImportPartsXls SheetBook LstColumnSeek)
		(if (findfile FileImportPartsXls)
			(progn
				(setq Num 1)
				(ProgressBar "" "Lettura Excel" 0.1)
				(setq Reps~ 1)
				(PrgBr 70)
				(OpenExcel FileImportPartsXls)
				(PrgBr 70)
				(ActiveSheet SheetBook)
				(PrgBr 70)
				
				(setq LoopSearch 1)
				(while LoopSearch 
				
					(setq LineRead (car (ReadCells LstColumnSeek (list (LM:rtos Num 2 0)))))
					(PrgBr 70)

					(setq ValueDataXls (AssignValueDataXls (CompleteXlsLine LineRead) LstColumnSeek))
					(if (ParseDataXls ValueDataXls)
						(progn
							(setq LstRead (append LstRead (list ValueDataXls)))
							(setq Num (1+ Num))
						)
						(progn
							(setq Num (1+ Num))
							(setq LoopSearch (1+ LoopSearch))
						)
					)
					(if (> LoopSearch MaxLoopSearch)
						(setq LoopSearch nil)
					)
				)
				(PrgBr 70)
				(CloseExcel)
				(EndProgressBar)
			)
		)
	)
	LstRead
)
;
;
;
(defun ReadDataPartsFromCsv (FileImportPartsCsv Separator LstColumnSeek / ParseCsvLine AssignValueDataCsv ParseDataCsv
																				   itm LstCol Stream LineRead SplitLineRead LstRead Rtn
																				   ValueDataCsv
																				   AlternativeOrder AlternativePhase AlternativeMat)

	;(READDATAPARTSFROMCSV "C:\\Users\\ut04\\Desktop\\Tmp\\EasyCutBeta_20220612_2048\\NewApp\\NestingBars\\test.csv" ";" '("1" "2" "3" "4" "5" "6" "7") '("" "" ""))
	;     0     0     1     1     1     1      1     0
	;    Col1  Col2  Col3  Col4  Col5   Col6  Col7  Col8
	;   order phase  mark  qta  Length Width Thick Material
	;
	
	(defun CompleteCsvLine (LineRead Separator / NumCol itm Rtn)
	
		(setq NumCol 26)
		(if (and LineRead Separator)
			(progn
				(foreach itm (LM:csv->lst LineRead Separator 0)
					(setq Rtn (append Rtn (list (vl-string-right-trim " \t" (vl-string-left-trim " \t" itm)))))
				)
				(repeat (- NumCol (length Rtn))
					(setq Rtn (append Rtn (list "")))
				)
			)
		)
	)
	;
	;
	;
	(defun AssignValueDataCsv (ListDataCsv LstColumnSeek  / AlternativeOrder AlternativePhase AlternativeMat
															NDOrder NDPhase NDMat
															Num itm Order Phase Mat Mark Quantity Length Profile)



		(setq Num 0)
		(if (and ListDataCsv LstColumnSeek)
			(progn
				(foreach itm LstColumnSeek
					(cond 
						((= Num 0)
							(if (= itm "N.D.")
								(setq Order NDOrder)
								(if (= (nth (- (atoi itm) 1) ListDataCsv) "")
									(setq Order  NDOrder)
									(setq Order  (nth (- (atoi itm) 1) ListDataCsv))
								)
							)
						)
						((= Num 1)
							(if (= itm "N.D.")
								(setq Phase NDPhase)
								(if (= (nth (- (atoi itm) 1) ListDataCsv) "")
									(setq Phase NDPhase)
									(setq Phase  (nth (- (atoi itm) 1) ListDataCsv))
								)
							)
						)
						((= Num 2)
							(setq Mark  		(nth (- (atoi itm) 1)  ListDataCsv))
						)
						((= Num 3)
							(setq Quantity 		(nth (- (atoi itm) 1)  ListDataCsv))
						)
						((= Num 4)
							(setq Length 		(nth (- (atoi itm) 1)  ListDataCsv))
						)
						((= Num 5)
							(setq Profile 		(nth (- (atoi itm) 1)  ListDataCsv))
						)
						((= Num 6)
							(if (= itm "N.D.")
								(setq Mat NDMat)
								(if (= (nth (- (atoi itm) 1) ListDataCsv) "")
									(setq Mat NDMat)
									(setq Mat (nth (- (atoi itm) 1) ListDataCsv))
								)
							)
						)
					)
					(setq Num (1+ Num))
				)
				(setq Rtn (list Order Phase Mark Quantity Length Profile Mat))
			)
		)
		Rtn
	)
	;
	;
	;
	(defun ParseDataCsv (ListDataCsv / Num Chk)
		
		(setq Num 0)
		(setq Chk T)
		(foreach itm ListDataCsv
			
			(cond 
				((= Num 0) (if (= itm "") 		(setq Chk nil)))
				((= Num 1) (if (= itm "") 		(setq Chk nil)))
				((= Num 2) (if (= itm "") 		(setq Chk nil)))
				((= Num 3) (if (= (atoi itm) 0) (setq Chk nil)))
				((= Num 4) (if (= (atof itm) 0) (setq Chk nil)))
				((= Num 5) (if (= itm "") 		(setq Chk nil)))
				((= Num 6) (if (= itm "") 		(setq Chk nil)))
			)
			(setq Num (1+ Num))
		)
		Chk
	)
	;
	; Main
	;
	(if (and FileImportPartsCsv Separator LstColumnSeek)
		(if (findfile FileImportPartsCsv)
			(progn
				(foreach itm LstColumnSeek
					(setq LstCol (append LstCol (list (atoi (substr itm (strlen itm) 1)))))
				)
				(setq Stream (open FileImportPartsCsv "r"))
				(if Stream
					(while (setq LineRead (read-line Stream))
						(setq ValueDataCsv (AssignValueDataCsv (CompleteCsvLine LineRead Separator) LstColumnSeek))
						(if (ParseDataCsv ValueDataCsv)
							(setq LstRead (append LstRead (list ValueDataCsv)))
						)
					)
				)
				(Close Stream)
			)
		)
	)
	LstRead
)
;
;
;
(defun CheckPartsImportXls (FileImportPartsXls SheetBook LstColumnSeek / itm itm1 LstHead Ncar Stream FileTmp Prg)

	(cond
		((null FileImportPartsXls)
			(LM:popup "avvertimento" "Dare il nome del file" (+ 0 48 4096))
		)
		(t
			(foreach itm (ReadDataPartsFromXls FileImportPartsXls SheetBook LstColumnSeek)
				(setq LstHead (append LstHead (list (list	(nth 0  itm) 				;->  IdOrder
															(nth 1  itm) 				;->  IdPhase
															(nth 2  itm) 				;->  IdIdentification
															(nth 3  itm) 				;->  IdQuantity
															(nth 4  itm)				;->  IdLength
															(nth 5  itm)				;->  IdProfile
															(strcase (nth 6  itm)) 		;->  IdQuality
															(today)))))
			)
			(if LstHead
				(progn
					(setq Ncar (list 6 10))
					(setq FileTmp (vl-filename-mktemp))
					(setq Stream (open FileTmp "w"))
					(princ (strcat 	"\n"
									(testo_a_sinistra "Item" 			(car  Ncar))
									(testo_a_sinistra "Order" 			(cadr Ncar))
									(testo_a_sinistra "Phase" 			(cadr Ncar))
									(testo_a_sinistra "Name"		 	(cadr Ncar))
									(testo_a_sinistra "Qta."			(cadr Ncar))
									(testo_a_sinistra "Length" 			(cadr Ncar))
									(testo_a_sinistra "Prof." 			(cadr Ncar))
									(testo_a_sinistra "Mat." 			(cadr Ncar))
									(testo_a_sinistra "Date" 			(cadr Ncar))
									"\n") Stream)
					(setq Prg 1)
					(foreach itm LstHead
						(princ "\n" Stream)
						(princ (testo_a_sinistra (vl-princ-to-string Prg) (car Ncar)) Stream)
						(foreach itm1 itm (princ (testo_a_sinistra (vl-princ-to-string itm1) (cadr Ncar)) Stream))
						(setq Prg (1+ Prg))
					)
					(close Stream)
					(EasyCutViewer FileTmp)
				)
				(LM:popup "avvertimento" "Il file non e' formattato correttamente" (+ 0 48 4096))
			)	
		)
	)
)
;
;
;
(defun CheckPartsImportCsv (FileImportPartsCsv Separator LstColumnSeek / itm itm1 LstHead Ncar Stream FileTmp Prg)

	(cond
		((null FileImportPartsCsv)
			(LM:popup "avvertimento" "Dare il nome del file" (+ 0 48 4096))
		)
		(t
			(foreach itm (ReadDataPartsFromCsv FileImportPartsCsv <Separator> <LstColumnSeekCsv>)
				(setq LstHead (append LstHead (list (list	(nth 0  itm) 			;->  IdOrder
															(nth 1  itm) 			;->  IdPhase
															(nth 2  itm) 			;->  IdIdentification
															(nth 3  itm) 			;->  IdQuantity
															(nth 4  itm) 			;->  IdLength
															(nth 5  itm)			;->  IdProfile
															(strcase (nth 6  itm)) 	;->  IdQuality
															(today)))))
			)
			(if LstHead
				(progn
					(setq Ncar (list 6 10))
					(setq FileTmp (vl-filename-mktemp))
					(setq Stream (open FileTmp "w"))
					(princ (strcat 	"\n"
									(testo_a_sinistra "Item" 			(car  Ncar))
									(testo_a_sinistra "Order" 			(cadr Ncar))
									(testo_a_sinistra "Phase" 			(cadr Ncar))
									(testo_a_sinistra "Name"		 	(cadr Ncar))
									(testo_a_sinistra "Qta."			(cadr Ncar))
									(testo_a_sinistra "Length" 			(cadr Ncar))
									(testo_a_sinistra "Prof." 			(cadr Ncar))
									(testo_a_sinistra "Mat." 			(cadr Ncar))
									(testo_a_sinistra "Date" 			(cadr Ncar))
									"\n") Stream)
					(setq Prg 1)
					(foreach itm LstHead
						(princ "\n" Stream)
						(princ (testo_a_sinistra (vl-princ-to-string Prg) (car Ncar)) Stream)
						(foreach itm1 itm (princ (testo_a_sinistra (vl-princ-to-string itm1) (cadr Ncar)) Stream))
						(setq Prg (1+ Prg))
					)
					(close Stream)
					(EasyCutViewer FileTmp)
				)
				(LM:popup "avvertimento" "Il file non e' formattato correttamente" (+ 0 48 4096))
			)
		)
	)
)
;
;
;
(defun ReadDataBarsFromXls (FileImportBarsXls SheetBook LstColumnSeek / CompleteXlsLine AssignValueDataXls ParseDataXls
																	    MaxLoopSearch LoopSearch LineRead Num LstRead)

	;    
	;     A     B        C
	;   Length Profile Material
	;
	(defun CompleteXlsLine (ListLineRead / NumCol itm Rtn)
	
		(foreach itm ListLineRead
			(if (= (type itm) 'STR)
				(setq Rtn (append Rtn (list (vl-string-right-trim " \t" (vl-string-left-trim " \t" itm)))))
				(setq Rtn (append Rtn (list itm)))
			)
		)
		Rtn
	)
	;
	;
	;
	(defun AssignValueDataXls (ListDataXls LstColumnSeek /  PrincToString
															AlternativeOrder AlternativePhase AlternativeMat
															NDOrder NDPhase NDMat
															Num itm Mat Quantity Length) 

		(defun PrincToString (Val / Rtn)
		
			(if Val
				(cond
					((= (type Val) 'STR)
						(setq Rtn Val)
					)
					((= (type Val) 'INT)
						(setq Rtn (vl-princ-to-string Val))
					)
					((= (type Val) 'REAL)
						(if (= (- Val (fix Val)) 0)
							(setq Rtn (LM:rtos Val 2 0))
							(setq Rtn (vl-princ-to-string Val))
						)
					)
				)
			)
		)
		;
		; Main
		;
		;(setq AlternativeOrder	"-")
		;(setq AlternativePhase	"-")
		;(setq AlternativeMat	"-")

		;(if (= (setq NDOrder (car LstNAXls)) "")   (setq NDOrder AlternativeOrder))
		;(if (= (setq NDPhase (cadr LstNAXls)) "")  (setq NDPhase AlternativePhase))
		;(if (= (setq NDMat   (caddr LstNAXls)) "") (setq NDMat   AlternativeMat))
		
		(setq Num 0)
		(if (and ListDataXls LstColumnSeek)
			(progn
				(foreach itm LstColumnSeek
					(cond 
						((= Num 0)
							(setq Length 	(PrincToString (nth Num  ListDataXls)))
						)
						((= Num 1)
							(setq Profile 	(PrincToString (nth Num  ListDataXls)))
						)
						((= Num 2)
							(if (= itm "N.D.")
								(setq Mat NDMat)
								(if (or (= (nth Num ListDataXls) "") (= (nth Num ListDataXls) nil))
									(setq Mat NDMat)
									(setq Mat (PrincToString (nth Num ListDataXls)))
								)
							)
						)
					)
					(setq Num (1+ Num))
				)
				(setq Rtn (list Length Profile Mat))
			)
		)
		Rtn
	)
	;
	;
	;
	(defun ParseDataXls (ListDataXls / Num Chk)
		
		(setq Num 0)
		(setq Chk T)
		(foreach itm ListDataXls
			(if itm
				(cond 
					((= Num 0) (if (= (atof itm) 0) (setq Chk nil)))
					((= Num 1) (if (= itm "") 		(setq Chk nil)))
					((= Num 2) (if (= itm "") 		(setq Chk nil)))
				)
				(setq Chk nil)
			)
			(setq Num (1+ Num))
		)
		Chk
	)
	;
	; Main
	;
	(setq MaxLoopSearch 10)
	(if (and FileImportBarsXls SheetBook LstColumnSeek)
		(if (findfile FileImportBarsXls)
			(progn
				(setq Num 1)
				(ProgressBar "" "Lettura Excel" 0.1)
				(setq Reps~ 1)
				(PrgBr 70)
				(OpenExcel FileImportBarsXls)
				(PrgBr 70)
				(ActiveSheet SheetBook)
				(PrgBr 70)
				
				(setq LoopSearch 1)
				(while LoopSearch 
				
					(setq LineRead (car (ReadCells LstColumnSeek (list (LM:rtos Num 2 0)))))
					(PrgBr 70)

					(setq ValueDataXls (AssignValueDataXls (CompleteXlsLine LineRead) LstColumnSeek))
					(if (ParseDataXls ValueDataXls)
						(progn
							(setq LstRead (append LstRead (list ValueDataXls)))
							(setq Num (1+ Num))
						)
						(progn
							(setq Num (1+ Num))
							(setq LoopSearch (1+ LoopSearch))
						)
					)
					(if (> LoopSearch MaxLoopSearch)
						(setq LoopSearch nil)
					)
				)
				(PrgBr 70)
				(CloseExcel)
				(EndProgressBar)
			)
		)
	)
	LstRead
)
;
;
;
(defun ReadDataBarsFromCsv (FileImportBarsCsv Separator LstColumnSeek / ParseCsvLine AssignValueDataCsv ParseDataCsv
																				   itm LstCol Stream LineRead SplitLineRead LstRead Rtn
																				   ValueDataCsv
																				   AlternativeOrder AlternativePhase AlternativeMat)

	;(READDATABarSFROMCSV "C:\\Users\\ut04\\Desktop\\Tmp\\EasyCutBeta_20220612_2048\\NewApp\\NestingBars\\test.csv" ";" '("1" "2" "3" "4" "5" "6" "7"))
	;     
	;    Col1  Col2  Col3
	;   Length Width Material
	;
	
	(defun CompleteCsvLine (LineRead Separator / NumCol itm Rtn)
	
		(setq NumCol 26)
		(if (and LineRead Separator)
			(progn
				(foreach itm (LM:csv->lst LineRead Separator 0)
					(setq Rtn (append Rtn (list (vl-string-right-trim " \t" (vl-string-left-trim " \t" itm)))))
				)
				(repeat (- NumCol (length Rtn))
					(setq Rtn (append Rtn (list "")))
				)
			)
		)
	)
	;
	;
	;
	(defun AssignValueDataCsv (ListDataCsv LstColumnSeek  / AlternativeOrder AlternativePhase AlternativeMat
															NDOrder NDPhase NDMat
															Num itm Mat Length Profile)



		;(setq AlternativeOrder	"-")
		;(setq AlternativePhase	"-")
		;(setq AlternativeMat	"-")

		;(if (= (setq NDOrder (car LstNACsv)) "")   (setq NDOrder AlternativeOrder))
		;(if (= (setq NDPhase (cadr LstNACsv)) "")  (setq NDPhase AlternativePhase))
		;(if (= (setq NDMat   (caddr LstNACsv)) "") (setq NDMat   AlternativeMat))
		
		(setq Num 0)
		(if (and ListDataCsv LstColumnSeek)
			(progn
				(foreach itm LstColumnSeek
					(cond 
						((= Num 0)
							(setq Length 		(nth (- (atoi itm) 1)  ListDataCsv))
						)
						((= Num 1)
							(setq Profile 		(nth (- (atoi itm) 1)  ListDataCsv))
						)
						((= Num 2)
							(if (= itm "N.D.")
								(setq Mat NDMat)
								(if (= (nth (- (atoi itm) 1) ListDataCsv) "")
									(setq Mat NDMat)
									(setq Mat (nth (- (atoi itm) 1) ListDataCsv))
								)
							)
						)
					)
					(setq Num (1+ Num))
				)
				(setq Rtn (list Length Profile Mat))
			)
		)
		Rtn
	)
	;
	;
	;
	(defun ParseDataCsv (ListDataCsv / Num Chk)
		
		(setq Num 0)
		(setq Chk T)
		(foreach itm ListDataCsv
			
			(cond 
				((= Num 0) (if (= (atof itm) 0) (setq Chk nil)))
				((= Num 1) (if (= itm "") 		(setq Chk nil)))
				((= Num 2) (if (= itm "") 		(setq Chk nil)))
			)
			(setq Num (1+ Num))
		)
		Chk
	)
	;
	; Main
	;
	(if (and FileImportBarsCsv Separator LstColumnSeek)
		(if (findfile FileImportBarsCsv)
			(progn
				(foreach itm LstColumnSeek
					(setq LstCol (append LstCol (list (atoi (substr itm (strlen itm) 1)))))
				)
				(setq Stream (open FileImportBarsCsv "r"))
				(if Stream
					(while (setq LineRead (read-line Stream))
						(setq ValueDataCsv (AssignValueDataCsv (CompleteCsvLine LineRead Separator) LstColumnSeek))
						(if (ParseDataCsv ValueDataCsv)
							(setq LstRead (append LstRead (list ValueDataCsv)))
						)
					)
				)
				(Close Stream)
			)
		)
	)
	LstRead
)
;
;
;
(defun CheckBarsImportXls (FileImportBarsXls SheetBook LstColumnSeek / itm itm1 LstHead Ncar Stream FileTmp Prg)

	(cond
		((null FileImportBarsXls)
			(LM:popup "avvertimento" "Dare il nome del file" (+ 0 48 4096))
		)
		(t
			(foreach itm (ReadDataBarsFromXls FileImportBarsXls SheetBook LstColumnSeek)
				(setq LstHead (append LstHead (list (list	(nth 0  itm)				;->  IdLength
															(nth 1  itm)				;->  IdProfile
															(strcase (nth 2  itm)) 		;->  IdQuality
															(today)))))
			)
			(if LstHead
				(progn
					(setq Ncar (list 6 10))
					(setq FileTmp (vl-filename-mktemp))
					(setq Stream (open FileTmp "w"))
					(princ (strcat 	"\n"
									(testo_a_sinistra "Item" 			(car  Ncar))
									(testo_a_sinistra "Length" 			(cadr Ncar))
									(testo_a_sinistra "Prof." 			(cadr Ncar))
									(testo_a_sinistra "Mat." 			(cadr Ncar))
									(testo_a_sinistra "Date" 			(cadr Ncar))
									"\n") Stream)
					(setq Prg 1)
					(foreach itm LstHead
						(princ "\n" Stream)
						(princ (testo_a_sinistra (vl-princ-to-string Prg) (car Ncar)) Stream)
						(foreach itm1 itm (princ (testo_a_sinistra (vl-princ-to-string itm1) (cadr Ncar)) Stream))
						(setq Prg (1+ Prg))
					)
					(close Stream)
					(EasyCutViewer FileTmp)
				)
				(LM:popup "avvertimento" "Il file non e' formattato correttamente" (+ 0 48 4096))
			)	
		)
	)
)
;
;
;
(defun CheckBarsImportCsv (FileImportBarsCsv Separator LstColumnSeek / itm itm1 LstHead Ncar Stream FileTmp Prg)

	(cond
		((null FileImportBarsCsv)
			(LM:popup "avvertimento" "Dare il nome del file" (+ 0 48 4096))
		)
		(t
			(foreach itm (ReadDataBarsFromCsv FileImportBarsCsv <Separator> <LstColumnSeekCsv>)
				(setq LstHead (append LstHead (list (list	(nth 0  itm) 			;->  IdLength
															(nth 1  itm)			;->  IdProfile
															(strcase (nth 2  itm)) 	;->  IdQuality
															(today)))))
			)
			(if LstHead
				(progn
					(setq Ncar (list 6 10))
					(setq FileTmp (vl-filename-mktemp))
					(setq Stream (open FileTmp "w"))
					(princ (strcat 	"\n"
									(testo_a_sinistra "Item" 			(car  Ncar))
									(testo_a_sinistra "Length" 			(cadr Ncar))
									(testo_a_sinistra "Prof." 			(cadr Ncar))
									(testo_a_sinistra "Mat." 			(cadr Ncar))
									(testo_a_sinistra "Date" 			(cadr Ncar))
									"\n") Stream)
					(setq Prg 1)
					(foreach itm LstHead
						(princ "\n" Stream)
						(princ (testo_a_sinistra (vl-princ-to-string Prg) (car Ncar)) Stream)
						(foreach itm1 itm (princ (testo_a_sinistra (vl-princ-to-string itm1) (cadr Ncar)) Stream))
						(setq Prg (1+ Prg))
					)
					(close Stream)
					(EasyCutViewer FileTmp)
				)
				(LM:popup "avvertimento" "Il file non e' formattato correttamente" (+ 0 48 4096))
			)
		)
	)
)
;
;
;
;
;
;
(defun GuiSelPiecesParts ( / MakeButtons UpDateButtons FormatTableNesting SelectItmBoxList LoadTable BoxToList ListToBox SortBox 
						     RemovePart RemoveBar ModifiedPart ModifiedBar AddPart AddBar SelectFile GetCodeJob SaveJob ReadJobBar
							 ImportJob ImportFileBar ImportFilePart ImportFilePart NestingBar CheckDataNestingBar LoadExamplePart LoadExampleBar
							 AccuracyResultNestingBar
							 xx LstButtonPKey LstButtonBKey LstSortP$ LstSortB$ ImportPart ModPart LstIdParts LstIdBars GoNestingBar TmpLstPart)
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
	(defun SelectItmBoxList (KeyName)
		(if KeyName
			(get_tile keyName)
		)
	)	
	;
	;
	(defun LoadTable (LstTable KeyTable Index / Num itm Rtn)

		(start_list KeyTable)
			(mapcar 'add_list nil)
		(end_list)
		
		(if LstTable
			(cond 
				((= Index T)
					(setq Num 1)
					(foreach itm LstTable
						(setq Rtn (append Rtn (list (LM:lst->str (LM:SubstNth (LM:rtos Num 2 0) 0 (LM:str->lst itm "\t")) "\t"))))
						(setq Num (1+ Num))
					)
					(start_list KeyTable)
						(mapcar 'add_list Rtn)
					(end_list)
					Rtn
				)
				(t
					(start_list KeyTable)
						(mapcar 'add_list LstTable)
					(end_list)
					LstTable
				)
			)
		)
	)
	;
	;
	(defun BoxToList (LstBox / itm Rtn)
		(foreach itm LstBox
			(setq Rtn (append Rtn (list (LM:str->lst itm "\t"))))
		)
	)
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
	(defun SortBox (LstPart Button LstButtonKey LstStatusButton TypeMember / LstSort TypeSort Num itm Rtn)

		(if (and LstPart Button LstButtonKey LstStatusButton)
			(progn

				(cond 
					((= TypeMember "Part")
						(setq LstSortP$ (UpDateButtons Button LstButtonKey LstStatusButton))
						(setq LstSort LstSortP$)
					)
					((= TypeMember "Bar")
						(setq LstSortB$ (UpDateButtons Button LstButtonKey LstStatusButton))
						(setq LstSort LstSortB$)
					)
				)
				
				
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
				(setq Rtn (SortTable LstPart (cdr LstSort) TypeSort))
				(cond 
					((= TypeMember "Part")
						(setq $LstPart Rtn)
						(LoadTable (FormatTableNesting Rtn) "BoxPart" T)
					)
					((= TypeMember "Bar")
						(setq $LstBar Rtn)
						(LoadTable (FormatTableNesting Rtn) "BoxBar" T)
					)
				)
			)
		)
	)
	;
	;
	(defun RemovePart (LstPart LstNth / RemoveListNthFromList Rtn)
	
		(defun RemoveListNthFromList (Lst LstNth / LstPos Pos itm)
			(setq Pos 0)
			(foreach itm LstNth
				(if (numberp (read itm))
					(progn
						(setq LstPos (append LstPos (list (- (atoi itm) Pos))))
						(setq Pos (1+ Pos))
					)
				)
			)
			(foreach itm LstPos	(setq Lst (LM:RemoveNth itm Lst)))
			Lst
		)
		;
		; Main
		;
		(if (and LstPart LstNth)
			(setq Rtn (RemoveListNthFromList LstPart LstNth))
			(setq Rtn -1)
		)
	)
	;
	;
	(defun RemoveBar (LstBar LstNth / RemoveListNthFromList Rtn)
	
		(defun RemoveListNthFromList (Lst LstNth / LstPos Pos itm)
			(setq Pos 0)
			(foreach itm LstNth
				(if (numberp (read itm))
					(progn
						(setq LstPos (append LstPos (list (- (atoi itm) Pos))))
						(setq Pos (1+ Pos))
					)
				)
			)
			(foreach itm LstPos	(setq Lst (LM:RemoveNth itm Lst)))
			Lst
		)
		;
		; Main
		;
		(if (and LstBar LstNth)
			(setq Rtn (RemoveListNthFromList LstBar LstNth))
			(setq Rtn -1)
		)
	)
	;
	;
	(defun ModifiedPart (LstPart LstNth / GetData UpdateTablePart MakeDialog xx Prog Rtn itm StreamDcl)
	
		;
		(defun GetData (LstNth / Prog SPrg Chk Order Phase Mark Qtantity _Length Profile Material Rtn)
			
			(setq Chk T)
			(setq Prog 1)
			
			(repeat (length LstNth)
				(setq SPrg (LM:rtos Prog 2 0))
				(if (IsEmptyBox (strcat "Order" SPrg))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Commessa non dichiarata" (+ 0 16 4096)))
					(setq Order (GetTextBox (strcat "Order" SPrg)))
				)
				(if (IsEmptyBox (strcat "Phase" SPrg))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Fase non dichiarata" (+ 0 16 4096)))
					(setq Phase (GetTextBox (strcat "Phase" SPrg)))
				)
				(if (IsEmptyBox (strcat "Mark" SPrg))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Marca non dichiarata" (+ 0 16 4096)))
					(setq Mark (GetTextBox (strcat "Mark" SPrg)))
				)
				(if (IsEmptyBox (strcat "Quantity" SPrg))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Quantita' non dichiarata" (+ 0 16 4096)))
					(if (IsOnlyNumberBox (strcat "Quantity" SPrg))
						(setq Quantity (GetTextBox (strcat "Quantity" SPrg)))
						(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Quantita' deve essere un numero" (+ 0 16 4096)))
					)
				)
				(if (IsEmptyBox (strcat "Length" SPrg))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Lunghezza non dichiarata" (+ 0 16 4096)))
					(if (IsOnlyNumberBox (strcat "Length" SPrg))
						(setq _Length (GetTextBox (strcat "Length" SPrg)))
						(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Lunghezza deve essere un numero" (+ 0 16 4096)))
					)
				)
				(if (IsEmptyBox (strcat "Profile" SPrg))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Profilo non dichiarato" (+ 0 16 4096)))
					(setq Profile (GetTextBox (strcat "Profile" SPrg)))
				)
				(if (IsEmptyBox (strcat "Material" SPrg))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Materiale non dichiarato" (+ 0 16 4096)))
					(setq Material (GetTextBox (strcat "Material" SPrg)))
				)
				(setq Rtn (append Rtn (list (list Order Phase Mark Quantity _Length Profile Material))))
				(setq Prog (1+ Prog))
			)
			(if Chk
				Rtn
				nil
			)
		)
		;
		(defun UpdateTablePart (LstPart LstNth LstValue / itm Prog)
		
			(setq Prog 0)
			(if (and LstPart LstNth LstValue)
				(foreach itm LstNth
					(setq LstPart (LM:SubstNth (nth Prog LstValue) (atoi itm) LstPart))
					(setq Prog (1+ Prog))
				)
			)
			LstPart
		)
		;
		(defun MakeDialog (LstNth / dcl des Prog)
			(if LstNth
				(progn
					(setq dcl (vl-filename-mktemp nil nil ".dcl"))
					(setq des (open dcl "w"))
					(write-line (strcat "ModifiedPart" (LM:rtos (length LstNth) 2 0) ":dialog") 			des)
					(write-line 		"	{" 																des)
					(write-line 		"	label=\"Modifica parti\";" 										des)
					(write-line 		"	:row {" 														des)
					(write-line 		"		fixed_width=true;" 											des) 
					(write-line 		"		width=91;" 													des)
					(write-line 		"		:text_part {width=10; fixed_width=true; label=\"Comm\" ;}" 	des)
					(write-line 		"		:text_part {width=10; fixed_width=true; label=\"Fase\" ;}" 	des)
					(write-line 		"		:text_part {width=10; fixed_width=true; label=\"Marca\";}" 	des)
					(write-line 		"		:text_part {width=10; fixed_width=true; label=\"Qta\"  ;}" 	des)
					(write-line 		"		:text_part {width=10; fixed_width=true; label=\"Lung.\";}" 	des)
					(write-line 		"		:text_part {width=10; fixed_width=true; label=\"Prof.\";}" 	des)
					(write-line 		"		:text_part {width=10; fixed_width=true; label=\"Mat.\" ;}" 	des)
					(write-line 		"	}" 																des)

					(setq Prog 1)
					(repeat (length LstNth)
						(write-line ":row {" des)
						(write-line (strcat ":edit_box {key=\"Order" 	(LM:rtos Prog 2 0) 	"\" ; 	edit_width=10;}") des)
						(write-line (strcat ":edit_box {key=\"Phase" 	(LM:rtos Prog 2 0) 	"\" ; 	edit_width=10;}") des)
						(write-line (strcat ":edit_box {key=\"Mark" 	(LM:rtos Prog 2 0) 	"\" ; 	edit_width=10;}") des)
						(write-line (strcat ":edit_box {key=\"Quantity" (LM:rtos Prog 2 0) 	"\" ; 	edit_width=10;}") des)
						(write-line (strcat ":edit_box {key=\"Length" 	(LM:rtos Prog 2 0) 	"\" ; 	edit_width=10;}") des)
						(write-line (strcat ":edit_box {key=\"Profile" 	(LM:rtos Prog 2 0) 	"\" ; 	edit_width=10;}") des)
						(write-line (strcat ":edit_box {key=\"Material" (LM:rtos Prog 2 0) 	"\" ; 	edit_width=10;}") des)
						(write-line "}" des)
						(setq Prog (1+ Prog))
					)
					(write-line 		"	ok_cancel;" 													des)
					(write-line 		"}" 																des)
					(setq des (close des))
					;(EasyCutViewer Dcl)
					dcl
				)
			)
		)
		;
		; Main
		;
		(if (and LstPart LstNth)
			(if (numberp (read (car LstNth)))
				(progn
					(setq StreamDcl (MakeDialog LstNth))
					(setq xx (load_dialog StreamDcl))
					(new_dialog (strcat "ModifiedPart" (LM:rtos (length LstNth) 2 0)) xx "" (cond ( *ModifiedPart* ) ( '(-1 -1) )))

					(setq Prog 1)
					(foreach itm LstNth
						(SetTile (strcat "Order" 	 (LM:rtos Prog 2 0))	(nth 0 (nth (atoi itm) LstPart)))
						(SetTile (strcat "Phase"	 (LM:rtos Prog 2 0))	(nth 1 (nth (atoi itm) LstPart)))
						(SetTile (strcat "Mark"		 (LM:rtos Prog 2 0))	(nth 2 (nth (atoi itm) LstPart)))
						(SetTile (strcat "Quantity"	 (LM:rtos Prog 2 0))	(nth 3 (nth (atoi itm) LstPart)))
						(SetTile (strcat "Length"	 (LM:rtos Prog 2 0))	(nth 4 (nth (atoi itm) LstPart)))
						(SetTile (strcat "Profile"	 (LM:rtos Prog 2 0))	(nth 5 (nth (atoi itm) LstPart)))
						(SetTile (strcat "Material"	 (LM:rtos Prog 2 0))	(nth 6 (nth (atoi itm) LstPart)))
						(setq Prog (1+ Prog))
					)
					
					(action_tile "accept"  "(if (setq Rtn (GetData LstNth)) (progn (setq *ModifiedPart* (done_dialog)) (unload_dialog xx)))")
					(action_tile "cancel"  "(setq *ModifiedPart* (done_dialog)) (unload_dialog xx)")
					(start_dialog)
					
					(vl-file-delete StreamDcl)
					
					(if Rtn 
						(UpdateTablePart LstPart LstNth Rtn)
						LstPart
					)
				)
			)
		)
	)
	;
	;
	(defun ModifiedBar (LstBar LstNth / GetData UpdateTableBar MakeDialog xx Rtn Prog StreamDcl)
	
		;
		(defun GetData (LstNth / Prog SPrg Chk _Length Profile Material Rtn)
			
			(setq Chk T)
			(setq Prog 1)
			
			(repeat (length LstNth)
				(setq SPrg (LM:rtos Prog 2 0))
				(if (IsEmptyBox (strcat "Length" SPrg))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica barra ] Lunghezza non dichiarata" (+ 0 16 4096)))
					(if (IsOnlyNumberBox (strcat "Length" SPrg))
						(setq _Length (GetTextBox (strcat "Length" SPrg)))
						(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica barra ] Lunghezza deve essere un numero" (+ 0 16 4096)))
					)
				)
				(if (IsEmptyBox (strcat "Profile" SPrg))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica barra ] Profilo non dichiarato" (+ 0 16 4096)))
					(setq Profile (GetTextBox (strcat "Profile" SPrg)))
				)
				(if (IsEmptyBox (strcat "Material" SPrg))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica barra ] Materiale non dichiarato" (+ 0 16 4096)))
					(setq Material (GetTextBox (strcat "Material" SPrg)))
				)
				(setq Rtn (append Rtn (list (list _Length Profile Material))))
				(setq Prog (1+ Prog))
			)
			(if Chk
				Rtn
				nil
			)
		)
		;
		(defun UpdateTableBar (LstBar LstNth LstValue / itm Prog)
		
			(setq Prog 0)
			(if (and LstBar LstNth LstValue)
				(foreach itm LstNth
					(setq LstBar (LM:SubstNth (nth Prog LstValue) (atoi itm) LstBar))
					(setq Prog (1+ Prog))
				)
			)
			LstBar
		)
		;
		(defun MakeDialog (LstNth / dcl des Prog)
			(if LstNth
				(progn
					(setq dcl (vl-filename-mktemp nil nil ".dcl"))
					(setq des (open dcl "w"))
					(write-line (strcat "ModifiedBar" (LM:rtos (length LstNth) 2 0) ":dialog") 			des)
					(write-line 		"	{" 																des)
					(write-line 		"	label=\"Modifica barre\";" 										des)
					(write-line 		"	:row {" 														des)
					(write-line 		"		fixed_width=true;" 											des) 
					(write-line 		"		width=41;" 													des)
					(write-line 		"		:text_part {width=10; fixed_width=true; label=\"Lung.\";}" 	des)
					(write-line 		"		:text_part {width=10; fixed_width=true; label=\"Prof.\";}" 	des)
					(write-line 		"		:text_part {width=10; fixed_width=true; label=\"Mat.\" ;}" 	des)
					(write-line 		"	}" 																des)

					(setq Prog 1)
					(repeat (length LstNth)
						(write-line ":row {" des)
						(write-line (strcat ":edit_box {key=\"Length" 	(LM:rtos Prog 2 0) 	"\" ; 	edit_width=10;}") des)
						(write-line (strcat ":edit_box {key=\"Profile" 	(LM:rtos Prog 2 0) 	"\" ; 	edit_width=10;}") des)
						(write-line (strcat ":edit_box {key=\"Material" (LM:rtos Prog 2 0) 	"\" ; 	edit_width=10;}") des)
						(write-line "}" des)
						(setq Prog (1+ Prog))
					)
					(write-line 		"	ok_cancel;" 													des)
					(write-line 		"}" 																des)
					(setq des (close des))
					;(EasyCutViewer Dcl)
					dcl
				)
			)
		)
		;
		; Main
		;
		(if (and LstBar LstNth)
			(if (numberp (read (car LstNth)))
				(progn
					(setq StreamDcl (MakeDialog LstNth))
					(setq xx (load_dialog StreamDcl))
					(new_dialog (strcat "ModifiedBar" (LM:rtos (length LstNth) 2 0)) xx "" (cond ( *ModifiedBar* ) ( '(-1 -1) )))

					(setq Prog 1)
					(foreach itm LstNth
						(SetTile (strcat "Length"	 (LM:rtos Prog 2 0))	(nth 0 (nth (atoi itm) LstBar)))
						(SetTile (strcat "Profile"	 (LM:rtos Prog 2 0))	(nth 1 (nth (atoi itm) LstBar)))
						(SetTile (strcat "Material"	 (LM:rtos Prog 2 0))	(nth 2 (nth (atoi itm) LstBar)))
						(setq Prog (1+ Prog))
					)
					
					(action_tile "accept"  "(if (setq Rtn (GetData LstNth)) (progn (setq *ModifiedBar* (done_dialog)) (unload_dialog xx)))")
					(action_tile "cancel"  "(setq *ModifiedBar* (done_dialog)) (unload_dialog xx)")
					(start_dialog)
					
					(vl-file-delete StreamDcl)
					
					(if Rtn 
						(UpdateTableBar LstBar LstNth Rtn)
						LstBar
					)
				)
			)
		)
	)
	;
	;
	(defun AddPart (LstPart / GetData UpdateTablePart)
	
		(defun GetData (/ Chk Order Phase Mark Qtantity _Length Profile Material)
		
			(setq Chk T)
			(if (IsEmptyBox "OrderPart")
				(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Commessa non dichiarata" (+ 0 16 4096)))
				(setq Order (GetTextBox "OrderPart"))
			)
			(if (IsEmptyBox "PhasePart")
				(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Fase non dichiarata" (+ 0 16 4096)))
				(setq Phase (GetTextBox "PhasePart"))
			)
			(if (IsEmptyBox "MarkPart")
				(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Marca non dichiarata" (+ 0 16 4096)))
				(setq Mark (GetTextBox "MarkPart"))
			)
			(if (IsEmptyBox "QtyPart")
				(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Quantita' non dichiarata" (+ 0 16 4096)))
				(if (IsOnlyNumberBox "QtyPart")
					(setq Quantity (GetTextBox "QtyPart"))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Quantita' deve essere un numero" (+ 0 16 4096)))
				)
			)
			(if (IsEmptyBox "LgPart")
				(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Lunghezza non dichiarata" (+ 0 16 4096)))
				(if (IsOnlyNumberBox "LgPart")
					(setq _Length (GetTextBox "LgPart"))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Lunghezza deve essere un numero" (+ 0 16 4096)))
				)
			)
			(if (IsEmptyBox "ProPart")
				(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Profilo non dichiarato" (+ 0 16 4096)))
				(setq Profile (GetTextBox "ProPart"))
			)
			(if (IsEmptyBox "MatPart")
				(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Materiale non dichiarato" (+ 0 16 4096)))
				(setq Material (GetTextBox "MatPart"))
			)
			(if Chk	(list Order Phase Mark Quantity _Length Profile Material))
		)
		;
		(defun UpdateTablePart (LstPart LstAdd / itm LstCtrl)
			(if LstAdd
				(progn
					(foreach itm LstPart
						(setq LstCtrl (append LstCtrl (list (strcat (strcase (nth 0 itm)) (strcase (nth 1 itm)) (strcase (nth 2 itm))))))
					)
					(if (not (member (strcat (strcase (nth 0 LstAdd)) (strcase (nth 1 LstAdd)) (strcase (nth 2 LstAdd))) LstCtrl))
						(append LstPart (list LstAdd))
						(progn
							(LM:popup "Errore" "[ Aggiungi parte ] profilo gia' presnte" (+ 0 16 4096))
							nil
						)
					)
				)
			)
		)
		;
		; Main
		;
		(UpdateTablePart LstPart (GetData))
	)
	;
	;
	(defun AddBar (LstBar / GetData UpdateTableBar)
	
		(defun GetData (/ Chk _Length Profile Material)
		
			(setq Chk T)
			(if (IsEmptyBox "LgBar")
				(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica barra ] Lunghezza non dichiarata" (+ 0 16 4096)))
				(if (IsOnlyNumberBox "LgBar")
					(setq _Length (GetTextBox "LgBar"))
					(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica barra ] Lunghezza deve essere un numero" (+ 0 16 4096)))
				)
			)
			(if (IsEmptyBox "ProBar")
				(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica barra ] Profilo non dichiarato" (+ 0 16 4096)))
				(setq Profile (GetTextBox "ProBar"))
			)
			(if (IsEmptyBox "MatBar")
				(progn (setq Chk nil) (LM:popup "Errore" "[ Modifica parte ] Materiale non dichiarato" (+ 0 16 4096)))
				(setq Material (GetTextBox "MatBar"))
			)
			(if Chk	(list _Length Profile Material))
		)
		;
		(defun UpdateTableBar (LstBar LstAdd / itm LstCtrl)
			(if LstAdd
				(progn
					(foreach itm LstBar
						(setq LstCtrl (append LstCtrl (list (strcat (strcase (nth 0 itm)) (strcase (nth 1 itm)) (strcase (nth 2 itm))))))
					)
					(if (not (member (strcat (strcase (nth 0 LstAdd)) (strcase (nth 1 LstAdd)) (strcase (nth 2 LstAdd))) LstCtrl))
						(append LstBar (list LstAdd))
						(progn
							(LM:popup "Errore" "[ Aggiungi barra ] lunghezza gia' presnte" (+ 0 16 4096))
							nil
						)
					)
				)
			)
		)
		;
		; Main
		;
		(UpdateTableBar LstBar (GetData))
	)
	;
	;
	(defun SelectFile (Path FileName Ext Registry CheckWrite / CheckFileWrite
															   FormatFileName
															   FileName)
															 
			(defun CheckFileWrite (FileName / Wf)
				(if FileName
					(if (setq Wf (open FileName "w"))
						(progn
							(close Wf)
							(vl-file-delete FileName)
							T
						)
						nil
					)
				)
			)
			;
			; Main
			;
			(if (setq FileName (OpenFileDialog  (list Path FileName Ext "PathNesting" nil T)))
				(progn
					(setq FileName (strcat (nth 0 FileName) "\\" (nth 1 FileName)))
					(if CheckWrite
						(if (CheckFileWrite FileName)
							(progn
								(if Registry (vl-registry-write EasyCutRegistryPath$ Registry (vl-filename-directory  FileName)))
								FileName
							)
							-1
						)
						(progn
							(if Registry (vl-registry-write EasyCutRegistryPath$ Registry (vl-filename-directory  FileName)))
							FileName
						)
					)
				)
				-2
			)
	)	
	;
	;
	(defun GetCodeJob (LstBar LstPart LstVar / itm StrBar StrPart StrVar Pos)
	
		(if (and LstBar LstPart LstVar)
			(progn
				(setq StrBar "")
				(foreach itm (SortTable LstBar '(0 0 -1 0 0 0 0) "<")
					(setq StrBar (strcat StrBar (vl-prin1-to-string itm)))
				)
				(setq StrPart "")
				(foreach itm (SortTable LstPart '(-1 0 0) "<")
					(setq StrPart (strcat StrPart (vl-prin1-to-string itm)))
				)
				(setq StrVar "")
				(setq Pos 0)
				(foreach itm LstVar
					(cond 
						((= Pos 0)	(setq StrVar (strcat StrVar (LM:rtos itm 2 2))))
						((= Pos 1)	(setq StrVar (strcat StrVar (LM:rtos itm 2 2))))
						((= Pos 2)	(setq StrVar (strcat StrVar (LM:rtos itm 2 2))))
						((= Pos 3)	(setq StrVar (strcat StrVar (LM:rtos itm 2 0))))
					)
					(setq Pos (1+ Pos))
				)
				(strcase (vl-list->string (LM:MD5 (vl-string->list (strcat StrBar StrPart StrVar)))))
			)
		)
	)
	;
	;
	(defun SaveJob (LstBar LstPart LstVar GraphicData FileOut / BarMargStart BarMargEnd TkCutBar Stream itm)
	
		;	JobId="2022_07_03-09.57.42"
		;	JobName="NestingBar"
		;	JobCode=B170E8512ECCF5A78CCFE769D6990A1C
		;	Mgstbar="10.00"
		;	Mgennbar="15.00"
		;	Cuttk="0.00"
		;	Perform="1"
		;	Bar=("1000.00" "L80*8" "MMM")
		;	Bar=("1500.00" "L80*8" "MMM")
		;	Bar=("2000.00" "L80*8" "MMM")
		;	Part=("C125" "1" "mk3000" "2" "1000.00" "L80*8" "MMM")
		;	Part=("C125" "2" "mk3001" "4" "1500.00" "L80*8" "MMM")
		;	Part=("C125" "3" "mk3002" "3" "2000.00" "L80*8" "MMM")
		;	GraphicData=("2022_07_03-09.57.40" nil nil "1000.0000" "10.0000" "15.0000" ("2022_07_03-09.57.40" ("1000.0000" "1500.0000" "2000.0000") ("2" "4" "3") ("C125|1|mk3000" "C125|2|mk3001" "C125|3|mk3002") "1000.0000") "8.8889")
		;	GraphicData=("2022_07_03-09.57.40" ("Adl-Cut" (("2" ("1000.0000") "475.0000")) "0") (("1000.0000" "C125|1|mk3000" "1000.0000")) "1500.0000" "10.0000" "15.0000" ("2022_07_03-09.57.40" ("1500.0000" "2000.0000") ("4" "3") ("C125|2|mk3001" "C125|3|mk3002") "1500.0000") "8.8889")
		;	GraphicData=("2022_07_03-09.57.40" ("Adl-Cut" (("4" ("1499.9999") "475.0001") ("2" ("1000.0000") "975.0000")) "0") (("1000.0000" "C125|1|mk3000" "1000.0000") ("1499.9999" "C125|2|mk3001" "1500.0000")) "2000.0000" "10.0000" "15.0000" ("2022_07_03-09.57.40" ("2000.0000") ("3") ("C125|3|mk3002") "2000.0000") "8.8889")" />
		
		;
		; Main
		;
		(setq BarMargStart 	(nth 0 LstVar))
		(setq BarMargEnd 	(nth 1 LstVar))
		(setq TkCutBar    	(nth 2 LstVar))
		(setq Perform    	(nth 3 LstVar))
		
		(if (and LstBar LstPart LstVar GraphicData FileOut)
			(progn
				(setq Stream (open FileOut "w"))
				(if Stream 
					(progn
						(write-line (strcat "JobId=" (CurDate nil))  Stream)
						(write-line "JobName=NestingBar"   			Stream)
						(write-line (strcat "JobCode=" 				(strcase (GetCodeJob LstBar LstPart LstVar)) )  Stream)
						(write-line (strcat "BarMargStart=" 		(LM:rtos BarMargStart  2 2) )  Stream)
						(write-line (strcat "BarMargEnd="   		(LM:rtos BarMargEnd    2 2) )  Stream)
						(write-line (strcat "TkCutBar="     		(LM:rtos TkCutBar      2 2) )  Stream)
						(write-line (strcat "Perform="     			(LM:rtos Perform       2 0) )  Stream)
						(foreach itm LstBar
							(write-line (strcat "Bar=" (vl-prin1-to-string itm)) Stream)
						)
						(foreach itm LstPart
							(write-line (strcat "Part=" (vl-prin1-to-string itm)) Stream)
						)
						(foreach itm GraphicData
							(write-line (strcat "GraphicData=" (vl-prin1-to-string itm)) Stream)
						)
						(close Stream)
					)
				)
			)
		)
	)
	;
	;
	(defun ReadJobBar (FileImport / GetBlock 
									Stream LineRead LstData JobId JobName JobCode BarMargStart BarMargEnd TkCutBar Perform LstBar LstPart LstGraph Rtn)
	
		(defun GetBlock (LineRead / LstBlock Split)
			(setq LstBlock '("JobId" "JobName" "JobCode" "BarMargStart" "BarMargEnd" "TkCutBar" "Perform" "Bar" "Part" "GraphicData"))
			(if LineRead
				(if (/= LineRead "")
					(progn
						(setq Split (splitxt LineRead "="))
						(if (member (vl-string-right-trim " \t" (vl-string-left-trim " \t" (car Split))) LstBlock)
							(list (vl-string-right-trim " \t" (vl-string-left-trim " \t" (car Split)))
								  (vl-string-right-trim " \t" (vl-string-left-trim " \t" (cadr Split)))
							)
						)
					)
				)
			)
		)
		;
		; Main
		;
		(if FileImport
			(progn
				(setq Stream (open FileImport "r"))
				(if Stream
					(progn
						(setq LineRead (read-line Stream))
						(while LineRead
							(setq LineRead (vl-string-right-trim " \t" (vl-string-left-trim " \t" LineRead)))
							(if (setq LstData (GetBlock LineRead))
								(cond
									((= (car LstData) "JobId")
										(setq JobId (cons "JobId" (read (cadr LstData))))
									)
									((= (car LstData) "JobName")
										(setq JobName (cons "JobName" (read (cadr LstData))))
									)
									((= (car LstData) "JobCode")
										(setq JobCode (cons "JobCode" (cadr LstData)))
									)
									((= (car LstData) "BarMargStart")
										(setq BarMargStart (cons "BarMargStart" (read (cadr LstData))))
									)
									((= (car LstData) "BarMargEnd")
										(setq BarMargEnd (cons "BarMargEnd" (read (cadr LstData))))
									)
									((= (car LstData) "TkCutBar")
										(setq TkCutBar (cons "TkCutBar" (read (cadr LstData))))
									)
									((= (car LstData) "Perform")
										(setq Perform (cons "Perform" (read (cadr LstData))))
									)
									((= (car LstData) "Part")
										(if LstPart 
											(setq LstPart (append LstPart (list (read (cadr LstData)))))
											(setq LstPart (cons "LstPart" (list (read (cadr LstData)))))
										)
									)
									((= (car LstData) "Bar")
										(if LstBar 
											(setq LstBar (append LstBar (list (read (cadr LstData)))))
											(setq LstBar (cons "LstBar" (list (read (cadr LstData)))))
										)
										
									)
									((= (car LstData) "GraphicData")
										(if LstGraph
											(setq LstGraph (append LstGraph (list (read (cadr LstData)))))
											(setq LstGraph (cons "GraphicData" (list (read (cadr LstData)))))
										)
									)
									(t 
										nil
									)
								)
							)
							(setq LineRead (read-line Stream))
						)
						(close Stream)
						(setq Rtn (list JobId JobName JobCode BarMargStart BarMargEnd TkCutBar Perform LstBar LstPart LstGraph))
					)
				)
			)
		)
		Rtn
	)
	;
	;
	(defun ImportJob (FileName / FileName Rtn)
		;
		;("JobId" "JobName" "JobCode" "JobCode" "BarMargStart" "BarMargEnd" "TkCutBar" "Perform" "Bar" "Part" "GraphicData"))
		;
		
		(if FileName
			(if (not (findfile FileName))
				(setq FileName (SelectFile (vl-registry-read EasyCutRegistryPath$ "PathNesting") nil "*.bar" "PathNesting" nil))
			)
			(setq FileName (SelectFile (vl-registry-read EasyCutRegistryPath$ "PathNesting") nil "*.bar" "PathNesting"  nil))
		)
		
		(if (setq Rtn (ReadJobBar fileName))
			(progn
				(setq JobFile$		FileName)
				(setq JobId$  		(cdr (assoc "JobId"  		Rtn)))
				(setq JobName$  	(cdr (assoc "JobName"  		Rtn)))
				(setq JobCode$  	(cdr (assoc "JobCode"  		Rtn)))
				(setq $BarMargStart (cdr (assoc "BarMargStart"  Rtn)))
				(setq $BarMargEnd 	(cdr (assoc "BarMargEnd" 	Rtn)))
				(setq $TkCutBar    	(cdr (assoc "TkCutBar"    	Rtn)))
				(setq $Perform    	(cdr (assoc "Perform"    	Rtn)))
				(setq $LstPart  	(cdr (assoc "LstPart"  		Rtn)))
				(setq $LstBar   	(cdr (assoc "LstBar"  		Rtn)))
				(setq $GraphicData  (cdr (assoc "GraphicData"  	Rtn)))
			)
		)
	)
	;
	;
	(defun ImportFileBar (/ FileName)
		(if (setq FileName (SelectFile (vl-registry-read EasyCutRegistryPath$ "PathNesting") nil "*.csv|*.xls|*.xlsx" "PathNesting" nil))
			(GuiImportBars FileName)
		)
	)
	;
	;
	(defun ImportFilePart (/ FileName)
		(if (setq FileName (SelectFile (vl-registry-read EasyCutRegistryPath$ "PathNesting") nil "*.csv|*.xls|*.xlsx" "PathNesting" nil))
			(GuiImportParts FileName)
		)
	)
	;
	;
	(defun NestingBar (/ Job LstLengthPart LstQtaPart LstIdPart LstLengthBar LstProBar 
						 LstVar itm JobCode Order Phase Mark Pro FileOut PointInsert)
		;
		;
		(setq Job (CurDate nil))
		(foreach itm $LstPart
			(setq LstLengthPart (append LstLengthPart (list (atof (nth 4 itm)))))
		)
		(foreach itm $LstPart
			(setq LstQtaPart (append LstqtaPart (list (atoi (nth 3 itm)))))
		)
		(foreach itm $LstPart
			(if (= (vl-string-right-trim  " \t" (vl-string-left-trim " \t" (nth 0 itm))) "")
				(setq Order "-")
				(setq Order (vl-list->string (vl-remove-if '(lambda (u) (member u '(32 9)))
										(vl-string->list (nth 0 itm)))))
			)
			(if (= (vl-string-right-trim  " \t" (vl-string-left-trim " \t" (nth 1 itm))) "")
				(setq Phase "-")
				(setq Phase (vl-list->string (vl-remove-if '(lambda (u) (member u '(32 9)))
										(vl-string->list (nth 1 itm)))))
			)
			(if (= (vl-string-right-trim  " \t" (vl-string-left-trim " \t" (nth 2 itm))) "")
				(setq Mark "-")
				(setq Mark  (vl-list->string (vl-remove-if '(lambda (u) (member u '(32 9)))
										(vl-string->list (nth 2 itm)))))
			)
			(if (= (vl-string-right-trim  " \t" (vl-string-left-trim " \t" (nth 5 itm))) "")
				(setq Pro "-")
				(setq Pro  (vl-list->string (vl-remove-if '(lambda (u) (member u '(32 9)))
										(vl-string->list (nth 5 itm)))))
			)
			;(setq LstIdPart (append LstIdPart (list (strcat $RappPart " " Order " " Phase " " Mark " " Mat))))
			(setq LstIdPart (append LstIdPart (list (strcat Order " " Phase " " Mark " " Pro))))

		)
		(if (= $AutoAccuracyNestingBar "1")
			(setq LstVar (list 	$BarMargStart $BarMargEnd $TkCutBar -1 ))
			(setq LstVar (list 	$BarMargStart $BarMargEnd $TkCutBar $Perform))
		)
		(foreach itm $LstBar
			(setq LstLengthBar (append LstLengthBar (list (list (atof (nth 0 itm)) (nth 1 itm)))))
		)
		(setq JobCode (GetCodeJob $LstBar $LstPart LstVar))
		
		
		(if (not (equal JobCode JobCode$))
			(progn
				(setq FileOut (SelectFile (vl-registry-read EasyCutRegistryPath$ "PathNesting") (strcat "Bar_" Job ".bar") "*.bar" "PathNesting" T))
				;(setq FileOut (SelectFile "c:\\Users\\Utente\\Desktop\\" (strcat "Bar_" Job ".bar") "*.bar" "PathNesting" T))
				
				(cond 
					((= (type FileOut) 'STR)
						(setq $GraphicData (ResolutionNestingBar (list (list Job LstLengthPart LstQtaPart LstIdPart LstVar LstLengthBar))))
						(SaveJob $LstBar $LstPart LstVar $GraphicData FileOut)
						(ImportJob FileOut)
						(setq PointInsert (getpoint "\nPunto di inserimento"))
					)
					((= FileOut -1)
						(LM:popup "Avvertimento" "Il file non puo essere salvato in questa posizione" (+ 0 48 4096))
					)
					((= FileOut -2)
						(LM:popup "Errore" "Exit" (+ 0 48 4096))
					)
				)
			)
			(setq PointInsert (getpoint "\nPunto di inserimento"))
		)

		(GraphicNestingBar $GraphicData PointInsert)
	)
	;
	;
	(defun CheckDataNestingBar (/ Rtn)
	
		(setq Rtn T)
		(if  (= (GetTextBox "BarMargStart") "")
			(progn
				(LM:popup "Errore" "[ CheckDataNestingBar ] Margine iniziale barra non dichiarato" (+ 0 16 4096))
				(setq Rtn nil)
			)
			(setq $BarMargStart (atof (GetTextBox "BarMargStart")))
		)
		(if  (= (GetTextBox "BarMargEnd") "")
			(progn
				(LM:popup "Errore" "[ CheckDataNestingBar ] Margine finale barra non dichiarato" (+ 0 16 4096))
				(setq Rtn nil)
			)
			(setq $BarMargEnd (atof (GetTextBox "BarMargEnd")))
		)
		(if  (= (GetTextBox "TkCutBar") "")
			(progn
				(LM:popup "Errore" "[ CheckDataNestingBar ] Spessore taglio parte non dichiarato" (+ 0 16 4096))
				(setq Rtn nil)
			)
			(setq $TkCutBar (atof (GetTextBox "TkCutBar")))
		)
		(if (not $LstBar)
			(progn
				(LM:popup "Errore" "[ CheckDataNestingBar ] Lista barre non dichiarata" (+ 0 16 4096))
				(setq Rtn nil)
			)
		)
		(if (not $LstPart)
			(progn
				(LM:popup "Errore" "[ CheckDataNestingBar ] Lista parti non dichiarata" (+ 0 16 4096))
				(setq Rtn nil)
			)
		)
		(setq $RappPart (get_tile "RapPart"))
		Rtn
	)
	;
	;
	(defun LoadExamplePart (/ Path FileName Rtn)
		(setq Path 	(vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
		(if (findfile (strcat Path "\\Example\\NestingBar\\ExamplePart.xls"))
			(if (setq FileName (SelectFile (strcat Path "\\Example\\NestingBar") "ExamplePart.xls" "*.csv|*.xls|*.xlsx" nil nil))
				(if (setq Rtn (GuiImportParts FileName))
					(progn 
						(setq $LstPart Rtn) 
						(LoadTable (FormatTableNesting $LstPart) "BoxPart" nil)
					)
				)
			)
			(LM:popup "Avvertimento" (strcat "Il file "
											(strcat Path "\\Example\\NestingBar\\ExamplePart.xls")
											"\n non e' stato trovato") 
									 (+ 1 48 4096)
			)
		)

		;(setq $LstPart 	'(("C125" "Ph1"  "Mk01" "2"  "2350" "L80*8" "S355J0") 
		;				  ("C125" "Ph2"  "Mk02" "4"  "2250" "L80*8" "S355J0") 
		;				  ("C125" "Ph3"  "Mk03" "4"  "2200" "L80*8" "S355J0") 
		;				  ("C126" "Ph4"  "Mk04" "15" "2100" "L80*8" "S355J0") 
		;				  ("C127" "Ph5"  "Mk05" "6"  "2050" "L80*8" "S355J0") 
		;				  ("C128" "Ph6"  "Mk06" "11" "2000" "L80*8" "S355J0") 
		;				  ("C129" "Ph7"  "Mk07" "6"  "1950" "L80*8" "S355J0") 
		;				  ("C130" "Ph8"  "Mk08" "15" "1900" "L80*8" "S355J0") 
		;				  ("C131" "Ph9"  "Mk09" "13" "1850" "L80*8" "S355J0") 
		;				  ("C132" "Ph10" "Mk10" "5"  "1700" "L80*8" "S355J0") 
		;				  ("C133" "Ph11" "Mk11" "2"  "1650" "L80*8" "S355J0") 
		;				  ("C134" "Ph12" "Mk12" "9"  "1350" "L80*8" "S355J0") 
		;				  ("C135" "Ph13" "Mk13" "3"  "1300" "L80*8" "S355J0") 
		;				  ("C136" "Ph14" "Mk14" "6"  "1250" "L80*8" "S355J0") 
		;				  ("C137" "Ph15" "Mk15" "10" "1200" "L80*8" "S355J0") 
		;				  ("C138" "Ph16" "Mk16" "4"  "1150" "L80*8" "S355J0") 
		;				  ("C139" "Ph17" "Mk17" "8"  "1100" "L80*8" "S355J0") 
		;				  ("C140" "Ph18" "Mk18" "3"  "1050" "L80*8" "S355J0"))		
		;)
		;(LoadTable (FormatTableNesting $LstPart) "BoxPart" nil)
	)
	;
	;
	(defun LoadExampleBar (/ Path FileName Rtn)
		(setq Path 	(vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
		(if (findfile (strcat Path "\\Example\\NestingBar\\ExampleBar.xls"))
			(if (setq FileName (SelectFile (strcat Path "\\Example\\NestingBar") "ExampleBar.xls" "*.csv|*.xls|*.xlsx" nil nil))
				(if (setq Rtn (GuiImportBars FileName))
					(progn 
						(setq $LstBar  Rtn) 
						(LoadTable (FormatTableNesting $LstBar) "BoxBar" nil)
					)
				)
			)
			(LM:popup "Avvertimento" (strcat "Il file "
											(strcat Path "\\Example\\NestingBar\\ExampleBar.xls")
											"\n non e' stato trovato") 
									 (+ 1 48 4096)
			)
		)
		
		;(setq $LstBar 	'(("6000" "L80*8"  "S355J0") 
		;				  ("7000" "L80*8" "S355J0"))
		;)
		;(LoadTable (FormatTableNesting $LstBar) "BoxBar" nil)
	)
	;
	;
	(defun AccuracyResultNestingBar (Var1 Var2 Var3)

		;
		; Var1 AutoAccuracyNestingBar    (Toggle)
		; Var2 AccuracyValueNestingBar   (EditBox)
		; Var3 AccuracySliderNestingBar  (Slider)
		;
		(cond
			(Var1
				(if (= (get_tile "AutoAccuracyNestingBar") "0")
					(progn
						(mode_tile "AccuracyValueNestingBar"  0)
						(mode_tile "AccuracySliderNestingBar" 0)
					)
					(progn
						(mode_tile "AccuracyValueNestingBar"  1)
						(mode_tile "AccuracySliderNestingBar" 1)
					)
				)
				(setq $AutoAccuracyNestingBar (get_tile "AutoAccuracyNestingBar"))
			)
			(Var2
				(setq $AccuracyValueNestingBar (get_tile "AccuracyValueNestingBar"))
				(SetTile "AccuracySliderNestingBar" $AccuracyValueNestingBar)
				(setq $AccuracySliderNestingBar $AccuracyValueNestingBar) 
			)
			(Var3
				(setq $AccuracySliderNestingBar (get_tile "AccuracySliderNestingBar"))
				(SetTile "AccuracyValueNestingBar" $AccuracySliderNestingBar)
				(setq $AccuracyValueNestingBar  $AccuracySliderNestingBar)
			)
		)
		(cond 
			((and (>= (atoi $AccuracyValueNestingBar) 1)  (< (atoi $AccuracyValueNestingBar) 33))
				(setq $Perform 1) ; Lower Performance
			)
			((and (>= (atoi $AccuracyValueNestingBar) 33) (< (atoi $AccuracyValueNestingBar) 66))
				(setq $Perform 2) ; Medium Performance
			)
			((and (>= (atoi $AccuracyValueNestingBar) 66) (<= (atoi $AccuracyValueNestingBar) 100))
				(setq $Perform 3) ; High Performance
			)
		)
	)
	;
	;Main
	;
	(setq LstButtonPKey 		'("Btnp0" "Btnp1" "Btnp2" "Btnp3" "Btnp4" "Btnp5" "Btnp6" "Btnp7"))
	(setq LstButtonBKey 		'("Btnb0" "Btnb1" "Btnb2" "Btnb3"))
	(setq LstSortP$ 			'(0 0 0 0 0 0 0 0))
	(setq LstSortB$ 			'(0 0 0 0))

	(setq xx (load_dialog (strcat GuiPathEasyCut$ "PartsAndBars.dcl")))
	(new_dialog "InfoTableNestingBar" xx "" (cond ( *InfoTableNestingBar* ) ( '(-1 -1) )))
		
		(LoadTable (FormatTableNesting $LstPart) "BoxPart" nil)
		(LoadTable (FormatTableNesting $LstBar)  "BoxBar"  nil)
			
		(MakeButtons LstButtonPKey LstSortP$)
		(MakeButtons LstButtonBKey LstSortB$)
		(SetTile "TkCutBar" 	  (LM:rtos $TkCutBar		2 2))
		(SetTile "BarMargStart"   (LM:rtos $BarMargStart	2 2))
		(SetTile "BarMargEnd" 	  (LM:rtos $BarMargEnd		2 2))
		(SetTile "JobFle" 	       JobFile$)

		(if (not $AutoAccuracyNestingBar)    (setq $AutoAccuracyNestingBar "1"))
		(if (not $AccuracyValueNestingBar)   (setq $AccuracyValueNestingBar "50"))
		(SetTile "AutoAccuracyNestingBar"    $AutoAccuracyNestingBar )
		(SetTile "AccuracyValueNestingBar"   $AccuracyValueNestingBar)
		(SetTile "AccuracySliderNestingBar"  $AccuracyValueNestingBar)
		(AccuracyResultNestingBar T nil nil)


		(start_list "RapPart")
		;					   0         1                2                   3            	       4	        5
		(mapcar 'add_list '("Marca" "Fase  Marca" "Commessa  Marca" "Commessa  Fase  Marca" "Marca Profilo"	"Nessuna"))
		(end_list)

		(if (not $RappPart) (setq $RappPart "0"))
		(SetTile "RapPart" $RappPart)

		(action_tile "LoadPart"	 	"(if (setq Rtn (ImportFilePart)) (progn (setq $LstPart Rtn) (LoadTable (FormatTableNesting $LstPart) \"BoxPart\" nil)))")
		(action_tile "LoadBar"	 	"(if (setq Rtn (ImportFileBar))  (progn (setq $LstBar  Rtn) (LoadTable (FormatTableNesting $LstBar) \"BoxBar\" nil)))")
		
		(action_tile "Btnp1"  		"(SortBox $LstPart \"Btnp1\" LstButtonPKey LstSortP$ \"Part\")")
		(action_tile "Btnp2"  		"(SortBox $LstPart \"Btnp2\" LstButtonPKey LstSortP$ \"Part\")")
		(action_tile "Btnp3"  		"(SortBox $LstPart \"Btnp3\" LstButtonPKey LstSortP$ \"Part\")")
		(action_tile "Btnp4"  		"(SortBox $LstPart \"Btnp4\" LstButtonPKey LstSortP$ \"Part\")")
		(action_tile "Btnp5"  		"(SortBox $LstPart \"Btnp5\" LstButtonPKey LstSortP$ \"Part\")")
		(action_tile "Btnp6"  		"(SortBox $LstPart \"Btnp6\" LstButtonPKey LstSortP$ \"Part\")")
		(action_tile "Btnp7"  		"(SortBox $LstPart \"Btnp7\" LstButtonPKey LstSortP$ \"Part\")")

		(action_tile "Btnb1"  		"(SortBox $LstBar \"Btnb1\" LstButtonBKey LstSortB$ \"Bar\")")
		(action_tile "Btnb2"  		"(SortBox $LstBar \"Btnb2\" LstButtonBKey LstSortB$ \"Bar\")")
		(action_tile "Btnb3"  		"(SortBox $LstBar \"Btnb3\" LstButtonBKey LstSortB$ \"Bar\")")

		(action_tile "BoxPart"    	"(if (= $reason 4)
										(progn
											(setq TmpLstPart $LstPart)
											(setq LstIdParts (list $value))
											(if (setq $LstPart (ModifiedPart $LstPart LstIdParts))
												(LoadTable (FormatTableNesting $LstPart) \"BoxPart\" nil)
												(setq $LstPart TmpLstPart)
											)
										)
										(setq LstIdParts (LM:str->lst (SelectItmBoxList \"BoxPart\") \" \"))
									)")
		(action_tile "ModifiedPart" "(if (setq Rtn (ModifiedPart $LstPart LstIdParts))
										(progn
											(LoadTable (FormatTableNesting Rtn) \"BoxPart\" nil)
											(setq $LstPart Rtn)
											(setq LstIdParts nil)
										)
									)")
		(action_tile "RemovePart"   "(if (/= (setq Rtn (RemovePart $LstPart LstIdParts)) -1)
										(progn
											(LoadTable (FormatTableNesting Rtn) \"BoxPart\" nil)
											(setq $LstPart Rtn)
											(setq LstIdParts nil)
										)
									)")
		(action_tile "AddPart"		"(if (setq Rtn (AddPart $LstPart))
										(progn
											(LoadTable (FormatTableNesting Rtn) \"BoxPart\" nil)
											(setq $LstPart Rtn)
										)
									)")
		(action_tile "ExamplePart"	"(LoadExamplePart)")
		; *********************************************************************************************
		(action_tile "BoxBar"    	"(if (= $reason 4)
										(progn
											(setq LstIdBars (list $value))
											(setq $LstBar (ModifiedBar $LstBar LstIdBars))
											(LoadTable (FormatTableNesting $LstBar) \"BoxBar\" nil)
										)
										(setq LstIdBars (LM:str->lst (SelectItmBoxList \"BoxBar\") \" \"))
									)")
		(action_tile "ModifiedBar" "(if (setq Rtn (ModifiedBar $LstBar LstIdBars))
										(progn
											(LoadTable (FormatTableNesting Rtn) \"BoxBar\" nil)
											(setq $LstBar Rtn)
											(setq LstIdBars nil)
										)
									)")
		(action_tile "RemoveBar"    "(if (/= (setq Rtn (RemoveBar $LstBar LstIdBars)) -1)
										(progn
											(LoadTable (FormatTableNesting Rtn) \"BoxBar\" nil)
											(setq $LstBar Rtn)
											(setq LstIdBars nil)
										)
									)")
		(action_tile "AddBar"		"(if (setq Rtn (AddBar $LstBar))
										(progn
											(LoadTable (FormatTableNesting Rtn) \"BoxBar\" nil)
											(setq $LstBar Rtn)
										)
									)")
		(action_tile "ExampleBar"	"(LoadExampleBar)")
		; *********************************************************************************************
		(action_tile "AutoAccuracyNestingBar"   "(AccuracyResultNestingBar T nil nil)")
		(action_tile "AccuracyValueNestingBar"  "(AccuracyResultNestingBar nil T nil)")
		(action_tile "AccuracySliderNestingBar" "(AccuracyResultNestingBar nil nil T)")
		; *********************************************************************************************
		(action_tile "ImportNesting"	"(ImportJob nil)		
										 (LoadTable (FormatTableNesting $LstPart) \"BoxPart\" nil)
										 (LoadTable (FormatTableNesting $LstBar)  \"BoxBar\"  nil)
										 (SetTile \"JobFle\" 	    JobFile$)
										 (SetTile \"TkCutBar\" 	    (LM:rtos $TkCutBar		2 2))
										 (SetTile \"BarMargStart\"  (LM:rtos $BarMargStart	2 2))
										 (SetTile \"BarMargEnd\" 	(LM:rtos $BarMargEnd	2 2))")
										 
										 
		(action_tile "NestingBar"		"(if (CheckDataNestingBar)
											(progn
												(setq GoNestingBar T)
												(setq *InfoTableNestingBar* (done_dialog)) (unload_dialog xx)
											)
										)")
		(action_tile "cancel"  		"(setq *InfoTableNestingBar* (done_dialog)) (unload_dialog xx)")
	
	(start_dialog)
		
	(if GoNestingBar
		(NestingBar)
	)
)
