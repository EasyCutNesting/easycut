(defun IsProcessExcelActive (/ obj)
	(setq obj (vlax-get-object "Excel.Application"))
	(if obj
		(progn 
			(vlax-release-object obj) 
			T
		)
		nil
	)
)
;
(defun OpenExcel (Exfile / res)
	(if (findfile Exfile)
		(progn
			(SetExcelValue)
			(setq ProcessExcelActive$ (IsProcessExcelActive))
			(setq MyXL$ (vlax-get-or-create-object "Excel.Application"))
			(if MyXL$
				(progn
					(setq VisibleProcess$ (vlax-get-property MyXL$ 'Visible))
					(setq AlertProcess$   (vlax-get-property MyXL$ 'DisplayAlerts))
					(vlax-put-property MyXL$ 'Visible       :vlax-false)
					(vlax-put-property MyXL$ 'DisplayAlerts :vlax-false)
					(setq res (vl-catch-all-apply 'vla-open	(list (vlax-get-property MyXL$ "WorkBooks") Exfile)))
					(if (vl-catch-all-error-p res)
						(progn
							(princ (strcat "\nErrore apertura: " (vl-catch-all-error-message res)))
							(setq MyBook$ nil)
							(CloseExcel)
							nil
						)
						(setq MyBook$ res)
					)
				)
			)
		)
	)
)
;
(defun CloseExcel ()
	(if MyBook$
		(vl-catch-all-apply 'vlax-invoke-method (list MyBook$ "Close" :vlax-false))
	)
	(if MyXL$
		(if (not ProcessExcelActive$)
			(vl-catch-all-apply 'vlax-invoke-method (list MyXL$ "Quit"))
			(progn
				(vl-catch-all-apply 'vlax-put-property (list MyXL$ 'Visible VisibleProcess$))
				(vl-catch-all-apply 'vlax-put-property (list MyXL$ 'DisplayAlerts AlertProcess$))
			)
		)
	)
	(if (and MySheet$  (= (type MySheet$)  'VLA-OBJECT)) (vlax-release-object MySheet$))
	(if (and MyBook$   (= (type MyBook$)   'VLA-OBJECT)) (vlax-release-object MyBook$))
	(if (and MyXL$     (= (type MyXL$)     'VLA-OBJECT)) (vlax-release-object MyXL$))
	(SetExcelValue)
	(gc)
)
;
(defun GetCell (Cell / MyRange val)
	(setq MyCell$ nil)
	(if (and Cell MySheet$)
		(progn
			(setq MyRange (vlax-get-property MySheet$ 'Range Cell))
			(setq val (vlax-variant-value (vlax-get-property MyRange 'Value2)))
			(vlax-release-object MyRange)
			(setq MyCell$ val)
		)
	)
	MyCell$
)
;
(defun ReadCells (LstColl LstRow / Rtn LstTmp Row Coll)
	(if (and LstColl LstRow MySheet$)
		(foreach Row LstRow
			(setq LstTmp nil)
			(foreach Coll LstColl
				(setq LstTmp
					(cons (if (/= Coll "N.D.") (GetCell (strcat Coll Row)) nil)	LstTmp)
				)
			)
			(setq Rtn (cons (reverse LstTmp) Rtn))
		)
	)
	(reverse Rtn)
)
;
(defun GetLastRow (Coll / MaxRow Rng Last)
	;; Ultima riga con un valore nella colonna indicata (es. "B"). Ritorna 0 se vuota.
	(setq MaxRow (vlax-get-property (vlax-get-property MySheet$ 'Rows) 'Count))
	(setq Rng    (vlax-get-property MySheet$ 'Range (strcat Coll (itoa MaxRow))))
	(setq Last   (vlax-get-property (vlax-get-property Rng 'End -4162)   ; xlUp = -4162
                 'Row)
	)
	(vlax-release-object Rng)
	;; se la colonna è completamente vuota, End(xlUp) arriva a riga 1:
	;; controllo che A1 sia davvero piena
	(if (and (= Last 1)
			(null (vlax-variant-value (vlax-get-property (vlax-get-property MySheet$ 'Range (strcat Coll "1")) 'Value2)))
		)
		0
		Last
	)
)
;
(defun GetColumn (Coll StartRow EndRow Typ / Rng Val Rtn)
	;; Legge una colonna da StartRow fino a EndRow (se EndRow è nil usa l'ultima riga piena).
	;; Ritorna una lista di valori (nil per le celle vuote).
	(if (null EndRow) (setq EndRow (GetLastRow Coll)))
	(if (and MySheet$ (>= EndRow StartRow))
		(progn
			(setq Rng (vlax-get-property MySheet$ 'Range (strcat Coll (itoa StartRow) ":" Coll (itoa EndRow))))
			(setq Val (vlax-variant-value (vlax-get-property Rng 'Value2)))
			(vlax-release-object Rng)
			(setq Rtn
				(if (= (type Val) 'SAFEARRAY)
					(mapcar '(lambda (r) (ConvVal (CleanVal (car r)) Typ))
							(vlax-safearray->list Val))
					(list (ConvVal (CleanVal Val) Typ))
				)
			)
		)
	)
	Rtn
)
;
(defun CleanVal (v / res)
	(cond
		((= (type v) 'VARIANT)
			(if (member (vlax-variant-type v) '(0 1 10))   ; empty, null, error
				nil
				(progn
					(setq res (vl-catch-all-apply 'vlax-variant-value (list v)))
					(if (vl-catch-all-error-p res) nil (CleanVal res))
				)
			)
		)
		((member v '(:vlax-null :vlax-empty))
			nil
		)
		(T 
			v
		)
	)
)
;
(defun ConvVal (v Typ)
	(cond
		((or (null v) (null Typ))
			v
		)
		((= Typ "STR")
			(cond 
				((= (type v) 'STR)  v)
					((numberp v)       (rtos v 2 8)   ; 5.0 -> "5", 2.5 -> "2.5"
				)
				(T
					(vl-princ-to-string v)
				)
			)
		)
		((= Typ "INT")
			(cond ((= (type v) 'INT)  v)
				((= (type v) 'REAL) 
					(fix (+ v (if (minusp v) -0.5 0.5)))  ; arrotonda
				)
				((= (type v) 'STR)  
					(atoi v)
				)
				(T 
					nil
				)
			)
		)
		((= Typ "REAL")
			(cond 
				((= (type v) 'REAL) 
					v
				)
				((= (type v) 'INT)  
					(float v)
				)
				((= (type v) 'STR)  
					(atof (vl-string-translate "," "." v))  ; "1,5" -> 1.5
				)
				(T 
					nil
				)
			)
		)
		(T
			v
		)
	)
)
;
(defun MakeNilList (n / l) (repeat n (setq l (cons nil l))) l)
;
(defun ReadColumns (LstColl LstType StartRow / Rtn Last Cols Typs Coll Col)
	(setq Rtn nil)
	(if (and LstColl MySheet$)
		(progn
			(setq Last 0)
			(foreach Coll LstColl
				(if (/= Coll "N.D.") (setq Last (max Last (GetLastRow Coll))))
			)
			(if (>= Last StartRow)
				(progn
					(setq Typs LstType)
					(foreach Coll LstColl
						(setq Col
							(if (/= Coll "N.D.")
								(GetColumn Coll StartRow Last (car Typs))
								(MakeNilList (1+ (- Last StartRow)))
							)
						)
						(setq Cols (append Cols (list Col)))
						(setq Typs (cdr Typs))
					)
					;; trasposizione: da lista di colonne a lista di righe
					(setq Rtn (apply 'mapcar (cons 'list Cols)))
				)
			)
		)
	)
	Rtn
)
;
(defun Test (/ ExcelFile res)
  (setq ExcelFile "C:\\Users\\adl20\\Desktop\\EasyCutNesting Beta\\Test\\MergeInfo.xlsx")
  (if (findfile ExcelFile)
    (progn
      (OpenExcel ExcelFile)
      (if MyBook$
        (progn
          (setq res
            (vl-catch-all-apply
              '(lambda ()
                 (if (member "Foglio1" (GetListSheet))
                   (progn
                     (ActiveSheet "Foglio1")
					 (setq Tabella (ReadColumns '("A" "B" "C") '("STR" "STR" "STR") 1))
                     ;(GetCell "B4")
                     ;(PrintExcelValue)
                   )
                   (princ "\nFoglio1 non trovato.")
                 )
               )
            )
          )
          (if (vl-catch-all-error-p res)
            (princ (strcat "\nErrore: " (vl-catch-all-error-message res)))
          )
          (CloseExcel)
        )
      )
    )
    (princ "\nFile non trovato.")
  )
  (princ)
)
;
(defun UpDateQuantityImportDxf (FileXls Sheet LstColumns TypeValue / ReadTabExcel CheckUniqValue BuildTab
																	 Tab NewTab SselBom LstBom itm obj
																	 NameShape Record Order Phase Qta Tk Mat)

	; es (UpDateQuantityImportDxf "C:\\Users\\adl20\\Desktop\\EasyCutNesting Beta\\Test\\MergeInfo.xlsx" "Foglio1" '("A" "B" "C" "D" "E" "F") '("STR" "STR" "STR" "INT" "REAL" "STR"))

	; LstColumns	TypeValue
	; A Order		Str
	; B Phase		Str
	; C Name		Str
	; D Qty			Int
	; E Tk			Real
	; F Mat			Str
	(defun CheckUniqValue (Tabella / Rtn LstCheck Val)
		(setq Rtn T)
		(while (and Rtn Tabella)
			(setq Val (caddr (car Tabella)))
			(if (member Val LstCheck)
				(setq Rtn nil)
				(setq LstCheck (cons Val LstCheck))
			)
			(setq Tabella (cdr Tabella))
		)
		Rtn
	)
	;
	(defun ReadTabExcel (FileXls Sheet LstColumns TypeValue / res Tabella)
		(if (and FileXls (findfile FileXls) Sheet)
			(progn
				(OpenExcel FileXls)
				(if MyBook$
					(progn
						(setq res
							(vl-catch-all-apply
								'(lambda ()
									(if (member Sheet (GetListSheet))
										(progn
											(ActiveSheet Sheet)
											(ReadColumns LstColumns TypeValue 1)
										)
										(progn (princ (strcat "\n" Sheet " non trovato.")) nil)
									)
								)
							)
						)
						(CloseExcel)
						(if (vl-catch-all-error-p res)
							(princ (strcat "\nErrore: " (vl-catch-all-error-message res)))
							(setq Tabella res)
						)
					)
				)
			)
			(princ "\nFile non trovato.")
		)
		Tabella
	)
	;
	(defun BuildTab (Tab / itm Rtn)
		;; riordina: (Order Phase Name Qty Tk Mat) -> (Name Order Phase Qty Tk Mat)
		(foreach itm Tab
			(setq Rtn (cons (list (nth 2 itm) (nth 0 itm) (nth 1 itm)
								  (nth 3 itm) (nth 4 itm) (nth 5 itm))
							Rtn))
		)
		(reverse Rtn)
	)
	;
	; Main ++++
	;
	(setq Tab (ReadTabExcel FileXls Sheet LstColumns TypeValue))
	(if (and Tab (CheckUniqValue Tab))
		(progn
			(setq NewTab (BuildTab Tab))
			(setq SselBom (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShapeTarget)))))
			(if SselBom
				;   tag IDSHAPE
				;   tag ORDERSHAPE
				;   tag PHASESHAPE
				;   tag MKSHAPE
				;   tag TKSHAPE
				;   tag LENGTHSHAPE
				;   tag HEIGHTSHAPE
				;   tag MATSHAPE
				;   tag LASTMODIFYSHAPE
				;   tag PERIMETERSHAPE
				;   tag WEIGTHSHAPE
				;   tag TYPESHAPE
				;   tag JOUSHAPE
				;   tag COMPSHAPE
				;   tag TIMECUTSHAPE
				;   tag QTASHAPE
				(progn
					(setq LstBom (LM:ss->ent SselBom))
					(foreach itm LstBom
						(setq obj       (vlax-ename->vla-object itm))
						(setq NameShape (LM:vl-getattributevalue obj "MKSHAPE"))
						(setq Record    (assoc NameShape NewTab))
						(if Record
							(progn
								(setq Order (nth 1 Record)
									  Phase (nth 2 Record)
									  Qta   (nth 3 Record)
									  Tk    (nth 4 Record)
									  Mat   (nth 5 Record)
								)
								(LM:vl-setattributevalue obj "ORDERSHAPE" (if Order Order ""))
								(LM:vl-setattributevalue obj "PHASESHAPE" (if Phase Phase ""))
								(LM:vl-setattributevalue obj "QTASHAPE"   (if Qta  (LM:Rtos Qta 2 0) ""))
								(LM:vl-setattributevalue obj "TKSHAPE"    (if Tk   (LM:Rtos Tk 2 1) ""))
								(LM:vl-setattributevalue obj "MATSHAPE"   (if Mat  Mat ""))
							)
							(princ (strcat "\nNon trovato in Excel: " (vl-princ-to-string NameShape)))
						)
					)
				)
				(princ "\nNessun blocco trovato.")
			)
		)
		(princ "\nTabella vuota o nomi duplicati: aggiornamento annullato.")
	)
	(princ)
)	
;	
	
	