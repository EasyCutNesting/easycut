(defun GuiSymula02 (EnameSheet / Loop xx LstSequence TypeSequence Rtn Rtn1 Rtn2 GoWalk GoSequence GoTrigger GoPartProgramm FileError)

	(if EnameSheet
		(progn
			;(SequenceCut EnameSheet)
			
			(setq Loop T)
			(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
			
				(new_dialog "CheckCut02" xx "" (cond ( *CheckCut* ) ( '(-1 -1) )))

				
				
				;(mode_tile "trigger"				1)
				;(mode_tile "resulttrigger"			1)
				(mode_tile "infotrigger"			1)

				(mode_tile "sequence"				1)
				(mode_tile "resultsequence"			1)
				(mode_tile "infosequence"			1)

				
				(mode_tile "walk"					1)
				(mode_tile "resultwalk"				1)
				(mode_tile "infowalk"				1)
				
				(mode_tile "PartProgramm"   		1)
				(mode_tile "ResultPartProgramm"		1)
				(mode_tile "StartPartProgramm"		1)
				
				
				(setq LstSequence (list "[Superficie maggiore]" "[Superficie minore]" "[Vicino a..]" "[X/Y]" "[Seleziona contorni]"))
				(if (setq TypeSequence (GetTypeSequnce EnameSheet))
					(set_tile "sequence" (strcat "Sequenza taglio --> " (nth (- (atoi TypeSequence) 1) LstSequence)))
					(set_tile "sequence" "Nessuna sequenza trovata" )
				)
				
				(set_tile "resulttrigger"		(if (CheckSequenceTriggerOnSheet EnameSheet)
													(progn
														(mode_tile "sequence"		0)
														(mode_tile "resultsequence"	0)
														(setq Rtn1 "Passato")
													)
													(progn
														(mode_tile "infotrigger" 	0)
														(setq Rtn1 "Non passato")
													)
												)
				)
				
				(if (= Rtn1 "Passato")
					(set_tile "resultsequence" 	(if (= (CheckSequenceShapeOnSheet EnameSheet nil) 1)
													(progn
														(mode_tile "walk"				0)
														(mode_tile "resultwalk"			0)
														(mode_tile "infowalk"			0)
														
														(mode_tile "PartProgramm"   	0)
														(mode_tile "ResultPartProgramm"	0)
														(mode_tile "StartPartProgramm"	0)
														
														(setq Rtn2 "Passato")
													)
													(progn
														(mode_tile "infosequence" 	0)
														(setq Rtn2 "Non passato")
													)
												)
					)
				)
				
				
				
				
				
				;(set_tile "resultsequence"		(if (= (CheckSequenceShapeOnSheet EnameSheet nil) 1)
				;									(progn
				;										(mode_tile "trigger"		0)
				;										(mode_tile "resulttrigger"	0)
				;										(setq Rtn1 "Passato")
				;									)
				;									(progn
				;										(mode_tile "infosequence" 	0)
				;										(setq Rtn1 "Non passato")
				;									)
				;								)
				;)
				
				
				;(if (= Rtn1 "Passato")
				;	(set_tile "resulttrigger" 	(if (CheckSequenceTriggerOnSheet EnameSheet)
				;									(progn
				;										(mode_tile "walk"				0)
				;										(mode_tile "resultwalk"			0)
				;										(mode_tile "infowalk"			0)
				;										
				;										(mode_tile "PartProgramm"   	0)
				;										(mode_tile "ResultPartProgramm"	0)
				;										(mode_tile "StartPartProgramm"	0)
				;										
				;										(setq Rtn2 "Passato")
				;									)
				;									(progn
				;										(mode_tile "infotrigger" 	0)
				;										(setq Rtn2 "Non passato")
				;									)
				;								)
				;	)
				;)
				;
				(action_tile "infosequence" (strcat "(setq *CheckCut* (done_dialog)) (unload_dialog xx)"
													"(setq GoSequence T)"
											)
				)
				(action_tile "infowalk" 	(strcat "(setq *CheckCut* (done_dialog)) (unload_dialog xx)"
													"(setq GoWalk T)"
											)
				)
				(action_tile "infotrigger"  (strcat "(setq *CheckCut* (done_dialog)) (unload_dialog xx)"
													"(setq GoTrigger T)"
											)
				)
				(action_tile "StartPartProgramm"  (strcat "(setq *CheckCut* (done_dialog)) (unload_dialog xx)"
													"(setq GoPartProgramm T)"
											)
				)
				(action_tile "accept"           (strcat "(setq *CheckCut* (done_dialog)) (unload_dialog xx)"))
				(start_dialog)		
			
			
			(if GoSequence	
				(progn
					(setq Rtn (CheckSequenceShapeOnSheet EnameSheet T))
					(cond 
						((= Rtn 2) (LM:popup "Avvertimento" "Aggiorno la sequenza dei contorni\n [AddSequenceGroupOnSheet]" 	(+ 0 48 4096))
							(GuiSymula02 EnameSheet)
						)
						((= Rtn 3) (LM:popup "Avvertimento" "Aggiorno la sequenza dei contorni\n [DelSequenceGroupOnSheet]"		(+ 0 48 4096))
							(GuiSymula02 EnameSheet)
						)
						((= Rtn 4) (LM:popup "Avvertimento" "Lamiera vuota rimuovo la sequenza\n [RemoveSequenceGroupOnSheet]"  (+ 0 48 4096))
							(GuiSymula02 EnameSheet)
						)
						((= Rtn 5) (LM:popup "Errore" "Sequenza vuota"  (+ 0 16 4096))
							(if (setq TypeSequence (GetTypeSequnce EnameSheet))
								(UpDateCutSequence EnameSheet (atoi TypeSequence) T)
								(if (setq x (ChoiseSequnceCut01 nil))
									(PutSequenceGroupOnSheet  EnameSheet x)
									(exit)
								)
							)
							(GuiSymula02 EnameSheet)
						)
						((= Rtn 6) (LM:popup "Errore" "Lamiera vuota nessuna contorno presente"       		 (+ 0 16 4096)))
					)
				)
			)
			(if GoTrigger
				(if (setq FileError (GetErrorTriggerOnSheet EnameSheet))
					(if (findfile FileError) (InfoCutError FileError))
				)
			)
			(if GoWalk 			(ViewSequenceCutWalkOnSheet EnameSheet))
			(if GoPartProgramm 	(PostProccessSheet 			EnameSheet))
		)
	)
)
;
;
(defun GetErrorTriggerOnSheet (EnameSheet / FileError DataSheet FlagFileErr Num Nel itm LstShapeExternal LstShapeInternal 
											LstEname EnameTrigger EnameEntra EnameEsci)
											 
											 
	(if EnameSheet
		(progn
			(setq DataSheet (GetDataSheetByEname EnameSheet))
			(setq FileError (strcat CutPathEasyCut$ (nth 1 DataSheet) ".err")) 
			(vl-file-delete  FileError)
					
			(setq FlagFileErr "w")
			(setq LstShapeExternal (GetEnameShapeByEnameSheet EnameSheet "CE"))
			(setq LstShapeInternal (GetEnameShapeByEnameSheet EnameSheet "CI"))
					
					
			(setq Num 1)
			(setq Nel (length LstShapeInternal))
			(StartProgressBar "Contorni interni:" Nel)
			(princ (testo_a_sinistra "\n" 100))
					
			(foreach itm LstShapeInternal

				(UpDateProgressBar)
				(princ "\rGetErrorTriggerOnSheet") (princ (strcat "[" (LM:rtos Num 2 0) "/" (LM:rtos Nel 2 0) "] " (vl-princ-to-string itm))) 
			
				(setq EnameTrigger (GetEnameTriggerByEnameShape itm))
				(setq EnameEntra (nth 0 EnameTrigger))
				(setq EnameEsci  (nth 1 EnameTrigger))
			
				(cond
					((and EnameEntra EnameEsci)
						(if (not (Contorno+Attacchi itm EnameEntra EnameEsci))
							(progn 
								(WriteErrorDataTrigger itm -1 -1 FileError FlagFileErr)
								(if (= FlagFileErr "w")	(setq FlagFileErr "a"))
							)	
						)
					)
					((and EnameEntra (not EnameEsci))
						(WriteErrorDataTrigger itm EnameEntra EnameEsci FileError FlagFileErr)
						(if (= FlagFileErr "w")(setq FlagFileErr "a"))
					)
					((and (not EnameEntra) EnameEsci)
						(WriteErrorDataTrigger itm EnameEntra EnameEsci FileError FlagFileErr)
						(if (= FlagFileErr "w")(setq FlagFileErr "a"))
					)
				)
				(setq Num (1+ Num))
			)
			(ClearProgressBar)
			;
			;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(setq Num 1)
			(setq Nel (length LstShapeExternal))
			(StartProgressBar "Contorni esterni:" Nel)
			(princ (testo_a_sinistra "\n" 100))
					
			(foreach itm LstShapeExternal
		
				(UpDateProgressBar)
				(princ "\rGetErrorTriggerOnSheet") (princ (strcat "[" (LM:rtos Num 2 0) "/" (LM:rtos Nel 2 0) "] " (vl-princ-to-string itm))) 

				(setq EnameTrigger (GetEnameTriggerByEnameShape itm))
				(setq EnameEntra (nth 0 EnameTrigger))
				(setq EnameEsci  (nth 1 EnameTrigger))
	
				(cond
					((and EnameEntra EnameEsci)
						(if (not (Contorno+Attacchi itm EnameEntra EnameEsci))
							(progn 
								(WriteErrorDataTrigger itm -1 -1 FileError FlagFileErr)
								(if (= FlagFileErr "w")(setq FlagFileErr "a"))
							)
						)
					)
					((and EnameEntra (not EnameEsci))
						(WriteErrorDataTrigger itm EnameEntra EnameEsci FileError FlagFileErr)
						(if (= FlagFileErr "w")(setq FlagFileErr "a"))
					)
					((and (not EnameEntra) EnameEsci)
						(WriteErrorDataTrigger itm EnameEntra EnameEsci FileError FlagFileErr)
						(if (= FlagFileErr "w")(setq FlagFileErr "a"))
					)
					((and (not EnameEntra) (not EnameEsci))
						(WriteErrorDataTrigger itm EnameEntra EnameEsci FileError FlagFileErr)
						(if (= FlagFileErr "w")(setq FlagFileErr "a"))
					)	
				)
				(setq Num (1+ Num))
			)
			(ClearProgressBar)
		)
	)
	(princ "\n")
	FileError
)
;
;
;
(defun CheckSequenceTriggerOnSheet (EnameSheet / itm LstEname LstShapeExternal LstShapeInternal
												 Num Nel Rtn Loop EnameShape EnameTrigger EnameEntra EnameEsci)
	;
	(if EnameSheet
		(progn
			
			(setq LstShapeExternal (GetEnameShapeByEnameSheet EnameSheet "CE"))
			(setq LstShapeInternal (GetEnameShapeByEnameSheet EnameSheet "CI"))

			(setq Num 0)
			(setq Nel (length LstShapeInternal))
			(setq Rtn T)
			(setq Loop T)
			(if (> Nel 0)
				(progn
					(StartProgressBar "Contorni interni:" (length LstShapeInternal))
					(princ (testo_a_sinistra "\n" 100))
					
					(while Loop
						(setq EnameShape (nth Num LstShapeInternal))
						(UpDateProgressBar)
						(princ "\rCheckSequenceTriggerOnSheet") (princ (strcat "[" (LM:rtos (1+ Num) 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ EnameShape)
						(setq Num (1+ Num))
						(setq EnameTrigger (GetEnameTriggerByEnameShape EnameShape))
						(setq EnameEntra (nth 0 EnameTrigger))
						(setq EnameEsci  (nth 1 EnameTrigger))
						(cond
							((or (and (not EnameEntra)      EnameEsci)
								 (and      EnameEntra  (not EnameEsci)))
									(setq Rtn nil)
									(setq Loop nil)
							)
							((and EnameEntra EnameEsci)
								(if (not (Contorno+Attacchi EnameShape EnameEntra EnameEsci))
									(progn
										(setq Rtn nil)
										(setq Loop nil)
									)
								)
							)
						)
						(if (= Num (length LstShapeInternal)) (setq Loop nil))
					)
					(ClearProgressBar)
				)
			)
			;
			;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(if Rtn
				(progn
					(setq Num 0)
					(setq Nel (length LstShapeExternal))
					(princ (testo_a_sinistra "\n" 100))
					(setq Loop T)

					(StartProgressBar "Contorni esterni:" (length LstShapeExternal))
					(while Loop
						(setq EnameShape (nth Num LstShapeExternal))
						(UpDateProgressBar)
						(princ "\rCheckSequenceTriggerOnSheet") (princ (strcat "[" (LM:rtos (1+ Num) 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ EnameShape)
						(setq Num (1+ Num))
				
						(setq EnameTrigger (GetEnameTriggerByEnameShape EnameShape))
						(setq EnameEntra (nth 0 EnameTrigger))
						(setq EnameEsci  (nth 1 EnameTrigger))
				
						(cond
							((or (and (not EnameEntra) (not EnameEsci))
								 (and (not EnameEntra)      EnameEsci)
								 (and      EnameEntra  (not EnameEsci)))
						 
								(setq Rtn nil)
								(setq Loop nil)
							)
							((and EnameEntra EnameEsci)
								(if (not (Contorno+Attacchi EnameShape EnameEntra EnameEsci))
									(progn
										(setq Rtn nil)
										(setq Loop nil)
									)
								)
							)
						)
						(if (= Num (length LstShapeExternal)) (setq Loop nil))
					)
					(ClearProgressBar)
				)
			)
		)
	)
	(princ "\n")
	Rtn
)