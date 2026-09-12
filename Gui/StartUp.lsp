(defun FoldersOutput (/ StrCatFolder)


	(defun StrCatFolder (LstPath / itm Rtn)
		
		
		(foreach itm LstPath
			(if (= (ascii (substr itm 1 1)) 92)
				(setq itm (substr itm 2 (strlen itm)))
			)
			(if (= (ascii (substr itm (strlen itm))) 92)
				(setq itm (substr itm 1 (- (strlen itm) 1)))
			)
			(if Rtn	
				(setq Rtn (strcat Rtn "\\" itm))
				(setq Rtn itm)
			)
		)
		Rtn
	)
	
	(if (not (vl-file-directory-p BinPathEasyCut$)) 		(alert (strcat "Folder " BinPathEasyCut$  		" Error Not Exist !")))
	(if (not (vl-file-directory-p LoadEasyCut$)) 			(alert (strcat "Folder " LoadEasyCut$  			" Error Not Exist !")))
	(if (not (vl-file-directory-p GuiPathEasyCut$))			(alert (strcat "Folder " GuiPathEasyCut$        " Error Not Exist !")))
	(if (not (vl-file-directory-p FontPathEasyCut$))		(alert (strcat "Folder " FontPathEasyCut$       " Error Not Exist !")))
	(if (not (vl-file-directory-p LibPathEasyCut$)) 		(alert (strcat "Folder " LibPathEasyCut$        " Error Not Exist !")))
	(if (not (vl-file-directory-p SetupPathEasyCut$)) 		(alert (strcat "Folder " SetupPathEasyCut$      " Error Not Exist !")))
	
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	;							Folders Output
	;
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p (strcat SetupPathEasyCut$ "Tmp")))
		(progn
			(princ (strcat "\n->(1) Folder " (strcat SetupPathEasyCut$ "Tmp")  " Not Exist !"))
			(if (vl-mkdir (strcat SetupPathEasyCut$ "tmp"))
				(princ (strcat "\n->Default Folder " (strcat SetupPathEasyCut$ "Tmp") "-> Create"))
				(princ (strcat "\n->Default Folder " (strcat SetupPathEasyCut$ "Tmp") "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p $PathWorkDefault))
		(progn
			(princ (strcat "\n->(2) Folder " $PathWorkDefault  " Not Exist !"))
			(if (vl-mkdir $PathWorkDefault) 
				(princ (strcat "\n->Default Folder " $PathWorkDefault "-> Create"))
				(princ (strcat "\n->Default Folder " $PathWorkDefault "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p $PathSearchDefault))
		(progn
			(princ (strcat "\n->(3) Folder " $PathSearchDefault  " Not Exist !"))
			(if (vl-mkdir $PathWorkDefault) 
				(princ (strcat "\n->Default Folder " $PathSearchDefault "-> Create"))
				(princ (strcat "\n->Default Folder " $PathSearchDefault "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p $PathNcDefault))
		(progn
			(princ (strcat "\n->(4) Folder " $PathNcDefault  " Not Exist !"))
			(if (vl-mkdir $PathNcDefault) 
				(princ (strcat "\n->Default Folder " $PathNcDefault "-> Create"))
				(princ (strcat "\n->Default Folder " $PathNcDefault "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p $PathInfoDefault))
		(progn
			(princ (strcat "\n->(5) Folder " $PathInfoDefault  " Not Exist !"))
			
			(if (vl-mkdir $PathInfoDefault) 
				(princ (strcat "\n->Default Folder " $PathInfoDefault "-> Create"))
				(princ (strcat "\n->Default Folder " $PathInfoDefault "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p $PathOutputDefault))
		(progn
			(princ (strcat "\n->(6) Folder " $PathOutputDefault  " Not Exist !"))
			(if (vl-mkdir $PathOutputDefault) 
				(princ (strcat "\n->Default Folder " $PathOutputDefault "-> Create"))
				(princ (strcat "\n->Default Folder " $PathOutputDefault "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p $PathNestingDefault)) 					
		(progn
			(princ (strcat "\n->(7) Folder " $PathNestingDefault     " Not Exist !"))
			(if (vl-mkdir $PathNestingDefault)
				(princ (strcat "\n->Default Folder " $PathNestingDefault "-> Create"))
				(princ (strcat "\n->Default Folder " $PathNestingDefault "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p $PathDxfJobDefault)) 					
		(progn
			(princ (strcat "\n->(8) Folder " $PathDxfJobDefault     " Not Exist !"))
			(if (vl-mkdir $PathNestingDefault)
				(princ (strcat "\n->Default Folder " $PathDxfJobDefault "-> Create"))
				(princ (strcat "\n->Default Folder " $PathDxfJobDefault "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p $PathDocsDefault)) 				
		(progn
			(princ (strcat "\n->(9) Folder " $PathDocsDefault    " Not Exist !"))
			(if (vl-mkdir $PathDocsDefault)	
				(princ (strcat "\n->Default Folder " $PathDocsDefault "-> Create"))
				(princ (strcat "\n->Default Folder " $PathDocsDefault "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p (StrCatFolder (list $PathDocsDefault ECFolderReport$))))
		(progn
			(princ (strcat "\n->(10) Folder " (StrCatFolder (list $PathDocsDefault ECFolderReport$)) " Not Exist !"))
			(if (vl-mkdir (StrCatFolder (list $PathDocsDefault ECFolderReport$))) 
				(princ (strcat "\n->Default Folder " (StrCatFolder (list $PathDocsDefault ECFolderReport$)) "-> Create"))
				(princ (strcat "\n->Default Folder " (StrCatFolder (list $PathDocsDefault ECFolderReport$)) "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p (StrCatFolder (list $PathDocsDefault ECFolderSheet$)))) 
		(progn																
			(princ (strcat "\n->(11) Folder " (StrCatFolder (list $PathDocsDefault ECFolderSheet$)) " Not Exist !"))
			(if (vl-mkdir (StrCatFolder (list $PathDocsDefault ECFolderSheet$))) 
				(princ (strcat "\n->Default Folder " (StrCatFolder (list $PathDocsDefault ECFolderSheet$)) "-> Create"))
				(princ (strcat "\n->Default Folder " (StrCatFolder (list $PathDocsDefault ECFolderSheet$)) "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p (StrCatFolder (list $PathDocsDefault ECFolderShape$))))
		(progn
			(princ (strcat "\n->(12) Folder " (StrCatFolder (list $PathDocsDefault ECFolderShape$)) " Not Exist !"))
			(if (vl-mkdir (StrCatFolder (list $PathDocsDefault ECFolderShape$))) 
				(princ (strcat "\n->Default Folder " (StrCatFolder (list $PathDocsDefault ECFolderShape$)) "-> Create"))
				(princ (strcat "\n->Default Folder " (StrCatFolder (list $PathDocsDefault ECFolderShape$)) "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (not (vl-file-directory-p (StrCatFolder (list $PathDocsDefault ECFolderShapePreview$))))
		(progn
			(princ (strcat "\n->(13) Folder " (StrCatFolder (list $PathDocsDefault ECFolderShapePreview$)) " Not Exist !"))
			(if (vl-mkdir (StrCatFolder (list $PathDocsDefault ECFolderShapePreview$))) 
				(princ (strcat "\n->Default Folder " (StrCatFolder (list $PathDocsDefault ECFolderShapePreview$)) "-> Create"))
				(princ (strcat "\n->Default Folder " (StrCatFolder (list $PathDocsDefault ECFolderShapePreview$)) "-> Not Create"))
			)
		)
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
	(setq DefaultBrowserEasyCut$ (vl-registry-read EasyCutRegistryPath$ "PathOtherBrowser"))
	(if (and (/= DefaultBrowserEasyCut$ "") (vl-string-search "*" DefaultBrowserEasyCut$))
		(setq DefaultBrowserEasyCut$  (car (splitxt DefaultBrowserEasyCut$ "*"))) 
		(setq DefaultBrowserEasyCut$  (GetNameBrowserDefaultToRegistry))
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
	; Derivate Filders
	;
	(if (not (vl-file-directory-p OutputPathEasyCut$)) 	(setq OutputPathEasyCut$ 	$PathWorkDefault)) 
	(if (not (vl-file-directory-p CncPathEasyCut$))		(setq CncPathEasyCut$ 		$PathNcDefault))
	(if (not (vl-file-directory-p InfoPathEasyCut$))	(setq InfoPathEasyCut$ 		$PathInfoDefault))
	(if (not (vl-file-directory-p CutPathEasyCut$))		(setq CutPathEasyCut$ 		$PathOutputDefault))	
	(if (not (vl-file-directory-p DxfNestingEasyCut$))	(setq DxfNestingEasyCut$ 	$PathNestingDefault))
	(if (not (vl-file-directory-p HtmlStorageEasyCut$))	(setq HtmlStorageEasyCut$ 	$PathDocsDefault))


	;	BinPathEasyCut$       | archivio Bin
	;	LoadEasyCut$          | archivio Load
	;	NestPorfessorEasyCut$ | eseguibile NestProfessor
	;	GuiPathEasyCut$       | archivio interfaccia grafica DCL
	;	FontPathEasyCut$      | archivio font
	;	LibPathEasyCut$       | archivio libreria blocchi
	;	obsoleto DbaseEasyCut$         | archivio DataBase
	;	CncPathEasyCut$       | archivio CNC import
	;	OutputPathEasyCut$    | archivio lavoro
	;	CutPathEasyCut$       | archivio salva percorso taglio
	;	InfoPathEasyCut$      | archivio info 
	;	HtmlStorageEasyCut$   | archivio layout Html
	;	HtmlScriptEasyCut$    | archivio script Html
	;	DxfNestingEasyCut$    | archivio Dxf nesting
)
;
;
(defun EasyCutStartUp(/ Limit)
	;
	; Startup +++++
	;
	(setq   $InfoMtextSheet   		"MtSheetEasyCut")
	(setq   $InfoMtextShape   		"MtShapeEasyCut")
	(setq   $InfoMtextDefault 		"MtDefaultEasyCut")
	(setq   $RgpTargetPoint    		"EAANCHORPOINT")
	(setq   $RgpTrash    			"EATRASH")
	;
	; DXF IMPORT +++++++++++++++++++++++
	; controllo da eseguire sulla versione del dxf generato 
	;  
	(setq ECVersionDxfCreated$ nil)   ; T il dxf verrà importato con vla-Import / nil verrà importato con Dxf2Entity
	(setq ECSpline2Polyline$ T)		  ; T la spline verrà sostituita da una polyline / nil rimane spline
	(setq ECSpline2PolylineToll$ 0.1) ; lunghezza del segmento proiettato (freccia) 
	; ++++++++++++++++++++++++++++++++++
	(setq Clone$ 						T)					; Tutte le entità EasyCut copiate verranno colonate
	(setq UcsActEasyCut$  				"UcsActEasyCut")
	(setq UcsWrdEasyCut$  				"UcsWrdEasyCut")
	(setq EasyCutTypeDim$  				"0")
	(setq EasyCutAccuracyAngleRotation$ (/ (* 0.5 Pi) 180.0))
	; Set menu
	(setq DefaultMenuEasyCut$ MainMenu)
	;
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(FoldersOutput)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	; DINFO
	;
	(regapp $InfoMtextSheet)
	(regapp $InfoMtextShape)
	(regapp $InfoMtextDefault)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(regapp $RgpTrash)
	(regapp $RgpSheet)
	(regapp $RgpSheetTarget)
	(regapp $RgpShape)
	(regapp $RgpShapeTarget)
	(regapp $RgpTiggerOn)
	(regapp $RgpTiggerOff)
	(regapp $RgpSymula)
	(regapp $RgpTargetPoint)
	(MakeStyle (strcat FontPathEasyCut$  $FontDefaultEasyCut) $StyleEasyCut  (list nil 0.8 nil) 0)
	(MakeStyle (strcat FontPathEasyCut$  $FontDefaultEasyCut) (strcat $StyleEasyCut "Dim")  (list nil 0.8 nil) 0)
	(DeleteLayout "FoundSheet")
	(DeleteLayout "FoundShape")
	
	(setq Limit (VpCoords))
	(command "_.zoom" "_extents")
		(MyPurge '("BLOCK" "GROUP"))
		(UpGradeGroup T)
		(UpGradeIdShape T)
		(UpGradeIdSheet T)
		(UpGradeComplanarShape T)
	(ZoomWindow01 (car Limit) (cadr Limit))
	;
	; Load Acet ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;	
	(if (and (not (boundp 'acet-ui-progress-init)) ; Se le funzioni non sono già presenti  E se il file delle librerie esiste
			(findfile "acetutil.arx")
		)           
		(if (boundp 'acet-load-expresstools)
			(acet-load-expresstools)                  ; Versione 2025+
			(arxload "acetutil.arx" nil)              ; Versioni precedenti
		)
	)
	;
	; Variabili da mantenre rispetto alla configurazione dell'utente +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(setq CalcQtyDeduct$ "1")
	(setq $NumberTorch$ 1)
    (setq FileBlockShape$ "BlockShape03.dwg")
	(StartReactors T)
)