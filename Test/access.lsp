(setq 	DBname   "C:\\EasyCut\\Test\\Mark3.mdb"
		TableName  "TABELLA"
		RecorSetName "(COMMESSA, FASE, MARCA, NOTICINE)"
		LstValue (list "a" "b" "c" "123FFFFF")
)

(setq 	DBname   "C:\\EasyCut\\Test\\Database2.mdb"
		TableName  "DRAWING"
		RecorSetName "(DATA1, DATA2, DATA3)"
		LstValue (list "a1" "b1" "c1")
)
;(WriteDataAccess 	DBname TableName RecorSetName LstValue)


;(setq 	FileAccess1 "C:\\EasyCut\\Test\\Order.mdb"
;		FileAccess2 "C:\\EasyCut\\Test\\Phase.mdb"
;		FileAccess3 "C:\\EasyCut\\Test\\Mark.mdb"
;		TableAccess1 "TableOrder"
;		TableAccess2 "TablePhase"
;		TableAccess3 "TableMark"
;		RecordAccess1 "(ORDER)"
;		RecordAccess2 "(ORDER, PHASE)"
;		RecordAccess3 "(ORDER, PHASE, MARK)"
;)
;(WriteDataAccess FileAccess1 TableAccess1 RecordAccess1 (list "C123"))
;(WriteDataAccess FileAccess2 TableAccess2 RecordAccess2 (list "C123" "SUB1"))
;(WriteDataAccess FileAccess3 TableAccess3 RecordAccess3 (list "C123" "SUB1" "MK100"))
;
(defun WriteDataAccess 	(DBname TableName RecorSetName LstValue /	ADOcn ADOrst  
																	Fieldvalues	SQLstr
						)

				
	(vl-load-com)
	(defun sql-parse-list (rowlist)
		(vl-princ-to-string
			(append
				(mapcar (function	(lambda	(x)	(vl-string-subst x x (strcat "'" x "'" ", "))))
						(reverse (cdr (reverse rowlist)))
				)
				(list 	(vl-string-subst
							(last rowlist)
							(last rowlist)
							(strcat "'" (last rowlist) "'")
						)
				)
			)
		)
	)

	;
	; MAIN
	;
	(setq FieldValues (sql-parse-list LstValue))
	(setq ADOcn  (vlax-create-object "ADODB.Connection"))
	(setq ADOrst (vlax-create-object "ADODB.Recordset"))
	(vlax-invoke-method
					ADOcn
					"Open"
					(strcat	"Driver={Microsoft Access Driver (*.mdb)}; DBQ=" DBname)
					T T	T
	)
	
	(setq SQLstr (strcat "INSERT INTO " TableName " " RecorSetName " VALUES " FieldValues))

	;					"INSERT INTO DRAWING_PROPERTIES (REVISION_DATE, FOLDER, DRAWING, LOGINNAME) VALUES "
	
	
	(vl-catch-all-apply
		(function 	(lambda ()
						(vlax-invoke-method
						ADOrst "Open" SQLstr ADOcn -1 3 1)
					)
		)
	)

	(vlax-invoke-method ADOcn "Close")
	
	(mapcar (function 	(lambda (x)
							(vl-catch-all-apply
								(function 	(lambda ()
												(progn
													(vlax-release-object x)
													(setq x nil)
												)
											)
								)
							)
						)
			)
			(list ADOrst ADOcn)
	)
	(gc)
	(princ)
)
;
;
;
(defun WriteAcess 	(/	ADOcn	ADOrst DBname 
						Fieldvalues	RevDate RowData SQLstr
					)

	;tabella 	DRAWING_PROPERTIES
	;dati		REVISION_DAT	stringa
	;			FOLDER			stringa
	;			DRAWING			stringa
	;			LOGINNAME		stringa
				
	(vl-load-com)
	(defun sql-parse-list (rowlist)
		(vl-princ-to-string
			(append
				(mapcar (function	(lambda	(x)	(vl-string-subst x x (strcat "'" x "'" ", "))))
						(reverse (cdr (reverse rowlist)))
				)
				(list 	(vl-string-subst
							(last rowlist)
							(last rowlist)
							(strcat "'" (last rowlist) "'")
						)
				)
			)
		)
	)

	;
	; MAIN
	;
	(setq	RevDate	(rtos (getvar "cdate") 2 6)
			RevDate	(strcat
						(substr RevDate 5 2)
						"/"
						(substr RevDate 7 2)
						"/"
						(substr RevDate 1 4)
						","
						(substr RevDate 10 2)
						":"
						(substr RevDate 12 2)
					)
	)

	(setq	RowData	(list RevDate
						(getvar "dwgprefix")
						(getvar "dwgname")
						(getvar "loginname")
					)
	)

	(setq FieldValues (sql-parse-list RowData))
	(setq	DBname (findfile
						(getfiled "Select an Access File"
							(getvar "dwgprefix")
							"mdb"
							8
						)
					)
	)
	(setq ADOcn  (vlax-create-object "ADODB.Connection"))
	(setq ADOrst (vlax-create-object "ADODB.Recordset"))
	(vlax-invoke-method
					ADOcn
					"Open"
					(strcat	"Driver={Microsoft Access Driver (*.mdb)}; DBQ=" DBname)
					T T	T
	)
	(setq	SQLstr
			(strcat
					"INSERT INTO DRAWING_PROPERTIES (REVISION_DATE, FOLDER, DRAWING, LOGINNAME) VALUES " FieldValues
			)
	)
	(vl-catch-all-apply
		(function 	(lambda ()
						(vlax-invoke-method
						ADOrst "Open" SQLstr ADOcn -1 3 1)
					)
		)
	)

	(vlax-invoke-method ADOcn "Close")
	
	(mapcar (function 	(lambda (x)
							(vl-catch-all-apply
								(function 	(lambda ()
												(progn
													(vlax-release-object x)
													(setq x nil)
												)
											)
								)
							)
						)
			)
			(list ADOrst ADOcn)
	)
	(gc)
	(princ)
)
;
;
;
(defun ReadAccess (/ ADOcn ADOrst DBname RowData SQLstr tblName)
		
		(setq 	DBname (getfiled "Select an Access Database File" (getvar "dwgprefix") "mdb" 4)

				ADOcn  (vlax-create-object "ADODB.Connection")
				ADOrst (vlax-create-object "ADODB.Recordset")
		)
		(vlax-invoke-method	ADOcn
							"Open"
							(strcat "Driver={Microsoft Access Driver (*.mdb)}; DBQ=" DBname)
							T T T
		)
		(setq tblName (getstring T "\nEnter name of the data table :"))

		(setq SQLstrRead (strcat " SELECT * FROM " tblName ";"))
		(vlax-invoke-method ADOrst "Open" SQLstrRead ADOcn -1 3 1)
		(setq RowData (vlax-invoke-method ADOrst "GetRows" T))
		(setq TableData (apply 'mapcar 	(cons 'list (mapcar (function
																(lambda (x)
																	(mapcar (function 	(lambda (y)
																							(vlax-variant-value y)
																						)
																			)
																			x
																	)
																)
															)
															(vlax-safearray->list (vlax-variant-value RowData))
													)
										)
						)
		)
		(vlax-invoke-method ADOrst "Close")
		(vlax-invoke-method ADOcn "Close")
		(mapcar (function (lambda (x) 	(vl-catch-all-apply (function (lambda ()
																		(progn
																			(vlax-release-object x)
																			(setq x nil)
																		)
																	)
															)
										)
							)
				)
			(list ADOrst ADOcn)
		)
		(gc)
		TableData
)

; TesT :
(defun C:test()
(setq data (ard))
(princ data)
(princ)
)
