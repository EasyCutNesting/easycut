(defun Test ()
	(setq FileXls "C:\\EasyCutNesting Beta\\Test\\Xls\\TuoFile.xlsx")
	(ExportToExcel FileXls T)
)

(defun ExportToExcel (FileXls Visible / xlApp xlBook xlSheet row)
	;; Inizializza l'applicazione Excel
	(setq xlApp (vlax-get-or-create-object "Excel.Application"))
	(if xlApp
		(progn
			(if Visible
				(vla-put-visible xlApp :vlax-true)
				(vla-put-visible xlApp :vlax-false)
			)
			;; Crea una nuova cartella di lavoro
			(setq xlBook (vlax-invoke (vlax-get-property xlApp "Workbooks") "Add"))
			(setq xlSheet (vlax-get-property xlBook "ActiveSheet"))
  
			;; Esempio: Scrivere dati in alcune celle
			(vlax-put-property (vlax-get-property xlSheet "Range" "A1") "Value2" "ID")
			(vlax-put-property (vlax-get-property xlSheet "Range" "B1") "Value2" "Coordinate")
			(vlax-put-property (vlax-get-property xlSheet "Range" "A2") "Value2" 1)
			(vlax-put-property (vlax-get-property xlSheet "Range" "B2") "Value2" "10,20,0")
  
			;; Salva il file (specificare percorso completo)
			(vlax-invoke xlBook "SaveAs" FileXls)
			;; Chiudi e pulisci
			(vlax-invoke xlBook "Close" :vlax-false)
			(vlax-invoke xlApp "Quit")
			(vlax-release-object xlSheet)
			(vlax-release-object xlBook)
			(vlax-release-object xlApp)
			(princ "\nDati esportati in Excel.")
			T
		)
		(progn
			(princ "\nExcel non installato")
			nil
		)
	)
)
