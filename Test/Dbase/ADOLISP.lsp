; http://www.connectionstrings.com/
; https://www.w3schools.com/sql
; http://www.theswamp.org
; user andrea1
; passwd Chisiamo
;
;
(setq Path (vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
;----------------------------------------------------------------------------------------------

(setq DbaseInfoShapeFile$ 		(strcat Path "\\Dbase\\InfoShape.mdb")) ;access 2002-2003
(setq DbaseInfoShapeTblName$ 	"INFOSHAPE")
(setq DbaseInfoShapeData$ 		(list 	"IDSHAPE" "ORDERSHAPE" "PHASESHAPE" "FAMILYSHAPE" "MARKSHAPE" "QUANTITYSHAPE" "NAMESHAPE" "MATERIALSHAPE"
										"THIKNESSSHAPE" "LENGTHSHAPE" "WIDTHSHAPE" "CUTSHAPE" "DATESHAPE" "FLAG1SHAPE" "FLAG2SHAPE" "FLAG3SHAPE"))

;----------------------------------------------------------------------------------------------

(setq DbaseExShapeFile$ 	(strcat Path "\\Dbase\\ExShape.mdb")) ;access 2002-2003
(setq DbaseExShapeTblName$ 	"EXTERNALSHAPE")
(setq DbaseExShapeData$ 	(list 	"IDSHAPE" "DXFLISTSHAPE" "EXTENDEDDATA"))

;----------------------------------------------------------------------------------------------

(setq DbaseInShapeFile$ 	(strcat Path "\\Dbase\\InShape.mdb")) ;access 2002-2003									
(setq DbaseInShapeTblName$ 	"INTERNALSHAPE")									
(setq DbaseInShapeData$ 	(list 	"IDSHAPE" "IDSHAPEINT" "DXFLISTSHAPE" "EXTENDEDDATA"))

;----------------------------------------------------------------------------------------------

(setq DbaseTriggerFile$ 		(strcat Path "\\Dbase\\Trigger.mdb")) ;access 2002-2003	
(setq DbaseTriggerExtTblName$ 	"TRIGGEREXT")								
(setq DbaseTriggerIntTblName$ 	"TRIGGERINT")
(setq DbaseTriggerExtData$ 		(list 	"IDSHAPE" "IDSHAPEEXT" "DXFLISTSHAPE" "EXTENDEDDATA"))
(setq DbaseTriggerIntData$ 		(list 	"IDSHAPE" "IDSHAPEINT" "DXFLISTSHAPE" "EXTENDEDDATA"))

;----------------------------------------------------------------------------------------------

(setq DbaseConnectString$ 	"Provider=MSDASQL;Driver={Microsoft Access Driver (*.mdb)};DBQ=")
;(setq DbaseConnectString$ 	"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=")

;----------------------------------------------------------------------------------------------
;
;
;
(defun CreateSQLStatement (RowName LstValueName / ReturnSQLQueryStatement Include Esclude Start Rtn)

		; "10" "11" "<20,25>" "-21"
		;(THIKNESSSHAPE=8 OR THIKNESSSHAPE=15 OR QUANTITYSHAPE BETWEEN 1 AND 3 AND NOT QUANTITYSHAPE=2)
		
		(defun ReturnSQLQueryStatement (RowName Str / Start End RtnInclude RtnEsclude) 
		
			(if Str
				(progn
					(cond
					
						((and 	(vl-string-search "<" Str) 
								(vl-string-search "-" Str) 
								(vl-string-search ">" Str))
						
							(setq Start (splitxt Str "<" ))
							(setq Start (splitxt (nth 0 Start) "-" ))
							(setq End   (nth 0 (splitxt (nth 1 Start) ">" )))
							(setq Start (nth 0 Start))
							;Price BETWEEN 50 AND 60;
							(cond 
								(	(or (= RowName "QUANTITYSHAPE")
										(= RowName "THIKNESSSHAPE") 
										(= RowName "LENGTHSHAPE")
										(= RowName "WIDTHSHAPE")
									)
										(setq RtnInclude (strcat RowName " BETWEEN "  Start " AND " End))
								)
								(t
									(setq RtnInclude (strcat RowName " BETWEEN '"  Start "' AND '" End "'"))
								)
							)
						)
						
						
						((= Str "<>")
							(setq RtnInclude (strcat RowName " LIKE '%'"))
						)
						
						
						(t

							(cond 
								(	(or (= RowName "QUANTITYSHAPE")
										(= RowName "THIKNESSSHAPE") 
										(= RowName "LENGTHSHAPE")
										(= RowName "WIDTHSHAPE")
									)
										
										(if (= (substr Str 1 1) "-") 
											(setq RtnEsclude (strcat "NOT " RowName "=" (substr Str 2 (strlen Str))))
											(setq RtnInclude (strcat RowName "=" Str))
										)
								)
								(t
										(if (= (substr Str 1 1) "-")
											(setq RtnEsclude (strcat "NOT " RowName "='" (substr Str 2 (strlen Str)) "'"))
											(setq RtnInclude (strcat RowName "='" Str "'"))
										)
								)
							)
						)
					)
				)
			)
			(list RtnInclude RtnEsclude)
		)
		;
		;
		;
		(if (and RowName LstValueName)
			(progn
				(foreach itm LstValueName
					(setq Query (ReturnSQLQueryStatement RowName itm))
					(if (nth 0 Query) (setq Include (append Include (list (nth 0 Query)))))
					(if (nth 1 Query) (setq Esclude (append Esclude (list (nth 1 Query)))))
				)
			
		
				(if (> (length Include) 1) (setq Rtn "(") (setq Rtn ""))
				(setq Start T)
						
				(foreach itm Include
					(if Start
						(setq Rtn (strcat Rtn itm))
						(setq Rtn (strcat Rtn " OR "  itm))
					)
					(setq Start nil)
				)
				(if (> (length Include) 1) (setq Rtn (strcat Rtn ")")))
		
				(foreach itm Esclude
					(if (/= Rtn "")
						(setq Rtn (strcat Rtn " " itm))
						(setq Rtn (strcat Rtn itm))
					)
				)
			)
		)
		;(alert Rtn)
		Rtn
)
;					0		1				2		3	4	5	6	7		8				9					10		11	12	13	14	15
;(SelPiecesDbase 	nil (list "C872") (list "300") nil nil nil nil nil (list "<1,10>") (list "620" "610") (list "-540") nil nil nil nil nil)		
;
(defun SelPiecesDbase (	LstIdShape 			LstOrderShape 		LstPhaseShape 	LstFamilyShape 
						LstMarkShape 		LstQuantityShape 	LstNameShape 	LstMaterialShape 
						LstThiknessShape	LstLengthShape		LstWidthShape	LstCutShape 		
						LstDateShape 		LstFlag1Shape		LstFlag2Shape 	LstFlag3Shape 
						/
						NameDbFile tblName LstRowName ConnectString ConnectionObject SQLStatement
						SQLStatementIdShape		SQLStatementOrderShape 		SQLStatementPhaseShape 	
						SQLStatementFamilyShape SQLStatementMarkShape 		SQLStatementQuantityShape 
						SQLStatementNameShape 	SQLStatementMaterialShape	SQLStatementThiknessShape 
						SQLStatementLengthShape SQLStatementWidthShape		SQLStatementCutShape 	
						SQLStatementDateShape	SQLStatementFlag1Shape		SQLStatementFlag2Shape 	
						SQLStatementFlag3Shape Rtn Out)

	;"SELECT IDSHAPE FROM INFOSHAPE WHERE (ORDERSHAPE='C872' OR ORDERSHAPE='C872123') AND 
	;									  (PHASESHAPE='300'  OR PHASESHAPE='310' OR PHASESHAPE='422' OR PHASESHAPE='400')"
	;SELECT IDSHAPE FROM INFOSHAPE WHERE ORDERSHAPE='C872' AND PHASESHAPE='300' AND THIKNESSSHAPE BETWEEN 1 AND 10 
	; 									AND (LENGTHSHAPE=620 OR LENGTHSHAPE=610) AND NOT WIDTHSHAPE=540 NOT WIDTHSHAPE=393
					
	(setq NameDbFile DbaseInfoShapeFile$)
	(setq tblName DbaseInfoShapeTblName$)
	(setq LstRowName DbaseInfoShapeData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	
	(setq SQLStatementIdShape 		(CreateSQLStatement "IDSHAPE" 		LstIdShape))
	(setq SQLStatementOrderShape 	(CreateSQLStatement "ORDERSHAPE" 	LstOrderShape))
	(setq SQLStatementPhaseShape 	(CreateSQLStatement "PHASESHAPE"	LstPhaseShape))
 	(setq SQLStatementFamilyShape 	(CreateSQLStatement "FAMILYSHAPE"	LstFamilyShape)) 
	(setq SQLStatementMarkShape 	(CreateSQLStatement "MARKSHAPE"		LstMarkShape))
	(setq SQLStatementQuantityShape (CreateSQLStatement "QUANTITYSHAPE"	LstQuantityShape))
 	(setq SQLStatementNameShape 	(CreateSQLStatement "NAMESHAPE"		LstNameShape))
 	(setq SQLStatementMaterialShape (CreateSQLStatement "MATERIALSHAPE"	LstMaterialShape))
	(setq SQLStatementThiknessShape (CreateSQLStatement "THIKNESSSHAPE"	LstThiknessShape))
	(setq SQLStatementLengthShape   (CreateSQLStatement "LENGTHSHAPE"	LstLengthShape))
	(setq SQLStatementWidthShape    (CreateSQLStatement "WIDTHSHAPE"	LstWidthShape))
	(setq SQLStatementCutShape 		(CreateSQLStatement "CUTSHAPE"		LstCutShape))
	(setq SQLStatementDateShape 	(CreateSQLStatement "DATESHAPE"		LstDateShape))
 	(setq SQLStatementFlag1Shape 	(CreateSQLStatement "FLAG1SHAPE"	LstFlag1Shape))		
	(setq SQLStatementFlag2Shape 	(CreateSQLStatement "FLAG2SHAPE"	LstFlag2Shape))
	(setq SQLStatementFlag3Shape 	(CreateSQLStatement "FLAG3SHAPE"	LstFlag3Shape))

	(setq SQLStatement nil)
	
	(if SQLStatementIdShape
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementIdShape)			(setq SQLStatement (strcat SQLStatement " AND " SQLStatementIdShape))))
	(if SQLStatementOrderShape
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementOrderShape)		(setq SQLStatement (strcat SQLStatement " AND " SQLStatementOrderShape))))
	(if SQLStatementPhaseShape 		
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementPhaseShape) 		(setq SQLStatement (strcat SQLStatement " AND " SQLStatementPhaseShape))))
	(if SQLStatementFamilyShape 	
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementFamilyShape) 	(setq SQLStatement (strcat SQLStatement " AND " SQLStatementFamilyShape))))
	(if SQLStatementMarkShape 		
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementMarkShape) 		(setq SQLStatement (strcat SQLStatement " AND " SQLStatementMarkShape))))
	(if SQLStatementQuantityShape 	
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementQuantityShape) 	(setq SQLStatement (strcat SQLStatement " AND " SQLStatementQuantityShape))))
	(if SQLStatementNameShape 		
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementNameShape)	 	(setq SQLStatement (strcat SQLStatement " AND " SQLStatementNameShape))))
	(if SQLStatementMaterialShape 	
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementMaterialShape) 	(setq SQLStatement (strcat SQLStatement " AND " SQLStatementMaterialShape))))
	(if SQLStatementThiknessShape 	
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementThiknessShape) 	(setq SQLStatement (strcat SQLStatement " AND " SQLStatementThiknessShape))))
	(if SQLStatementLengthShape 	
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementLengthShape) 	(setq SQLStatement (strcat SQLStatement " AND " SQLStatementLengthShape))))
	(if SQLStatementWidthShape 	
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementWidthShape) 		(setq SQLStatement (strcat SQLStatement " AND " SQLStatementWidthShape))))
	(if SQLStatementCutShape 		
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementCutShape)		(setq SQLStatement (strcat SQLStatement " AND " SQLStatementCutShape))))
	(if SQLStatementDateShape		
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementDateShape)		(setq SQLStatement (strcat SQLStatement " AND " SQLStatementDateShape))))
	(if SQLStatementFlag1Shape		
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementFlag1Shape) 		(setq SQLStatement (strcat SQLStatement " AND " SQLStatementFlag1Shape))))
	(if SQLStatementFlag2Shape 		
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementFlag2Shape) 		(setq SQLStatement (strcat SQLStatement " AND " SQLStatementFlag2Shape))))
	(if SQLStatementFlag3Shape 		
		(if (not SQLStatement) 
				(setq SQLStatement SQLStatementFlag3Shape) 		(setq SQLStatement (strcat SQLStatement " AND " SQLStatementFlag3Shape))))
	
	(if SQLStatement
		(progn
			(setq SQLStatement (strcat "SELECT IDSHAPE FROM " tblName " WHERE " SQLStatement))
			(princ (strcat "\n" SQLStatement "\n"))
			(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
			(setq Out (ReadDbaseMultiField ConnectionObject SQLStatement))
			(ADOLISP_DisconnectFromDB ConnectionObject)
			
			(if (and (/= Out -1) (/= Out -2))
				(foreach itm (cdr Out)
					(setq Rtn (append Rtn (list (car itm))))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetLstInfoDataShape (LstIdShape / NameDbFile tblName LstRowName ConnectString itm Rtn LstData LstRtn)

	(if LstIdShape
		(progn
			(setq NameDbFile DbaseInfoShapeFile$)
			(setq tblName DbaseInfoShapeTblName$)
			(setq LstRowName DbaseInfoShapeData$)
			(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
			(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
			(if ConnectionObject
				(progn
				
					(foreach itm LstIdShape
						(setq Rtn (ReadDbase ConnectionObject tblName (nth 0 LstRowName) itm))
						(if (and (/= Rtn -1) (/= Rtn -2))	
							(progn
								(setq LstData (cdr Rtn))
								(setq LstRtn (append LstRtn (list (nth 0 LstData))))
							)
						)
					)
				)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
		)
	)
	LstRtn
)
;
;
;
(defun GuiSelectedPiecesDbase (/ LstIDShape xx SwapModeTile GetChooseSelPiecesDbase LstDataShape LstChooseSelPiecesDbase Rtn)

	(defun SwapModeTile (Mode SetTile)
		;(setq Mode (get_tile GetTile))
		(if (= Mode "0") (mode_tile SetTile 1))
		(if (= Mode "1") (mode_tile SetTile 0))
	)
	;
	;
	;
	(defun GetChooseSelPiecesDbase ( / 	CeckValue
										Id 
										Order 
										Phase
										Family
										Mark
										Quantity
										Name
										Material 
										Thikness
										Lngth
										Height
										Cut
										Date
										Flag1
										Flag2
										Flag3
										Rtn)
				

		(defun CeckValue (Str Mode / Rtn)
		
			;(if (and Str Mode)
			;	(if (CheckFilterString Str Mode)
			;		(setq Rtn (splitxt Str ","))
			;		(setq Rtn nil)
			;	)
			;)
			(setq Rtn (splitxt Str ","))
			;Rtn
		)
		;
		; MAIN
		;
		(setq $DbActiveFilterId$ 		(get_tile  "ActiveFilterId"			))		
		(setq $DbActiveFilterOrder$ 	(get_tile  "ActiveFilterOrder"		))		
		(setq $DbActiveFilterPhase$		(get_tile  "ActiveFilterPhase"		))		
	   ;(setq $DbActiveFilterFamily$	(get_tile  "ActiveFilterFamily"		))			
		(setq $DbActiveFilterMark$		(get_tile  "ActiveFilterMark"		))
		(setq $DbActiveFilterQuantity$	(get_tile  "ActiveFilterQuantity"	))
	   ;(setq $DbActiveFilterName$		(get_tile  "ActiveFilterName"		))
		(setq $DbActiveFilterMaterial$	(get_tile  "ActiveFilterMaterial"	))
		(setq $DbActiveFilterThikness$	(get_tile  "ActiveFilterThikness"	))
		(setq $DbActiveFilterLength$	(get_tile  "ActiveFilterLength"		))
		(setq $DbActiveFilterHeight$	(get_tile  "ActiveFilterHeight"		))
		(setq $DbActiveFilterCut$		(get_tile  "ActiveFilterCut"		))
		(setq $DbActiveFilterDate$		(get_tile  "ActiveFilterDate"		))
	   ;(setq $DbActiveFilterFlag1$		(get_tile  "ActiveFilterFlag1"		))
	   ;(setq $DbActiveFilterFlag2$		(get_tile  "ActiveFilterFlag2"		))
	   ;(setq $DbActiveFilterFlag3$		(get_tile  "ActiveFilterFlag3"		))
			
		(setq $DbIdFilter$				(get_tile  "IdFilter"				))	
		(setq $DbOrderFilter$			(get_tile  "OrderFilter"			))	
		(setq $DbPhaseFilter$			(get_tile  "PhaseFilter"			))			
       ;(setq $DbFamilyFilter$			(get_tile  "FamilyFilter"			))
		(setq $DbMarkFilter$			(get_tile  "MarkFilter"				))
		(setq $DbQuantityFilter$		(get_tile  "QuantityFilter"			))
	   ;(setq $DbNameFilter$			(get_tile  "NameFilter"				))
		(setq $DbMaterialFilter$		(get_tile  "MaterialFilter"			))
		(setq $DbThiknessFilter$		(get_tile  "ThiknessFilter"			))
		(setq $DbLengthFilter$			(get_tile  "LengthFilter"			))
		(setq $DbHeightFilter$			(get_tile  "HeightFilter"			))
		(setq $DbCutFilter$				(get_tile  "CutFilter"				))
		(setq $DbDateFilter$			(get_tile  "DateFilter"				))
	   ;(setq $DbFlag1Filter$			(get_tile  "Flag1Filter"			))
	   ;(setq $DbFlag2Filter$			(get_tile  "Flag2Filter"			))
	   ;(setq $DbFlag3Filter$			(get_tile  "Flag3Filter"			))
	
		(if (= $DbActiveFilterId$    	"1")	 	(setq Id $DbIdFilter$				)	(setq Id 		"<>"))
		(if (= $DbActiveFilterOrder$    "1")	 	(setq Order $DbOrderFilter$			)	(setq Order 	"<>"))
		(if (= $DbActiveFilterPhase$    "1")		(setq Phase $DbPhaseFilter$			)	(setq Phase 	"<>"))	
	   ;(if (= $DbActiveFilterFamily$   "1")		(setq Family $DbFamilyFilter$		)	(setq Family 	"<>"))	
		(if (= $DbActiveFilterMark$     "1")		(setq Mark $DbMarkFilter$			)	(setq Mark 		"<>"))
		(if (= $DbActiveFilterQuantity$ "1")		(setq Quantity $DbQuantityFilter$	)	(setq Quantity 	"<>"))
	   ;(if (= $DbActiveFilterName$ 	"1")		(setq Name $DbNameFilter$			)	(setq Name 		"<>"))
		(if (= $DbActiveFilterMaterial$ "1")		(setq Material $DbMaterialFilter$	)	(setq Material 	"<>"))
		(if (= $DbActiveFilterThikness$ "1")		(setq Thikness $DbThiknessFilter$	)	(setq Thikness 	"<>"))
		(if (= $DbActiveFilterLength$   "1")		(setq Lngth $DbLengthFilter$		)	(setq Lngth 	"<>"))
		(if (= $DbActiveFilterHeight$   "1")		(setq Height $DbHeightFilter$		)	(setq Height 	"<>"))
		(if (= $DbActiveFilterCut$   	"1")		(setq Cut $DbCutFilter$				)	(setq Cut 		"<>"))
		(if (= $DbActiveFilterDate$     "1")		(setq Date $DbDateFilter$			)	(setq Date 		"<>"))
	   ;(if (= $DbActiveFilterFlag1$    "1")		(setq Flag1 $DbFlag1Filter$			)	(setq Flag1 	"<>"))
	   ;(if (= $DbActiveFilterFlag2$    "1")		(setq Flag2 $DbFlag2Filter$			)	(setq Flag2 	"<>"))
	   ;(if (= $DbActiveFilterFlag3$    "1")		(setq Flag3 $DbFlag3Filter$			)	(setq Flag3 	"<>"))
		
		(setq Rtn T)
		
		(if (not (setq Id       (CeckValue Id 2))) 	 	 (progn (alert "Probabile errore nella formula ID")  	 (setq Rtn nil)))
		(if (not (setq Order    (CeckValue Order 2))) 	 (progn (alert "Probabile errore nella formula ORDER")   (setq Rtn nil)))
		(if (not (setq Phase    (CeckValue Phase 2)))  	 (progn (alert "Probabile errore nella formula PHASE")   (setq Rtn nil)))
	   ;(if (not (setq Family   (CeckValue Family 1))) 	 (progn (alert "Probabile errore nella formula FAMILY")  (setq Rtn nil)))
		(if (not (setq Mark     (CeckValue Mark 2)))     (progn (alert "Probabile errore nella formula MARK")    (setq Rtn nil)))
		(if (not (setq Quantity (CeckValue Quantity 1))) (progn (alert "Probabile errore nella formula QUANTITY")(setq Rtn nil)))
	   ;(if (not (setq Name     (CeckValue Name 2))) 	 (progn (alert "Probabile errore nella formula NAME") 	 (setq Rtn nil)))
		(if (not (setq Material (CeckValue Material 2))) (progn (alert "Probabile errore nella formula MATERIAL")(setq Rtn nil)))
		(if (not (setq Thikness (CeckValue Thikness 1))) (progn (alert "Probabile errore nella formula THIKNESS")(setq Rtn nil)))
		(if (not (setq Lngth    (CeckValue Lngth 1)))    (progn (alert "Probabile errore nella formula LENGTH")  (setq Rtn nil)))
		(if (not (setq Height   (CeckValue Height 1)))	 (progn (alert "Probabile errore nella formula HEIGTH")  (setq Rtn nil)))
		(if (not (setq Cut      (CeckValue Cut 2)))      (progn (alert "Probabile errore nella formula CUT") 	 (setq Rtn nil)))
		(if (not (setq Date     (CeckValue Date 2)))     (progn (alert "Probabile errore nella formula DATE") 	 (setq Rtn nil)))
	   ;(if (not (setq Flag1    (CeckValue Flag1 2))) 	 (progn (alert "Probabile errore nella formula FLAG1") 	 (setq Rtn nil)))
	   ;(if (not (setq Flag2    (CeckValue Flag2 2))) 	 (progn (alert "Probabile errore nella formula FLAG2") 	 (setq Rtn nil)))
	   ;(if (not (setq flag3    (CeckValue Flag3 2))) 	 (progn (alert "Probabile errore nella formula FLAG3") 	 (setq Rtn nil)))
		
		
		(if (not Rtn)
			Rtn
			(list Id Order Phase nil Mark Quantity nil Material Thikness Lngth Height Cut Date nil nil nil)
		)

	)
	;
	; MAIN
	;
	(if (not $DbActiveFilterId$)		(setq $DbActiveFilterId$ 		"1"))
	(if (not $DbActiveFilterOrder$)		(setq $DbActiveFilterOrder$ 	"1"))
	(if (not $DbActiveFilterPhase$)		(setq $DbActiveFilterPhase$ 	"1"))
	(if (not $DbActiveFilterFamily$)	(setq $DbActiveFilterFamily$	"1"))
	(if (not $DbActiveFilterMark$)		(setq $DbActiveFilterMark$ 		"1"))
	(if (not $DbActiveFilterQuantity$)	(setq $DbActiveFilterQuantity$ 	"1"))
	(if (not $DbActiveFilterName$)		(setq $DbActiveFilterName$ 		"1"))
	(if (not $DbActiveFilterMaterial$)	(setq $DbActiveFilterMaterial$	"1"))
	(if (not $DbActiveFilterThikness$)	(setq $DbActiveFilterThikness$	"1"))
	(if (not $DbActiveFilterLength$)	(setq $DbActiveFilterLength$	"1"))
	(if (not $DbActiveFilterHeight$)	(setq $DbActiveFilterHeight$	"1"))
	(if (not $DbActiveFilterCut$)		(setq $DbActiveFilterCut$		"1"))
	(if (not $DbActiveFilterDate$)		(setq $DbActiveFilterDate$		"1"))
	(if (not $DbActiveFilterFlag1$)		(setq $DbActiveFilterFlag1$		"1"))
	(if (not $DbActiveFilterFlag2$)		(setq $DbActiveFilterFlag2$		"1"))
	(if (not $DbActiveFilterFlag3$)		(setq $DbActiveFilterFlag3$		"1"))
	

	(if (not $DbIdFilter$)		(setq $DbIdFilter$ 			"<>"))
	(if (not $DbOrderFilter$)	(setq $DbOrderFilter$ 		"<>"))
    (if (not $DbPhaseFilter$)	(setq $DbPhaseFilter$ 		"<>"))
    (if (not $DbFamilyFilter$)	(setq $DbFamilyFilter$ 		"<>"))
	(if (not $DbMarkFilter$)	(setq $DbMarkFilter$ 		"<>"))
	(if (not $DbQuantityFilter$)(setq $DbQuantityFilter$ 	"<>"))
	(if (not $DbNameFilter$)	(setq $DbNameFilter$ 		"<>"))
	(if (not $DbMaterialFilter$)(setq $DbMaterialFilter$ 	"<>"))
	(if (not $DbThiknessFilter$)(setq $DbThiknessFilter$ 	"<>"))
	(if (not $DbLengthFilter$)	(setq $DbLengthFilter$		"<>"))
	(if (not $DbHeightFilter$)	(setq $DbHeightFilter$		"<>"))
	(if (not $DbCutFilter$)		(setq $DbCutFilter$			"<>"))
	(if (not $DbDateFilter$)	(setq $DbDateFilter$		"<>"))
	(if (not $DbFlag1Filter$)	(setq $DbFlag1Filter$		"<>"))
	(if (not $DbFlag2Filter$)	(setq $DbFlag2Filter$		"<>"))
	(if (not $DbFlag3Filter$)	(setq $DbFlag3Filter$		"<>"))

	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "SelPiecesShapeDbase" xx "" (cond ( *SelPiecesShapeDbase* ) ( '(-1 -1) )))
			

	(set_tile  "ActiveFilterId"		    	$DbActiveFilterId$)			
	(set_tile  "ActiveFilterOrder"		    $DbActiveFilterOrder$)			
	(set_tile  "ActiveFilterPhase"		    $DbActiveFilterPhase$)			
   ;(set_tile  "ActiveFilterFamily"	 		$DbActiveFilterFamily$)			
	(set_tile  "ActiveFilterMark"			$DbActiveFilterMark$)	
	(set_tile  "ActiveFilterQuantity"		$DbActiveFilterQuantity$)
   ;(set_tile  "ActiveFilterName"			$DbActiveFilterName$)
	(set_tile  "ActiveFilterMaterial"	    $DbActiveFilterMaterial$)
	(set_tile  "ActiveFilterThikness"	    $DbActiveFilterThikness$)
	(set_tile  "ActiveFilterLength"	    	$DbActiveFilterLength$)
	(set_tile  "ActiveFilterHeight"	    	$DbActiveFilterHeight$)
	(set_tile  "ActiveFilterCut"	    	$DbActiveFilterCut$)
	(set_tile  "ActiveFilterDate"	    	$DbActiveFilterDate$)
   ;(set_tile  "ActiveFilterFlag1"	    	$DbActiveFilterFlag1$)
   ;(set_tile  "ActiveFilterFlag2"	    	$DbActiveFilterFlag2$)
   ;(set_tile  "ActiveFilterFlag3"	    	$DbActiveFilterFlag3$)
			
	(set_tile  "IdFilter"					$DbIdFilter$)			
	(set_tile  "OrderFilter"				$DbOrderFilter$)			
	(set_tile  "PhaseFilter"				$DbPhaseFilter$)			
   ;(set_tile  "FamilyFilter"				$DbFamilyFilter$)
	(set_tile  "MarkFilter"					$DbMarkFilter$)
	(set_tile  "QuantityFilter"				$DbQuantityFilter$)
   ;(set_tile  "NameFilter"					$DbNameFilter$)
	(set_tile  "MaterialFilter"				$DbMaterialFilter$)
	(set_tile  "ThiknessFilter"				$DbThiknessFilter$)
	(set_tile  "LengthFilter"				$DbLengthFilter$)
	(set_tile  "HeightFilter"				$DbHeightFilter$)
	(set_tile  "CutFilter"					$DbCutFilter$)
	(set_tile  "DateFilter"					$DbDateFilter$)
   ;(set_tile  "Flag1Filter"				$DbFlag1Filter$)
   ;(set_tile  "Flag2Filter"				$DbFlag2Filter$)
   ;(set_tile  "Flag3Filter"				$DbFlag3Filter$)
				
	(if (= $DbActiveFilterId$  		"1")	(mode_tile "IdFilter"       0)	(mode_tile "IdFilter"    	1))
	(if (= $DbActiveFilterOrder$   	"1")	(mode_tile "OrderFilter"    0)	(mode_tile "OrderFilter"    1))
	(if (= $DbActiveFilterPhase$   	"1")	(mode_tile "PhaseFilter"    0)	(mode_tile "PhaseFilter"    1))	
   ;(if (= $DbActiveFilterFamily$   "1")	(mode_tile "FamilyFilter"   0)	(mode_tile "FamilyFilter"   1))	
	(if (= $DbActiveFilterMark$     "1")	(mode_tile "MarkFilter"     0)	(mode_tile "MarkFilter"     1))
	(if (= $DbActiveFilterQuantity$ "1")	(mode_tile "QuantityFilter" 0)	(mode_tile "QuantityFilter" 1))
   ;(if (= $DbActiveFilterName$ 	"1")	(mode_tile "NameFilter" 	0)	(mode_tile "NameFilter" 	1))
	(if (= $DbActiveFilterMaterial$ "1")	(mode_tile "MaterialFilter" 0)	(mode_tile "MaterialFilter" 1))
	(if (= $DbActiveFilterThikness$ "1")	(mode_tile "ThiknessFilter" 0)	(mode_tile "ThiknessFilter" 1))
	(if (= $DbActiveFilterLength$   "1")	(mode_tile "LengthFilter"   0)	(mode_tile "LengthFilter"   1))
	(if (= $DbActiveFilterHeight$   "1")	(mode_tile "HeightFilter"   0)	(mode_tile "HeightFilter"   1))
	(if (= $DbActiveFilterCut$   	"1")	(mode_tile "CutFilter"   	0)	(mode_tile "CutFilter"   	1))
	(if (= $DbActiveFilterDate$     "1")	(mode_tile "DateFilter"   	0)	(mode_tile "DateFilter"   	1))
   ;(if (= $DbActiveFilterFlag1$    "1")	(mode_tile "Flag1Filter"   	0)	(mode_tile "Flag1Filter"   	1))
   ;(if (= $DbActiveFilterFlag2$    "1")	(mode_tile "Flag2Filter"   	0)	(mode_tile "Flag2Filter"  	1))
   ;(if (= $DbActiveFilterFlag3$    "1")	(mode_tile "Flag3Filter"   	0)	(mode_tile "Flag3Filter"  	1))
	
	(action_tile "HelpId" 		"(alert \"esempio 012563584,555872369 oppure <>\")")
	(action_tile "HelpOrder" 	"(alert \"esempio C800,C900 oppure <>\")")
	(action_tile "HelpPhase" 	"(alert \"esempio 100,101 oppure <>\")")
   ;(action_tile "HelpFamily" 	"(alert \"non implementato\")")
	(action_tile "HelpMark" 	"(alert \"esempio CT100,OP101 oppure <>\")")
	(action_tile "HelpQuantity" "(alert \"esempio <1-10>,-9,25  oppure <>\")")
   ;(action_tile "HelpName" 	"(alert \"non implementato\")")
	(action_tile "HelpMaterial" "(alert \"esempio S355J0,S275JR  oppure <> \")")
	(action_tile "HelpThikness" "(alert \"esempio <1-10>,-9,25  oppure <>\")")
	(action_tile "HelpLength" 	"(alert \"esempio <1-10>,-9,25  oppure <>\")")
	(action_tile "HelpHeight" 	"(alert \"esempio <1-10>,-9,25  oppure <>\")")
	(action_tile "HelpCut" 		"(alert \"esempio 1,2  oppure <>\")")
	(action_tile "HelpDate" 	"(alert \"01/20/2018,01/20/2019\")")
   ;(action_tile "HelpFlag1" 	"(alert \"non implementato\")")
   ;(action_tile "HelpFlag2" 	"(alert \"non implementato\")")
   ;(action_tile "HelpFlag3" 	"(alert \"non implementato\")")

	
	(action_tile "ActiveFilterId" 		"(SwapModeTile (get_tile \"ActiveFilterId\") 		\"IdFilter\")")
	(action_tile "ActiveFilterOrder" 	"(SwapModeTile (get_tile \"ActiveFilterOrder\") 	\"OrderFilter\")")
	(action_tile "ActiveFilterPhase"	"(SwapModeTile (get_tile \"ActiveFilterPhase\") 	\"PhaseFilter\")")
   ;(action_tile "ActiveFilterFamily"	"(SwapModeTile (get_tile \"ActiveFilterFamily\") 	\"FamilyFilter\")")
	(action_tile "ActiveFilterMark"		"(SwapModeTile (get_tile \"ActiveFilterMark\") 		\"MarkFilter\")")
	(action_tile "ActiveFilterQuantity"	"(SwapModeTile (get_tile \"ActiveFilterQuantity\") 	\"QuantityFilter\")")
   ;(action_tile "ActiveFilterName"		"(SwapModeTile (get_tile \"ActiveFilterName\") 		\"NameFilter\")")
	(action_tile "ActiveFilterMaterial"	"(SwapModeTile (get_tile \"ActiveFilterMaterial\") 	\"MaterialFilter\")")
	(action_tile "ActiveFilterThikness"	"(SwapModeTile (get_tile \"ActiveFilterThikness\") 	\"ThiknessFilter\")")
	(action_tile "ActiveFilterLength"	"(SwapModeTile (get_tile \"ActiveFilterLength\") 	\"LengthFilter\")")
	(action_tile "ActiveFilterHeight"	"(SwapModeTile (get_tile \"ActiveFilterHeight\") 	\"HeightFilter\")")
	(action_tile "ActiveFilterCut"		"(SwapModeTile (get_tile \"ActiveFilterCut\") 		\"CutFilter\")")
	(action_tile "ActiveFilterDate"		"(SwapModeTile (get_tile \"ActiveFilterDate\") 		\"DateFilter\")")
   ;(action_tile "ActiveFilterFlag1"	"(SwapModeTile (get_tile \"ActiveFilterFlag1\") 	\"Flag1Filter\")")
   ;(action_tile "ActiveFilterFlag2"	"(SwapModeTile (get_tile \"ActiveFilterFlag2\") 	\"Flag2Filter\")")
   ;(action_tile "ActiveFilterFlag3"	"(SwapModeTile (get_tile \"ActiveFilterFlag3\") 	\"Flag3Filter\")")
	


	(action_tile "accept"               "(setq LstChooseSelPiecesDbase (GetChooseSelPiecesDbase) *SelPiecesShapeDbase* (done_dialog)) (unload_dialog xx)")
	(action_tile "exit"	               	"(setq Rtn nil *SelPiecesShapeDbase* (done_dialog)) (unload_dialog xx)")
															
				
	(start_dialog)
	
	(if LstChooseSelPiecesDbase 
		(progn
			(setq LstIDShape (SelPiecesDbase (nth 0  LstChooseSelPiecesDbase)
											 (nth 1  LstChooseSelPiecesDbase)
											 (nth 2  LstChooseSelPiecesDbase)
											 (nth 3  LstChooseSelPiecesDbase)
											 (nth 4  LstChooseSelPiecesDbase)
											 (nth 5  LstChooseSelPiecesDbase)
											 (nth 6  LstChooseSelPiecesDbase)
											 (nth 7  LstChooseSelPiecesDbase)
											 (nth 8  LstChooseSelPiecesDbase)
											 (nth 9  LstChooseSelPiecesDbase)
											 (nth 10 LstChooseSelPiecesDbase)
											 (nth 11 LstChooseSelPiecesDbase)
											 (nth 12 LstChooseSelPiecesDbase)
											 (nth 13 LstChooseSelPiecesDbase)
											 (nth 14 LstChooseSelPiecesDbase)
											 (nth 15 LstChooseSelPiecesDbase)))
			(setq LstTableNesting (GetLstInfoDataShape LstIDShape))
			(setq Rtn (GuiShowLstDataShape LstTableNesting))
		)
	)
	Rtn
)
;
;
;
(defun GuiShowLstDataShape (LstTableNesting / FormatTableNesting SetRecordNesting GetFilterList SelectAllBoxList GetDataBoxList SelectItmBoxList
											  itm LstInfoShape ok save xx Rtn accept)

	;
	;
	;
	(defun FormatTableNesting (LstTableNesting / itm Conta Rtn)
	
		(if LstTableNesting
			(progn
				(setq Conta 1)
				(foreach itm LstTableNesting
					;	  0      1          2     3    4       5    6  7     8      9   10    11   12      13       14   15  16 
					;itm (39 "465046357" "C872" "300" "-" "178-363" 4 "-" "S355J0" 3.0 325.0 300.0 "1" "08/06/2019" "-" "-" "-")
					;
					;Itm\tIdent\tOrder\tPhase\tMark\tQuantity\tThikness\tLength\tHeight\tMaterial
					;
					(setq Rtn (append Rtn (list (strcat (LM:rtos Conta 2 0) "\t"		;Itm
														(nth 1  itm)				"\t"	;Id
														(nth 2  itm)				"\t"	;Order
														(nth 3  itm)				"\t"	;Phase
														;(nth 4  itm)				"\t"	;Family
														(nth 5  itm)				"\t"	;Mark
														(nth 6  itm)				"\t"	;Quantity
														;(nth 7  itm)				"\t"	;Name
														(nth 9  itm)				"\t"	;Thikness
														(nth 10 itm)				"\t"	;Length
														(nth 11 itm)				"\t"	;Height
														(nth 8  itm)				"\t"	;Material
														(nth 13 itm)				"\t"	;Date
														(if (= (nth 12 itm) "1") "Antiorario" "Orario")
														;(nth 12 itm)				"\t"	;Cut				
														;(nth 14 itm)				"\t"	;Flag1
														;(nth 15 itm)				"\t"	;Flag2
														;(nth 16 itm)				"\t"	;Flag3
					))))
					(setq Conta (1+ Conta))
				)
			)
		)
		Rtn
	)
	;
	;
	;
	(defun SetRecordNesting (LstTableNesting /  itm LstFilter ErrorFilter
												ErrorPrgFilter
												ErrorIdFilter
												ErrorOrderFilter
												ErrorPhaseFilter
												ErrorMarkFilter
												ErrorQuantityFilter
												ErrorThiknessFilter
												ErrorLengthFilter
												ErrorHeightFilter
												ErrorMaterialFilter
												ErrorDateFilter
												ErrorCutFilter
												Value
												Conta Rtn)
	
		(if LstTableNesting
			(progn
				(mode_tile "box_label" 2)
				(setq $ActiveFilterPrg$ 		(get_tile "ActiveFilterPrg"))
				(setq $ActiveFilterId$ 			(get_tile "ActiveFilterId"))
				(setq $ActiveFilterOrder$ 		(get_tile "ActiveFilterOrder"))
				(setq $ActiveFilterPhase$  		(get_tile "ActiveFilterPhase"))
				(setq $ActiveFilterMark$     	(get_tile "ActiveFilterMark"))
				(setq $ActiveFilterQuantity$    (get_tile "ActiveFilterQuantity"))
				(setq $ActiveFilterThikness$	(get_tile "ActiveFilterThikness"))
				(setq $ActiveFilterLength$	    (get_tile "ActiveFilterLength"))
				(setq $ActiveFilterHeight$	    (get_tile "ActiveFilterHeight"))
				(setq $ActiveFilterMaterial$    (get_tile "ActiveFilterMaterial"))
				(setq $ActiveFilterDate$    	(get_tile "ActiveFilterDate"))
				(setq $ActiveFilterCut$    		(get_tile "ActiveFilterCut"))
				
				;(alert (strcat $ActiveFilterOrder$ " " $ActiveFilterPhase$ " " $ActiveFilterMark$ " " $ActiveFilterThikness$ " " $ActiveFilterMaterial$))
				; ---------------------------------- PrgFilter 
				(if (= $ActiveFilterPrg$ "1")
					(progn
						(mode_tile "PrgFilter" 0) ; attivo
						(setq Value (get_tile "PrgFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $PrgFilter$ Value)
							)
							(setq ErrorIdFilter T)
						)
					)
					(progn
						(mode_tile "PrgFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- IdFilter 
				(if (= $ActiveFilterId$ "1")
					(progn
						(mode_tile "IdFilter" 0) ; attivo
						(setq Value (get_tile "IdFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $IdFilter$ Value)
							)
							(setq ErrorIdFilter T)
						)
					)
					(progn
						(mode_tile "IdFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- OrderFilter 
				(if (= $ActiveFilterOrder$ "1")
					(progn
						(mode_tile "OrderFilter" 0) ; attivo
						(setq Value (get_tile "OrderFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $OrderFilter$ Value)
							)
							(setq ErrorOrderFilter T)
						)
					)
					(progn
						(mode_tile "OrderFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- PhaseFilter
				(if (= $ActiveFilterPhase$ "1")
					(progn
						(mode_tile "PhaseFilter" 0) ; attivo
						(setq Value (get_tile "PhaseFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $PhaseFilter$ Value)
							)
							(setq ErrorPhaseFilter T)
						)
					)
					(progn
						(mode_tile "PhaseFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- MarkFilter
				(if (= $ActiveFilterMark$ "1")
					(progn
						(mode_tile "MarkFilter" 0) ; attivo
						(setq Value (get_tile "MarkFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $MarkFilter$ Value)
							)
							(setq ErrorMarkFilter T)
						)
					)
					(progn
						(mode_tile "MarkFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- QuantityFilter
				(if (= $ActiveFilterQuantity$ "1")
					(progn
						(mode_tile "QuantityFilter" 0) ; attivo
						(setq Value (get_tile "QuantityFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $QuantityFilter$ Value)
							)
							(setq ErrorQuantityFilter T)
						)
					)
					(progn
						(mode_tile "QuantityFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- ThiknessFilter
				(if (= $ActiveFilterThikness$ "1")
					(progn
						(mode_tile "ThiknessFilter" 0) ; attivo
						(setq Value (get_tile "ThiknessFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $ThiknessFilter$ Value)
							)
							(setq ErrorThiknessFilter T)
						)
					)
					(progn
						(mode_tile "ThiknessFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- LengthFilter
				(if (= $ActiveFilterLength$ "1")
					(progn
						(mode_tile "LengthFilter" 0) ; attivo
						(setq Value (get_tile "LengthFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $LengthFilter$ Value)
							)
							(setq ErrorLengthFilter T)
						)
					)
					(progn
						(mode_tile "LengthFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- HeightFilter
				(if (= $ActiveFilterHeight$ "1")
					(progn
						(mode_tile "HeightFilter" 0) ; attivo
						(setq Value (get_tile "HeightFilter"))
						(if (CheckFilterString Value 1)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $HeightFilter$ Value)
							)
							(setq ErrorHeightFilter T)
						)
					)
					(progn
						(mode_tile "HeightFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- MaterialFilter
				(if (= $ActiveFilterMaterial$ "1")
					(progn
						(mode_tile "MaterialFilter" 0) ; attivo
						(setq Value (get_tile "MaterialFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $MaterialFilter$ Value)
							)
							(setq ErrorMaterialFilter T)
						)
					)
					(progn
						(mode_tile "MaterialFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- DateFilter
				(if (= $ActiveFilterDate$ "1")
					(progn
						(mode_tile "DateFilter" 0) ; attivo
						(setq Value (get_tile "DateFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $DateFilter$ Value)
							)
							(setq ErrorDateFilter T)
						)
					)
					(progn
						(mode_tile "DateFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ---------------------------------- CutFilter
				(if (= $ActiveFilterCut$ "1")
					(progn
						(mode_tile "CutFilter" 0) ; attivo
						(setq Value (get_tile "CutFilter"))
						(if (CheckFilterString Value 2)
							(progn
								(setq LstFilter (append LstFilter (list Value)))
								(setq $CutFilter$ Value)
							)
							(setq ErrorCutFilter T)
						)
					)
					(progn
						(mode_tile "CutFilter" 1) ; disattivo
						(setq LstFilter (append LstFilter (list "<>")))
					)
				)
				; ----------------------------------

				(if (and 	(not ErrorPrgFilter)
							(not ErrorIdFilter)
							(not ErrorOrderFilter)
							(not ErrorPhaseFilter)
							(not ErrorMarkFilter)
							(not ErrorQuantityFilter)
							(not ErrorThiknessFilter)
							(not ErrorLengthFilter)
							(not ErrorHeightFilter)
							(not ErrorMaterialFilter)
							(not ErrorDateFilter)
							(not ErrorCutFilter)
					)
						(setq ErrorFilter nil)
						
						(progn
							(if ErrorPrgFilter			(alert "Possibile errore di sintassi ITEM"))
							(if ErrorIdFilter			(alert "Possibile errore di sintassi ID"))
							(if ErrorOrderFilter		(alert "Possibile errore di sintassi ORDER"))
							(if ErrorPhaseFilter		(alert "Possibile errore di sintassi PHASE"))
							(if ErrorMarkFilter			(alert "Possibile errore di sintassi MARK"))
							(if ErrorQuantityFilter		(alert "Possibile errore di sintassi QUANTITY"))
							(if ErrorThiknessFilter		(alert "Possibile errore di sintassi THIKNESS"))
							(if ErrorLengthFilter		(alert "Possibile errore di sintassi LENGTH"))
							(if ErrorHeightFilter		(alert "Possibile errore di sintassi HEIGTH"))
							(if ErrorMaterialFilter		(alert "Possibile errore di sintassi MATERIAL"))
							(if ErrorDateFilter			(alert "Possibile errore di sintassi DATE"))
							(if ErrorCutFilter			(alert "Possibile errore di sintassi CUT"))
						)
				)
					
				
				;(princ (strcat "\n" (nth 0 LstFilter) "--" (nth 1 LstFilter) "--" (nth 2 LstFilter) "--" (nth 3 LstFilter) "--" (nth 4 LstFilter)))
				
				(if (null ErrorFilter)
					(progn
						(set_tile "box_info" "")
						(setq Rtn (GetFilterList LstTableNesting LstFilter))
						(start_list "box_info")
							(mapcar 'add_list Rtn)
						(end_list)
					)
				)
			)
		)
		Rtn
	)	
	;
	;
	;
	(defun GetFilterList (LstTableNesting LstFilter / Conta itm Split Rtn)
		(if (and LstTableNesting LstFilter)
			(progn
				(setq Conta 1)
				(foreach itm LstTableNesting
					(setq Split (LM:str->lst itm "\t"))
					;	0	     1		  2      3      4      5    6    7        8       9			10			11
					; ("01" "026611999" "C872" "100" "011124" "1" "15" "1183.5" "1540" "S355J2" "20/10/2018" "Antioraria")
					(if (LogicFilterSelectStockShape 	(nth 0 Split) (nth 1 Split) (nth 2 Split) (nth 3 Split) (nth 4 Split) (nth 5 Split)
														(nth 6 Split) (nth 7 Split) (nth 8 Split) (nth 9 Split) ;(nth 10 Split) (nth 11 Split)
														(nth 0 LstFilter)
														(nth 1 LstFilter)
														(nth 2 LstFilter)
														(nth 3 LstFilter)
														(nth 4 LstFilter)
														(nth 5 LstFilter)
														(nth 6 LstFilter)
														(nth 7 LstFilter)
														(nth 8 LstFilter)
														(nth 9 LstFilter))
														;(nth 10 LstFilter)
														;(nth 11 LstFilter))
						(setq Rtn (append Rtn (list (strcat (rtos Conta 2 0) "\t"
															(nth 1 Split) "\t"
															(nth 2 Split) "\t"
															(nth 3 Split) "\t"
															(nth 4 Split) "\t"
															(nth 5 Split) "\t"
															(nth 6 Split) "\t"
															(nth 7 Split) "\t"
															(nth 8 Split) "\t"
															(nth 9 Split)
															;(nth 10 Split) "\t"
															;(nth 11 Split)
													)))
							 Conta (1+ Conta)
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
	(defun SelectItmBoxList (KeyName)
		(if KeyName
			(get_tile keyName)
		)
	)	
	;
	;
	;
	(defun SelectAllBoxList (KeyName LstTableNesting / Select conta)
	
		(if (and KeyName LstTableNesting)
			(progn
				(setq Select "")
				(setq conta 0)
				(foreach itm LstTableNesting
					(setq Select (strcat Select (rtos conta 2 0) " "))
					(setq conta (1+ conta))
				)
				(set_tile KeyName Select)
			)
		)
	)
	;
	;
	;
	(defun GetDataBoxList (KeyName LstTableNesting Nth_ / Get_Tile_List LstItmSelect itm SplitRow Rtn TmpLst)
	
		(defun Get_Tile_List (KeyName / itm itemsplit Rtn)
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
		;
		(if (and KeyName LstTableNesting)
			(progn
				(setq LstItmSelect (Get_Tile_List KeyName))
				(foreach itm LstItmSelect
					(setq SplitRow (splitxt (nth (atoi itm)  LstTableNesting) "\t"))
					(if Nth_
						(setq Rtn (append Rtn (list (nth Nth_ SplitRow))))
						(progn
							(foreach itm1 SplitRow
								(setq TmpLst (append TmpLst (list itm1)))
							)
							(setq Rtn (append Rtn (list TmpLst)))
							(setq TmpLst nil)
						)
					)
				)			
			)
		)
		Rtn
	)
	;
	; MAIN
	;
	(setq LstTableNesting (FormatTableNesting LstTableNesting))

	;(if (not $ActiveFilterId$)			(setq $ActiveFilterId$ 			"1"))
	;(if (not $ActiveFilterOrder$)		(setq $ActiveFilterOrder$ 		"1"))
	;(if (not $ActiveFilterPhase$)		(setq $ActiveFilterPhase$ 		"1"))
	;(if (not $ActiveFilterFamily$)		(setq $ActiveFilterFamily$ 		"1"))
	;(if (not $ActiveFilterMark$)		(setq $ActiveFilterMark$ 		"1"))
	;(if (not $ActiveFilterQuantity$)	(setq $ActiveFilterQuantity$ 	"1"))
	;(if (not $ActiveFilterName$)		(setq $ActiveFilterName$ 		"1"))
	;(if (not $ActiveFilterMaterial$)	(setq $ActiveFilterMaterial$	"1"))
	;(if (not $ActiveFilterThikness$)	(setq $ActiveFilterThikness$	"1"))
	;(if (not $ActiveFilterLength$)		(setq $ActiveFilterLength$		"1"))
	;(if (not $ActiveFilterHeight$)		(setq $ActiveFilterHeight$		"1"))
	;(if (not $ActiveFilterCut$)		(setq $ActiveFilterCut$			"1"))
	;(if (not $ActiveFilterDate$)		(setq $ActiveFilterDate$		"1"))
	;(if (not $ActiveFilterFlag1$)		(setq $ActiveFilterFlag1$		"1"))
	;(if (not $ActiveFilterFlag2$)		(setq $ActiveFilterFlag2$		"1"))
	;(if (not $ActiveFilterFlag3$)		(setq $ActiveFilterFlag3$		"1"))

	(setq $ActiveFilterPrg$			"0")
	(setq $ActiveFilterId$ 			"0")
	(setq $ActiveFilterOrder$ 		"0")
	(setq $ActiveFilterPhase$ 		"0")
	(setq $ActiveFilterFamily$ 		"0")
	(setq $ActiveFilterMark$ 		"0")
	(setq $ActiveFilterQuantity$ 	"0")
	(setq $ActiveFilterName$ 		"0")
	(setq $ActiveFilterMaterial$	"0")
	(setq $ActiveFilterThikness$	"0")
	(setq $ActiveFilterLength$		"0")
	(setq $ActiveFilterHeight$		"0")
	(setq $ActiveFilterCut$			"0")
	(setq $ActiveFilterDate$		"0")
	(setq $ActiveFilterFlag1$		"0")
	(setq $ActiveFilterFlag2$		"0")
	(setq $ActiveFilterFlag3$		"0")
	
	(if (not $PrgFilter$)		(setq $PrgFilter$ 				"<>"))
	(if (not $IdFilter$)		(setq $IdFilter$ 				"<>"))			
	(if (not $OrderFilter$)		(setq $OrderFilter$ 			"<>"))			
    (if (not $PhaseFilter$)	 	(setq $PhaseFilter$ 			"<>"))			
    (if (not $FamilyFilter$)	(setq $FamilyFilter$ 			"<>"))	
	(if (not $MarkFilter$)		(setq $MarkFilter$ 				"<>"))
	(if (not $QuantityFilter$)	(setq $QuantityFilter$ 			"<>"))
	(if (not NameFilter$)		(setq $NameFilter$ 				"<>"))
	(if (not $MaterialFilter$)	(setq $MaterialFilter$ 			"<>"))
	(if (not $ThiknessFilter$)	(setq $ThiknessFilter$ 			"<>"))
	(if (not $LengthFilter$)	(setq $LengthFilter$			"<>"))
	(if (not $HeightFilter$)	(setq $HeightFilter$			"<>"))
	(if (not $CutFilter$)		(setq $CutFilter$				"<>"))
	(if (not $DateFilter$)		(setq $DateFilter$				"<>"))
	(if (not $Flag1Filter$)		(setq $Flag1Filter$				"<>"))
	(if (not $Flag2Filter$)		(setq $Flag2Filter$				"<>"))
	(if (not $Flag3Filter$)		(setq $Flag3Filter$				"<>"))
	
	
	(if LstTableNesting
		(progn
				(setq ok nil)
				(setq save nil)
				
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(new_dialog "InfoTableNesting" xx "" (cond ( *InfoTableNesting* ) ( '(-1 -1) )))
				;(start_list "box_info")
				;	(mapcar 'add_list LstTableNesting)
				;(end_list)
			
				(set_tile  "ActiveFilterPrg"	    	$ActiveFilterPrg$)
				(set_tile  "ActiveFilterId"		    	$ActiveFilterId$)			
				(set_tile  "ActiveFilterOrder"		    $ActiveFilterOrder$)			
				(set_tile  "ActiveFilterPhase"		    $ActiveFilterPhase$)			
				(set_tile  "ActiveFilterMark"			$ActiveFilterMark$)	
				(set_tile  "ActiveFilterQuantity"		$ActiveFilterQuantity$)
				(set_tile  "ActiveFilterThikness"	    $ActiveFilterThikness$)
				(set_tile  "ActiveFilterLength"	   	 	$ActiveFilterLength$)
				(set_tile  "ActiveFilterHeight"	    	$ActiveFilterHeight$)
				(set_tile  "ActiveFilterMaterial"	    $ActiveFilterMaterial$)
				(set_tile  "ActiveFilterDate"	    	$ActiveFilterDate$)
				(set_tile  "ActiveFilterCut"		    $ActiveFilterCut$)
			
				(set_tile  "PrgFilter"					$PrgFilter$)
				(set_tile  "IdFilter"					$IdFilter$)			
				(set_tile  "OrderFilter"				$OrderFilter$)			
				(set_tile  "PhaseFilter"				$PhaseFilter$)			
				(set_tile  "MarkFilter"					$MarkFilter$)
				(set_tile  "QuantityFilter"				$QuantityFilter$)
				(set_tile  "ThiknessFilter"				$ThiknessFilter$)
				(set_tile  "LengthFilter"				$LengthFilter$)
				(set_tile  "HeightFilter"				$HeightFilter$)
				(set_tile  "MaterialFilter"				$MaterialFilter$)
				(set_tile  "DateFilter"					$DateFilter$)
				(set_tile  "CutFilter"					$CutFilter$)

				(mode_tile "PrgFilter"    	1)
				(mode_tile "IdFilter"    	1)
				(mode_tile "OrderFilter"    1)
				(mode_tile "PhaseFilter"    1)
				(mode_tile "MarkFilter"     1)
				(mode_tile "QuantityFilter" 1)
				(mode_tile "ThiknessFilter" 1)
				(mode_tile "LengthFilter"   1)
				(mode_tile "HeightFilter"   1)
				(mode_tile "MaterialFilter" 1)
				(mode_tile "DateFilter" 	1)
				(mode_tile "CutFilter"	 	1)

				
				;(if (= $ActiveFilterId$    	"1")	(mode_tile "IdFilter"    	0)	(mode_tile "IdFilter" 	   	1))
				;(if (= $ActiveFilterOrder$    	"1")	(mode_tile "OrderFilter"    0)	(mode_tile "OrderFilter"    1))
				;(if (= $ActiveFilterPhase$    	"1")	(mode_tile "PhaseFilter"    0)	(mode_tile "PhaseFilter"    1))	
				;(if (= $ActiveFilterMark$     	"1")	(mode_tile "MarkFilter"     0)	(mode_tile "MarkFilter"     1))
				;(if (= $ActiveFilterQuantity$ 	"1")	(mode_tile "QuantityFilter" 0)	(mode_tile "QuantityFilter" 1))
				;(if (= $ActiveFilterThikness$ 	"1")	(mode_tile "ThiknessFilter" 0)	(mode_tile "ThiknessFilter" 1))
				;(if (= $ActiveFilterLength$   	"1")	(mode_tile "LengthFilter"   0)	(mode_tile "LengthFilter"   1))
				;(if (= $ActiveFilterHeight$   	"1")	(mode_tile "HeightFilter"   0)	(mode_tile "HeightFilter"   1))
				;(if (= $ActiveFilterMaterial$ 	"1")	(mode_tile "MaterialFilter" 0)	(mode_tile "MaterialFilter" 1))
				;(if (= $ActiveFilterDate$ 	  	"1")	(mode_tile "DateFilter" 	0)	(mode_tile "DateFilter" 	1))
				;(if (= $ActiveFilterCut$ 	  	"1")	(mode_tile "CutFilter" 		0)	(mode_tile "CutFilter"	 	1))
				
				(mode_tile "box_label" 2)
				(mode_tile "save" 1)
				
				(setq Rtn (SetRecordNesting LstTableNesting))
				
				(action_tile "ActiveFilterPrg" 		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterId" 		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterOrder" 	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterPhase"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterMark"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterQuantity"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterThikness"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterLength"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterHeight"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterMaterial"	"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterDate"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ActiveFilterCut"		"(setq Rtn (SetRecordNesting LstTableNesting))")

				(action_tile "PrgFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "IdFilter"				"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "OrderFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
                (action_tile "PhaseFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "MarkFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "QuantityFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "ThiknessFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "LengthFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "HeightFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "MaterialFilter"		"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "DateFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				(action_tile "CutFilter"			"(setq Rtn (SetRecordNesting LstTableNesting))")
				
				(action_tile "HelpItm" 		"(alert \"esempio 1,2 oppure <> -1\")")
				(action_tile "HelpId" 		"(alert \"esempio 012563584,555872369 oppure <> -15235877\")")
				(action_tile "HelpOrder" 	"(alert \"esempio C800,C900 oppure <> oppure -C900,-C901\")")
				(action_tile "HelpPhase" 	"(alert \"esempio 100,101 oppure <> oppure -100\")")
				(action_tile "HelpMark" 	"(alert \"esempio CT100,OP101 oppure <> oppure -17552\")")
				(action_tile "HelpQuantity" "(alert \"esempio <1,10>,-9,25  oppure <> oppure -1,-2\")")
				(action_tile "HelpMaterial" "(alert \"esempio S355J0,S275JR  oppure <> oppure -S275JR \")")
				(action_tile "HelpThikness" "(alert \"esempio <1,10>,-9,25  oppure <> oppure -1,-2\")")
				(action_tile "HelpLength" 	"(alert \"esempio <1,10>,-9,25  oppure <> oppure -1100.2\")")
				(action_tile "HelpHeight" 	"(alert \"esempio <1,10>,-9,25  oppure <> oppure -1100.2\")")
				(action_tile "HelpCut" 		"(alert \"esempio 1,2  oppure <> oppure -1,-2\")")
				(action_tile "HelpDate" 	"(alert \"01/20/2018,01/20/2019\")")

				(action_tile "box_info"				"(SelectItmBoxList \"box_info\")")
				(action_tile "selectall"			"(SelectAllBoxList \"box_info\" (SetRecordNesting LstTableNesting))")
				(action_tile "import"				(strcat "(if (GetDataBoxList \"box_info\" Rtn nil)"
															"    (progn"
															"       (setq Rtn (GetDataBoxList \"box_info\" Rtn nil))"
															"       (setq accept T *InfoTableNesting* (done_dialog))"
															"       (unload_dialog xx)"
															"     )"
															"    (alert \"Nessun file selezionato\")"
															")"
													))
				(action_tile "list"					(strcat "(if (GetDataBoxList  \"box_info\" Rtn nil)"
															"	 (ListNesting \"SHAPE\" (GetDataBoxList  \"box_info\" Rtn nil))"
															"	 (alert \"Nessun file selezionato\")"
															")"
													))
				(action_tile "cancel"				"(setq Rtn nil *InfoTableNestingDstv* (done_dialog)) (unload_dialog xx)")
				(start_dialog)
		)
	)
	(if accept Rtn nil)
)
;
;
;
(defun ExistID (IdShape / LstId IdDbase IdDbase IdDbase Check Conta Loop Rtn)

	(if IdShape
		(progn
			(setq LstId (GetLstIdEntity))
			(if LstId
				(progn
					(if (setq IdDbase (GetIdExternalShapeDbase    IdShape)) (setq Check (list IdDbase)))
					(if (setq IdDbase (GetLstIdInternalShapeDbase IdShape)) (setq Check (append Check IdDbase)))
					(if (setq IdDbase (GetLstIdTriggerShapeDbase  IdShape)) (setq Check (append Check IdDbase)))
			
					(setq Conta 0)
					(setq Loop T)
					(while (and Loop (< Conta (length Check)))
						(if (member (nth Conta Check) LstId)
							(progn
								(setq Rtn T)
								(setq Loop nil)
							)
						)
						(setq Conta (1+ Conta))
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
(defun ImportShapeDbase ( / itm LstIdActive Rtn LstIdShape LstShape LstPtInsert Ssel MinMaxSsel MinCatch MaxCatch)

	(setq LstShape (GuiSelectedPiecesDbase))
	;("1" "215807477" "C872" "300" "178-351" "1" "15" "100.00" "100.00" "S355J0" "26/07/2019" "Antiorario")
	(foreach itm LstShape
		(setq LstIdShape (append LstIdShape (list (nth 1 itm))))
	)
	
	(foreach itm LstIdShape
		(if	(ExistID itm)
			(progn
				(setq Rtn T)
				(setq LstIdActive (append LstIdActive (list itm)))
			)
		)
	)
	(if LstIdShape
		(if (not Rtn)
			(progn
				(setq LstPtInsert (PreviewNestingDbase LstIdShape))
				(setq Ssel (NestingShapeDbase LstIdShape LstPtInsert))
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
			(progn
				(Alert "Import interrotto - Trovato contorni gia' rappresentati")
				(princ LstIdActive)
			)
		)
		(alert "Nessun contorno selezionato !")
	)
	(princ)
)
;
;
;
(defun PreviewNestingDbase ( LstIdShape / *error*
						                  Out Ssel LstEnameShape itm Rtn)

	(defun *error* (msg / Conta )
		(setq Conta 0)
		(DeleteSsel Ssel)
	)
	;
	;
	;
	(if LstIdShape
		(progn
			(setq Out (PreviewNestingShapeDbase LstIdShape))
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
(defun PreviewNestingShapeDbase (LstIdShape / DimScreen StepColumn Xdstv Ydstv StartXdstv StartYDstv LstY EnameShape LstOutEname
					 				          itm DataDstv LstEnameShape Ssel minmax Width Height point1 point2 conta Rtn)
 
	(setq DimScreen (VpCoords))
	(setq StepColumn 1)
	(setq Xdstv (/ (+ (nth 0 (nth 0 DimScreen)) (nth 0 (nth 1 DimScreen))) 2.0))
	(setq Ydstv (/ (+ (nth 1 (nth 0 DimScreen)) (nth 1 (nth 1 DimScreen))) 2.0))
	(setq StartXdstv Xdstv)
	(setq StartYDstv Ydstv)
	(setq LstY nil)
	(setq Rtn (ssadd))
	
	(foreach itm LstIdShape
	
		(setq EnameShape 	(ImportDxfExternalShape itm))
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
	(list Rtn LstOutEname)
)
;
;
;
(defun NestingShapeDbase (LstIdShape LstPtInsert / Rtn Conta0 Conta1 itm PtInsert EnameShape Ssel)

	
	(setq Rtn (ssadd))
	(setq Conta0 0)
	(foreach itm LstIdShape
	
		(setq PtInsert 		 (nth Conta0 LstPtInsert)) 
		(setq Conta0 		 (1+ Conta0))
		(setq EnameShape     (GraphicDbase itm PtInsert))
		(setq Ssel 		     (InquadraShape EnameShape nil))
		
		(setq Conta1 0)
		(repeat (sslength Ssel)
				(ssadd (ssname Ssel Conta1) Rtn)
				(setq Conta1 (1+ Conta1))
		)
	)
	Rtn
)
;
;
;
(defun GraphicDbase (IdShape PtInsert / EnameExternalShape PtAnchor LstEnameInternalShape itm EnameTriggerShape IdGroup)

	(if (and IdShape PtInsert)
		(progn
			(setq EnameExternalShape	 	(ImportDxfExternalShape	IdShape))
			(vla-getboundingbox (vlax-ename->vla-object EnameExternalShape) 'mnl 'mxl)
			(setq PtAnchor mnl)
			(vla-move (vlax-ename->vla-object EnameExternalShape)  PtAnchor (vlax-3d-point PtInsert))
			
			(setq LstEnameInternalShape 	(ImportDxfInternalShape IdShape))
			(foreach itm LstEnameInternalShape
				(vla-move (vlax-ename->vla-object itm) PtAnchor (vlax-3d-point PtInsert))
			)
			
			(ZoomEname EnameExternalShape 100)
			(SetShape EnameExternalShape)
			(ChangeRecordShape EnameExternalShape 2 IdShape)
		
			(setq EnameTriggerShape	 		(ImportDxfTriggerShape	IdShape))
			(setq IdGroup 					(nth 0 (gnames EnameExternalShape)))
				
			(foreach itm EnameTriggerShape
				(vla-move (vlax-ename->vla-object itm) PtAnchor (vlax-3d-point PtInsert))
				(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems 
							(list (vlax-ename->vla-object itm)))
			)
		)
	)
	EnameExternalShape
)
;
;
;
(defun GetIdExternalShapeDbase (IdShape / NameDbFile tblName LstRowName ConnectString ConnectionObject Out Rtn)

	(if IdShape
		(progn

			(setq NameDbFile DbaseExShapeFile$)
			(setq tblName DbaseExShapeTblName$)
			(setq LstRowName DbaseExShapeData$)
			(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
			(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
			(if ConnectionObject
				(progn
					(setq Out (ReadDbase ConnectionObject tblName (nth 0 LstRowName) IdShape))
					(if (and (/= Out -1) (/= Out -2))	
						(progn
							(setq LstData (cdr Out))
							(setq Rtn (nth 1 (nth 0 LstData)))
						)
					)
				)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
		)
	)
	Rtn
)
;
;
;
(defun GetLstIdInternalShapeDbase (IdShape / NameDbFile tblName LstRowName ConnectString ConnectionObject itm Out Rtn)

	(if IdShape
		(progn
			(setq NameDbFile DbaseInShapeFile$)
			(setq tblName DbaseInShapeTblName$)
			(setq LstRowName DbaseInShapeData$)
			(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
			(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
			(if ConnectionObject
				(progn
					(setq Out (ReadDbase ConnectionObject tblName (nth 0 LstRowName) IdShape))
					(if (and (/= Out -1) (/= Out -2))	
						(foreach itm (cdr Out)
							(setq Rtn (append Rtn (list (nth 2 itm))))
						)
					)
				)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
		)
	)
	Rtn
)
;
;
;
(defun GetLstIdTriggerShapeDbase (IdShape / NameDbFile tblNameExtTrigger tblNameIntTrigger 
											LstRowNameExtTrigger LstRowNameIntTrigger ConnectString ConnectionObject itm Out Rtn)

	(if IdShape
		(progn
			(setq NameDbFile 			DbaseTriggerFile$)
			(setq tblNameExtTrigger 	DbaseTriggerExtTblName$)
			(setq tblNameIntTrigger 	DbaseTriggerIntTblName$)
			(setq LstRowNameExtTrigger 	DbaseTriggerExtData$)
			(setq LstRowNameIntTrigger 	DbaseTriggerIntData$)
			(setq ConnectString (strcat DbaseConnectString$ NameDbFile))

			(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
			(if ConnectionObject
				(progn

					(setq Out (ReadDbase ConnectionObject tblNameExtTrigger (nth 0 LstRowNameExtTrigger) IdShape))
					(if (and (/= Out -1) (/= Out -2))	
						(foreach itm (cdr Out)
							(setq Rtn (append Rtn (list (nth 2 itm))))
						)
					)
					(setq Out (ReadDbase ConnectionObject tblNameIntTrigger (nth 0 LstRowNameIntTrigger) IdShape))
					(if (and (/= Out -1) (/= Out -2))	
						(foreach itm (cdr Out)
							(setq Rtn (append Rtn (list (nth 2 itm))))
						)
					)
				)	
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
		)
	)
	Rtn
)
;
;
;
(defun ImportDxfExternalShape (IdShape / NameDbFile tblNam LstRowName ConnectString ConnectionObject 
										 Rtn LstData LstDxfN LstDxfE)

	(setq NameDbFile DbaseExShapeFile$)
	(setq tblName DbaseExShapeTblName$)
	(setq LstRowName DbaseExShapeData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
	(if ConnectionObject
		(progn
			(setq Rtn (ReadDbase ConnectionObject tblName (nth 0 LstRowName) IdShape))
			(if (and (/= Rtn -1) (/= Rtn -2))	
				(progn
					(setq LstData (cdr Rtn))
					(setq LstDxfN (read (nth 2 (nth 0 LstData))))
					(setq LstDxfE (read (nth 3 (nth 0 LstData))))
					(ADOLISP_DisconnectFromDB ConnectionObject)
					
					(if (and LstDxfN LstDxfE) (setq Rtn (entmakex (append LstDxfN (list LstDxfE)))))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun ImportDxfInternalShape (IdShape / NameDbFile tblNam LstRowName ConnectString ConnectionObject 
										 Rtn Rtn1 LstData LstDxfN LstDxfE)

	(setq NameDbFile DbaseInShapeFile$)
	(setq tblName DbaseInShapeTblName$)
	(setq LstRowName DbaseInShapeData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
	(if ConnectionObject
		(progn
			(setq Rtn (ReadDbase ConnectionObject tblName (nth 0 LstRowName) IdShape))
			
			
			(if (and (/= Rtn -1) (/= Rtn -2))	
				(foreach itm (cdr Rtn)
					;(setq LstData (cdr Rtn))
					
					(setq LstDxfN (read (nth 3 itm)))
					(setq LstDxfE (read (nth 4 itm)))
					
					(if (and LstDxfN LstDxfE) (setq Rtn1 (append Rtn1 (list (entmakex (append LstDxfN (list LstDxfE)))))))
				)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
		)
	)
	Rtn1
)
;
;
;
(defun ImportDxfTriggerShape (IdShape / NameDbFile tblNameExtTrigger tblNameIntTrigger
										LstRowNameExtTrigger LstRowNameIntTrigger
										ConnectString ConnectionObject 
										Rtn Rtn1 LstData LstDxfN LstDxfE)

 	(setq NameDbFile 			DbaseTriggerFile$)
	(setq tblNameExtTrigger 	DbaseTriggerExtTblName$)
	(setq LstRowNameExtTrigger 	DbaseTriggerExtData$)
	(setq tblNameIntTrigger 	DbaseTriggerIntTblName$)
	(setq LstRowNameIntTrigger 	DbaseTriggerIntData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))

	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
	(if ConnectionObject
		(progn

			(setq Rtn (ReadDbase ConnectionObject tblNameExtTrigger (nth 0 LstRowNameExtTrigger) IdShape))
			(if (and (/= Rtn -1) (/= Rtn -2))	
				(foreach itm (cdr Rtn)
					;(setq LstData (cdr Rtn))
					
					(setq LstDxfN (read (nth 3 itm)))
					(setq LstDxfE (read (nth 4 itm)))
					
					(if (and LstDxfN LstDxfE) (setq Rtn1 (append Rtn1 (list (entmakex (append LstDxfN (list LstDxfE)))))))
				)
			)

			(setq Rtn (ReadDbase ConnectionObject tblNameIntTrigger (nth 0 LstRowNameIntTrigger) IdShape))
			(if (and (/= Rtn -1) (/= Rtn -2))	
				(foreach itm (cdr Rtn)
					;(setq LstData (cdr Rtn))
					
					(setq LstDxfN (read (nth 3 itm)))
					(setq LstDxfE (read (nth 4 itm)))
					
					(if (and LstDxfN LstDxfE) (setq Rtn1 (append Rtn1 (list (entmakex (append LstDxfN (list LstDxfE)))))))
				)
			)
			
			(ADOLISP_DisconnectFromDB ConnectionObject)
		)
	)
	Rtn1
)
;
;
;
(defun ResetAllDbase ()
	(ResetDbaseInfoShape)
	(ResetDbaseExternalShape)
	(ResetDbaseInternalShape)
	(ResetDbaseTriggerShape)
)
;
;
;
(defun ResetDbaseInfoShape ( / NameDbFile tblName LstRowName ConnectString ConnectionObject Rtn itm IdShape LstIdShape)

	(setq NameDbFile DbaseInfoShapeFile$)
	(setq tblName DbaseInfoShapeTblName$)
	(setq LstRowName DbaseInfoShapeData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
	(if ConnectionObject
		(progn
			(setq Rtn (ReadDbase ConnectionObject tblName (nth 0 LstRowName) "*"))
			
			(if	(and (/= Rtn -1) (/= Rtn -2))
				(progn
					(foreach itm (cdr Rtn)
						(setq IdShape (nth 1 itm))
						(if (not (member IdShape LstIdShape))
							(setq LstIdShape (append LstIdShape (list IdShape)))
						)
					)
				)
			)
			
			(foreach itm LstIdShape
				(DeleteRowDbase ConnectionObject tblName (nth 0 LstRowName) itm)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
			
		)
	)
)
;
;
;
(defun ResetDbaseExternalShape ( / NameDbFile tblName LstRowName ConnectString ConnectionObject Rtn itm IdShape LstIdShape)

	(setq NameDbFile DbaseExShapeFile$)
	(setq tblName DbaseExShapeTblName$)
	(setq LstRowName DbaseExShapeData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
	
	(if ConnectionObject
		(progn
			(setq Rtn (ReadDbase ConnectionObject tblName (nth 0 LstRowName) "*"))
			
			(if	(and (/= Rtn -1) (/= Rtn -2))
				(progn
					(foreach itm (cdr Rtn)
						(setq IdShape (nth 1 itm))
						(if (not (member IdShape LstIdShape))
							(setq LstIdShape (append LstIdShape (list IdShape)))
						)
					)
				)
			)
			
			(foreach itm LstIdShape
				(DeleteRowDbase ConnectionObject tblName (nth 0 LstRowName) itm)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
			
		)
	)
)
;
;
;
(defun ResetDbaseInternalShape ( / NameDbFile tblName LstRowName ConnectString ConnectionObject Rtn itm IdShape LstIdShape)

	(setq NameDbFile DbaseInShapeFile$)
	(setq tblName DbaseInShapeTblName$)
	(setq LstRowName DbaseInShapeData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
	
	(if ConnectionObject
		(progn
			(setq Rtn (ReadDbase ConnectionObject tblName (nth 0 LstRowName) "*"))
			
			(if (and (/= Rtn -1) (/= Rtn -2))
				(foreach itm (cdr Rtn)
					(setq IdShape (nth 1 itm))
					(if (not (member IdShape LstIdShape))
						(setq LstIdShape (append LstIdShape (list IdShape)))
					)
				)
			)
			
			
			(foreach itm LstIdShape
				(DeleteRowDbase ConnectionObject tblName (nth 0 LstRowName) itm)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
			
		)
	)
)
;
;
;
(defun ResetDbaseTriggerShape ( / 	NameDbFile 
									tblNameExtTrigger tblNameIntTrigger
									LstRowNameExtTrigger LstRowNameIntTrigger
									ConnectString ConnectionObject Rtn itm IdShape LstIdShape)

	(setq NameDbFile 			DbaseTriggerFile$)
	(setq tblNameExtTrigger 	DbaseTriggerExtTblName$)
	(setq LstRowNameExtTrigger 	DbaseTriggerExtData$)
	(setq tblNameIntTrigger 	DbaseTriggerIntTblName$)
	(setq LstRowNameIntTrigger 	DbaseTriggerIntData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
		
	
	(if ConnectionObject
		(progn

			(setq IdShape nil)
			(setq Rtn (ReadDbase ConnectionObject tblNameExtTrigger (nth 0 LstRowNameExtTrigger) "*"))
			(if (and (/= Rtn -1) (/= Rtn -2))
				(foreach itm (cdr Rtn)
					(setq IdShape (nth 1 itm))
					(if (not (member IdShape LstIdShape))
						(setq LstIdShape (append LstIdShape (list IdShape)))
					)
				)
			)
			(foreach itm LstIdShape
				(DeleteRowDbase ConnectionObject tblNameExtTrigger (nth 0 LstRowNameExtTrigger) itm)
			)
			
			;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			
			(setq IdShape nil)
			(setq Rtn (ReadDbase ConnectionObject tblNameIntTrigger (nth 0 LstRowNameIntTrigger) "*"))
			(if (and (/= Rtn -1) (/= Rtn -2))
				(foreach itm (cdr Rtn)
					(setq IdShape (nth 1 itm))
					(if (not (member IdShape LstIdShape))
						(setq LstIdShape (append LstIdShape (list IdShape)))
					)
				)
			)
			(foreach itm LstIdShape
				(DeleteRowDbase ConnectionObject tblNameIntTrigger (nth 0 LstRowNameIntTrigger) itm)
			)

			(ADOLISP_DisconnectFromDB ConnectionObject)
		)
	)
)
;
;
;
(defun DeleteInfoShape (IdShape / NameDbFile tblName LstRowName ConnectString ConnectionObject)

	(setq NameDbFile DbaseInfoShapeFile$)
	(setq tblName DbaseInfoShapeTblName$)
	(setq LstRowName DbaseInfoShapeData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	(DeleteRowDbase ConnectionObject tblName (nth 0 LstRowName) IdShape)
	(ADOLISP_DisconnectFromDB ConnectionObject)
)
;
;
;
(defun DeleteExternalShape (IdShape / NameDbFile tblName LstRowName ConnectString ConnectionObject)

	(setq NameDbFile DbaseExShapeFile$)
	(setq tblName DbaseExShapeTblName$)
	(setq LstRowName DbaseExShapeData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	(DeleteRowDbase ConnectionObject tblName (nth 0 LstRowName) IdShape)
	(ADOLISP_DisconnectFromDB ConnectionObject)

)
;
;
;
(defun DeleteInternalShape (IdShape / NameDbFile tblName LstRowName ConnectString ConnectionObject)

	(setq NameDbFile DbaseInShapeFile$)
	(setq tblName DbaseInShapeTblName$)
	(setq LstRowName DbaseInShapeData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	(DeleteRowDbase ConnectionObject tblName (nth 0 LstRowName) IdShape)
	(ADOLISP_DisconnectFromDB ConnectionObject)

)
;
;
;
(defun DeleteTriggerShape (IdMainShape / NameDbFile tblNameExtTriggere tblNameIntTrigger 
										 LstRowNameExtTrigger  LstRowNameIntTrigger
										 ConnectString ConnectionObject)

	(setq NameDbFile 			DbaseTriggerFile$)
	(setq tblNameExtTrigger 	DbaseTriggerExtTblName$)
	(setq LstRowNameExtTrigger 	DbaseTriggerExtData$)
	(setq tblNameIntTrigger 	DbaseTriggerIntTblName$)
	(setq LstRowNameIntTrigger 	DbaseTriggerIntData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))

	
	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	(DeleteRowDbase ConnectionObject tblNameExtTrigger (nth 0 LstRowNameExtTrigger) IdMainShape)
	(DeleteRowDbase ConnectionObject tblNameIntTrigger (nth 0 LstRowNameIntTrigger) IdMainShape)
	(ADOLISP_DisconnectFromDB ConnectionObject)

)
;
;
;
(defun WriteDataShape (EnameShape / IdShape Rtn1 Rtn2 Rtn3 Rtn4)

	(if EnameShape
		(if (setq EnameShape (GetEnameShapeByDummyEnameSelect EnameShape))
			(progn
				(princ "\n[")
				(setq IdShape 	(GetIdShape EnameShape))
			
				(princ "Write Info Shape > ")
				(setq Rtn1 		(WriteDataInfoShape EnameShape))
				(princ Rtn1)
			
				(princ " External Shape > ")
				(setq Rtn2 		(WriteDataExternalShape EnameShape))
				(princ Rtn2)
			
				(princ " Internal Shape > ")
				(setq Rtn3 		(WriteDataInternalShape EnameShape))
				(princ Rtn3)
			
				(princ " Trigger Shape > ")
				(setq Rtn4 		(WriteDataTriggerShape EnameShape))
				(princ Rtn4)

				(princ "]\n")
	
				(if (and Rtn1 Rtn2 Rtn3  Rtn4)
					(setq Rtn T)
					(progn
						(DeleteInfoShape IdShape)
						(DeleteExternalShape IdShape)
						(DeleteInternalShape IdShape)
						(DeleteTriggerShape IdShape)
						(setq Rtn nil)
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
(defun WriteDataInfoShape (EnameShape / NameDbFile tblName LstRowName ConnectString 
											ConnectionObject
											OrderShape PhaseShape FamilyShape MarkShape IdShape QtaShape NameShape 
											MatShape ThikShape DimensionShape LengthShape WidthShape CutShape DateShape 
											Flag1Shape Flag2Shape Flag3Shape LstDxfCode LstValName DxfDataN DxfDataE 
											Rtn)

											

	
	(setq NameDbFile DbaseInfoShapeFile$)
	(setq tblName DbaseInfoShapeTblName$)
	(setq LstRowName DbaseInfoShapeData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	
	
	
	(if EnameShape
		(progn
			(setq IdShape 		 (GetIdShape EnameShape))
			(setq OrderShape 	 (GetComShape EnameShape))
			(setq PhaseShape 	 (GetPhaseShape EnameShape))
			(setq FamilyShape "-")
			(setq MarkShape 	 (GetNameShape EnameShape))
			(setq QtaShape 		 (GetQtaShape EnameShape))
			(setq NameShape "-")
			(setq MatShape 		 (GetMatShape EnameShape))
			(setq ThikShape 	 (GetTkShape EnameShape))
			(setq DimensionShape (GetDimensionShape EnameShape))
			(setq LengthShape 	 (LM:rtos  (car  (nth 1 DimensionShape))  2 2))
			(setq WidthShape 	 (LM:rtos  (cadr (nth 1 DimensionShape))  2 2))
 			(setq CutShape 		 (GetCutShape EnameShape))
			(setq DateShape 	 (GetDateShape EnameShape))
			(setq Flag1Shape "-")
			(setq Flag2Shape "-")
			(setq Flag3Shape "-")
			
			;(if (< (atoi QtaShape) 9)   								(setq QtaShape (strcat "000" QtaShape)))
			;(if (and (> (atoi QtaShape) 9)   (< (atoi QtaShape) 99))  	(setq QtaShape (strcat "00" QtaShape)))
			;(if (and (> (atoi QtaShape) 99)  (< (atoi QtaShape) 999)) 	(setq QtaShape (strcat "0" QtaShape)))

			(setq LstValName (list	IdShape
									OrderShape
									PhaseShape
									FamilyShape
									MarkShape
									QtaShape
									NameShape
									MatShape
									ThikShape
									LengthShape
									WidthShape
									CutShape
									DateShape
									Flag1Shape
									Flag2Shape
									Flag3Shape
									))
			;(terpri) (princ LstValName) (terpri)
			
			(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
			(if ConnectionObject 
				(progn
					(DeleteRowDbase ConnectionObject tblName (nth 0 LstRowName) IdShape)
					(setq Rtn (WriteDbase 	ConnectionObject tblName LstRowName LstValName))
					
				)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
		)
	)
	Rtn
)
;
;
;
(defun WriteDataExternalShape (EnameShape / NameDbFile tblName LstRowName ConnectString 
											ConnectionObject
											OrderShape PhaseShape FamilyShape MarkShape IdShape QtaShape NameShape 
											MatShape ThikShape CutShape DateShape Flag1Shape Flag2Shape Flag3Shape
											LstDxfCode LstValName
											DxfDataN DxfDataE Rtn)

											

	
	(setq NameDbFile DbaseExShapeFile$)
	(setq tblName DbaseExShapeTblName$)
	(setq LstRowName DbaseExShapeData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	
	(if EnameShape
		(progn
			(setq IdShape 		(GetIdShape EnameShape))
			(setq LstDxfCode 	(DxfCode->String Enameshape))
	
			(if (not (nth 0 LstDxfCode)) (setq DxfDataN "-") (setq DxfDataN  (nth 0 LstDxfCode)))	; record dxflist data
			(if (not (nth 1 LstDxfCode)) (setq DxfDataE "-") (setq DxfDataE  (nth 1 LstDxfCode)))	; extended data
			
			
			(setq LstValName (list	IdShape
									DxfDataN
									DxfDataE
									))
	
			(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
			(if ConnectionObject 
				(progn
					(DeleteRowDbase ConnectionObject tblName (nth 0 LstRowName) IdShape)
					(setq Rtn (WriteDbase 	ConnectionObject tblName LstRowName LstValName))
					
				)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
		)
	)
	Rtn
)
;
;
;
(defun WriteDataInternalShape (EnameShape / NameDbFile tblName LstRowName ConnectString 
											ConnectionObject IdShape IdInShape LstEnameInternalShape 
											LstDxfCode LstValName itm
											DxfDataN DxfDataE Rtn)
	
	
	
	(setq NameDbFile DbaseInShapeFile$)
	(setq tblName DbaseInShapeTblName$)
	(setq LstRowName DbaseInShapeData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	(setq Rtn T)
	
	(if EnameShape
		(progn
			(setq EnameShape 			(GetEnameShapeByDummyEnameSelect EnameShape))
			(setq LstEnameInternalShape (GetEnameInternalShapeByDummyEnameSelect EnameShape))
			(setq IdShape 				(GetIdShape EnameShape))
				
			(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
			(if ConnectionObject
				(progn
					(DeleteRowDbase ConnectionObject tblName (nth 0 LstRowName) IdShape)
					(foreach itm LstEnameInternalShape
				
						(setq LstDxfCode (DxfCode->String itm))
						(setq IdInShape  (GetIdShape itm))
						
						(if (not (nth 0 LstDxfCode)) (setq DxfDataN "-")  (setq DxfDataN (nth 0 LstDxfCode)))
						(if (not (nth 1 LstDxfCode)) (setq DxfDataE "-")  (setq DxfDataE (nth 1 LstDxfCode)))
							
						(setq LstValName (list IdShape IdInShape DxfDataN DxfDataE))
						(if (not (WriteDbase 	ConnectionObject tblName LstRowName LstValName))
							(setq Rtn nil)
						)
					)
				)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
		)
	)
	Rtn
)
;
;
;
(defun WriteDataTriggerShape (EnameShape / 	WriteTriggerShape
											NameDbFile tblNameExtTrigger tblNameIntTrigger 
											LstRowNameExtTrigger LstRowNameIntTrigger ConnectString ConnectionObject
											Rtn LstEnameInternalShape
											itm)


	(defun WriteTriggerShape (EnameShape ConnectionObject tblName LstRowName / IdShape LstEnameTrigger itm LstDxfCode LstValName 
																				MainShape MainIdShape Rtn)
	
		(setq Rtn T)
		(if (and EnameShape ConnectionObject tblName LstRowName)
			(progn			
				(setq MainShape 		(GetEnameShapeByDummyEnameSelect EnameShape))
				(setq MainIdShape 	 	(GetIdShape MainShape))
				
				(setq IdShape 	 		(GetIdShape EnameShape))
				(setq LstEnameTrigger 	(GetEnameTriggerByEnameShape EnameShape))
				
				(DeleteRowDbase ConnectionObject tblName (nth 1 LstRowName) IdShape)
				
				(foreach itm LstEnameTrigger
					(if itm
						(progn
							(setq LstDxfCode 	(DxfCode->String itm))
							(setq LstValName 	(list MainIdShape IdShape (nth 0 LstDxfCode) (nth 1 LstDxfCode)))
				
							(if (not (WriteDbase 	ConnectionObject tblName LstRowName LstValName))
								(setq Rtn nil)
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
	(setq NameDbFile 			DbaseTriggerFile$)
	(setq tblNameExtTrigger 	DbaseTriggerExtTblName$)
	(setq LstRowNameExtTrigger 	DbaseTriggerExtData$)
	(setq tblNameIntTrigger 	DbaseTriggerIntTblName$)
	(setq LstRowNameIntTrigger 	DbaseTriggerIntData$)
	(setq ConnectString (strcat DbaseConnectString$ NameDbFile))
	(setq Rtn T)

	(if EnameShape
		(progn
		
			(setq EnameShape 			(GetEnameShapeByDummyEnameSelect EnameShape))
			(setq LstEnameInternalShape (GetEnameInternalShapeByDummyEnameSelect EnameShape))
			
			(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
			
			(if ConnectionObject
				(progn

					; Write Trigger External Shape
					(if (not (WriteTriggerShape EnameShape ConnectionObject tblNameExtTrigger LstRowNameExtTrigger))
						(setq Rtn nil)
					)
					
					; Write Trigger Internal Shape
					
					(foreach itm LstEnameInternalShape
						(if (not (WriteTriggerShape itm ConnectionObject tblNameIntTrigger LstRowNameIntTrigger))
							(setq Rtn nil)
						)
					)
				)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
		)
	)
	Rtn
)
;
;
;
;
;
;
;
;
; Connecting to the database ...
; (setq NameDbFile "C:\\EasyCut\\Dbase\\InfoShape.mdb")
;(setq ConnectString (strcat "Provider=MSDASQL;Driver={Microsoft Access Driver (*.mdb)};DBQ=" NameDbFile))
;(setq ConnectString (strcat "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" NameDbFile ";Persist Security Info=False"))
;(setq ConnectString (strcat "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" NameDbFile ";Persist Security Info=False"))
;(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
;(ADOLISP_DisconnectFromDB ConnectionObject)
;
;
; ->	(WriteDbase ConnectionObject tblName LstRowName LstValName)
(defun WriteDbase (ConnectionObject tblName LstRowName LstValName)

	(if (and ConnectionObject tblName LstRowName LstValName)
		(if (not (setq Rtn (ADOLISP_DoSQL ConnectionObject (SQLStatementInsert tblName LstRowName LstValName))))
			(setq Rtn -1) 		; Scrittura fallita
		)
	)
	Rtn
)
;
; ->	(ReadDbase ConnectionObject tblName "AUTOCAD_DRAWING" "ABCDEF00")
; ->	(ReadDbase ConnectionObject tblName "AUTOCAD_DRAWING" "*")
(defun ReadDbase (ConnectionObject tblName rowName valueName / Rtn SQLStatement)

	(if (and ConnectionObject tblName rowName valueName)
		(progn
			(if (= valueName "*")
				(setq SQLStatement (strcat "SELECT * FROM " tblName ";"))										;	"SELECT * FROM DESKS;"
				(setq SQLStatement (strcat "SELECT * FROM " tblName " WHERE " rowName " = '" valueName "'"))	;	"SELECT * FROM DESKS WHERE AUTOCAD_HANDLE = 'ABCDEF00'"
			)
			(if (not (setq Rtn (ADOLISP_DoSQL ConnectionObject SQLStatement)))
				(setq Rtn -1) 		; Lettura fallita
				(if (= (length Rtn) 1)
					(setq Rtn -2)	; Valore non trovato
				)
			)
		)
	)
	Rtn
)
;
;
;
; ->	(setq SQLStatement "SELECT IDSHAPE FROM INFOSHAPE WHERE (ORDERSHAPE='C872' OR ORDERSHAPE='C872123')  AND (PHASESHAPE='300' OR PHASESHAPE='310' OR PHASESHAPE='422' OR PHASESHAPE='400')")
(defun ReadDbaseMultiField (ConnectionObject SQLStatement / Rtn SQLStatement)

	(if (and ConnectionObject SQLStatement)
		(progn
			(if (not (setq Rtn (ADOLISP_DoSQL ConnectionObject SQLStatement)))
				(setq Rtn -1) 		; Lettura fallita
				(if (= (length Rtn) 1)
					(setq Rtn -2)	; Valore non trovato
				)
			)
		)
	)
	Rtn
)
;
;
; ->	(DeleteRowDbase ConnectionObject tblName "AUTOCAD_DRAWING" "TESTDRAWING")
(defun DeleteRowDbase (ConnectionObject tblName rowName valueName / Rtn)

	(if (and ConnectionObject tblName rowName valueName)
		(progn
			(setq SQLStatement (strcat "DELETE FROM " tblName " WHERE " rowName "='" valueName "'"))
			(if (not (setq Rtn (ADOLISP_DoSQL ConnectionObject SQLStatement)))
				(setq Rtn -1) 		; Cancellazione fallita
			)
		)
	)
	Rtn
)
;
;
;
(defun SQLStatementInsert (tblName LstRowName LstValName / Rtn conta)

	; "INSERT INTO DESKS (AUTOCAD_HANDLE, AUTOCAD_DRAWING, OCCUPANT, EXTENSION, PROPERTY_NUMBER) VALUES ('ABCDEF00', 'TESTDRAWING', 'Barbara', '123456', '654321')"
	
	(if (and tblName LstRowName LstValName)
		(progn
			(setq Rtn (strcat "INSERT INTO " tblName " ("))
			(setq conta 1)
			(foreach itm LstRowName
				(setq Rtn (strcat Rtn itm))
				(if (< conta (length LstRowName)) (setq Rtn (strcat Rtn ", ")))
				(setq conta (1+ conta))
			)
			(setq Rtn (strcat Rtn ")"))
			
			(setq Rtn (strcat Rtn " VALUES "))
			
			(setq conta 1)
			(setq Rtn (strcat Rtn "("))
			(foreach itm LstValName
				(setq Rtn (strcat Rtn "'" itm "'"))
				(if (< conta (length LstRowName)) (setq Rtn (strcat Rtn ", ")))
				(setq conta (1+ conta))
			)
			(setq Rtn (strcat Rtn ")"))
		)
	)
	Rtn
)
;
;
;
(defun DxfCode->String (EnameShape / LstDxfCode LstDxfCodeExtended NumberDec itm RtnN RtnE)

	
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
								(setq RtnN (strcat RtnN "(62 . " (LM:rtos (cdr itm) 2 0) ")"))
							)
							; ----------------------------------------------------------------
							((= (car itm) 90)	; Number of vertices 
								(setq RtnN (strcat RtnN "(90 . " (LM:rtos (cdr itm) 2 0) ")"))
							)
							((= (car itm) 70)	; Flag  default is 0 1 = Closed; 128 = Plinegen 
								(setq RtnN (strcat RtnN "(70 . " (LM:rtos (cdr itm) 2 0) ")"))
							)
							((= (car itm) 43)	; Constant width 
								(setq RtnN (strcat RtnN "(43 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 38)	; Elevation (optional; default = 0)
								(setq RtnN (strcat RtnN "(38 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 39)	; Thickness (optional; default = 0)
								(setq RtnN (strcat RtnN "(39 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 40)	; Starting width  (optional; default = 0) / Radius
								(setq RtnN (strcat RtnN "(40 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 41)	; End width  (optional; default = 0)
								(setq RtnN (strcat RtnN "(41 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 42)	; Bulge  (optional; default = 0)
								(setq RtnN (strcat RtnN "(42 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 50)	; Start Angle
								(setq RtnN (strcat RtnN "(50 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 51)	; End Angle
								(setq RtnN (strcat RtnN "(51 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 10)	; Start
								(if (= (length itm) 4)
									(setq RtnN (strcat RtnN "(10 " 	(LM:rtos (car (cdr itm)) 2 NumberDec) " " 
																	(LM:rtos (cadr (cdr itm)) 2 NumberDec) " " 
																	(LM:rtos (caddr (cdr itm)) 2 NumberDec) ")")) 
								)
								(if (= (length itm) 3)
									(setq RtnN (strcat RtnN "(10 " 	(LM:rtos (car (cdr itm)) 2 NumberDec) " " 
																	(LM:rtos (cadr (cdr itm)) 2 NumberDec) ")")) 
								)
							)
							((= (car itm) 11)	; End
								(if (= (length itm) 4)
									(setq RtnN (strcat RtnN "(11 " 	(LM:rtos (car (cdr itm)) 2 NumberDec) " " 
																	(LM:rtos (cadr (cdr itm)) 2 NumberDec) " " 
																	(LM:rtos (caddr (cdr itm)) 2 NumberDec) ")")) 
								)
								(if (= (length itm) 3)
									(setq RtnN (strcat RtnN "(11 " 	(LM:rtos (car (cdr itm)) 2 NumberDec) " " 
																	(LM:rtos (cadr (cdr itm)) 2 NumberDec) ")")) 
								)
							)

							((= (car itm) 210)	; normal axis
								(setq RtnN (strcat RtnN "(210 " (LM:rtos (car (cdr itm)) 2 NumberDec) " " 
																(LM:rtos (cadr (cdr itm)) 2 NumberDec) " " 
																(LM:rtos (caddr (cdr itm)) 2 NumberDec) ")")) 
							)
						)
					)
					(setq RtnN (strcat RtnN ")"))
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
				)
			)
		)
	)
	;(ExportCode Rtn)
	(list RtnN RtnE)
)
