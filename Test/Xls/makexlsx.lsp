(defun Test (/ FileXls Af)
	(setq FileXls "C:\\EasyCutNesting Beta\\Test\\Xls\\TuoFile.xlsx")
	(if (findfile FileXls) (vl-file-delete FileXls))
	
	(ExportToExcel FileXls nil)
	(ExcelAndBack)
	(alert "excel editato")
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

(defun ExcelAndBack ( / excelApp workbook shell acadApp)
  (vl-load-com)
  (setq path "C:\\EasyCutNesting Beta\\Test\\Xls\\TuoFile.xlsx") ;; MODIFICA IL PERCORSO

  (if (findfile path)
    (progn
      (setq acadApp (vlax-get-acad-object))
      (setq excelApp (vlax-get-or-create-object "Excel.Application"))
      
      ;; 1. Apri Excel e portalo in primo piano
      (vla-put-visible excelApp :vlax-true)
      (setq workbook (vlax-invoke-method (vlax-get-property excelApp 'Workbooks) 'Open path))
      (vla-put-windowstate acadApp acMin) ;; Minimizza AutoCAD

      (princ "\nIn attesa della chiusura di Excel...")

      ;; 2. LOOP DI ATTESA
      ;; Il LISP "dorme" finché il file Excel risulta aperto
      (while (and workbook (not (vlax-erased-p workbook)))
        (vl-catch-all-apply 
          '(lambda () 
             ;; Se workbook.Saved genera errore, significa che è stato chiuso
             (vlax-get-property workbook 'Saved)
           )
        )
        ;; Piccolo ritardo per non sovraccaricare la CPU (mezzo secondo)
        (command "_.DELAY" 500) 
      )

      ;; 3. RITORNO IN AUTOCAD
      (vla-put-windowstate acadApp acMax) ;; Massimizza AutoCAD
      (setq shell (vlax-create-object "WScript.Shell"))
      (vlax-invoke-method shell 'AppActivate (getvar "PROGRAM"))
      
      (vlax-release-object shell)
      (vlax-release-object excelApp)
      (princ "\nBentornato in AutoCAD!")
    )
    (princ "\nFile non trovato.")
  )
  (princ)
)



(defun ApriExcelFocus ( / excelApp workbook shell hwnd)
  (vl-load-com)
  (setq path "C:\\EasyCutNesting Beta\\Test\\Xls\\TuoFile.xlsx") ;; MODIFICA QUI

  (if (findfile path)
    (progn
      ;; Connetti a Excel
      (setq excelApp (vlax-get-or-create-object "Excel.Application"))
      (vla-put-visible excelApp :vlax-true)
      
      ;; Apri il file
      (setq workbook (vlax-invoke-method 
                       (vlax-get-property excelApp 'Workbooks) 
                       'Open path))

      ;; RECUPERA L'IDENTIFICATIVO DELLA FINESTRA (HWND)
      ;; Questo permette di puntare alla finestra esatta di Excel
      (setq hwnd (vlax-get-property excelApp 'HWND))

      ;; FORZA IL PRIMO PIANO
      (setq shell (vlax-create-object "WScript.Shell"))
      ;; AppActivate può accettare l'ID della finestra invece del titolo
      (vlax-invoke-method shell 'AppActivate hwnd)
      
      (vlax-release-object shell)
      (vlax-release-object excelApp)
      (princ "\nExcel portato in primo piano con successo.")
    )
    (princ "\nErrore: Percorso file non valido.")
  )
  (princ)
)




;
;
;
(defun CreaExcel ( / xlApp xlBook xlSheet xlCells)
  
  ; Tenta di connettersi a un'istanza esistente o ne crea una nuova
  (setq xlApp (vlax-get-or-create-object "Excel.Application"))
  
  (if xlApp
    (progn
      (vla-put-visible xlApp :vlax-true) ; Rendi Excel visibile
      
      (vlax-put-property xlApp 'DisplayFullScreen :vlax-true) ; Nasconde Ribbon e Barre
      ;(vlax-put-property xlApp 'DisplayFormulaBar :vlax-false) ; Nasconde barra formula
      ;(vlax-put-property xlApp 'DisplayStatusBar :vlax-false)   ; Nasconde barra stato

      ; Aggiungi un nuovo Workbook e seleziona il primo foglio
      (setq xlBook  (vlax-invoke-method (vlax-get-property xlApp 'Workbooks) 'Add)
            xlSheet (vlax-get-property xlBook 'ActiveSheet)
            xlCells (vlax-get-property xlSheet 'Cells))
      
      ; Scrittura nelle celle: Item(riga, colonna)
	  
      (vlax-put-property (vlax-variant-value (vlax-get-property xlCells 'Item 1 1)) 'Value2 "Nome")
      (vlax-put-property (vlax-variant-value (vlax-get-property xlCells 'Item 1 2)) 'Value2 "Coordinata X")
      (vlax-put-property (vlax-variant-value (vlax-get-property xlCells 'Item 2 1)) 'Value2 "Punto 1")
      (vlax-put-property (vlax-variant-value (vlax-get-property xlCells 'Item 2 2)) 'Value2 250.5)

      (princ "\nFile Excel creato con successo.")
	  ;(vla-put-visible xlApp :vlax-true)
	  ;(vlax-put-property xlApp 'WindowState -4137)
	  
	  ;(setq shell (vlax-create-object "WScript.Shell"))
      ;(vlax-invoke-method shell 'AppActivate "Microsoft Excel")
      ;(vlax-release-object shell)
    )
    (princ "\nErrore: Impossibile avviare Excel.")
  )
  (princ)
)
(defun ExcelInPrimoPiano ( / xlApp shell )

  (setq xlApp (vlax-get-or-create-object "Excel.Application"))
  
  (if xlApp
    (progn
      ; 1. Rendi visibile e massimizza
      (vla-put-visible xlApp :vlax-true)
      (vlax-put-property xlApp 'WindowState -4137)
      
      ; 2. Forza il focus in primo piano
      (setq shell (vlax-create-object "WScript.Shell"))
      (vlax-invoke-method shell 'AppActivate "Microsoft Excel")
      (vlax-release-object shell)
      
      (princ "\nExcel è ora in primo piano.")
    )
    (princ "\nExcel non è in esecuzione.")
  )
  (princ)
)

(defun c:ExcelMinimal ( / xlApp )
  (vl-load-com)
  (setq xlApp (vlax-get-or-create-object "Excel.Application"))
  
  (if xlApp
    (progn
      (vla-put-visible xlApp :vlax-true)
      
      ; --- RIDUZIONE MENU ---
      (vlax-put-property xlApp 'DisplayFullScreen :vlax-true) ; Nasconde Ribbon e Barre
      (vlax-put-property xlApp 'DisplayFormulaBar :vlax-false) ; Nasconde barra formula
      (vlax-put-property xlApp 'DisplayStatusBar :vlax-false)   ; Nasconde barra stato
      
      ; Aggiungi un foglio per vedere il risultato
      (vlax-invoke-method (vlax-get-property xlApp 'Workbooks) 'Add)
      
      (princ "\nExcel caricato con interfaccia ridotta.")
    )
    (princ "\nErrore: Excel non trovato.")
  )
  (princ)
)

