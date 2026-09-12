; Download SQLITELSP
;http://www.theswamp.org/index.php?topic=28286.0
;---------------------------------------------------------------------------------------------------------------------------------------------
;(setq DbFileShape$ 		(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\SqLite\\Shape.db")) ;DB SQL
;---------------------------------------------------------------------------------------------------------------------------------------------
(setq MaxCharDxfDb$				1024)
(setq TableInfoShape$ 			"INFOSHAPE")
(setq LstTagInfoShape$			(list 	"IDSHAPE" "ORDERSHAPE" "PHASESHAPE" "FAMILYSHAPE" "MARKSHAPE" "QUANTITYSHAPE" "NAMESHAPE" "MATERIALSHAPE"
										"THIKNESSSHAPE" "LENGTHSHAPE" "WIDTHSHAPE" "CUTSHAPE" "DATESHAPE" "FLAG1SHAPE" "FLAG2SHAPE" "FLAG3SHAPE"))
(setq LstTypeInfoShape$			(list 	"char(64)" "char(64)" "char(64)" "char(64)" "char(64)" "int" "char(64)" "char(64)"
										"float" "float" "float" "int" "char(64)" "char(64)" "char(64)" "char(64)"))
;---------------------------------------------------------------------------------------------------------------------------------------------
(setq TableExShape$ 			"OUTSHAPE")
(setq LstTagExShape$			(list 	"IDSHAPE" "DXFLISTSHAPE" "EXTENDEDDATA"))
(setq LstTypeExShape$			(list 	"char(64)" "char(1024)" "char(1024)"))
(setq TableInShape$ 			"INSHAPE")									
(setq LstTagInShape$			(list 	"IDSHAPE" "IDSHAPEIN" "DXFLISTSHAPE" "EXTENDEDDATA"))
(setq LstTypeInShape$			(list 	"char(64)" "char(64)" "char(1024)" "char(1024)"))
;---------------------------------------------------------------------------------------------------------------------------------------------
(setq TableInTrigger$ 			"TRIGGERINSHAPE")									
(setq LstTagInTrigger$			(list 	"IDSHAPE" "IDTRIGGER" "DXFLISTTRIGGER" "EXTENDEDDATA"))
(setq LstTypeInTrigger$			(list 	"char(64)" "char(64)" "char(1024)" "char(1024)"))
(setq TableOutTrigger$ 			"TRIGGEROUTSHAPE")									
(setq LstTagOutTrigger$			(list 	"IDSHAPE" "IDTRIGGER" "DXFLISTTRIGGER" "EXTENDEDDATA"))
(setq LstTypeOutTrigger$		(list 	"char(64)" "char(64)" "char(1024)" "char(1024)"))
;----------------------------------------------------------------------------------------------------------------------------------------------
(setq TableInfoSheet$ 			"INFOSHEET")
(setq LstTagInfoSheet$			(list 	"IDSHEET" "NAMESHEET" "WIDTHSHEET" "HEIGHTSHEET" "THICKSHEET" "SURFACESHEET" "WEIGHTSHEET" "MATERIALSHEET"))
(setq LstTypeInfoSheet$			(list 	"char(64)" "char(64)" "float" "float" "float" "float" "float" "char(64)"))
;----------------------------------------------------------------------------------------------------------------------------------------------
(setq TableExSheet$ 			"OUTSHEET")
(setq LstTagExSheet$			(list 	"IDSHEET" "DXFLISTSHAPE" "EXTENDEDDATA"))
(setq LstTypeExSheet$			(list 	"char(64)" "char(1024)" "char(1024)"))
(setq TableInSheet$ 			"INSHEET")
(setq LstTagInSheet$			(list 	"IDSHEET" "DXFLISTSHAPE" "EXTENDEDDATA"))
(setq LstTypeInSheet$			(list 	"char(64)" "char(1024)" "char(1024)"))
;----------------------------------------------------------------------------------------------------------------------------------------------
(setq TableInfoShapeOnSheet$ 	"INFOSHAPEONSHEET")
(setq LstTagInfoShapeOnSheet$	(list 	"IDSHEET" "IDSHAPE" "ORDERSHAPE" "PHASESHAPE" "MARKSHAPE" "NAMESHAPE" "MATERIALSHAPE"
								        "THICKSHAPE" "LENGTHSHAPE" "WIDTHSHAPE" "CUTSHAPE" "DATESHAPE"))
(setq LstTypeInfoShapeOnSheet$	(list   "char(64)" "char(64)" "char(64)" "char(64)" "char(64)" "char(64)" "char(64)"
								        "float" "float" "float"  "int"  "char(64)"))
;----------------------------------------------------------------------------------------------------------------------------------------------
(setq TableExShapeOnSheet$ 		"OUTSHAPEONSHEET")
(setq LstTagExShapeOnSheet$		(list 	"IDSHEET" "IDSHAPE" "DXFLISTSHAPE" "EXTENDEDDATA"))
(setq LstTypeExShapeOnSheet$	(list 	"char(64)" "char(64)" "char(1024)" "char(1024)"))
(setq TableInShapeOnSheet$ 		"INSHAPEONSHEET")									
(setq LstTagInShapeOnSheet$		(list 	"IDSHEET" "IDSHAPE" "IDSHAPEIN" "DXFLISTSHAPE" "EXTENDEDDATA"))
(setq LstTypeInShapeOnSheet$	(list 	"char(64)" "char(64)" "char(64)" "char(1024)" "char(1024)"))
;----------------------------------------------------------------------------------------------------------------------------------------------
(setq TableInTriggerOnSheet$ 	"TRIGGERINSHAPE")									
(setq LstTagInTriggerOnSheet$	(list 	"IDSHEET" "IDSHAPE" "IDTRIGGER" "DXFLISTTRIGGER" "EXTENDEDDATA"))
(setq LstTypeInTriggerOnSheet$	(list 	"char(64)" "char(64)" "char(64)" "char(1024)" "char(1024)"))
(setq TableOutTriggerOnSheet$ 	"TRIGGEROUTSHAPE")									
(setq LstTagOutTriggerOnSheet$	(list 	"IDSHEET" "IDSHAPE" "IDTRIGGER" "DXFLISTTRIGGER" "EXTENDEDDATA"))
(setq LstTypeOutTriggerOnSheet$	(list 	"char(64)" "char(64)" "char(64)" "char(1024)" "char(1024)"))
;----------------------------------------------------------------------------------------------------------------------------------------------
;									
;
;
(defun LoadRuntimeSqLiteLsp (/ AcadPlatform Path FN)

	(defun AcadPlatform (/ proc_arch str)
		(if (and (setq proc_arch (getenv "PROCESSOR_ARCHITECTURE"))
				 (< 1 (strlen proc_arch))
				 (eq "64" (substr proc_arch (1- (strlen proc_arch))))
			)
			(setq str "x64")
			(setq str "x32")
		)
		str
	)
	;
	;
	;
	(setq Path (vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
	(setq FN (findfile (strcat Path "\\SqLite\\SQLiteLsp\\SQLiteBin\\SQLiteLsp"
                          (substr (getvar "acadver") 1 2)
                          (AcadPlatform)
                          ".ARX"
                       )
			)
	)
	(arxload FN (strcat "\nError loading " FN))
)
;
;
;
(defun UnLoadRuntimeSqLiteLsp (/ AcadPlatform Path FN)

	(defun AcadPlatform (/ proc_arch str)
		(if (and (setq proc_arch (getenv "PROCESSOR_ARCHITECTURE"))
				 (< 1 (strlen proc_arch))
				 (eq "64" (substr proc_arch (1- (strlen proc_arch))))
			)
			(setq str "x64")
			(setq str "x32")
		)
		str
	)
	;
	;
	;
	(setq Path (vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
	(setq FN (findfile (strcat Path "\\SqLite\\SQLiteLsp\\SQLiteBin\\SQLiteLsp"
                          (substr (getvar "acadver") 1 2)
                          (AcadPlatform)
                          ".ARX"
                       )
			)
	)
	(arxunload FN (strcat "\nError unloading " FN))
)
;
;
;
(defun CreateDbase (DbFileName)
	
	(if DbFileName
		(progn
			(if (findfile DbFileName) (vl-file-delete DbFileName))
			(Dsql_Open  DbFileName)
			(Dsql_Close DbFileName)
		)
	)
)
;
;
;
(defun CreateTableDbase (DbFileName TblName LstTagName LstTypeData / Num ActionString)
	
	(if (and DbFileName TblName LstTagName LstTypeData)
		(progn
			(Dsql_Open DbFileName)
				(setq Num 0)
				(setq ActionString "")
				(repeat (length LstTagName)
					(if (= (1+ Num) (length LstTagName)) 
						(setq ActionString (strcat ActionString (nth Num LstTagName) " " (nth Num LstTypeData)))
						(setq ActionString (strcat ActionString (nth Num LstTagName) " " (nth Num LstTypeData) ", "))
					)
					(setq Num (1+ Num))
				)
				(setq ActionString (strcat "CREATE TABLE " TblName " (" ActionString ");"))
				(Dsql_Dml DbFileName ActionString)
			(Dsql_Close DbFileName)
		)
	)
)
;
;
;
(defun ResetFileDbSheet (DbFileName)
	(if DbFileName
		(progn
			(CreateDbase DbFileName)
			(CreateTableDbase DbFileName TableInfoSheet$         LstTagInfoSheet$          LstTypeInfoSheet$)		  ;-> WriteInfoSheet
			(CreateTableDbase DbFileName TableExSheet$           LstTagExSheet$            LstTypeExSheet$)			  ;-> WriteDataSheet 
			(CreateTableDbase DbFileName TableInSheet$           LstTagInSheet$            LstTypeInSheet$)			  ; null
			(CreateTableDbase DbFileName TableInfoShapeOnSheet$  LstTagInfoShapeOnSheet$   LstTypeInfoShapeOnSheet$)  ;-> WriteInfoShapeOnSheet
			(CreateTableDbase DbFileName TableExShapeOnSheet$    LstTagExShapeOnSheet$     LstTypeExShapeOnSheet$)    ;-> WriteDataShapeOnSheet
			(CreateTableDbase DbFileName TableInShapeOnSheet$    LstTagInShapeOnSheet$     LstTypeInShapeOnSheet$)	  ;-> WriteDataShapeOnSheet
			(CreateTableDbase DbFileName TableInTriggerOnSheet$  LstTagInTriggerOnSheet$   LstTypeInTriggerOnSheet$)  ;-> WriteDataTriggerShapeOnSheet
			(CreateTableDbase DbFileName TableOutTriggerOnSheet$ LstTagOutTriggerOnSheet$  LstTypeOutTriggerOnSheet$) ;-> WriteDataTriggerShapeOnSheet
		)
	)
)
;
;
;
(defun ResetFileDbShape (DbFileName)
	(if DbFileName
		(progn
			(CreateDbase DbFileName)
			(CreateTableDbase DbFileName TableInfoShape$  LstTagInfoShape$  LstTypeInfoShape$)		;-> WriteInfoShape
			(CreateTableDbase DbFileName TableExShape$    LstTagExShape$    LstTypeExShape$)		;-> WriteDataShape
			(CreateTableDbase DbFileName TableInShape$    LstTagInShape$    LstTypeInShape$)		;-> WriteDataShape
			(CreateTableDbase DbFileName TableInTrigger$  LstTagInTrigger$  LstTypeInTrigger$)		;-> WriteDataTriggerShape
			(CreateTableDbase DbFileName TableOutTrigger$ LstTagOutTrigger$ LstTypeOutTrigger$)		;-> WriteDataTriggerShape
		)
	)
)
;
;
;
(defun Sheet->Sql (DbFileName EnameSheet / EnameShape LstDataShape Num itm)

	(if (and DbFileName EnameSheet)
		(progn
			(WriteInfoSheet        DbFileName EnameSheet)
			(WriteDataSheet        DbFileName EnameSheet)
			(WriteInfoShapeOnSheet DbFileName EnameSheet)
			(foreach EnameShape (GetEnameShapeByEnameSheet EnameSheet "CE")
				(WriteDataShapeOnSheet DbFileName EnameSheet EnameShape)
				
				(setq LstDataShape (GetExpertEnameShape&Trigger EnameShape 6))
				(setq Num 0)
				(foreach itm (cadr LstDataShape) 
				
					(setq EnameTriggerIn  (car itm))
					(setq EnameTriggerOut (cadr itm))
					(setq EnameShape (nth Num (car LstDataShape)))
					(WriteDataTriggerShapeOnSheet DbFileName EnameSheet EnameShape EnameTriggerIn)
					(WriteDataTriggerShapeOnSheet DbFileName EnameSheet EnameShape EnameTriggerOut)
					(setq Num (1+ Num))
				)
			)
		)
	)
)
;
;
;
(defun Shape->Sql (DbFileName EnameDummy / EnameShape LstDataShape Num itm EnameTriggerIn EnameTriggerOut )

	(if (and DbFileName EnameDummy)
		(progn
			(setq EnameShape    (GetEnameShapeByDummyEnameSelect EnameDummy))
			(setq LstDataShape  (GetExpertEnameShape&Trigger EnameShape 6))

			(WriteInfoShape DbFileName EnameShape)
			(foreach itm (car LstDataShape) 
				(WriteDataShape DbFileName itm)
			)
			(setq Num 0)
			
			(foreach itm (cadr LstDataShape) 
			
				(setq EnameTriggerIn  (car itm))
				(setq EnameTriggerOut (cadr itm))
				(setq EnameShape 	  (nth Num (car LstDataShape)))
				
				(WriteDataTriggerShape DbFileName EnameShape EnameTriggerIn)
				(WriteDataTriggerShape DbFileName EnameShape EnameTriggerOut)
				(setq Num (1+ Num))
			)
		)
	)
)
;
;
;
(defun Sql->Shape (DbFileName IdShape Code ExData / LstDataInfo LstDataShape LstDataTrigger LstEnameShape LstEnameTrigger Rtn)

	;(setq LstDataInfo     (ReadDataInfoShape IdShape))
	(if (and DbFileName IdShape Code)
		(progn
			(cond 
				((= Code "111")
					(setq LstDataShape    (ReadDataShape 		DbFileName IdShape))
					(setq LstDataTrigger  (ReadDataTriggerShape DbFileName IdShape))
					(setq Rtn 			  (GraphShape 			LstDataShape "11" ExData))
					(setq Rtn 			  (append (GraphTriggerShape LstDataTrigger ExData)  Rtn))
				)
				((= Code "100")
					(setq LstDataShape    (ReadDataShape 		DbFileName IdShape))
					(setq Rtn 			  (GraphShape 			LstDataShape "10" ExData))
				)
				((= Code "010")
					(setq LstDataShape    (ReadDataShape		DbFileName IdShape))
					(setq Rtn 			  (GraphShape			LstDataShape "01" ExData))
				)
				((= Code "001")
					(setq LstDataTrigger  (ReadDataTriggerShape	DbFileName IdShape))
					(setq Rtn 			  (GraphTriggerShape 	LstDataTrigger ExData))
				)
				((= Code "110")
					(setq LstDataShape    (ReadDataShape 		DbFileName IdShape))
					(setq Rtn 			  (GraphShape 			LstDataShape "11" ExData))
				)
				((= Code "011")
					(setq LstDataShape    (ReadDataShape 		DbFileName IdShape))
					(setq LstDataTrigger  (ReadDataTriggerShape DbFileName IdShape))
					(setq Rtn 			  (GraphShape 			LstDataShape "01" ExData))
					(setq Rtn 			  (append (GraphTriggerShape LstDataTrigger ExData)  Rtn))
				)
				((= Code "101")
					(setq LstDataShape    (ReadDataShape 		DbFileName IdShape))
					(setq LstDataTrigger  (ReadDataTriggerShape DbFileName IdShape))
					(setq Rtn 			  (GraphShape 			LstDataShape "10" ExData))
					(setq Rtn 			  (append (GraphTriggerShape LstDataTrigger ExData)  Rtn))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun Sql->Sheet (DbFileName IdSheet Code ExData / LstDataSheet LstDataShapeOnSheet LstDataTriggerShapeOnSheet Rtn1 Rtn2 Rtn3)

	;(setq LstDataInfo     (ReadDataInfoShape IdShape))
	; Code 1111 -> 1/0 Sheet	 1/0 ShapeIn 	1/0 ShapeOut 	1/0 Trigger
	
	(if (and DbFileName IdSheet Code)
		(progn
			(cond 
				((= Code "1111")
					(setq LstDataSheet 	        		(ReadDataSheet 					DbFileName IdSheet))
					(setq LstDataShapeOnSheet			(ReadDataShapeOnSheet        	DbFileName IdSheet "<>"))
					(setq LstDataTriggerShapeOnSheet  	(ReadDataTriggerShapeOnSheet 	DbFileName IdSheet "<>"))
					(setq Rtn1 			  				(GraphSheet 					LstDataSheet ExData))
					(setq Rtn2 							(GraphShapeOnSheet 				LstDataShapeOnSheet "11" ExData))
					(setq Rtn3 							(GraphTriggerShapeOnSheet 		LstDataTriggerShapeOnSheet ExData))
				)
				((= Code "1000")
					(setq LstDataSheet  				(ReadDataSheet 					DbFileName IdSheet))
					(setq Rtn1 							(GraphSheet	 					LstDataSheet ExData))
				)
				((= Code "1110")
					(setq LstDataSheet 	  				(ReadDataSheet 					DbFileName IdSheet))
					(setq LstDataShapeOnSheet			(ReadDataShapeOnSheet       	DbFileName IdSheet "<>"))
					(setq Rtn1 			  				(GraphSheet 					LstDataSheet ExData))
					(setq Rtn2 							(GraphShapeOnSheet 				LstDataShapeOnSheet "11" ExData))
				)
				((= Code "0110")
					(setq LstDataShapeOnSheet			(ReadDataShapeOnSheet       	DbFileName IdSheet "<>"))
					(setq Rtn2 							(GraphShapeOnSheet 				LstDataShapeOnSheet "11" ExData))
				)
				((= Code "0100")
					(setq LstDataShapeOnSheet			(ReadDataShapeOnSheet       	DbFileName IdSheet "<>"))
					(setq Rtn2 							(GraphShapeOnSheet 				LstDataShapeOnSheet "10" ExData))
				)
				((= Code "0010")
					(setq LstDataShapeOnSheet			(ReadDataShapeOnSheet       	DbFileName IdSheet "<>"))
					(setq Rtn2 							(GraphShapeOnSheet 				LstDataShapeOnSheet "01" ExData))
				)
				((= Code "0001")
					(setq LstDataTriggerShapeOnSheet  	(ReadDataTriggerShapeOnSheet 	DbFileName IdSheet "<>"))
					(setq Rtn3 							(GraphTriggerShapeOnSheet 		LstDataTriggerShapeOnSheet ExData))
				)
				((= Code "1100")
					(setq LstDataSheet 	  				(ReadDataSheet 					DbFileName IdSheet))
					(setq LstDataShapeOnSheet			(ReadDataShapeOnSheet       	DbFileName IdSheet "<>"))
					(setq Rtn1 			  				(GraphSheet 					LstDataSheet ExData))
					(setq Rtn2 							(GraphShapeOnSheet 				LstDataShapeOnSheet "10" ExData))
				)
				(t
					(alert "Filtro non implementato [Sql->Sheet]")
				)
			)
		)
	)
	(list Rtn1 Rtn2 Rtn3)
)
;
;
;
(defun GraphShape (LstDataShape Code ExData / DataEx DataIn itm LstDxfN LstDxfE Rtn)
	
	(if (and LstDataShape Code)
		(progn
			(setq DataEx (car  LstDataShape))
			(setq DataIn (cadr LstDataShape))
			(cond
				((= Code "10")
					(setq LstDxfN (read (nth 1 (car DataEx))))
					(setq LstDxfE (read (nth 2 (car DataEx))))
					(if ExData
						(setq Rtn (cons (entmakex (append LstDxfN (list LstDxfE))) Rtn))
						(setq Rtn (cons (entmakex LstDxfN ) Rtn))
					)
				)
				((= Code "01")
					(foreach itm DataIn
						(setq LstDxfN (read (nth 2 itm)))
						(setq LstDxfE (read (nth 3 itm)))
						(if ExData
							(setq Rtn (cons (entmakex (append LstDxfN (list LstDxfE))) Rtn))
							(setq Rtn (cons (entmakex LstDxfN ) Rtn))
						)
					)
				)
				((= Code "11")
					(setq LstDxfN (read (nth 1 (car DataEx))))
					(setq LstDxfE (read (nth 2 (car DataEx))))
					(if ExData
						(setq Rtn (cons (entmakex (append LstDxfN (list LstDxfE))) Rtn))
						(setq Rtn (cons (entmakex LstDxfN ) Rtn))
					)
					(foreach itm DataIn
						(setq LstDxfN (read (nth 2 itm)))
						(setq LstDxfE (read (nth 3 itm)))
						(if ExData
							(setq Rtn (cons (entmakex (append LstDxfN (list LstDxfE))) Rtn))
							(setq Rtn (cons (entmakex LstDxfN ) Rtn))
						)
					)
					(setq Rtn (reverse Rtn))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GraphShapeOnSheet (LstDataShapeOnSheet Code ExData / DataOutShape DataInShape itm LstDxfN LstDxfE Rtn)
	
	(if (and LstDataShapeOnSheet Code)
		(progn
			(setq DataOutShape (car  LstDataShapeOnSheet))
			(setq DataInShape  (cadr LstDataShapeOnSheet))
			
			(foreach itm DataOutShape
				(if (or (= Code "10") (= Code "11"))
					(progn
						(setq LstDxfN (read (nth 2 itm)))
						(setq LstDxfE (read (nth 3 itm)))
						(if ExData 
							(setq Rtn (cons (entmakex (append LstDxfN (list LstDxfE))) Rtn))
							(setq Rtn (cons (entmakex LstDxfN) Rtn))
						)
					)
				)
			)
			(foreach itm DataInShape
				(if (or (= Code "01") (= Code "11"))
					(progn
						(setq LstDxfN (read (nth 3 itm)))
						(setq LstDxfE (read (nth 4 itm)))
						(if ExData 
							(setq Rtn (cons (entmakex (append LstDxfN (list LstDxfE))) Rtn))
							(setq Rtn (cons (entmakex LstDxfN) Rtn))
						)
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
(defun GraphTriggerShapeOnSheet (LstDataTriggerShapeOnSheet ExData / DataInTriggerShape DataOutTriggerShape itm LstDxfN LstDxfE Rtn)
	

	(if LstDataTriggerShapeOnSheet
		(progn
			(setq DataInTriggerShape   (car  LstDataTriggerShapeOnSheet))
			(setq DataOutTriggerShape  (cadr LstDataTriggerShapeOnSheet))
			
			(foreach itm DataInTriggerShape
				(progn
					(setq LstDxfN (read (nth 3 itm)))
					(setq LstDxfE (read (nth 4 itm)))
					(if ExData
						(setq Rtn (cons (entmakex (append LstDxfN (list LstDxfE))) Rtn))
						(setq Rtn (cons (entmakex LstDxfN ) Rtn))
					)
				)
			)
			(foreach itm DataOutTriggerShape
				(progn
					(setq LstDxfN (read (nth 3 itm)))
					(setq LstDxfE (read (nth 4 itm)))
					(if ExData
						(setq Rtn (cons (entmakex (append LstDxfN (list LstDxfE))) Rtn))
						(setq Rtn (cons (entmakex LstDxfN ) Rtn))
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
(defun GraphSheet (LstDataSheet ExData / DataEx DataIn LstDxfN LstDxfE Rtn)
	
	(if LstDataSheet
		(progn
			(setq DataEx  (car  LstDataSheet))
			;(setq DataIn (cadr LstDataSheet))
			(setq LstDxfN (read (nth 1 (car DataEx))))
			(setq LstDxfE (read (nth 2 (car DataEx))))
			(if ExData
				(setq Rtn (cons (entmakex (append LstDxfN (list LstDxfE))) Rtn))
				(setq Rtn (cons (entmakex LstDxfN ) Rtn))
			)
		)
	)

	Rtn
)
;
;
;
(defun GraphTriggerShape (LstDataTrigger ExData / itm LstDxfN LstDxfE Rtn)
	
	;
	; attacchi esterni
	;
	(foreach itm (car LstDataTrigger)
		(setq LstDxfN (read (nth 2 itm)))
		(setq LstDxfE (read (nth 3 itm)))
		(if ExData 
			(setq Rtn (cons (entmakex (append LstDxfN (list LstDxfE))) Rtn))
			(setq Rtn (cons (entmakex LstDxfN ) Rtn))
		)
	)
	;
	; attacchi interni
	;
	(foreach itm (cadr LstDataTrigger)
		(setq LstDxfN (read (nth 2 itm)))
		(setq LstDxfE (read (nth 3 itm)))
		(if ExData
			(setq Rtn (cons (entmakex (append LstDxfN (list LstDxfE))) Rtn))
			(setq Rtn (cons (entmakex LstDxfN ) Rtn))
		)
	)
	Rtn
)
;
;
;
(defun ReadDataInfoShape (DbFileName IdShape / TblName LstRowName Rtn)

	;	(setq TableInfoShape$ 			"INFOSHAPE")
	;	(setq LstTagInfoShape$			(list 	"IDSHAPE" "ORDERSHAPE" "PHASESHAPE" "FAMILYSHAPE" "MARKSHAPE" "QUANTITYSHAPE" "NAMESHAPE" "MATERIALSHAPE"
	;											"THIKNESSSHAPE" "LENGTHSHAPE" "WIDTHSHAPE" "CUTSHAPE" "DATESHAPE" "FLAG1SHAPE" "FLAG2SHAPE" "FLAG3SHAPE"))
	;	(setq LstTypeInfoShape$			(list 	"char(64)" "char(64)" "char(64)" "char(64)" "char(64)" "int" "char(64)" "char(64)"
	;											"float" "float" "float" "int" "char(64)" "char(64)" "char(64)" "char(64)"))

	(if (and DbFileName IdShape)
		(progn
			(setq TblName    TableInfoShape$)
			(setq LstRowName LstTagInfoShape$)
			(Dsql_Open DbFileName)
				(if (setq Rtn (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdShape "';")))
					(setq Rtn (cdr Rtn))
				)
			(Dsql_Close DbFileName)
		)
	)
	Rtn
)
;
;
;
(defun ReadDataInfoSheet (DbFileName IdSheet / TblName LstRowName Rtn)

	;	(setq TableInfoSheet$ 			"INFOSHEET")
	;	(setq LstTagInfoSheet$			(list 	"IDSHEET" "NAMESHEET" "WIDTHSHEET" "HEIGHTSHEET" "THICKSHEET" "SURFACESHEET" "WEIGHTSHEET" "MATERIALSHEET"))
	;	(setq LstTypeInfoSheet$			(list 	"char(64)" "char(64)" "float" "float" "float" "float" "float" "char(64)"))


	(if (and DbFileName IdSheet)
		(progn
			(setq TblName    TableInfoSheet$)
			(setq LstRowName LstTagInfoSheet$)
			(Dsql_Open DbFileName)
				(if (setq Rtn (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "';")))
					(setq Rtn (cdr Rtn))
				)
			(Dsql_Close DbFileName)
		)
	)
	Rtn
)
;
;
;
(defun ReadDataInfoShapeOnSheet (DbFileName IdSheet IdShape / TblName LstRowName Rtn)

	
	;	(setq TableInfoShapeOnSheet$ 	"INFOSHAPEONSHEET")
	;	(setq LstTagInfoShapeOnSheet$	(list 	"IDSHEET" "IDSHAPE" "ORDERSHAPE" "PHASESHAPE" "MARKSHAPE" "NAMESHAPE" "MATERIALSHAPE"
	;									        "THICKSHAPE" "LENGTHSHAPE" "WIDTHSHAPE" "CUTSHAPE" "DATESHAPE"))
	;	(setq LstTypeInfoShapeOnSheet$	(list   "char(64)" "char(64)" "char(64)" "char(64)" "char(64)" "char(64)" "char(64)"
	;											"float" "float" "float"  "int"  "char(64)"))
	
	;   if IdShape = "<>" return all Shape or IdShape = "12345"

	(if (and DbFileName IdSheet IdShape)
		(progn
			(setq TblName    TableInfoShapeOnSheet$)
			(setq LstRowName LstTagInfoShapeOnSheet$)
			(Dsql_Open DbFileName)
				(cond 
					((= IdShape "<>")
						(setq Rtn (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "' AND " (nth 1 LstRowName) " LIKE '%';")))
					)
					(t
						(setq Rtn (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "' AND " (nth 1 LstRowName) "='" Idshape "';")))
					)
				)
				(if Rtn	(setq Rtn (cdr Rtn)))
			(Dsql_Close DbFileName)
		)
	)
	Rtn
)
;
;
;
(defun ReadDataShapeOnSheet (DbFileName IdSheet IdShape / TblNameEx LstRowNameEx TblNameIn LstRowNameIn Rtn1 Rtn2)

	
	;	(setq TableExShapeOnSheet$ 		"OUTSHAPEONSHEET")
	;	(setq LstTagExShapeOnSheet$		(list 	"IDSHEET" "IDSHAPE" "DXFLISTSHAPE" "EXTENDEDDATA"))
	;	(setq LstTypeExShapeOnSheet$	(list 	"char(64)" "char(64)" "char(1024)" "char(1024)"))
	;	(setq TableInShapeOnSheet$ 		"INSHAPEONSHEET")									
	;	(setq LstTagInShapeOnSheet$		(list 	"IDSHEET" "IDSHAPE" "IDSHAPEIN" "DXFLISTSHAPE" "EXTENDEDDATA"))
	;	(setq LstTypeInShapeOnSheet$	(list 	"char(64)" "char(64)" "char(64)" "char(1024)" "char(1024)"))

	;   if IdShape = "<>" return all Shape or IdShape = "12345"
	
	
	(if (and DbFileName IdSheet IdShape)
		(progn
			(setq TblNameEx    TableExShapeOnSheet$)
			(setq LstRowNameEx LstTagExShapeOnSheet$)
			(setq TblNameIn    TableInShapeOnSheet$)
			(setq LstRowNameIn LstTagInShapeOnSheet$)

			(Dsql_Open DbFileName)
				(cond 
					((= IdShape "<>")
						(if (setq Rtn1 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameEx " WHERE " (nth 0 LstRowNameEx) "='" IdSheet "' AND " (nth 1 LstRowNameEx) " LIKE '%';")))
							(setq Rtn1 (cdr Rtn1))
						)
						(if (setq Rtn2 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameIn " WHERE " (nth 0 LstRowNameIn) "='" IdSheet "' AND " (nth 1 LstRowNameIn) " LIKE '%';")))
							(setq Rtn2 (cdr Rtn2))
						)
					)
					(t
						(if (setq Rtn1 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameEx " WHERE " (nth 0 LstRowNameEx) "='" IdSheet "' AND " (nth 1 LstRowNameEx) "='" Idshape "';")))
							(setq Rtn1 (cdr Rtn1))
						)
						(if (setq Rtn2 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameIn " WHERE " (nth 0 LstRowNameIn) "='" IdSheet "' AND " (nth 1 LstRowNameIn) "='" Idshape "';")))
							(setq Rtn2 (cdr Rtn2))
						)
					)
				)
				
			(Dsql_Close DbFileName)
		)
	)
	(list Rtn1 Rtn2)
)
;
;
;
(defun ReadDataShape (DbFileName IdShape / TblNameEx LstRowNameEx TblNameIn LstRowNameIn Rtn1 Rtn2)

	;	(setq TableExShape$ 			"OUTSHAPE")
	;	(setq LstTagExShape$			(list 	"IDSHAPE" "DXFLISTSHAPE" "EXTENDEDDATA"))
	;	(setq LstTypeExShape$			(list 	"char(64)" "char(1024)" "char(1024)"))
	;	(setq TableInShape$ 			"INSHAPE")									
	;	(setq LstTagInShape$			(list 	"IDSHAPE" "IDSHAPEIN" "DXFLISTSHAPE" "EXTENDEDDATA"))
	;	(setq LstTypeInShape$			(list 	"char(64)" "char(64)" "char(1024)" "char(1024)"))

	(if (and DbFileName IdShape)
		(progn

			(setq TblNameEx    TableExShape$)
			(setq LstRowNameEx LstTagExShape$)
			(setq TblNameIn    TableInShape$)
			(setq LstRowNameIn LstTagInShape$)

			;(setq LstValName (list IdMainShape DxfDataN DxfDataE))
			;(setq LstValName (list IdMainShape IdDummyShape DxfDataN DxfDataE))

			(Dsql_Open DbFileName)
				(if (setq Rtn1 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameEx " WHERE " (nth 0 LstRowNameEx) "='" IdShape "';")))
					(setq Rtn1 (cdr Rtn1))
				)
				(if (setq Rtn2 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameIn " WHERE " (nth 0 LstRowNameIn) "='" IdShape "';")))
					(setq Rtn2 (cdr Rtn2))
				)

			(Dsql_Close DbFileName)
		)
	)	
	(list Rtn1 Rtn2)
)
;
;
;
(defun ReadDataSheet (DbFileName IdSheet / TblNameEx LstRowNameEx TblNameIn LstRowNameIn Rtn1)

	;	(setq TableExSheet$ 			"OUTSHEET")
	;	(setq LstTagExSheet$			(list 	"IDSHEET" "DXFLISTSHAPE" "EXTENDEDDATA"))
	;	(setq LstTypeExSheet$			(list 	"char(64)" "char(1024)" "char(1024)"))
	;	(setq TableInSheet$ 			"INSHEET")
	;	(setq LstTagInSheet$			(list 	"IDSHEET" "DXFLISTSHAPE" "EXTENDEDDATA"))
	;	(setq LstTypeInSheet$			(list 	"char(64)" "char(1024)" "char(1024)"))

	(if (and DbFileName IdSheet)
		(progn

			(setq TblNameEx    TableExSheet$)
			(setq LstRowNameEx LstTagExSheet$)
			(setq TblNameIn    TableInSheet$)
			(setq LstRowNameIn LstTagInSheet$)

			;(setq LstValName (list IdMainShape DxfDataN DxfDataE))
			;(setq LstValName (list IdMainShape IdDummyShape DxfDataN DxfDataE))

			(Dsql_Open DbFileName)
				(if (setq Rtn1 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameEx " WHERE " (nth 0 LstRowNameEx) "='" IdSheet "';")))
					(setq Rtn1 (cdr Rtn1))
				)
				;(if (setq Rtn2 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameIn " WHERE " (nth 0 LstRowNameIn) "='" IdShape "';")))
				;	(setq Rtn2 (cdr Rtn2))
				;)

			(Dsql_Close DbFileName)
		)
	)	
	(list Rtn1 nil)
	
)
;
;
;
(defun ReadDataTriggerShape (DbFileName IdShape / TblNameIn LstRowNameIn TblNameOut LstRowNameOut Rtn1 Rtn2)

	;	(setq TableInTrigger$ 			"TRIGGERINSHAPE")									
	;	(setq LstTagInTrigger$			(list 	"IDSHAPE" "IDTRIGGER" "DXFLISTTRIGGER" "EXTENDEDDATA"))
	;	(setq LstTypeInTrigger$			(list 	"char(64)" "char(64)" "char(1024)" "char(1024)"))
	;	(setq TableOutTrigger$ 			"TRIGGEROUTSHAPE")									
	;	(setq LstTagOutTrigger$			(list 	"IDSHAPE" "IDTRIGGER" "DXFLISTTRIGGER" "EXTENDEDDATA"))
	;	(setq LstTypeOutTrigger$		(list 	"char(64)" "char(64)" "char(1024)" "char(1024)"))

	(if (and DbFileName IdShape)
		(progn
			(setq TblNameIn     TableInTrigger$)
			(setq LstRowNameIn  LstTagInTrigger$)
			(setq TblNameOut    TableOutTrigger$)
			(setq LstRowNameOut LstTagOutTrigger$)
			;(setq LstValName (list IdMainShape IdTriggerShape DxfDataN DxfDataE))	
			(Dsql_Open DbFileName)
				(if (setq Rtn1 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameIn " WHERE " (nth 0 LstRowNameIn) "='" IdShape "';")))
					(setq Rtn1 (cdr Rtn1))
				)
				(if (setq Rtn2 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameOut " WHERE " (nth 0 LstRowNameOut) "='" IdShape "';")))
					(setq Rtn2 (cdr Rtn2))
				)
			(Dsql_Close DbFileName)
		)
	)
	(list Rtn1 Rtn2)
)
;
;
;
(defun ReadDataTriggerShapeOnSheet (DbFileName IdSheet IdShape / TblNameIn LstRowNameIn TblNameOut LstRowNameOut Rtn1 Rtn2)

	;	(setq TableInTriggerOnSheet$ 	"TRIGGERINSHAPE")									
	;	(setq LstTagInTriggerOnSheet$	(list 	"IDSHEET" "IDSHAPE" "IDTRIGGER" "DXFLISTTRIGGER" "EXTENDEDDATA"))
	;	(setq LstTypeInTriggerOnSheet$	(list 	"char(64)" "char(64)" "char(64)" "char(1024)" "char(1024)"))
	;	(setq TableOutTriggerOnSheet$ 	"TRIGGEROUTSHAPE")									
	;	(setq LstTagOutTriggerOnSheet$	(list 	"IDSHEET" "IDSHAPE" "IDTRIGGER" "DXFLISTTRIGGER" "EXTENDEDDATA"))
	;	(setq LstTypeOutTriggerOnSheet$	(list 	"char(64)" "char(64)" "char(64)" "char(1024)" "char(1024)"))

	;   if IdShape = "<>" return all Shape or IdShape = "12345"	
	
	(if (and DbFileName IdSheet IdShape)
		(progn

			(setq TblNameIn     TableInTriggerOnSheet$)
			(setq LstRowNameIn  LstTagInTriggerOnSheet$)
			(setq TblNameOut    TableOutTriggerOnSheet$)
			(setq LstRowNameOut LstTagOutTriggerOnSheet$)

			
			(Dsql_Open DbFileName)
				(cond 
					((= IdShape "<>")
						(if (setq Rtn1 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameIn  " WHERE " (nth 0 LstRowNameIn)  "='" IdSheet "' AND " (nth 1 LstRowNameIn)  " LIKE '%';")))
							(setq Rtn1 (cdr Rtn1))
						)
						(if (setq Rtn2 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameOut " WHERE " (nth 0 LstRowNameOut) "='" IdSheet "' AND " (nth 1 LstRowNameOut) " LIKE '%';")))
							(setq Rtn2 (cdr Rtn2))
						)
					)
					(t
						(if (setq Rtn1 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameIn  " WHERE " (nth 0 LstRowNameIn)  "='" IdSheet "' AND " (nth 1 LstRowNameIn)  "='" Idshape "';")))
							(setq Rtn1 (cdr Rtn1))
						)
						(if (setq Rtn2 (Dsql_query DbFileName (strcat "SELECT * FROM " TblNameOut " WHERE " (nth 0 LstRowNameOut) "='" IdSheet "' AND " (nth 1 LstRowNameOut) "='" Idshape "';")))
							(setq Rtn2 (cdr Rtn2))
						)
					
					)
				)
			(Dsql_Close DbFileName)
		)
	)
	(list Rtn1 Rtn2)
)
;
;
;
(defun WriteInfoSheet (DbFileName EnameSheet / TblName LstRowName 
											   LstInfoSheet IdSheet NameSheet WidthSheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet
											   LstValName)

	;	(setq TableInfoSheet$ 			"INFOSHEET")
	;	(setq LstTagInfoSheet$			(list 	"IDSHAPE" "NAMESHEET" "WIDTHSHEET" "HEIGHTSHEET" "THICKSHEET" "SURFACESHEET" "WEIGHTSHEET" "MATERIALSHEET"))
	;	(setq LstTypeInfoSheet$			(list 	"char(64)" "char(64)" "float" "float" "float" "float" "float" "char(64)"))
												   
	
	(if (and EnameSheet DbFileName)
		(progn
			(setq TblName   	 TableInfoSheet$)
			(setq LstRowName 	LstTagInfoSheet$)
			(setq LstInfoSheet  (GetDataSheetByEname EnameSheet)) ; --> (IdSheet NameSheet WidthSheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet))
			(setq IdSheet 		(nth 0 LstInfoSheet)
				  NameSheet 	(nth 1 LstInfoSheet)
				  WidthSheet 	(atof (nth 2 LstInfoSheet))
				  HeightSheet 	(atof (nth 3 LstInfoSheet))
				  ThickSheet    (atof (nth 4 LstInfoSheet))
				  SurfaceSheet  (atof (nth 5 LstInfoSheet))
				  WeightSheet   (atof (nth 6 LstInfoSheet))
				  MatSheet      (nth 7 LstInfoSheet)
			)
			(setq LstValName (list IdSheet NameSheet WidthSheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet))
			
			(if (findfile DbFileName)
				(progn
					(Dsql_Open DbFileName)
						(if (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "';"))
							(Dsql_Dml DbFileName   (strcat "DELETE FROM "   TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "';"))
							;(DeleteRowDbase DbFileName TblName (nth 0 LstRowName) IdSheet)
						)
						(WriteDbase DbFileName TblName LstValName)
					(Dsql_Close DbFileName)
				)
			)
		)
	)
)
;
;
;
(defun WriteInfoShape (DbFileName EnameShape / TblName LstRowName 
											   OrderShape PhaseShape FamilyShape MarkShape IdShape QtaShape NameShape 
											   MatShape ThickShape DimensionShape LengthShape WidthShape CutShape DateShape 
											   Flag1Shape Flag2Shape Flag3Shape LstValName)

	;	(setq TableInfoShape$ 			"INFOSHAPE")
	;	(setq LstTagInfoShape$			(list 	"IDSHAPE" "ORDERSHAPE" "PHASESHAPE" "FAMILYSHAPE" "MARKSHAPE" "QUANTITYSHAPE" "NAMESHAPE" "MATERIALSHAPE"
	;											"THIKNESSSHAPE" "LENGTHSHAPE" "WIDTHSHAPE" "CUTSHAPE" "DATESHAPE" "FLAG1SHAPE" "FLAG2SHAPE" "FLAG3SHAPE"))
	;	(setq LstTypeInfoShape$			(list 	"char(64)" "char(64)" "char(64)" "char(64)" "char(64)" "int" "char(64)" "char(64)"
	;											"float" "float" "float" "int" "char(64)" "char(64)" "char(64)" "char(64)"))
												   
	
	(if (and EnameShape DbFileName)
		(progn
			(setq 	TblName    		TableInfoShape$)
			(setq 	LstRowName 		LstTagInfoShape$)
			(setq 	IdShape 		(GetIdShape EnameShape)
					OrderShape 	 	(GetComShape EnameShape)
					PhaseShape 	 	(GetPhaseShape EnameShape)
					FamilyShape 	"-"
					MarkShape 	 	(GetNameShape EnameShape)
					QtaShape 		(atoi (GetQtaShape EnameShape))
					NameShape 		"-"
					MatShape 		(GetMatShape EnameShape)
					ThickShape 	 	(atof (GetTkShape EnameShape))
					DimensionShape 	(GetDimensionShape EnameShape)
					LengthShape 	(car  (nth 1 DimensionShape))
					WidthShape 	 	(cadr (nth 1 DimensionShape))
					CutShape 		(atoi (GetCutShape EnameShape))
					DateShape 	 	(GetDateShape EnameShape)
					Flag1Shape 		"-"
					Flag2Shape 		"-"
					Flag3Shape 		"-"
			)
			(setq LstValName (list	IdShape OrderShape PhaseShape FamilyShape MarkShape QtaShape NameShape MatShape	ThickShape
									LengthShape	WidthShape CutShape DateShape Flag1Shape Flag2Shape Flag3Shape))
			(if (findfile DbFileName)
				(progn
					(Dsql_Open DbFileName)
						(if (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdShape "';"))
							(Dsql_Dml DbFileName   (strcat "DELETE FROM "   TblName " WHERE " (nth 0 LstRowName) "='" IdShape "';"))
							;(DeleteRowDbase DbFileName TblName (nth 0 LstRowName) IdShape)
						)
						(WriteDbase DbFileName TblName LstValName)
					(Dsql_Close DbFileName)
				)
			)
		)
	)
)
;
;
;
(defun WriteDataSheet (DbFileName EnameSheet / IdSheet LstDxfCode DxfDataN DxfDataE
											   TblName LstRowName LstValName)

	;	(setq TableExSheet$ 			"OUTSHEET")
	;	(setq LstTagExSheet$			(list 	"IDSHEET" "DXFLISTSHAPE" "EXTENDEDDATA"))
	;	(setq LstTypeExSheet$			(list 	"char(64)" "char(1024)" "char(1024)"))
	;	(setq TableInSheet$ 			"INSHEET")
	;	(setq LstTagInSheet$			(list 	"IDSHEET" "DXFLISTSHAPE" "EXTENDEDDATA"))
	;	(setq LstTypeInSheet$			(list 	"char(64)" "char(1024)" "char(1024)"))
											   
	(if (and DbFileName EnameSheet)
		(progn
			(setq IdSheet     (GetIdSheet EnameSheet))
			(setq LstDxfCode  (DxfCode->String EnameSheet))

			(if (not (nth 0 LstDxfCode)) (setq DxfDataN "-") (setq DxfDataN  (nth 0 LstDxfCode)))	; record dxflist data
			(if (not (nth 1 LstDxfCode)) (setq DxfDataE "-") (setq DxfDataE  (nth 1 LstDxfCode)))	; extended data
			
			(setq TblName    TableExSheet$)
			(setq LstRowName LstTagExSheet$)
			(setq LstValName (list IdSheet DxfDataN DxfDataE))
			
			(if (findfile DbFileName)
				(progn
					(Dsql_Open DbFileName)
						(if (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "';"))
							(Dsql_Dml DbFileName   (strcat "DELETE FROM "   TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "';"))
							;(DeleteRowDbase DbFileName TblName (nth 0 LstRowName) IdSheet)
						)
						(WriteDbase DbFileName TblName LstValName)
					(Dsql_Close DbFileName)
				)
			)
		)
	)
)
;
;
;
(defun WriteDataShape (DbFileName EnameDummy / EnameMainShape IdMainShape IdDummyShape LstDxfCode TypeShape
											   TblName LstRowName DxfDataN DxfDataE LstValName)

	;	(setq TableExShape$ 			"OUTSHAPE")
	;	(setq LstTagExShape$			(list 	"IDSHAPE" "DXFLISTSHAPE" "EXTENDEDDATA"))
	;	(setq LstTypeExShape$			(list 	"char(64)" "char(1024)" "char(1024)"))
	;	(setq TableInShape$ 			"INSHAPE")									
	;	(setq LstTagInShape$			(list 	"IDSHAPE" "IDSHAPEIN" "DXFLISTSHAPE" "EXTENDEDDATA"))
	;	(setq LstTypeInShape$			(list 	"char(64)" "char(64)" "char(1024)" "char(1024)"))
											   
	(if (and DbFileName EnameDummy)
		(progn
			(setq EnameMainShape (GetEnameShapeByDummyEnameSelect EnameDummy))
			(setq IdMainShape 	 (GetIdShape EnameMainShape))
			(setq IdDummyShape 	 (GetIdShape EnameDummy))
			(setq LstDxfCode 	 (DxfCode->String EnameDummy))
			(setq TypeShape		 (GetTypeShape EnameDummy))
			
			(if (not (nth 0 LstDxfCode)) (setq DxfDataN "-") (setq DxfDataN  (nth 0 LstDxfCode)))	; record dxflist data
			(if (not (nth 1 LstDxfCode)) (setq DxfDataE "-") (setq DxfDataE  (nth 1 LstDxfCode)))	; extended data
			
			(cond
				((= TypeShape 1)
					(setq TblName    TableExShape$)
					(setq LstRowName LstTagExShape$)
					(setq LstValName (list IdMainShape DxfDataN DxfDataE))
				)
				((= TypeShape 2)
					(setq TblName    TableInShape$)
					(setq LstRowName LstTagInShape$)
					(setq LstValName (list IdMainShape IdDummyShape DxfDataN DxfDataE))
				)
			)
			
			(if (findfile DbFileName)
				(progn
					(Dsql_Open DbFileName)
						(cond
							((= TypeShape 1)
								(if (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdMainShape "';"))
									(Dsql_Dml DbFileName   (strcat "DELETE FROM "   TblName " WHERE " (nth 0 LstRowName) "='" IdMainShape "';"))
									;(DeleteRowDbase DbFileName TblName (nth 0 LstRowName) IdMainShape)
								)
							)
							((= TypeShape 2)
								(if (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdMainShape "' AND "
																									  (nth 1 LstRowName) "='" IdDummyShape "';"))
									(Dsql_Dml DbFileName   (strcat "DELETE FROM "   TblName " WHERE " (nth 0 LstRowName) "='" IdMainShape "' AND "
																									  (nth 1 LstRowName) "='" IdDummyShape "';"))
									;(DeleteRowDbase DbFileName TblName (nth 1 LstRowName) IdDummyShape)
								)
							)
						)
						(WriteDbase DbFileName TblName LstValName)
					(Dsql_Close DbFileName)
				)
			)
		)
	)
)
;
;
;
(defun WriteDataShapeOnSheet (DbFileName EnameSheet EnameShape / IdSheet IdShape LstDxfCode TblName LstRowName LstValName 
																 EnameInternalShape IdShapeIn DxfDataN DxfDataE)


	;	(setq TableExShapeOnSheet$ 		"OUTSHAPEONSHEET")
	;	(setq LstTagExShapeOnSheet$		(list 	"IDSHEET" "IDSHAPE" "DXFLISTSHAPE" "EXTENDEDDATA"))
	;	(setq LstTypeExShapeOnSheet$	(list 	"char(64)" "char(64)" "char(1024)" "char(1024)"))
	;	(setq TableInShapeOnSheet$ 		"INSHAPEONSHEET")									
	;	(setq LstTagInShapeOnSheet$		(list 	"IDSHEET" "IDSHAPE" "IDSHAPEIN" "DXFLISTSHAPE" "EXTENDEDDATA"))
	;	(setq LstTypeInShapeOnSheet$	(list 	"char(64)" "char(64)" "char(64)" "char(1024)" "char(1024)"))

	(if (and DbFileName EnameSheet EnameShape)
		(if (findfile DbFileName)
			(progn
				(Dsql_Open DbFileName)
				(setq IdSheet 		(GetIdSheet EnameSheet))
				(setq IdShape 		(GetIdShape EnameShape))
				(setq LstDxfCode	(DxfCode->String EnameShape))
				(if (not (nth 0 LstDxfCode)) (setq DxfDataN "-") (setq DxfDataN  (nth 0 LstDxfCode)))	; record dxflist data
				(if (not (nth 1 LstDxfCode)) (setq DxfDataE "-") (setq DxfDataE  (nth 1 LstDxfCode)))	; extended data
					
				(setq TblName    TableExShapeOnSheet$)
				(setq LstRowName LstTagExShapeOnSheet$)
				(setq LstValName (list IdSheet IdShape DxfDataN DxfDataE))

				(if (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "' AND "
																					  (nth 1 LstRowName) "='" IdShape "';"))
					(Dsql_Dml DbFileName   (strcat "DELETE FROM "   TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "' AND "
																					  (nth 1 LstRowName) "='" IdShape "';"))
					;(DeleteRowDbase DbFileName TblName (nth 1 LstRowName) IdShape)
				)
				(WriteDbase DbFileName TblName LstValName)
					
				(foreach EnameInternalShape (GetEnameInternalShapeByDummyEnameSelect EnameShape)
						
					(setq IdShapeIn 	(GetIdShape EnameInternalShape))
					(setq LstDxfCode	(DxfCode->String EnameInternalShape))
					(if (not (nth 0 LstDxfCode)) (setq DxfDataN "-") (setq DxfDataN  (nth 0 LstDxfCode)))	; record dxflist data
					(if (not (nth 1 LstDxfCode)) (setq DxfDataE "-") (setq DxfDataE  (nth 1 LstDxfCode)))	; extended data
			
					(setq TblName    TableInShapeOnSheet$)
					(setq LstRowName LstTagInShapeOnSheet$)
					(setq LstValName (list IdSheet IdShape IdShapeIn DxfDataN DxfDataE))
					(if (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "' AND "
																						  (nth 1 LstRowName) "='" IdShape "' AND "
																						  (nth 2 LstRowName) "='" IdShapeIn "';"))
						(Dsql_Dml DbFileName   (strcat "DELETE FROM "   TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "' AND "
																						  (nth 1 LstRowName) "='" IdShape "' AND "
																						  (nth 2 LstRowName) "='" IdShapeIn "';"))
						;(DeleteRowDbase DbFileName TblName (nth 2 LstRowName) IdShapeIn)
					)
					(WriteDbase DbFileName TblName LstValName)
				)
				(Dsql_Close DbFileName)
			)
		)
	)
)
;
;
;
(defun WriteInfoShapeOnSheet (DbFileName EnameSheet / itm IdSheet IdShape OrderShape PhaseShape MarkShape NameShape MatShape ThickShape
													  DimensionShape LengthShape WidthShape CutShape DateShape
													  LstValName TblName LstRowName)

	;	(setq TableInfoShapeOnSheet$ 	"INFOSHAPEONSHEET")
	;	(setq LstTagInfoShapeOnSheet$	(list 	"IDSHEET" "IDSHAPE" "ORDERSHAPE" "PHASESHAPE" "MARKSHAPE" "NAMESHAPE" "MATERIALSHAPE"
	;									        "THICKSHAPE" "LENGTHSHAPE" "WIDTHSHAPE" "CUTSHAPE" "DATESHAPE"))
	;	(setq LstTypeInfoShapeOnSheet$	(list   "char(64)" "char(64)" "char(64)" "char(64)" "char(64)" "char(64)" "char(64)"
	;									        "float" "float" "float"  "int"  "char(64)"))


	(if (and DbFileName EnameSheet)
		(progn
			(setq IdSheet (GetIdSheet EnameSheet))
			(foreach itm (GetEnameShapeByEnameSheet EnameSheet "CE")
				(setq IdShape 	  		(GetIdShape itm)
					  OrderShape		(GetComShape itm)
					  PhaseShape 		(GetPhaseShape itm)
					  MarkShape 		(GetNameShape itm)
					  NameShape 		"-"
					  MatShape 			(GetMatShape itm)
					  ThickShape 		(atof (GetTkShape itm))
					  DimensionShape	(GetDimensionShape itm)
					  LengthShape 		(car  (nth 1 DimensionShape))
					  WidthShape 	 	(cadr (nth 1 DimensionShape))
					  CutShape 			(atoi (GetCutShape itm))
					  DateShape 	 	(GetDateShape itm)
				)
				(setq LstValName (list	IdSheet IdShape OrderShape PhaseShape MarkShape NameShape MatShape	ThickShape
									    LengthShape	WidthShape CutShape DateShape))
				
				(setq TblName    TableInfoShapeOnSheet$)
				(setq LstRowName LstTagInfoShapeOnSheet$)
										
				(if (findfile DbFileName)
					(progn
						(Dsql_Open DbFileName)
							(if (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "' AND "
																								  (nth 1 LstRowName) "='" IdShape "';"))
								(Dsql_Dml DbFileName   (strcat "DELETE FROM "   TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "' AND "
																								  (nth 1 LstRowName) "='" IdShape "';"))																								  
								;(DeleteRowDbase DbFileName TblName (nth 1 LstRowName) IdShape)
							)
							(WriteDbase DbFileName TblName LstValName)
						(Dsql_Close DbFileName)
					)
				)
			)
		)
	)
)
;
;
;
(defun WriteDataTriggerShapeOnSheet (DbFileName EnameSheet EnameShape EnameTrigger / IdSheet IdShape IdTrigger TypeTrigger LstDxfCode 
																					 TblName LstRowName LstValName DxfDataN DxfDataE)

	;	(setq TableInTriggerOnSheet$ 	"TRIGGERINSHAPE")									
	;	(setq LstTagInTriggerOnSheet$	(list 	"IDSHEET" "IDSHAPE" "IDTRIGGER" "DXFLISTTRIGGER" "EXTENDEDDATA"))
	;	(setq LstTypeInTriggerOnSheet$	(list 	"char(64)" "char(64)" "char(64)" "char(1024)" "char(1024)"))
	;	(setq TableOutTriggerOnSheet$ 	"TRIGGEROUTSHAPE")									
	;	(setq LstTagOutTriggerOnSheet$	(list 	"IDSHEET" "IDSHAPE" "IDTRIGGER" "DXFLISTTRIGGER" "EXTENDEDDATA"))
	;	(setq LstTypeOutTriggerOnSheet$	(list 	"char(64)" "char(64)" "char(64)" "char(1024)" "char(1024)"))
	
	(if (and DbFileName EnameSheet EnameShape EnameTrigger)
		(progn
			(setq IdSheet		(GetIdSheet   EnameSheet))
			(setq IdShape		(GetIdShape   EnameShape))
			(setq IdTrigger		(GetIdTrigger EnameTrigger))
			(setq TypeTrigger	(GetTypeShape EnameTrigger))
			(setq LstDxfCode	(DxfCode->String EnameTrigger))
			
			(if (not (nth 0 LstDxfCode)) (setq DxfDataN "-") (setq DxfDataN  (nth 0 LstDxfCode)))	; record dxflist data
			(if (not (nth 1 LstDxfCode)) (setq DxfDataE "-") (setq DxfDataE  (nth 1 LstDxfCode)))	; extended data

			(cond
				((= TypeTrigger 3) ; in
					(setq TblName    TableInTriggerOnSheet$)
					(setq LstRowName LstTagInTriggerOnSheet$)
				)
				((= TypeTrigger 4) ; out
					(setq TblName    TableOutTriggerOnSheet$)
					(setq LstRowName LstTagOutTriggerOnSheet$)
				)
			)
			
			(setq LstValName (list IdSheet IdShape IdTrigger DxfDataN DxfDataE))
			(Dsql_Open DbFileName)
			(if (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "' AND "
																				  (nth 1 LstRowName) "='" IdShape "' AND "
																				  (nth 2 LstRowName) "='" IdTrigger "';"))
				(Dsql_Dml DbFileName   (strcat "DELETE FROM "   TblName " WHERE " (nth 0 LstRowName) "='" IdSheet "' AND "
																				  (nth 1 LstRowName) "='" IdShape "' AND "
																				  (nth 2 LstRowName) "='" IdTrigger "';"))
				;(DeleteRowDbase DbFileName TblName (nth 2 LstRowName) IdTrigger)
			)
			(WriteDbase DbFileName TblName LstValName)
			(Dsql_Close DbFileName)
		)
	)
)
;
;
;
(defun WriteDataTriggerShape (DbFileName EnameShape EnameTrigger / EnameMainShape IdMainShape IdTriggerShape TypeTrigger LstDxfCode
																   TblName LstRowName LstValName DxfDataN DxfDataE)

																   
	;	(setq TableInTrigger$ 			"TRIGGERINSHAPE")									
	;	(setq LstTagInTrigger$			(list 	"IDSHAPE" "IDTRIGGER" "DXFLISTTRIGGER" "EXTENDEDDATA"))
	;	(setq LstTypeInTrigger$			(list 	"char(64)" "char(64)" "char(1024)" "char(1024)"))
	;	(setq TableOutTrigger$ 			"TRIGGEROUTSHAPE")									
	;	(setq LstTagOutTrigger$			(list 	"IDSHAPE" "IDTRIGGER" "DXFLISTTRIGGER" "EXTENDEDDATA"))
	;	(setq LstTypeOutTrigger$		(list 	"char(64)" "char(64)" "char(1024)" "char(1024)"))
																   
																   
	(if (and DbFileName EnameShape EnameTrigger)
		(progn
			(setq EnameMainShape    (GetEnameShapeByDummyEnameSelect EnameTrigger))
			(setq IdMainShape 	 	(GetIdShape EnameMainShape))
			(setq IdTriggerShape  	(GetIdTrigger EnameTrigger))
			(setq TypeTrigger		(GetTypeShape EnameTrigger))
			(setq LstDxfCode 	    (DxfCode->String EnameTrigger))
			
			(if (not (nth 0 LstDxfCode)) (setq DxfDataN "-") (setq DxfDataN  (nth 0 LstDxfCode)))	; record dxflist data
			(if (not (nth 1 LstDxfCode)) (setq DxfDataE "-") (setq DxfDataE  (nth 1 LstDxfCode)))	; extended data
			
			(cond
				((= TypeTrigger 3) ; in
					(setq TblName    TableInTrigger$)
					(setq LstRowName LstTagInTrigger$)
				)
				((= TypeTrigger 4) ; out
					(setq TblName    TableOutTrigger$)
					(setq LstRowName LstTagOutTrigger$)
				)
			)
			
			(setq LstValName (list IdMainShape IdTriggerShape DxfDataN DxfDataE))
			
			(if (findfile DbFileName)
				(progn
					(Dsql_Open DbFileName)
						(if (Dsql_query DbFileName (strcat "SELECT * FROM " TblName " WHERE " (nth 0 LstRowName) "='" IdMainShape    "' AND "
																							  (nth 1 LstRowName) "='" IdTriggerShape "';"))
							(Dsql_Dml DbFileName   (strcat "DELETE FROM "   TblName " WHERE " (nth 0 LstRowName) "='" IdMainShape    "' AND "
																							  (nth 1 LstRowName) "='" IdTriggerShape "';"))
							;(DeleteRowDbase DbFileName TblName (nth 1 LstRowName) IdTriggerShape)
						)
						(WriteDbase DbFileName TblName LstValName)
					(Dsql_Close DbFileName)
				)
			)
		)
	)
)
;
;
;
(defun DeleteRowDbase (DbFileName TblName TagName ValueName)

	(if (and DbFileName TblName TagName ValueName)
		(Dsql_Dml DbFileName (strcat "DELETE FROM " TblName " WHERE " TagName "='" ValueName "';")) ;1 ok 0 no
	)
)
;
;
;
(defun WriteDbase (DbFileName TblName LstValName / Num ActionString Valur)

	(if (and DbFileName TblName LstValName)
		(progn
			(setq Num 0)
			(setq ActionString "")
			(repeat (length LstValName)
				(cond
					((= (type (nth Num LstValName)) 'INT)  (setq Value (itoa (nth Num LstValName)))) 
					((= (type (nth Num LstValName)) 'REAL) (setq Value (LM:rtos (nth Num LstValName) 2 2))) 
					((= (type (nth Num LstValName)) 'STR)  (setq Value (strcat "'" (nth Num LstValName) "'"))) 
				)
				(if (= (1+ Num) (length LstValName))
					;(setq ActionString (strcat ActionString "'" (nth Num LstValName) "'"))
					;(setq ActionString (strcat ActionString "'" (nth Num LstValName)"', "))
					(setq ActionString (strcat ActionString Value))
					(setq ActionString (strcat ActionString Value ", "))
				)
				(setq Num (1+ Num))
			)
			
			(Dsql_Dml DbFileName (strcat "INSERT INTO " TblName " VALUES (" ActionString ");"))
			
		)
	)
)
;
;
;
(defun DxfCode->String (EnameShape / ParseValue
									 LstDxfCode LstDxfCodeExtended NumberDec itm RtnN RtnE)

	(defun ParseValue (ValueCode NumberDec)
		(if ValueCode
			(cond 
				( (= (type ValueCode) 'REAL)
					(if (zerop (- ValueCode (fix ValueCode)))
						(LM:rtos ValueCode 2 1)
						(LM:rtos ValueCode 2 NumberDec)
					)
				)
				( (= (type ValueCode) 'INT)
					(LM:rtos ValueCode 2 0)
				)
			)
		)
	)
	
	(if EnameShape
		(progn
			(setq LstDxfCode         			(entget EnameShape))
			(setq LstDxfCodeExtended (assoc -3 	(entget EnameShape (list "*"))))
			(setq NumberDec 8)
			;
			; normal data ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(if LstDxfCode
				(progn
					(setq RtnN "(")
					(foreach itm LstDxfCode
						;(princ itm) (princ "\n")
						(cond
							; -----------------------------------------------------------------
							((= (car itm) 0)	; type entity
								(setq RtnN (strcat RtnN "(0 . \"" (cdr itm) "\")")) 
							)
							((= (car itm) 100)	; type entity
								(setq RtnN (strcat RtnN "(100 . \"" (cdr itm) "\")")) 
							)
							((= (car itm) 8)	; layer
								(setq RtnN (strcat RtnN "(8 . \"" (cdr itm) "\")")) 
							)
							((= (car itm) 62)	; color
								(setq RtnN (strcat RtnN "(62 . " (ParseValue (cdr itm) NumberDec) ")"))
							)
							; ----------------------------------------------------------------
							((= (car itm) 90)	; Number of vertices 
								(setq RtnN (strcat RtnN "(90 . " (ParseValue (cdr itm) NumberDec) ")"))
							)
							((= (car itm) 70)	; Flag  default is 0 1 = Closed; 128 = Plinegen 
								(setq RtnN (strcat RtnN "(70 . " (ParseValue (cdr itm) NumberDec) ")"))
							)
							((= (car itm) 43)	; Constant width 
								(setq RtnN (strcat RtnN "(43 . " (ParseValue (cdr itm) NumberDec) ")"))
							)
							((= (car itm) 38)	; Elevation (optional; default = 0)
								(setq RtnN (strcat RtnN "(38 . " (ParseValue (cdr itm) NumberDec) ")"))
							)
							((= (car itm) 39)	; Thickness (optional; default = 0)
								(setq RtnN (strcat RtnN "(39 . " (ParseValue (cdr itm) NumberDec) ")"))
							)
							((= (car itm) 40)	; Starting width  (optional; default = 0) / Radius
								(setq RtnN (strcat RtnN "(40 . " (ParseValue (cdr itm) NumberDec) ")"))
							)
							((= (car itm) 41)	; End width  (optional; default = 0)
								(setq RtnN (strcat RtnN "(41 . " (ParseValue (cdr itm) NumberDec) ")"))
							)
							((= (car itm) 42)	; Bulge  (optional; default = 0)
								(setq RtnN (strcat RtnN "(42 . " (ParseValue (cdr itm) NumberDec) ")"))
							)
							((= (car itm) 50)	; Start Angle
								(setq RtnN (strcat RtnN "(50 . " (ParseValue (cdr itm) NumberDec) ")"))
							)
							((= (car itm) 51)	; End Angle
								(setq RtnN (strcat RtnN "(51 . " (ParseValue (cdr itm) NumberDec) ")"))
							)
							((= (car itm) 10)	; Start
								(if (= (length itm) 4)
									(setq RtnN (strcat RtnN "(10 " 	(ParseValue (car (cdr itm)) NumberDec) " " 
																	(ParseValue (cadr (cdr itm)) NumberDec) " " 
																	(ParseValue (caddr (cdr itm)) NumberDec) ")")) 
								)
								(if (= (length itm) 3)
									(setq RtnN (strcat RtnN "(10 " 	(ParseValue (car (cdr itm))  NumberDec) " " 
																	(ParseValue (cadr (cdr itm))  NumberDec) ")")) 
								)
							)
							((= (car itm) 11)	; End
								(if (= (length itm) 4)
									(setq RtnN (strcat RtnN "(11 " 	(ParseValue (car (cdr itm))  NumberDec) " " 
																	(ParseValue (cadr (cdr itm))  NumberDec) " " 
																	(ParseValue (caddr (cdr itm))  NumberDec) ")")) 
								)
								(if (= (length itm) 3)
									(setq RtnN (strcat RtnN "(11 " 	(ParseValue (car (cdr itm))  NumberDec) " " 
																	(ParseValue (cadr (cdr itm))  NumberDec) ")")) 
								)
							)

							((= (car itm) 210)	; normal axis
								(setq RtnN (strcat RtnN "(210 " (ParseValue (car (cdr itm))  NumberDec) " " 
																(ParseValue (cadr (cdr itm))  NumberDec) " " 
																(ParseValue (caddr (cdr itm))  NumberDec) ")")) 
							)
						)
					)
					(setq RtnN (strcat RtnN ")"))
					(if (>= (strlen RtnN) MaxCharDxfDb$) 
						(progn 
							;(alert "Superato limite massimo caratteri DxfCode")
							(princ (strcat " -> Avvertimento Superato limite caratteri DxfCode " 
											(LM:rtos (strlen RtnN)  2 0) " "
											(LM:rtos MaxCharDxfDb$ 2 0)))
						)
					)
				)
			)
			;
			; extended Data  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			; (-3 ("PIATTO" (1002 . "{") (1000 . "CE") (1000 . "081264528") (1000 . "2") 
			; (1000 . "178-350") (1000 . "1") (1000 . "C872") (1000 . "300") (1000 . "S355J0") (1000 . "10") (1000 . "18/05/2019") (1000 . "8") (1002 . "}")))
			
			(if LstDxfCodeExtended
				(progn
					(setq RtnE (strcat "(-3 (\"" (nth 0 (nth 1 LstDxfCodeExtended)) "\" "))
					
					(foreach itm (cdr (nth 0 (cdr LstDxfCodeExtended)))
						;(princ itm) (princ "\n")
						(setq RtnE (strcat RtnE "(" (LM:rtos (car itm) 2 0) " . \"" (cdr itm) "\")")) 
					)
					(setq RtnE (strcat RtnE "))"))
					(if (>= (strlen RtnE) MaxCharDxfDb$) 
						(progn 
							;(alert "Superato limite massimo caratteri DxfCode")
							(princ (strcat " -> Superato limite caratteri DxfCode " 
											(LM:rtos (strlen RtnN)  2 0) " "
											(LM:rtos MaxCharDxfDb$ 2 0)))
						)
					)
				)
			)
		)
	)
	;(ExportCode Rtn)
	(list RtnN RtnE)
)
;
;
;
(defun GetSQLQueryStatement (TableName TagName TypeValue LstMetaQuery LstMetaOrder / IncludeExcludeSQLQueryStatemen OutOrder 
																					 itm Query Include Esclude Start Rtn)
	;
	;LstMetaQuery ("10" "11" "<20-25>" "-21") ---> (THIKNESSSHAPE='8' OR THIKNESSSHAPE='15' OR QUANTITYSHAPE BETWEEN '1' AND '3' AND NOT QUANTITYSHAPE='2')
	;
	(defun IncludeExcludeSQLQueryStatement (TagName TypeValue MetaQuery / Start End RtnInclude RtnEsclude) 
	
		(if (and TagName TypeValue MetaQuery)
			(progn
				(cond
				
					((and (vl-string-search "<" MetaQuery) (vl-string-search "-" MetaQuery) (vl-string-search ">" MetaQuery))
					
						(setq Start (splitxt MetaQuery "<" ))
						(setq Start (splitxt (nth 0 Start) "-" ))
						(setq End   (nth 0 (splitxt (nth 1 Start) ">" )))
						(setq Start (nth 0 Start))
			
						(if (= TypeValue "STR")
							(setq RtnInclude (strcat TagName " BETWEEN '"  Start "' AND '" End "'"))
							(setq RtnInclude (strcat TagName " BETWEEN "   Start  " AND " End))
						)
					)
					((= MetaQuery "<>")
						(setq RtnInclude (strcat TagName " LIKE '%'"))
					)
					(t

						(if (= (substr MetaQuery 1 1) "-")
							(if (= TypeValue "STR")
								(setq RtnEsclude (strcat "NOT " TagName "='" (substr MetaQuery 2 (strlen MetaQuery)) "'"))
								(setq RtnEsclude (strcat "NOT " TagName "="  (substr MetaQuery 2 (strlen MetaQuery))))
							)
							(if (= TypeValue "STR")
								(setq RtnInclude (strcat TagName "='" MetaQuery "'"))
								(setq RtnInclude (strcat TagName "="  MetaQuery))
							)
						)
					)
				)
			)
		)
		(list RtnInclude RtnEsclude)
	)
	;
	;LstOrderBy (list TagName1 ">" TagName "<" ....) ---> " ORDER BY TsgName1 ESC, TsgName2 DESC
	;
	(defun OutOrder (LstMetaOrder / Num LstTagOrder LstBooleanOrder Rtn)

		(if LstMetaOrder
			(progn
				(setq Rtn "ORDER BY")
				(setq Num 0)
				(repeat (/ (length LstMetaOrder) 2)
					(setq LstTagOrder     (append LstTagOrder (list (nth Num LstMetaOrder))))
					(if (= (nth (1+ Num) LstMetaOrder) ">")
						(setq LstBooleanOrder (append LstBooleanOrder (list "ASC")))
						(setq LstBooleanOrder (append LstBooleanOrder (list "DESC")))
					)
					(setq Num (+ 2 Num))
				)
				
				(setq Num 0)
				(repeat (length LstTagOrder)
					(if (= (1+ Num) (length LstTagOrder))
						(setq Rtn (strcat Rtn " " (nth Num LstTagOrder) " " (nth Num LstBooleanOrder)))
						(setq Rtn (strcat Rtn " " (nth Num LstTagOrder) " " (nth Num LstBooleanOrder) ",")) 		
					)
					(setq Num (1+ Num))
				)
			)
		)
		Rtn
	)
	;
	;
	;
	(if (and TableName TagName TypeValue LstMetaQuery)
		(progn
			(foreach itm LstMetaQuery
				(setq Query (IncludeExcludeSQLQueryStatement TagName TypeValue itm))
				(if (nth 0 Query) (setq Include (append Include (list (nth 0 Query)))))
				(if (nth 1 Query) (setq Esclude (append Esclude (list (nth 1 Query)))))
			)
	
			;(if (> (length Include) 1) (setq Rtn "(") (setq Rtn ""))
			(setq Rtn "")
			(setq Start T)
					
			(foreach itm Include
				(if Start
					(setq Rtn (strcat Rtn itm))
					(setq Rtn (strcat Rtn " OR "  itm))
				)
				(setq Start nil)
			)
			;(if (> (length Include) 1) (setq Rtn (strcat Rtn ")")))
	
			(foreach itm Esclude
				(if (/= Rtn "")
					(setq Rtn (strcat Rtn " AND " itm))
					(setq Rtn (strcat Rtn itm))
				)
			)
			(if LstMetaOrder
				; ORDER BY Country ASC, CustomerName DESC
				(setq Rtn (strcat "SELECT * FROM " TableName " WHERE " Rtn " " (OutOrder LstMetaOrder)))
				(setq Rtn (strcat "SELECT * FROM " TableName " WHERE " Rtn))
			)
			;(princ "\n") (princ Rtn)
		)
	)
	Rtn
)
;
;
;
(defun ExportShapeToSql (/ CalcQtyDeduct DbFileName Rtn itm i LstEname LstChk)


	;(cond 
	;	((= CalcQtyDeduct$ "0")
	;		(setq Rtn (GuiSelPiecesShape (GetTableStockShapeNesting) (strcat SetupPathEasyCut$ "Tmp\\ShapeSql.shp") 1))
	;	)
	;	((= CalcQtyDeduct$ "1")
	;		(setq Rtn (GuiSelPiecesShape (GetTableStockDeductShapeNesting) (strcat SetupPathEasyCut$ "Tmp\\ShapeSql.shp") 1))
	;	)
	;	(t
	;		(setq Rtn (GuiSelPiecesShape (GetTableStockShapeNesting) (strcat SetupPathEasyCut$ "Tmp\\ShapeSql.shp") 1))
	;		(setq CalcQtyDeduct$ "0")
	;	)
	;)
	(setq CalcQtyDeduct CalcQtyDeduct$)
	(setq CalcQtyDeduct$ "-1")
	(setq NameHeadDcl$ "Lista export SQL")
	(setq Rtn (GuiSelPiecesShape (GetTableStockShapeNesting) (strcat SetupPathEasyCut$ "Tmp\\ShapeSql.shp") 1))
	(setq CalcQtyDeduct$ CalcQtyDeduct)
	
	(if (car Rtn)
		(progn
			;(setq DbFileName (MyGetField (vl-registry-read EasyCutRegistryPath$ "PathSearch") nil "*.db"))
			
			(if (setq DbFileName (OpenFileDialog  (list (vl-registry-read EasyCutRegistryPath$ "PathSearch") "ExportShape.db" "*.db" "Export Sql Shape" nil)))
				(progn
					(setq DbFileName (strcat (car DbFileName) "\\" (vl-filename-base (cadr DbFileName)) ".db"))
					
					(if (findfile DbFileName)
						(if (= (LM:popup "avvertimento" (strcat "Il file " DbFileName " esite "
																"\n\n vuoi sovrascriverlo ?\n\n") (+ 4 48 4096)) 6)
							(ResetFileDbShape DbFileName)
							(exit)
						)
						(ResetFileDbShape DbFileName)
					)
					
					(vl-registry-write EasyCutRegistryPath$ "PathSearch" (vl-filename-directory  DbFileName))
					
					(StartProgressBar      "Extract Ename Shape:" (length (cadr Rtn)))
					
					(foreach itm (LM:ss->ent (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShape)))))
						(setq LstChk (append LstChk (list (list (GetIdShape itm) itm))))
					)
					(foreach itm (cadr Rtn)
						(if (setq LstAss (assoc (nth 1 itm) LstChk))
							(setq LstEname (cons (cadr LstAss) LstEname))
						)
						(UpDateProgressBar)
					)
					(ClearProgressBar)
					;
					(StartProgressBar      (strcat "Export to SQL file -> " DbFileName) (length LstEname))
					(setq i 0)
					(foreach itm LstEname
						(princ (strcat "\n" (nth 2 (nth i (cadr Rtn))) " " (nth 3 (nth i (cadr Rtn))) " " (nth 4 (nth i (cadr Rtn)))))
						(Shape->Sql DbFileName itm)
						(UpDateProgressBar)
						(setq i (1+ i))		
					)
					(ClearProgressBar)
					(LM:popup "Info" (strcat "Esportati n. " (LM:rtos (length LstEname) 2 0) " contorni") (+ 0 64 4096))
				)
			)
		)
		(LM:popup "Info" (strcat "Nessun contorno esportato") (+ 0 64 4096))
	)
)
;
;
;
(defun ImportShapeFromSql (/ MakeTableforGuiShape
							 DbFileName TableName TagName TypeValue LstMetaQuery OrderBy Rtn itm LstShape
							 LstPtInsert Ssel MinMaxSsel MaxCatch)

	
	(defun MakeTableforGuiShape (LstTableNesting / ConvertMetaDataToString 
												   itm Rtn)
												   
		(defun ConvertMetaDataToString (LstMetaData / itm Rtn)
				(foreach itm LstMetaData
					(cond
						((= (type itm) 'REAL)
							(setq Rtn (append Rtn (list (LM:rtos itm 2 2))))
						)
						((= (type itm) 'int)
							(setq Rtn (append Rtn (list (itoa itm))))
						)
						((= (type itm) 'ENME)
							(setq Rtn (append Rtn (list (vl-princ-to-string itm))))
						)
						((= (type itm) 'STR)
							(setq Rtn (append Rtn (list itm)))
						)
					)
				)
				Rtn
			)	
			(foreach itm LstTableNesting
				;	       0         1      2    3     4       5    6       7      8     9    10    11     12         13  14  15 
				;itm ("465046357" "C872"  "300" "-"  "178-363" 4   "-"    "S355J0" 3.0  325.0 300.0 "1"  "08/06/2019" "-" "-" "-")
				;        "ID"     "ORDER" "PH" "FAM" "MARK"   "QT" "NAME" "MAT"  "THK" "LG"  "WD"  "CUT" "DATE"      "F1" "F2" "F3"))
				;
				;Itm\tIdent\tOrder\tPhase\tMark\tQuantity\tThikness\tLength\tHeight\tMaterial
				;
				(setq itm (ConvertMetaDataToString itm))
				(setq Rtn (append Rtn (list (list 	(nth 0  itm)	;Id
													(nth 1  itm)	;Order
													(nth 2  itm)	;Phase
													;(nth 3  itm)	;Family
													(nth 4  itm)	;Mark
													(nth 5  itm)	;Quantity
													;(nth 6  itm)	;Name
													(nth 8  itm)	;Thikness
													(nth 9 itm)		;Length
													(nth 10 itm)	;Height
													(nth 7  itm)	;Material
													(nth 12 itm)	;Date
													(if (= (nth 11 itm) "1") "Antiorario" "Orario")
													;(nth 12 itm)	;Cut				
													;(nth 14 itm)	;Flag1
													;(nth 15 itm)	;Flag2
													;(nth 16 itm)	;Flag3
				))))
			)
		Rtn
	)
	;
	; Main ++++++++++++++
	;
	(setq TableName TableInfoShape$)
	(setq TagName "IDSHAPE")
	(setq TypeValue "STR")
	(setq NameHeadDcl$ "Lista import da SQL")
	(setq LstMetaQuery (list "<>"))
	(setq OrderBy      (list "ORDERSHAPE" ">" "PHASESHAPE" ">" "MARKSHAPE" ">"))
	
	;(setq DbFileName (MyGetField (vl-registry-read EasyCutRegistryPath$ "PathSearch") nil "*.db"))
	
	(if (setq DbFileName (OpenFileDialog (list (vl-registry-read EasyCutRegistryPath$ "PathSearch") nil "*.db"	"Import Sql Shape" nil T)))
		(if (findfile (setq DbFileName (strcat (car DbFileName) "\\" (vl-filename-base (cadr DbFileName)) ".db")))
			(progn
				(PurgeBlockLoop)
				(Dsql_Open DbFileName)
					(if (setq Rtn (Dsql_query DbFileName (GetSQLQueryStatement TableName TagName TypeValue LstMetaQuery OrderBy)))
						(setq Rtn (cdr Rtn))
					)
				(Dsql_Close DbFileName)
				(vl-registry-write EasyCutRegistryPath$ "PathSearch" (vl-filename-directory  DbFileName))
				(setq Rtn (GuiSelPiecesShape (MakeTableForGuiShape Rtn) (strcat SetupPathEasyCut$ "Tmp\\ShapeSql.shp") 0))
				;(
				;	("291388652" "C750" "10" "1001" "2" "40.00" "5281.50" "2393.00" "S355J2+N" "10/11/2020" "Antiorario") 
				;	("244650570" "C750" "10" "1002" "2" "40.00" "3440.50" "2393.00" "S355J2+N" "10/11/2020" "Antiorario")
				;)
				; check IdShape +++++++++++++++++++++++++++++++++++++++
				(foreach itm (cadr Rtn) (setq LstShape (append LstShape (list (cdr itm)))))
				(foreach itm (GetLstIdEntity)
					(if (assoc itm LstShape)
						(progn
							(LM:popup "Avvertimento" (strcat "IDSHAPE " itm " gia' presente nel disegno (non verra' importato) ") (+ 0 64 4096))
							(princ (strcat "\nIDSHAPE " itm " gia' presente nel disegno (non verra' importato) "))
							(setq LstShape (LM:RemoveOnce (assoc itm LstShape) LstShape))
						)
					)
				)
				; +++++++++++++++++++++++++++++++++++++++++++++++++++++
		
				(setq LstPtInsert (GetPreviewNestingShapeDbase DbFileName LstShape))
				(setq Ssel        (NestingShapeDbase DbFileName LstShape LstPtInsert))
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
					(LM:popup "Info" (strcat "Nessun contorno importato") (+ 0 64 4096))
				)
			)
			(LM:popup "Info" (strcat "Il file  " DbFileName "  non esiste !") (+ 0 48 4096))
		)
	)
)	
;
;
;
(defun GetPreviewNestingShapeDbase (DbFileName LstShape / *error*
															Out Ssel LstEnameShape itm Rtn)

	(defun *error* (msg / Conta )
		(setq Conta 0)
		(DeleteSsel Ssel)
	)
	;
	;
	;
	(if (and DbFileName LstShape)
		(progn
			(setq Out (PreviewNestingShapeDbase DbFileName LstShape))
			(setq Ssel          (nth 0 Out))
			(setq LstEnameShape (nth 1 Out))
			(if Ssel 
				(progn
					(setq MinMaxSsel	(LM:SSBoundingBox Ssel))
			
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
	Rtn
)
;
;
;
(defun PreviewNestingShapeDbase (DbFileName LstShape / DimScreen StepColumn Xdstv Ydstv StartXdstv StartYDstv LstY EnameShape LstOutEname
													   i itm itm1 DataDstv LstEnameShape Ssel minmax Width Height point1 point2 Rtn)
 
	(if (and DbFileName LstShape)
		(progn
			(setq DimScreen (VpCoords))
			(setq StepColumn 1)
			(setq Xdstv (/ (+ (nth 0 (nth 0 DimScreen)) (nth 0 (nth 1 DimScreen))) 2.0))
			(setq Ydstv (/ (+ (nth 1 (nth 0 DimScreen)) (nth 1 (nth 1 DimScreen))) 2.0))
			(setq StartXdstv Xdstv)
			(setq StartYDstv Ydstv)
			(setq LstY nil)
			(setq Rtn (ssadd))
			
			(StartProgressBar      "Preview Shape "  (length LstShape))

			(foreach itm LstShape
			
				(setq EnameShape 	(Sql->Shape DbFileName (car itm) "100" nil))
				(setq LstOutEname   (append LstOutEname EnameShape))
				(setq Ssel 			(PreviewInquadraShape (car EnameShape)))
				(setq minmax 		(LM:SSBoundingBox Ssel))
				(setq Width			(abs (- (nth 0 (nth 1 minmax)) (nth 0 (nth 0 minmax)))))
				(setq Height		(abs (- (nth 1 (nth 2 minmax)) (nth 1 (nth 1 minmax)))))
				
				(setq LstY (append LstY (list Height)))
				
				(setq point1 (vlax-3d-point  (nth 0 (nth 0 minmax))   (nth 1 (nth 0 minmax))   0.0)
					  point2 (vlax-3d-point  StartXDstv StartYDstv  0.0)
				)

				(foreach itm1 (LM:ss->ent Ssel) (vla-Move (vlax-ename->vla-object itm1) point1 point2))
						
				(setq StepColumn (1+ StepColumn))
						
				(if (> StepColumn MaxColumn$)
					(setq 	StartXDstv Xdstv
							StartYDstv (+ StartYDstv (apply 'max LstY) (nth 1 MargColumn$))
							LstY nil
							StepColumn 1
					)
					(setq 	StartXDstv (+ StartXDstv Width (nth 0 MargColumn$)))
				)

				(foreach itm1 (LM:ss->ent Ssel)	(ssadd itm1 Rtn))
				(UpDateProgressBar)
			)
			(ClearProgressBar)
		)
	)
	(list Rtn LstOutEname)
)
;
;
;
(defun NestingShapeDbase (DbFileName LstShape LstPtInsert / i Rtn Conta0 itm itm1 PtInsert EnameShape Ssel)

	(if (and DbFileName LstShape LstPtInsert)
		(progn
			(setq Conta0 0)
			(setq Rtn (ssadd))

			(StartProgressBar      (strcat "Import from SQL file -> " DbFileName) (length LstShape))
			(foreach itm LstShape
				(princ (strcat "\nImport " (nth 0 itm) " " (nth 1 itm) " " (nth 2 itm) " " (nth 3 itm)))
				(setq PtInsert 		 (nth Conta0 LstPtInsert)) 
				(setq EnameShape     (GraphicShapeDbase DbFileName (car itm) PtInsert))
				(setq Ssel 		     (InquadraShape EnameShape nil))
				(foreach itm1 (LM:ss->ent Ssel) (ssadd itm1 Rtn))
				(setq Conta0 (1+ Conta0))
				(UpDateProgressBar)
			)
			(ClearProgressBar)
			
			(if (= (sslength Rtn) 0)
				(setq Rtn nil)
			)
		)
	)
	Rtn
)
;
;
;
(defun GraphicShapeDbase (DbFileName IdShape PtInsert / LstEnameShape PtAnchor itm EnameTriggerShape)

	(if (and DbFileName IdShape PtInsert)
		(progn

			(setq LstEnameShape     (Sql->Shape DbFileName IdShape "110" T))
			(setq EnameTriggerShape	(Sql->Shape DbFileName IdShape "001" T))
			
			(vla-getboundingbox (vlax-ename->vla-object (car LstEnameShape)) 'mnl 'mxl)
			(setq PtAnchor mnl)
			(foreach itm LstEnameShape
		    	(vla-move (vlax-ename->vla-object itm) PtAnchor (vlax-3d-point PtInsert))
			)
			(foreach itm EnameTriggerShape
				(vla-move (vlax-ename->vla-object itm) PtAnchor (vlax-3d-point PtInsert))
			)
			
			(ZoomEname (car LstEnameShape) 50)
			(SetShape  (car LstEnameShape))
			(ChangeRecordShape (car LstEnameShape) 2 IdShape)
		)
	)
	(car LstEnameShape)
)
;
;
;
;
;
;
;
(defun ExportSheetToSql (/ DbFileName Rtn itm i LstEname)

	(setq NameHeadDcl$ "Lista export SQL")
	(setq Rtn (GuiSelPiecesSheet (GetTableStockSheetNesting 3) (strcat SetupPathEasyCut$ "Tmp\\SheetSql.shp") 1))
	(if (car Rtn)
		(progn
			;(setq DbFileName (MyGetField (vl-registry-read EasyCutRegistryPath$ "PathSearch") nil "*.db"))

			(if (setq DbFileName (OpenFileDialog  (list (vl-registry-read EasyCutRegistryPath$ "PathSearch") "ExportSheet.db" "*.db" "Export Sql Sheet" nil T)))
				(progn
					(setq DbFileName (strcat (car DbFileName) "\\" (vl-filename-base (cadr DbFileName)) ".db"))
					
					(if (findfile DbFileName)
						(if (= (LM:popup "avvertimento" (strcat "Il file " DbFileName " esite "
																"\n\n vuoi sovrascriverlo ?\n\n") (+ 4 48 4096)) 6)
							(ResetFileDbSheet DbFileName)
							(exit)
						)
						(ResetFileDbSheet DbFileName)
					)
					
					(vl-registry-write EasyCutRegistryPath$ "PathSearch" (vl-filename-directory  DbFileName))
					
					(StartProgressBar      "Extract Ename Sheet:" (length (cadr Rtn)))
					(foreach itm (cadr Rtn)
						(setq LstEname (cons (GetEnameSheetById (nth 1 itm)) LstEname))
						(UpDateProgressBar)
					)
					(ClearProgressBar)
					
					(StartProgressBar      (strcat "Export to SQL file -> " DbFileName) (length LstEname))
					(setq i 0)
					(foreach itm LstEname
						(princ (strcat "\n"  (nth 1 (nth i (cadr Rtn))) " "
											 (nth 2 (nth i (cadr Rtn))) " " 
											 (nth 3 (nth i (cadr Rtn))) "x" 
											 (nth 4 (nth i (cadr Rtn))) "x"
											 (nth 5 (nth i (cadr Rtn)))))
											 
						(Sheet->Sql DbFileName itm)
						(UpDateProgressBar)
						(setq i (1+ i))		
					)
					(ClearProgressBar)
					(LM:popup "Info" (strcat "Esportate n. " (LM:rtos (length LstEname) 2 0) " lamiere") (+ 0 64 4096))
				)
			)
		)
		(LM:popup "Info" (strcat "Nessun contorno esportato") (+ 0 64 4096))
	)
)
;
;
;
(defun ImportSheetFromSql (/ MakeTableforGuiSheet
							 TableName TagName TypeValue LstMetaQuery OrderBy DbFileName Rtn LstSheet LstPtInsert Ssel 
							 MinMaxSsel MinCatch MaxCatch)


	(defun MakeTableForGuiSheet (LstTableNesting / ConvertMetaDataToString 
												   itm Rtn)
												   
		(defun ConvertMetaDataToString (LstMetaData / itm Rtn)
				(foreach itm LstMetaData
					(cond
						((= (type itm) 'REAL)
							(setq Rtn (append Rtn (list (LM:rtos itm 2 2))))
						)
						((= (type itm) 'int)
							(setq Rtn (append Rtn (list (itoa itm))))
						)
						((= (type itm) 'ENME)
							(setq Rtn (append Rtn (list (vl-princ-to-string itm))))
						)
						((= (type itm) 'STR)
							(setq Rtn (append Rtn (list itm)))
						)
					)
				)
				Rtn
			)	
			(foreach itm LstTableNesting
				;	     0        1       2       3        4        5       6        7
				;itm ("16414" "stokgg"  2500.0  5000.0    1.0     12.5    98.13    "1")
				;       "ID"   "STOK"  "WIDTH" "LENGTH" "THICK" "SURFACE" "WEIGHT" "MAT" 
				;
				;Itm\tIdent\tStok\tWidth\tLength\tThick\tSurface\tWeight\tMat
				;
				(setq itm (ConvertMetaDataToString itm))
				(setq Rtn (append Rtn (list (list 	(nth 0  itm)	;Ident
													(nth 1  itm)	;Stok
													(nth 2  itm)	;Width
													(nth 3  itm)	;Length
													(nth 4  itm)	;Thick
													(nth 5  itm)	;Surface
													(nth 6  itm)	;Weight
													(nth 7  itm)	;Material
				))))
			)
		Rtn
	)

	;
	; Main ++++++++++++++
	;
	(setq TableName TableInfoSheet$)
	(setq TagName "IDSHEET")
	(setq TypeValue "STR")
	(setq NameHeadDcl$ "Lista import da SQL")
	(setq LstMetaQuery (list "<>"))
	(setq OrderBy      (list "NAMESHEET" ">" "THICKSHEET" ">" "WIDTHSHEET" ">" "HEIGHTSHEET" ">"))
	
	;(setq DbFileName (MyGetField (vl-registry-read EasyCutRegistryPath$ "PathSearch") nil "*.db"))
	
	(if (setq DbFileName (OpenFileDialog  (list (vl-registry-read EasyCutRegistryPath$ "PathSearch") nil "*.db"	"Import Sql Sheet" nil T)))
		(if (setq DbFileName (findfile (strcat (car DbFileName) "\\" (vl-filename-base (cadr DbFileName)) ".db")))
			(progn
				(vl-registry-write EasyCutRegistryPath$ "PathSearch" (vl-filename-directory DbFileName))
				(PurgeBlockLoop)
				(Dsql_Open DbFileName)
					(if (setq Rtn (Dsql_query DbFileName (GetSQLQueryStatement TableName TagName TypeValue LstMetaQuery OrderBy)))
						(setq Rtn (cdr Rtn))
					)
				(Dsql_Close DbFileName)
				(setq Rtn (GuiSelPiecesSheet (MakeTableForGuiSheet Rtn) (strcat SetupPathEasyCut$ "Tmp\\SheetSql.shp") 0))
				
				;(foreach itm (cadr Rtn)
				;	(setq LstIdSheet (cons (cadr itm) LstIdSheet))
				;)
				;(setq LstSheet (reverse LstSheet))
				; check IdSheet +++++++++++++++++++++++++++++++++++++++
				(foreach itm (cadr Rtn) (setq LstSheet (append LstSheet (list (cdr itm)))))
				(foreach itm (GetListIdSheet)
					(if (assoc itm LstSheet)
						(progn
							(LM:popup "Avvertimento" (strcat "IDSHEET " itm " gia' presente nel disegno (non verra' importato) ") (+ 0 64 4096))
							(princ (strcat "\nIDSHEET " itm " gia' presente nel disegno (non verra' importato) "))
							(setq LstSheet (LM:RemoveOnce (assoc itm LstSheet) LstSheet))
						)
					)
				)
				; +++++++++++++++++++++++++++++++++++++++++++++++++++++
				(setq LstPtInsert (GetPreviewNestingSheetDbase DbFileName LstSheet))
				(setq Ssel        (NestingSheetDbase DbFileName LstSheet LstPtInsert))
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
					(LM:popup "Info" (strcat "Nessuna lamiera importata") (+ 0 64 4096))
				)
			)
			(LM:popup "Info" (strcat "Il file  " DbFileName "  non esiste !") (+ 0 48 4096))
		)
	)
)
;
;
;
(defun GraphicSheetDbase (DbFileName IdSheet PtInsert / LstEnameSheet LstEnameExShapeOnSheet LstEnameInShapeOnSheet LstEnameTriggerShapeOnSheet
													    PtAnchor itm EnameRule IdShape)

	(if (and DbFileName IdSheet PtInsert)
		(progn

			(setq LstEnameSheet     	  		(car   (Sql->Sheet DbFileName IdSheet "1000" T)))
			(setq LstEnameExShapeOnSheet    	(cadr  (Sql->Sheet DbFileName IdSheet "0100" T)))
			(setq LstEnameInShapeOnSheet    	(cadr  (Sql->Sheet DbFileName IdSheet "0010" T)))
			(setq LstEnameTriggerShapeOnSheet	(caddr (Sql->Sheet DbFileName IdSheet "0001" T)))
			
			(vla-getboundingbox (vlax-ename->vla-object (car LstEnameSheet)) 'mnl 'mxl)
			(setq PtAnchor mnl)
			(foreach itm LstEnameSheet
		    	(vla-move (vlax-ename->vla-object itm) PtAnchor (vlax-3d-point PtInsert))
			)
			(foreach itm LstEnameExShapeOnSheet
		    	(vla-move (vlax-ename->vla-object itm) PtAnchor (vlax-3d-point PtInsert))
			)
			(foreach itm LstEnameInShapeOnSheet
		    	(vla-move (vlax-ename->vla-object itm) PtAnchor (vlax-3d-point PtInsert))
			)
			(foreach itm LstEnameTriggerShapeOnSheet
				(vla-move (vlax-ename->vla-object itm) PtAnchor (vlax-3d-point PtInsert))
			)
			
			(ZoomEname (car LstEnameSheet) 50)
			(SetSheet  (car LstEnameSheet))
			(setq EnameRule (PrintRuleSheet (car LstEnameSheet))) 
			(setq EnameRule (LogoSheet (car LstEnameSheet) EnameRule))
			
			(foreach itm LstEnameExShapeOnSheet
				(setq IdShape (GetIdShape itm))
				(SetShape  itm)
				(ChangeRecordShape itm 2 IdShape)
			)
		)
	)
	(append LstEnameSheet LstEnameExShapeOnSheet LstEnameInShapeOnSheet LstEnameTriggerShapeOnSheet (list EnameRule))
)
;
;
;
(defun NestingSheetDbase (DbFileName LstSheet LstPtInsert / i Rtn Conta0 itm itm1 PtInsert LstEname Ssel)

	(if (and DbFileName LstSheet LstPtInsert)
		(progn
			(setq Conta0 0)
			(setq Rtn (ssadd))
			
			(StartProgressBar (strcat "Import from SQL file -> " DbFileName) (length LstSheet))
			
			(foreach itm LstSheet
				(princ (strcat "\nImport " (nth 0 itm) " " (nth 1 itm) " " (nth 2 itm) "x" (nth 3 itm) "x" (nth 4 itm)))
				(setq PtInsert	(nth Conta0 LstPtInsert)) 
				(setq LstEname  (GraphicSheetDbase DbFileName (car itm) PtInsert))
				
				(foreach itm1 	LstEname (ssadd itm1 Rtn))
				(setq Conta0 (1+ Conta0))
				(UpDateProgressBar)
			)
			(ClearProgressBar)
			(if (= (sslength Rtn) 0)
				(setq Rtn nil)
			)
		)
	)
	
	Rtn
)
;
;
;
(defun GetPreviewNestingSheetDbase (DbFileName LstSheet / *error*
															MinMaxSsel Out Ssel LstEnameSheet itm Rtn)

	(defun *error* (msg / Conta )
		(setq Conta 0)
		(DeleteSsel Ssel)
	)
	;
	;
	;
	(if (and DbFileName LstSheet)
		(progn
			(setq Out (PreviewNestingSheetDbase DbFileName LstSheet))
			(setq Ssel          (nth 0 Out))
			(setq LstEnameSheet (nth 1 Out))
			(if Ssel 
				(progn
					(setq MinMaxSsel	(LM:SSBoundingBox Ssel))
			
					(command "._Move" Ssel "" (car MinMaxSsel) pause)
					(while (not (FindAreaAvailable Ssel))
						(command "._Move" Ssel "" (getvar "LASTPOINT") pause)
					)
					(foreach itm LstEnameSheet
						(vla-getboundingbox (vlax-ename->vla-object itm) 'mnl 'mxl)
						(setq Rtn (append Rtn (list (vlax-safearray->list mnl))))
					)
					
					(DeleteSsel Ssel)
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun PreviewInquadraSheet (EnameSheet / MaxMin Po Width Height EnameBom Rtn)
	(if EnameSheet
		(progn
		
			(vla-getboundingbox (vlax-ename->vla-object EnameSheet) 'mnl 'mxl)
			(setq MaxMin  (BoundingBoxLstEname (list EnameSheet)))
			
			(setq Po          (list (- (car (nth 0 MaxMin)) 560.0) (- (cadr (nth 0 MaxMin)) 960.0)))
			(setq Width       (+ (distance (nth 0 MaxMin) (nth 1 MaxMin))  600.0))
			(setq Height      (+ (distance (nth 1 MaxMin) (nth 2 MaxMin)) 1000.0))
			(setq EnameBom    (MakeRectangle Po Width Height))
			
													
			(setq Rtn (LstEname->Ssget (list EnameSheet EnameBom)))
		)
	)
	Rtn
)
;
;
;
(defun PreviewNestingSheetDbase (DbFileName LstSheet / DimScreen StepColumn Xdstv Ydstv StartXdstv StartYDstv LstY EnameSheet LstOutEname
													   i itm itm1 DataDstv LstEnameShape Ssel minmax Width Height point1 point2 Rtn)
 
 
	(if (and DbFileName LstSheet)
		(progn
			(setq DimScreen (VpCoords))
			(setq StepColumn 1)
			(setq Xdstv (/ (+ (nth 0 (nth 0 DimScreen)) (nth 0 (nth 1 DimScreen))) 2.0))
			(setq Ydstv (/ (+ (nth 1 (nth 0 DimScreen)) (nth 1 (nth 1 DimScreen))) 2.0))
			(setq StartXdstv Xdstv)
			(setq StartYDstv Ydstv)
			(setq LstY nil)
			(setq Rtn (ssadd))
			
			(StartProgressBar "Preview Sheet:" (length LstSheet))

			(foreach itm LstSheet
			
				(setq EnameSheet 	(car (Sql->Sheet DbFileName (car itm) "1000" nil)))
				(setq LstOutEname   (append LstOutEname EnameSheet))
				(setq Ssel 			(PreviewInquadraSheet (car EnameSheet)))
				(setq minmax 		(LM:SSBoundingBox Ssel))
				(setq Width			(abs (- (nth 0 (nth 1 minmax)) (nth 0 (nth 0 minmax)))))
				(setq Height		(abs (- (nth 1 (nth 2 minmax)) (nth 1 (nth 1 minmax)))))
				
				(setq LstY (append LstY (list Height)))
				
				(setq point1 (vlax-3d-point  (nth 0 (nth 0 minmax))   (nth 1 (nth 0 minmax))   0.0)
					  point2 (vlax-3d-point  StartXDstv StartYDstv  0.0)
				)

				(foreach itm1 (LM:ss->ent Ssel) (vla-Move (vlax-ename->vla-object itm1) point1 point2))
						
				(setq StepColumn (1+ StepColumn))
						
				(if (> StepColumn MaxColumn$)
					(setq 	StartXDstv Xdstv
							StartYDstv (+ StartYDstv (apply 'max LstY) (nth 1 MargColumn$))
							LstY nil
							StepColumn 1
					)
					(setq 	StartXDstv (+ StartXDstv Width (nth 0 MargColumn$)))
				)

				(foreach itm1 (LM:ss->ent Ssel)	(ssadd itm1 Rtn))
				
				(UpDateProgressBar)
			)
			(ClearProgressBar)
		)
	)
	(list Rtn LstOutEname)
)
;
;
;
