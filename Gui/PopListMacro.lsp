;
; Pop List menu ++
;
; Setup ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(defun c:PopListGuiSetupEasyCut ()
	(GuiSetupEasyCut)
)
;
(defun c:PopListCheckVarEasyCut ()
	(CheckVarEasyCut)
)
;
(defun c:PopListLoadDefaultSetup (/ PathEasyCut FileEasyCut)
	(LoadDefaultSetup)
	(setq PathEasyCut 		(vl-registry-read EasyCutRegistryPath$ "DefaultPathCfg"))
	(setq FileEasyCut 		(vl-registry-read EasyCutRegistryPath$ "DefaultFileCfg"))
	(setq NameConfigurationEasyCut$ (strcat PathEasyCut "\\" FileEasyCut))
	(SaveSetupEasyCut (strcat PathEasyCut "\\" FileEasyCut) "\nconfigurazione salvata        -> ")
	(vl-registry-write EasyCutRegistryPath$ "PathCfg" PathEasyCut)
	(vl-registry-write EasyCutRegistryPath$ "FileCfg" FileEasyCut)
)
; Import - Export +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(defun c:PopListImportShapeDstv ()
	(MyPurge '("BLOCK" "GROUP"))
	(if (IsModelSpace)
		(ImportShapeDstv)
		(LM:popup "avvertimento" "[ImportShapeDstv] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)	
)
;
(defun c:PopListImportShapeCam ()
	(MyPurge '("BLOCK" "GROUP"))
	(if (IsModelSpace)
		(ImportShapeCam)
		(LM:popup "avvertimento" "[ImportShapeCam] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)
)
;
(defun c:PopListImportShapeXls ()
	(MyPurge '("BLOCK" "GROUP"))
	(if (IsModelSpace)
		(ImportShapeXls)
		(LM:popup "avvertimento" "[ImportShapeXls] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)
)
;
(defun c:PopListImportShapeDxf ()
	(MyPurge '("BLOCK" "GROUP"))
	(if (IsModelSpace)
		(ImportShapeDxf)
		(LM:popup "avvertimento" "[ImportShapeDxf] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)
)
;
;(defun c:PopListUpdateBomDxf ()
;	(MyPurge '("BLOCK" "GROUP"))
;	(UpdateShapeDxf)
;)
;
(defun c:PopListExportShapeToSql ()
	(MyPurge '("BLOCK" "GROUP"))
	(ExportShapeToSql)
)
;
(defun c:PopListExportSheetToSql ()
	(MyPurge '("BLOCK" "GROUP"))
	(ExportSheetToSql)
)
;
(defun c:PopListImportShapeFromSql ()
	(MyPurge '("BLOCK" "GROUP"))
	(if (IsModelSpace)
		(ImportShapeFromSql)
		(LM:popup "avvertimento" "[ImportShapeFromSql] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)
)
;
(defun c:PopListImportSheetFromSql ()
	(MyPurge '("BLOCK" "GROUP"))
	(if (IsModelSpace)
		(ImportSheetFromSql)
		(LM:popup "avvertimento" "[ImportSheetFromSql] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)
)
; Search ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(defun c:PopListGuiFindShapeOnSheet (/ *error*)
	(defun *error* (msg)
		(princ boo)
	)
	(GoToModelLayout)
	(GuiFindShapeOnSheet)
	(alert "Ricerca terminata")
	(quit)
)
;
(defun c:PopListGuiFindShape (/ *error*)
	(defun *error* (msg)
		(princ boo)
	)
	(GoToModelLayout)
	(GuiFindShape)
	(alert "Ricerca terminata")
	(quit)
)
; Shape & Sheet +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(defun c:PopListManagementShape (/ CalcQtyDeduct)

	(setq NameHeadDcl$ "Lista pezzi")
	(if (and (/= CalcQtyDeduct$ "1") (/= CalcQtyDeduct$ "0")) (setq CalcQtyDeduct$ "1"))

	(setq CalcQtyDeduct CalcQtyDeduct$)
	(setq CalcQtyDeduct$ "-1")
	(GuiSelPiecesShapeReduce (GetTableStockShapeNesting))
	(setq CalcQtyDeduct$ CalcQtyDeduct)
)
;
(defun c:PopListTcEasyCut ()
	(if (IsModelSpace)
		(TcEasyCut nil)
		(LM:popup "avvertimento" "[TecnoShape] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListTsEasyCut ()
	(if (IsModelSpace)
		(TsEasyCut)
		(LM:popup "avvertimento" "[TecnoSheet] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListCreateStockSheet ()
	(if (IsModelSpace)
		(CreateStockSheet)
		(LM:popup "avvertimento" "[CreateStockSheet] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListDinamicInfo ()
	(if (IsModelSpace)
		(DinamicInfo)
		(LM:popup "avvertimento" "[DinamicInfo] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
; Trigger ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(defun c:PopListManualTrigger (/ Loop)
	(setq Loop T)
	(if (IsModelSpace)
		(while Loop	
			(ManualTrigger)
		)
		(LM:popup "avvertimento" "[ManualTrigger] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListAutoTrigger (/ Loop)
	(setq Loop T)
	(if (IsModelSpace)
		(while Loop	
			(AutoTrigger)
		)
		(LM:popup "avvertimento" "[AutoTrigger] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListSheetTrigger (/ Loop)
	(setq Loop T)
	(if (IsModelSpace)
		(while Loop 
			(SheetTrigger)
		)
		(LM:popup "avvertimento" "[SheetTrigger] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListDeleteTrigger()
	(if (IsModelSpace)
		(while (DeleteTrigger))
		(LM:popup "avvertimento" "[DeleteTrigger] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListMakeMicro ()
	(if (IsModelSpace)
		(GuiMakeMicro)
		(LM:popup "avvertimento" "[MakeMicro] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListRemoveMicro ()
	(if (IsModelSpace)
		(GuiRemoveMicro)
		(LM:popup "avvertimento" "[RemoveMICRO] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
; Tools ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(defun c:PopListToolMove ()
	(if (IsModelSpace)
		(ToolMove)
		(LM:popup "avvertimento" "[ToolMove] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListFineTunning ()
	(if (IsModelSpace)
		(FineTunning)
		(LM:popup "avvertimento" "[FineTunning] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListArrayShape ()
	(if (IsModelSpace)
		(ArrayShape)
		(LM:popup "avvertimento" "[ArrayShape] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListFlex ()
	(if (IsModelSpace)
		(GuiFlex)
		(LM:popup "avvertimento" "[ListFlex] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
; Nesting ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun c:PopListExpertNesting (/ LstFile *FuntionCall*)

	(if (IsModelSpace)
		(progn
			(if (and (/= CalcQtyDeduct$ "1") (/= CalcQtyDeduct$ "0")) (setq CalcQtyDeduct$ "1"))
			(setq *FuntionCall* "c:PopListExpertNesting")
			(if (setq LstFile (GuiNesting (strcat DxfNestingEasyCut$ "StdShapeExpert.shp")
										  (strcat DxfNestingEasyCut$ "StdSheetExpert.sht") 1))
				(progn
					(DeletedHatchEasyCut)
					; **************************************************************************************
					(setq PathWorkDxfNest$ (strcat (getenv "USERPROFILE") "\\EasyCut\\Output\\Nesting"))
					(if (not (vl-file-directory-p PathWorkDxfNest$)) (vl-mkdir PathWorkDxfNest$))
					(if (not (vl-registry-read EasyCutRegistryPath$ "SettingDxfNest"))
						(vl-registry-write EasyCutRegistryPath$ "SettingDxfNest" (strcat PathWorkDxfNest$ "\\" ECFileSetupExpertNesting$))
					)
					(DxfNest:CreateNestingExpert 	(cdr (ReadFileNesting (car  LstFile) ";")) 
													(cdr (ReadFileNesting (cadr LstFile) ";"))
													(strcat PathWorkDxfNest$ "\\DxfNestShape.txt")
													(strcat PathWorkDxfNest$ "\\DxfNestSheet.txt")
													(strcat PathWorkDxfNest$ "\\" ECFileSetupExpertNesting$))
				    ; **************************************************************************************
					(vla-Regen (vla-get-activedocument (vlax-get-acad-object)) acAllViewports)
					(MergeNesting 	(cdr (ReadFileNesting (car  LstFile) ";"))
									(cdr (ReadFileNesting (cadr LstFile) ";")))
				)
			)
		)
		(LM:popup "avvertimento" "[ExpertNesting] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
; 
(defun c:PopListSimpleNesting (/ LstFile *FuntionCall*)

	(if (IsModelSpace)
		(progn
			(if (and (/= CalcQtyDeduct$ "1") (/= CalcQtyDeduct$ "0")) (setq CalcQtyDeduct$ "1"))
			(setq *FuntionCall* "c:PopListSimpleNesting")
			(if (setq LstFile (GuiNesting (strcat DxfNestingEasyCut$ "StdShapeSample.shp")
										  (strcat DxfNestingEasyCut$ "StdSheetSample.sht") 2))
				(progn
					(DeletedHatchEasyCut)
					; **************************************************************************************
					(CreateNestingSimple (cdr (ReadFileNesting (car  LstFile) ";"))
										 (cdr (ReadFileNesting (cadr LstFile) ";")))
					; **************************************************************************************
					(vla-Regen (vla-get-activedocument (vlax-get-acad-object)) acAllViewports)
					(MergeNesting 	(cdr (ReadFileNesting (car  LstFile) ";"))
									(cdr (ReadFileNesting (cadr LstFile) ";")))
				)
			)
		)
		(LM:popup "avvertimento" "[SimpleNesting] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)	
;
(defun c:PopListRectPackNesting (/ LstFile *FuntionCall*)

	(if (IsModelSpace)
		(progn
			(if (and (/= CalcQtyDeduct$ "1") (/= CalcQtyDeduct$ "0")) (setq CalcQtyDeduct$ "1"))
			(setq *FuntionCall* "c:PopListRectPackNesting")
			(if (setq LstFile (GuiNesting (strcat DxfNestingEasyCut$ "StdShapeExpert.shp")
										  (strcat DxfNestingEasyCut$ "StdSheetExpert.sht") 1))
				(progn
					(DeletedHatchEasyCut)
					; **************************************************************************************
					(setq PathWorkDxfNest$ (strcat (getenv "USERPROFILE") "\\EasyCut\\Output\\Nesting"))
					(if (not (vl-file-directory-p PathWorkDxfNest$)) (vl-mkdir PathWorkDxfNest$))
					(if (not (vl-registry-read EasyCutRegistryPath$ "SettingRectPack"))
						(vl-registry-write EasyCutRegistryPath$ "SettingRectPack" (strcat PathWorkDxfNest$ "\\" ECFileSetupRectPackNesting$))
					)
					(RectPAck:CreateNesting 	(cdr (ReadFileNesting (car  LstFile) ";")) 
												(cdr (ReadFileNesting (cadr LstFile) ";"))
												(strcat PathWorkDxfNest$ "\\RectPackShape.xml")
												(strcat PathWorkDxfNest$ "\\RectPackSheet.xml")
												(strcat PathWorkDxfNest$ "\\" ECFileSetupRectPackNesting$))
				    ; **************************************************************************************
					(vla-Regen (vla-get-activedocument (vlax-get-acad-object)) acAllViewports)
					(MergeNesting 	(cdr (ReadFileNesting (car  LstFile) ";"))
									(cdr (ReadFileNesting (cadr LstFile) ";")))
				)
			)
		)
		(LM:popup "avvertimento" "[RectPack:Nesting] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)	
;
(defun c:PopListNestingBar (/ LstFile)
	(if (IsModelSpace)
		(GuiSelPiecesParts)
		(LM:popup "avvertimento" "[NestingBar] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListGuiAvailabilitySheet (/ LstFile)


	(if (setq LstFile (GuiAvailabilitySheet (strcat DxfNestingEasyCut$ "StdShape.shp")
											(strcat DxfNestingEasyCut$ "StdSheet.sht")
					   ))
		(progn
			(AvailabilitySheet (cdr (ReadFileNesting (car  LstFile) ";"))
							   (cdr (ReadFileNesting (cadr LstFile) ";"))	T)
			(vl-file-delete (car  LstFile))
			(vl-file-delete (cadr LstFile))
		)
	)
)
;
(defun c:PopListGuiSequenceCut ()
	(if (IsModelSpace)
		(GuiSequenceCut)
		(LM:popup "avvertimento" "[SequenceCut] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListPostProcessorSheet ()
	(if (IsModelSpace)
		(PostProcessorSheetGui)
		(LM:popup "avvertimento" "[PostProcessorSheet] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListPostProcessorShape ()
	(if (IsModelSpace)
		(PostProcessorShapeGui)
		(LM:popup "avvertimento" "[PostProcessorShape] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListGuiScrapSheet ()
	(if (IsModelSpace)
		(GuiScrapSheet)
		(LM:popup "avvertimento" "[ScrapSheet] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListInfoCutSheet ()
	(if (IsModelSpace)
		(InfoCutSheet)
		(LM:popup "avvertimento" "[InfoCutSheet] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListMergeNesting (/ LstSheet)
	(if (setq LstFile (GuiMergeNesting))
		(MergeNesting (cdr (ReadFileNesting (car  LstFile) ";"))
					  (cdr (ReadFileNesting (cadr LstFile) ";")))
	)
)
;
(defun c:PopListMergeSheet (/ Ssel itm EnameSheet StorageSheet)
	
	(if (IsModelSpace)
		(progn
			(prompt "\nSeleziona la lamiera")
			(setq Ssel (ssget (list (list -3 (list (strcat $RgpSheet "," $RgpSheetTarget))))))
			(foreach itm (LM:ss->ent Ssel)
				(setq EnameSheet (GetEnameSheetByDummyEname itm))
				(if (not (member EnameSheet StorageSheet))
					(setq StorageSheet (append StorageSheet (list EnameSheet)))
				)
			)
			(if Ssel (MergeSheet StorageSheet))
		)
		(LM:popup "avvertimento" "[MergeSheet] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListMergeShape (/ LstSheet)
	(if (IsModelSpace)
		(MergeShape)
		(LM:popup "avvertimento" "[MergeShape] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListReportSheet ()
	(if (IsModelSpace)
		(ReportSheet)
		(LM:popup "avvertimento" "[ReportSheet] va eseguito nel MODELSPACE" (+ 0 64 4096))
	)		
)
;
(defun c:PopListManagerReportSheet ()
	(ManagerReportSheet)
)
; Macro ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(defun c:PopListAcadVersion (/ Os AutocadRegistry AutocadBit PlatformBit AutocadVersion 
							 AutocadSubVersion AutolispVersion Language Release ProductName SerialNumber)
	
	(setq AutocadRegistry "HKEY_CURRENT_USER\\Software\\Autodesk\\AutoCAD")
	
	(setq Os (vl-registry-read "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion" "ProductName"))
	(if Acad64Bit-platform
		(setq PlatformBit "Processore 64 Bit")
		(setq PlatformBit "Processore 32 Bit")
	)
	(if Acad64Bit-version
		(setq AutocadBit "64 Bit")
		(setq AutocadBit "32 Bit")
	)

	(setq AutocadVersion    (vl-registry-read AutocadRegistry "CurVer"))
	(setq AutocadSubVersion (vl-registry-read (strcat AutocadRegistry "\\" AutocadVersion) "CurVer"))
	
	(setq AutolispVersion	(ver))
	(setq Language 			(vl-registry-read (strcat "HKEY_LOCAL_MACHINE\\" (vlax-product-key)) "Language"))
	(setq Release 			(vl-registry-read (strcat "HKEY_LOCAL_MACHINE\\" (vlax-product-key)) "Release"))
	(setq ProductName		(vl-registry-read (strcat "HKEY_LOCAL_MACHINE\\" (vlax-product-key)) "ProductName"))
	(setq SerialNumber		(getvar "_PKSER"))
	
	(alert (strcat	"Sistema operativo\t\t"		Os					"\n"
					"Piattaforma\t\t"			PlatformBit 		"\n" 
					"Autocad\t\t\t"  			AutocadBit 			"\n"
					"Versione Autocad\t\t"		AutocadVersion 		"\n" 
					"SubVersione Autocad\t"		AutocadSubVersion 	"\n"
					"Versione Autolisp\t\t"		AutolispVersion 	"\n"
					"Linguaggio Autocad\t"		Language 			"\n"
					"Release\t\t\t"				Release 			"\n"
					"Nome Prodotto\t\t"			ProductName 		"\n"
					"SerialNumber\t\t"			SerialNumber 		"\n"))
	(princ (strcat	"*********************************************\n"
					"Sistema operativo\["	Os					"]\n"
					"Piattaforma["			PlatformBit 		"]\n" 
					"Autocad[" 				AutocadBit 			"]\n"
					"Versione Autocad["		AutocadVersion 		"]\n" 
					"SubVersione Autocad["	AutocadSubVersion 	"]\n"
					"Versione Autolisp["	AutolispVersion 	"]\n"
					"Linguaggio Autocad["	Language 			"]\n"
					"Release["				Release 			"]\n"
					"Nome Prodotto["		ProductName 		"]\n"
					"SerialNumber["			SerialNumber 		"]\n"
					"*********************************************\n"))
	(princ)

)
;
(defun c:PopListInfoObject ()
	(DmpObject)
)
;
(defun c:PopListInfoEname ()
	(princ (DmpEname))
)
;
(defun c:PopListZoomHandle (/ NameHandle Rtn)
	(if (setq NameHandle (getstring "\nNome Handle "))
		(if (setq Rtn (ZoomHandle NameHandle))
			(sssetfirst nil (LstEname->Ssget (list Rtn)))
			(alert "Entita' non trovata")
		)
	)
)
;
(defun c:PopListLwPolySimple ()
	(GuiLwPolySimple)
)
;
(defun c:PopListPolyLineMergeToArc ()
	(PolyMergeArc)
)
;
(defun c:PopListAddVertexPolyline ()
	(GuiMakeVertexPolyLine)
)
;
(defun c:PopListUpGradeGroup ()
	(UpGradeGroup T)
)
;
(defun c:PopListShowAcadDoc ()
	(if (setq FileName (findfile "AcadDoc.lsp"))
		(EasyCutViewer FileName)
	)
)
;
(defun c:PopListResizeWindowDrawing (/ HSize WSize)
	(setq HSize (getint "\nAltezza Window...."))
	(setq WSize (getint "\nLarghezza Window.."))
	(if (and HSize WSize)
		(ResizeWindowDrawing HSize WSize)
	)
)
;
(defun c:PopListBarcode39 ()
	(Barcode39)
)
;
(defun c:PopListBarcode128 ()
	(Barcode128)
)
;
(defun c:PopListDimensionStyle ()
	(GuiStyleDimension)
)
;
(defun c:PopListDimension ()
	(RestoreUcs	UcsActEasyCut$)
	(GuiDimensionTools1)
)
;
(defun c:PopListLeaderCoo ()
	(RestoreUcs	UcsActEasyCut$)
	(LeaderCoo)
)
;
(defun c:PopListCodex ()
	(GuiCodeX)
)
;
(defun c:PopListReactor (/ itm Rtn)
	(setq Rtn "")
	(foreach itm (vlr-reactors)
		(setq Rtn (strcat Rtn "\n" (vl-prin1-to-string itm)))
	)
	(if (= Rtn "")
		(LM:popup "Reactors" Rtn (+ 0 16 4096))
		(LM:popup "Reactors" Rtn (+ 0 64 4096))
	)
)
;
;
;

