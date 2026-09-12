;
(defun ImportDxf_ (/ FillLstDxf ReadFileCsvInfoDxf
					 FileCsv LstDataDxf CncPathEasyCut$)

	(defun FillLstDxf (LstFile /  DataDxf itm Rtn)
		(setq DataDxf (list "-" "-" "-" "-" "-" "-" "OK"))
		(foreach itm LstFile
			(setq Rtn (append Rtn (list (cons itm DataDxf))))  
		)
		Rtn
	)
	;
	(defun ReadFileCsvInfoDxf (FileCsv / CodError Stream LineRead LineSplit LstLineRead Available)
	
		(setq CodError 0)
		(if FileCsv
			(progn
				(setq Stream (open FileCsv "r"))
				(if (not Stream)
					(progn
						(alert (strcat "ERRORE!! apertura file -> " FileCsv))
						(setq CodError 1)
					)
					(setq LineRead (read-line Stream))
				)
				
				(if (not LineRead)
					(progn
						(alert (strcat "ERRORE!! file vuoto -> " FileCsv))
						(setq CodError 2)
						(close Stream)
					)
				)
				
				(if (= CodError 0)
					(progn
						(while LineRead
							;True;C:\EasyCut\ExampleDxf\DXF7\0002020.dxf;-;-;-;-;-;-;
							;True;C:\EasyCut\ExampleDxf\DXF7\0002021.dxf;-;-;-;-;-;-;
							(setq LineRead (vl-string-right-trim " " (vl-string-left-trim " " LineRead)))
							(setq LineSplit (Splitxt LineRead ";"))
							(if (= (length LineSplit) 8)
								(progn
									(if (findfile (nth 1 LineSplit))
										(setq Available "OK")
										(setq Available "NO")
									)
									(setq LstLineRead 	(append LstLineRead (list 	(list 	(nth 1 LineSplit) ; file name
																							(nth 2 LineSplit) ; order name
																							(nth 3 LineSplit) ; phase name
																							(nth 4 LineSplit) ; mark name
																							(nth 5 LineSplit) ; quantity
																							(nth 6 LineSplit) ; thickness
																							(nth 7 LineSplit) ; material
																							Available
																				))))
								)
								(progn
									(setq CodError 3)
									(alert (strcat "Riga non formattata correttamente" LineRead))
								)
							)
							(setq LineRead (read-line Stream))
						)
						(close Stream)
					)
				)
			)
		)
		LstLineRead
	)		
	;
	; Main
	;
	(if (setq FileCsv (vl-registry-read EasyCutRegistryPath$ "PathDxfJob"))
		(setq LstDataDxf (ReadFileCsvInfoDxf FileCsv))
		(progn
			(setq CncPathEasyCut$ (vl-registry-read EasyCutRegistryPath$ "PathNc"))
			(setq LstDataDxf (FillLstDxf (LM:getfiles "Seleziona file" CncPathEasyCut$ "dxf")))
		)
	)
	
	(if LstDataDxf
		(GuiSelPiecesDxf LstDataDxf)
	)
)
;
;
(defun ImportShapeDxf (/ Message
						 LstFileDxf FileCsv Rtn Ssel MinMaxSsel MinCatch MaxCatch)


	(defun Message (/ Msg)
		(setq Msg "")

		(if $DxfRemoveSingleObject
			(setq Msg (strcat Msg "\nVerranno rimosse le entita' senza collegamento"))
		)
		(setq Msg (strcat Msg "\nVerranno mantenute le entita' con linea CONTINUA"))
		(if $DxfClosePolyline
			(setq Msg (strcat Msg "\nLe polilinee verranno chiuse"))
		)
		(if $DxfExplodeBlocks
			(setq Msg (strcat Msg "\nI blocchi verranno esplosi"))
		)
		(if $DxfPurgePolyline
			(setq Msg (strcat Msg "\nLe polilinee vengono semplificate nel numero di vertici"))
		)
		(if $Seg2Arc
			(progn
				(setq Msg (strcat Msg "\nI segmenti verranno convertiti in archi"))
				(setq Msg (strcat Msg "\n     lunghezza massima segmenti per conversione in archi " (LM:rtos $Seg2Arc_MaxLgSeg2Arc     2 2)))
				(setq Msg (strcat Msg "\n     quantita' minima segmenti per conversione in archi " (LM:rtos $Seg2Arc_MinQtySeg2Arc    2 2)))
				(setq Msg (strcat Msg "\n     tolleranza controllo centro archi " 				   (LM:rtos $Seg2Arc_AcuracyCenterArc 2 2)))
			)
		)
		(if $Overlapp
			(progn
				(setq Msg (strcat Msg "\nVerra' eseguito il controllo di sovrapposizione"))
				(setq Msg (strcat Msg "\n     tolleranza controllo centro cerchi e archi " 		(LM:rtos $OverlappAcuracyCenter    2 2)))
				(setq Msg (strcat Msg "\n     tolleranza controllo raggi " 						(LM:rtos $OverlappAcuracyRadius    2 2)))
				(setq Msg (strcat Msg "\n     tolleranza distanza vertici " 					(LM:rtos $OverlappAcuracyPoint 	   2 2)))
				(setq Msg (strcat Msg "\n     tolleranza controllo collinearita' punti retta " 	(LM:rtos $OverlappAcuracyCollinear 2 2)))
				(setq Msg (strcat Msg "\n     tolleranza controllo angoli archi " 				(LM:rtos $OverlappAcuracyAngleArc  2 2)))
			)
		)
		(setq Msg (strcat Msg "\nVerranno rimosse le entita' con lunghezza <=" (LM:rtos $RemoveAmbiguosLength 2 2)))
		(LM:popup "Import DXF" Msg (+ 0 64 4096))
	)
	;
	;
	(vl-registry-write EasyCutRegistryPath$ "Sentinel" "0")
	;(startapp (strcat GuiPathEasyCut$ "DataGrid.exe"))
	(startapp (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Apps\\DataGrid.exe"))
	(while (= (vl-registry-read EasyCutRegistryPath$ "Sentinel") "0"))
	;(alert (vl-registry-read EasyCutRegistryPath$ "Sentinel"))
	
	(cond 
		((= (vl-registry-read EasyCutRegistryPath$ "Sentinel") "1")
			(setq LstFileDxf (GetLstFileDxf))
			(if LstFileDxf
				(progn
					(Message)
					(setq Rtn  (PreviewShapeDxf LstFileDxf))
					(setq Ssel (NestingShapeDxf (car Rtn) (cadr Rtn) (getvar "LASTPOINT") LstFileDxf))
				)
			)
		)
		((= (vl-registry-read EasyCutRegistryPath$ "Sentinel") "2")
			(if (setq FileCsv (vl-registry-read EasyCutRegistryPath$ "PathDxfJob"))
				(ShowDxf FileCsv)
			)
		)
	)
	
	(princ)
)
;
;
;
(defun NestingShapeDxf (SselShape LstDimBom PtInsert LstFileShapeDxf / ControlEname
																	   Dlx Dly conta itm xmin ymin xmax ymax SsgetList
																	   MSecStart MSecEnd
																	   IdOrder IdPhase IdIdentification IdQuantity IdThickness IdQuality 
																	   LstEname EnameShape)
																	   
	(defun ControlEname (LstEname / Rtn itm)
		(setq Rtn T)
		(foreach itm (cdr LstEname)
			(if (not (PoligonInsidePoligon02 (car LstEname) itm))  
				(setq Rtn nil)
			)
		)
		Rtn
	)
	;
	;
	;
	(if (and SselShape LstDimBom PtInsert)
		(progn

			(setq Dlx (- (nth 0 PtInsert) (nth 0 (car (car LstDimBom)))))
			(setq Dly (- (nth 1 PtInsert) (nth 1 (car (car LstDimBom)))))
			(setq conta 0)
			
			(StartProgressBar "Preview:" (length LstFileShapeDxf))
			
			(foreach itm LstDimBom
			
				(UpDateProgressBar)
				(setq MSecStart (getvar "MILLISECS"))
				
				
				(setq xmin (+ Dlx (nth 0 (nth 0 itm))))
				(setq ymin (+ Dly (nth 1 (nth 0 itm))))
				(setq xmax (+ Dlx (nth 0 (nth 2 itm))))
				(setq ymax (+ Dly (nth 1 (nth 2 itm))))
				(ZoomWindow01 (list xmin ymin) (list xmax ymax))
				(setq SsgetList (ssget "_C" (list xmin ymin) (list xmax ymax) '((-4 . "<OR")
																							(0 . "Arc")      (0 . "Line")
																							(0 . "Polyline") (0 . "LwPolyline")
																							(0 . "Insert")   (0 . "Point")
																							(0 . "Circle")   (0 . "Ellipse")
																							;(0 . "Text")     (0 . "Mtext")
																				(-4 . "OR>"))))
				(if (FillSsel SsgetList)
					(progn
						(ZoomSsel SsgetList 10.0)
						
				
						;(getstring "<prima>")
						(setq LstEname (ChkDxfEntity SsgetList))
						;(getstring "<dopo>")
						
						
						(if LstEname
							(if (ControlEname LstEname)
								(progn

									(setq IdOrder 			(nth 1 (nth conta LstFileShapeDxf)))
									(setq IdPhase 			(nth 2 (nth conta LstFileShapeDxf)))
									(setq IdIdentification 	(nth 3 (nth conta LstFileShapeDxf)))
									(setq IdQuantity	 	(nth 4 (nth conta LstFileShapeDxf)))
									(setq IdThickness	 	(nth 5 (nth conta LstFileShapeDxf)))
									(setq IdQuality		 	(nth 6 (nth conta LstFileShapeDxf)))

									(princ (strcat "\n" IdOrder " " IdPhase " " IdIdentification))
									(setq EnameShape (car LstEname))
									(AssignNameShape EnameShape (list IdIdentification "1" IdOrder IdPhase IdQuality IdThickness (Today) IdQuantity))
									(InquadraShape   EnameShape nil)
								)
							)
						)
						(setq MSecEnd (getvar "MILLISECS"))
						(princ "\n") (princ (car (nth conta LstFileShapeDxf)))
						(princ " Timing  ImportDxf ") (princ (/ (- MSecEnd MSecStart) 1000.0))
						(setq conta (1+ conta))
					)
				)
			)
			(ClearProgressBar)
		)
	)
)
;
;
;
(defun ChkDxfEntity (SsgetList / *error* 
								 SsgetBlock SsgetWork Itm LstRtn Ssel Rtn)

    (defun *error* ( msg )
        (LM:endundo (LM:acdoc))
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )
	;
	; Main ++++++++++++++++++++++
	;
	(LM:startundo (LM:acdoc))
	
	(if (and (setq SsgetBlock (FilterEntitySelectionByName SsgetList (list "INSERT"))) $DxfExplodeBlocks)
		(setq SsgetWork (LstEname->Ssget (LM:burst SsgetBlock T)))
		(setq SsgetWork (ssadd))
	)
	(foreach Itm (LM:ss->ent SsgetList)
		(ssadd Itm SsgetWork)
	)
	(setq LstRtn (PorcessDxfEntity SsgetWork))
	;			0            1              2                3			   4
	; (list intersect  open polyline  close polyline  singol line/arc	circle)
	;
	; ***********************************************************************
	(if $DxfRemoveSingleObject
		(DeleteEntity (nth 3 LstRtn))
	)
	; ***********************************************************************
	(if $DxfClosePolyline
		(progn
			(foreach Itm (nth 1 LstRtn)
				(vla-put-closed (vlax-ename->vla-object Itm) :vlax-true)
			)
			(setq LstPoly (append (nth 1 LstRtn) (nth 2 LstRtn)))
		)
		(setq LstPoly (nth 2 LstRtn))
	)
	; ***********************************************************************
	
	(setq Rtn (UpdateEntityType (SortArea (append LstPoly (nth 4 LstRtn)) 1)))
	
	(if $DxfPurgePolyline 
		(foreach itm Rtn
			(if (= (cdr (assoc 0 (entget itm))) "LWPOLYLINE") 
				(setq Rtn (subst (PurgePolyline itm) itm Rtn))
			)
		)
	)
	
	(LM:endundo (LM:acdoc))
	Rtn
)
;
;
;
(defun PorcessDxfEntity (SsgetList / Ssel itm 
									 SsgetLine SsgetArc SsgetCircle SsgetCircle+Arc SsgetArc SsgetLine+Arc SsgetEllipse
									 Ename Obj CheckPedit
									 Rtn1 Rtn2 Rtn3 Rtn4)
									 
									 
	;
	; La procedura elimina :
	;	1. Punti
	;	
	;
	; La procedura restituisce la segunte lista : ( (lista line o archi che si intersecano già presenti nel Dxf)
	;											    (lista polyline aperte)
	;												(lista polyline chiuse)
	;												(lista line o archi singoli già presenti nel Dxf)
	;
	(setq Ssel (ExplodeLwPolylineAndPolyline SsgetList))
	(setq Ssel (RemoveEntityNotLtype Ssel (list "Continuous")))
	(setq Ssel (RemoveEntity 		 Ssel (list "POINT")))
	(setq Ssel (RemoveAmbiguosEntity Ssel (list "LINE" "ARC" "CIRCLE" "ELLIPSE") $RemoveAmbiguosLength))
	
	(foreach itm (LM:ss->ent (FilterEntitySelectionByName Ssel (list "LINE" "ARC" "CIRCLE")))
		(ChangeZAxse itm)
		(FlattEntity itm)
	)
	;*************************************************************************************************
	(if $Overlapp
		(progn
			(setq SsgetLine       (MyOverKill Ssel "LINE"))
			(setq SsgetArc        (MyOverKill Ssel "ARC"))
			(setq SsgetCircle     (MyOverKill Ssel "CIRCLE"))
			(setq SsgetCircle+Arc (MyOverKill (MergeSSel (list SsgetArc SsgetCircle)) "CIRCLE ARC"))
			(setq SsgetArc   	  (FilterEntitySelectionByName SsgetCircle+Arc (list "ARC")))
			(setq SsgetLine+Arc   (MergeSSel (list SsgetArc SsgetLine)))
		)
		(progn
			(setq SsgetLine+Arc   (FilterEntitySelectionByName Ssel (list "LINE" "ARC")))
			(setq SsgetCircle     (FilterEntitySelectionByName Ssel (list "CIRCLE")))
		)
	)
	;**************************************************************************************************
	(setq SsgetEllipse (FilterEntitySelectionByName Ssel (list "ELLIPSE")))
	(foreach Itm (LM:ss->ent SsgetEllipse)
		(setq Ename (Ellipse2LwPolyline itm nil))

		(if (not (ClosePolyline Ename $MaxOpenPolyline))
			(progn
				(if (not SsgetLine+Arc) (setq SsgetLine+Arc (ssadd)))
				(foreach Obj (LwPolyToSegment Ename nil)
					(ChangeZAxse (vlax-vla-object->ename Obj))
					(FlattEntity (vlax-vla-object->ename Obj))
					(ssadd (vlax-vla-object->ename Obj) SsgetLine+Arc)
				)
				(entdel Itm)
			)
		)
		(entdel Ename)
	)
	; created Lwpolyline ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if SsgetLine+Arc
		(setq CheckPedit (MyPedit3 SsgetLine+Arc $OverlappAcuracyPoint))
	)
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(foreach Itm (car CheckPedit)
		(if (>= (vlax-get (vlax-ename->vla-object Itm) 'area) 0.01)
			(if (= (vla-get-closed (vlax-ename->vla-object Itm)) :vlax-false)
				(if (ClosePolyline Itm $MaxOpenPolyline)
					(setq Rtn3 (append Rtn3 (list Itm)))
					(setq Rtn2 (append Rtn2 (list Itm)))
				)
				(setq Rtn3 (append Rtn3 (list Itm)))
			)			
			(DeleteEntity (list Itm))
		)
	)
	
	(foreach Itm (cadr CheckPedit)
		(if (or (= (vlax-get-property  (vlax-ename->vla-object Itm) 'ObjectName) "AcDbArc")
			    (= (vlax-get-property  (vlax-ename->vla-object Itm) 'ObjectName) "AcDbLine")
			)
			(setq Rtn4 (append Rtn4 (list Itm)))
		)
	)
	;
	;    intersect	 open polyline  close polyline  singol line/arc	     singol circle
	;        v             v              v             v 				      v
	(list   Rtn1          Rtn2          Rtn3          Rtn4			(LM:ss->ent	SsgetCircle))
)
;
;
;
(defun PreviewShapeDxf (LstFileShapeDxf / 	*error* LM:startundo LM:endundo LM:acdoc
											Preview MinMaxSsel MinCatch MaxCatch Rtn)

	(defun *error* ( msg )
        (LM:endundo (LM:acdoc))
		(DeleteSsel (nth 0 Preview))
		;(command "_undo" "1")
        ;(if (not (wcmatch (strcase msg) "*break,*cancel*,*exit*"))
        ;    (princ (strcat "\nError: " msg))
        ;)
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
	(if LstFileShapeDxf
		(progn
			(setq Preview (PreviewNestingShapeDxf LstFileShapeDxf))
	
			(if (and (nth 0 Preview) (nth 1 Preview) (nth 2 Preview)) 
				(progn
					(setq MinMaxSsel (LM:SSBoundingBox (nth 0 Preview)))
					(setq MinCatch 	 (list (- (nth 0 (nth 0 MinMaxSsel)) 100)
									       (- (nth 1 (nth 0 MinMaxSsel)) 100)
								     )
					)
					(setq MaxCatch 	 (list (+ (nth 0 (nth 2 MinMaxSsel)) 100)
										   (+ (nth 1 (nth 2 MinMaxSsel)) 100)
								     )
					)			
					(vla-ZoomWindow (vlax-get-acad-object) (vlax-3d-point MinCatch) (vlax-3d-point MaxCatch))			
					
					(command "._Move" (nth 0 Preview) "" (car MinMaxSsel) pause)
					(while (not (FindAreaAvailable (nth 0 Preview)))
						(command "._Move" (nth 0 Preview) "" (getvar "LASTPOINT") pause)
					)
					(DeleteSsel (nth 1 Preview))
					(setq Rtn (list (nth 0 Preview) (nth 2 Preview)))
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
(defun ReadFileCsvInfoDxf (FileCsv / CodError Stream LineRead LineSplit LstLineRead)
	
	(setq CodError 0)
	(if FileCsv
		(progn
			(setq Stream (open FileCsv "r"))
			(if (not Stream)
				(progn
					(alert (strcat "ERRORE!! apertura file -> " FileCsv))
					(setq CodError 1)
				)
				(setq LineRead (read-line Stream))
			)
			
			(if (not LineRead)
				(progn
					(alert (strcat "ERRORE!! file vuoto -> " FileCsv))
					(setq CodError 2)
					(close Stream)
				)
			)
			
			(if (= CodError 0)
				(progn
					(while LineRead
						;True;C:\EasyCut\ExampleDxf\DXF7\0002020.dxf;-;-;-;-;-;-;
						;True;C:\EasyCut\ExampleDxf\DXF7\0002021.dxf;-;-;-;-;-;-;
						(setq LineRead (vl-string-right-trim " " (vl-string-left-trim " " LineRead)))
						(setq LineSplit (Splitxt LineRead ";"))
						(if (= (length LineSplit) 8)
							(if (= (strcase (nth 0 LineSplit)) "TRUE")
								(setq LstLineRead 	(append LstLineRead (list 	(list 	(nth 1 LineSplit) ; file name
																						(nth 2 LineSplit) ; order name
																						(nth 3 LineSplit) ; phase name
																						(nth 4 LineSplit) ; mark name
																						(nth 5 LineSplit) ; quantity
																						(nth 6 LineSplit) ; thickness
																						(nth 7 LineSplit) ; material
																				))))
							)
							(progn
								(setq CodError 3)
								(alert (strcat "Riga non formattata correttamente" LineRead))
							)
						)
						(setq LineRead (read-line Stream))
					)
					(close Stream)
				)
			)
		)
	)
	LstLineRead
)	
;
;
;
(defun GetLstFileDxf (/ DataDxf itm)

	(PurgeAllGroupUnentity)
	
	(setq DataDxf (ReadFileCsvInfoDxf (vl-registry-read EasyCutRegistryPath$ "PathDxfJob")))
	;(if DataDxf
	;	(foreach itm DataDxf
	;			(setq ListFile (append ListFile (list (car itm))))
	;	)
	;)
	DataDxf
)
;
;
;
(defun FilterEnameDxf (LstEnameDxf Remove / RemoveBadEname RemoveBadLayer RemovePspaceEntity
											LstLayer itm LstExplode Rtn)

	(defun RemoveBadEname (LstEname Remove / LstGoodEname itm Rtn)
	
		(setq LstGoodEname 	'("LWPOLYLINE" "LINE" "ARC" "CIRCLE" "ELLIPSE" "TEXT" "MTEXT"))
		
		(foreach itm LstEname
			(if (entget itm)
				(if (not (member (cdr (assoc 0 (entget itm))) LstGoodEname))
					(if Remove (DeleteEntity (list itm)))
					(setq Rtn (cons itm Rtn))
				)
			)
		)
		Rtn
	)
	;
	(defun RemoveBadLayer (LstEname LstLayer / layeron freeze itm NameLayer DataLayer Rtn)
		
		(setq layeron "On")
		(setq freeze  "Thawed")
		
		;(princ "\nRemoveBadLayer Numero entita ") (princ (length LstEname)) (getstring "<>")
		(foreach itm LstEname
			(setq NameLayer (vla-get-layer (vlax-ename->vla-object itm)))
			
			;   layeron  freeze
			;      v       v
			;("0" "On" "Thawed" "Not locked" "White" "Continuous" "Default" "Color_7" "Plottable" "Not frozen")
			
			(setq DataLayer (assoc NameLayer LstLayer))
			(setq _remove nil)
			(if (and (= (nth 1 DataLayer) layeron)
					 (= (nth 2 DataLayer) freeze)
				)
					 (setq Rtn (cons itm Rtn)) 

					 (DeleteEntity (list itm))
			)
		)
		;(princ "\nRemoveBadLayer Numero entita filtrate ") (princ (length Rtn)) (getstring "<>")
		Rtn
	)
	;
	(defun RemovePspaceEntity (LstEname / itm Rtn)
		;(princ "\nRemovePspaceEntity Numero entita ") (princ (length LstEname)) (getstring "<>")
		(foreach itm LstEname
			(if (CheckIfPaperSpace itm) (DeleteEntity (list itm)) (setq Rtn (cons itm Rtn)))
		)
		;(princ "\nRemovePspaceEntity Numero entita filtrate ") (princ (length Rtn)) (getstring "<>")
		Rtn
	)
	;
	; Main +++++
	;
	(setq LstLayer	(ax:layer-list))
	(setq Rtn 		(RemovePspaceEntity LstEnameDxf))
	(setq Rtn 		(RemoveBadLayer     Rtn LstLayer))
	
	(foreach itm Rtn
		(cond
			((= (cdr (assoc 0 (entget itm))) "INSERT")
				(if $DxfExplodeBlocks
					(setq LstExplode (append LstExplode (LM:burst (LstEname->Ssget (list itm)) T)))
				)
			)
			((= (cdr (assoc 0 (entget itm))) "POLYLINE")
				(Polyline2LwPolyline itm)
			)
		)
	)
	(foreach itm LstExplode
		(if (= (cdr (assoc 0 (entget itm))) "POLYLINE")
			(Polyline2LwPolyline itm)
		)
	)
	
	(setq Rtn (RemoveBadEname (LM:ListUnion Rtn LstExplode) Remove))
	
	(PurgeBlockLoop)
	Rtn
)
;
;
;
(defun PreviewNestingShapeDxf (LstFileShapeDxf / DimScreen StepColumn Xdstv Ydstv StartXdstv StartYDstv LstY
												 i Rtn1 Rtn2 Rtn3 NameFile LstBlockPre InsertPoint LstEnameDxfImport
												 Ssel1 Ssel2 itm minmax  Width Height point1 point2 conta)




	(setq DimScreen (VpCoords))
	(setq StepColumn 1)
	(setq Xdstv (/ (+ (nth 0 (nth 0 DimScreen)) (nth 0 (nth 1 DimScreen))) 2.0))
	(setq Ydstv (/ (+ (nth 1 (nth 0 DimScreen)) (nth 1 (nth 1 DimScreen))) 2.0))
	(setq StartXdstv Xdstv)
	(setq StartYDstv Ydstv)
	(setq LstY nil)
	
	(setq Rtn1 (ssadd))
	(setq Rtn2 (ssadd))

	(StartProgressBar "Preview:" (length LstFileShapeDxf))
	
	(foreach NameFile LstFileShapeDxf
	
		(foreach itm (GetBlockList) (PurgeBlock itm))
		
		(UpDateProgressBar)
		
		(princ (strcat "\nFile name read " (car NameFile)))
		(setq InsertPoint (list 0.0 0.0 0.0))
		(setq LstEnameDxfImport (ImportDxf (car NameFile) InsertPoint))
		(setq LstEnameDxfImport (FilterEnameDxf LstEnameDxfImport T))

		(if LstEnameDxfImport
			(progn
				(setq Ssel1 (LstEname->Ssget LstEnameDxfImport))
				(setq Ssel2 (PreviewInquadraShapeDxf Ssel1))
				
				(setq minmax 		(LM:SSBoundingBox Ssel2))
				(setq Width			(abs (- (nth 0 (nth 1 minmax)) (nth 0 (nth 0 minmax)))))
				(setq Height		(abs (- (nth 1 (nth 2 minmax)) (nth 1 (nth 1 minmax)))))
				
				(setq LstY (append LstY (list Height)))
				
				(setq point1 (vlax-3d-point  (nth 0 (nth 0 minmax))   (nth 1 (nth 0 minmax))   0.0)
					  point2 (vlax-3d-point  StartXDstv StartYDstv  0.0)
				)
				(foreach itm (LM:ss->ent Ssel1)
					(vla-Move (vlax-ename->vla-object itm) point1 point2)
				)
				(foreach itm (LM:ss->ent Ssel2)
					(vla-Move (vlax-ename->vla-object itm) point1 point2)
				)
				
				;(setq conta 0)
				;(repeat (sslength Ssel1)
				;		(if (not (member (vlax-get-property (vlax-ename->vla-object (ssname Ssel1 conta)) 'ObjectName) LstBadEntity))
				;			(vla-Move (vlax-ename->vla-object (ssname Ssel1 conta)) point1 point2)
				;		)
				;		(setq conta (1+ conta))
				;)
				;(setq conta 0)
				;(repeat (sslength Ssel2)
				;		;(princ "\n")
				;		;(princ (vlax-get-property (vlax-ename->vla-object (ssname Ssel conta)) 'ObjectName))
				;		;(getstring "***")
				;		(if (not (member (vlax-get-property (vlax-ename->vla-object (ssname Ssel2 conta)) 'ObjectName) LstBadEntity))
				;			(vla-Move (vlax-ename->vla-object (ssname Ssel2 conta)) point1 point2)
				;		)
				;		(setq conta (1+ conta))
				;)
		
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
				(repeat (sslength Ssel1)
						(ssadd (ssname Ssel1 conta) Rtn1)
						(setq conta (1+ conta))
				)
				(setq conta 0)
				(repeat (sslength Ssel2)
						(ssadd (ssname Ssel2 conta) Rtn1)
						(setq conta (1+ conta))
				)
				(setq conta 0)
				(repeat (sslength Ssel2)
						(ssadd (ssname Ssel2 conta) Rtn2)
						(setq conta (1+ conta))
				)
				
				(setq Rtn3 (append Rtn3 (list (LM:SSBoundingBox Ssel2))))
				(setq Ssel1 nil)
				(setq Ssel2 nil)
			)
			(progn
				(alert (strcat "File " (car NameFile) " privo di entita' significative "))
				(princ (strcat "\nFile " (car NameFile) " privo di entita' significative "))
			)
		)
	)
	(ClearProgressBar)
	(list Rtn1 Rtn2 Rtn3)
)
;
; 
;
(defun PreviewInquadraShapeDxf (Ssel / minmax WidthShape HeightShape XcenterShape YcenterShape Rpx  Rpy x y	BaseQuadro AltezzaQuadro
									   modelSpace Obj1 Obj2 Obj3 Obj4 Obj5 Obj6 Obj7 Obj8 P1Bom P2Bom P3Bom P4Bom Rtn)

	(if Ssel
		(progn
			(setq minmax 		(LM:SSBoundingBox Ssel))
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

			(setq BaseQuadro    (/ WidthShape  (nth 0 Rpx)))
			(setq AltezzaQuadro (/ HeightShape (nth 0 Rpy)))
			
			
			(if (< BaseQuadro     (nth 0 DistColumn$))
				(setq BaseQuadro  (nth 0 DistColumn$))
			)
			
			(setq modelSpace (vla-get-modelspace(vla-get-activedocument (vlax-get-acad-object))))
			
			; Riquadro virtuale	
			
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
			
			; Cartiglio virtuale
			
			(setq P1Bom (list  (- XcenterShape (/ BaseQuadro 2.0)) 
							   (- (- YcenterShape (/ AltezzaQuadro 2.0)) HBom$ )))

			(setq P2Bom (list (+ (car P1Bom) BaseQuadro) (cadr P1Bom)))
			
			(setq P3Bom (list (+ (car P1Bom) BaseQuadro) (+ (cadr P1Bom) HBom$)))
			
			(setq P4Bom (list (car P1Bom)                (+ (cadr P1Bom) HBom$)))
			
			
			(setq Obj5 (vla-AddLine modelSpace  (vlax-3d-point P1Bom) (vlax-3d-point P2Bom)))
			(setq Obj6 (vla-AddLine modelSpace  (vlax-3d-point P2Bom) (vlax-3d-point P3Bom)))							
			(setq Obj7 (vla-AddLine modelSpace  (vlax-3d-point P3Bom) (vlax-3d-point P4Bom)))							
			(setq Obj8 (vla-AddLine modelSpace  (vlax-3d-point P1Bom) (vlax-3d-point P4Bom)))							
													
			(setq Rtn (LstEname->Ssget (append 	;(LM:ss->ent Ssel)
												(list 	(vlax-vla-object->ename Obj1)
														(vlax-vla-object->ename Obj2)
														(vlax-vla-object->ename Obj3)
														(vlax-vla-object->ename Obj4)
														(vlax-vla-object->ename Obj5)
														(vlax-vla-object->ename Obj6)
														(vlax-vla-object->ename Obj7)
														(vlax-vla-object->ename Obj8)
												))))
		)
	)
	Rtn
)
;
;
;
(defun ClosePolyline (EnamePolyline MaxGap / Rtn)
	
	(setq Rtn T)
	(if (and EnamePolyline MaxGap)
		(if (= (cdr (assoc 0 (entget EnamePolyline))) "LWPOLYLINE")
			(if (= (vla-get-closed (vlax-ename->vla-object EnamePolyline)) :vlax-false)
				(if (< (distance (vlax-curve-getstartpoint EnamePolyline) (vlax-curve-getendpoint EnamePolyline)) MaxGap)
					(vla-put-closed (vlax-ename->vla-object EnamePolyline) :vlax-true)
					(setq Rtn nil)
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun CheckIntersection01 (Ssel Fuzz / AlongLine AlongArc MyIntersectWith IfIntersection
										Lst1 Lst2 Itm1 Itm2 Obj1 Obj2 i_pts Px Pa Pb Pc Pd Rtn)

	(defun AlongLine (Ename Fuzz / Obj Ps Pe Rtn)
		(if (and Ename Fuzz)
			(progn
				(setq Obj (vlax-ename->vla-object Ename))
				(setq Ps (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Obj))))
				(setq Pe (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint   Obj))))
				(setq Ps (prol (car Pe) (cadr Pe) (car Ps) (cadr Ps)  Fuzz))
				(setq Pe (prol (car Ps) (cadr Ps) (car Pe) (cadr Pe)  Fuzz))
				(setq Rtn (entmakex (list (cons 0  "LINE") (cons 10 Ps) (cons 11 Pe) (list 210 0.0 0.0 1.0))))
			)
		)
		Rtn
	)
	;
	;
	;
	(defun AlongArc (Ename Fuzz / Obj Center Radius SA EA Ang Rtn)
		(if (and Ename Fuzz)
			(progn
				(setq Obj (vlax-ename->vla-object Ename))
				(setq Center (vlax-safearray->list (vlax-variant-value (vla-get-Center Obj))))
				(setq Radius (vla-get-Radius Obj))
				(setq SA (vla-get-StartAngle Obj))
				(setq EA (vla-get-EndAngle Obj))
				(setq Ang (/ Fuzz Radius))
				(setq Rtn (entmakex (list (cons 0 "ARC") (cons 10 Center) (cons 40 Radius) (cons 50 (- SA Ang)) (cons 51 (+ EA Ang)) (list 210 0.0 0.0 1.0))))
			)	
		)
		Rtn
	)
	;
	;
	;
	(defun MyIntersectWith (Ename1 Ename2 Fuzz / Obj1 Obj2 RtnEanme1 RtnEname2 i_pts conta Rtn)
	
		(if (and Ename1 Ename2)
			(progn
				(setq Obj1 (vlax-ename->vla-object Ename1))
				(setq Obj2 (vlax-ename->vla-object Ename2))
				
				(if (= (vlax-get-property Obj1 'ObjectName) "AcDbArc")  (setq RtnEname1 (AlongArc  Ename1 Fuzz)))
				(if (= (vlax-get-property Obj1 'ObjectName) "AcDbLine") (setq RtnEname1 (AlongLine Ename1 Fuzz)))
				(if (= (vlax-get-property Obj2 'ObjectName) "AcDbArc")  (setq RtnEname2 (AlongArc  Ename2 Fuzz)))
				(if (= (vlax-get-property Obj2 'ObjectName) "AcDbLine") (setq RtnEname2 (AlongLine Ename2 Fuzz)))
					
				(setq i_pts  (vlax-variant-value (vla-IntersectWith (vlax-ename->vla-object RtnEname1)
																	(vlax-ename->vla-object RtnEname2) acExtendNone)))
				(entdel RtnEname1)
				(entdel RtnEname2)
				(setq conta 0)
				(if (> (vlax-safearray-get-u-bound i_pts 1) 0)
					(repeat (/ (length (vlax-safearray->list i_pts)) 3)
						(setq Rtn (append Rtn (list (list (nth (+ 0 conta) (vlax-safearray->list i_pts))
														  (nth (+ 1 conta) (vlax-safearray->list i_pts))
													      (nth (+ 2 conta) (vlax-safearray->list i_pts))
											  ))
								  )
						)
						(setq conta (+ 3 conta))
					)
				)
			)
		)
		Rtn
	)
	;
	;
	;
	(defun IfIntersection (Pa Pb Pc Pd Px Fuzz / Rtn)
		
		(if (and Pa Pb Pc Pd Px)
			(cond
				((and (not (equal Px Pa Fuzz)) (not (equal Px Pb Fuzz)) (not (equal Px Pc Fuzz)) (equal Px Pd Fuzz))
					(setq Rtn T)
				)
				((and (not (equal Px Pa Fuzz)) (not (equal Px Pb Fuzz)) (equal Px Pc Fuzz) (not (equal Px Pd Fuzz)))
					(setq Rtn T)
				)
				((and (not (equal Px Pa Fuzz)) (equal Px Pb Fuzz) (not (equal Px Pc Fuzz)) (not (equal Px Pd Fuzz)))
					(setq Rtn T)
				)
				((and (equal Px Pa Fuzz) (not (equal Px Pb Fuzz)) (not (equal Px Pc Fuzz)) (not (equal Px Pd Fuzz)))
					(setq Rtn T)
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if Ssel
		(progn
			
			(setq Lst1 (reverse (cdr (reverse (LM:ss->ent Ssel)))))
			(setq Lst2 (cdr (LM:ss->ent Ssel)))
			
			(foreach Itm1 Lst1
				(setq Obj1 (vlax-ename->vla-object Itm1))
				(setq Pa (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Obj1))))
				(setq Pb (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint Obj1))))
				
				(foreach Itm2 Lst2
					(setq Obj2   (vlax-ename->vla-object Itm2))
					(setq Pc     (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Obj2))))
					(setq Pd     (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint Obj2))))
					
					(setq LstPx  (MyIntersectWith Itm1 Itm2 Fuzz))
					(if LstPx
						(progn
							;(princ "\nIntersezione ") (princ LstPx)
							(if (and (not (equal (car LstPx) Pa Fuzz)) (not (equal (car LstPx) Pb Fuzz)) 
									 (not (equal (car LstPx) Pc Fuzz)) (not (equal (car LstPx) Pd Fuzz)))
								(progn
									(if (not (member Itm1 Rtn)) (setq Rtn (append Rtn (list Itm1))))
									(if (not (member Itm2 Rtn)) (setq Rtn (append Rtn (list Itm2))))
								)
							)
							(if (IfIntersection Pa Pb Pc Pd (car LstPx) Fuzz) 
								(progn
									(if (not (member Itm1 Rtn)) (setq Rtn (append Rtn (list Itm1))))
									(if (not (member Itm2 Rtn)) (setq Rtn (append Rtn (list Itm2))))
								)
							)
						)
					)
				)
				(setq Lst2 (cdr Lst2))
			)
		)
	)
	Rtn
)
;
;
;
(defun MyOverKill (Ssel NameEntity  / SplitName SselByName LstCombine Loop Pos LstEname)
	;
	; Main
	;
	(if (and Ssel NameEntity)
		(progn
			(setq SplitName 		(splitxt NameEntity " "))
			(setq SselByName 		(FilterEntitySelectionByName Ssel SplitName))
			(if (setq LstCombine	(CombineList (LM:ss->ent SselByName) 2))
				(setq Loop T)
			)
			(setq Pos 0)
			(while Loop 
				
				(if (setq Rtn (OverlappEname (car (nth Pos LstCombine)) (cadr (nth Pos LstCombine))))
					(progn
						(setq LstEname 		(LM:ss->ent SselByName))
						(setq LstEname 		(append LstEname (list (cadr Rtn))))
						(setq LstEname 		(vl-remove (car  (nth Pos LstCombine)) LstEname))
						(setq LstEname 		(vl-remove (cadr (nth Pos LstCombine)) LstEname))
						(DeleteEntity       (list (car  (nth Pos LstCombine)) (cadr (nth Pos LstCombine))))
						(setq SselByName    (LstEname->Ssget LstEname))
						(setq LstCombine    (CombineList (LM:ss->ent SselByName) 2))
						(setq Pos 0)
					)
					(setq Pos (1+ Pos))
				)
				(if LstCombine
					(if (> (1+ Pos) (length LstCombine)) (setq Loop nil))
					(setq Loop nil)
				)
					
			)
		)
	)
	SselByName
)
;
;
;
(defun OverlappEname (Ename1 Ename2 / OverlappArcToArc    OverlappCircleToCircle 
									  OverlappArcToCircle OverlappLineToLine
									  Obj1 Obj2 Rtn)


	;
	(defun OverlappArcToArc (Ename1 Ename2 / IncludedAngle AngleArc 
											 Obj1 Obj2 Center1 Center2 Radius1 Radius2
											 S1 S2 E1 E2 Sp1 Sp2 Ep1 Ep2 As Ae Rtn)
												  
		; return :
		; nil 	nessuna intersezione
		; 1 	arco integralmente sovrapposte
		; 2 	arco Ename1 sovrappone l'arco Ename2
		; 3 	arco Ename2 sovrappone l'arco Ename1
		; 4 	gli archi Ename1 e Ename2 sono tra loro parzialmente sovrapposti
		; 5		gli archi sono continui
							
		(defun AngleArc (StartAng EndAng)
			(if (< EndAng StartAng)	
				(-(+ EndAng (* 2.0 pi)) StartAng)
				(- EndAng StartAng)
			)
		)
		;
		(defun IncludedAngle (StartAng EndAng CheckAng Fuzz)
		
			(if (and StartAng EndAng CheckAng)
				(progn
					(if (equal CheckAng (* 2.0 pi) Fuzz)
						(setq CheckAng1 0.0
							  CheckAng2 CheckAng
						)
						(setq CheckAng1 CheckAng
							  CheckAng2 CheckAng
						)
					)
						
					(cond 
						((equal (polar '(0.0 0.0) CheckAng 1.0) (polar '(0.0 0.0) StartAng 1.0) Fuzz)
							T
						)
						((equal (polar '(0.0 0.0) CheckAng 1.0) (polar '(0.0 0.0) EndAng 1.0) Fuzz)
							T
						)
						((and (> CheckAng1 StartAng) (< CheckAng1 EndAng))
							T
						)
						((and (> CheckAng2 StartAng) (< CheckAng2 EndAng))
							T
						)
					)
				)
			)
		)
		;
		; Main
		;
		(if (and Ename1 Ename2)
			(progn
				(setq Obj1 (vlax-ename->vla-object Ename1))
				(setq Obj2 (vlax-ename->vla-object Ename2))
				
				
				(if (and (= (vlax-get-property Obj1 'ObjectName) "AcDbArc")
						 (= (vlax-get-property Obj2 'ObjectName) "AcDbArc"))
					(progn
						(setq Center1 (vlax-safearray->list (vlax-variant-value (vla-get-Center Obj1))))
						(setq Center2 (vlax-safearray->list (vlax-variant-value (vla-get-Center Obj2))))
						(setq Radius1 (vla-get-Radius Obj1))
						(setq Radius2 (vla-get-Radius Obj2))
						
						(if (and (equal Center1 Center2 $OverlappAcuracyCenter) (equal Radius1 Radius2 $OverlappAcuracyRadius))
							(progn
								(setq S1  (vla-get-StartAngle Obj1))
								(setq E1  (vla-get-EndAngle   Obj1))
								(setq S2  (vla-get-StartAngle Obj2))
								(setq E2  (vla-get-EndAngle   Obj2))
								(setq Sp1 (vlax-get Obj1 'Startpoint))
								(setq Ep1 (vlax-get Obj1 'Endpoint))
								(setq Sp2 (vlax-get Obj2 'Startpoint))
								(setq Ep2 (vlax-get Obj2 'Endpoint))
								(if (equal E1 0.0 $OverlappAcuracyAngleArc) (setq E1 (* 2 Pi)))
								(if (equal E2 0.0 $OverlappAcuracyAngleArc) (setq E2 (* 2 Pi)))
								
								(cond
									((and (equal (distance Sp2 Ep1) 0.0 $OverlappAcuracyAngleArc) (equal (distance Sp1 Ep2) 0.0 $OverlappAcuracyAngleArc))
										(setq Rtn 5)	; cerchio
										(setq As 0.0 Ae 0.0)
									)
									((and (equal (distance Ep1 Ep2) 0.0 $OverlappAcuracyAngleArc) (equal (distance Sp1 Sp2) 0.0 $OverlappAcuracyAngleArc))
										(setq Rtn 1)	; archi uguali sovrapposti
										(setq As S1 Ae E1)
									)
									(t
										(cond 
											((and (IncludedAngle S1 E1 S2 $OverlappAcuracyAngleArc) (IncludedAngle S1 E1 E2 $OverlappAcuracyAngleArc) 
												  (IncludedAngle S2 E2 S1 $OverlappAcuracyAngleArc) (IncludedAngle S2 E2 E1 $OverlappAcuracyAngleArc))
												(setq Rtn 5)	; cerchio
												(setq As 0.0 Ae 0.0)
											)
											((and      (IncludedAngle S1 E1 S2 $OverlappAcuracyAngleArc) 
												  (not (IncludedAngle S1 E1 E2 $OverlappAcuracyAngleArc))
												       (IncludedAngle S2 E2 E1 $OverlappAcuracyAngleArc)
												  (not (IncludedAngle S2 E2 S1 $OverlappAcuracyAngleArc)))
												(setq Rtn 4)	; l'arco 1 e 2 sono parzialmente sovrapposti
												(setq As S1 Ae E2)
											)
											((and 	   (IncludedAngle S1 E1 E2 $OverlappAcuracyAngleArc) 
												  (not (IncludedAngle S1 E1 S2 $OverlappAcuracyAngleArc)) 
													   (IncludedAngle S2 E2 S1 $OverlappAcuracyAngleArc)
												  (not (IncludedAngle S2 E2 E1 $OverlappAcuracyAngleArc)))
												(setq Rtn 4)	; l'arco 1 e 2 sono parzialmente sovrapposti
												(setq As S2 Ae E1)
											)
											((and 	   (IncludedAngle S1 E1 S2 $OverlappAcuracyAngleArc)
													   (IncludedAngle S1 E1 E2 $OverlappAcuracyAngleArc) 
												  (not (IncludedAngle S2 E2 S1 $OverlappAcuracyAngleArc))
												  (not (IncludedAngle S2 E2 E1 $OverlappAcuracyAngleArc)))
												(setq Rtn 2)	; l' arco 1 sovrappone l'arco 2
												(setq As S1 Ae E1)
											)
											((and (not (IncludedAngle S1 E1 S2 $OverlappAcuracyAngleArc)) 
												  (not (IncludedAngle S1 E1 E2 $OverlappAcuracyAngleArc)) 
												       (IncludedAngle S2 E2 S1 $OverlappAcuracyAngleArc) 
													   (IncludedAngle S2 E2 E1 $OverlappAcuracyAngleArc))
												(setq Rtn 3)	; l' arco 2 sovrappone l'arco 1
												(setq As S2 Ae E2)
											)
										)
									)
								)
							)
						)
					)
				)
			)
		)
		(if Rtn 
			(if (equal As Ae $OverlappAcuracyAngleArc)
				(list Rtn (LM:MakeCircle (MidPoint Center1 Center2) (/ (+ Radius1 Radius2) 2.0)))
				(list Rtn (LM:MakeArc    (MidPoint Center1 Center2) (/ (+ Radius1 Radius2) 2.0) As Ae))
			)
		)
	)
	;
	;
	;
	(defun OverlappCircleToCircle (Ename1 Ename2 / Obj1 Obj2 Center1 Center2 Radius1 Radius2 Int Rtn)
												  
		; return :
		; nil 	nessuna intersezione
		; 1 	cerchi integralmente sovrapposti
		; 2 	cerchio Ename1 sovrappone cerchio Ename2
		; 3 	cerchio Ename2 sovrappone cerchio Ename1
		; 4 	i cerchi Ename1 e Ename2 sono tra loro parzialmente sovrapposti
		; 5		i cerchi sono tangenti
		;
		; Main
		;
		(if (and Ename1 Ename2)
			(progn
				(setq Obj1 (vlax-ename->vla-object Ename1))
				(setq Obj2 (vlax-ename->vla-object Ename2))
				
				
				(if (and (= (vlax-get-property Obj1 'ObjectName) "AcDbCircle")
						 (= (vlax-get-property Obj2 'ObjectName) "AcDbCircle"))
					(progn
						(setq Center1 (vlax-safearray->list (vlax-variant-value (vla-get-Center Obj1))))
						(setq Center2 (vlax-safearray->list (vlax-variant-value (vla-get-Center Obj2))))
						(setq Radius1 (vla-get-Radius Obj1))
						(setq Radius2 (vla-get-Radius Obj2))

						(cond 
							((equal Center1 Center2 $OverlappAcuracyCenter)
								(if (equal Radius1 Radius2 $OverlappAcuracyRadius)
									(setq Rtn (list 1 (LM:MakeCircle (MidPoint Center1 Center2) (/ (+ Radius1 Radius2) 2.0))))
									;(if (> Radius1 Radius2)
									;	(setq Rtn (list 2 (LM:MakeCircle (MidPoint Center1 Center2) Radius1)))
									;	(setq Rtn (list 3 (LM:MakeCircle (MidPoint Center1 Center2) Radius2)))
									;)
								)
							)
							(t
								(if (setq Int (LM:inters-circle-circle Center1 Radius1 Center2 Radius2))
									(progn
										(if (= (length Int) 2)
											(setq Rtn (list 4 (car (LM:ss->ent (LM:outline (LstEname->Ssget (list Ename1 Ename2)))))))
											(setq Rtn (list 5))
										)
									)
								)
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
	(defun OverlappArcToCircle (Ename1 Ename2 / Obj1 Obj2 Center1 Center2 Radius1 Radius2 Rtn)
	
		; return :
		; nil 	nessuna intersezione
		; 1 	cerchio integralmente sovrapposto all'arco
		;
		; Main
		;
		(if (and Ename1 Ename2)
			(progn
				(setq Obj1 (vlax-ename->vla-object Ename1))
				(setq Obj2 (vlax-ename->vla-object Ename2))
				
				
				(if (or (and (= (vlax-get-property Obj1 'ObjectName) "AcDbCircle")
							 (= (vlax-get-property Obj2 'ObjectName) "AcDbArc"))
						(and (= (vlax-get-property Obj1 'ObjectName) "AcDbArc")
							 (= (vlax-get-property Obj2 'ObjectName) "AcDbCircle"))
					)
					(progn
						(setq Center1 (vlax-safearray->list (vlax-variant-value (vla-get-Center Obj1))))
						(setq Center2 (vlax-safearray->list (vlax-variant-value (vla-get-Center Obj2))))
						(setq Radius1 (vla-get-Radius Obj1))
						(setq Radius2 (vla-get-Radius Obj2))
						(if (and (equal Center1 Center2 $OverlappAcuracyCenter) (equal Radius1 Radius2 $OverlappAcuracyRadius))
							(setq Rtn (list 1 (LM:MakeCircle (MidPoint Center1 Center2) (/ (+ Radius1 Radius2) 2.0))))
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
	(defun OverlappLineToLine (Ename1 Ename2 / PointOnLine ContnuosLine MergeLine
											   Obj1 Obj2
											   Pa Pb Pc Pd Rtn)
	
		; return :
		; nil 	nessuna intersezione
		; 1 	rette integralmente sovrapposte
		; 2 	retta Ename1 sovrappone la retta Ename2
		; 3 	retta Ename2 sovrappone la retta Ename1
		; 4 	le rette Ename1 e Ename2 sono tra loro parzialmente sovrapposte
		; 5 	le rette Ename1 e Ename2 sono continue
		
		(defun PointOnLine (P1 P2 Px Fuzz)
			(equal (+ (distance P1 Px) (distance P2 Px)) (distance P1 P2) Fuzz)
		)
		;
		;
		(defun ContnuosLine (Pa Pb Pc Pd Fuzz)
			(or (equal (Pt->3dPt (prol (car Pa) (cadr Pa) (car Pb) (cadr Pb) (distance Pc Pd))) Pd Fuzz)
				(equal (Pt->3dPt (prol (car Pa) (cadr Pa) (car Pb) (cadr Pb) (distance Pc Pd))) Pc Fuzz)
				(equal (Pt->3dPt (prol (car Pb) (cadr Pb) (car Pa) (cadr Pa) (distance Pc Pd))) Pd Fuzz)
				(equal (Pt->3dPt (prol (car Pb) (cadr Pb) (car Pa) (cadr Pa) (distance Pc Pd))) Pc Fuzz)
			 ) 
		)
		;
		;
		(defun MergeLine (Pa Pb Pc Pd Fuzz / Rtn)
		
			(setq Rtn (list Pa Pb Pc Pd))
			(if (PointOnLine Pa Pb Pc Fuzz) (setq Rtn (vl-remove Pc Rtn)))
			(if (PointOnLine Pa Pb Pd Fuzz) (setq Rtn (vl-remove Pd Rtn)))
			(if (PointOnLine Pc Pd Pa Fuzz) (setq Rtn (vl-remove Pa Rtn)))
			(if (PointOnLine Pc Pd Pb Fuzz) (setq Rtn (vl-remove Pb Rtn)))
			Rtn
		)
		;
		; Main
		;		
		(if (and Ename1 Ename2)
			(progn
				(setq Obj1 (vlax-ename->vla-object Ename1))
				(setq Obj2 (vlax-ename->vla-object Ename2))
				
				(if (and (= (vlax-get-property Obj1 'ObjectName) "AcDbLine")
						 (= (vlax-get-property Obj2 'ObjectName) "AcDbLine"))
					(progn
						(setq Pa (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Obj1)))
							  Pb (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint   Obj1)))
							  Pc (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Obj2)))
							  Pd (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint   Obj2)))
						)
						(if (LM:ListCollinear-p (list Pa Pb Pc Pd) $OverlappAcuracyCollinear)
							(if (not (ContnuosLine Pa Pb Pc Pd $OverlappAcuracyPoint))
								(cond
									((or (and (equal Pa Pc $OverlappAcuracyPoint) (equal Pb Pd $OverlappAcuracyPoint))
										 (and (equal Pa Pd $OverlappAcuracyPoint) (equal Pb Pc $OverlappAcuracyPoint))
									  )
										(setq Rtn (list 1 (LM:MakeLine Pa Pb)))  ; rette integralmente sovrapposte
									)
									((and (PointOnLine Pa Pb Pc $OverlappAcuracyPoint) (PointOnLine Pa Pb Pd $OverlappAcuracyPoint))
										(setq Rtn (list 2 (LM:MakeLine Pa Pb)))	 ; retta Ename1 sovrappone la retta Ename2
										
									)
									((and (PointOnLine Pc Pd Pa $OverlappAcuracyPoint) (PointOnLine Pc Pd Pb $OverlappAcuracyPoint))
										(setq Rtn (list 3 (LM:MakeLine Pc Pd))) ; retta Ename2 sovrappone la retta Ename1
										
									)
									((or (PointOnLine Pa Pb Pc $OverlappAcuracyPoint) (PointOnLine Pa Pb Pd $OverlappAcuracyPoint)
										 (PointOnLine Pc Pd Pa $OverlappAcuracyPoint) (PointOnLine Pc Pd Pb $OverlappAcuracyPoint))
										(setq LstPt (MergeLine Pa Pb Pc Pd $OverlappAcuracyPoint))
										(setq Rtn (list 4 (LM:MakeLine (car LstPt) (cadr LstPt)))) ; le rette Ename1 e Ename2 sono tra loro parzialmente sovrapposte
									)
								)
								(progn
									(setq LstPt (MergeLine Pa Pb Pc Pd $OverlappAcuracyPoint))
									(setq Rtn (list 5 (LM:MakeLine (car LstPt) (cadr LstPt)))) ; le rette Ename1 e Ename2 sono continue
								)
							)
						)
					)
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if (and Ename1 Ename2)
		(progn
			(setq Obj1 (vlax-ename->vla-object Ename1))
			(setq Obj2 (vlax-ename->vla-object Ename2))
			
			(cond
				((and (= (vlax-get-property Obj1 'ObjectName) "AcDbLine") (= (vlax-get-property Obj2 'ObjectName) "AcDbLine"))
					 (setq Rtn (OverlappLineToLine Ename1 Ename2))
				)
				((and (= (vlax-get-property Obj1 'ObjectName) "AcDbArc") (= (vlax-get-property Obj2 'ObjectName) "AcDbArc"))
					 (setq Rtn (OverlappArcToArc Ename1 Ename2))
				)
				((and (= (vlax-get-property Obj1 'ObjectName) "AcDbCircle") (= (vlax-get-property Obj2 'ObjectName) "AcDbCircle"))
					 (setq Rtn (OverlappCircleToCircle Ename1 Ename2))
				)
				((or (and (= (vlax-get-property Obj1 'ObjectName) "AcDbCircle") (= (vlax-get-property Obj2 'ObjectName) "AcDbArc"))
					 (and (= (vlax-get-property Obj1 'ObjectName) "AcDbArc")    (= (vlax-get-property Obj2 'ObjectName) "AcDbCircle"))
				  )
					(setq Rtn (OverlappArcToCircle Ename1 Ename2))
				)
			)
		)
	)
	Rtn
)
;
; (ShowDxf "C:\\EasyCut\\ExampleDxf\\test6.csv")
;
(defun ShowDxf (CsvFileName / 	GetDataCsvFile
								LstFilePreview LstDataCsv itm itm1
								InsertPoint LstEnameDxfImport IdShape FileShape)

	;
	;
	;
	(defun GetDataCsvFile (CsvFileName / Stream GoNext LineRead LineSplit LstDataDxf)
	
		;   0                      1                         2  3        4     5   6    7  
		;False;C:\EasyCut\ExampleDxf\DXF6\0001014_revA.dxf;c870;1;0001014_revA;1;10.5;s355J0;
		;True;C:\EasyCut\ExampleDxf\DXF6\0001015_revA.dxf ;c870;1;0001015_revA;1;10.5;s355J0;
		;
		
		(if CsvFileName
			(if (findfile CsvFileName)
				(progn
					(setq Stream (open CsvFileName "r"))
					(setq GoNext T)
					(if (not Stream)
						(progn
							(alert (strcat "ERRORE!! apertura file -> " CsvFileName))
							(setq GoNext nil)
						)
						(setq LineRead (read-line Stream))
					)
					(if (not LineRead)
						(progn
							(alert (strcat "ERRORE!! file vuoto -> " CsvFileName))
							(close Stream)
							(setq GoNext nil)
						)
					)
					
					(if GoNext
						(while LineRead
							(setq LineSplit (splitxt LineRead ";"))
							(if (= (strcase (nth 0 LineSplit)) "TRUE")
								(setq LstDataDxf (append LstDataDxf (list (list (nth 1 LineSplit)	; File Name
																				(nth 2 LineSplit)	; Order
																				(nth 3 LineSplit)	; Phase
																				(nth 4 LineSplit)	; Mark
																				(nth 5 LineSplit)	; Quantity
																				(nth 6 LineSplit)	; Thickness
																				(nth 7 LineSplit)	; Material
																			)))
								)
							)
							(setq LineRead (read-line Stream))
						)
					)
				)
			)
		)
		LstDataDxf
	)
	;
	; Main
	;
	(setq LstFilePreview (vl-directory-files (strcat HtmlStorageEasyCut$ ECFolderShapePreview$) (strcat ECFileShape$ "_*.html") 1))
	(foreach itm LstFilePreview
			(vl-file-delete (strcat HtmlStorageEasyCut$ ECFolderShapePreview$ itm))
	)
	(setq LstDataCsv (GetDataCsvFile CsvFileName))
	
	(foreach itm LstDataCsv
	
			;(nth 0 itm)	; File Name
			;(nth 1 itm)	; Order
			;(nth 2 itm)	; Phase
			;(nth 3 itm)	; Mark
			;(nth 4 itm)	; Quantity
			;(nth 5 itm)	; Thickness
			;(nth 6 itm)	; Material
	
			(princ (strcat "\nFile name read " (nth 0 itm)))
			(foreach itm1 (GetBlockList) (PurgeBlock itm1))
			(setq InsertPoint (list 0.0 0.0 0.0))
			(setq LstEnameDxfImport (ImportDxf (nth 0 itm) InsertPoint))
			(setq LstEnameDxfImport (FilterEnameDxf LstEnameDxfImport T))
			(setq IdShape (Random_Str 9))
			
			(setq FileShape (strcat HtmlStorageEasyCut$ ECFolderShapePreview$ ECFileShape$ "_" IdShape ".html"))
			(terpri)
			(princ LstEnameDxfImport)			(terpri)
			(princ (append (list IdShape) itm))	(terpri)
			(princ FileShape)					(terpri)
			(terpri)
			(trace EnameToGraphicCanvas)
			(EnameToGraphicCanvas LstEnameDxfImport (append (list IdShape) itm) FileShape)
			(DeleteEntity LstEnameDxfImport)
	)
	(setq Rtn (UpdatePreviewShapeHtml))
	(if (findfile Rtn) 
		(DefaultBrowser Rtn)
	)
)
;
;
;
(defun ReadDxfFormat (FileName / GetDataLine
									  Stream LineRead RtnEntity RtnBlock RtnInsert)


	(defun GetDataLine (Stream / Rtn Loop LineRead Code LineRead)
	
		(if Stream
			(progn
				(setq Rtn (list (cons 0 "LINE")))
				(setq LineRead "")
				(setq LstCode (list " 10" " 20" " 11" " 21"))
				(setq Loop T)
				(while Loop
					
					(if (member LineRead LstCode)
						(progn
							(setq Code (atoi LineRead))
							(setq LineRead (read-line Stream))
							(setq Rtn (append Rtn (list (cons Code (atof LineRead)))))
						)
					)
					
					(if (= LineRead "  0")
						(setq Loop nil)
						(setq LineRead (read-line Stream))
					)
				)
				(setq Rtn (list (assoc 0 Rtn)
								(cons 10 (list (cdr (assoc 10 Rtn)) (cdr (assoc 20 Rtn))))
								(cons 11 (list (cdr (assoc 11 Rtn)) (cdr (assoc 21 Rtn))))
						  )
				)
			)
		)
		;(princ "\n ((Esco)) ") (princ LineRead)
		Rtn
	)
	;
	;
	;
	(defun GetDataArc (Stream / Rtn Loop LstCode Code LineRead)
	
		(if Stream
			(progn
				(setq Rtn (list (cons 0 "ARC")))
				(setq LineRead "")
				(setq LstCode (list " 10" " 20" " 40" " 50" " 51"))
				(setq Loop T)
				(while Loop
					(if (member LineRead LstCode)
						(progn
							(setq Code (atoi LineRead))
							(setq LineRead (read-line Stream))
							(setq Rtn (append Rtn (list (cons Code (atof LineRead)))))
						)
					)
					(if (= LineRead "  0")
						(setq Loop nil)
						(setq LineRead (read-line Stream))
					)
				)
				(setq Rtn (list (assoc 0 Rtn)
								(cons 10 (list (cdr (assoc 10 Rtn)) (cdr (assoc 20 Rtn))))
								(assoc 40 Rtn)
								(assoc 50 Rtn)
								(assoc 51 Rtn)
						  )
				)
			)
		)
		;(princ "\n ((Esco)) ") (princ LineRead)
		Rtn
	)
	;
	;
	;
	(defun GetDataCircle (Stream / Rtn Loop LstCode Code LineRead)
	
		(if Stream
			(progn
				(setq Rtn (list (cons 0 "CIRCLE")))
				(setq LineRead "")
				(setq LstCode (list " 10" " 20" " 40"))
				(setq Loop T)
				(while Loop
					(if (member LineRead LstCode)
						(progn
							(setq Code (atoi LineRead))
							(setq LineRead (read-line Stream))
							(setq Rtn (append Rtn (list (cons Code (atof LineRead)))))
						)
					)
					(if (= LineRead "  0")
						(setq Loop nil)
						(setq LineRead (read-line Stream))
					)
				)
				(setq Rtn (list (assoc 0 Rtn)
								(cons 10 (list (cdr (assoc 10 Rtn)) (cdr (assoc 20 Rtn))))
								(assoc 40 Rtn)
						  )
				)
			)
		)
		;(princ "\n ((Esco)) ") (princ LineRead)
		Rtn
	)
	;
	;
	;
	(defun GetDataPolyline (Stream / Rtn Data Loop LstCode Code LineRead Bulge)
	
		(if Stream
			(progn
				(setq Rtn (list (cons 0 "LWPOLYLINE")))
				(setq LineRead "")
				(setq LstCode (list " 10" " 20" " 42"))
				(setq Loop T)
				(while Loop
					(if (member LineRead LstCode)
						(progn
							(setq Code (atoi LineRead))
							(setq LineRead (read-line Stream))
							(setq Data (append Data (list (cons Code (atof LineRead)))))
						)
					)
					(if (= LineRead "  0")
						(setq Loop nil)
						(setq LineRead (read-line Stream))
					)
				)
				
				(foreach itm Data
					
					(princ itm) (getstring "")

					(if (and Bulge (/= (car itm) 42))
						(progn
							(setq Rtn (append Rtn (list (cons 42 0.0))))
							(setq Bulge nil)
						)
					)
					
					
					(cond
						((= (car itm) 0)
							(setq Rtn (append Rtn (list Itm)))
						)
						((= (car itm) 10)
							(setq Pt (cdr itm))
						)
						((= (car itm) 20)
							(setq Pt (cons 10 (list Pt (cdr itm))))
							(setq Rtn (append Rtn (list Pt)))
							(setq Rtn (append Rtn (list (cons 40 0.0))))
							(setq Rtn (append Rtn (list (cons 41 0.0))))
							(setq Bulge T)
						)
						((= (car itm) 42)
							(setq Rtn (append Rtn (list (cons 42 (cdr Itm)))))
							(setq Bulge nil)
						)
					)
				)
			)
		)
		;(princ "\n ((Esco)) ") (princ LineRead)
		Rtn
	)
	;
	;
	;
	(defun GetDataInsert (Stream / Rtn LineRead LstCode Code Loop)
		
		(if Stream
			(progn
				(setq Rtn (list (cons 0 "INSERT")))
				(setq LineRead "")
				(setq LstCode (list "  2" " 10" " 20" " 41" " 42" " 50"))
				(setq Loop T)
				(while Loop
					(if (member LineRead LstCode)
						(progn
							(setq Code (atoi LineRead))
							(setq LineRead (read-line Stream))
							(cond
								((= Code 2)
									(setq Rtn (append Rtn (list (cons Code LineRead))))
								)
								(t
									(setq Rtn (append Rtn (list (cons Code (atof LineRead)))))
								)
							)
						)
					)
					(if (= LineRead "  0")
						(setq Loop nil)
						(setq LineRead (read-line Stream))
					)
				)
				(setq xx Rtn)
				(setq Rtn (list (assoc 0 Rtn)
								(assoc 2 Rtn)
								(cons 10 (list (cdr (assoc 10 Rtn)) (cdr (assoc 20 Rtn))))
								(if (assoc 41 Rtn) (assoc 41 Rtn) (cons 41 1.0)) 
								(if (assoc 42 Rtn) (assoc 42 Rtn) (cons 42 1.0)) 
								(if (assoc 50 Rtn) (cons 50 (* PI (/ (cdr (assoc 50 Rtn)) 180.0))) (cons 50 0.0)) 
						  )
				)			
			
			)
		)
		Rtn
	)
	;
	;
	;
	(defun GetDataBlock (Stream / Rtn Loop LstCode Code LineRead RtnEntity RtnBlock NameBlock)
	
		(if Stream
			(progn
				(setq RtnBlock (list (cons 0 "BLOCK")))
				(setq LineRead "")
				(setq LstCode (list "  2" " 10" " 20"))
				
				(setq Loop T)
				(while Loop
				
					(if (member LineRead LstCode)
						(progn
							(setq Code (atoi LineRead))
							(setq LineRead (read-line Stream))
							(cond
								((= Code 2)
									(setq RtnBlock (append RtnBlock (list (cons Code LineRead))))
									(setq NameBlock LineRead)
								)
								(t
									(setq RtnBlock (append RtnBlock (list (cons Code (atof LineRead)))))
								)
							)
						)
					)
					(if (= LineRead "  0")
						(setq Loop nil)
						(setq LineRead (read-line Stream))
					)
				)
				
				(setq RtnBlock 	(list (assoc 0 RtnBlock)
									  (cons 10 (list (cdr (assoc 10 RtnBlock)) (cdr (assoc 20 RtnBlock))))
								)
				)

				
				;(princ "\n") (princ Rtn)
				(setq Loop T)
				(while Loop
				
					(if (= LineRead "  0")
						(progn
							(setq LineRead (read-line Stream))
							(cond 
								((= (strcase (vl-string-left-trim " " (vl-string-right-trim " " LineRead))) "LINE")
									;(princ "\nLine ")
									(setq RtnEntity (append RtnEntity (list (GetDataLine Stream))))
									(setq LineRead "  0")
								)
								((= (strcase (vl-string-left-trim " " (vl-string-right-trim " " LineRead))) "ARC")
									;(princ "\nArc ")
									(setq RtnEntity (append RtnEntity (list (GetDataArc Stream))))
									(setq LineRead "  0")
								)
								((= (strcase (vl-string-left-trim " " (vl-string-right-trim " " LineRead))) "CIRCLE")
									;(princ "\nCircle ")
									(setq RtnEntity (append RtnEntity (list (GetDataCircle Stream))))
									(setq LineRead "  0")
								)
								((= (strcase (vl-string-left-trim " " (vl-string-right-trim " " LineRead))) "LWPOLYLINE")
									;(princ "\nCircle ")
									(setq RtnEntity (append RtnEntity (list (GetDataPolyline Stream))))
									(setq LineRead "  0")
								)
								((= (strcase (vl-string-left-trim " " (vl-string-right-trim " " LineRead))) "INSERT")
									;(princ "\nCircle ")
									(setq RtnEntity (append RtnEntity (list (GetDataInsert Stream))))
									(setq LineRead "  0")
								)
							)
						)
						(if (= (strcase (vl-string-left-trim " " (vl-string-right-trim " " LineRead))) "ENDBLK")
							(setq Loop nil)
							(setq LineRead (read-line Stream))
						)
					)
					
				)
				;(princ "--") (princ RtnEntity)
			)
		)
		;(princ "\n ((Esco)) ") (princ LineRead)
		(if RtnEntity
			(list NameBlock RtnBlock RtnEntity)
			nil
		)
	)
	;
	;
	;
	(if FileName
		(progn
			(setq Stream (open FileName "r"))
			(setq LineRead (read-line Stream))
			
			(while LineRead
				(if (= LineRead "  0")
					(progn
						(setq LineRead (read-line Stream))
						(cond 
							((= (strcase (vl-string-left-trim " " (vl-string-right-trim " " LineRead))) "LINE")
								(setq RtnEntity (append RtnEntity (list (GetDataLine Stream))))
								(setq LineRead "  0")
							)
							((= (strcase (vl-string-left-trim " " (vl-string-right-trim " " LineRead))) "ARC")
								(setq RtnEntity (append RtnEntity (list (GetDataArc Stream))))
								(setq LineRead "  0")
							)
							((= (strcase (vl-string-left-trim " " (vl-string-right-trim " " LineRead))) "CIRCLE")
								(setq RtnEntity (append RtnEntity (list (GetDataCircle Stream))))
								(setq LineRead "  0")
							)
							((= (strcase (vl-string-left-trim " " (vl-string-right-trim " " LineRead))) "LWPOLYLINE")
								(setq RtnEntity (append RtnEntity (list (GetDataPolyline Stream))))
								(setq LineRead "  0")
							)
							((= (strcase (vl-string-left-trim " " (vl-string-right-trim " " LineRead))) "INSERT")
								(setq RtnEntity (append RtnEntity (list (GetDataInsert Stream))))
								(setq LineRead "  0")
							)
							((= (strcase (vl-string-left-trim " " (vl-string-right-trim " " LineRead))) "BLOCK")
								(if (setq Rtn (GetDataBlock Stream))
									(setq RtnBlock (append RtnBlock (list Rtn)))
								)
								(setq LineRead (read-line Stream))
								(princ LineRead)
							)
						)
					)
					(setq LineRead (read-line Stream))
				)

				;(princ "\n Esco ") (princ LineRead)

			)
			(close Stream)
		)						
	)
	(append (list RtnBlock) (list RtnEntity))
)
;
;
;