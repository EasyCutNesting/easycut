; ----------------------------------------------------------------------------------------------
;                   	min val 
;						   V
;(setq DistColumn$ 	(list 760 1000 1500 2000 3000 4000 5000 6000 7000 8000 9000 10000 11000 12000 13000 14000 15000 16000 17000 18000 19000 20000))
(setq DistColumn$ 	(list 1200 1500 2000 3000 4000 5000 6000 7000 8000 9000 10000 11000 12000 13000 14000 15000 16000 17000 18000 19000 20000))
(setq DistRow$    	(list 540  800 1000 1500 2000 3000 4000 5000 6000 7000 8000  9000 10000 11000 12000 13000 14000 15000 16000 17000 18000 19000 20000))
(setq HBom$			300.0)
;(setq PosLogo$    	(list 540.0 47.0))
;(setq PosBarCode$ 	(list 540.0 80.0))
(setq PosLogo$    	(list 890.0 47.0))
(setq PosBarCode$ 	(list 890.0 80.0))
;
;
;(setq DimBom$ 	 	(list 720 271))
;(setq PosBom$     	(list 0.0 -10.0))
(setq MaxColumn$ 	10)
(setq MargColumn$   (list 20.0 40.0))
;
;
;
(defun ImportShapeDstv (/ OpenFileLogDstv LstOnlyPlate LstPtInsert Ssel MinMaxSsel MinCatch MaxCatch itm LstDataSahpe FileName LstHead Conta Rtn)

	(defun OpenFileLogDstv (FileName / StreamLog)
		(if FileName
			(progn
				(if (not (setq StreamLog (open FileName "w")))
					(progn
						(alert (strcat "[OpenFileLogDstv] Impossibile creare file di Log " FileName))
						(exit)
					)
				)
			)
		)
		StreamLog 
	)
	;
	;
	(setq StreamLog$   (OpenFileLogDstv (strcat InfoPathEasyCut$ "log.txt")))
	(princ (strcat (today) "  " (time)) StreamLog$)
	(princ "\n--> [ImportShapeDstv]" StreamLog$)


	(setq LstOnlyPlate (GetLstFileDstv))
	(if (and LstOnlyPlate)
		(progn
			(princ "\n" StreamLog$)
			(princ "\n--> Controllo contorni  [ImportShapeDstv]" StreamLog$)
			(princ "\n" StreamLog$)
			
			(setq Conta 0)
			(foreach itm LstOnlyPlate
				
				(setq Conta (1+ Conta)) (princ (strcat "\nFile letto " itm " " (rtos Conta 2 0)))
				
				(setq LstDataSahpe (car (DstvReadFile itm nil T)))
				
				
				;(nth 0  LstHead) ->  IdOrder          	"C8722
				;(nth 1  LstHead) ->  IdDrawing         "171-110"
				;(nth 2  LstHead) ->  IdPhase        	"100"
				;(nth 3  LstHead) ->  IdIdentification 	"011124"
				;(nth 4  LstHead) ->  IdQuality        	"S355J2"
				;(nth 5  LstHead) ->  IdQuantity        "1"
				;(nth 6  LstHead) ->  IdProfile         "PL1540*15"
				;(nth 7  LstHead) ->  IdCode            "B"
				;(nth 8  LstHead) ->  IdLength          "1183.50
				;(nth 9  LstHead) ->  IdHeigth          "1540.00"
				;(nth 10 LstHead) ->  IdThicknes        "15.00"
				;(nth 11 LstHead) ->  IdWeightmt        "64.25"
				;(nth 12 LstHead) ->  IdSurface         "1.13"
				;(nth 13 LstHead) ->  IdName	        "PIATTO"
				
				
				(setq FileName 			itm)
				(setq FolderShape$ 		(vl-filename-directory itm))
				(setq ExtensionShape$ 	(vl-filename-extension itm))

				(setq LstHead (append LstHead (list (list 	FileName							;->  IdShape
															(nth 0  LstDataSahpe) 				;->  IdOrder
															(nth 2  LstDataSahpe) 				;->  IdPhase
															(nth 3  LstDataSahpe) 				;->  IdIdentification
															(nth 5  LstDataSahpe) 				;->  IdQuantity
															(nth 10 LstDataSahpe) 				;->  IdThicknes
															(nth 8  LstDataSahpe) 				;->  IdLength
															(nth 9  LstDataSahpe) 				;->  IdHeigth
															(strcase (nth 4  LstDataSahpe)) 	;->  IdQuality
															))))
															;(today)))))
				
			)
			(setq NameHeadDcl$ "Lista Import file DSTV")
			(setq Rtn (GuiSelPiecesShapeImport (SortTable LstHead '(0 1 2 3 0 0 0 0 0) "<")))
			(if Rtn
				(progn
					(alert (strcat "n^ " (rtos (length Rtn) 2 0) " piatti selezionati"))
					(setq LstPtInsert  (PreviewNesting Rtn))
					(setq Ssel (NestingShapeNC Rtn LstPtInsert))
					(if (and Ssel (> (sslength Ssel) 0))
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
			)
		)
	)
	(close StreamLog$)
	(EasyCutViewer (strcat InfoPathEasyCut$ "log.txt"))
	(setq StreamLog$ nil)
	(princ)
)
;
;
;
(defun ShowDstv (LstFile / i LstFilePreview itm FileShape Rtn CamFile DstvFile ExtensionShape FolderTmp)

	(setq CamFile  (list (strcase ".CAM")))
	(setq DstvFile (list (strcase ".NC") (strcase ".NC1")))

	(if LstFile
		(progn
			(StartProgressBar "Working:" (length LstOnlyPlate))
			(setq LstFilePreview (vl-directory-files (strcat HtmlStorageEasyCut$ ECFolderShapePreview$) (strcat ECFileShape$ "_*.html") 1))
			(foreach itm LstFilePreview
				(vl-file-delete (strcat HtmlStorageEasyCut$ ECFolderShapePreview$ itm))
			)
			(foreach itm LstFile
				(setq FileShape (strcat HtmlStorageEasyCut$ ECFolderShapePreview$ ECFileShape$ "_" (Random_Str 9) ".html"))
				(princ (strcat "\n" itm))
				
				(setq ExtensionShape (vl-filename-extension itm))
				
				(if (member (strcase ExtensionShape) CamFile)
					(progn
						(setq FolderTmp (strcat SetupPathEasyCut$ "Tmp"))
						(Cam2Dstv itm  (strcat FolderTmp "\\" (vl-filename-base itm) ".nc"))
						(DstvToGraphicCanvas (strcat FolderTmp "\\" (vl-filename-base itm) ".nc") FileShape)
					)
				)
				
				(if (member (strcase ExtensionShape) DstvFile)
						(DstvToGraphicCanvas itm FileShape)
				)
				(UpDateProgressBar)
			)
			(ClearProgressBar)
			(setq Rtn (UpdatePreviewShapeHtml))
			(if (findfile Rtn)
				(DefaultBrowser Rtn)
			)
		)
	)
)
;
;
;
(defun ListDstv (LstDataDstv / Sep conta FileOut Stream itm tm1 SplitLstDataDstv)
	
	;(princ LstDataDst)
	
	(if LstDataDstv
		(progn
			(setq Sep $DivideCsv)
			(setq conta 1)
			(setq FileOut 	(strcat HtmlStorageEasyCut$ ECFolderShapePreview$ "list.txt"))
			(setq Stream 	(open FileOut "w"))
			(princ (strcat 	"Itm" 	Sep 
							"File" 	Sep 
							"Order" Sep 
							"Phase" Sep 
							"Mark" 	Sep 
							"Qua" 	Sep 
							"Thik" 	Sep 
							"Length" Sep 
							"Height" Sep 
							"Mat\n") Stream)
			
			(foreach itm LstDataDstv
				;(princ itm) (terpri)
				(foreach itm1 itm
					;(princ itm1) (terpri)
					(princ (strcat itm1 Sep) Stream)
				)
				(princ "\n" Stream)
			)
			(close Stream)
			(ViewHtmlPage01 FileOut  "Dstv List" Sep)
			(vl-file-delete  FileOut)
		)	
	)
)
;
;
;
(defun FindAreaAvailable (Ssel / MinMaxSsel MinCatch MaxCatch Conta StorageEname Rtn SelCheck Loop)
		(if Ssel
			(progn
				(setq MinMaxSsel	(LM:SSBoundingBox Ssel))
				(setq MinCatch 		(nth 0 MinMaxSsel))
				(setq MaxCatch 		(nth 2 MinMaxSsel))
				(setq Conta 0)
				(setq StorageEname (LM:ss->ent Ssel))

				(setq Rtn T)
				(setq SelCheck (ssget "_C" MinCatch MaxCatch))
				(if SelCheck
					(progn
						(setq Conta 0)
						(setq Loop T)
						(while Loop
							(if (not (member (ssname SelCheck Conta) StorageEname))
								(progn
									(setq Loop nil)
									(setq Rtn nil)
								)
							)
							(setq Conta (1+ Conta))
							(if (= Conta (sslength SelCheck))
								(setq Loop nil)
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
(defun PreviewNesting (LstFileShape / *error* LM:startundo LM:endundo
						              Out Ssel LstEnameShape MinMaxSsel MinCatch MaxCatch itm Rtn)

	(defun *error* ( msg )
        (LM:endundo (LM:acdoc))
		(DeleteSsel Ssel)
        (princ)
    )
	(defun LM:startundo ( doc )
		(LM:endundo doc)
		(vla-startundomark doc)
	)
	(defun LM:endundo ( doc )
		(while (= 8 (logand 8 (getvar 'undoctl)))
			(vla-endundomark doc)
		)
	)
	(defun LM:acdoc nil
		(cond ( acdoc ) ((setq acdoc (vla-get-activedocument (vlax-get-acad-object)))))
	)
	;
	; Main
	;
	(LM:startundo (LM:acdoc))
	(if LstFileShape
		(progn
			(setq Out (PreviewNestingShapeDstv LstFileShape))
			(setq Ssel          (nth 0 Out))
			(setq LstEnameShape (nth 1 Out))
			(if (and Ssel LstEnameShape)
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
	(LM:endundo (LM:acdoc))
	Rtn
)
;
;
;
(defun PreviewNestingShapeDstv (LstFileShape / DimScreen StepColumn Xdstv Ydstv StartXdstv StartYDstv LstY Rtn
											   NameFile DataDstv LstEnameShape LstOutEname Ssel minmax Width Height
											   point1 point2 conta i)
 
	(setq DimScreen (VpCoords))
	(setq StepColumn 1)
	(setq Xdstv (/ (+ (nth 0 (nth 0 DimScreen)) (nth 0 (nth 1 DimScreen))) 2.0))
	(setq Ydstv (/ (+ (nth 1 (nth 0 DimScreen)) (nth 1 (nth 1 DimScreen))) 2.0))
	(setq StartXdstv Xdstv)
	(setq StartYDstv Ydstv)
	(setq LstY nil)
	(setq Rtn (ssadd))

	(StartProgressBar "Preview:" (length LstFileShape))
	
	(foreach NameFile LstFileShape
	
		(UpDateProgressBar)
		(princ (strcat "\nPreview file " NameFile))
		(setq DataDstv 		(DstvReadFile NameFile nil nil))
		(setq LstEnameShape (GraphicDstv (list (nth 0 DataDstv) (nth 1 DataDstv) nil nil nil) (list Xdstv Ydstv) nil))
		(setq LstOutEname   (append LstOutEname 	(list (nth 0 (nth 0 LstEnameShape)))))
		(setq Ssel 			(PreviewInquadraShape 		  (nth 0 (nth 0 LstEnameShape))))
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
	(ClearProgressBar)
	(list Rtn LstOutEname)
)
;
; 
;
(defun PreviewInquadraShape (EnameShape / WidthShape HeightShape XcenterShape YcenterShape Rpx  Rpy x y	BaseQuadro AltezzaQuadro
										  modelSpace Obj1 Obj2 Obj3 Obj4 Obj5 Obj6 Obj7 Obj8 P1Bom P2Bom P3Bom P4Bom Rtn)
	(if EnameShape
		(progn
		
			(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
			(setq WidthShape   (+ (abs (- (nth 0 (vlax-safearray->list mxl)) (nth 0 (vlax-safearray->list mnl)))) 40.0))
			(setq HeightShape  (+ (abs (- (nth 1 (vlax-safearray->list mxl)) (nth 1 (vlax-safearray->list mnl)))) 40.0))	
			(setq XcenterShape (/      (+ (nth 0 (vlax-safearray->list mxl)) (nth 0 (vlax-safearray->list mnl))) 2.0))
			(setq YcenterShape (/      (+ (nth 1 (vlax-safearray->list mxl)) (nth 1 (vlax-safearray->list mnl))) 2.0))
			
			; inquadramento ------------------
			(setq Rpx nil Rpy nil)
			(foreach x DistColumn$
				(if (< (/ WidthShape x) 1.0)
					(setq Rpx (append Rpx (list (/ WidthShape x))))
				)
			)
			(foreach y DistRow$
				(if (< (/ HeightShape y) 1.0)
					(setq Rpy (append Rpy (list (/ HeightShape y))))
				)
			)

			; --------------------------------

			(setq BaseQuadro    (/ WidthShape  (nth 0 Rpx)))
			(setq AltezzaQuadro (/ HeightShape (nth 0 Rpy)))
			
			
			(if (< BaseQuadro     (nth 0 DistColumn$))
				(setq BaseQuadro  (nth 0 DistColumn$))
			)

			
			(setq modelSpace (vla-get-modelspace(vla-get-activedocument (vlax-get-acad-object))))
			
			; Riquadro massimo	
			
			(setq Obj1 (vla-AddLine modelSpace  (vlax-3d-point  (- XcenterShape (/ BaseQuadro 2.0)) 
																(- YcenterShape (/ AltezzaQuadro 2.0)))
												(vlax-3d-point  (+ XcenterShape (/ BaseQuadro 2.0)) 
																(- YcenterShape (/ AltezzaQuadro 2.0)))))
											    
			(setq Obj2 (vla-AddLine modelSpace  (vlax-3d-point  (+ XcenterShape (/ BaseQuadro 2.0)) 
																(- YcenterShape (/ AltezzaQuadro 2.0)))
												(vlax-3d-point  (+ XcenterShape (/ BaseQuadro 2.0)) 
																(+ YcenterShape (/ AltezzaQuadro 2.0)))))								
											    
			(setq Obj3 (vla-AddLine modelSpace  (vlax-3d-point  (+ XcenterShape (/ BaseQuadro 2.0)) 
																(+ YcenterShape (/ AltezzaQuadro 2.0)))
											    (vlax-3d-point  (- XcenterShape (/ BaseQuadro 2.0)) 
																(+ YcenterShape (/ AltezzaQuadro 2.0)))))
																
			(setq Obj4 (vla-AddLine modelSpace  (vlax-3d-point  (- XcenterShape (/ BaseQuadro 2.0)) 
																(+ YcenterShape (/ AltezzaQuadro 2.0)))
											    (vlax-3d-point	(- XcenterShape (/ BaseQuadro 2.0)) 
																(- YcenterShape (/ AltezzaQuadro 2.0)))))
			
			; Cartiglio
			;(setq P1Bom (list 	(+ (car  PosBom$) (- XcenterShape (/ BaseQuadro 2.0)) ) 
			;					(+ (cadr PosBom$) (- YcenterShape (/ AltezzaQuadro 2.0)) )))

 			(setq P1Bom (list  (- XcenterShape (/ BaseQuadro 2.0)) 
							   (- (- YcenterShape (/ AltezzaQuadro 2.0)) HBom$ )))

			(setq P2Bom (list (+ (car P1Bom) BaseQuadro) (cadr P1Bom)))
			
			(setq P3Bom (list (+ (car P1Bom) BaseQuadro) (+ (cadr P1Bom) HBom$)))
			
			(setq P4Bom (list (car P1Bom)                (+ (cadr P1Bom) HBom$)))
			
			
			(setq Obj5 (vla-AddLine modelSpace  (vlax-3d-point P1Bom) (vlax-3d-point P2Bom)))
			(setq Obj6 (vla-AddLine modelSpace  (vlax-3d-point P2Bom) (vlax-3d-point P3Bom)))							
			(setq Obj7 (vla-AddLine modelSpace  (vlax-3d-point P3Bom) (vlax-3d-point P4Bom)))							
			(setq Obj8 (vla-AddLine modelSpace  (vlax-3d-point P1Bom) (vlax-3d-point P4Bom)))							
													
			(setq Rtn (LstEname->Ssget (list EnameShape (vlax-vla-object->ename Obj1)
														(vlax-vla-object->ename Obj2)
														(vlax-vla-object->ename Obj3)
														(vlax-vla-object->ename Obj4)
														(vlax-vla-object->ename Obj5)
														(vlax-vla-object->ename Obj6)
														(vlax-vla-object->ename Obj7)
														(vlax-vla-object->ename Obj8)
														)))
		)
	)
	Rtn
)
;
;
;
(defun GetLstFileDstv (/ PathNc ListFile itm CodeNc TmpFile
						 Stream LstRtnB LstRtnI LstRtnL LstRtnU LstRtnRU LstRtnRO LstRtnM LstRtnC LstRtnT LstRtnSO LstRtnUnKnow) 


	;(PurgeAllGroupUnentity)
	(setq CncPathEasyCut$ (vl-registry-read EasyCutRegistryPath$ "PathNc"))
	
    (setq ListFile (LM:getfiles "Seleziona file" CncPathEasyCut$ "nc;nc1"))
	(if ListFile
		(progn
			(foreach itm ListFile
			
				(setq CodeNc (GetTypeShapeDstv itm))
				
				(if (= (length CodeNc) 2)
					(cond 
						((= (nth 1 CodeNc) "I")
							(setq LstRtnI (append LstRtnI (list itm)))
						)
						((= (nth 1 CodeNc) "L")
							(setq LstRtnL (append LstRtnL (list itm)))
						)
						((= (nth 1 CodeNc) "U")
							(setq LstRtnU (append LstRtnU (list itm)))
						)
						((= (nth 1 CodeNc) "B")
							(setq LstRtnB (append LstRtnB (list itm)))
						)
						((= (nth 1 CodeNc) "RU")
							(setq LstRtnRU (append LstRtnRU (list itm)))
						)
						((= (nth 1 CodeNc) "RO")
							(setq LstRtnRO (append LstRtnRO (list itm)))
						)
						((= (nth 1 CodeNc) "M")
							(setq LstRtnM (append LstRtnM (list itm)))
						)
						((= (nth 1 CodeNc) "C")
							(setq LstRtnC (append LstRtnC (list itm)))
						)
						((= (nth 1 CodeNc) "T")
							(setq LstRtnT (append LstRtnT (list itm)))
						)
						((= (nth 1 CodeNc) "SO")
							(setq LstRtnSO (append LstRtnSO (list itm)))
						)
						(t
							(setq LstRtnUnKnow (append LstRtnUnKnow (list itm)))
						)
					)
				)
			)
			(princ "\n" StreamLog$)
			(princ "\n--> Lettura file" StreamLog$)

			(princ "\n[Piatti]" StreamLog$)
			(foreach itm LstRtnB 		(princ (strcat "\n" itm) StreamLog$))
			(princ "\n\n[Profili I]" StreamLog$)
			(foreach itm LstRtnI 		(princ (strcat "\n" itm) StreamLog$))
			(princ "\n\n[Profili L]" StreamLog$)
			(foreach itm LstRtnL 		(princ (strcat "\n" itm) StreamLog$))
			(princ "\n\n[Profili U]" StreamLog$)
			(foreach itm LstRtnU 		(princ (strcat "\n" itm) StreamLog$))
			(princ "\n\n[Tondo pieno]" StreamLog$)
			(foreach itm LstRtnRU 		(princ (strcat "\n" itm) StreamLog$))
			(princ "\n\n[Tubo tondo]" StreamLog$)
			(foreach itm LstRtnRO 		(princ (strcat "\n" itm) StreamLog$))
			(princ "\n\n[Tubo]" StreamLog$)
			(foreach itm LstRtnM 		(princ (strcat "\n" itm) StreamLog$))
			(princ "\n\n[Profili C]" StreamLog$)
			(foreach itm LstRtnC 		(princ (strcat "\n" itm) StreamLog$))
			(princ "\n\n[Profili T]" StreamLog$)
			(foreach itm LstRtnT 		(princ (strcat "\n" itm) StreamLog$))
			(princ "\n\n[Profili Speciali]" StreamLog$)
			(foreach itm LstRtnSO 		(princ (strcat "\n" itm) StreamLog$))
			(princ "\n\n[Profili sconosciuti]" StreamLog$)
			(foreach itm LstRtnUnKnow 	(princ (strcat "\n" itm) StreamLog$))
			(if LstRtnB (vl-registry-write EasyCutRegistryPath$ "PathNc" (vl-filename-directory (nth 0 LstRtnB))))
		)
	)
	
	LstRtnB
)
;
;
;
(defun InquadraShape (EnameShape Flag / DimBom PosBom PosLogo PosBarCode WidthShape MargX MargY
										HeightShape	XcenterShape YcenterShape Rpx Rpy x BaseQuadro AltezzaQuadro
										modelSpace Obj1 Obj2 Obj3 Obj4 BlockName NameBlockLogo LstInfoShape LenghtCut
										LstDataBarCode LstBarCode itm StrBarCode EnameBlock ultent xd_list nuova_entita
										EnameBlockLogo EnameBlockBarCode LstEnameShape ObjBlock Rtn)
	(if EnameShape
		(progn
		
			(setq MargX 40.0)
			(setq MargY 40.0)
			
			(setq EnameShape (GetEnameShapeByDummyEnameSelect EnameShape))
		
			(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
			(setq WidthShape   (abs (- (nth 0 (vlax-safearray->list mxl)) (nth 0 (vlax-safearray->list mnl)))))
			(setq HeightShape  (abs (- (nth 1 (vlax-safearray->list mxl)) (nth 1 (vlax-safearray->list mnl)))))
			(setq XcenterShape (/      (+ (nth 0 (vlax-safearray->list mxl)) (nth 0 (vlax-safearray->list mnl))) 2.0))
			(setq YcenterShape (/      (+ (nth 1 (vlax-safearray->list mxl)) (nth 1 (vlax-safearray->list mnl))) 2.0))
			
			; inquadramento ------------------
			
			(setq Rpx nil Rpy nil)
			(foreach x DistColumn$
				(if (< (/ (+ WidthShape MargX) x) 1.0)
					(setq Rpx (append Rpx (list (/ (+ WidthShape MargX) x))))
				)
			)
			(foreach y DistRow$
				(if (< (/ (+ HeightShape MargY) y) 1.0)
					(setq Rpy (append Rpy (list (/ (+ HeightShape MargY) y))))
				)
			)

			; --------------------------------

			(setq BaseQuadro       (/ (+ WidthShape MargX)  (nth 0 Rpx)))
			(setq AltezzaQuadro    (/ (+ HeightShape MargY) (nth 0 Rpy)))
			
			
			(if (< BaseQuadro     (nth 0 DistColumn$))
				(setq BaseQuadro  (nth 0 DistColumn$))
			)
												
			(setq BlockName    	(strcat LibPathEasyCut$ FileBlockShape$))
			(setq NameBlockLogo	(strcat LibPathEasyCut$ FileBlockLogo$))
			(setq LstInfoShape  (GetDataShape EnameShape))
			
			; cartiglio
				
			(if LstInfoShape
				(progn
					;		0		1		2		3			4		5		6		7			8		9		10		11			12
					;	TypShape IdShape JouShape NameShape CutComp LenghtCut Timing ComShape PhaseShape MatShape TkShape DateShape	Quantita
					;    ["0"]["2"]["3"]  			percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria
					;    ["0"]["1"]["2"]["3"] 	 	compensazione taglio 0 nessuna 1 auto 2 dx 3 sx
					(cond 
						((= (nth 2 LstInfoShape) "0") (setq Percorrenza "Contorno Aperto"))
						((= (nth 2 LstInfoShape) "2") (setq Percorrenza "Antioraria"))
						((= (nth 2 LstInfoShape) "3") (setq Percorrenza "Oraria"))
					)
						
					(cond 
						((= (nth 4 LstInfoShape) "0") (setq Compensa "Nessuna"))
						((= (nth 4 LstInfoShape) "1") (setq Compensa "Automatica"))
						((= (nth 4 LstInfoShape) "2") (setq Compensa "Destra"))
						((= (nth 4 LstInfoShape) "3") (setq Compensa "Sinistra"))
					)
						
					(cond
						((= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
							(setq LenghtCut (vla-get-Circumference (vlax-ename->vla-object EnameShape)))
						)
						((= (cdr (assoc 0 (entget EnameShape))) "ELLIPSE")
							(setq LenghtCut (vlax-curve-getDistAtParam (vlax-ename->vla-object EnameShape)
											(vlax-curve-getendparam    (vlax-ename->vla-object EnameShape))))
						)
						(t
							(setq LenghtCut (vla-get-length (vlax-ename->vla-object EnameShape)))
						)
					)						
					
					(setq LstDataBarCode 	(list 	"------"
												(nth 1 LstInfoShape)
												(nth 7 LstInfoShape)
												(nth 8 LstInfoShape)
												(nth 3 LstInfoShape)
												(nth 10 LstInfoShape)
												(rtos WidthShape 2 1) 
												(rtos HeightShape 2 1)	
												(rtos LenghtCut 2 1)
												(nth 9 LstInfoShape)
												(rtos (* (/ (vla-get-area (vlax-ename->vla-object EnameShape)) 1000000.0) (atof (nth 10 LstInfoShape)) 7.85) 2 2)
												"Esterno"
												Percorrenza 
												Compensa 
												(nth 0 (nth 6 LstInfoShape)) 
												(Today)
											)
					)
					(setq LstBarCode (GetDataBarCode))
					; composizione Codice a Barre
					;((-1 96) (1 124) (2 124) (4 0) (-1 96))
					(setq StrBarCode "")
					(foreach itm LstBarCode
						(cond 
							((= (nth 0 itm) -1)
								(setq StrBarCode (strcat StrBarCode (chr (nth 1 itm))))
							)
							(t
								(setq StrBarCode (strcat StrBarCode (nth (nth 0 itm) LstDataBarCode) (chr (nth 1 itm))))
							)
						)
					)
					;(terpri) (princ StrBarCode)
					(setq PosBom (list 	  (- XcenterShape (/ BaseQuadro 2.0)) 
									   (- (- YcenterShape (/ AltezzaQuadro 2.0)) HBom$ )))

					(if Flag
						(setq ObjBlock (InsertBlock BlockName PosBom T))
						(setq ObjBlock (vlax-ename->vla-object (car (InsertBomWithoutMessage BlockName PosBom))))
					)

					(LM:vl-setattributevalue ObjBlock "IDSHAPE" 		(nth 1 LstInfoShape)) 			; id shape
					(LM:vl-setattributevalue ObjBlock "ORDERSHAPE" 	 	(nth 7 LstInfoShape)) 			; nome commessa
					(LM:vl-setattributevalue ObjBlock "PHASESHAPE" 	 	(nth 8 LstInfoShape))			; nome fase
					(LM:vl-setattributevalue ObjBlock "MKSHAPE" 		(nth 3 LstInfoShape))			; nome pezzo
					(LM:vl-setattributevalue ObjBlock "TKSHAPE"  		(nth 10 LstInfoShape))			; spessore
					(LM:vl-setattributevalue ObjBlock "LENGTHSHAPE" 	(rtos WidthShape 2 1))			; lunghezza
					(LM:vl-setattributevalue ObjBlock "HEIGHTSHAPE" 	(rtos HeightShape 2 1))			; larghezza
					(LM:vl-setattributevalue ObjBlock "MATSHAPE" 		(nth 9 LstInfoShape))			; materiale
					(LM:vl-setattributevalue ObjBlock "LASTMODIFYSHAPE" (Today))						; ultima modifica
					(LM:vl-setattributevalue ObjBlock "PERIMETERSHAPE"  (rtos LenghtCut 2 1)) 			; perimetro
					(LM:vl-setattributevalue ObjBlock "WEIGTHSHAPE" 	(rtos (* (/ (vla-get-area   (vlax-ename->vla-object EnameShape)) 1000000.0) (atof (nth 10 LstInfoShape)) 7.85) 2 2))
					(LM:vl-setattributevalue ObjBlock "TYPESHAPE" 		"Esterno")						; tipo contorno
					(LM:vl-setattributevalue ObjBlock "JOUSHAPE" 		Percorrenza)					; percorrenza
					(LM:vl-setattributevalue ObjBlock "COMPSHAPE" 		Compensa)						; compensazione
					(LM:vl-setattributevalue ObjBlock "TIMECUTSHAPE" 	(nth 0 (nth 6 LstInfoShape)))	; tempo
					(LM:vl-setattributevalue ObjBlock "QTASHAPE" 		(nth 12 LstInfoShape))			; quantità
					
					(setq EnameBlock (vlax-vla-object->ename ObjBlock))
					(LM:setdynpropvalue EnameBlock "Distance1" BaseQuadro)
					(LM:setdynpropvalue EnameBlock "Distance2" (+ AltezzaQuadro HBom$))
					(setq PosBom (BoundingBoxLstEname (list EnameBlock)))
					
					(setq ultent  (entget EnameBlock))
					(setq xd_list (list '(1002 . "}")))
					(setq xd_list (cons '(1002 . "{")  xd_list))
					(setq xd_list (cons $RgpShapeTarget xd_list))
					(setq xd_list (list -3 xd_list))
					(setq nuova_entita (append ultent (list xd_list)))
					(entmod nuova_entita)
					(entupd EnameBlock)
										
					(setq PosLogo (list (+ (car  (car PosBom)) (car PosLogo$)) 
										(+ (cadr (car PosBom)) (cadr PosLogo$))))
					
					;(setq EnameBlockLogo (InsertLogo NameBlockLogo PosLogo 220.0))
					(setq EnameBlockLogo  (vlax-vla-object->ename (InsertBlock NameBlockLogo PosLogo nil)))

					(setq PosBarCode (list 	(+ (car  (car PosBom)) (car PosBarCode$)) 
											(+ (cadr (car PosBom)) (cadr PosBarCode$))))
					
					(BrCode128 StrBarCode (strcat "BARCODE128_" (nth 1 LstInfoShape))  PosBarCode 30 (* 30 0.2))
					(PurgeBlock (strcat "BARCODE128_" (nth 1 LstInfoShape)))
					(setq EnameBlockBarCode (entlast))
					
					
					(setq LstEnameShape (GetEnameShape&TriggerByGroup (nth 0 (Gnames EnameShape))))
					
					 
					(setq Rtn (LstEname->Ssget (append LstEnameShape (list EnameBlock) 
																	 (list EnameBlockLogo) 
																	 (list EnameBlockBarCode)))
																	 
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
(defun InquadraShapeDummyEname (SselDummy LstInfoShape LstAction / minmax WidthShape HeightShape XcenterShape YcenterShape
																   Rpx Rpy x y BaseQuadro AltezzaQuadro BlockName NameBlockLogo PosBom ObjBlock
																   ultent xd_list nuova_entita
																   EnameBlock EnameBlockLogo)

	; LstInfoShape (list IdOrder IdPhase IdIdentification IdQuantity IdThickness IdQuality)

	(if (and SselDummy LstInfoShape)
		(progn
		
			(setq minmax 		(LM:SSBoundingBox SselDummy))
			(setq WidthShape	(+ (abs (- (nth 0 (nth 1 minmax)) (nth 0 (nth 0 minmax)))) 40.0))
			(setq HeightShape	(+ (abs (- (nth 1 (nth 2 minmax)) (nth 1 (nth 1 minmax)))) 40.0))
			(setq XcenterShape 	(/   (+ (nth 0 (nth 0 minmax)) (nth 0 (nth 2 minmax))) 2.0))
			(setq YcenterShape 	(/   (+ (nth 1 (nth 0 minmax)) (nth 1 (nth 2 minmax))) 2.0))		
			
			; inquadramento ------------------
			
			(setq Rpx nil Rpy nil)
			(foreach x DistColumn$
				(if (< (/ WidthShape x) 1.0)
					(setq Rpx (append Rpx (list (/ WidthShape x))))
				)
			)
			(foreach y DistRow$
				(if (< (/ HeightShape y) 1.0)
					(setq Rpy (append Rpy (list (/ HeightShape y))))
				)
			)

			; --------------------------------

			(setq BaseQuadro       (/ WidthShape  (nth 0 Rpx)))
			(setq AltezzaQuadro    (/ HeightShape (nth 0 Rpy)))
			
			(if (< BaseQuadro     (nth 0 DistColumn$))
				(setq BaseQuadro  (nth 0 DistColumn$))
			)
												
			(setq BlockName    	(strcat LibPathEasyCut$ FileBlockShapeTmp$))
			(setq NameBlockLogo	(strcat LibPathEasyCut$ FileBlockLogo$))
			
		
			; cartiglio
				
			(setq PosBom (list 	  (- XcenterShape (/ BaseQuadro 2.0)) 
							   (- (- YcenterShape (/ AltezzaQuadro 2.0)) HBom$ )))
							   
			
			;(setq ObjBlock 	(InsertBlock BlockName PosBom T))
			(setq ObjBlock (vlax-ename->vla-object (car (InsertBomWithoutMessage BlockName PosBom))))
			
			(LM:vl-setattributevalue ObjBlock "ORDERSHAPE" 	 	(nth 0 LstInfoShape)) 			; nome commessa
			(LM:vl-setattributevalue ObjBlock "PHASESHAPE" 	 	(nth 1 LstInfoShape))			; nome fase
			(LM:vl-setattributevalue ObjBlock "MKSHAPE" 		(nth 2 LstInfoShape))			; nome pezzo
			(LM:vl-setattributevalue ObjBlock "QTASHAPE" 		(nth 3 LstInfoShape))			; quantità
			(LM:vl-setattributevalue ObjBlock "TKSHAPE"  		(nth 4 LstInfoShape))			; spessore
			(LM:vl-setattributevalue ObjBlock "MATSHAPE" 		(nth 5 LstInfoShape))			; materiale
			
			(if (nth 0 LstAction) (LM:vl-setattributevalue ObjBlock "ACTION1" 	 "Esploso Blocchi"))
			(if (nth 1 LstAction) (LM:vl-setattributevalue ObjBlock "ACTION2" 	 "Eliminato Intersezione rette/archi"))
			(if (nth 2 LstAction) (LM:vl-setattributevalue ObjBlock "ACTION3" 	 "Chiuso polyline aperte"))
			(if (nth 3 LstAction) (LM:vl-setattributevalue ObjBlock "ACTION4" 	 "Eliminato oggetti singoli"))
					
			(setq EnameBlock (vlax-vla-object->ename ObjBlock))
			(LM:setdynpropvalue EnameBlock "Distance1" BaseQuadro)
			(LM:setdynpropvalue EnameBlock "Distance2" (+ AltezzaQuadro HBom$))
			(setq PosBom (BoundingBoxLstEname (list EnameBlock)))
			
			(setq ultent  (entget EnameBlock))
			(setq xd_list (list '(1002 . "}")))
			(setq xd_list (cons '(1002 . "{")  xd_list))
			(setq xd_list (cons $RgpShapeTarget xd_list))
			(setq xd_list (list -3 xd_list))
			(setq nuova_entita (append ultent (list xd_list)))
			(entmod nuova_entita)
			(entupd EnameBlock)
			
			(setq PosLogo (list (+ (car  (car PosBom)) (car PosLogo$)) 
								(+ (cadr (car PosBom)) (cadr PosLogo$))))
					
			(setq EnameBlockLogo  (vlax-vla-object->ename (InsertBlock NameBlockLogo PosLogo nil)))
		)
	)
)
;
;
;
(defun InsertLogo (FileName PosLogo WidthLogo / inimage Rtn)
	(if (findfile FileName)
		(progn
			(setq inimage 	(vlax-invoke
								(vlax-get
									(vla-get-ActiveLayout
											(vla-get-activedocument
												(vlax-get-acad-object)
											)
									)
									'Block
								)
								'AddRaster
								FileName	
								;'(540.0 -254.0 0.0)
								PosLogo
								;220.0			;<-width
								WidthLogo
								0.0
							)
			)
			(setq Rtn (vlax-vla-object->ename inimage))
	  
		)
    )
	Rtn
)
;
;
;
(defun NestingShapeNC (LstFileShape LstPtInsert / Rtn Conta0 Conta1 PtInsert DataDstv LstEnameShape Ssel i FileTmp)
 
	
	(setq Rtn (ssadd))
	(setq Conta0 0)
	(princ "\n" StreamLog$)
	(princ "\n--> Controllo contorni + intersezioni  [NestingShapeNC]" StreamLog$)
	(princ "\n" StreamLog$)	
	
	(StartProgressBar "Import:" (length LstFileShape))
	
	(foreach NameFile LstFileShape
		
		(UpDateProgressBar)
		
		(setq PtInsert 		 (nth Conta0 LstPtInsert)) 
		(setq Conta0 		 (1+ Conta0))
		(setq DataDstv 		 (DstvReadFile NameFile nil nil))
		(setq LstEnameShape  (GraphicDstv DataDstv PtInsert T))
		
		(princ (strcat "\n" (nth 0 (car DataDstv)) " " (nth 1 (car DataDstv)) " " (nth 2 (car DataDstv)) " " (nth 3 (car DataDstv))))
		
		(if (nth 1 LstEnameShape)
			(princ (strcat "\nErrore contorno esterno si interseca " 	(nth 0 (nth 0 DataDstv)) " " 
																		(nth 1 (nth 0 DataDstv)) " "
																		(nth 2 (nth 0 DataDstv)) " "
																		(nth 3 (nth 0 DataDstv)) " ") StreamLog$
			)
		)
		(if (nth 2 LstEnameShape)
			(princ (strcat "\nErrore contorno interno si interseca " 	(nth 0 (nth 0 DataDstv)) " " 
																		(nth 1 (nth 0 DataDstv)) " "
																		(nth 2 (nth 0 DataDstv)) " "
																		(nth 3 (nth 0 DataDstv)) " ") StreamLog$
			)
		)
		(if (nth 3 LstEnameShape)
			(princ (strcat "\nErrore contorno esterno con interno si intersecano " 	(nth 0 (nth 0 DataDstv)) " " 
																					(nth 1 (nth 0 DataDstv)) " "
																					(nth 2 (nth 0 DataDstv)) " "
																					(nth 3 (nth 0 DataDstv)) " ") StreamLog$
			)
		)
	
		(if (and (not (nth 1 LstEnameShape)) (not (nth 2 LstEnameShape)) (not (nth 3 LstEnameShape)))
			(progn
				(AttachDataInfoShape 		(car LstEnameShape) (car DataDstv))
				(setq Ssel (InquadraShape   (car (car LstEnameShape)) nil))
		
				(setq Conta1 0)
				(repeat (sslength Ssel)
						(ssadd (ssname Ssel Conta1) Rtn)
						(setq Conta1 (1+ Conta1))
				)
			)
		)
	)
	(ClearProgressBar)
	Rtn
)
;
;
;
(defun GraphicDstv (DataDstv PtOrigin CheckSelfIntersect / 	DataArco
															Point1 Point2
															Head ShapeOut ShapeIn Hole modelSpace Ssel conta p1 p2 InfoArco
															Obj ObjRet1 ObjRet2
															LstEnameToPoly LstTmp
															ObLine Data circleObj LstHole itm EnamePoly ErrorOut ErrorIn ErrorOutIn DataCircle
															LstInShape LstOutShape Out In)


	(defun DataArco (p1 p2 ra / corda freccia residuo px pout alfa_ini alfa_fin out alfa_interno fs svt ps pe)
		
		(setq corda (distance p1 p2))
		
				
		(if (> (- (abs ra) (/ corda 2.0)) 1e-1)
		;(if (> (abs (- (/ corda 2.0) (abs ra))) 1e-10)
			(progn
				;(princ "\nFreccia") 
				(setq freccia (- (abs ra) (sqrt (- (* ra ra)  (/ (* corda corda) 4.0)))))
				;(princ "\nResiduo")
				(setq residuo (- (abs ra) freccia))
				;(princ "\nPx     ") 
				(setq px (nth 0 (div (nth 0 p1) (nth 1 p1) (nth 0 p2) (nth 1 p2) 1)))
				
				(if (> ra 0)
					(progn
						;(princ "\nPout 1 ")
						(setq pout (per (nth 0 p1) (nth 1 p1)
										(nth 0 px) (nth 1 px)
										residuo
									)
						)
					)
					(progn
						;(princ "\nPout 2 ")
						(setq pout (per (nth 0 p1) (nth 1 p1)
										(nth 0 px) (nth 1 px)
										(* residuo -1.0)
									)
						)
					)
				)
			)
			(progn
				(setq pout (nth 0 (div (nth 0 p1) (nth 1 p1) (nth 0 p2) (nth 1 p2) 1)))
				;(setq freccia (abs ra))
				(setq freccia (/ corda 2.0))
				(if (> ra 0)
					(setq ra freccia)
					(setq ra (- 0.0 freccia))
				)
			)
		) 
		
		(if (> ra 0)
			(progn
				(setq alfa_ini (angle pout p1))
				(setq alfa_fin (angle pout p2))
			)
			(progn
				(setq alfa_ini (angle pout p2))
				(setq alfa_fin (angle pout p1))
			)
		)
		
		(setq fs (/ freccia (/ corda 2.0)))
		(if (< ra 0)
			(setq fs (* fs -1.0))
		)
		
		;
		; correzione per raggi grandi
		;
		(if (> (abs ra) 999999999.0)
			(progn
				(setq svt 1.0)
				(setq alfa_ini (+ alfa_ini (/ svt (abs ra))))
				(setq alfa_fin (- alfa_fin (/ svt (abs ra))))
				(setq ps (polar p1 alfa_ini (abs ra)))
				(setq pe (polar p1 alfa_fin (abs ra)))
			)
		)
	
		(list (list (nth 0 pout) (nth 1 pout)) alfa_ini alfa_fin ra	fs ps pe)
	)
	;
	;
	;
	(if DataDstv
		(progn
			;(LstHead LstShape LstHole LstStamp)
			(setq Head  	(nth 0 DataDstv))
			(setq ShapeOut 	(nth 1 DataDstv))
			(setq Hole  	(nth 2 DataDstv))
			(setq ShapeIn  	(nth 4 DataDstv))
			
			
			(setq modelSpace (vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
			
			(if ShapeOut
				(progn
					(setq conta 0)
					(setq Ssel (ssadd))
					(repeat (- (length ShapeOut) 1)
						
						(setq p1 (nth (+ 0 conta) ShapeOut))
						(setq p2 (nth (+ 1 conta) ShapeOut))
						
						(if (/= (nth 2 p1) 0)
							(progn
								(setq InfoArco (DataArco (list (nth 0 p1)  (nth 1 p1) )
														 (list (nth 0 p2)  (nth 1 p2) )
														 (nth 2 p1)))
								;   0      1       2      3  4  5  6
								; pcen alfa_ini alfa_fin ra fs ps pe
								;
								(setq ObjRet1 nil)
								(setq ObjRet2 nil)

								(setq Obj (vla-AddArc modelSpace (vlax-3d-point (nth 0 InfoArco)) (abs (nth 3 InfoArco)) (nth 1 InfoArco) (nth 2 InfoArco)))
								
								(if (and (nth 5 InfoArco) (nth 6 InfoArco))
									(progn
									
										(setq StartPoint (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Obj))))
										(setq EndPoint   (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint   Obj))))
									
										(if (> (nth 3 InfoArco) 0)  ; raggio
											(progn
												(setq ObjRet1 	(vla-AddLine modelSpace (vlax-3d-point StartPoint) (vlax-3d-point (nth 0 p1) (nth 1 p1) )
																))
												(setq ObjRet2 	(vla-AddLine modelSpace (vlax-3d-point EndPoint)   (vlax-3d-point (nth 0 p2) (nth 1 p2) )
																))
											)
											(progn
												(setq ObjRet1 	(vla-AddLine modelSpace  (vlax-3d-point StartPoint) (vlax-3d-point (nth 0 p2) (nth 1 p2) )
																))
												(setq ObjRet2 	(vla-AddLine modelSpace  (vlax-3d-point EndPoint)  (vlax-3d-point (nth 0 p1) (nth 1 p1) )
																))
											)
										)
									)
								)		
							)
							(setq Obj (vla-AddLine modelSpace (vlax-3d-point (nth 0 p1) (nth 1 p1)) (vlax-3d-point (nth 0 p2) (nth 1 p2) )))
						)
					
						(cond 
							((=(vlax-get-property Obj 'ObjectName) "AcDbLine")
								(if (> (vlax-get-property Obj 'Length) 0.0)
									(ssadd  (vlax-vla-object->ename Obj) Ssel)
									(entdel (vlax-vla-object->ename Obj))
								)
							)
							((=(vlax-get-property Obj 'ObjectName) "AcDbArc")
								(if (> (vlax-get-property Obj 'ArcLength) 0.0) 	
									(ssadd (vlax-vla-object->ename Obj) Ssel)
									(entdel (vlax-vla-object->ename Obj))
								)
								(if (and ObjRet1 ObjRet2)
									(progn
										(ssadd (vlax-vla-object->ename ObjRet1) Ssel)
										(ssadd (vlax-vla-object->ename ObjRet2) Ssel)
									)
								)
							)
						)
						(setq conta  (1+ conta))
					)
			
					(setq LstTmp 	(MyPedit Ssel 0.01))
					
					(if LstTmp
						(progn
						
							(if (setq DataCircle (IsLwPolylineDummyCircle (car LstTmp) 0.5))
								(progn
									(entdel (car LstTmp))
									(setq LstTmp (list (CircleLwpolyline (car DataCircle) (cadr DataCircle))))
								)
							)
							(setq LstOutShape    (append LstOutShape    LstTmp))
							(setq LstEnameToPoly (append LstEnameToPoly LstTmp))
							(if CheckSelfIntersect
								(if (CheckSelfIntersectShape (car LstTmp))
									(setq ErrorOut T)
								)
							)
						)
					)
				)
			)
			(if ShapeIn
				(foreach itm ShapeIn
					
					(setq conta 0)
					(setq Ssel (ssadd))
					(repeat (- (length itm) 1)
						
						(setq p1 (nth (+ 0 conta) itm))
						(setq p2 (nth (+ 1 conta) itm))
						
						(if (/= (nth 2 p1) 0)
							(progn
								(setq InfoArco (DataArco (list (nth 0 p1) (nth 1 p1))
														 (list (nth 0 p2) (nth 1 p2))
														 (nth 2 p1)))
								;   0      1       2      3  4  5  6
								; pcen alfa_ini alfa_fin ra fs ps pe
								;
								(setq ObjRet1 nil)
								(setq ObjRet2 nil)

								(setq Obj (vla-AddArc modelSpace (vlax-3d-point (nth 0 InfoArco)) (abs (nth 3 InfoArco)) (nth 1 InfoArco) (nth 2 InfoArco)))
																	
								(if (and (nth 5 InfoArco) (nth 6 InfoArco))
									(progn
										(setq StartPoint (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Obj))))
										(setq EndPoint   (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint   Obj))))

										(if (> (nth 3 InfoArco) 0)  ; raggio
											(progn
												(setq ObjRet1 	(vla-AddLine modelSpace (vlax-3d-point StartPoint) (vlax-3d-point (nth 0 p1) (nth 1 p1) )
																))
												(setq ObjRet2 	(vla-AddLine modelSpace (vlax-3d-point EndPoint)   (vlax-3d-point (nth 0 p2) (nth 1 p2) )
																))
											)
											(progn
												(setq ObjRet1 	(vla-AddLine modelSpace  (vlax-3d-point StartPoint) (vlax-3d-point (nth 0 p2) (nth 1 p2) )
																))
												(setq ObjRet2 	(vla-AddLine modelSpace  (vlax-3d-point EndPoint)  (vlax-3d-point (nth 0 p1) (nth 1 p1) )
																))
											)
										)
									)
								)
							)
							(setq Obj (vla-AddLine modelSpace (vlax-3d-point (nth 0 p1) (nth 1 p1)) (vlax-3d-point (nth 0 p2) (nth 1 p2) )))
						)
						
						(cond 
							((=(vlax-get-property Obj 'ObjectName) "AcDbLine")
								(if (> (vlax-get-property Obj 'Length) 0.0)
									(ssadd (vlax-vla-object->ename Obj) Ssel)
									(entdel (vlax-vla-object->ename Obj))
								)
							)
							((=(vlax-get-property Obj 'ObjectName) "AcDbArc")
								(if (> (vlax-get-property Obj 'ArcLength) 0.0) 	
									(ssadd (vlax-vla-object->ename Obj) Ssel)
									(entdel (vlax-vla-object->ename Obj))
								)
								(if (and ObjRet1 ObjRet2)
									(progn
										(ssadd (vlax-vla-object->ename ObjRet1) Ssel)
										(ssadd (vlax-vla-object->ename ObjRet2) Ssel)
									)
								)
							)
						)
						(setq conta  (1+ conta))
					)
					
					
					(setq LstTmp (MyPedit Ssel 0.01))
					(if LstTmp
						(progn
							(if (setq DataCircle (IsLwPolylineDummyCircle (car LstTmp) 0.5))
								(progn
									(entdel (car LstTmp))
									(setq circleObj (vla-AddCircle modelSpace (vlax-3d-point (cadr DataCircle)) (car DataCircle)))
									(setq LstEnameToPoly (append LstEnameToPoly (list (vlax-vla-object->ename circleObj))))
									(setq LstInShape     (append LstInShape     (list (vlax-vla-object->ename circleObj))))
								)
								(progn
							
									(setq LstEnameToPoly (append LstEnameToPoly LstTmp))
									(setq LstInShape     (append LstInShape     LstTmp))
									(if CheckSelfIntersect
										(if (CheckSelfIntersectShape (car LstTmp))
											(setq ErrorIn T)
										)
									)
								)
							)
						)
					)
				)
			)
			
			
			(if Hole
				(progn
					(setq conta 0)
					(repeat (length Hole)
						(setq Data (nth (+ 0 conta) Hole))
						(setq circleObj (vla-AddCircle modelSpace (vlax-3d-point (list (nth 0 Data) (nth 1 Data))) (/ (nth 2 Data) 2.0)))
						(setq conta  (1+ conta))
						(setq LstHole (append LstHole (list (vlax-vla-object->ename circleObj))))
					)
					(setq LstEnameToPoly (append LstEnameToPoly LstHole))
					(setq LstInShape     (append LstInShape     LstHole))
				)
			)
			
			
		)
	)
	
	(if LstEnameToPoly
		(progn
			
			(setq Point1 (vlax-3d-point  (nth 0 (LM:SSBoundingBox (LstEname->Ssget LstEnameToPoly)))))
			(setq Point2 (vlax-3d-point  PtOrigin))

			(foreach itm LstEnameToPoly
				(vla-Move (vlax-ename->vla-object itm) Point1 Point2)
			)
		)
	)
	;
	; controllo collisione contorno esterno con contorini interni
	;
	(if CheckSelfIntersect
		(if (CheckIntersectionsListEntity LstEnameToPoly)
		    (setq ErrorOutIn T)
		)
	)
	(list LstEnameToPoly ErrorOut ErrorIn)
	(list LstEnameToPoly ErrorOut ErrorIn ErrorOutIn)
)	
;
;
;
(defun AttachDataInfoShape (LstEname Head / ColorShapeOra ColorShapeAntiOra ColorHoleOra ColorHoleAntiOra ColorCircle ColorEllipse
											Num itm TypShape Journey RecordList ultent xd_list nuova_entita GrName l)


	;	0	IdOrder
	;	1	IdDrawing
	;	2	IdPhase
	;	3	IdIdentification
	;	4	IdQuality
	;	5	IdQuantity
	;	6	IdProfile
	;	7	IdCode
	;	8	IdLength
	;	9	IdHeigth
	;	10	IdThickness
	;	11	IdWeightmt
	;	12	IdSurfacemt
	;	13	IdName

	(if (and LstEname Head)
		(progn
			(ZoomEname (car LstEname) 50)
			(setq ColorShapeOra  	$ColorShapeOra)
			(setq ColorShapeAntiOra $ColorShapeAntiOra)
			(setq ColorHoleOra		$ColorHoleOra)
			(setq ColorHoleAntiOra 	$ColorHoleAntiOra)
			(setq ColorCircle 		$ColorCircle)
			(setq ColorEllipse 		$ColorEllipse)
			
			(setq Num 0)
			(foreach itm LstEname
				
				(if (= Num 0) 
					(setq TypShape "CE")
					(setq TypShape "CI")
				)
				(cond
					((= (cdr (assoc 0 (entget itm))) "LWPOLYLINE")
						(setq Journey (ClockWeisEname  itm))
					)
					((or (= (cdr (assoc 0 (entget itm))) "CIRCLE")		; solo per contorni interni
						 (= (cdr (assoc 0 (entget itm))) "ELLIPSE")) 	; solo per contorni interni
							(setq Journey 2)
					)
				)
				(cond
					((= TypShape "CE")
						(if (= Journey 3) (vla-put-Color (vlax-ename->vla-object itm) ColorShapeOra))	
						(if (= Journey 2) (vla-put-Color (vlax-ename->vla-object itm) ColorShapeAntiOra))
					)
					((= TypShape "CI")
						(if (= Journey 3) (vla-put-Color (vlax-ename->vla-object itm) ColorHoleOra))
						(if (= Journey 2) (vla-put-Color (vlax-ename->vla-object itm) ColorHoleAntiOra))
					)
				)
				;
				; Xdata +++++++++++++++++++++++++++++++++++++++
				;
				(setq RecordList (list (nth 3 Head) "1" (nth 0 Head) (nth 2 Head) (nth 4 Head) (nth 10 Head) (Today) (nth 5 Head)))
				(setq ultent (entget itm)
				      xd_list (list '(1002 . "}"))
				)
				(foreach itm1 (reverse RecordList)
					(setq xd_list (cons (cons 1000 itm1) xd_list))
				)
				(setq xd_list (cons (cons 1000 (rtos Journey 2 0)) xd_list)	; percorrenza   ["0"]["2"]["3"]
					  xd_list (cons (cons 1000 (Random_Str 9))     xd_list)	; id pezzo      ["123456789"]
					  xd_list (cons (cons 1000 TypShape)           xd_list)	; tipo contorno ["CE"] ["CI"]
					  xd_list (cons '(1002 . "{")                  xd_list)
					  xd_list (cons $RgpShape xd_list)
					  xd_list (list -3 xd_list)
					  nuova_entita (append ultent (list xd_list))
				)
				(setq Num (1+ Num))
				
				(entmod nuova_entita)
				(entupd itm)
				;
				; end Xdata ++++++++++++++++++++++++++++++++++++
				;
			)
			;
			; ricreo il gruppo +++++++++++++++++++++++++++++++++++++++++
			;
			(setq GrName (Random_Str 9))
			(setq l nil)
			(foreach  itm LstEname
				(setq l (cons (vlax-ename->vla-object itm) l))
			)
			(if LstEname (vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) GrName) 'appenditems l))
			(ChDescGroup GrName $RgpShape)
		)
	)
)
;
;
;
(defun GetTypeShapeDstv (FileIn / IsVoidString 
								  BlockStartFile BlockEndFile BlockComm i Stream IdCode codeerror)
	
	(defun IsVoidString (String / itm Rtn)
		(setq Rtn T)
		(if String
			(foreach itm (vl-string->list String)
				(if (and (/= itm 32) (/= itm 9))
					(setq Rtn nil)
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if FileIn
		(progn
		
			(setq BlockStartFile "ST")
			(setq BlockEndFile   "EN")
			(setq BlockComm      "**")
			(setq codeerror 0)
			(setq Stream (open FileIn "r")) 
	
			(if (not Stream)
				(progn
					; (alert (strcat "ERRORE!! apertura file -> " FileIn))
					; (exit)
					(setq codeerror 1)
				)
				(setq Line (read-line Stream))
			)
			(if (not Line)
				(progn
					;(alert (strcat "ERRORE!! file vuoto -> " FileIn))
					(setq codeerror 2)
					(close Stream)
					;(exit)
				)
			)
			(if (= codeerror 0)
				(progn
					; find Start Info Member +++++++
					(while (/= (strcase (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))) (strcase BlockStartFile))
						(setq Line (read-line Stream))
					)
					(setq Line (read-line Stream))
					(setq i 0)
					; find Info Member +++++++++++++
					(while 	(< i 8)
						(if (and (not (IsVoidString Line))	(/= (substr Line 1 2) BlockComm))
							(progn
								(setq i (1+ i))
								(if (= i 8) (setq IdCode (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; B
							)
						)
						(setq Line (read-line Stream))
					)
					(close Stream)
				)
			)
		)
	)
	(list codeerror IdCode)
)
;
;
;
(defun DstvReadFile (FileIn Expert Verbose / IsVoidString PurgeLine GetReal_ PrintStream
									 fuzztable BlockStartFile BlockEndFile BlockComm LstBlockInfo Stream Line LinePrint LineSplit i
									 IdOrder IdPhase IdDrawing IdIdentification IdQuality IdQuantity  IdProfile  IdCode IdLength
									 IdHeigth skeep	IdThickness IdWeightmt IdSurfacemt IdName LstHead
									 OpenBo OpenAk OpenIk OpenSi OpenDummy TypDim$ RefDim$ BlockName
									 X Y D H Tx LstHole LstAkShape LstIkShape LstStamp LstIkShapeTotal
									 LstDiscrete Clock PerimeterShape JouShape TypShape CutShape Weigth)
						

	
	 

		;
		(defun IsVoidString (String / itm Rtn)
			(setq Rtn T)
			(if String
				(foreach itm (vl-string->list String)
					(if (and (/= itm 32) (/= itm 9))
						(setq Rtn nil)
					)
				)
			)
			Rtn
		)
		;
		;
		(defun DecodeLine (TypeBlock String  / IsNumber DecodeString
											 String SplitString X Y D R Ang Ht Tx Num Rtn)
		
			(defun IsNumber (CodeAscii)
				(if CodeAscii
					(cond
						((=  CodeAscii 45) T)
						((=  CodeAscii 46) T)
						((and (>= CodeAscii 48) (<= CodeAscii 57)) T)
					)
				)
			)
			;
			(defun DecodeString (String / itm PrevChar Rtn)

				(setq PrevChar 0)
				(setq Rtn "")
				(if String
					(progn
						(setq String (ReplaceChar  " " "\t" String))
						(setq String (vl-string-right-trim " " (vl-string-left-trim " " String)))
						(foreach itm (vl-string->list String)
							(cond	
								((= itm 32) ; Space
									(if (/= PrevChar itm) 
										(setq Rtn (strcat Rtn (chr itm)))
									)
									(setq PrevChar itm)
								)
								((IsNumber itm)
									(setq Rtn (strcat Rtn (chr itm)))
									(setq PrevChar itm)
								)
								(t
									(setq Rtn (strcat Rtn (chr itm) "|"))
									(setq PrevChar 32)
								)
							)
						)
						(if (IsNumber (ascii (substr Rtn (strlen Rtn) 1))) (setq Rtn (strcat Rtn " ")))
						;(setq Rtn (vl-string-right-trim " " (vl-string-left-trim " " Rtn)))
						(setq Rtn (LM:StringSubst " |" " " Rtn))
						(setq Rtn (SpliTxt Rtn "|"))
					)
				)
				Rtn
			)
			;
			; Main
			;
			(if (and TypeBlock String)
				(progn
					; General
					(if (or (= (substr String 1 1) "v")
							(= (substr String 1 1) "h")
						)
						(progn
							(setq TypDim$ T)
							(setq String (ReplaceNthChar 1 "" String))
						)
					)
					
					(setq SplitString (DecodeString String))
					; General
					(if (or (= (substr (car SplitString) (strlen (car SplitString)) 1) "o")
							(= (substr (car SplitString) (strlen (car SplitString)) 1) "s")
							(= (substr (car SplitString) (strlen (car SplitString)) 1) "u")
						)
						(setq RefDim$ T)
					)
					(setq X (substr (car SplitString) 1  (- (strlen (car SplitString)) 1)))
					(setq Y (substr (cadr SplitString) 1 (- (strlen (cadr SplitString)) 1)))
					
					
					(cond
						((= TypeBlock "BO")
							
							(if (or (= (substr (cadr SplitString) (strlen (cadr SplitString)) 1) "g") 	; foro filettato
									(= (substr (cadr SplitString) (strlen (cadr SplitString)) 1) "m")	; traccia
									(= (substr (cadr SplitString) (strlen (cadr SplitString)) 1) "s")	; foro ribassato
								)
								(setq D "0.0")
								(setq D (substr (caddr SplitString) 1 (- (strlen (caddr SplitString)) 1)))
							)
							(if (> (length SplitString) 3)
								(if (> (atof (substr (nth 3 SplitString) 1 (- (strlen (nth 3 SplitString)) 1))) 0.0)	; foro ribassato cieco
									(setq D "0.0")
								)
							)
							(setq Rtn (strcat X " " Y " " D))
						)
						((or (= TypeBlock "AK") (= TypeBlock "IK"))
							
							(if (or (= (substr (cadr SplitString) (strlen (cadr SplitString)) 1) "t")
									(= (substr (cadr SplitString) (strlen (cadr SplitString)) 1) "w")
								)
								(setq R "0.0")
								(setq R (substr (caddr SplitString) 1 (- (strlen (caddr SplitString)) 1)))
							)
							(if (= (length SplitString) 3)
								(setq Rtn (strcat X " " Y " " R)) 		; contorno senza preparazioni
								(setq Rtn (strcat X " " Y " " R " 1")) 	; contorno con preparazioni
							)
						)
						((= TypeBlock "SI")
							
							(setq Ang   (substr (nth 2 SplitString) 1 (- (strlen (nth 2 SplitString)) 1)))
							(setq Ht    (substr (nth 3 SplitString) 1 (- (strlen (nth 3 SplitString)) 1)))
							(setq Num 4)
							(setq Tx "")
							(repeat (- (length SplitString) 4)
								(setq Tx (strcat Tx (nth Num SplitString)))
								(setq Num (1+ Num))
							)
							(setq Rtn (strcat X " " Y " " Ang " " Ht " " Tx))
						)
					)

					
					(if Rtn
						(if (<= (length (splitxt Rtn " ")) 2)
							(progn
								(princ (strcat " Errore linea non formattata [DecodeLine] "  Rtn))
								(exit)
							)
						)
						(progn
							(princ (strcat " Linea nulla [DecodeLine] "))
							(exit)
						)
					)

					
					(if (and TypDim$ RefDim$)
						(setq Rtn (list (strcat "11") Rtn))
						(setq Rtn nil)
					)
				)
			)
			Rtn
		)
		;
		;
		(defun GetReal_ (String / conta Rtn)
		
			(if String
				(progn
					(setq conta 1)
					(setq Rtn "")
					(repeat (strlen String)
						(cond
							((= (ascii (substr String conta 1)) 45)	(setq Rtn (strcat Rtn (substr String conta 1))))
							((= (ascii (substr String conta 1)) 46)	(setq Rtn (strcat Rtn (substr String conta 1))))
							((= (ascii (substr String conta 1)) 48)	(setq Rtn (strcat Rtn (substr String conta 1))))
							((= (ascii (substr String conta 1)) 49)	(setq Rtn (strcat Rtn (substr String conta 1))))
							((= (ascii (substr String conta 1)) 50)	(setq Rtn (strcat Rtn (substr String conta 1))))
							((= (ascii (substr String conta 1)) 51)	(setq Rtn (strcat Rtn (substr String conta 1))))
							((= (ascii (substr String conta 1)) 52)	(setq Rtn (strcat Rtn (substr String conta 1))))
							((= (ascii (substr String conta 1)) 53)	(setq Rtn (strcat Rtn (substr String conta 1))))
							((= (ascii (substr String conta 1)) 54)	(setq Rtn (strcat Rtn (substr String conta 1))))
							((= (ascii (substr String conta 1)) 55)	(setq Rtn (strcat Rtn (substr String conta 1))))
							((= (ascii (substr String conta 1)) 56)	(setq Rtn (strcat Rtn (substr String conta 1))))
							((= (ascii (substr String conta 1)) 57)	(setq Rtn (strcat Rtn (substr String conta 1))))
						)
						(setq conta (1+ conta))
					)
				)
			)
			(if (/= Rtn "")
				(atof Rtn)
				nil
			)
		)
		;
		;
		(defun PrintStream (String Stream Verbose)
			(if (and String Stream Verbose)
				(princ String Stream)
				;(princ String)
			)
		)
		;
		; Main
		;
		(setq fuzztable 2)
		(setq BlockStartFile "ST")
		(setq BlockEndFile   "EN")
		(setq BlockComm      "**")
		(setq LstBlockInfo '(     "BO" "SI" "AK" "IK" "PU" "KO" "SC" "TO" "UE" "PR" "KA"
								  "E0" "E1" "E2" "E3" "E4" "E5" "E6" "E7" "E8" "E9"
								  "B0" "B1" "B2" "B3" "B4" "B5" "B6" "B7" "B8" "B9"
								  "S0" "S1" "S2" "S3" "S4" "S5" "S6" "S7" "S8" "S9"
								  "A0" "A1" "A2" "A3" "A4" "A5" "A6" "A7" "A8" "A9"
								  "I0" "I1" "I2" "I3" "I4" "I5" "I6" "I7" "I8" "I9"
								  "P0" "P1" "P2" "P3" "P4" "P5" "P6" "P7" "P8" "P9"
								  "K0" "K1" "K2" "K3" "K4" "K5" "K6" "K7" "K8" "K9"))
								  
								  
		(if FileIn
			(progn
				(setq Stream (open FileIn "r"))
	
				(if (not Stream)
					(progn
						(alert (strcat "ERRORE!! apertura file -> " FileIn))
						(exit)
					)
					(setq Line (read-line Stream))
				)
				
				(if (not Line)
					(progn
						(alert (strcat "ERRORE!! file vuoto -> " FileIn))
						(close Stream)
						(exit)
					)
				)
				
				; find Start Info Member +++++++
				(while (/= (strcase (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))) (strcase BlockStartFile))
					(setq Line (read-line Stream))
				)
				(setq Line (read-line Stream))
				(setq i 0)
				; find Info Member +++++++++++++
				(while 	(< i 20)
					(if (and 
							(not (member  (strcase (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))) LstBlockInfo))
							(not (IsVoidString Line))
							(/= (substr Line 1 2) BlockComm)
						)
						(progn
							(setq i (1+ i))
							(cond
								((= i 1) (setq IdOrder          (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; C872 
								((= i 2) (setq IdPhase          (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 100
								((= i 3) (setq IdDrawing        (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 171-110
								((= i 4) (setq IdIdentification (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 011124
								((= i 5) (setq IdQuality        (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; S355J2
								((= i 6) (setq IdQuantity       (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 1
								((= i 7) (setq IdProfile        (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; PL1540*15
								((= i 8) (setq IdCode           (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; B
								((and (= i 9) (= IdCode "B"))   (setq IdLength 	  (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 1183.50
								((and (= i 10) (= IdCode "B"))  (setq IdHeigth    (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 1540.00
								((and (= i 11) (= IdCode "B"))  (setq skeep	      (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 0.00
								((and (= i 12) (= IdCode "B"))  (setq skeep       (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 0.00
								((and (= i 13) (= IdCode "B"))  (setq IdThickness (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 15.00	
								((and (= i 14) (= IdCode "B"))  (setq skeep       (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 0.00
								((and (= i 15) (= IdCode "B"))  (setq IdWeightmt  (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 64.25
								((and (= i 16) (= IdCode "B"))  (setq IdSurfacemt (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 1.13
								((and (= i 17) (= IdCode "B"))  (setq skeep       (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 0.00
								((and (= i 18) (= IdCode "B"))  (setq skeep       (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 0.00
								((and (= i 19) (= IdCode "B"))  (setq skeep       (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 0.00
								((and (= i 20) (= IdCode "B"))  (setq skeep       (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line))))	; 0.00
							)
						)
					)
					(setq Line (read-line Stream))
				)

				(if (and (= IdCode "B") (= i 20))
					(setq IdName  (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line)))	; PIATTO
				)
				
				(if (and (= IdCode "B") (= (- (atof IdThickness) (atoi IdThickness)) 0))
					(setq IdThickness (rtos (atoi IdThickness) 2 0))
				)
				
				(if (= IdCode "B") 
					(setq LstHead (list IdOrder IdDrawing IdPhase IdIdentification
									(strcase IdQuality) IdQuantity IdProfile IdCode IdLength IdHeigth
									IdThickness IdWeightmt IdSurfacemt IdName)
					)
					(progn
						(close Stream)
						(setq Line nil)
					)
				)
			
				(while Line
					
					(setq Line (vl-string-right-trim " \t" (vl-string-left-trim " \t" Line)))
					
					(cond
						((= Line "BO")			; fori
							(setq OpenBo T OpenAk nil OpenIk nil OpenSi nil OpenDummy nil TypDim$ nil RefDim$ nil)
							(setq BlockName (car (member Line LstBlockInfo)))
						)
						((= Line "AK") 			; controni esterni
							(setq OpenAk T OpenIk nil OpenBo nil OpenSi nil OpenDummy nil TypDim$ nil RefDim$ nil)
							(setq BlockName (car (member Line LstBlockInfo)))
						)
						((= Line "IK") 			; controni interni
							(if LstIkShape (setq LstIkShapeTotal (append LstIkShapeTotal (list LstIkShape))))
							(setq OpenIk T LstIkShape nil OpenAk nil OpenBo nil OpenSi nil OpenDummy nil TypDim$ nil RefDim$ nil)
							(setq BlockName (car (member Line LstBlockInfo)))
						)
						((= Line "SI") 			; stamp
							(setq OpenSi T OpenBo nil OpenAk nil OpenIk nil OpenDummy nil TypDim$ nil RefDim$ nil)
							(setq BlockName (car (member Line LstBlockInfo)))
						)
						((or (= Line "PU") (= Line "KO") (= Line "SC") (= Line "TO") (= Line "UE") (= Line "PR") (= Line "KA")
							 (= Line "E0") (= Line "E1") (= Line "E2") (= Line "E3") (= Line "E4") 
							 (= Line "E5") (= Line "E6") (= Line "E7") (= Line "E8") (= Line "E9")
							 (= Line "B0") (= Line "B1") (= Line "B2") (= Line "B3") (= Line "B4") 
							 (= Line "B5") (= Line "B6") (= Line "B7") (= Line "B8") (= Line "B9")
							 (= Line "S0") (= Line "S1") (= Line "S2") (= Line "S3") (= Line "S4")
							 (= Line "S5") (= Line "S6") (= Line "S7") (= Line "S8") (= Line "S9")
							 (= Line "A0") (= Line "A1") (= Line "A2") (= Line "A3") (= Line "A4") 
							 (= Line "A5") (= Line "A6") (= Line "A7") (= Line "A8") (= Line "A9")
							 (= Line "I0") (= Line "I1") (= Line "I2") (= Line "I3") (= Line "I4")
							 (= Line "I5") (= Line "I6") (= Line "I7") (= Line "I8") (= Line "I9")
							 (= Line "P0") (= Line "P1") (= Line "P2") (= Line "P3") (= Line "P4")
							 (= Line "P5") (= Line "P6") (= Line "P7") (= Line "P8") (= Line "P9")
							 (= Line "K0") (= Line "K1") (= Line "K2") (= Line "K3") (= Line "K4")
							 (= Line "K5") (= Line "K6") (= Line "K7") (= Line "K8") (= Line "K9"))
							 
							 (setq OpenDummy T OpenBo nil OpenAk nil OpenIk nil OpenSi nil TypDim$ nil RefDim$ nil)
							 (setq BlockName (car (member Line LstBlockInfo)))
						)
						((= Line BlockEndFile)  ; end
							(setq OpenBo nil OpenAk nil OpenIk nil OpenSi nil OpenDummy nil TypDim$ nil RefDim$ nil Line nil)
							(setq BlockName BlockEndFile)
						)
						(t
							(cond
								; [++++++ FORI ++++++]
								((and OpenBo (not (IsVoidString Line)) (/= (substr Line 1 2) BlockComm))
									(setq LinePrint Line)
									(setq Line (DecodeLine "BO" Line))
									(setq LineSplit (splitxt (cadr Line) " "))
									(cond 
										((= (car Line) "11")
											(if (> (GetReal_ (caddr LineSplit)) 0)
												(setq X (GetReal_ (car LineSplit))
													  Y (GetReal_ (cadr LineSplit))
													  D (GetReal_ (caddr LineSplit))
													  LstHole     (append LstHole (list (list X Y D)))
												)
												(progn
													(PrintStream (strcat "\n" FileIn "- Foro cieco/incassato/svasato/filettato (NON RAPPRESENTATO) - ") StreamLog$ Verbose)
													(PrintStream (strcat " [ " BlockName " ] ") StreamLog$ Verbose)
													(PrintStream LinePrint StreamLog$ Verbose)
												)
											)
										)
										(t 
											(PrintStream (strcat "\n" FileIn "- origine coordinata foro non implementata - ") StreamLog$ Verbose)
											(PrintStream (strcat " [ " BlockName " ] ") StreamLog$ Verbose)
											(PrintStream LinePrint StreamLog$ Verbose)
										)
									)
								)
								; [++++++ CONTORNI ESTERNI ++++++]
								((and OpenAk (not (IsVoidString Line)) (/= (substr Line 1 2) BlockComm))
									(setq LinePrint Line)
									(setq Line (DecodeLine "AK" Line))
									(setq LineSplit (splitxt (cadr Line) " "))
							
									(cond 
										((= (car Line) "11")
											(if (>= (length LineSplit) 3)
												(setq X (GetReal_ (car LineSplit))
													  Y (GetReal_ (cadr LineSplit))
													  R (GetReal_ (caddr LineSplit))
													  LstAkShape (append LstAkShape (list (list X Y R)))
												)
											)
											(if (> (length LineSplit) 3)
												(progn
													(PrintStream (strcat "\n" FileIn "- contorno esterno con preparazione - ") StreamLog$ Verbose)
													(PrintStream (strcat " [ " BlockName " ] ") StreamLog$ Verbose)
													(PrintStream LinePrint StreamLog$ Verbose)
												)
											)
										)
										(t 
											(PrintStream (strcat "\n" FileIn "- origine coordinata contorno non implementata - ") StreamLog$ Verbose)
											(PrintStream (strcat " [ " BlockName " ] ") StreamLog$ Verbose)
											(PrintStream LinePrint StreamLog$ Verbose)
										)
									)
								)
								; [++++++ CONTORNI INTERNI ++++++]
								((and OpenIk (not (IsVoidString Line)) (/= (substr Line 1 2) BlockComm))
									(setq LinePrint Line)
									(setq Line (DecodeLine "IK" Line))
									(setq LineSplit (splitxt (cadr Line) " "))
						
									(cond 
										((= (car Line) "11")
											(if (>= (length LineSplit) 3)
												(setq X (GetReal_ (car LineSplit))
													  Y (GetReal_ (cadr LineSplit))
													  R (GetReal_ (caddr LineSplit))
													  LstIkShape (append LstIkShape (list (list X Y R)))
												)
											)
											(if (> (length LineSplit) 3)
												(progn
													(PrintStream (strcat "\n" FileIn "- contorno interno con preparazione - ") StreamLog$ Verbose)
													(PrintStream (strcat " [ " BlockName " ] ") StreamLog$ Verbose)
													(PrintStream LinePrint StreamLog$ Verbose)
												)
											)
										)
										(t
											(PrintStream (strcat "\n" FileIn "- origine coordinata contorno interno non implementata - ") StreamLog$ Verbose)
											(PrintStream (strcat " [ " BlockName " ] ") StreamLog$ Verbose)
											(PrintStream LinePrint StreamLog$ Verbose)
										)
									)
								)
								; [++++++ NUMERAZIONE ++++++]
								((and OpenSi (not (IsVoidString Line)) (/= (substr Line 1 2) BlockComm))
									(setq LinePrint Line)
									(setq Line (DecodeLine "SI" Line))
									(setq LineSplit (splitxt (cadr Line) " "))
									;200.00 400.00 0.00  5 C872/300/178-357
									(cond 
										((= (car Line) "11")
											(if (= (length LineSplit) 5)
												(setq X (GetReal_ (nth 0 LineSplit))
													  Y (GetReal_ (nth 1 LineSplit))
													  R (GetReal_ (nth 2 LineSplit))
													  H (GetReal_ (nth 3 LineSplit))
													  Tx         (nth 4 LineSplit)
													  LstStamp (append LstStamp (list (list X Y R H Tx)))
												)
												(progn
													(PrintStream (strcat "\n" FileIn "- formattazione stampa non riconosciuta - ") StreamLog$ Verbose)
													(PrintStream (strcat " [ " BlockName " ] ") StreamLog$ Verbose)
													(PrintStream LinePrint StreamLog$ Verbose)
												)
											)
										)
										(t
											(PrintStream (strcat "\n" FileIn "- origine coordinata stampa non implementata - ") StreamLog$ Verbose)
											(PrintStream (strcat " [ " BlockName " ] ") StreamLog$ Verbose)
											(PrintStream LinePrint StreamLog$ Verbose)
										)
									)
								)
								; [++++++ BLOCCO DUMMY ++++++]
								((and OpenDummy (not (IsVoidString Line)) (/= (substr Line 1 2) BlockComm))
									(setq LinePrint Line)
									(PrintStream (strcat "\n" FileIn "- Blocco non gestito - ") StreamLog$ Verbose)
									(PrintStream (strcat " [ " BlockName " ] ") StreamLog$ Verbose)
									(PrintStream LinePrint StreamLog$ Verbose)
								)
							)
						)
					)
					(setq Line (read-line Stream))
				)
				(close Stream)
				;
				; Patch 1 ++++++++++++++++++++++++++++++
				;
				(if (and (= IdCode "B") (not LstAkShape)) ; piatto senza contorno (inteso come piatto)
					(setq X 0.0     		    Y 0.0 			      LstAkShape (append LstAkShape (list (list X Y 0.0)))
						  X (GetReal_ IdLength) Y 0.0                 LstAkShape (append LstAkShape (list (list X Y 0.0)))
						  X (GetReal_ IdLength) Y (GetReal_ IdHeigth) LstAkShape (append LstAkShape (list (list X Y 0.0)))
						  X 0.0 			    Y (GetReal_ IdHeigth) LstAkShape (append LstAkShape (list (list X Y 0.0)))
						  X 0.0     		    Y 0.0 			      LstAkShape (append LstAkShape (list (list X Y 0.0)))
					)
				)
				;
				; Patch 2 ++++++++++++++++++++++++++++++
				;
				(if (and (= IdCode "B")  LstAkShape (not (equal (car LstAkShape) (car (reverse LstAkShape)))))
					(setq LstAkShape (append LstAkShape (list (car LstAkShape))))
				)
				;
				; Patch 3 ++++++++++++++++++++++++++++++
				;
				(if (and (= IdCode "B") Expert)
					(progn
						(setq LstDiscrete 		(DiscretizeDstvShape LstAkShape))
						(setq Clock 			(LM:ListClockwise-p (car LstDiscrete)))
						(setq PerimeterShape 	(LM:rtos  (cadr LstDiscrete) 2 fuzztable))
						(setq LstDiscrete 		(car LstDiscrete))
						(if Clock (setq JouShape "3") (setq JouShape "2"))
						(setq TypShape "CE")
						(setq CutShape "1")
						(setq Weigth (rtos (abs (* (/ (area01 (mapcar 'car LstDiscrete) (mapcar 'cadr LstDiscrete)) 1000000.0) (atof IdThickness) 7.85)) 2 2))
						(setq LstHead (append LstHead (list JouShape TypShape CutShape PerimeterShape Weigth (today))))
					)
				)
				;
				; Patch 4 ++++++++++++++++++++++++++++++
				;
				(if (and (= IdCode "B")  LstIkShape)
					(progn
						;(princ "\n Scarico finale")
						(setq LstIkShapeTotal (append LstIkShapeTotal (list LstIkShape)))
					)
				)
			)
		)
		(list LstHead LstAkShape LstHole LstStamp LstIkShapeTotal)
)					
;
;
;
(defun DiscretizeDstvShape (LstShape  / DataArco DeltaAng
										Clock LstPt Perimeter conta p1 p2 InfoArco PtCen AlfaIni AlfaFin Radius PtStart DistDivide LgArc Ndi LstPtArc LstOut itm Rtn)


	(defun DataArco (p1 p2 ra / corda freccia residuo px pout alfa_ini alfa_fin out alfa_interno fs)
		
		(setq corda (distance p1 p2))
		
		(if (> (abs (- (/ corda 2.0) (abs ra))) 1e-02)
			(progn
				(setq freccia (- (abs ra) (sqrt (- (* ra ra)  (/ (* corda corda) 4.0)))))
				(setq residuo (- (abs ra) freccia))
				(setq px (nth 0 (div (nth 0 p1) (nth 1 p1)
									 (nth 0 p2) (nth 1 p2)
									 1
								)
						)
				)
				(if (> ra 0)
					(setq pout (per (nth 0 p1) (nth 1 p1)
									(nth 0 px) (nth 1 px)
									residuo
								)
					)
					(setq pout (per (nth 0 p1) (nth 1 p1)
									(nth 0 px) (nth 1 px)
									(* residuo -1.0)
								)
					)
				)
			)
			(progn
				(setq pout (nth 0 (div (nth 0 p1) (nth 1 p1)
									   (nth 0 p2) (nth 1 p2)
										1
								  )
						   )
						   freccia (abs ra)
				)
			)
		)      
		(if (> ra 0)
			(progn
				(setq alfa_ini (angle pout p1))
				(setq alfa_fin (angle pout p2))
			)
			(progn
				(setq alfa_ini (angle pout p2))
				(setq alfa_fin (angle pout p1))
			)
		)
		(setq fs (/ freccia (/ corda 2.0)))
		(if (< ra 0)
			(setq fs (* fs -1.0))
		)
		(list (list (nth 0 pout) (nth 1 pout)) alfa_ini alfa_fin ra	fs)
	)
	;
	;
	;
	(defun DeltaAng (AngIni AngFin / Rtn)
		(if (and AngIni AngFin)
			(progn
				(setq Rtn (- AngFin AngIni))
				(cond
					((= Rtn 0)
						(setq Rtn 0.0)
					)
					((< Rtn 0)
						(setq Rtn (+ (* Pi 2.0) Rtn))
					)
				)
			)
		)
		Rtn
	)
	;
	;
	;
	(if LstShape
		(progn
			;(setq Clock (ClockWeiseArc LstShape))
			;(princ Clock) (getstring "")
			(setq conta 0)
			(repeat (- (length LstShape) 1)
			
				(setq p1 (nth (+ 0 conta) LstShape))
				(setq p2 (nth (+ 1 conta) LstShape))
						
				(if (/= (nth 2 p1) 0)
					(progn
						(setq InfoArco (DataArco (list (nth 0 p1) (nth 1 p1))
												 (list (nth 0 p2) (nth 1 p2))
												 (nth 2 p1)))
						
						;(list (list (nth 0 pout) (nth 1 pout)) alfa_ini alfa_fin ra fs)
						;(polar pt ang dist)
						;(vla-AddArc Object Center Radius StartAngle EndAngle)
						;(dcp x1 y1 x2 y2 ang n_pt)
							
						(setq PtCen   	 (nth 0 InfoArco))
						(setq AlfaIni 	 (nth 1 InfoArco))
						(setq AlfaFin 	 (nth 2 InfoArco))
						(setq Radius  	 (abs (nth 2 p1)))
						(setq PtStart 	 (polar PtCen AlfaIni Radius))
						(setq DistDivide (GetDivArc2 Radius $ArrowArcDivision))
						;(setq LgArc	 (abs (* Radius (- AlfaFin AlfaIni))))
						(setq LgArc		 (abs (* Radius (DeltaAng AlfaIni AlfaFin))))
						(setq Ndi 		 (fix (/ LgArc DistDivide)))
						
						(if (= Ndi 0) (setq Ndi 2))
								
						;(setq LstPtArc (dcp (nth 0 PtCen) 
						;					(nth 1 PtCen)
						;					(nth 0 PtStart)
						;					(nth 1 PtStart)
						;					(abs (- AlfaFin AlfaIni))
						;					(- Ndi 1)))
						(setq LstPtArc (dcp (nth 0 PtCen) 
											(nth 1 PtCen)
											(nth 0 PtStart)
											(nth 1 PtStart)
											(DeltaAng AlfaIni AlfaFin)
											(- Ndi 1)))

						(if (< (nth 2 p1) 0) (setq LstPtArc (reverse LstPtArc)))
						
						
						;(if Clock (setq LstPtArc (reverse LstPtArc)))
						
						(if (not (member (list (car p1) (cadr p1)) LstOut))
							(setq LstOut (append LstOut (list (list (car p1) (cadr p1)))))
						)
						
						(foreach itm LstPtArc
							(setq LstOut (append LstOut (list itm)))
						)
						
						(if (not (member (list (car p2) (cadr p2)) LstOut))
							(setq LstOut (append LstOut (list (list (car p2) (cadr p2)))))
						)
					)
					
					(progn
						(if (not (member (list (car p1) (cadr p1)) LstOut))
							(setq LstOut (append LstOut (list (list (car p1) (cadr p1)))))
						)
						(if (not (member (list (car p2) (cadr p2)) LstOut))
							(setq LstOut (append LstOut (list (list (car p2) (cadr p2)))))
						)
						
					)
				)
				(setq conta  (1+ conta))
			)
			
			(setq conta 0)
			;(setq Rtn (list (nth 0 LstOut)))
			
			(setq Perimeter 0)
 			(repeat (length LstOut)
				(cond
					((< conta (- (length LstOut) 1))
						(setq Perimeter (+ Perimeter (distance (nth conta LstOut) (nth (1+ conta) LstOut))))
					)
					((= conta (- (length LstOut) 1))
						(setq Perimeter (+ Perimeter (distance (nth conta LstOut) (nth 0 LstOut))))
					)
				)
				(setq conta (1+ conta))
			)
		)
	)
	(list LstOut Perimeter)
)