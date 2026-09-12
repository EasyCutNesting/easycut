;
; Gui Import Shape From File
;
(defun ImportShapeXls (/ Rtn itm LstPtInsert Ssel MinMaxSsel MinCatch MaxCatch)
	
	(setq Rtn (GuiShapeXls))
	(if (= (type (cadr Rtn)) 'LIST)
		(progn
			(alert (strcat "n^ " (rtos (length (cadr Rtn)) 2 0) " piatti selezionati"))
			(setq LstPtInsert  (PreviewNestingImportXls (cadr Rtn)))
			(setq Ssel (NestingShapeImportXls (cadr Rtn) LstPtInsert))
			(if Ssel
				(progn
					(setq MinMaxSsel	(LM:SSBoundingBox Ssel))
					(setq MinCatch 		(list (- (nth 0 (nth 0 MinMaxSsel)) 100)
											  (- (nth 1 (nth 0 MinMaxSsel)) 100)
										)
					)
					(setq MaxCatch 		(list (+ (nth 0 (nth 2 MinMaxSsel)) 100)
											  (+ (nth 1 (nth 2 MinMaxSsel)) 100)
										)
					)			
					(vla-ZoomWindow (vlax-get-acad-object) (vlax-3d-point MinCatch) (vlax-3d-point MaxCatch))	
				)
			)
		)
	)
	(princ)
)
;
;
;
(defun GuiShapeXls (/ itm LstHead SaveCalcQtyDeduct Rtn)

	
	(foreach itm (GuiImportShapeXls)
		(setq LstHead (append LstHead (list (list	(Random_Str 9)					
													(nth 0  itm) 							;->  IdOrder
													(nth 1  itm) 							;->  IdPhase
													(nth 2  itm) 							;->  IdIdentification
													(rtos (atoi (nth 3  itm)) 2 0) 			;->  IdQuantity
													(nth 6  itm) 							;->  IdThicknes
													(nth 4  itm) 							;->  IdHeigth
													(nth 5  itm) 							;->  IdLength
													(strcase (nth 7  itm)) 					;->  IdQuality
													(today)
													"--"))))
	)
	(setq SaveCalcQtyDeduct CalcQtyDeduct$)
	(setq CalcQtyDeduct$ "-1")
	(if LstHead
		(setq Rtn (GuiSelPiecesShape LstHead (strcat InfoPathEasyCut$ "log.txt") 0))
	)
	(setq CalcQtyDeduct$ SaveCalcQtyDeduct)
	Rtn
)
;
;
;
(defun GuiImportShapeXls (/ GetFileImport PutGui GetGui PutGuiInfo GetSheetsXls OpenDemoShape
								 xx Loop FileImport ImportShape LstDataShepe
								 <LstSheet> <LstOrder> <LstPhase> <LstMark> <LstQuantity> <LstLength> <LstWidth> <LstThick> <LstMaterial>
								 <LstSeparator> <Separator> <LstColl> <LstCol2> <LstCol3> <LstCol4> <LstCol5> <LstCol6> <LstCol7> <LstCol8>
								 <LstColumnSeekXls> <LstColumnSeekCsv> <SheetBook> <LstNAXls> <LstNACsv>)


	(defun GetFileImport (/ Ext FileImport)
	
		(cond 
			((= TypeFileToImportShape$ "1")
				(setq Ext "*.xls|*.xlsx")
			)
			((= TypeFileToImportShape$ "2")
				(setq Ext "*.csv|*.*")
			)
		)
		;(setq FileImport (MyGetField (vl-registry-read EasyCutRegistryPath$ "PathSearch") nil Ext))
		;(setq FileImport (LM:getfiles "File da importare" (vl-registry-read EasyCutRegistryPath$ "PathSearch") Ext))
		(if (setq FileImport (OpenFileDialog  (list (vl-registry-read EasyCutRegistryPath$ "PathSearch") nil Ext "FileDialog"	nil	T)))
			(cond
				((= TypeFileToImportShape$ "1")
					(setq FileToImportShapeXls$ (strcat (car FileImport) "\\" (cadr FileImport)))
					(setq <LstSheet> (GetSheetsXls))
					(setq LastTimeFileToImportShapeXls$ (GetFileLastModified FileToImportShapeXls$))
					(vl-registry-write EasyCutRegistryPath$ "PathSearch" (vl-filename-directory  FileToImportShapeXls$))
				)
				((= TypeFileToImportShape$ "2")
					(setq FileToImportShapeCsv$ (strcat (car FileImport) "\\" (cadr FileImport)))
					(vl-registry-write EasyCutRegistryPath$ "PathSearch" (vl-filename-directory  FileToImportShapeCsv$))
				)
			)
		)
	)
	;
	;
	(defun PutGui (/ LastTime)

	
		;(alert (strcat "ingresso PutGui " ValSheetImportShape$))
		
		(if (and FileToImportShapeXls$ (findfile FileToImportShapeXls$)) 
			(progn
				(set_tile "FileSelectShapeXls" FileToImportShapeXls$)
				(setq LastTime (GetFileLastModified FileToImportShapeXls$))
				(if (> LastTime LastTimeFileToImportShapeXls$)
					(progn
						(setq LastTimeFileToImportShapeXls$ LastTime)
						(setq <LstSheet> (GetSheetsXls))
 					)
					(setq <LstSheet> LstSheet$)
				)
			)
		)
		(if FileToImportShapeCsv$ (set_tile "FileSelectShapeCsv" FileToImportShapeCsv$))


		(if (or (not ValSheetImportShape$) (= ValSheetImportShape$ ""))		(setq ValSheetImportShape$ "0"))
		(if (not ValOrderImportShape$)		(setq ValOrderImportShape$		"0"))
		(if (not ValPhaseImportShape$)		(setq ValPhaseImportShape$		"0"))
		(if (not ValMarkImportShape$)		(setq ValMarkImportShape$		"0"))
		(if (not ValQuantityImportShape$)	(setq ValQuantityImportShape$	"0"))
		(if (not ValLengthImportShape$)		(setq ValLengthImportShape$		"0"))
		(if (not ValWidthImportShape$)		(setq ValWidthImportShape$		"0"))
		(if (not ValThickImportShape$)		(setq ValThickImportShape$		"0"))
		(if (not ValMaterialImportShape$)	(setq ValMaterialImportShape$	"0"))
		(if (not ValSeparatorImportShape$)	(setq ValSeparatorImportShape$	"0"))
		(if (not ValCol1ImportShape$)		(setq ValCol1ImportShape$		"0"))
		(if (not ValCol2ImportShape$)		(setq ValCol2ImportShape$		"0"))
		(if (not ValCol3ImportShape$)		(setq ValCol3ImportShape$		"0"))
		(if (not ValCol4ImportShape$)		(setq ValCol4ImportShape$		"0"))
		(if (not ValCol5ImportShape$)		(setq ValCol5ImportShape$		"0"))
		(if (not ValCol6ImportShape$)		(setq ValCol6ImportShape$		"0"))
		(if (not ValCol7ImportShape$)		(setq ValCol7ImportShape$		"0"))
		(if (not ValCol8ImportShape$)		(setq ValCol8ImportShape$		"0"))
		
		;(cond 
		;	((= TypeFileToImportShape$ "1")
				
				;(setq <LstSheet> 	 (GetSheetsXls))
				
				(start_list "ListSheet")(mapcar 'add_list <LstSheet>) 	(end_list)
				(start_list "Order") 	(mapcar 'add_list <LstOrder>) 	(end_list)
				(start_list "Phase") 	(mapcar 'add_list <LstPhase>) 	(end_list)
				(start_list "Mark") 	(mapcar 'add_list <LstMark>) 	(end_list)
				(start_list "Quantity") (mapcar 'add_list <LstQuantity>)(end_list)
				(start_list "Length") 	(mapcar 'add_list <LstLength>) 	(end_list)
				(start_list "Width") 	(mapcar 'add_list <LstWidth>) 	(end_list)
				(start_list "Thick") 	(mapcar 'add_list <LstThick>) 	(end_list)
				(start_list "Material") (mapcar 'add_list <LstMaterial>)(end_list)
				
				(set_tile   "ListSheet" ValSheetImportShape$)
				(set_tile   "Order" 	ValOrderImportShape$)
				(set_tile   "Phase" 	ValPhaseImportShape$)
				(set_tile   "Mark"		ValMarkImportShape$)
				(set_tile   "Quantity" 	ValQuantityImportShape$)
				(set_tile   "Length" 	ValLengthImportShape$)
				(set_tile   "Width" 	ValWidthImportShape$)
				(set_tile   "Thick" 	ValThickImportShape$)
				(set_tile   "Material" 	ValMaterialImportShape$)

				(if (and ValOrderNAXls$ (/= ValOrderNAXls$ ""))	(set_tile "OrderNAXls" ValOrderNAXls$))
				(if (and ValPhaseNAXls$ (/= ValPhaseNAXls$ ""))	(set_tile "PhaseNAXls" ValPhaseNAXls$))
				(if (and ValMatNAXls$   (/= ValMatNAXls$   ""))	(set_tile "MatNAXls"   ValMatNAXls$))
				
		;	)
		
		;	((= TypeFileToImportShape$ "2")

				(start_list "Separator")(mapcar 'add_list <LstSeparator>) 	(end_list)
				(start_list "Col1") 	(mapcar 'add_list <LstColl>) 		(end_list)
				(start_list "Col2") 	(mapcar 'add_list <LstCol2>) 		(end_list)
				(start_list "Col3") 	(mapcar 'add_list <LstCol3>) 		(end_list)
				(start_list "Col4") 	(mapcar 'add_list <LstCol4>) 		(end_list)
				(start_list "Col5") 	(mapcar 'add_list <LstCol5>) 		(end_list)
				(start_list "Col6") 	(mapcar 'add_list <LstCol6>) 		(end_list)
				(start_list "Col7") 	(mapcar 'add_list <LstCol7>) 		(end_list)
				(start_list "Col8") 	(mapcar 'add_list <LstCol8>) 		(end_list)
				
				(set_tile   "Separator" ValSeparatorImportShape$)
				(set_tile   "Col1" 		ValCol1ImportShape$)
				(set_tile   "Col2" 		ValCol2ImportShape$)
				(set_tile   "Col3" 		ValCol3ImportShape$)
				(set_tile   "Col4" 		ValCol4ImportShape$)
				(set_tile   "Col5" 		ValCol5ImportShape$)
				(set_tile   "Col6" 		ValCol6ImportShape$)
				(set_tile   "Col7" 		ValCol7ImportShape$)
				(set_tile   "Col8" 		ValCol8ImportShape$)

				(if (and ValOrderNACsv$ (/= ValOrderNACsv$ ""))	(set_tile "OrderNACsv" ValOrderNACsv$))
				(if (and ValPhaseNACsv$ (/= ValPhaseNACsv$ ""))	(set_tile "PhaseNACsv" ValPhaseNACsv$))
				(if (and ValMatNACsv$   (/= ValMatNACsv$   ""))	(set_tile "MatNACsv"   ValMatNACsv$))
				
		;	)
		;)
		
		(cond 
			((= TypeFileToImportShape$ "1")
				(set_tile "TypeXls" 	"1")
				(set_tile "TypeCsv" 	"0")
				(mode_tile "XlsData"	0)
				(mode_tile "CsvData"	1)
			)
			((= TypeFileToImportShape$ "2")
				(set_tile "TypeCsv" 	"1")
				(set_tile "TypeXls" 	"0")
				(mode_tile "CsvData"	0)
				(mode_tile "XlsData"	1)
			)
		)
		;(mode_tile "FileSelectShapeXls" 1)
		;(mode_tile "FileSelectShapeCsv" 1)
		
	
		;(alert (strcat "uscita PutGui " ValSheetImportShape$))
	)
	;
	;
	(defun PutGuiInfo ()
	
		(princ "\nTypeFileToImportShape$   ")   (princ TypeFileToImportShape$)
		(princ "\nFileToImportShapeXls$    ")   (princ FileToImportShapeXls$)
		(princ "\nFileToImportShapeCsv$    ")  	(princ FileToImportShapeCsv$)
		(princ "\nLstSheet$                ")   (princ LstSheet$)
		(princ "\nValSheetImportShape$     ") 	(princ ValSheetImportShape$)
		(princ "\nValOrderImportShape$     ")	(princ ValOrderImportShape$)
		(princ "\nValPhaseImportShape$     ")	(princ ValPhaseImportShape$)
		(princ "\nValMarkImportShape$      ")	(princ ValMarkImportShape$)
		(princ "\nValQuantityImportShape$  ")	(princ ValQuantityImportShape$)
		(princ "\nValLengthImportShape$    ")	(princ ValLengthImportShape$)
		(princ "\nValWidthImportShape$     ")	(princ ValWidthImportShape$)
		(princ "\nValThickImportShape$     ")	(princ ValThickImportShape$)
		(princ "\nValMaterialImportShape$  ")	(princ ValMaterialImportShape$)
		(princ "\nValSeparatorImportShape$ ")	(princ ValSeparatorImportShape$)
		(princ "\nValCol1ImportShape$      ")	(princ ValCol1ImportShape$)
		(princ "\nValCol2ImportShape$      ")	(princ ValCol2ImportShape$)
		(princ "\nValCol3ImportShape$      ")	(princ ValCol3ImportShape$)
		(princ "\nValCol4ImportShape$      ")	(princ ValCol4ImportShape$)
		(princ "\nValCol5ImportShape$      ")	(princ ValCol5ImportShape$)
		(princ "\nValCol6ImportShape$      ")	(princ ValCol6ImportShape$)
		(princ "\nValCol7ImportShape$      ")	(princ ValCol7ImportShape$)
		(princ "\nValCol8ImportShape$      ")	(princ ValCol8ImportShape$)
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
	
		(if (= (get_tile "TypeXls") "1")  (setq TypeFileToImportShape$ "1"))
		(if (= (get_tile "TypeCsv") "1")  (setq TypeFileToImportShape$ "2"))
	
		
		(setq ValSheetImportShape$		(get_tile "ListSheet"))
		(setq ValOrderImportShape$		(get_tile "Order"))
		(setq ValPhaseImportShape$		(get_tile "Phase"))
		(setq ValMarkImportShape$		(get_tile "Mark"))
		(setq ValQuantityImportShape$	(get_tile "Quantity"))
		(setq ValLengthImportShape$		(get_tile "Length"))
		(setq ValWidthImportShape$		(get_tile "Width"))
		(setq ValThickImportShape$		(get_tile "Thick"))
		(setq ValMaterialImportShape$	(get_tile "Material"))
		(setq ValSeparatorImportShape$	(get_tile "Separator"))
		(setq ValCol1ImportShape$		(get_tile "Col1"))
		(setq ValCol2ImportShape$		(get_tile "Col2"))
		(setq ValCol3ImportShape$		(get_tile "Col3"))
		(setq ValCol4ImportShape$		(get_tile "Col4"))
		(setq ValCol5ImportShape$		(get_tile "Col5"))
		(setq ValCol6ImportShape$		(get_tile "Col6"))
		(setq ValCol7ImportShape$		(get_tile "Col7"))
		(setq ValCol8ImportShape$		(get_tile "Col8"))
		(setq ValOrderNAXls$			(get_tile "OrderNAXls"))
		(setq ValPhaseNAXls$			(get_tile "PhaseNAXls"))
		(setq ValMatNAXls$				(get_tile "MatNAXls"))
		(setq ValOrderNACsv$			(get_tile "OrderNACsv"))
		(setq ValPhaseNACsv$			(get_tile "PhaseNACsv"))
		(setq ValMatNACsv$				(get_tile "MatNACsv"))
		
		(setq <LstColumnSeekXls>	(list 
										(nth (atoi ValOrderImportShape$) 	<LstOrder>)
										(nth (atoi ValPhaseImportShape$) 	<LstPhase>)
										(nth (atoi ValMarkImportShape$) 	<LstMark>)
										(nth (atoi ValQuantityImportShape$) <LstQuantity>)
										(nth (atoi ValLengthImportShape$) 	<LstLength>)
										(nth (atoi ValWidthImportShape$)	<LstWidth>)
										(nth (atoi ValThickImportShape$) 	<LstThick>)
										(nth (atoi ValMaterialImportShape$) <LstMaterial>)
									)
		)
		(setq <LstColumnSeekCsv>	(list 
										(nth (atoi ValCol1ImportShape$) <LstColl>)
										(nth (atoi ValCol2ImportShape$) <LstCol2>)
										(nth (atoi ValCol3ImportShape$) <LstCol3>)
										(nth (atoi ValCol4ImportShape$)	<LstCol4>)
										(nth (atoi ValCol5ImportShape$) <LstCol5>)
										(nth (atoi ValCol6ImportShape$)	<LstCol6>)
										(nth (atoi ValCol7ImportShape$) <LstCol7>)
										(nth (atoi ValCol8ImportShape$) <LstCol8>)
									)
		)
		(if (and LstSheet$  <LstSheet>)   (setq <SheetBook> (nth (atoi ValSheetImportShape$) <LstSheet>)))
		(setq <Separator> (nth (atoi ValSeparatorImportShape$) <LstSeparator>))
		(setq <LstNAXls>  (list ValOrderNAXls$ ValPhaseNAXls$ ValMatNAXls$))
		(setq <LstNACsv>  (list ValOrderNACsv$ ValPhaseNACsv$ ValMatNACsv$))
	)
	;
	;
	(defun GetSheetsXls (/ LstSheet)
		(setq LstSheet$ nil)
		;(princ"\nTypeFileToImportShape$")  (princ TypeFileToImportShape$)
		;(princ"\nFileToImportShapeXls$")   (princ FileToImportShapeXls$)
		;(if (= TypeFileToImportShape$ "1")
			(if FileToImportShapeXls$
				(if (findfile FileToImportShapeXls$)
					(progn
						(ProgressBar "" "Lettura Excel" 0.1)
						(setq Reps~ 1)
						(PrgBr 10)
						(OpenExcel FileToImportShapeXls$)
						(PrgBr 10)
						(GetListSheet) (setq LstSheet$ MySheets$)
						(PrgBr 10)
						(CloseExcel)
						(EndProgressBar)					
					)
				)
			)
		;)
		LstSheet$
	)
	;
	;
	(defun OpenDemoShape (TypeFile / Path FileData)
	
		(setq Path 	(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Example\\NestingXls"))

		(cond 
			((= TypeFile "csv")
				(if (findfile (strcat Path "\\ExampleShape.csv"))
					(if (setq FileData (OpenFileDialog  (list Path "ExampleShape.csv" "*.csv" "Load Xls-Csv" nil nil)))
						(progn
							(setq FileToImportShapeCsv$ (strcat (nth 0 FileData) "\\" (nth 1 FileData)))
							(set_tile "FileSelectShapeCsv" FileToImportShapeCsv$)
							(set_tile   "Separator" "0")
							(set_tile   "Col1" 		"1")
							(set_tile   "Col2" 		"2")
							(set_tile   "Col3" 		"2")
							(set_tile   "Col4" 		"3")
							(set_tile   "Col5" 		"4")
							(set_tile   "Col6" 		"5")
							(set_tile   "Col7" 		"6")
							(set_tile   "Col8" 		"8")
						)
					)
				)
			)
			((= TypeFile "xls")
				(if (findfile (strcat Path "\\ExampleShape.xls"))
					(if (setq FileData (OpenFileDialog  (list Path "ExampleShape.xls" "*.xls|*.xlsx" "Load Xls-Csv" nil nil)))
						(progn
							(setq FileToImportShapeXls$ (strcat (nth 0 FileData) "\\" (nth 1 FileData)))
							(set_tile "FileSelectShapeXls" FileToImportShapeXls$)
							(setq <LstSheet> (GetSheetsXls))
							(start_list "ListSheet")(mapcar 'add_list <LstSheet>) (end_list)
							(set_tile   "ListSheet" "0")
							(set_tile   "Order" 	"1")
							(set_tile   "Phase" 	"2")
							(set_tile   "Mark"		"2")
							(set_tile   "Quantity" 	"3")
							(set_tile   "Length" 	"4")
							(set_tile   "Width" 	"5")
							(set_tile   "Thick" 	"6")
							(set_tile   "Material" 	"8")
						)
					)
				)
			)
		)
	)
	;
	; Main
	;
	(setq <LstOrder>	 '("N.D." "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstPhase>	 '("N.D." "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstMark>		 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstQuantity>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstLength>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstWidth>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstThick>	 '("A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
	(setq <LstMaterial>	 '("N.D." "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))

	(setq <LstSeparator> '(";" "," "|"))
	(setq <LstColl>		 '("N.D." "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol2>		 '("N.D." "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol3>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol4>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol5>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol6>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol7>		 '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	(setq <LstCol8>		 '("N.D." "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26"))
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))

	(setq Loop T)
	(while Loop
	
		(new_dialog "ImportShapeXls" xx "" (cond ( *ImportShapeXls* ) ( '(-1 -1) )))

		(if (not TypeFileToImportShape$) (setq TypeFileToImportShape$ "1"))
		(PutGui)
		(action_tile "TypeXls" 	 	 		(vl-prin1-to-string '(progn (GetGui) (setq TypeFileToImportShape$ "1") (PutGui))))
		(action_tile "TypeCsv" 	 			(vl-prin1-to-string '(progn (GetGui) (setq TypeFileToImportShape$ "2") (PutGui))))
		(action_tile "SelectFileShapeXls" 	(vl-prin1-to-string '(progn (GetGui) (setq FileImport T)   (setq	*ImportShapeXls* (done_dialog)) (unload_dialog xx))))
		(action_tile "SelectFileShapeCsv" 	(vl-prin1-to-string '(progn (GetGui) (setq FileImport T)   (setq	*ImportShapeXls* (done_dialog)) (unload_dialog xx))))
		(action_tile "ChkFileShapeXls"		(vl-prin1-to-string '(progn (GetGui) (setq FileCheckXls T) (setq	*ImportShapeXls* (done_dialog)) (unload_dialog xx))))
		(action_tile "ChkFileShapeCsv"		(vl-prin1-to-string '(progn	(GetGui) (setq FileCheckCsv T) (setq	*ImportShapeXls* (done_dialog))	(unload_dialog xx))))
		(action_tile "OpenFileShapeXls"		(vl-prin1-to-string '(progn	(GetGui) 
																	(if FileToImportShapeXls$
																		(if (findfile FileToImportShapeXls$)
																			(LM:Open FileToImportShapeXls$)
																			(LM:popup "avvertimento" "File non trovato" (+ 0 48 4096))
																		)
																		(LM:popup "avvertimento" "Definire il file" (+ 0 48 4096))
																	))))
		(action_tile "OpenFileShapeCsv"		(vl-prin1-to-string '(progn	(GetGui) 
																	(if FileToImportShapeCsv$
																		(if (findfile FileToImportShapeCsv$)
																			(LM:Open FileToImportShapeCsv$)
																			(LM:popup "avvertimento" "Il file non trovato" (+ 0 48 4096))
																		)
																		(LM:popup "avvertimento" "Definire il file" (+ 0 48 4096))
																	))))
		(action_tile "OpenDemoShapeCsv"		(vl-prin1-to-string '(progn	(GetGui) (OpenDemoShape "csv"))))
		(action_tile "OpenDemoShapeXls"		(vl-prin1-to-string '(progn	(GetGui) (OpenDemoShape "xls"))))
		
		(action_tile "cancel"    			(vl-prin1-to-string '(progn (setq *ImportShapeXls* (done_dialog)) (unload_dialog xx) (setq Loop nil))))
		(action_tile "accept"    			(vl-prin1-to-string '(progn (GetGui) 
																	(setq ImportShape T)
																	(setq *ImportShapeXls* (done_dialog)) 
																	(unload_dialog xx)
																	(setq Loop nil))))
		(start_dialog)
		
		(cond 
			((= FileImport T)
				(GetFileImport)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq FileImport nil)
			)
			((= FileCheckXls T)
				(CheckFileImportXls FileToImportShapeXls$ <SheetBook> <LstColumnSeekXls> <LstNAXls>)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq FileCheckXls nil)
			)
			((= FileCheckCsv T)
				(CheckFileImportCsv FileToImportShapeCsv$ <Separator> <LstColumnSeekCsv> <LstNACsv>)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq FileCheckCsv nil)
			)
			((= ImportShape T)
				(cond 
					((= TypeFileToImportShape$ "1")
						(setq LstDataShepe (ReadDataShapeFromXls FileToImportShapeXls$ <SheetBook> <LstColumnSeekXls> <LstNAXls>))
					)
					((= TypeFileToImportShape$ "2")
						(setq LstDataShepe (ReadDataShapeFromCsv FileToImportShapeCsv$ <Separator> <LstColumnSeekCsv> <LstNACsv>))
					)
				)
				(setq ImportShape nil)
			)
		)
	)
	LstDataShepe
)
;
;
;
(defun ReadDataShapeFromXls (FileImportShapeXls SheetBook LstColumnSeek LstNAXls / CompleteXlsLine AssignValueDataXls ParseDataXls
																				   MaxLoopSearch LoopSearch LineRead Num LstRead)

	;     0     0     1     1     1     1     1     0
	;     A     B     C     D     E     F     G     H
	;   order phase  mark  qta  Length Width Thick Material
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
	(defun AssignValueDataXls (ListDataXls LstColumnSeek LstNAxls / PrincToString
																	AlternativeOrder AlternativePhase AlternativeMat
																	NDOrder NDPhase NDMat
																	Num itm Order Phase Mat Mark Quantity Length Width
																	Thick)

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
		(setq AlternativeOrder	"-")
		(setq AlternativePhase	"-")
		(setq AlternativeMat	"-")

		(if (= (setq NDOrder (car LstNAXls)) "")   (setq NDOrder AlternativeOrder))
		(if (= (setq NDPhase (cadr LstNAXls)) "")  (setq NDPhase AlternativePhase))
		(if (= (setq NDMat   (caddr LstNAXls)) "") (setq NDMat   AlternativeMat))
		
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
							(setq Width 	(PrincToString (nth Num  ListDataXls)))
						)
						((= Num 6)
							(setq Thick 	(PrincToString (nth Num  ListDataXls)))
						)
						((= Num 7)
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
				(setq Rtn (list Order Phase Mark Quantity Length Width Thick Mat))
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
					((= Num 5) (if (= (atof itm) 0) (setq Chk nil)))
					((= Num 6) (if (= (atof itm) 0) (setq Chk nil)))
					((= Num 7) (if (= itm "") 		(setq Chk nil)))
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
	(if (and FileImportShapeXls SheetBook LstColumnSeek LstNAXls)
		(if (findfile FileImportShapeXls)
			(progn
				(setq Num 1)
				(ProgressBar "" "Lettura Excel" 0.1)
				(setq Reps~ 1)
				(PrgBr 70)
				(OpenExcel FileImportShapeXls)
				(PrgBr 70)
				(ActiveSheet SheetBook)
				(PrgBr 70)
				
				(setq LoopSearch 1)
				(while LoopSearch 
				
					(setq LineRead (car (ReadCells LstColumnSeek (list (LM:rtos Num 2 0)))))
					(PrgBr 70)

					(setq ValueDataXls (AssignValueDataXls (CompleteXlsLine LineRead) LstColumnSeek LstNAXls))
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
(defun ReadDataShapeFromCsv (FileImportShapeCsv Separator LstColumnSeek LstNACsv / ParseCsvLine AssignValueDataCsv ParseDataCsv
																				   itm LstCol Stream LineRead SplitLineRead LstRead Rtn
																				   ValueDataCsv
																				   AlternativeOrder AlternativePhase AlternativeMat)

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
	(defun AssignValueDataCsv (ListDataCsv LstColumnSeek LstNACsv / AlternativeOrder AlternativePhase AlternativeMat
																	NDOrder NDPhase NDMat
																	Num itm Order Phase Mat Mark Quantity Length Width
																	Thick)



		(setq AlternativeOrder	"-")
		(setq AlternativePhase	"-")
		(setq AlternativeMat	"-")

		(if (= (setq NDOrder (car LstNACsv)) "")   (setq NDOrder AlternativeOrder))
		(if (= (setq NDPhase (cadr LstNACsv)) "")  (setq NDPhase AlternativePhase))
		(if (= (setq NDMat   (caddr LstNACsv)) "") (setq NDMat   AlternativeMat))
		
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
							(setq Width 		(nth (- (atoi itm) 1)  ListDataCsv))
						)
						((= Num 6)
							(setq Thick 		(nth (- (atoi itm) 1)  ListDataCsv))
						)
						((= Num 7)
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
				(setq Rtn (list Order Phase Mark Quantity Length Width Thick Mat))
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
				((= Num 5) (if (= (atof itm) 0) (setq Chk nil)))
				((= Num 6) (if (= (atof itm) 0) (setq Chk nil)))
				((= Num 7) (if (= itm "") 		(setq Chk nil)))
			)
			(setq Num (1+ Num))
		)
		Chk
	)
	;
	; Main
	;
	(if (and FileImportShapeCsv Separator LstColumnSeek LstNACsv)
		(if (findfile FileImportShapeCsv)
			(progn
				(foreach itm LstColumnSeek
					(setq LstCol (append LstCol (list (atoi (substr itm (strlen itm) 1)))))
				)
				(setq Stream (open FileImportShapeCsv "r"))
				(if Stream
					(while (setq LineRead (read-line Stream))
						(setq ValueDataCsv (AssignValueDataCsv (CompleteCsvLine LineRead Separator) LstColumnSeek LstNACsv))
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
;(CHECKFILEIMPORTXLS "C:\\EasyCutBeta\\Test\\Cartel1.xlsx" "Foglio1" '("A" "B" "C" "D" "E" "F" "G" "H") '("" "" ""))
;
(defun CheckFileImportXls (FileImportShapeXls SheetBook LstColumnSeek LstNAXls / itm itm1 LstHead Ncar Stream FileTmp Prg)

	(cond
		((null FileImportShapeXls)
			(LM:popup "avvertimento" "Dare il nome del file" (+ 0 48 4096))
		)
		(t
			(foreach itm (ReadDataShapeFromXls FileImportShapeXls SheetBook LstColumnSeek LstNAXls)
				(setq LstHead (append LstHead (list (list	(nth 0  itm) 				;->  IdOrder
															(nth 1  itm) 				;->  IdPhase
															(nth 2  itm) 				;->  IdIdentification
															(nth 3  itm) 				;->  IdQuantity
															(nth 6  itm)				;->  IdThickness
															(nth 4  itm)				;->  IdHeigth
															(nth 5  itm)				;->  IdLength
															(strcase (nth 7  itm)) 		;->  IdQuality
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
									(testo_a_sinistra "Thick."			(cadr Ncar))
									(testo_a_sinistra "Heigth" 			(cadr Ncar))
									(testo_a_sinistra "Length" 			(cadr Ncar))
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
(defun CheckFileImportCsv (FileImportShapeCsv Separator LstColumnSeek LstNACsv / itm itm1 LstHead Ncar Stream FileTmp Prg)

	(cond
		((null FileImportShapeCsv)
			(LM:popup "avvertimento" "Dare il nome del file" (+ 0 48 4096))
		)
		(t
			(foreach itm (ReadDataShapeFromCsv FileImportShapeCsv <Separator> <LstColumnSeekCsv> <LstNACsv>)
				(setq LstHead (append LstHead (list (list	(nth 0  itm) 			;->  IdOrder
															(nth 1  itm) 			;->  IdPhase
															(nth 2  itm) 			;->  IdIdentification
															(nth 3  itm) 			;->  IdQuantity
															(nth 6  itm) 			;->  IdThickness
															(nth 4  itm) 			;->  IdHeigth
															(nth 5  itm) 			;->  IdLength
															(strcase (nth 7  itm)) 	;->  IdQuality
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
									(testo_a_sinistra "Thick."			(cadr Ncar))
									(testo_a_sinistra "Heigth" 			(cadr Ncar))
									(testo_a_sinistra "Length" 			(cadr Ncar))
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
(defun PreviewNestingImportXls (LstShape / *error* LM:startundo LM:endundo
													Out Ssel LstEnameShape MinMaxSsel MinCatch MaxCatch itm Rtn)

	(defun *error* ( msg )
        (LM:endundo (LM:acdoc))
		(DeleteSsel Ssel)
		;(command "._U" "1")
        ;(if (not (wcmatch (strcase msg) "*break,*cancel*,*exit*"))
        ;    (princ (strcat "\nError: " msg))
        ;)
        (princ)
    )
	(defun LM:startundo ( doc )
		(LM:endundo doc)
		(vla-startundomark doc)
	)
	(defun LM:endundo ( doc )
		(while (= 8 (logand 8 (getvar 'undoctl)))
			(vla-endundomark doc)
		)
	)
	(defun LM:acdoc nil
		(cond ( acdoc ) ((setq acdoc (vla-get-activedocument (vlax-get-acad-object)))))
	)

	;
	;
	;
	(LM:startundo (LM:acdoc))
	(if LstShape
		(progn
			(setq Out (PreviewNestingShapeImportXls LstShape))
			(setq Ssel          (nth 0 Out))
			(setq LstEnameShape (nth 1 Out))
			(if (and Ssel LstEnameShape)
				(progn
					(setq MinMaxSsel	(LM:SSBoundingBox Ssel))
					
					(setq MinCatch 		(list (- (nth 0 (nth 0 MinMaxSsel)) 100)
											  (- (nth 1 (nth 0 MinMaxSsel)) 100)
										)
					)
					(setq MaxCatch 		(list (+ (nth 0 (nth 2 MinMaxSsel)) 100)
											  (+ (nth 1 (nth 2 MinMaxSsel)) 100)
										)
					)			
					(vla-ZoomWindow (vlax-get-acad-object) (vlax-3d-point MinCatch) (vlax-3d-point MaxCatch))			
					
					(command "._Move" Ssel "" (car MinMaxSsel) pause)
					(while (not (FindAreaAvailable Ssel))
						(command "._Move" Ssel "" (getvar "LASTPOINT") pause)
					)
					(foreach itm LstEnameShape
						(vla-getboundingbox (vlax-ename->vla-object itm) 'mnl 'mxl)
						(setq Rtn (append Rtn (list (vlax-safearray->list mnl))))
					)
					
					(DeleteSsel Ssel)
				)
			)
		)
	)
	(LM:endundo (LM:acdoc))
	Rtn
)
;
;
;
(defun PreviewNestingShapeImportXls (LstShape / DimScreen StepColumn Xdstv Ydstv StartXdstv StartYDstv LstY
													 i itm _Order _Phase _Mark _Qty _Length _Heigth _Thick _Mat
													 EnameShape LstOutEname Ssel minmax Width Height
													 point1 point2 conta Rtn)
 
	(setq DimScreen (VpCoords))
	(setq StepColumn 1)
	(setq Xdstv (/ (+ (nth 0 (nth 0 DimScreen)) (nth 0 (nth 1 DimScreen))) 2.0))
	(setq Ydstv (/ (+ (nth 1 (nth 0 DimScreen)) (nth 1 (nth 1 DimScreen))) 2.0))
	(setq StartXdstv Xdstv)
	(setq StartYDstv Ydstv)
	(setq LstY nil)
	(setq Rtn (ssadd))

	(StartProgressBar "Preview:" (length LstShape))
	
	(foreach itm LstShape
	
		(setq _Order 	(nth 2  itm))
		(setq _Phase 	(nth 3  itm))
		(setq _Mark  	(nth 4  itm))
		(setq _Qty   	(nth 5  itm))
		(setq _Thick  	(nth 6  itm))
		(setq _Length 	(nth 7  itm))
		(setq _Heigth	(nth 8  itm))
		(setq _Mat 		(nth 9  itm))	
		
		(UpDateProgressBar)
		(princ (strcat "\nPreview shape " _Order " " _Phase " " _Mark))
		
		(setq EnameShape 	(MakeRectangle (list Xdstv Ydstv) (atof _Length) (atof _Heigth)))
		(setq LstOutEname   (append LstOutEname (list EnameShape)))
		(setq Ssel 			(PreviewInquadraShape EnameShape))
		(setq minmax 		(LM:SSBoundingBox Ssel))
		(setq Width			(abs (- (nth 0 (nth 1 minmax)) (nth 0 (nth 0 minmax)))))
		(setq Height		(abs (- (nth 1 (nth 2 minmax)) (nth 1 (nth 1 minmax)))))
		
		(setq LstY (append LstY (list Height)))
		
		(setq point1 (vlax-3d-point  (nth 0 (nth 0 minmax))   (nth 1 (nth 0 minmax))   0.0)
			  point2 (vlax-3d-point  StartXDstv StartYDstv  0.0)
		)

		(setq conta 0)
		(repeat (sslength Ssel)
				(vla-Move (vlax-ename->vla-object (ssname Ssel conta)) point1 point2)
				(setq conta (1+ conta))
		)
				
		(setq StepColumn (1+ StepColumn))
				
		(if (> StepColumn MaxColumn$)
			(setq 	StartXDstv Xdstv
					StartYDstv (+ StartYDstv (apply 'max LstY) (nth 1 MargColumn$))
					LstY nil
					StepColumn 1
			)
			(setq 	StartXDstv (+ StartXDstv Width (nth 0 MargColumn$)))
		)
		
		(setq conta 0)
		(repeat (sslength Ssel)
				(ssadd (ssname Ssel conta) Rtn)
				(setq conta (1+ conta))
		)
	)
	(ClearProgressBar)
	(list Rtn LstOutEname)
)
;
;
;
(defun NestingShapeImportXls (LstShape LstPtInsert / Rtn FileTmp i Num itm itm1 Err
														  _Order _Phase _Mark _Qty _Length _Heigth _Thick _Mat
														  PtInsert EnameShape Head Ssel)
	
	(setq Rtn (ssadd))
	(setq FileTmp (vl-filename-mktemp))
	(setq StreamLog$ (open FileTmp "w"))
	(princ (strcat "\n" (today) "   " (Time)) StreamLog$)
	(princ "\n+-----------------------------------------------------------------------+" StreamLog$)
	(princ "\n|       Controllo contorni importati  [NestingShapeImportXls]           |" StreamLog$)
	(princ "\n+-----------------------------------------------------------------------+" StreamLog$)
	(princ "\n" StreamLog$)	
	
	(StartProgressBar "Import:" (length LstShape))

	(setq Num 0)
	(foreach itm LstShape

		(setq _Order 	(nth 2  itm))
		(setq _Phase 	(nth 3  itm))
		(setq _Mark  	(nth 4  itm))
		(setq _Qty   	(nth 5  itm))
		(setq _Thick  	(nth 6  itm))
		(setq _Length 	(nth 7  itm))
		(setq _Heigth	(nth 8  itm))
		(setq _Mat 		(nth 9  itm))	

		(UpDateProgressBar)
		; Check 
		(setq Err nil)
		(if (<= (atoi _Qty) 	0) 
			(progn (setq Err T) (princ (strcat "\nErrore quantita  [" _Qty "]"    _Order " " _Phase " " _Mark) StreamLog$)))
		(if (<= (atof _Length) 	0) 
			(progn (setq Err T) (princ (strcat "\nErrore lunghezza [" _Length "]" _Order " " _Phase " " _Mark) StreamLog$)))
		(if (<= (atof _Heigth) 	0) 
			(progn (setq Err T) (princ (strcat "\nErrore larghezza [" _Heigth "]" _Order " " _Phase " " _Mark) StreamLog$)))
		(if (<= (atof _Thick)	0) 
			(progn (setq Err T) (princ (strcat "\nErrore spessore  [" _Thick "]"  _Order " " _Phase " " _Mark) StreamLog$)))
		(if (not Err)
			(progn
				(princ (strcat "\n" _Order " " _Phase " " _Mark))
				(setq PtInsert 		 	(nth Num LstPtInsert)) 
				(setq EnameShape 	 	(MakeRectangle PtInsert (atof _Length) (atof _Heigth)))		
				
				;	0	IdOrder
				;	1	IdDrawing
				;	2	IdPhase
				;	3	IdIdentification
				;	4	IdQuality
				;	5	IdQuantity
				;	6	IdProfile
				;	7	IdCode
				;	8	IdLength
				;	9	IdHeigth
				;	10	IdThickness
				;	11	IdWeightmt
				;	12	IdSurfacemt
				;	13	IdName

				;					0	 1	   2	 3	  4		5	6	7	  8		  9     10	 11  12   13
				(setq Head (list _Order "0" _Phase _Mark _Mat _Qty "0" "0" _Length _Heigth _Thick "0" "0" "0"))
                
				(AttachDataInfoShape  (list EnameShape) Head)
				(setq Ssel 			  (InquadraShape EnameShape nil))
				(foreach itm1 (LM:ss->ent Ssel) (ssadd itm1 Rtn))
			)
		)
		(setq Num (1+ Num))
	)
	(ClearProgressBar)
	(close StreamLog$)
	(EasyCutViewer FileTmp)
	Rtn
)
;
;
;
(defun LM:Open ( target / Shell result )
	;;------------------------=={ Open }==------------------------;;
	;;                                                            ;;
	;;  Uses the 'Open' method of the Shell Object to open the    ;;
	;;  specified file or folder.                                 ;;
	;;------------------------------------------------------------;;
	;;  Author: Lee Mac, Copyright © 2010 - www.lee-mac.com       ;;
	;;------------------------------------------------------------;;
	;;  Arguments:                                                ;;
	;;  target - filename, directory or                           ;;
	;;           ShellSpecialFolderConstants Enumeration to open  ;;
	;;------------------------------------------------------------;;
	;;  Returns:  T if opened successfully, else nil              ;;
	;;------------------------------------------------------------;;
	(setq Shell (vla-getInterfaceObject (vlax-get-acad-object) "Shell.Application"))
	(setq result
		(and (or (eq 'INT (type target)) (setq target (findfile target)))
			(not
				(vl-catch-all-error-p
					(vl-catch-all-apply 'vlax-invoke (list Shell 'Open target))
				)
			)
		)
	)
	(vlax-release-object Shell)
	result
)