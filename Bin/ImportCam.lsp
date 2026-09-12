;
;
;
(defun ImportShapeCam (/ OpenFileLogCam 
						 FolderTmp LstFile itm LstOnlyPlate Conta LstDataSahpe LstHead Rtn LstPtInsert Ssel MinMaxSsel
						 MinCatch LstFileDstv LstTmp)






	(defun OpenFileLogCam (FileName / StreamLog)
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
	(setq StreamLog$   (OpenFileLogCam (strcat InfoPathEasyCut$ "log.txt")))
	(princ (strcat (today) "  " (time)) StreamLog$)
	(princ "\n--> [ImportShapeCam]" StreamLog$)
	

	; Delete file *.nc in Tmp folder +++++
	(setq FolderTmp (strcat SetupPathEasyCut$ "Tmp"))
	(if (not (vl-file-directory-p FolderTmp)) 
		(vl-mkdir FolderTmp)
	)

	(setq LstOnlyPlate (GetLstFileCam))
	
	(StartProgressBar "Read file Cam:" (length LstOnlyPlate))
	(foreach itm LstOnlyPlate
		;	
		(setq LstDataSahpe (CamReadFile itm))
		;        0        1     2      3      4      5     6      7       8     9     10     11
		;(car (NumCom LotCom SbaPez MarPez PosPez QtaPez TipPro LunPro LarPro SpePro MatPro DesPez)
		;
		(setq LstHead (append LstHead (list (list 	itm										;->  IdShape
													(nth 0  (car LstDataSahpe)) 			;->  IdOrder
													(nth 2  (car LstDataSahpe)) 			;->  IdPhase
													(nth 4  (car LstDataSahpe)) 			;->  IdIdentification
													(nth 5  (car LstDataSahpe)) 			;->  IdQuantity
													(nth 9  (car LstDataSahpe)) 			;->  IdThicknes
													(nth 7  (car LstDataSahpe)) 			;->  IdLength
													(nth 8  (car LstDataSahpe)) 			;->  IdHeigth
													(strcase (nth 10 (car LstDataSahpe))) 	;->  IdQuality
											))))
		(UpDateProgressBar)
	)
	(ClearProgressBar)
	(setq NameHeadDcl$ "Lista Import file CAM")
	(foreach itm (vl-directory-files FolderTmp "*.nc" 1) (vl-file-delete (strcat FolderTmp "\\" itm)))
	(setq Rtn (GuiSelPiecesShapeImport (SortTable LstHead '(0 1 2 3 0 0 0 0 0) "<")))
	(foreach itm (vl-directory-files FolderTmp "*.nc" 1) (vl-file-delete (strcat FolderTmp "\\" itm)))
	(if Rtn
		(progn
			(setq Conta 0)
			(StartProgressBar "Read file Cam:" (length Rtn))
			; +++++++++++++++++++++++++++
			(foreach itm Rtn
				(UpDateProgressBar)
				(setq Conta (1+ Conta)) (princ (strcat "\n" (rtos Conta 2 0) "  File letto " itm)) 
				(Cam2Dstv itm  (strcat FolderTmp "\\" (vl-filename-base itm) ".nc"))
			)
			; +++++++++++++++++++++++++++
			(ClearProgressBar)
			
			(setq LstFileDstv 	(vl-directory-files FolderTmp "*.nc" 1))
			(foreach itm LstFileDstv
				(setq LstTmp (append LstTmp (list (strcat FolderTmp "\\" itm))))
			)
			(setq LstFileDstv LstTmp)
				
			(alert (strcat "n^ " (rtos (length LstFileDstv) 2 0) " piatti selezionati"))
			
			(setq LstPtInsert   (PreviewNesting LstFileDstv))
			(setq Ssel 			(NestingShapeNC LstFileDstv LstPtInsert))
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
	)
	(close StreamLog$)
	(EasyCutViewer (strcat InfoPathEasyCut$ "log.txt"))
	(setq StreamLog$ nil)


	(princ)
)
;
;
;
(defun Cam2Dstv (FileCam FileDstv / LstDataCam Rtn)
	(if (and FileCam FileDstv)
		(if (findfile FileCam)
			(progn
				(setq LstDataCam (CamReadFile FileCam))
				(MakeDstvPlate LstDataCam FileDstv)
				(setq Rtn T)
			)
		)
	)
	Rtn
)
;
;
;
(defun GetLstFileCam (/ PathNc ListFile RtnShape RtnNoShape itm CodeNc TmpFile Stream)

	;(PurgeAllGroupUnentity)
	(setq CncPathEasyCut$ (vl-registry-read EasyCutRegistryPath$ "PathNc"))
	
    (setq ListFile (LM:getfiles "Seleziona file" CncPathEasyCut$ "cam"))
	
	(if ListFile
		(progn
			(foreach itm ListFile
			
				(setq CodeNc (GetTypeShapeCam itm))
				
				(cond 
					((= (length CodeNc) 2)
						(if (or (= (nth 1 CodeNc) "R") (= (nth 1 CodeNc) "Q"))
							(setq RtnShape   (append RtnShape (list itm)))
							(setq RtnNoShape (append RtnNoShape (list itm)))
						)
					)
					(t
						(setq RtnNoShape (append RtnNoShape (list itm)))
					)
				)				
			)
			(if RtnShape (vl-registry-write EasyCutRegistryPath$ "PathNc" (vl-filename-directory (nth 0 RtnShape))))
			
			;(setq TmpFile (vl-filename-mktemp))
			;(setq Stream (open TmpFile "w"))
			(princ "\n" StreamLog$)
			(princ "\n--> Lettura file" StreamLog$)
			(princ "\n[Piatti]" StreamLog$)
			(foreach itm RtnShape 		(princ (strcat "\n" itm) StreamLog$))
			(princ "\n\n[Altro]" StreamLog$)
			(foreach itm RtnNoShape 	(princ (strcat "\n" itm) StreamLog$))
		)
	)
	RtnShape
)
;
;
;
(defun GetTypeShapeCam (FileIn / Stream RowCheck IdCode Loop codeerror)
	
	(if FileIn
		(progn
			(setq codeerror 0)
			(setq Stream (open FileIn "r")) 

			(if (not Stream)
				(progn
					; (alert (strcat "ERRORE!! apertura file -> " FileIn))
					; (exit)
					(setq codeerror 1)
				)
				(setq riga (read-line Stream))
			)
			(if (not riga)
				(progn
					;(alert (strcat "ERRORE!! file vuoto -> " FileIn))
					(setq codeerror 2)
					(close Stream)
					;(exit)
				)
			)
			(if (= codeerror 0)
				(progn
					(setq Row (read-line Stream))
					(setq Loop T)
					(while (and Loop Row)
						(if  (= (substr Row 1 7) "TIP_PRO")
							(progn
								(setq IdCode (nth 1 (SpliTxtLstChar (vl-string-right-trim " " (vl-string-left-trim " " Row)) "\t:")))		;	R o Q
								(setq Loop nil)
							)
						)
						(setq Row (read-line Stream))
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
(defun CamReadFile (FileCam / 	IsVoidString
								Stream Row 
								ShapeAni ShapeSup ShapeInf 
								HoleAni HoleSup HoleInf LstOut
								Row_split x y s r ai af record d Rtn
								NumCom LotCom SbaPez MarPez PosPez QtaPez 
								TipPro LunPro LarPro SpePro MatPro DesPez
								NuberInLine InLineTmp 
								ShapeInlineAni ShapeInlineSup ShapeInlineInf
								ShapeFormatedInLineAni ShapeFormatedInLineSup ShapeFormatedInLineInf) 
                               

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
	(if (findfile FileCam)
		(progn
			(setq Stream (open FileCam "r"))
			(if Stream
				(progn
					(setq Row (read-line Stream))
					
					(while Row
					
						(setq Row (vl-string-right-trim " " (vl-string-left-trim " " Row)))
						
						(if (= Row "[HEAD]")  
							(progn
								;(princ "\nGruppo Testa")
								(setq Row (read-line Stream))
								(setq Row (vl-string-right-trim " " (vl-string-left-trim " " Row)))
								
								(while (/= (substr Row 1 1) "[")
									(setq Row (vl-string-right-trim " " (vl-string-left-trim " " Row)))
									(if (not (IsVoidString Row))
										(progn
											(setq Row_split (SpliTxtLstChar Row "\t:"))
											(if (= (nth 0 Row_split) "NUM_COM") (if (not (nth 1 Row_split)) (setq NumCom "-") (setq NumCom (nth 1 Row_split))))
											(if (= (nth 0 Row_split) "LOT_COM") (if (not (nth 1 Row_split)) (setq LotCom "-") (setq LotCom (nth 1 Row_split))))
											(if (= (nth 0 Row_split) "SBA_PEZ") (if (not (nth 1 Row_split)) (setq SbaPez "-") (setq SbaPez (nth 1 Row_split))))
											(if (= (nth 0 Row_split) "MAR_PEZ") (if (not (nth 1 Row_split)) (setq MarPez "-") (setq MarPez (nth 1 Row_split))))
											(if (= (nth 0 Row_split) "POS_PEZ") (if (not (nth 1 Row_split)) (setq PosPez "-") (setq PosPez (nth 1 Row_split))))
											(if (= (nth 0 Row_split) "QTA_PEZ") (if (not (nth 1 Row_split)) (setq QtaPez "-") (setq QtaPez (nth 1 Row_split))))
											(if (= (nth 0 Row_split) "TIP_PRO") (if (not (nth 1 Row_split)) (setq TipPro "-") (setq TipPro (nth 1 Row_split))))
											(if (= (nth 0 Row_split) "LUN_PRO") (if (not (nth 1 Row_split)) (setq LunPro "-") (setq LunPro (nth 1 Row_split))))
											(if (= (nth 0 Row_split) "LAR_PRO") (if (not (nth 1 Row_split)) (setq LarPro "-") (setq LarPro (nth 1 Row_split))))
											(if (= (nth 0 Row_split) "SPE_PRO") (if (not (nth 1 Row_split)) (setq SpePro "-") (setq SpePro (nth 1 Row_split))))
											(if (= (nth 0 Row_split) "MAT_PRO") (if (not (nth 1 Row_split)) (setq MatPro "-") (setq MatPro (nth 1 Row_split))))
											(if (= (nth 0 Row_split) "DES_PEZ") (if (not (nth 1 Row_split)) (setq DesPez "-") (setq DesPez (nth 1 Row_split))))
										)
									)
									(setq Row (read-line Stream))
								)
							)
						)
						(if (= Row "[OUTLINE]")   
							(progn
								;(princ "\nGruppo Contorno")
								(setq Row (read-line Stream))
								(setq Row (vl-string-right-trim " " (vl-string-left-trim " " Row)))
								
								(while (/= (substr Row 1 1) "[")
									(setq Row (vl-string-right-trim " " (vl-string-left-trim " " Row)))
									(if (not (IsVoidString Row))
										(progn
											(if (= (substr Row 1 4) "LIV1") (setq Shape "ani"))
											(if (= (substr Row 1 4) "LIV2") (setq Shape "sup"))
											(if (= (substr Row 1 4) "LIV3") (setq Shape "inf"))

											(setq Row_split (SpliTxtLstChar Row "\t "))

											(if (>= (length Row_split) 6)
												(progn
													(setq x  (nth 0 Row_split))
													(setq y  (nth 1 Row_split))
													(setq s  (nth 2 Row_split))
													(setq r  (nth 3 Row_split))
													(setq ai (nth 4 Row_split))
													(setq af (nth 5 Row_split))
													(setq record (list x y s r ai af))
													(if (= Shape "ani") (setq ShapeAni (append ShapeAni (list record))))
													(if (= Shape "sup") (setq ShapeSup (append ShapeSup (list record))))
													(if (= Shape "inf") (setq ShapeInf (append ShapeInf (list record))))
												)
											)
										)
									)
									(setq Row (read-line Stream))
								)
							)
						)

						(if (= Row "[INLINE]")   
							(progn
								;(princ "\nGruppo Inline")
								(setq ContaInlineAni 0)
								(setq ContaInlineSup 0)
								(setq ContaInlineInf 0)
								(setq Row (read-line Stream))
								(setq Row (vl-string-right-trim " " (vl-string-left-trim " " Row)))
								
								(while (/= (substr Row 1 1) "[")
									(setq Row (vl-string-right-trim " " (vl-string-left-trim " " Row)))
									(if (not (IsVoidString Row))
										(progn
											(if (= (substr Row 1 4) "LIV1") (progn (setq Shape "ani") (setq ContaInlineAni (1+ ContaInlineAni))))
											(if (= (substr Row 1 4) "LIV2") (progn (setq Shape "sup") (setq ContaInlineSup (1+ ContaInlineSup))))
											(if (= (substr Row 1 4) "LIV3") (progn (setq Shape "inf") (setq ContaInlineInf (1+ ContaInlineInf))))

											(setq Row_split (SpliTxtLstChar Row "\t "))

											(if (>= (length Row_split) 6)
												(progn
													(setq x  (nth 0 Row_split))
													(setq y  (nth 1 Row_split))
													(setq s  (nth 2 Row_split))
													(setq r  (nth 3 Row_split))
													(setq ai (nth 4 Row_split))
													(setq af (nth 5 Row_split))
								
													(if (= Shape "ani") (setq record (list ContaInlineAni x y s r ai af)))
													(if (= Shape "sup") (setq record (list ContaInlineSup x y s r ai af)))
													(if (= Shape "inf") (setq record (list ContaInlineInf x y s r ai af)))

													(if (= Shape "ani") (setq ShapeInlineAni (append ShapeInlineAni (list record))))
													(if (= Shape "sup") (setq ShapeInlineSup (append ShapeInlineSup (list record))))
													(if (= Shape "inf") (setq ShapeInlineInf (append ShapeInlineInf (list record))))
												)
											)
										)
									)
									(setq Row (read-line Stream))
								)
							)
						)

						(if (= Row "[HOLE]")   
							(progn
								;(princ "\nGruppo Fori")
								(setq Row (read-line Stream))
								(setq Row (vl-string-right-trim " " (vl-string-left-trim " " Row)))
								
								(while (/= (substr Row 1 1) "[")
									(setq Row (vl-string-right-trim " " (vl-string-left-trim " " Row)))
									(if (not (IsVoidString Row))
										(progn
											(if (= (substr Row 1 4) "LIV1") (setq hole "ani"))
											(if (= (substr Row 1 4) "LIV2") (setq hole "sup"))
											(if (= (substr Row 1 4) "LIV3") (setq hole "inf"))

											(setq Row_split (SpliTxtLstChar Row "\t "))
											(if (>= (length Row_split) 4)
												(progn
													(setq x  (nth 2 Row_split))
													(setq y  (nth 3 Row_split))
													(setq d  (nth 1 Row_split))
													(setq record (list x y d))
										
													(if (= hole "ani") (setq HoleAni (append HoleAni (list record))))
													(if (= hole "sup") (setq HoleSup (append HoleSup (list record))))
													(if (= hole "inf") (setq HoleInf (append HoleInf (list record))))
												)
											)
										)
									)
									(setq Row (read-line Stream))
								)
							)
						)
						(setq Row (read-line Stream))
					)
					(close Stream)
					
					; Formated inline ++++++++++++++++++++++
					
					(if ShapeInlineAni
						(progn 
							(setq NuberInLine (car (car ShapeInlineAni)))
							(setq InLineTmp nil)
							
							(foreach itm ShapeInLineAni
		
								(if (= NuberInLine (car itm))
									(setq InLineTmp (append InLineTmp (list (cdr itm))))
									(progn
										(setq ShapeFormatedInLineAni (append ShapeFormatedInLineAni (list InLineTmp)))
										(setq InLineTmp (list (cdr itm)))
									)
								)
								(setq NuberInLine (car itm))
							)
							(setq ShapeFormatedInLineAni (append ShapeFormatedInLineAni (list InLineTmp)))
						)
					)
					(if ShapeInlineSup
						(progn 
							(setq NuberInLine (car (car ShapeInlineSup)))
							(setq InLineTmp nil)
							
							(foreach itm ShapeInLineSup
		
								(if (= NuberInLine (car itm))
									(setq InLineTmp (append InLineTmp (list (cdr itm))))
									(progn
										(setq ShapeFormatedInLineSup (append ShapeFormatedInLineSup (list InLineTmp)))
										(setq InLineTmp (list (cdr itm)))
									)
								)
								(setq NuberInLine (car itm))
							)
							(setq ShapeFormatedInLineSup (append ShapeFormatedInLineSup (list InLineTmp)))
						)
					)
					(if ShapeInlineInf
						(progn 
							(setq NuberInLine (car (car ShapeInlineInf)))
							(setq InLineTmp nil)
							
							(foreach itm ShapeInLineInf
		
								(if (= NuberInLine (car itm))
									(setq InLineTmp (append InLineTmp (list (cdr itm))))
									(progn
										(setq ShapeFormatedInLineInf (append ShapeFormatedInLineInf (list InLineTmp)))
										(setq InLineTmp (list (cdr itm)))
									)
								)
								(setq NuberInLine (car itm))
							)
							(setq ShapeFormatedInLineInf (append ShapeFormatedInLineInf (list InLineTmp)))
						)
					)
					
					(setq Rtn (list (list NumCom LotCom SbaPez MarPez PosPez QtaPez TipPro LunPro LarPro SpePro MatPro DesPez)
									      ShapeAni ShapeSup ShapeInf 
										  HoleAni HoleSup HoleInf 
										  ShapeFormatedInLineAni 
										  ShapeFormatedInLineSup 
										  ShapeFormatedInLineInf
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
(defun MakeDstvPlate (LstDataShape DstvFile / info_com info_shape info_hole 
                                             NumCom LotCom SbaPez MarPez PosPez QtaPez TipPro 
                                             LunPro LarPro SpePro MatPro DesPez kg_ml mq_ml pos_split
                                             Stream format_shape_nc itm conta_vertici x y r d hole_dbl conta_fori)


;                               0       1       2       3       4       5       6       7       8       9      10 		11
;                  LISTA[0]  num_com lot_com mar_pez spa_pez pos_pez qta_pez tip_pro lun_pro lar_pro spe_pro mat_pro des_pro
;
;                             0 1 2 3 4  5          
;                  LISTA[1]  (x y s r ai af) ( ...... ) 
;
;                             0 1 2
;                  LISTA[2]  (d x y)  ( ...... ) 
;


    (setq info_com    (nth 0 LstDataShape)
          info_shape  (nth 1 LstDataShape)
          info_hole   (nth 4 LstDataShape)
          info_inline (nth 7 LstDataShape)

          NumCom (nth 0 info_com)
          LotCom (nth 1 info_com)
          SbaPez (nth 2 info_com)
		  MarPez (nth 3 info_com)
          PosPez (nth 4 info_com)
          QtaPez (nth 5 info_com)
		  TipPro (vl-string-right-trim " " (vl-string-left-trim " " (nth 6 info_com)))
          LunPro (nth 7 info_com)
          LarPro (nth 8 info_com)
          SpePro (nth 9 info_com)
          MatPro (nth 10 info_com)
          DesPez (nth 11 info_com)
          kg_ml   (* (*  (/ (atof LarPro) 1000.0) (atof SpePro)) 7.85)
          mq_ml   (/ (+ (* (atof LarPro) 2.0) (* (atof SpePro) 2.0)) 1000.0)
    )
    ;
    ; controlli 
    ;
    ;(if (not NumCom) (princ "\nmanca il nome della commessa" $wf$))
    ;(if (not LotCom) (princ "\nmanca il nome del lotto" $wf$))
    ;(if (not SbaPez) (princ "\nmanca il nome della fase" $wf$))
    ;(if (not MarPez) (princ "\nmanca la marca principale" $wf$))
    ;(if (not PosPez) (princ "\nmanca la posizione" $wf$))
    ;(if (not QtaPez) (princ "\nmanca la quantità della marca" $wf$))
    ;(if (not TipPro) (princ "\nmanca il tipo di profilo" $wf$))
    ;(if (not LunPro) (princ "\nmanca la lunghezza della marca" $wf$))
    ;(if (not LarPro) (princ "\nmanca la larghezza della marca" $wf$))
    ;(if (not SpePro) (princ "\nmanca manca lo spessore" $wf$))
    ;(if (not MatPro) (princ "\nmanca il materiale" $wf$))
    ;(if (not DesPez) (princ "\nmanca la descrizione" $wf$))
 
    (if (not NumCom) (setq NumCom "#"))
    (if (not LotCom) (setq LotCom "##"))
    (if (not SbaPez) (setq SbaPez "###"))
    (if (not MarPez) (setq MarPez "####"))
    (if (not PosPez) (setq PosPez "#####"))
    (if (not QtaPez) (setq QtaPez "######"))
    (if (not TipPro) (setq TipPro "#######"))
    (if (not LunPro) (setq LunPro "########"))
    (if (not LarPro) (setq LarPro "#########"))
    (if (not SpePro) (setq SpePro "##########"))
    (if (not MatPro) (setq MatPro "###########"))
    (if (not DesPez) (setq DesPez "############"))
 
 
    (if (or (= TipPro "Q") (= TipPro "R"))
        (progn
            (setq Stream (open DstvFile "w"))
              
            (if Stream
                (progn

                    ;(alert "gruppo testa")
                    (princ "ST\n" Stream)
                    (princ "** Interfaccia EasyCut Versione 1.0 22-09-19\n" Stream)

                    (princ (strcat "  " NumCom "\n") Stream) 
                    (princ (strcat "  " LotCom "\n") Stream) 
                    (princ (strcat "  " SbaPez "\n") Stream) 
                    (princ (strcat "  " PosPez "\n") Stream) 
                    (princ (strcat "  " MatPro "\n") Stream) 
                    (princ (strcat "  " QtaPez "\n") Stream)
                    (princ (strcat "  PL" LarPro "*" SpePro "\n") Stream)
                    (princ "  B\n" Stream)

                    (princ (RigthText (strcat "  " LunPro "\n") 12) Stream)
                    (princ (RigthText (strcat "  " LarPro "\n") 12) Stream)
                    (princ (RigthText "0.00\n" 12) Stream)          ; kost
                    (princ (RigthText" 0.00\n" 12) Stream)          ; kost
                    (princ (RigthText (strcat "  " SpePro "\n") 12)  Stream)
                    (princ (RigthText "0.00\n" 12) Stream)          ; kost
                    (princ (RigthText (strcat (rtos kg_ml 2 2) "\n") 12) Stream)    ; kg / ml
                    (princ (RigthText (strcat (rtos mq_ml 2 2) "\n") 12) Stream)    ; mq / ml
                    (princ (RigthText "0.00\n" 12) Stream)   
                    (princ (RigthText "0.00\n" 12) Stream)   
                    (princ (RigthText "0.00\n" 12) Stream)   
                    (princ (RigthText "0.00\n" 12) Stream) 

                    (if DesPez   
                        (princ (strcat "  " DesPez "\n")   Stream)          ; nome pezzo
                        (princ (strcat "  PLATE\n")   Stream)               ; nome pezzo
                    )
                    (princ "\n\n\n" Stream)   

                    ; **************************************************
                    ;                    CONTORNO
                    ; **************************************************
                    ;(alert "gruppo contorno")
                    (princ "AK\n" Stream)

                    (setq format_shape_nc (FormatShapeCamToDstv info_shape))
                    ;(setq conta_vertici 0)

                    (foreach itm format_shape_nc
                        (setq x (strcat  (LM:rtos (nth 1 itm) 2 2) "u"))
                        (setq y 		 (LM:rtos (nth 2 itm) 2 2))
                        (setq r 		 (LM:rtos (nth 3 itm) 2 2))
       
                        (princ (strcat "  v" (RigthText x 15)
                                             (RigthText y 15)
                                             (RigthText r 15)  "\n") Stream)

                        ;(setq conta_vertici (+ conta_vertici 1))
                    )
                    (setq x (strcat (LM:rtos (nth 1 (nth 0 format_shape_nc)) 2 2) "u"))
                    (setq y         (LM:rtos (nth 2 (nth 0 format_shape_nc)) 2 2))
                    (setq r         (LM:rtos 0.0 2 2))

                    (princ (strcat "  v" (RigthText x 15)
                                         (RigthText y 15)
                                         (RigthText r 15)  "\n") Stream)

                    ; **************************************************
                    ;               CONTORNO INTERNO
                    ; **************************************************
                    (if info_inline
                        (progn
                            (setq conta_inline 0)
                            (repeat (length info_inline)
                             
                                (setq format_shape_nc (FormatShapeCamToDstv (nth conta_inline info_inline)))
                                (setq conta_vertici 0)
       
                                (princ "IK\n" Stream)
               
                                (repeat (length format_shape_nc)
                                        (setq x (strcat (LM:rtos (nth 1 (nth conta_vertici format_shape_nc)) 2 2) "u"))
                                        (setq y         (LM:rtos (nth 2 (nth conta_vertici format_shape_nc)) 2 2))
                                        (setq r         (LM:rtos (nth 3 (nth conta_vertici format_shape_nc)) 2 2))
       
                                        (princ (strcat "  v" (RigthText x 15)
                                                             (RigthText y 15)
                                                             (RigthText r 15)  "\n") Stream)
     
                                        (setq conta_vertici (+ conta_vertici 1))
                                )
                                (setq x (strcat (LM:rtos (nth 1 (nth 0 format_shape_nc)) 2 2) "u"))
                                (setq y         (LM:rtos (nth 2 (nth 0 format_shape_nc)) 2 2))
                                (setq r         (LM:rtos 0.0 2 2))

                                (princ (strcat "  v" (RigthText x 15)
                                                     (RigthText y 15)
                                                     (RigthText r 15)  "\n") Stream)
                                     
                                (setq conta_inline (+ conta_inline 1))
                            )
                        )
                    )

					; **************************************************
                    ;                    FORI
                    ; **************************************************
                    ;(alert "gruppo fori")
                    (if info_hole
                        (progn
                            (princ "BO\n" Stream)
                            (setq hole_dbl (HoleStr2Dbl info_hole))
                            ;(setq conta_fori 0)
                            (foreach itm hole_dbl
                                (setq d (LM:rtos (nth 0 itm) 2 1)
                                      x (LM:rtos (nth 1 itm) 2 2)
                                      y (LM:rtos (nth 2 itm) 2 2)
                                )
 
                                (princ 	(strcat "  v" 
										(RigthText (strcat x "u") 15)
                                        (RigthText y 15)
                                        (RigthText d 15) "\n") Stream)

								;(setq conta_fori (+ conta_fori 1))
                            )
                        )
                    )
                    (princ "EN\n" Stream)
					
                    (close Stream)
                  )
              )
          )
      )
)
;
;
;
(defun SpliTxtLstChar (String StringSeparator / ncar glo temp a bak)
;
; procedura per la suddivisione di un testo
; String 			= testo da esaminare
; StringSeparator	= caratteri di verifica
;

	(if (and String StringSeparator)
		(progn
			(setq ncar (strlen String) glo 1 temp "" bak nil)

			(while (<= glo ncar)
				(setq a (substr String glo 1))
				(if (not (member (ascii a) (vl-string->list StringSeparator)))
					(progn
						(while 	(and (not (member (ascii a) (vl-string->list StringSeparator))) 
								    (<= glo ncar)
								)
								(setq temp (strcat temp a) glo (+ 1 glo) a (substr String glo 1))
						)
						(setq bak (append bak (list temp)) temp "")
					)
					(setq glo (+ 1 glo))
				)
			)
		)
	)

	(setq bak bak)
)
;
;
;
(defun FormatShapeCamToDstv (Shape_Cam / conta_cam conta_dstv out_list itm
                                         x y s r ai af x_p y_p x_s y_s out
                                         x0 y0 r0 x2 y2 x01 y01 r01 seek1 seek2)


	(setq conta_cam  0)
	(setq conta_dstv 1)
	(setq out_list nil)
		
		(if Shape_Cam
			(progn
				(foreach itm Shape_Cam
                
					(setq x  (atof (nth 0 itm)))
					(setq y  (atof (nth 1 itm)))
					(setq s  (atof (nth 2 itm)))
					(setq r  (atof (nth 3 itm)))
					(setq ai (atof (nth 4 itm)))
					(setq af (atof (nth 5 itm)))
    
					(if (/= r 0.0)
						(progn

							; trovo il punto precedente
							(if (= conta_cam 0)
								(setq seek1 (- (length shape_cam) 1))
								(setq seek1 (- conta_cam 1))
							)

							(setq x_p  (atof (nth 0 (nth seek1 shape_cam))))
							(setq y_p  (atof (nth 1 (nth seek1 shape_cam))))

							; trovo il punto successivo
							(if (= conta_cam (- (length shape_cam) 1))
								(setq seek2 0)
								(setq seek2 (+ conta_cam 1))
							)

							(setq x_s  (atof (nth 0 (nth seek2 shape_cam))))
							(setq y_s  (atof (nth 1 (nth seek2 shape_cam))))
                      
							(setq out  (ArcCamToDstv x y x_p y_p x_s y_s r ai af))

							(if (= (length out) 2)
								(progn
									(setq x0 (nth 0 (nth 0 out)))
									(setq y0 (nth 1 (nth 0 out)))
									(setq r0 (nth 2 (nth 0 out)))
									(setq x2 (nth 0 (nth 1 out)))
									(setq y2 (nth 1 (nth 1 out)))
									(if out_list
										(setq out_list (subst (cons  (- conta_dstv 1) (list x0 y0 r0)) 
															  (assoc (- conta_dstv 1) out_list) 
															  out_list))
										(progn                                    
											(setq out_list (append out_list (list (cons conta_dstv (list x0 y0 r0)))))
											(setq conta_dstv (+ conta_dstv 1))
										)
									)
								)
							)
							(if (= (length out) 3)
								(progn
									(setq x0  (nth 0 (nth 0 out)))
									(setq y0  (nth 1 (nth 0 out)))
									(setq r0  (nth 2 (nth 0 out)))
									(setq x01 (nth 0 (nth 1 out)))
									(setq y01 (nth 1 (nth 1 out)))
									(setq r01 (nth 2 (nth 1 out)))
									(setq x2  (nth 0 (nth 2 out)))
									(setq y2  (nth 1 (nth 2 out)))

									(setq out_list (subst (cons  (- conta_dstv 1) (list x0 y0 r0)) 
														  (assoc (- conta_dstv 1) out_list) 
														  out_list))

									(setq out_list (append out_list (list (cons conta_dstv (list x01 y01 r01)))))
									(setq conta_dstv (+ conta_dstv 1))
									;(setq out_list (append out_list (list (cons conta_dstv (list x2 y2 0.0)))))
									;(setq conta_dstv (+ conta_dstv 1))
								)
							)
						)                   
						(progn
							(setq out_list (append out_list (list (cons conta_dstv (list x y r)))))
							(setq conta_dstv (+ conta_dstv 1))
						)
					)  
					;(terpri) (princ out_list) (getstring)             
					(setq conta_cam (+ conta_cam 1))
				)
			)
		)
		;(terpri) (princ out_list) (getstring)
		out_list
)
;
;
;
(defun ArcCamToDstv (x1 y1 x0 y0 x2 y2 r ai af / lista_out preci_coord ai_rad dx_ai dy_ai x_ver_i y_ver_i
                                                 ra dalfa_tmetal px)

    ; 
    ; x1  y1  centro 
    ; x0  y0  punto precedente al 1
    ; x2  y2  punto successivo al 1
    ; r   raggio
    ; ai  angolo iniziale
    ; af  angolo finale
    ;

    (setq lista_out nil)
    (setq preci_coord 0.02)
    (setq ai_rad (/ (* ai PI) 180.0))
    (setq dx_ai (* r (cos ai_rad)))
    (setq dy_ai (* r (sin ai_rad)))

    (setq x_ver_i (+ x1 dx_ai))
    (setq y_ver_i (+ y1 dy_ai))


    (if (and (<= (abs (- (abs x0) (abs x_ver_i))) preci_coord)
             (<= (abs (- (abs y0) (abs y_ver_i))) preci_coord))
             (setq ra r)
             (setq ra (* r -1.0))
    )


    ;(terpri) (princ (- (abs x0) (abs x_ver_i)))
    ;(terpri) (princ (- (abs y0) (abs y_ver_i)))
    ;(terpri) (princ x0) 
    ;(terpri) (princ y0) 
    ;(terpri) (princ x_ver_i) 
    ;(terpri) (princ y_ver_i) 
    ;(terpri) (princ ra) (terpri)
   
    (setq dalfa_tmetal (- af ai))
    (if (< dalfa_tmetal 0.0)
        (setq dalfa_tmetal (/ (* (+ 360.0 dalfa_tmetal) PI) 180.0))
        (setq dalfa_tmetal (/ (* dalfa_tmetal PI) 180.0))
    )



    (if (> dalfa_tmetal PI)
        (progn
             (if (> ra 0)
                 (setq px (dca x1 y1 x0 y0 (/ dalfa_tmetal 2.0)))
                 (setq px (dca x1 y1 x0 y0 (* (/ dalfa_tmetal 2.0) -1.0)))
             )
             (setq lista_out (list (list x0 y0 ra) (list (nth 0 px) (nth 1 px) ra) (list x2 y2)))
        )                      
        (progn
             (setq lista_out (list (list x0 y0 ra) (list x2 y2)))
        )        
    )
    (setq lista_out lista_out)
)
;
;
;
(defun Str2Dbl (testo / testo_split out)
;
; procedura per la conversione di un testo in valore a doppia precisoine
;
; es: "123.456" = 123.456
; es: "123,456" = 123.456
;
     (setq testo_split (splitxt testo ","))
     (if (= (length testo_split) 2)
         (setq out (atof (strcat (nth 0 testo_split) "." (nth 1 testo_split))))
         (setq out (atof testo))
     )
)
;
;
;
(defun HoleStr2Dbl (hole_str / conta_fori hole_glo co x y d hole_dbl)

	(setq conta_fori 0)
    (setq hole_dbl nil)
    (repeat (length hole_str)
        (setq co (nth conta_fori hole_str)
              x  (str2dbl (nth 0 co))
              y  (str2dbl (nth 1 co))
              d  (str2dbl (nth 2 co))
              hole_dbl (append hole_dbl (list (list d x y)))
              conta_fori (+ conta_fori 1)
        )
    )
    (setq out hole_dbl)
)
;
;
;
(defun LeftText (testo n_car / out conta)
;
; procedura per formattare un testo con enne caratteri partendo da sinistra
; es testo= "122 124" 
;    n_car=10
;    risultato "123 124   "
;
  (setq out ""
        conta 1
  )
  (repeat n_car
     (if (<= conta (strlen testo))
         (setq out (strcat out (substr testo conta 1)))
         (setq out (strcat out " "))
     )
     (setq conta (+ conta 1))
  )    
  (setq out out)
)
;
;
;
(defun RigthText (testo n_car / out conta)
;
; procedura per formattare un testo con enne caratteri partendo da sinistra
; es testo= "122 124" 
;    n_car=10
;    risultato "   123 124"
;
  (setq out testo
        conta 1
  )
  (repeat (- n_car (strlen testo))
          (setq out (strcat " " out))
          (setq conta (+ conta 1))
  )    
  (setq out out)
)