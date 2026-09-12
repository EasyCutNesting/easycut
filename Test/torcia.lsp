(defun CreateNestingExpert (LstSheet LstShape  / 	DxfNestingStorage 
													itm SplitLst NewQtaShape
													IdShape EnameShape OriginShape 
													IdSheet EnameSheet CodeSheet
													Ssel FileNameDxf RtnOffset RtnCode conta NumSh DimensionShape LstDataSheet
													LstFileNameShape LstFileNameSheet Num Nel Rtn)

	(if (not LstSheet) (alert "Nessuna lamiera selezionata"))
	(if (not LstShape) (alert "Nessun controno selezionato"))
	
	(if (= $ActiveFilterTorch$ "1")
		(setq NumTorch (atoi $TorchFilter$))
		(setq NumTorch 1)
	)
	(alert (strcat "Torce attive n. " (rtos NumTorch 2 0))) 
	
	(if (and LstSheet LstShape)
		(progn
		
			(foreach itm (vl-directory-files DxfNestingEasyCut$ "*.dxf")
					(vl-file-delete  (strcat DxfNestingEasyCut$ itm))
			)
			(vl-file-delete (strcat DxfNestingEasyCut$ "FileXml.xml"))
			
			(foreach itm (vl-directory-files (strcat SetupPathEasyCut$ "Tmp\\" "*.out"))
					(vl-file-delete  (strcat SetupPathEasyCut$ "Tmp\\" itm))
			)
			;
			; DXF Shape ++++++++++++++
			;
			(setq Num 1)
			(setq Nel (LM:rtos (length LstShape) 2 0))
			
			(foreach itm LstShape
		
				; 0		  1			2	  3		  4	     5	 6	  7	      8		9
				;"2" "516645398" "C872" "300" "178-370" "2" "1" "277.5" "290" "S355J0"
				;itm     id       comm   fase    mk     qta  sp   lung   larg    qua
	
				(setq SplitLst		itm)	
				(setq IdShape  		(nth 1 SplitLst))
				(setq EnameShape	(nth 0 (GetEnameById IdShape)))
			
				(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
				(setq OriginShape	(vlax-safearray->list mnl))
				(setq Ssel 			(SelectShape EnameShape))
						
				(if Ssel
					(progn
						(setq RtnOffset	(OffsetShape EnameShape (/ $MargineAccosto 2.0)))
						(ssadd RtnOffset  Ssel)
						(ssdel EnameShape Ssel)
					
						(setq InfoPosLineMessage (PutPosLineMessageShape EnameShape))
						
						(if (ClockWeis (vlax-get (vlax-ename->vla-object EnameShape) 'coordinates))
							(setq RtnCode  (PutLineMessageShape EnameShape "O" InfoPosLineMessage))
							(setq RtnCode  (PutLineMessageShape EnameShape "A" InfoPosLineMessage))
						)
									
						(setq conta 0)
						(repeat (sslength RtnCode)
							(setq Ssel (ssadd (ssname RtnCode conta) Ssel))
							(setq conta (1+ conta))
						)
						
						(setq FileNameDxf 	(strcat DxfNestingEasyCut$ 	(nth 2 SplitLst) "_" 
																		(nth 3 SplitLst) "_" 
																		(nth 4 SplitLst) "_qt"
																		(nth 5 SplitLst) "_tk"
																		(nth 6 SplitLst) 
																		".dxf"))
																		
						(setq Rtn (DxfOutShape Ssel FileNameDxf))
						
						(cond 
							((= Rtn 1)
								(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Contorno - problema nella cancellazione del file " FileNameDxf))
							) 
							((= Rtn 2)
								(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Contorno - file cancellato " FileNameDxf))
							)
							((= Rtn 3)
								(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Contorno - file creato " FileNameDxf))
							)
						)
						(setq Num (1+ Num))

						(entdel RtnOffset)
						(DeleteSsel RtnCode)
						(setq LstFileNameShape (append LstFileNameShape (list (list FileNameDxf (nth 5 SplitLst)))))
					)		
				)
			)
			;
			; DXF Sheet ++++++++++++++
			;
			(setq Num 1)
			(setq Nel (LM:rtos (length LstSheet) 2 0))
			
			(foreach itm LstSheet

				; 0        1          2         3      4    5     6       7        8
				;"2" "162504882" "STK_GGG_2" "2500" "5000" "10" "12.5" "981.25" "S355J0"
				;itm      id        nome      larg   lung   sp    mq     peso     qua

				(setq SplitLst	itm)
				(setq IdSheet  	(nth 1 SplitLst))
				(setq HeightSheet 	(/ (atof (nth 3 SplitLst)) NumTorch))
				(setq EnameSheet 	(MakePolyline (list (list 0.0 0.0) (list HeightSheet 0.0) (list HeightSheet (atof (nth 4 SplitLst))) (list 0.0 (atof (nth 4 SplitLst))))))
				(setq CodeSheet 	(PutLineMessageSheet EnameSheet (strcat IdSheet "_" (rtos NumTorch 2 0))))
				(setq FileNameDxf 	(strcat DxfNestingEasyCut$ 	(nth 1 SplitLst)    "_" 
																(nth 3 SplitLst)    "_" 
																(nth 4 SplitLst)    "_"
																(nth 5 SplitLst)    ".dxf"))

				(setq Rtn (DxfOutShape (LstEname->Ssget (cons EnameSheet CodeSheet)) FileNameDxf))
				(entdel EnameSheet)
			
				(cond 
					((= Rtn 1)
						(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Lamiera - problema nella cancellazione del file " FileNameDxf))
					)
					((= Rtn 2)
						(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Lamiera - file cancellato " FileNameDxf))
					)
					((= Rtn 3)
						(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Lamiera - file creato " FileNameDxf))
					)
				)
				(entdel (car  CodeSheet))
				(entdel (cadr CodeSheet))
				(setq LstFileNameSheet (append LstFileNameSheet (list (list FileNameDxf "1" ))))
				(setq Num (1+ Num))
			)
			(WriteXmlNested (strcat DxfNestingEasyCut$ "FileXml.xml") LstFileNameShape LstFileNameSheet)
		)
	)
	(if (findfile (strcat DxfNestingEasyCut$ "FileXml.xml"))
		(GoNestProfessor LstFileNameShape LstFileNameSheet)
		(alert "Dati mancanti per il nesting")
	)
)

