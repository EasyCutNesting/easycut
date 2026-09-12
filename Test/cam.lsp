;(setq LstData (CamReadFile "c:\\EasyCut\\ExampleCam\\3.cam"))
;(MakeDstvPlate LstData "c:\\EasyCut\\ExampleCam\\3.nc")

(defun ImportShapeCam (/ LstOnlyPlate LstPtInsert Pathinfo Ssel MinMaxSsel MinCatch MaxCatch itm LstDataSahpe FileName LstHead Conta Rtn)



	(setq LstOnlyPlate (GetLstFileCam))
	(if LstOnlyPlate
		(progn
			
			(setq Path (vl-registry-read "HKEY_CURRENT_USER\\Software\\EasyCut" "PathNc"))
			(setq Conta 0)
			(foreach itm LstOnlyPlate
				(setq Conta (1+ Conta)) (princ (strcat "\nFile letto " itm " " (rtos Conta 2 0))) 
				(setq LstDataCam (CamReadFile itm))
				(if (nth 7 LstDataShape) (princ (strcat "\n" itm)))
				
				;(MakeDstvPlate LstDataCam (strcat Path "\\" file ".nc"))
			)
		)
	)
)
;
;
;
(defun GetLstFileCam (/ PathNc ListFile Rtn itm CodeNc)

	(PurgeAllGroupUnentity)
	(setq PathNc (vl-registry-read "HKEY_CURRENT_USER\\Software\\EasyCut" "PathNc"))
	
    (setq ListFile (LM:getfiles "Seleziona file" PathNc "cam"))
	(if ListFile
		(progn
			(foreach itm ListFile
			
				(setq CodeNc (CheckIfCamIsPlate itm))
				
				(cond 
					((= (length CodeNc) 2)
						(if (or (= (nth 1 CodeNc) "R") (= (nth 1 CodeNc) "Q"))
							(setq Rtn (append Rtn (list itm)))
						)
					)
					(t
						nil
					)
				)				
			)
			(if LstOnlyPlate (vl-registry-write "HKEY_CURRENT_USER\\Software\\EasyCut" "PathNc" (vl-filename-directory (nth 0 Rtn))))
		)
	)
	Rtn
)
;
;
;
(defun CheckIfCamIsPlate (FileIn / Stream RowCheck IdCode codeerror)
	
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
					(setq RowCheck 26)
					(repeat RowCheck
						(setq Row (read-line Stream))
					)
					(setq IdCode (nth 1 (splitxt (vl-string-right-trim " " (vl-string-left-trim " " Row)) ":")))		;	R o Q
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
(defun CamReadFile (FileCam / 	Stream Row 
								ShapeAni ShapeSup ShapeInf 
								ShapeInlineAni ShapeInlineSup ShapeInlineInf
								HoleAni HoleSup HoleInf LstOut
								Row_split x y s r ai af record d Rtn
								NumCom LotCom SbaPez MarPez PosPez QtaPez 
								TipPro LunPro LarPro SpePro MatPro DesPez) 
                                      
	(if (findfile FileCam)
		(progn
			(setq Stream (open FileCam "r"))
			(if Stream
				(progn
					(setq Row (read-line Stream))
					(while Row
               
						(if (= Row "[HEAD]")  
							(progn
								;(princ "\nGruppo Testa")
								(setq Row (read-line Stream))
								(while (/= (substr Row 1 1) "[")

									(setq Row_split (splitxt Row ":"))
									(if (= (nth 0 Row_split) "NUM_COM") (setq NumCom (nth 1 Row_split)))
									(if (= (nth 0 Row_split) "LOT_COM") (setq LotCom (nth 1 Row_split)))
									(if (= (nth 0 Row_split) "SBA_PEZ") (setq SbaPez (nth 1 Row_split)))
									(if (= (nth 0 Row_split) "MAR_PEZ") (setq MarPez (nth 1 Row_split)))
									(if (= (nth 0 Row_split) "POS_PEZ") (setq PosPez (nth 1 Row_split)))
									(if (= (nth 0 Row_split) "QTA_PEZ") (setq QtaPez (nth 1 Row_split)))
									(if (= (nth 0 Row_split) "TIP_PRO") (setq TipPro (nth 1 Row_split)))
									(if (= (nth 0 Row_split) "LUN_PRO") (setq LunPro (nth 1 Row_split)))
									(if (= (nth 0 Row_split) "LAR_PRO") (setq LarPro (nth 1 Row_split)))
									(if (= (nth 0 Row_split) "SPE_PRO") (setq SpePro (nth 1 Row_split)))
									(if (= (nth 0 Row_split) "MAT_PRO") (setq MatPro (nth 1 Row_split)))
									(if (= (nth 0 Row_split) "DES_PEZ") (setq DesPez (nth 1 Row_split)))
									(setq Row (read-line Stream))
								)
							)
						)
						(if (= Row "[OUTLINE]")   
							(progn
								;(princ "\nGruppo Contorno")
								(setq Row (read-line Stream))
								(while (/= (substr Row 1 1) "[")
                        
									(if (= (substr Row 1 4) "LIV1") (setq Shape "ani"))
									(if (= (substr Row 1 4) "LIV2") (setq Shape "sup"))
									(if (= (substr Row 1 4) "LIV3") (setq Shape "inf"))

									(setq Row_split (splitxt Row " "))

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
								(while (/= (substr Row 1 1) "[")
                      
									(if (= (substr Row 1 4) "LIV1") (progn (setq Shape "ani") (setq ContaInlineAni (1+ ContaInlineAni))))
									(if (= (substr Row 1 4) "LIV2") (progn (setq Shape "sup") (setq ContaInlineSup (1+ ContaInlineSup))))
									(if (= (substr Row 1 4) "LIV3") (progn (setq Shape "inf") (setq ContaInlineInf (1+ ContaInlineInf))))

									(setq Row_split (splitxt Row " "))

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
									(setq Row (read-line Stream))
								)
							)
						)

						(if (= Row "[HOLE]")   
							(progn
								;(princ "\nGruppo Fori")
								(setq Row (read-line Stream))
								(while (/= (substr Row 1 1) "[")

									(if (= (substr Row 1 4) "LIV1") (setq hole "ani"))
									(if (= (substr Row 1 4) "LIV2") (setq hole "sup"))
									(if (= (substr Row 1 4) "LIV3") (setq hole "inf"))

									(setq Row_split (splitxt Row " "))
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
									(setq Row (read-line Stream))
								)
							)
						)
						(setq Row (read-line Stream))
					)
					(close Stream)
					(setq Rtn (list (list NumCom LotCom SbaPez MarPez PosPez QtaPez TipPro LunPro LarPro SpePro MatPro DesPez)
									      ShapeAni ShapeSup ShapeInf HoleAni HoleSup HoleInf ShapeInlineAni ShapeInlineSup ShapeInlineInf
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
 
    (if (not NumCom) (setq NumCom "?"))
    (if (not LotCom) (setq LotCom "??"))
    (if (not SbaPez) (setq SbaPez "???"))
    (if (not MarPez) (setq MarPez "????"))
    (if (not PosPez) (setq PosPez "?????"))
    (if (not QtaPez) (setq QtaPez "??????"))
    (if (not TipPro) (setq TipPro "???????"))
    (if (not LunPro) (setq LunPro "????????"))
    (if (not LarPro) (setq LarPro "?????????"))
    (if (not SpePro) (setq SpePro "??????????"))
    (if (not MatPro) (setq MatPro "???????????"))
    (if (not DesPez) (setq DesPez "????????????"))
 
 
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
       
                        (princ (strcat "  v" (RigthText x 10)
                                             (RigthText y 10)
                                             (RigthText r 10)  "\n") Stream)

                        ;(setq conta_vertici (+ conta_vertici 1))
                    )
                    (setq x (strcat (LM:rtos (nth 1 (nth 0 format_shape_nc)) 2 2) "u"))
                    (setq y         (LM:rtos (nth 2 (nth 0 format_shape_nc)) 2 2))
                    (setq r         (LM:rtos 0.0 2 2))

                    (princ (strcat "  v" (RigthText x 10)
                                         (RigthText y 10)
                                         (RigthText r 10)  "\n") Stream)

                    ; **************************************************
                    ;               CONTORNO INTERNO
                    ; **************************************************
                    (if info_inline
                        (progn
                            (setq conta_inline 0)
                            (repeat (length info_inline)
                                ;(terpri) (princ (nth conta_inline info_inline)) (getstring "-----------")
                                (setq format_shape_nc (format_shape_cam_to_dstv (nth conta_inline info_inline)))
                                (setq conta_vertici 0)
       
                                (princ "IK\n" Stream)
               
                                (repeat (length format_shape_nc)
                                        (setq x (strcat (LM:rtos (nth 1 (nth conta_vertici format_shape_nc)) 2 2) "u"))
                                        (setq y         (LM:rtos (nth 2 (nth conta_vertici format_shape_nc)) 2 2))
                                        (setq r         (LM:rtos (nth 3 (nth conta_vertici format_shape_nc)) 2 2))
       
                                        (princ (strcat "  v" (RigthText x 10)
                                                             (RigthText y 10)
                                                             (RigthText r 10)  "\n") Stream)
     
                                        (setq conta_vertici (+ conta_vertici 1))
                                )
                                (setq x (strcat (LM:rtos (nth 1 (nth 0 format_shape_nc)) 2 2) "u"))
                                (setq y         (LM:rtos (nth 2 (nth 0 format_shape_nc)) 2 2))
                                (setq r         (LM:rtos 0.0 2 2))

                                (princ (strcat "  v" (RigthText x 10)
                                                     (RigthText y 10)
                                                     (RigthText r 10)  "\n") Stream)
                                     
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
										(RigthText (strcat x "u") 10)
                                        (RigthText y 10)
                                        (RigthText d 10) "\n") Stream)

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
