(defun Test (/ xlApp FileXls Title DataValue Rtn)

	(if (not (setq xlApp (vlax-get-or-create-object "Excel.Application")))
			(alert "\nExcel non installato")
		(progn
			(vlax-release-object xlApp)
			(setq FileXls (strcat (getenv "LOCALAPPDATA") "\\EasyCut\\TmpFile.xlsx"))
			(setq Title 	(list "Title1" "Title2"))
			(setq DataValue (list (list "Andrea" "Ramona")
							(list "Ilaria" "Daniele")))
			(if (ExportToExcelActiveX FileXls Title DataValue nil)
				(progn
					(EditExcelVbs  FileXls)
					(setq Rtn (ExcelToCsvVbs FileXls))
					(vl-file-delete FileXls)
				)
			)
		)
	)
	Rtn
)
;
(defun EditExcelVbs (FileXls / FileVbs Af Shell)

	(setq FileVbs (strcat (getenv "LOCALAPPDATA") "\\EasyCut\\EditXls.vbs"))
	
	(MakeEditExcelVbs FileVbs FileXls)
	(while (not (setq Af (open FileXls "a"))))
	(close Af)
	; -----------------------------------------------------
	(setq Shell (vlax-get-or-create-object "WScript.Shell"))
	(vlax-invoke-method Shell "Run" (strcat "\"" FileVbs "\"") 1 :vlax-true)
	(vlax-release-object Shell)
	(vl-file-delete FileVbs)
)
;
(defun ExportToExcelActiveX (FileXls Title DataValue TypeValue LstDimButton Visible / CreateArray PopulateArray ArrayData
														xlApp xlBook xlSheet xlCols Column _Range)
	;
	(defun CreateArray (Title DataValue / NumberRow NumberColumn)
		(setq NumberRow (1+ (length DataValue)))
		(setq NumberColumn	(length Title))
		(list NumberRow  NumberColumn (vlax-make-safearray vlax-vbString (cons 0 (1- NumberRow)) (cons 0 (1- NumberColumn))))
	)
	;
	(defun SetTypeValueOnCell (XlSheet DataValue NumberRow NumberColumn TypeValue / c r _Range xlrange TVal Sep)

		; Title +++++++
		(setq c 1)
		(repeat NumberColumn
			(setq _Range (chr (+ 64 c)))
			(setq xlrange (vlax-get-property XlSheet 'Range (strcat _Range "1")))
			(vlax-put-property xlrange 'NumberFormat "@")
			(setq c (1+ c))
		)
		(setq Sep (vl-registry-read "HKEY_CURRENT_USER\\Control Panel\\International" "sDecimal"))
		(setq r 2)
		(foreach Row DataValue
			(setq c 1)
			(foreach val Row
				;   A     B     C     D     E     F     G      H     I
				;("int" "str" "str" "str" "str" "int" "real" "str" "str"))
				;
				(setq _Range (chr (+ 64 c)))
				(setq xlrange (vlax-get-property XlSheet 'Range (strcat _Range (Rtos r 2 0))))
				
				(setq TVal (nth (1- c) TypeValue))
				(cond 
					((= TVal "int")
						(vlax-put-property xlrange 'NumberFormat "0")	
					)
					((= TVal "str")
						(vlax-put-property xlrange 'NumberFormat "@")
					)
					((= TVal "real")
						(vlax-put-property xlrange 'NumberFormat (strcat "0" Sep "0"))					
					)
				)
				(setq c (1+ c))
			)
			(setq r (1+ r))
		)
	)
	
	;
	(defun PopulateArray (Array Title DataValue TypeValue / TotData r Row c val)
	
		;
		; Title +++++++++++++++++++
		;
		(setq r 0)
;		(setq c 0)
;		(foreach val Title
;			(vlax-safearray-put-element Array r c val)
;			(setq c (1+ c))
;		)
;
;
;		;(setq TotData   (append (list Title) DataValue))
;		;
;		; Value +++++++++++++++++++
;		;
;		(setq r 1)
		(foreach Row DataValue
			(setq c 0)
			(foreach val Row
				;("int" "str" "str" "str" "str" "int" "real" "str" "str"))
				(setq TVal (nth c TypeValue))
				(cond 
					((= TVal "int")
						(vlax-safearray-put-element Array r c (atoi val))	
					)
					((= TVal "str")
						(vlax-safearray-put-element Array r c val)
					)
					((= TVal "real")
						(vlax-safearray-put-element Array r c (atof val))					
					)
				)
				(setq c (1+ c))
			)
			(setq r (1+ r))
		)
	)
	;
	(defun MakeRange (NumberRow MumberColumn)
		(strcat "A1:" (chr (+ 64 MumberColumn)) (itoa NumberRow))
	)
	;
	(defun PopulateCellExcell (XlSheet Title DataValue TypeValue LstDimButton / c itm xlCol _Range)
	
		(setq c 1)
		(foreach itm LstDimButton
			(setq _Range (chr (+ 64 c)))
			(setq xlCol (vlax-get-property XlSheet 'Range (strcat _Range ":" _Range)))
			(vlax-put-property xlcol 'ColumnWidth itm)
			;(vlax-release-object xlCol)
			(setq c (1+ c))
		)
	
		; Title +++++++
		(setq c 1)
		(foreach itm Title
			(setq _Range (chr (+ 64 c)))
			(setq xlrange (vlax-get-property XlSheet 'Range (strcat _Range "1")))
			(vlax-put-property xlrange 'NumberFormat "@")
			(vlax-put-property xlrange 'Value2 itm)
			(vlax-put-property xlrange 'HorizontalAlignment -4108)
			(setq xlfont (vlax-get-property xlrange 'Font))
			(setq xlborders (vlax-get-property xlrange 'Borders))
			(setq xlinterior (vlax-get-property xlrange 'Interior))
			(vlax-put-property xlfont 'Bold :vlax-true)
			(vlax-put-property xlborders 'LineStyle 1)
			(vlax-put-property xlborders 'Weight 2)
			(vlax-put-property xlinterior 'ColorIndex 15)
			
			(setq c (1+ c))
		)
		;
		; Value +++++++
		;
		(setq Sep (vl-registry-read "HKEY_CURRENT_USER\\Control Panel\\International" "sDecimal"))
		(setq r 0)
		(foreach Row DataValue
			(setq c 0)
			(foreach val Row
				;   A     B     C     D     E     F     G      H     I
				;("int" "str" "str" "str" "str" "int" "real" "str" "str"))
				;
				(setq _Range (chr (+ 64 (1+ c))))
				(setq xlrange (vlax-get-property XlSheet 'Range (strcat _Range (Rtos (+ r 2) 2 0))))
				
				(setq TVal (nth c TypeValue))
				(cond 
					((= TVal "int")
						(vlax-put-property xlrange 'NumberFormat "0")
						(vlax-put-property xlrange 'Value2 (atoi val))
						(vlax-put-property xlrange 'HorizontalAlignment -4108)						
					)
					((= TVal "str")
						(vlax-put-property xlrange 'NumberFormat "@")
						(vlax-put-property xlrange 'Value2 val)						
						(vlax-put-property xlrange 'HorizontalAlignment -4108)						
					)
					((= TVal "real")
						(vlax-put-property xlrange 'NumberFormat (strcat "0" Sep "0"))						
						(vlax-put-property xlrange 'Value2 (atof val))						
						(vlax-put-property xlrange 'HorizontalAlignment -4108)						
				)
				)
				(setq c (1+ c))
			)
			(setq r (1+ r))
		)
	
	)

	;
	; Main
	;
	(setq xlApp (vlax-get-or-create-object "Excel.Application"))
	(if xlApp
		(progn
		
			(if (findfile FileXls) (vl-file-delete FileXls))
			(if Visible
				(vla-put-visible xlApp :vlax-true)
				(vla-put-visible xlApp :vlax-false)
			)
			;; Crea una nuova cartella di lavoro
			(setq xlBook (vlax-invoke (vlax-get-property xlApp "Workbooks") "Add"))
			(setq xlSheet (vlax-get-property xlBook "ActiveSheet"))
		
			
			;("int" "str" "str" "str" "str" "int" "real" "str" "str"))
			
			;(setq ArrayData (CreateArray Title DataValue))
			;(PopulateArray (caddr ArrayData) Title DataValue TypeValue)
			;(setq Range (vlax-get-property xlSheet 'Range 
			;				(MakeRange (car ArrayData) (cadr ArrayData))
			;			)
			;)
			;(vlax-put-property Range 'Value2 (caddr ArrayData))

			(PopulateCellExcell XlSheet Title DataValue TypeValue LstDimButton)
			
			;(setq xlCols  (vlax-get-property xlSheet 'Columns))
			;(vlax-invoke-method xlcols 'AutoFit)
			
			;(vlax-put-property (vlax-get-property xlSheet "Range" "A1") "Value2" "ID")
			;(vlax-put-property (vlax-get-property xlSheet "Range" "B1") "Value2" "Coordinate")
			;(vlax-put-property (vlax-get-property xlSheet "Range" "A2") "Value2" 1)
			;(vlax-put-property (vlax-get-property xlSheet "Range" "B2") "Value2" "10,20,0")
  
			;; Salva il file (specificare percorso completo)
			(vlax-invoke xlBook "SaveAs" FileXls)
			;; Chiudi e pulisci
			(vlax-invoke xlBook "Close" :vlax-false)
			(vlax-invoke xlApp "Quit")
			;(vlax-release-object xlCols)
			(vlax-release-object xlSheet)
			(vlax-release-object xlBook)
			(vlax-release-object xlApp)
			;(princ "\nDati esportati in Excel.")
			T
		)
	)
)

;
(defun ImportFromExcelVbs (FileXls / FileVbs FileVbs Af Shell)
	
	(setq FileVbs (strcat (getenv "LOCALAPPDATA") "\\EasyCut\\ReadXls.vbs"))
	(setq FileOut (strcat (getenv "LOCALAPPDATA") "\\EasyCut\\ReadXls.csv"))
	(if (findfile FileVbs) (vl-file-delete FileVbs)) 
	(if (findfile FileOut) (vl-file-delete FileOut)) 
	
	(MakeReadExcelVbs FileVbs FileXls FileOut)
	(while (not (setq Af (open FileXls "a"))))
	(close Af)
	; -----------------------------------------------------
	(setq Shell (vlax-get-or-create-object "WScript.Shell"))
	(vlax-invoke-method Shell "Run" (strcat "\"" FileVbs "\"") 1 :vlax-true)
	(vlax-release-object Shell)
	(vl-file-delete FileVbs)
	; da modificare -----> (if (findfile FileOut) (ReadCsv FileOut ";"))
)
;
(defun ImportFromExcelActiveX  (FileXls Visible / MakeRange RecursiveRead
										  xlApp xlBook xlSheet xlRange MaxRow MaxColumn Rtn)
 
	(defun MakeRange (NumberRow MumberColumn)
		(strcat "A1:" (chr (+ 64 MumberColumn)) (itoa NumberRow))
	)
	;
	(defun RecursiveRead (Lst / Rtn itm1 itm2 LstTmp)
		
		(if Lst
			(progn
				(if (= (type Lst) 'safearray) (setq Lst (vlax-safearray->list Lst)))
				
				(foreach itm1 Lst
					(setq LstTmp nil)
					(foreach itm2 itm1
						(setq LstTmp (append LstTmp (list (vlax-variant-value itm2))))
					)
					(setq Rtn (append Rtn (list LstTmp))) 
				)
				(vl-remove-if '(lambda (x) (member nil x)) Rtn)
			)
		)
	)
	;
	; Main
	;
	; Connessione all'applicazione Excel
	(setq xlApp (vlax-get-or-create-object "Excel.Application"))
	(if xlApp
		(progn
			(if Visible
				(vla-put-visible xlApp :vlax-true)
				(vla-put-visible xlApp :vlax-false)
			)
			
			(setq xlBook (vla-open (vlax-get-property xlApp 'Workbooks) FileXls))
			(setq xlSheet (vlax-get-property xlBook 'ActiveSheet))
			
			;; Ottiene il conteggio delle righe nell'area usata
			(setq MaxRow 	(vlax-get-property (vlax-get-property (vlax-get-property xlSheet 'UsedRange) 'Rows) 'Count))
			(setq MaxColumn (vlax-get-property (vlax-get-property (vlax-get-property xlSheet 'UsedRange) 'Columns) 'Count))
			; Legge l'intervallo A1:B10
			(setq xlRange (vlax-get-property xlSheet 'Range (MakeRange MaxRow MaxColumn)))
			(setq Rtn (vlax-variant-value (vlax-get-property xlRange 'Value2)))
			(vlax-invoke-method xlBook 'Close :vlax-false)
			(vlax-invoke xlApp "Quit")
			(vlax-release-object xlBook)
			(vlax-release-object xlSheet)
			(vlax-release-object xlApp)
		)
	)
	(RecursiveRead Rtn)
)
;
(defun ExcelToCsvVbs (FileXls / FileVbs FileCsv Af Shell Rtn)

	(setq FileVbs (strcat (getenv "LOCALAPPDATA") "\\EasyCut\\XlsToCsv.vbs"))
	(setq FileCsv (strcat (getenv "LOCALAPPDATA") "\\EasyCut\\TmpFile.csv"))
	(if (findfile FileVbs) (vl-file-delete FileVbs)) 
	(if (findfile FileCsv) (vl-file-delete FileCsv)) 
	
	(MakeExcelToCsvVbs FileVbs FileXls FileCsv)
	(while (not (setq Af (open FileXls "a"))))
	(close Af)
	; -----------------------------------------------------
	(setq Shell (vlax-get-or-create-object "WScript.Shell"))
	(vlax-invoke-method Shell "Run" (strcat "\"" FileVbs "\"") 1 :vlax-true)
	(vlax-release-object Shell)
	(vl-file-delete FileVbs)
	(if (findfile FileCsv) (setq Rtn (LM:readcsv FileCsv)))
	(vl-file-delete FileVbs)
	(vl-file-delete FileCsv)
	Rtn
	
)
;
(defun MakeEditExcelVbs (FileVbs FileXls / Wf)

	(setq Wf (open FileVbs "W"))
	(if Wf
		(progn
			(write-line "Set objExcel = CreateObject(\"Excel.Application\")" 						Wf)
			(write-line "Set objShell = CreateObject(\"WScript.Shell\")" 							Wf)
			(write-line "' Rende l'applicazione visibile"											Wf)
			(write-line "objExcel.Visible = True"													Wf)
			(write-line "' Aggiunge un nuovo documento (o usa .Open \"C:\percorso\file.xlsx\")"		Wf)
			(write-line "' objExcel.Workbooks.Add"													Wf)
			(write-line (strcat "Set objWorkbook = objExcel.Workbooks.Open(\"" FileXls  "\")")		Wf)
			;(write-line "Set objSheet = objWorkbook.Sheets(1)"										Wf)
			;(write-line "' AutoFit per tutte le colonne del foglio"									Wf)
			;(write-line "objSheet.Cells.EntireColumn.AutoFit"										Wf)
			(write-line ""																			Wf)
			(write-line "' Riduce l'interfaccia: Modalità Schermo Intero"							Wf)
			(write-line "' Nasconde Ribbon, Barra di stato e Barra della formula"					Wf)
			(write-line "objExcel.ExecuteExcel4Macro \"SHOW.TOOLBAR(\"\"Ribbon\"\",False)\""		Wf)
			(write-line "'objExcel.DisplayFullScreen = True"										Wf)
			(write-line "objExcel.WindowState = -4143"												Wf)
			(write-line ""																			Wf)
			(write-line "' Porta la finestra in primo piano (Focus)"								Wf)
			(write-line "' AppActivate utilizza il titolo della finestra"							Wf)
			(write-line "objShell.AppActivate objExcel.Caption"										Wf)
			(write-line ""																			Wf)
			(write-line "Set objExcel = Nothing"													Wf)
			(write-line "Set objShell = Nothing"													Wf)
			(close Wf)
		)
	)
)
;
(defun MakeReadExcelVbs (FileVbs FileXls FileOut / Wf)

	(setq Wf (open FileVbs "W"))
	(if Wf
		(progn
			(write-line "' --- Configurazione Percorsi ---"												Wf)
			(write-line "Dim percorsoExcel, percorsoTesto"												Wf)
			(write-line (strcat "percorsoExcel = \"" FileXls "\"")										Wf)
			(write-line (strcat "percorsoTesto = \"" FileOut "\"")										Wf)
			(write-line "' --- Apertura Excel ---"														Wf)
			(write-line "Set objExcel = CreateObject(\"Excel.Application\")"							Wf)
			(write-line "Set objWorkbook = objExcel.Workbooks.Open(percorsoExcel)"						Wf)
			(write-line "Set objSheet = objWorkbook.Sheets(1)"											Wf)
			(write-line "'"																				Wf)
			(write-line "' --- Creazione File di Testo ---"												Wf)
			(write-line "Set objFSO = CreateObject(\"Scripting.FileSystemObject\")"						Wf)
			(write-line "Set objFile = objFSO.CreateTextFile(percorsoTesto, True)"						Wf)
			(write-line "'"																				Wf)
			(write-line "' 1. Identifica l'area utilizzata"												Wf)
			(write-line "Set objRange = objSheet.UsedRange"												Wf)
			(write-line "maxRighe = objRange.Rows.Count"												Wf)
			(write-line "maxColonne = objRange.Columns.Count"											Wf)
			(write-line "' 2. Carica tutti i dati in un array con un unico comando"						Wf)
			(write-line "' Questo è il modo più veloce in VBScript"										Wf)
			(write-line "arrDati = objRange.Value"														Wf)
			(write-line "' 3. Cicla l'array per leggere i valori"										Wf)
			(write-line "' Gli array da Excel partono sempre da indice 1"								Wf)
			(write-line "For r = 1 To maxRighe"															Wf)
			(write-line "   'rigaTesto = \"Riga \" & r & \": \""										Wf)
			(write-line "    rigaTesto = \"\""															Wf)
			(write-line "    For c = 1 To maxColonne"													Wf)
			(write-line "        ' Legge il valore dall'array (molto più rapido che da objSheet.Cells)"	Wf)
			(write-line "        rigaTesto = rigaTesto & arrDati(r, c) & \";\""							Wf)
			(write-line "    Next"																		Wf)
			(write-line "    ' Qui puoi elaborare la riga o scriverla su file"							Wf)
			(write-line "	objFile.WriteLine(rigaTesto)"												Wf)
			(write-line "    'WScript.Echo rigaTesto"													Wf)
			(write-line "Next"																			Wf)
			(write-line "'"																				Wf)
			(write-line "' --- Chiusura e Pulizia ---"													Wf)
			(write-line "objFile.Close"																	Wf)
			(write-line "objWorkbook.Close False"														Wf)
			(write-line "objExcel.Quit"																	Wf)
			(write-line "'"																				Wf)
			(write-line "Set objFile = Nothing"															Wf)
			(write-line "Set objFSO = Nothing"															Wf)
			(write-line "Set objSheet = Nothing"														Wf)
			(write-line "Set objWorkbook = Nothing"														Wf)
			(write-line "Set objExcel = Nothing"														Wf)
			(write-line "'"																				Wf)
			;(write-line "'MsgBox \"Esportazione completata in: \" & percorsoTesto"						Wf)
			(close Wf)
		)
	)
)
;
(defun MakeExcelToCsvVbs (FileVbs FileXls FileCsv / Wf)

	(setq Wf (open FileVbs "W"))
	(if Wf
		(progn
			(write-line "' Definisci i percorsi (usa percorsi assoluti)"											Wf)
			(write-line "Dim percorsoXlsx, percorsoCsv"																Wf)
			(write-line (strcat "percorsoXlsx = \"" FileXls "\"")													Wf)
			(write-line (strcat "percorsoCsv  = \"" FileCsv "\"")													Wf)
			(write-line "'"																							Wf)
			(write-line "Set objExcel = CreateObject(\"Excel.Application\")"										Wf)
			(write-line "objExcel.Visible = False"																	Wf)
			(write-line "objExcel.DisplayAlerts = False"															Wf)
			(write-line "'"																							Wf)
			(write-line "' --- CONFIGURAZIONE FORMATO NUMERICO ---"													Wf)
			(write-line "' Disabilita i separatori predefiniti di sistema di Windows"								Wf)
			(write-line "objExcel.UseSystemSeparators = False"														Wf)
			(write-line "'"																							Wf)
			(write-line "' Imposta il punto (.) come separatore decimale"											Wf)
			(write-line "objExcel.DecimalSeparator = \".\""															Wf)
			(write-line "'"																							Wf)
			(write-line "' Rimuove il separatore delle migliaia (stringa vuota)"									Wf)
			(write-line "objExcel.ThousandsSeparator = \"\""														Wf)
			(write-line "'"																							Wf)
			(write-line "objExcel.UseSystemSeparators = False"														Wf)
			(write-line "'"																							Wf)
			(write-line "'"																							Wf)
			(write-line "' Apri il file Excel"																		Wf)
			(write-line "Set objWorkbook = objExcel.Workbooks.Open(percorsoXlsx)"									Wf)
			(write-line "'"																							Wf)
			(write-line "' Salva in formato CSV (6 = xlCSV)"														Wf)
			(write-line "' I numeri verranno scritti come 1234.56 invece di 1.234,56"								Wf)
			(write-line "objWorkbook.SaveAs percorsoCsv, 6, , , , , , , , , , True"									Wf)
			(write-line "'"																							Wf)
			(write-line "' Ripristina le impostazioni originali e chiudi"											Wf)
			(write-line "objExcel.UseSystemSeparators = True"														Wf)
			(write-line "objWorkbook.Close False"																	Wf)
			(write-line "objExcel.Quit"																				Wf)
			(write-line "'"																							Wf)
			(write-line "Set objWorkbook = Nothing"																	Wf)
			(write-line "Set objExcel = Nothing"																	Wf)
			(write-line "'"																							Wf)
			(write-line "'MsgBox \"Conversione completata: punto decimale attivo e nessun separatore migliaia.\""	Wf)
			(close Wf)
		)
	)
)
;
(defun Dialog01ModifiedLstShapeExcel (LstShape LstButtonKey LstTypeValue LstDimButton / FileXls)

	(if (and LstShape LstButtonKey LstTypeValue)
		(progn
			(setq FileXls (strcat (getenv "LOCALAPPDATA") "\\EasyCut\\TmpFile.xlsx"))
			(if (ExportToExcelActiveX FileXls LstButtonKey LstShape LstTypeValue LstDimButton nil)
				(progn
					(EditExcelVbs  FileXls)
					(setq Rtn (ExcelToCsvVbs FileXls))
					(vl-file-delete FileXls)
				)
			)
		)
	)
	(if Rtn (cdr Rtn))
)

