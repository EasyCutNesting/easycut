(defun C:Ec ()
	(FoldersOutput)
	(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "")
	(DefaultMenuEasyCut$)
)
;
(defun SaveVarDwg (/ _attdia _cmdecho _osmode)
	(setq _attdia  (getvar "ATTDIA"))
	(setq _cmdecho (getvar "CMDECHO"))
	(setq _osmode  (getvar "OSMODE"))
	(SaveUcs UcsActEasyCut$)
	(list _attdia _cmdecho _osmode)
)
;
(defun DefVarDwg ()
	(setvar "ATTDIA" 0)
	(setvar "CMDECHO" 0)
	(setvar "OSMODE" 0)
	(UCSWorld UcsWrdEasyCut$)
	(setq CommandActiveEasyCut$ T)
	;(if (not (InternetStatus nil)) 
		(setq TmpScrHtmlEasyCut$ (strcat "file:///" (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "/Html/Script/"))
	;	(setq TmpScrHtmlEasyCut$ HtmlScriptEasyCut$)
	;)
)
;
(defun ResVarDwg (LstVar)
	(setvar "ATTDIA" 	(nth 0 LstVar))
	(setvar "CMDECHO" 	(nth 1 LstVar))
	(setvar "OSMODE"  	(nth 2 LstVar))
	(RestoreUcs			UcsActEasyCut$)
	(DeleteUCS 			UcsWrdEasyCut$)
	(setq CommandActiveEasyCut$ nil)
)
;
(defun MainMenu ( / SaveCfgMenu SetCfgMenu RestoreCfgMenu
					xx VarDwg Prg
					PopupImport MacroImport PopupSql MacroSql 
					PopupApp MacroApp PopupSearch MacroSearch PopupTrigger MacroTrigger
					PopupSetup MacroSetup PopupShapeAndSheet MacroSAndS 
					PopupTools MacroTools PopupReport MacroReport 
					PopupNestingExpert MacroNestingExpert
					PopupNestingSimple MacroNestingSimple
					PopupNestingBar MacroNestingBar
					PopupNestingTools MacroNestingTools
					CMacroApp CMacroImport CMacroSql CMacroSearch CMacroTrigger
					CMacroSetup CMacroSAndS CMacroTools	CMacroReport CMacroNestingBar CMacroNestingExpert
					CMacroNestingSimple	CMacroNestingTools
					PrgApp$ PrgImport$ PrgSql$ PrgSearch$ PrgTrigger$ PrgSetup$
					PrgSAndS$ PrgTools$ PrgReport$ PrgNestingExpert$ PrgNestingSimple$ PrgNestingTools$)

	;(defun *error* (msg)
	;	(ResVarDwg VarDwg)
	;)
	(defun SaveCfgMenu ()
		(vl-registry-write EasyCutRegistryPath$ "MenuCfg" 
				(LM:lst->str (list  PrgApp$ 
									PrgImport$ 
									PrgSql$ 
									PrgSearch$ 
									PrgTrigger$ 
									PrgSetup$ 
									PrgSAndS$ 
									PrgTools$ 
									PrgReport$ 
									PrgNestingExpert$ 
									PrgNestingSimple$ 
									PrgNestingTools$ 
									PrgNestingBar$) "-")
		)
	)
	;
	(defun SetCfgMenu ()
		(setq PrgApp$ 				"0"
			  PrgImport$ 			"0"
			  PrgSql$ 				"0"
			  PrgSearch$ 			"0"
			  PrgTrigger$			"0"
			  PrgSetup$				"0"
			  PrgSAndS$				"0"
			  PrgTools$				"0"
			  PrgReport$			"0"
			  PrgNestingExpert$ 	"0"
			  PrgNestingSimple$		"0"
			  PrgNestingTools$		"0"
			  PrgNestingBar$		"0"
		)
	)
	;
	(defun RestoreCfgMenu (/ Cfg LstMenu)
		(setq LstMenu (LM:str->lst (vl-registry-read EasyCutRegistryPath$ "MenuCfg") "-"))
		(setq PrgApp$ 				(nth 0  LstMenu)
			  PrgImport$ 			(nth 1  LstMenu)
			  PrgSql$ 				(nth 2  LstMenu)
			  PrgSearch$ 			(nth 3  LstMenu)
			  PrgTrigger$			(nth 4  LstMenu)
			  PrgSetup$				(nth 5  LstMenu)
			  PrgSAndS$				(nth 6  LstMenu)
			  PrgTools$				(nth 7  LstMenu)
			  PrgReport$			(nth 8  LstMenu)
			  PrgNestingExpert$ 	(nth 9  LstMenu)
			  PrgNestingSimple$		(nth 10 LstMenu)
			  PrgNestingTools$		(nth 11 LstMenu)
			  PrgNestingBar$		(nth 12 LstMenu)
		)
	)
	;
	; Main
	;
	(setq DefaultMenuEasyCut$ MainMenu)
	(setq VarDwg (SaveVarDwg))
	(setvar "FILEDIA" 1)
	(gc)
	(DefVarDwg)
	(StartReactors nil)
	; Setup ++++++++++++++++
	(setq PopupSetup 		'(	"01\tMenu Setup" "02\tVisualizza Variabili" "03\tCarica Default Setup"))
	(setq MacroSetup 		'(	"01 GuiSetupEasyCut" "02 CheckVarEasyCut" "03 LoadDefaultSetup"))
	; Import - Export ++++++
	;(setq PopupImport 		'(	"01\tImporta formato Dstv" "02\tImporta formato Cam" "03\tImporta formato Xls" "04\tImporta formato Dxf" "05\tAggiorna Cartiglio Dxf"))
	;(setq MacroImport 		'(	"01 ImportShapeDstv" "02 ImportShapeCam" "03 ImportShapeXls" "04 ImportShapeDxf" "05 UpDateBomDxf"))
	(setq PopupImport 		'(	"01\tImporta formato Dstv" "02\tImporta formato Cam" "03\tImporta formato Xls" "04\tImporta formato Dxf"))
	(setq MacroImport 		'(	"01 ImportShapeDstv" "02 ImportShapeCam" "03 ImportShapeXls" "04 ImportShapeDxf"))
	(setq PopupSql 			'(	"01\tEsporta Controni SqLite" "02\tEsporta Lamiere SqLite" "03\tImporta Controni SqLite" "04\tImporta Lamiere SqLite"))
	(setq MacroSql 			'(	"01 ExportShapeToSql" "02 ExportSheetToSql" "03 ImportShapeFromSql" "04 ImportSheetFromSql"))
	; Search +++++++++++++++
	(setq PopupSearch 		'(	"01\tCerca Pezzi su Lamiere" "02\tCerca Pezzi Archivio"))
	(setq MacroSearch 		'(	"01 GuiFindShapeOnSheet" "02 GuiFindShape"))
	; Shape & Sheet ++++++++
	(setq PopupSAndS 		'(	"01\tGestione contorni"	"02\tForma"	"03\tInserisci lamiera"	"04\tInserisci stock lamiere" "05\tInfo dinamico"))
	(setq MacroSAndS 		'(	"01 ManagementShape" "02 TcEasyCut" "03 TsEasyCut" "04 CreateStockSheet" "05 DinamicInfo"))
	; Trigger ++++++++++++++
	(setq PopupTrigger 		'(	"01\tAttacco Manuale" 
								"02\tAttacco Automatico" 
								"03\tAttacco Lamiera"	
								"04\tElimina Attacco"
								"05\tCrea Micro"
								"06\tElimina Micro"
							))
	(setq MacroTrigger 		'(	"01 ManualTrigger" 
								"02 AutoTrigger" 
								"03 SheetTrigger" 
								"04 DeleteTrigger"
								"05 MakeMicro"
								"06 RemoveMicro"
							))
	; Tools ++++++++++++++++
	(setq PopupTools 		'(	"01\tInserisci contorno" "02\tTetrix"  "03\tSerie" "04\tFlessione"))
	(setq MacroTools 		'(	"01 FineTunning" "02 ToolMove"  "03 ArrayShape" "04 Flex"))
	; Nesting ++++++++++++++
	(setq PopupNestingExpert '(	"01\tNesting Expert" "02\tImporta Nesting"))
	(setq MacroNestingExpert '(	"01 ExpertNesting" "02 ImportNestingExpert"))

	(setq PopupNestingSimple '(	"01\tNesting Rettangoli" ))
	(setq MacroNestingSimple '(	"01 SimpleNesting"))

	(setq PopupNestingBar 	'(	"01\tNesting Barre" ))
	(setq MacroNestingBar 	'(	"01 NestingBar"))
	
	
	(setq PopupNestingTools '(	"01\tCalcolo Disponibilita' Lamiere" 
								"02\tSequenza Taglio" 
								"03\tPartProgamm Lamiera"
								"04\tPartProgamm Contorno"								
								"05\tSfrido"))
	(setq MacroNestingTools '(	"01 GuiAvailabilitySheet"
								"02 GuiSequenceCut"
								"03 PostProcessorSheet" 
								"04 PostProcessorShape" 
								"05 GuiScrapSheet"))

	(setq PopupReport 		'(	"01\tReport Utilizzo Lamiera"
								"02\tReport Sconto Nesting"
								"03\tReport Sconto Lamiera"
								"04\tReport Sconto Pezzi"
								"05\tReport Lamiera"
								"06\tGestione Report"
							))
	(setq MacroReport 		'(	"01 InfoCutSheet"
								"02 MergeNesting"
								"03 MergeSheet"
								"04 MergeShape"
								"05 ReportSheet"
								"06 ManagerReportSheet"
							))
	; Macro ++++++++++++++++
	(setq PopupApp 			'(	"01\tVersione Autocad"
								"02\tInfo Oggetti"
								"03\tInfo Ename"
								"04\tZoom Handle"
								"05\tSemplifica polilinea"
								"06\tSegmenti->Archi"
								"07\tInserisci vertice polilinea"
								"08\tVisualizza AcadDoc.lsp"
								"09\tRidimensiona Finestra Disegno" 
								"10\t\Codice a barre 39"
								"11\tCodice a barre 128"
								"12\tCrea stile dimensione"
								"13\tQuota automatica contorni"
								"14\tQuota Leader"
								"15\tEncript"
								"16\tReactor"
							))
	(setq MacroApp 			'(	"01 AcadVersion"
								"02 InfoObject"
								"03 InfoEname"
								"04 ZoomHandle"
								"05 LwPolySimple"
								"06 PolyLineMergeToArc"
								"07 AddVertexPolyline"
								"08 ShowAcadDoc"
								"09 ResizeWindowDrawing" 
								"10 Barcode39"
								"11 Barcode128"
								"12 DimensionStyle"
								"13 Dimension"
								"14 LeaderCoo"
								"15 Codex"
								"16 Reactor"
							))
				
	(if (= (vl-registry-read EasyCutRegistryPath$ "MenuCfg") "")
		(progn
			(SetCfgMenu)
			(SaveCfgMenu)
		)
		(RestoreCfgMenu)
	)
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "mainmenu" xx "" (cond ( *mainmenu* ) ( '(-1 -1) )))
	
	(start_list "PopupReport")			
		(mapcar 'add_list PopupReport)	
	(end_list)
	(start_list "PopupTools")			
		(mapcar 'add_list PopupTools)	
	(end_list)
	(start_list "PopupSAndS")			
		(mapcar 'add_list PopupSAndS)	
	(end_list)
	(start_list "PopupSetup")			
		(mapcar 'add_list PopupSetup)	
	(end_list)
	(start_list "PopupImport")			
		(mapcar 'add_list PopupImport)	
	(end_list)
	(start_list "PopupSql")			
		(mapcar 'add_list PopupSql)	
	(end_list)
	(start_list "PopupSearch")			
		(mapcar 'add_list PopupSearch)	
	(end_list)
	(start_list "PopupTrigger")			
		(mapcar 'add_list PopupTrigger)	
	(end_list)
	(start_list "PopupNestingExpert")			
		(mapcar 'add_list PopupNestingExpert)	
	(end_list)
	(start_list "PopupNestingSimple")			
		(mapcar 'add_list PopupNestingSimple)	
	(end_list)
	(start_list "PopupNestingTools")			
		(mapcar 'add_list PopupNestingTools)	
	(end_list)
	(start_list "PopupNestingBar")			
		(mapcar 'add_list PopupNestingBar)	
	(end_list)
	
	(start_list "PopupApp")			
		(mapcar 'add_list PopupApp)	
	(end_list)
	(set_tile "Version" VersionEasyCut$)

	(set_tile "PopupApp" 			PrgApp$)
	(set_tile "PopupImport" 		PrgImport$)
	(set_tile "PopupSql" 			PrgSql$)
	(set_tile "PopupSearch" 		PrgSearch$)
	(set_tile "PopupTrigger" 		PrgTrigger$)
	(set_tile "PopupSetup" 			PrgSetup$)
	(set_tile "PopupSAndS"			PrgSAndS$)
	(set_tile "PopupTools" 			PrgTools$)
	(set_tile "PopupReport" 		PrgReport$)
	(set_tile "PopupNestingExpert" 	PrgNestingExpert$)
	(set_tile "PopupNestingSimple" 	PrgNestingSimple$)
	(set_tile "PopupNestingTools" 	PrgNestingTools$)
	(set_tile "PopupNestingBar" 	PrgNestingBar$)
	
	
	(action_tile "PopupApp" 		  "(setq  CMacroApp T 			 PrgApp$     		(get_tile \"PopupApp\"    )		  *mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "PopupImport" 		  "(setq  CMacroImport  T 		 PrgImport$  		(get_tile \"PopupImport\" ) 	  *mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "PopupSql" 		  "(setq  CMacroSql T 			 PrgSql$     		(get_tile \"PopupSql\"    ) 	  *mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "PopupSearch" 		  "(setq  CMacroSearch  T 		 PrgSearch$  		(get_tile \"PopupSearch\" )	 	  *mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "PopupTrigger" 	  "(setq  CMacroTrigger T 		 PrgTrigger$ 		(get_tile \"PopupTrigger\")		  *mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "PopupSetup" 		  "(setq  CMacroSetup  T 		 PrgSetup$   		(get_tile \"PopupSetup\"  )		  *mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "PopupSAndS"		  "(setq  CMacroSAndS  T 		 PrgSAndS$   		(get_tile \"PopupSAndS\"  ) 	  *mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "PopupTools" 		  "(setq  CMacroTools  T 		 PrgTools$   		(get_tile \"PopupTools\"  )		  *mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "PopupReport" 		  "(setq  CMacroReport T 		 PrgReport$  		(get_tile \"PopupReport\" )		  *mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "PopupNestingExpert" "(setq  CMacroNestingExpert T  PrgNestingExpert$ 	(get_tile \"PopupNestingExpert\") *mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "PopupNestingSimple" "(setq  CMacroNestingSimple T  PrgNestingSimple$ 	(get_tile \"PopupNestingSimple\") *mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "PopupNestingBar" 	  "(setq  CMacroNestingBar T     PrgNestingBar$ 	(get_tile \"PopupNestingBar\")    *mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "PopupNestingTools"  "(setq  CMacroNestingTools T 	 PrgNestingTools$  	(get_tile \"PopupNestingTools\")  *mainmenu* (done_dialog)) (unload_dialog xx) ")

	(action_tile "AttachApp" 	 		"(setq  CMacroApp T 			*mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "AttachImport"  		"(setq  CMacroImport  T			*mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "AttachSql" 	 		"(setq  CMacroSql T 			*mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "AttachSearch"  		"(setq  CMacroSearch  T			*mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "AttachTrigger" 		"(setq  CMacroTrigger T 		*mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "AttachSetup" 	 		"(setq  CMacroSetup  T 			*mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "AttachSAndS"	 		"(setq  CMacroSAndS  T 			*mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "AttachTools" 	 		"(setq  CMacroTools  T 			*mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "AttachReport"  		"(setq  CMacroReport T 			*mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "AttachNestingExpert" 	"(setq  CMacroNestingExpert  T 	*mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "AttachNestingSimple" 	"(setq  CMacroNestingSimple T	*mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "AttachNestingBar" 	"(setq  CMacroNestingBar 	T	*mainmenu* (done_dialog)) (unload_dialog xx) ")
	(action_tile "AttachNestingTools"  	"(setq  CMacroNestingTools T	*mainmenu* (done_dialog)) (unload_dialog xx) ")

	(action_tile "accept"   	"(setq *mainmenu* (done_dialog)) (unload_dialog xx)")

	(start_dialog)
	(cond
		((= CMacroApp T)		   (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgApp$) 		   MacroApp) 		  	" ")) ")"))))
		((= CMacroImport T)		   (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgImport$) 	   MacroImport) 		" ")) ")"))))
		((= CMacroSql T)		   (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgSql$) 		   MacroSql) 		  	" ")) ")"))))
		((= CMacroSearch T)		   (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgSearch$) 	   MacroSearch) 		" ")) ")"))))
		((= CMacroTrigger T)	   (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgTrigger$) 	   MacroTrigger) 	  	" ")) ")"))))
		((= CMacroSetup T)		   (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgSetup$) 		   MacroSetup) 		 	" ")) ")"))))
		((= CMacroSAndS T)		   (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgSAndS$) 		   MacroSAndS) 		 	" ")) ")"))))
		((= CMacroTools T)		   (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgTools$) 		   MacroTools) 		 	" ")) ")"))))
		((= CMacroReport T)		   (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgReport$) 	   MacroReport) 		" ")) ")"))))
		((= CMacroNestingExpert T) (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgNestingExpert$) MacroNestingExpert) 	" ")) ")"))))
		((= CMacroNestingSimple T) (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgNestingSimple$) MacroNestingSimple) 	" ")) ")"))))
		((= CMacroNestingTools T)  (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgNestingTools$)  MacroNestingTools)  	" ")) ")"))))
		((= CMacroNestingBar T)    (SaveCfgMenu) (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgNestingBar$)    MacroNestingBar) 	" ")) ")"))))
	)
	(ResVarDwg VarDwg)
	(princ)
)
;
;
;