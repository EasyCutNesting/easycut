(defun GuiNesting (/ GetSelectShape GetSelectSheet RestoreFile EditFile 
					 LstSheetSimple LstSheetExpert
					 LstShapeSimple LstShapeExpert
					 NestingSimple NestingExpert ImportExpert xx)


	(defun GetSelectShape (OutFile Key TypeQuantity / Rtn)
		(cond
			((= TypeQuantity "1")
				(setq Rtn (GuiSelPiecesShape (GetTableStockDeductShapeNesting) OutFile))
			)
			((= TypeQuantity "0")
				(setq Rtn (GuiSelPiecesShape (GetTableStockShapeNesting)       OutFile))
			)
		)
		(if (car Rtn) 
			(set_tile  Key	(car Rtn)) 
			(set_tile  Key	"")
		)
	)
	;
	(defun GetSelectSheet (OutFile Key / Rtn)
		(setq Rtn (GuiSelPiecesSheet (GetTableStockSheetNesting 1) OutFile))
		(if (car Rtn) 
			(set_tile  Key	(car Rtn)) 
			(set_tile  Key	"")
		)
	)
	;
	(defun RestoreFile (Key Ext / Rtn)
		(setq Rtn (LM:getfiles "Seleziona file Sheet" DxfNestingEasyCut$ Ext))
		(if Rtn 
			(set_tile  Key	(car Rtn)) 
			(set_tile  Key	"")
		)
	)
	;
	(defun EditFile (Key / Rtn)
		(if (/= (setq Rtn (get_tile  Key)) "")
			(startapp "notepad" Rtn)
			(alert "Nessun file selezionato")
		)
	)
	;
	(setq FileSaveShapeSimple$ (strcat DxfNestingEasyCut$ "StdShapeSimple.shp"))
	(setq FileSaveSheetSimple$ (strcat DxfNestingEasyCut$ "StdSheetSimple.sht"))
	(setq FileSaveShapeExpert$ (strcat DxfNestingEasyCut$ "StdShapeExpert.shp"))
	(setq FileSaveSheetExpert$ (strcat DxfNestingEasyCut$ "StdSheetExpert.sht"))

	(if (not CalcQtyS$)
		(setq CalcQtyS$ "1")
	)
	(if (not CalcQtyE$)
		(setq CalcQtyE$ "1")
	)
	;
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "NestingDialog" xx "" (cond ( *NestingDialog* ) ( '(-1 -1) )))

	(set_tile  "DeductShapeSimple"	CalcQtyS$)
	(set_tile  "DeductShapeExpert"	CalcQtyE$)
	
	(action_tile "DeductShapeSimple"	"(setq CalcQtyS$ (get_tile \"DeductShapeSimple\"))")
	(action_tile "DeductShapeExpert"	"(setq CalcQtyE$ (get_tile \"DeductShapeExpert\"))")
	(action_tile "SelectShapeSimple" 	"(GetSelectShape FileSaveShapeSimple$ \"FileSelectShapeSimple\" CalcQtyS$)")
	(action_tile "SelectShapeExpert" 	"(GetSelectShape FileSaveShapeExpert$ \"FileSelectShapeExpert\" CalcQtyE$)")
	(action_tile "SelectSheetSimple" 	"(GetSelectSheet FileSaveSheetSimple$ \"FileSelectSheetSimple\")")
	(action_tile "SelectSheetExpert" 	"(GetSelectSheet FileSaveSheetExpert$ \"FileSelectSheetExpert\")")
	(action_tile "RestoreShapeSimple"	"(RestoreFile \"FileSelectShapeSimple\" \"shp\")")
	(action_tile "RestoreShapeExpert"	"(RestoreFile \"FileSelectShapeExpert\" \"shp\")")
	(action_tile "RestoreSheetSimple"	"(RestoreFile \"FileSelectSheetSimple\" \"sht\")")
	(action_tile "RestoreSheetExpert"	"(RestoreFile \"FileSelectSheetExpert\" \"sht\")")
	(action_tile "EditShapeSimple"		"(EditFile \"FileSelectShapeSimple\")")
	(action_tile "EditShapeExpert"		"(EditFile \"FileSelectShapeExpert\")")
	(action_tile "EditSheetSimple"		"(EditFile \"FileSelectSheetSimple\")")
	(action_tile "EditSheetExpert"		"(EditFile \"FileSelectSheetExpert\")")
	(action_tile "AvailabilitySimple"	"(AvailabilityNesting (get_tile \"FileSelectShapeSimple\") (get_tile \"FileSelectSheetSimple\") nil)")
	(action_tile "AvailabilityExpert"	"(AvailabilityNesting (get_tile \"FileSelectShapeExpert\") (get_tile \"FileSelectSheetExpert\") nil)")
	(action_tile "MergeSimple"			"(MergeNesting (get_tile \"FileSelectShapeSimple\") (get_tile \"FileSelectSheetSimple\"))")
	(action_tile "MergeExpert"			"(MergeNesting (get_tile \"FileSelectShapeSimple\") (get_tile \"FileSelectSheetSimple\"))")
													  
	(action_tile "NestingSimple" 		(strcat "(setq 	NestingSimple T  
														LstSheetSimple (ReadFileNesting (get_tile \"FileSelectSheetSimple\") \" \")
														LstShapeSimple (ReadFileNesting (get_tile \"FileSelectShapeSimple\") \" \")
														*NestingDialog* (done_dialog)) (unload_dialog xx)"))

	(action_tile "NestingExpert"		(strcat "(setq 	NestingExpert T  
														LstSheetExpert (ReadFileNesting (get_tile \"FileSelectSheetExpert\") \" \")
														LstShapeExpert (ReadFileNesting (get_tile \"FileSelectShapeExpert\") \" \")
														*NestingDialog* (done_dialog)) (unload_dialog xx)"))
		
	(action_tile "ImportExpert"			(strcat "(setq 	ImportExpert T *NestingDialog* (done_dialog)) (unload_dialog xx)"))
	(action_tile "cancel"				(strcat "(setq  *NestingDialog* (done_dialog)) (unload_dialog xx)"))
	(start_dialog)
		
	(cond
		((= NestingSimple T)
			(CreateNestingSimple (cdr LstSheetSimple) (cdr LstShapeSimple))
		)
		((= NestingExpert T)
			(CreateNestingExpert (cdr LstSheetExpert) (cdr LstShapeExpert))
		)
		((= ImportExpert T)
			(ImportDxfFileNesting)
		)
	)
)