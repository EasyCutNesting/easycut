(defun ChoiseSequnceCut01 (SortType / PutChoseSequenceCut GetChoseSequenceCut xx)

	;
	(defun PutChoseSequenceCut (SortType)
	
		(if SortType
			(cond
				((= SortType "1") (setq $ChoseSequenceCut01 (list "1" "0" "0" "0")))
				((= SortType "2") (setq $ChoseSequenceCut01 (list "0" "1" "0" "0")))
				((= SortType "3") (setq $ChoseSequenceCut01 (list "0" "0" "1" "0")))
				((= SortType "4") (setq $ChoseSequenceCut01 (list "0" "0" "0" "1")))
			)
			(if (not $ChoseSequenceCut01) (setq $ChoseSequenceCut01 (list "1" "0" "0" "0")))
		)
		
		(set_tile "Type1" (nth 0 $ChoseSequenceCut01))
		(set_tile "Type2" (nth 1 $ChoseSequenceCut01))
		(set_tile "Type3" (nth 2 $ChoseSequenceCut01))
		(set_tile "Type4" (nth 3 $ChoseSequenceCut01))
	)
	;
	(defun GetChoseSequenceCut (/ Rtn)
		(setq $ChoseSequenceCut01 (list (get_tile "Type1") (get_tile "Type2") 
										(get_tile "Type3") (get_tile "Type4")))
		
		(if (= (nth 0 $ChoseSequenceCut01) "1") (setq Rtn 1))
		(if (= (nth 1 $ChoseSequenceCut01) "1") (setq Rtn 2))
		(if (= (nth 2 $ChoseSequenceCut01) "1") (setq Rtn 3))
		(if (= (nth 3 $ChoseSequenceCut01) "1") (setq Rtn 4))
		Rtn
	)
	;
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "ChoiseSequenceCut01" xx "" (cond ( *ChoseSequenceCut01* ) ( '(-1 -1) )))
	(PutChoseSequenceCut SortType)
	
	
	(action_tile "accept" "(setq Rtn (GetChoseSequenceCut) *ChoseSequenceCut* (done_dialog)) (unload_dialog xx)")
	(action_tile "cancel" "(setq Rtn nil *ChoseSequenceCut* (done_dialog)) (unload_dialog xx)")
	(start_dialog)
	 Rtn

)
;
(defun ChoiseSequnceCut02 (SortType / PutChoseSequenceCut GetChoseSequenceCut xx)

	;
	(defun PutChoseSequenceCut (SortType)
	
		(if SortType
			(cond
				((= SortType "1") (setq $ChoseSequenceCut02 (list "1" "0" "0" "0" "0")))
				((= SortType "2") (setq $ChoseSequenceCut02 (list "0" "1" "0" "0" "0")))
				((= SortType "3") (setq $ChoseSequenceCut02 (list "0" "0" "1" "0" "0")))
				((= SortType "4") (setq $ChoseSequenceCut02 (list "0" "0" "0" "1" "0")))
			)
			(if (not $ChoseSequenceCut02) (setq $ChoseSequenceCut02 (list "1" "0" "0" "0" "0")))
		)
		
		(set_tile "Type1" (nth 0 $ChoseSequenceCut02))
		(set_tile "Type2" (nth 1 $ChoseSequenceCut02))
		(set_tile "Type3" (nth 2 $ChoseSequenceCut02))
		(set_tile "Type4" (nth 3 $ChoseSequenceCut02))
		(set_tile "Type5" (nth 4 $ChoseSequenceCut02))
	)
	;
	(defun GetChoseSequenceCut (/ Rtn)
		(setq $ChoseSequenceCut02 (list (get_tile "Type1") (get_tile "Type2") 
										(get_tile "Type3") (get_tile "Type4") (get_tile "Type5")))
		
		(if (= (nth 0 $ChoseSequenceCut02) "1") (setq Rtn 1))
		(if (= (nth 1 $ChoseSequenceCut02) "1") (setq Rtn 2))
		(if (= (nth 2 $ChoseSequenceCut02) "1") (setq Rtn 3))
		(if (= (nth 3 $ChoseSequenceCut02) "1") (setq Rtn 4))
		(if (= (nth 4 $ChoseSequenceCut02) "1") (setq Rtn 5))
		Rtn
	)
	;
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "ChoiseSequenceCut02" xx "" (cond ( *ChoseSequenceCut02* ) ( '(-1 -1) )))
	(PutChoseSequenceCut SortType)
	
	
	(action_tile "accept" "(setq Rtn (GetChoseSequenceCut) *ChoseSequenceCut* (done_dialog)) (unload_dialog xx)")
	(action_tile "cancel" "(setq Rtn nil *ChoseSequenceCut* (done_dialog)) (unload_dialog xx)")
	(start_dialog)
	 Rtn

)
;
(defun ChoisePartProgramm (/ PutChoisePartProgramm GetChoisePartProgramm xx)

	;
	(defun PutChoisePartProgramm ()
	
		(if (not $ChoisePartProgramm) (setq $ChoisePartProgramm (list "1" "0" "0" "0")))
		
		(set_tile "Type1" (nth 0 $ChoisePartProgramm))
		(set_tile "Type2" (nth 1 $ChoisePartProgramm))
		(set_tile "Type3" (nth 2 $ChoisePartProgramm))
		(set_tile "Type4" (nth 3 $ChoisePartProgramm))
	)
	;
	(defun GetChoisePartProgramm (/ Rtn)
		(setq $ChoisePartProgramm (list (get_tile "Type1") (get_tile "Type2") 
										(get_tile "Type3") (get_tile "Type4")))
		
		(if (= (nth 0 $ChoisePartProgramm) "1") (setq Rtn 1))
		(if (= (nth 1 $ChoisePartProgramm) "1") (setq Rtn 2))
		(if (= (nth 2 $ChoisePartProgramm) "1") (setq Rtn 3))
		(if (= (nth 3 $ChoisePartProgramm) "1") (setq Rtn 4))
		Rtn
	)
	;
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "ChoisePartProgramm" xx "" (cond ( *ChoisePartProgramm* ) ( '(-1 -1) )))
	(PutChoisePartProgramm)
	
	
	(action_tile "accept" "(setq Rtn (GetChoisePartProgramm) *ChoisePartProgramm* (done_dialog)) (unload_dialog xx)")
	(action_tile "cancel" "(setq Rtn nil *ChoisePartProgramm* (done_dialog)) (unload_dialog xx)")
	(start_dialog)
	 Rtn

)
;
;(defun StartSymula ( / EnameSheet)
;	(prompt "\nSeleziona la lamiera ....")
;	(setq EnameSheet (car (entsel)))
;	(if (setq EnameSheet (GetEnameSheetByDummyEname EnameSheet))
;		(GuiSymula02 EnameSheet)
;		(LM:popup "Avvertimento" "Non e' una lamiera [StartSymula]"  (+ 0 48 4096))
;	)
;)
(defun PostProcessorSheetGui ( / Ename EnameSheet EnameShape)
	(prompt "\nSeleziona la lamiera o il contorno ....")
	(setq Ename (car (entsel)))
	(if (setq EnameSheet (GetEnameSheetByDummyEname Ename))
		(GuiSymula02 EnameSheet)
		(LM:popup "Avvertimento" "Non e' una lamiera [PostProcessorSheetGui]"  (+ 0 48 4096))
	)
)
;
;
(defun PostProcessorShapeGui ( / Ename EnameSheet EnameShape)
	(prompt "\nSeleziona la lamiera o il contorno ....")
	(setq Ename (car (entsel)))
	
	(if (setq EnameShape (GetEnameShapeByDummyEnameSelect Ename))
		(GuiSymula03 EnameShape)
		(LM:popup "Avvertimento" "Non e' un contorno [PostProcessorShapeGui]"  (+ 0 48 4096))
	)
)
;
;
;
(defun GuiSymula03 (EnameShape / Loop xx LstSequence TypeSequence Rtn Rtn1 Rtn2 GoWalk GoSequence GoTrigger GoPartProgramm FileError)

	(if EnameShape
		(progn
			;(SequenceCut EnameSheet)
			
			(setq Loop T)
			(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
			
				(new_dialog "CheckCut03" xx "" (cond ( *CheckCut* ) ( '(-1 -1) )))

				(mode_tile "trigger"				1)
				(mode_tile "resulttrigger"			1)
				(mode_tile "infotrigger"			1)
				
				(mode_tile "walk"					1)
				(mode_tile "resultwalk"				1)
				(mode_tile "infowalk"				1)
				
				(mode_tile "PartProgramm"   		1)
				(mode_tile "ResultPartProgramm"		1)
				(mode_tile "StartPartProgramm"		1)
				
				
				(setq Rtn1 "Passato")
				(if (= Rtn1 "Passato")
					(set_tile "resulttrigger" 	(if (= (CheckTrigger EnameShape) 4)
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
														(mode_tile "infotrigger" 	0)
														(setq Rtn2 "Non passato")
													)
												)
					)
				)
				
				(action_tile "infowalk" 	(strcat "(setq *CheckCut* (done_dialog)) (unload_dialog xx)"
													"(setq GoWalk T)"
											)
				)
				;(action_tile "infotrigger"  (strcat "(setq *CheckCut* (done_dialog)) (unload_dialog xx)"
				;									"(setq GoTrigger T)"
				;							)
				;)
				(action_tile "StartPartProgramm"  (strcat "(setq *CheckCut* (done_dialog)) (unload_dialog xx)"
													"(setq GoPartProgramm T)"
											)
				)
				(action_tile "accept"           (strcat "(setq *CheckCut* (done_dialog)) (unload_dialog xx)"))
				(start_dialog)		
			
			
			;(if GoTrigger
			;	(if (setq FileError (GetErrorTriggerOnSheet EnameSheet))
			;		(if (findfile FileError) (InfoCutError FileError))
			;	)
			;)
			(if GoWalk 			(ViewSequenceCutWalkOnShape EnameShape))
			(if GoPartProgramm 	(PostProccessShape 			EnameShape))
		)
	)
)
;
;
;
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
				
				(set_tile "resulttrigger"		(if (CheckTriggerOnSheet EnameSheet)
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
;
(defun UpDateCutSequence (EnameSheet TypeSequence Verbose / LstTypeSequence Rtn)

	
	(if (and EnameSheet TypeSequence)
		(progn
			(setq LstTypeSequence (list "-" "[1 Superficie maggiore]" "[2 Superficie minore]" "[3 Vicino a..]" "[4 X/Y]"))
			
			(if (null (nth TypeSequence LstTypeSequence))
				(progn
					(setq TypeSequence 1)
					(setq $Sequence    1)
				)
			)
			
			
			(princ (strcat "\nSequenza tipo --->" (nth TypeSequence LstTypeSequence)))
					
			(setq Rtn (CheckSequenceShapeOnSheet EnameSheet T))
			(cond 
				((= Rtn 2) (if Verbose (LM:popup "Avvertimento" "Aggiornato la sequenza dei contorni\n [AddSequenceGroupOnSheet]" 	(+ 0 48 4096))))
				((= Rtn 3) (if Verbose (LM:popup "Avvertimento" "Aggiornato la sequenza dei contorni\n [DelSequenceGroupOnSheet]"	(+ 0 48 4096))))
				((= Rtn 4) (if Verbose (LM:popup "Avvertimento" "Lamiera vuota rimosso la sequenza\n [RemoveSequenceGroupOnSheet]"  (+ 0 48 4096))))
				((= Rtn 5) (if Verbose (LM:popup "Avvertimento" "Sequenza vuota \n aggiorno la sequenza"  (+ 0 16 4096)))
					(PutSequenceGroupOnSheet EnameSheet TypeSequence)
				)
				((= Rtn 6) (if Verbose (LM:popup "Avvertimento" "Lamiera vuota nessuna contorno presente"       (+ 0 16 4096)))))
		)
	)
)
;
;
;
(defun GuiSequenceCut (/ Ssel EnameSheet x)


	(prompt "\nSelezionare la lamiera")
	(setq Ssel (ssget "_+.:E:S" (list (list -3 (list (strcat $RgpSheet "," $RgpSheetTarget))))))
	(if Ssel	
		(progn
			(setq EnameSheet (GetEnameSheetByDummyEname (ssname Ssel 0)))
			(if (setq x (ChoiseSequnceCut02 (GetTypeSequnce EnameSheet)))
				(if (= x 5)
					(progn
						(RemoveSequenceGroupOnSheet EnameSheet)
						(alert "[GuiSequenceCut] Sequenza rimossa")
					)
					(progn
						(if (setq FileError (GetErrorTriggerOnSheet EnameSheet))
							(if (findfile FileError) 
								(InfoCutError FileError)
								(PutSequenceGroupOnSheet  EnameSheet x)
							)
						)
					)
				)
			)
		)
		(alert "Lamiera non riconosciuta")
	)
)
;
; Simula
;
(defun CheckSequenceShapeOnSheet (EnameSheet Change / Sheet CheckZoom Ssel Num GrpName LstGrpName1 LstGrpName2 
													  DataSequence TypeSequence itm LstGrpName11 Rtn)

	
	(if EnameSheet
		(progn

			;(setq Sheet (DiscretizeShape EnameSheet))
			(setq Sheet (DiscretizeShapeNoControl EnameSheet))
					
			(setq CheckZoom (VisibleEname EnameSheet))
			(setq Ssel (ssget "_CP" Sheet (list (list -3 (list (strcat $RgpShape "," $RgpTiggerOn "," $RgpTiggerOff))))))
			(ZoomPrevius CheckZoom)
			
			(setq Num 0)			
			(if Ssel
				(repeat (sslength Ssel)
					(setq GrpName (gnames (ssname Ssel Num)))
					(if (not (member (nth 0 GrpName) LstGrpName1))
						(setq LstGrpName1 (append LstGrpName1 (list (nth 0 GrpName))))
					)
					(setq Num (1+ Num))
				)
			)
			(if (setq DataSequence (GetSequenceGroupOnSheet EnameSheet))
				(setq LstGrpName2  (cdr DataSequence))
			)
			;
			; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(cond
				((= (EqualValueOnList LstGrpName1 LstGrpName2) T)
					(setq Rtn 1)
				)
				((and LstGrpName1 LstGrpName2)
					(foreach itm LstGrpName1
						(if (member itm LstGrpName2)
							(setq LstGrpName2 (vl-remove itm LstGrpName2))
							(setq LstGrpName11 (append LstGrpName11 (list itm)))
						)
					)
					
					(if LstGrpName2
						(progn
							(setq Rtn 3)
							;(LM:popup "Avvertimento" "Aggiorno la sequenza dei contorni (DEL)" (+ 1 48 4096))
							(if Change
								(progn
									(setq TypeSequence (GetTypeSequnce EnameSheet))
									(DelSequenceGroupOnSheet EnameSheet LstGrpName2)
								)
							)
						)
					)

					(if LstGrpName11
						(progn
							(setq Rtn 2)
							;(LM:popup "Avvertimento" "Aggiorno la sequenza dei contorni (ADD)" (+ 1 48 4096))
							(if Change
								(AddSequenceGroupOnSheet EnameSheet LstGrpName11 TypeSequence)
							)
						)
					)
				)
				
				((and (not LstGrpName1) LstGrpName2)
					(setq Rtn 4)
					;(LM:popup "Avvertimento" "Lamiera vuota rimuovo la sequenza" (+ 1 48 4096))
					(if Change
						(RemoveSequenceGroupOnSheet EnameSheet)
					)
				)
				((and LstGrpName1 (not LstGrpName2))
					(setq Rtn 5)
					;(LM:popup "Errore" "Sequenza vuota (esegui nuova Sequenza) " (+ 1 16 4096))
				)
				((and (not LstGrpName1) (not LstGrpName2))
					(setq Rtn 6)
					;(LM:popup "Errore" "Lamiera vuota (nessuna sequenza)" (+ 1 16 4096))
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun InfoCutError (FileName / LstError xx Loop Rtn)


		;
		;
		;
		(defun FormatInofoFileErrorCut (FileName / Rtn Stream Row RowSplit PrgItm Flag RowTmp itm)
		
			(if FileName
				(progn
				
					;(setq Rtn (list "Prog\tId contorno\tMarca\tTipo contorno\tHandle\tAttacco ingresso\tAttacco uscita"))
				
					(setq Stream (open FileName "r")) 
					(if (not Stream)
						(progn
							(alert (strcat "ERRORE!! apertura file" FileName))
							(exit)
						)
						(setq Row (read-line Stream))
					)
					; | id contorno | 425496198 | marca | 011124 | tipo contorno | CI | Handle | 512 | Attacco ingresso | assente  | Attacco uscita |  assente
					; 1    425496198    011124    CI    512    assente    assente
					(setq PrgItm 1)
					(while Row
						(setq RowSplit (splitxt Row "|"))
						(setq Flag nil)
						(setq RowTmp (rtos PrgItm 2 0))
						
						(foreach itm RowSplit
							(if Flag 
								(setq RowTmp (strcat RowTmp "\t" (vl-string-trim " " itm))
									  Flag nil
								)
								(setq Flag T)
							)
						)
						(setq PrgItm (1+ PrgItm))
						(setq Rtn (append Rtn (list RowTmp)))
						(setq Row (read-line Stream))
					)
					(close Stream)
				)
			)
			Rtn
		)
		;
		;
		;
		(defun Get_Tile_IdShape (LstError / Itm ErrorItm)
			
			;(princ "\n-------< Reason ") (princ $reason)
			(if (and LstError (= 4 $reason))
				(progn
					(setq Itm      (get_tile "box_info"))
					(setq ErrorItm (nth (atoi Itm) LstError))
					(setq *InfoCutError* (done_dialog))
					(unload_dialog xx)
				)
			)
			
			
			ErrorItm
		)
		;
		;
		(setq LstError (FormatInofoFileErrorCut FileName))
		(if LstError
			(progn
				
				(setq Loop T)
				(while Loop
					(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
					(new_dialog "InfoCutError" xx "" (cond ( *InfoCutError* ) ( '(-1 -1) )))
					(start_list "box_info")
						(mapcar 'add_list LstError)
					(end_list)
					(start_list "box_label")
						(mapcar 'add_list (list "Prog\tId contorno\tMarca\tTipo contorno\tHandle\tAttacco ingresso\tAttacco uscita"))
					(end_list)

					(action_tile "box_info"   "(setq Rtn (Get_Tile_IdShape LstError))")
					(action_tile "accept"     "(setq *InfoCutError* (done_dialog)) (unload_dialog xx) (setq Loop nil)")
					(start_dialog)
				
					(if Rtn
						(progn
							;(alert Rtn)
							;(alert (nth 4 (LM:str->lst Rtn "\t")))
							(if (handent (nth 4 (LM:str->lst Rtn "\t")))
								(ZoomEname (handent (nth 4 (LM:str->lst Rtn "\t"))) 50)
							)
							(setq Rtn nil)
						)
							
					)
				)
			)
		)
)
;
;
;
(defun PutSequenceGroupOnSheet (EnameSheet TypeSequence / DataSheet Sheet CheckZoom Ssel Num 
														  ultent xd_list Grp nuova_entita itm 
														  LstExternalShape LstEnameSequence LstGroupShapeSort)


	(if (and EnameSheet TypeSequence)
		(progn
			(setq DataSheet (GetDataSheetByEname EnameSheet))
			(if DataSheet
				(progn
					;	0        1          2          3           4           5           6			7
					;(IdSheet NameSheet Widthsheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatShape)
					;
					;(setq Sheet     (DiscretizeShape EnameSheet))
					(setq Sheet     (DiscretizeShapeNoControl EnameSheet))
					(setq CheckZoom (VisibleEname EnameSheet))
					(setq Ssel      (ssget "_CP" Sheet (list (cons 0 "LWPOLYLINE") (list -3 (list $RgpShape)))))
					(ZoomPrevius CheckZoom)					
					
					(if Ssel	
						(progn
							(setq Num 0)
							(repeat (sslength Ssel)
								(if (= (GetTypShape (ssname Ssel Num)) "CE")
									(setq LstExternalShape (append LstExternalShape (list (ssname Ssel Num))))
								)
								(setq Num (1+ Num))
							)
							
							(cond 
								;((= TypeSequence 1) ; ordina casuale
								;	(setq LstEnameSequence LstExternalShape)
								;)
								((= TypeSequence 1) ; ordina per superficie >
									(setq LstEnameSequence (SortArea LstExternalShape 1))
								)
								((= TypeSequence 2) ; ordina per superficie <
									(setq LstEnameSequence (SortArea LstExternalShape -1))
								)
								((= TypeSequence 3) ; ordina per vicinanza
									(setq LstEnameSequence (SortAreaNearTo LstExternalShape (GetOriginSheet EnameSheet)))
								)
								((= TypeSequence 4) ; ordina X Y
									(setq LstEnameSequence (SortAreaXY LstExternalShape))
								)
								;((= TypeSequence 5) ; Select
								;	(setq LstEnameSequence (LoopSelectShape))
								;)
							)
					
							(foreach itm LstEnameSequence
								(setq LstGroupShapeSort (append LstGroupShapeSort (Gnames itm)))
							)
					
							(setq ultent (entget EnameSheet)
								  xd_list (list '(1002 . "}"))
							)
							(foreach Grp (reverse LstGroupShapeSort)
								(setq xd_list (cons (cons 1000 Grp) xd_list))
							)
							(setq xd_list (cons (cons 1000 (LM:rtos TypeSequence 2 0))  xd_list)
								  xd_list (cons (cons 1000 (nth 7 DataSheet))  xd_list)
								  xd_list (cons (cons 1000 (nth 4 DataSheet))  xd_list)
								  xd_list (cons (cons 1000 (nth 0 DataSheet))  xd_list)
								  xd_list (cons (cons 1000 (nth 1 DataSheet))  xd_list)
								  xd_list (cons '(1002 . "{") xd_list)
								  xd_list (cons $RgpSheet xd_list)
								  xd_list (list -3 xd_list)
								  nuova_entita (append ultent (list xd_list))
							)
							(entmod nuova_entita)
							(entupd EnameSheet)	
						)
						(RemoveSequenceGroupOnSheet EnameSheet)
					)
				)
			)
		)
	)
)
;
;
;
(defun AddSequenceGroupOnSheet (EnameSheet LstGrpName TypeSequence / DataSequence DataSheet TypSq LstNewGroup itm LstEnameShape 
																	 ultent xd_list nuova_entita)
	
	(if (and EnameSheet LstGrpName)
		(progn
			(setq DataSequence (GetSequenceGroupOnSheet EnameSheet)) 	
			;("1" "123456" "78910")
			(foreach itm (append (cdr DataSequence) LstGrpName)
				(setq LstEnameShape (append LstEnameShape (list (car (GetShapeByGroup itm)))))
			)
			;
			(setq DataSheet    (GetDataSheetByEname EnameSheet))
			;    0           1            2            3            4             5              6
			;("IdSheet" "NameSheet" "Widthsheet" "HeightSheet" "ThickSheet" "SurfaceSheet" "WeightSheet")
			;
			(if (not DataSequence)
				(setq TypSq TypeSequence)
				(setq TypSq (car DataSequence))
			)
				
			
			(cond 
				;((= TypSq "1") ; libero
				;	(setq LstEnameShape LstEnameShape)
				;)
				((= TypSq "1") ; ordinato per superficie
					(setq LstEnameShape (SortArea LstEnameShape 1))
				)
				((= TypSq "2") ; ordinato per superficie
					(setq LstEnameShape (SortArea LstEnameShape -1))
				)
				((= TypSq "3") ; ordinato per vicinanza
					(setq LstEnameShape (SortAreaNearTo LstEnameShape (GetOriginSheet EnameSheet)))
				)
				((= TypSq "4") ; ordina X Y
					(setq LstEnameShape (SortAreaXY LstEnameShape))
				)
				;((= TypSq "5") ; Select
				;	(setq LstEnameShape (LoopSelectShape))
				;)
			)
			
			(foreach itm LstEnameShape
				(setq LstNewGroup (append LstNewGroup (Gnames itm)))
			)
			
			(if LstNewGroup
				(progn
					(setq ultent (entget EnameSheet)
						  xd_list (list '(1002 . "}"))
					)
					(foreach itm (reverse LstNewGroup)
						(setq xd_list (cons (cons 1000 itm) xd_list))
					)	
					(setq xd_list (cons (cons 1000 TypSq)  				xd_list)
						  xd_list (cons (cons 1000 (nth 7 DataSheet))   xd_list)
					      xd_list (cons (cons 1000 (nth 4 DataSheet))   xd_list)
					      xd_list (cons (cons 1000 (nth 0 DataSheet))   xd_list)
					      xd_list (cons (cons 1000 (nth 1 DataSheet))   xd_list)
					      xd_list (cons '(1002 . "{") xd_list)
					      xd_list (cons $RgpSheet xd_list)
					      xd_list (list -3 xd_list)
					      nuova_entita (append ultent (list xd_list))
				    )
				    (entmod nuova_entita)
				    (entupd EnameSheet)		
				)
			)
		)
	)
)
;
;
;
(defun DelSequenceGroupOnSheet (EnameSheet LstGrpName / DataSequence DataSheet LstNewGroup itm ultent xd_list nuova_entita)
	
	(if (and EnameSheet LstGrpName)
		(progn
			(setq DataSequence (GetSequenceGroupOnSheet EnameSheet)) 	
			;("1" "123456" "78910")
			(setq DataSheet    (GetDataSheetByEname EnameSheet))
			;    0           1            2            3            4             5              6
			;("IdSheet" "NameSheet" "Widthsheet" "HeightSheet" "ThickSheet" "SurfaceSheet" "WeightSheet")
			;
			(setq LstNewGroup (cdr DataSequence))
			(foreach itm LstGrpName
				(setq LstNewGroup (vl-remove itm LstNewGroup))
			)
			(if LstNewGroup
				(progn
					(setq ultent (entget EnameSheet)
						  xd_list (list '(1002 . "}"))
					)
					(foreach itm (reverse LstNewGroup)
						(setq xd_list (cons (cons 1000 itm) xd_list))
					)	
					(setq xd_list (cons (cons 1000 (car DataSequence))  xd_list)
						  xd_list (cons (cons 1000 (nth 7 DataSheet))   xd_list)
					      xd_list (cons (cons 1000 (nth 4 DataSheet))   xd_list)
					      xd_list (cons (cons 1000 (nth 0 DataSheet))   xd_list)
					      xd_list (cons (cons 1000 (nth 1 DataSheet))   xd_list)
					      xd_list (cons '(1002 . "{") xd_list)
					      xd_list (cons $RgpSheet xd_list)
					      xd_list (list -3 xd_list)
					      nuova_entita (append ultent (list xd_list))
				    )
				    (entmod nuova_entita)
				    (entupd EnameSheet)		
				)
				(RemoveSequenceGroupOnSheet EnameSheet)
			)
		)
	)
)
;
;
;
(defun RemoveSequenceGroupOnSheet (EnameSheet / DataSheet ultent xd_list nuova_entita)
	
	(if EnameSheet
		(progn
			(setq DataSheet (GetDataSheetByEname EnameSheet))
			;    0           1            2            3            4             5              6
			;("IdSheet" "NameSheet" "Widthsheet" "HeightSheet" "ThickSheet" "SurfaceSheet" "WeightSheet")
			(if DataSheet
				(progn
					(setq ultent (entget EnameSheet)
						  xd_list (list '(1002 . "}"))
						  xd_list (cons (cons 1000 (nth 7 DataSheet))  xd_list) ; materiale
						  xd_list (cons (cons 1000 (nth 4 DataSheet))  xd_list) ; spessore
						  xd_list (cons (cons 1000 (nth 0 DataSheet))  xd_list) ; id
						  xd_list (cons (cons 1000 (nth 1 DataSheet))  xd_list) ; nome
						  xd_list (cons '(1002 . "{") xd_list)
						  xd_list (cons $RgpSheet xd_list)
						  xd_list (list -3 xd_list)
						  nuova_entita (append ultent (list xd_list))
					)
					(entmod nuova_entita)
					(entupd EnameSheet)
				)
			)
		)
	)
)
;
;
;
(defun CheckTriggerOnSheet (EnameSheet / itm LstEname LstShapeExternal LstShapeInternal
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
						(princ "\rCheckTriggerOnSheet") (princ (strcat "[" (LM:rtos (1+ Num) 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ EnameShape)
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
						(princ "\rCheckTriggerOnSheet") (princ (strcat "[" (LM:rtos (1+ Num) 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ EnameShape)
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
;
;
;
(defun CheckSequenceTriggerOnShape (EnameShape / LstEname LstShapeExternal LstShapeInternal
												 Num Nel Rtn Loop EnameShape EnameTrigger EnameEntra EnameEsci)
	;
	;
	(if EnameShape
		(progn
			
			(setq LstEname (GetShapeByGroup (car (Gnames EnameShape))))
			(setq LstShapeExternal (append  LstShapeExternal (list (car LstEname))))
			(setq LstShapeInternal (append  LstShapeInternal (cdr LstEname)))
			

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
						(princ "\rCheckSequenceTriggerOnShape") (princ (strcat "[" (LM:rtos (1+ Num) 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ EnameShape)
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
						(princ "\rCheckSequenceTriggerOnShape") (princ (strcat "[" (LM:rtos (1+ Num) 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ EnameShape)
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
;
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
(defun Contorno+Attacchi (EnameShape EnameEntra EnameEsci / StartEndPt LstPtEn LstPtEs Rtn NVertices Check AddPtEn AddPtEs InvertiEn InvertiEs )


	(defun StartEndPt (Ename / startPoint endPoint TypeEnt cenPoint Radius Rtn)
		(if Ename
			(progn
				(setq TypeEnt (cdr (assoc 0 (entget Ename))))
				(cond
					((= TypeEnt "LINE")
						 (setq startPoint (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint (vlax-ename->vla-object Ename)))))
						 (setq endPoint   (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint   (vlax-ename->vla-object Ename)))))
						 (setq Rtn 		  (list startPoint endPoint))
					)
					((= TypeEnt "ARC")
						 (setq startPoint (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint (vlax-ename->vla-object Ename)))))
						 (setq endPoint   (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint   (vlax-ename->vla-object Ename)))))
						 (setq cenPoint   (vlax-safearray->list (vlax-variant-value (vla-get-Center     (vlax-ename->vla-object Ename)))))
						 (setq Radius     (vla-get-Radius     (vlax-ename->vla-object Ename)))
						 ;
						 ; recupero il segno del raggio ++++++++++
						 ;
						 (setq segno (nth 1 (GetDataTrigger Ename)))
						 (if (= segno "-") (setq Radius (* Radius -1.0)))
						 (setq Rtn 		  (list startPoint endPoint cenPoint Radius))
					)
				)
			)
		)
		Rtn
	)
	;	
	(if (and EnameShape EnameEntra EnameEsci)
		(progn
				;(setq Check (CheckPoly EnameShape))
				
					
				; ******************* attacco ingresso ***********************
				(setq LstPtEn (StartEndPt EnameEntra))
				(setq AddPtEn nil)
				(setq InvertiEn -1)
				(if (MyEqualPoint (vlax-curve-getclosestpointto  (vlax-ename->vla-object EnameShape) (nth 0 LstPtEn)) (nth 0 LstPtEn)  1e-5)
					(progn
						(setq AddPtEn (append AddPtEn (nth 0 LstPtEn)))
						(setq InvertiEn 1)
					)
				)
				(if (MyEqualPoint (vlax-curve-getclosestpointto  (vlax-ename->vla-object EnameShape) (nth 1 LstPtEn)) (nth 1 LstPtEn)  1e-5)
					(setq AddPtEn (append AddPtEn (nth 1 LstPtEn)))
				)
				; **************** attacco uscita *****************************
				(setq LstPtEs (StartEndPt EnameEsci))
				(setq AddPtEs nil)
				(setq InvertiEs -1)
				(if (MyEqualPoint (vlax-curve-getclosestpointto  (vlax-ename->vla-object EnameShape) (nth 0 LstPtEs)) (nth 0 LstPtEs)  1e-5)
					(setq AddPtEs (append AddPtEs (nth 0 LstPtEs)))
				)
				(if (MyEqualPoint (vlax-curve-getclosestpointto  (vlax-ename->vla-object EnameShape) (nth 1 LstPtEs)) (nth 1 LstPtEs)  1e-5)
					(progn
						(setq AddPtEs (append AddPtEs (nth 1 LstPtEs)))
						(setq InvertiEs 1)
					)
				)
				
				; controllo quantita punti di attacco +++
				
				(cond
					((and (= (length AddPtEn) 3) (= (length AddPtEs) 3))
						(setq Rtn 1)
					)
					(t
						(setq Rtn -1)
					)
				)

				; controllo verso punti di attacco *************
				
				(if (= Rtn 1)
					(progn
					
					
						(cond
							((= (length LstPtEn) 2) ; retta
								(if (= InvertiEn 1) (setq LstPtEn (reverse LstPtEn)))
							)
							((= (length LstPtEn) 4) ; arco
								(if (= InvertiEn 1)
									(setq LstPtEn (list (nth 1 LstPtEn) (nth 0 LstPtEn) (nth 2 LstPtEn) (nth 3 LstPtEn)))
								)
							)
						)
						
						(cond
							((= (length LstPtEs) 2) ; retta
								(if (= InvertiEs 1) (setq LstPtEs (reverse LstPtEs)))
							)
							((= (length LstPtEs) 4) ; arco
								(if (= InvertiEs 1)
									(setq LstPtEs (list (nth 1 LstPtEs) (nth 0 LstPtEs) (nth 2 LstPtEs) (nth 3 LstPtEs)))
								)
							)
						)
					)
				)
				
				;(princ "--->") (princ Rtn) (princ "<---")
				(if (= Rtn 1)
					(progn
						(setq NVertices (FondiContorno EnameShape (list AddPtEn AddPtEs)))
						(if (nth 0 NVertices)
							(setq NVertices (append (list LstPtEn) (list (nth 1 NVertices)) (list LstPtEs)))
							(setq NVertices nil)
						)
					)
				)
				
				
		)
	)
	NVertices
)
;
;
;
(defun FondiContorno (EnameShape LstPtAdd / CloneInternalShape
											Vertices NewVertices NewShape itm chk EnameShapeClone)

	;
	(defun CloneInternalShape (EnameInternalShape Flag / DataInfo IdShape GrpLst Rtn
														 ultent xd_list conta itm)
		
			(if EnameInternalShape
				(progn
					(setq DataInfo 		(GetDataShape EnameInternalShape))
				
							; 0	TypShape   					*  ["CE"] ["CI"]		CE contorno esterno / CI contorno interno
							; 1	IdShape    					*  ["123456789"]		nome contorno -valore string-)
							; 2	JouShape   					*  ["0"] ["2"] ["3"]	percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria
							; 3	NameShape  					*  ["PIPPO"]			nome piatto
							; 4	CutComp    					*  ["0"]["1"]["2"]["3"]	compensazione taglio 0 nessuna / 1 auto 2 dx / 3 sx
							; 5	(rtos LenghtCut 2 2)		*  ["100.3"]  			lunghezza taglio
							; 6	(list Timing Extime Intime)	*  ["10 min 5 sec" "2 min 3 sec" "12 min 8 sec"] tempo di taglio
							; 7	ComShape   					*  ["C2018032"]  	 	nome commessa
							; 8	PhaseShape 					*  ["P100"]  	 	    nome fase
							; 9	MatShape   					*  ["S355J0"] 	 	    nome qualita'
							;10	TkShape    					*  ["10"]  	 	        spessore
							;11	DateShape  					*  ["10/11/2018"]  	 	ultima modifica
							;12	QtaShape  					*  ["100"]  	 		quantita
					
					(setq IdShape		(nth 1 DataInfo))
					(setq GrpLst 		(Gnames EnameInternalShape))
					(cond 
							; controllo se cerchio 
							((= (cdr (assoc 0 (entget EnameInternalShape))) "CIRCLE")
								(setq Rtn (Circle2LwPolyline EnameInternalShape Flag))
							)
							; controllo se ellisse
							((= (cdr (assoc 0 (entget EnameInternalShape))) "ELLIPSE")
								(setq Rtn (Ellipse2LwPolyline EnameInternalShape Flag))
							)
					)
					(setq Journey (CheckPoly Rtn))
					(if (and (= (nth 0 Journey) 2) (= (nth 2 DataInfo) "3")) (RevLwpline Rtn))
					(if (and (= (nth 0 Journey) 3) (= (nth 2 DataInfo) "2")) (RevLwpline Rtn))
					
					
					(if (and  IdShape GrpLst Rtn)
						(progn
								
							; aggancio i dati del contorno
							
							(setq 	ultent (entget Rtn)
									xd_list (list '(1002 . "}"))
							)
							(setq conta 0)
							(foreach itm (reverse DataInfo)
								(if (and (/= conta 5) (/= conta 6))
									(setq xd_list (cons (cons 1000 itm) xd_list))
								)
								(setq conta (1+ conta))
							)
							(setq 	xd_list (cons '(1002 . "{") xd_list)
									xd_list (cons $RgpShape xd_list)
									xd_list (list -3 xd_list)
									ultent (append ultent (list xd_list))
							)
							(entmod ultent)
							(entupd Rtn)
					
							; aggancio il gruppo
					
							(PutGroupToEname (nth 0 GrpLst) Rtn)
							
							(if (= (nth 2 DataInfo) "3") (vla-put-Color (vlax-ename->vla-object Rtn) $ColorHoleOra))
							(if (= (nth 2 DataInfo) "2") (vla-put-Color (vlax-ename->vla-object Rtn) $ColorHoleAntiOra))
							
						)
					)
				)
			)
			Rtn
	)
	;
	; Main
	; 
	(if (and EnameShape LstPtAdd)
		(progn


			(cond
				((= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
					(setq EnameShapeClone (CloneInternalShape EnameShape nil))
				)
				((= (cdr (assoc 0 (entget EnameShape))) "ELLIPSE")
					(setq EnameShapeClone (CloneInternalShape EnameShape nil))
				)
			)
			
			(if EnameShapeClone
				(progn
					(setq Vertices (LM:lwvertices (entget EnameShapeClone)))
					(setq NewShape (vlax-vla-object->ename (vla-Copy (vlax-ename->vla-object EnameShapeClone))))
					(entdel EnameShapeClone)
				)
				(progn
					(setq Vertices (LM:lwvertices (entget EnameShape)))
					(setq NewShape (vlax-vla-object->ename (vla-Copy (vlax-ename->vla-object EnameShape))))
				)
			)
			
			;(setq NewShape (vlax-vla-object->ename (vla-Copy (vlax-ename->vla-object EnameShape))))
			
			(foreach itm LstPtAdd
				(if (not (ExistVertexOnPolylineList	itm Vertices))
					(progn
						(vtx-add02 NewShape itm)
						(setq Vertices (LM:lwvertices (entget NewShape)))
					)
				)
			)
			
			(setq NewVertices (LM:lwvertices (entget NewShape)))
			(vla-delete (vlax-ename->vla-object NewShape))
			;
			;(terpri)
			;(princ (length Vertices))
			;(terpri)
			;(princ (length NewVertices))
			;(terpri)
			;
			(if (/= (length NewVertices) (+ (length Vertices) (length LstPtAdd)))
				(setq chk -1)
				(setq chk 1)
			)
			
			
		)
	)
	(list chk NewVertices)
)
;
;
;
(defun WriteErrorDataTrigger(EnameShape EnameEntra EnameEsci FileOut FlagFile / Strm DataShape Shape)

	
		(setq Strm (open FileOut FlagFile))
		(setq DataShape (GetDataShape EnameShape))
		(if DataShape
			(progn
				(if (= (nth 0 DataShape) "CE")
					(setq Shape "ESTERNO")
					(setq Shape "INTERNO")
				)
				(princ  (strcat "| Id contorno | "    (nth 1 DataShape) 
								" | Marca | "         (nth 3 DataShape) 
								" | Tipo contorno | " Shape
								" | Handle | "        (cdr (assoc 5 (entget EnameShape)))
						) Strm
				)
						
				(if (= EnameEntra nil)
					(princ " | Attacco ingresso | ASSENTE "  Strm)
					(cond
						((= EnameEntra -1)
							(princ " | Attacco ingresso | ERRORE   " Strm)
						)
						((= EnameEntra -2)
							(princ " | Attacco ingresso | dovrebbe esserci" Strm)
						)
						(t
							(princ " | Attacco ingresso | presente " Strm)
						)
					)
				)
				
				(if (= EnameEsci  nil)
					(princ " | Attacco uscita | ASSENTE"  Strm)
					(cond
						((= EnameEsci -1)
							(princ " | Attacco uscita | ERRORE   " Strm)
						)
						((= EnameEsci -2)
							(princ " | Attacco uscita | dovrebbe esserci" Strm)
						)
						(t
							(princ " | Attacco uscita | presente" Strm)
						)
					)
				)
				
				
				(princ "\n" Strm)
			)
		)
		(close Strm)
)
;
;
;
(defun ViewSequenceCutWalkOnSheet (EnameSheet / DataSequence ChoiseShape DataSheet)
	
	(if EnameSheet
		(progn
			(setq ChoiseShape (GetChoiseShape))
			(setq DataSequence (GetSequenceGroupOnSheet EnameSheet))
			;(DataSequence "1" "123456" "78910")
			(setq DataSheet    (GetDataSheetByEname EnameSheet))
			;(DataSheet "IdSheet" "NameSheet" "Widthsheet" "HeightSheet" "ThickSheet" "SurfaceSheet" "WeightSheet")
			(if DataSequence
				(progn
					(WriteCutSequenceSheet 	EnameSheet											; EName Sheet 
											(cdr DataSequence) 									; LstGrpName
											(car DataSequence) 									; TypeSequence
											(strcat CutPathEasyCut$ (nth 1 DataSheet) ".cut") 	; FileOut
											ChoiseShape)										; TypeShapeSequence
											
					(alert "\ninizio sequenza taglio")
					;(VisibleEname EnameSheet)
					(CutSimulator (strcat CutPathEasyCut$ (nth 1 DataSheet) ".cut") $TypSymula EnameSheet)
				)
			)
		)
	)
)
;
;
;
(defun ViewSequenceCutWalkOnShape (EnameShape / DataSequence ChoiseShape DataSheet)
	
	(if EnameShape
		(progn
			(setq ChoiseShape (GetChoiseShape))
			(setq DataShape  (GetDataShape EnameShape))
			(WriteCutSequenceShape	EnameShape
									(strcat CutPathEasyCut$ (nth 1 DataShape) ".cut") 	; FileOut
									ChoiseShape)										; TypeShapeSequence
											
			(alert "\ninizio sequenza taglio")
			(CutSimulator (strcat CutPathEasyCut$ (nth 1 DataShape) ".cut") $TypSymula EnameShape)
		)
	)
)
;
;
;
(defun CutSimulator (FileName TypeSymula EnameSheet /   ArcGrdraw Linegrdraw SequenceTorch _grdraw MakeTorch *error* 
														LstShape LstTorch
														itm conta start end ps pc Radius pe AngleFin AngleIni 
														LastPoint LstCatEnt)

    ;
    ; procedura di verifica percorso taglio
    ;
    ; FileName      = nome del file coordinate neutre del contorno
    ;
    ; TypeSimulator = tipo di simulazione
    ;                 1 = battere enter ad ogni segmento
    ;                 2 = automatico per ogni segmento (dare il tempo di attesa)
    ;                 3 = battere enter ad ogni spostamento veloce (il contorno viene inteso come un'unica entita)
    ;                 4 = animazione
	;
	(defun ArcGrdraw (pc Radius AngleIni AngleFin / Nda Step ps pe DAngle Rtn)
		
		;(setq NdA  (fix (* (/ (abs (- AngleFin AngleIni)) PI) 180.0)))
		
		(setq DAngle (- AngleFin AngleIni))
		(if (< DAngle 0.0)
			(setq DAngle (+ DAngle (* 2 PI)))
		)
		
		(setq NdA  (fix (* (/ DAngle PI) 180.0)))
		
		(if (> NdA 15) (setq NdA  (fix (/ NdA 15))))
		
		(if (= NdA 0)
			(progn
				(setq ps (dca (nth 0 pc) (nth 1 pc) (+ (nth 0 pc) Radius) (nth 1 pc) AngleIni))
				(setq pe (dca (nth 0 pc) (nth 1 pc) (+ (nth 0 pc) Radius) (nth 1 pc) AngleFin))
				
				(if (= $TypSymula 4)
					(setq Rtn (append Rtn (list (Linegrdraw ps pe))))
					(_grdraw ps pe)
				)
			)
			(progn
				(setq Step (/ DAngle NdA))
				(setq ps (dca (nth 0 pc) (nth 1 pc) (+ (nth 0 pc) Radius) (nth 1 pc) AngleIni))
				(repeat NdA
					(setq pe (dca (nth 0 pc) (nth 1 pc) (+ (nth 0 pc) Radius) (nth 1 pc) (+ AngleIni Step)))
					
					(if (= $TypSymula 4)
						(setq Rtn (append Rtn (list (Linegrdraw ps pe))))
						(_grdraw ps pe)
					)
					
					(setq AngleIni (+ AngleIni Step))
					(setq ps pe)
				)
			)
		)
		Rtn
	)
	;
	(defun _grdraw (ps pe / EnameLine)
		(if (and ps pe)
			(progn
				(setq EnameLine (LM:MakeLine ps pe))
				(vla-put-Color (vlax-ename->vla-object EnameLine) $ColorSymula)
				(entmod  (append (entget EnameLine) 
						 (list (list -3 (list $RgpSymula '(1002 . "{") '(1002 . "}")))))
				)
				(entupd EnameLine)
				(redraw EnameLine 3)
			)
		)
	)
	
	;
	(defun Linegrdraw (ps pe)
		(if (and ps pe)
			(LM:MakeLine ps pe)
		)
	)
	;
	(defun SequenceTorch (LstEname LstTorch Sleep Step ColorSymula / SortSequence)
		;
		(defun SortSequence (LstEname / Pos Chk Rtn)
			(if LstEname
				(progn
					(setq Rtn (append Rtn (list (vlax-curve-getstartpoint (car LstEname)) 
											    (vlax-curve-getendpoint   (car LstEname)))))
					(setq LstEname (vl-remove (car LstEname) LstEname))
					(setq Pos 0)
					
					(while (and LstEname (<= Pos (- (length LstEname) 1)))
					
						(setq Chk nil)
						(cond
							((equal (vlax-curve-getstartpoint (nth Pos LstEname)) (last Rtn) 0.01)
								(setq Rtn (append Rtn (list (vlax-curve-getendpoint (nth Pos LstEname))))) 
								(setq Chk T)
							)
							((equal (vlax-curve-getendpoint (nth Pos LstEname)) (last Rtn) 0.01)
								(setq Rtn (append Rtn (list (vlax-curve-getstartpoint (nth Pos LstEname)))))
								(setq Chk T)
							)
						)
						(if Chk						
							(progn
								(setq LstEname (vl-remove (nth Pos LstEname) LstEname))
								(setq Pos 0)
							)
							(setq Pos (1+ Pos))
						)
					)
				)
			)
			Rtn
		)
		;
		; Main
		;
		(if (setq EnameLwPoly (LM:MakeLWPoly (SortSequence LstEname) 0))
			(progn
				(DeleteEntity LstEname)
				(vla-put-Color (vlax-ename->vla-object EnameLwPoly) ColorSymula)
				(entmod  (append (entget EnameLwPoly) 
						 (list (list -3 (list $RgpSymula '(1002 . "{") '(1002 . "}")))))
				)
				(entupd EnameLwPoly)
				(redraw EnameLwPoly 3)
				(WalkPath EnameLwPoly LstTorch Sleep Step)
			)
		)
	)
	;
	(defun MakeTorch (EnameSheet  / EnameTra
									EnameTor
									ColorTra
									PtSheet
									PtFocus
									Wsheet
									Hsheet
									File)

		(defun 	AppendXdata (Ename)
			(entmod  (append (entget Ename) (list (list -3 (list $RgpSymula '(1002 . "{") '(1002 . "}"))))))
			(entupd Ename)
		)
		;
		; MAIN
		;
		(if EnameSheet
			(progn
			
				(setq ColorTra 	1)
				(setq PtSheet	(BoundingBoxLstEname (list EnameSheet)))
				(setq PtFocus	(car PtSheet))
				(setq Wsheet	(distance (car PtSheet) (cadr PtSheet)))
				(setq Hsheet	(distance (cadr PtSheet) (caddr PtSheet)))
				(setq File 		(strcat LibPathEasyCut$ "TorchEc.dwg"))
				(command "_.-insert" File "_none" PtFocus "" "" "")
				
				(setq EnameTor  (entlast))
				(setq EnameTra  (MakeRectangle (list 	(- (car (car PtSheet))  240)
														(- (cadr (car PtSheet))  90))
														50 (+ Hsheet 85)))
				(vla-put-Color 	(vlax-ename->vla-object EnameTra) ColorTra)
				
				(list	(list 	(AppendXdata (obj2blk "BarEc" PtFocus (LstEname->Ssget (list EnameTra)))))
						(list 	(AppendXdata EnameTor))
						PtFocus
				)
			)
		)
	)			
	;
	(defun *error* (msg / Ssel Pos)
	
		(princ "\n---> Esc CutSimulator <---")
		(setq Ssel (ssget "X" (list (list -3 (list $RgpSymula)))))
		(setq Pos 0)
		(repeat (sslength Ssel)
			(entdel (ssname Ssel Pos))
			(setq Pos (1+ Pos))
		)
		;(LM:deleteblocks (list "BarEc" "TorchEc"))
	)
	;
	; Main +++++++++
	;
	(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpSymula))))))
	(LM:deleteblocks (list "BarEc" "TorchEc"))		
	
	(setq LstShape (ReadNeutralData FileName))
    ;
	(if LstShape
		(progn
			
			(setq BrtColl nil)

			(if (= TypeSymula 4) (setq LstTorch (MakeTorch EnameSheet)))

			(foreach itm LstShape
				(setq conta 0)
				(repeat (- (length itm) 1)
				
					(setq start (nth conta itm)
						  end   (nth (1+ conta) itm)
					)
					;
					; collegamento al contorno precedente spostamento veloce
					;
					(if (and BrtColl (= conta 0))
						(progn
							(setq ps (list (atof (nth 0 BrtColl)) (atof (nth 1 BrtColl)))
								  pe (list (atof (nth 0 start))   (atof (nth 1 start)))
							)
							(if (= TypeSymula 4)
								(progn
									(setq LstCatEnt (append LstCatEnt (list (LineGrdraw ps pe))))
									(setq LastPoint (SequenceTorch LstCatEnt LstTorch (fix $TimeSymula) 50 5))
									(setq LstCatEnt nil)
								)
								(progn
									(_grdraw ps pe)
									(if (= TypeSymula 1) (getstring " <enter> "))
									(if (= TypeSymula 2) (repeat (* (fix $TimeSymula) 3) (redraw)))
								)
							)
						)
					)
			
					(if (= (length start) 5)
						(progn		; arco 
				
							(setq ps       (list (atof (nth 0 start)) (atof (nth 1 start)))
								  pc       (list (atof (nth 2 start)) (atof (nth 3 start)))
								  Radius   (atof (nth 4 start))
								  pe       (list (atof (nth 0 end)) (atof (nth 1 end)))
								  AngleIni (angle pc ps)
								  AngleFin (angle pc pe)
							)
							
							(if (> Radius 0)
								(setq LstCatEnt (append LstCatEnt (ArcGrdraw pc Radius AngleIni AngleFin)))
								(setq LstCatEnt (append LstCatEnt (ArcGrdraw pc (abs Radius) AngleFin AngleIni)))
							)
						)
						(progn		; retta 
							(setq ps (list (atof (nth 0 start)) (atof (nth 1 start)))
								  pe (list (atof (nth 0 end)) (atof (nth 1 end)))
							)
							(if (= TypeSymula 4)
								(setq LstCatEnt (append LstCatEnt (list (LineGrdraw ps pe))))
								(_grdraw ps pe)
							)
						)
					)
					(setq BrtColl end)
					(setq conta (1+ conta))
					
					(if (= TypeSymula 1) (getstring " <enter> "))
					(if (= TypeSymula 2) (repeat (* (fix $TimeSymula) 3) (redraw)))
				)
				(if (= TypeSymula 4)
					(progn
						(setq LastPoint (SequenceTorch LstCatEnt LstTorch (fix $TimeSymula) nil $ColorSymula))
						(setq LstCatEnt nil)
					)
					(progn
						(if (= TypeSymula 3) (getstring " <enter> "))
						;(if (= TypeSymula 4) (repeat (fix $TimeSymula) (redraw)))
					)
				)
			)
		)
	)
	
	(if (= TypeSymula 4)
		(progn
			(setq PtFocus (caddr LstTorch))
			(foreach itm (car   LstTorch) (Visibility02 itm nil))
			(foreach itm (cadr  LstTorch) (Visibility02 itm nil))
			(MoveDxfCode (car  LstTorch) PtFocus (list (car LastPoint) (cadr PtFocus) ))
			(MoveDxfCode (cadr LstTorch) PtFocus LastPoint)
			(foreach itm (car   LstTorch) (Visibility02 itm T))
			(foreach itm (cadr  LstTorch) (Visibility02 itm T))
		)
	)
	
	(getstring " <enter> ")
	(DeleteEntity (LM:ss->ent (ssget "X" (list (list -3 (list $RgpSymula))))))
	(LM:deleteblocks (list "BarEc" "TorchEc"))
	
)
;
;
;
(defun ReadNeutralData (FileIn / Stream riga LstShape LstSubShape riga_split)
	
		(if FileIn
			(progn
				(setq Stream (open FileIn "r")) 
	
				(if (not Stream)
					(progn
						(alert "ERRORE!! apertura file")
						(exit)
					)
					(setq riga (read-line Stream))
				)
				(if (not riga)
					(progn
						(alert "ERRORE!! file vuoto")
						(close Stream)
						(exit)
					)
				)
				;
				; lettura contorno
				;
				(setq LstShape nil)
				(setq LstSubShape nil)
				(while riga
					(if (or (= (substr riga 1 3) "01_") ; controno interno 
							(= (substr riga 1 3) "02_") ; controno esterno 
						)
						(progn
							(if LstSubShape
								(setq LstShape (append LstShape (list LstSubShape))
									  LstSubShape nil
								)
							)
							(setq riga (read-line Stream))
						)
					)
					(setq riga_split (splitxt riga " "))
					(setq LstSubShape  (append LstSubShape (list riga_split)))
					(setq riga (read-line Stream))
				)
				(setq LstShape (append LstShape (list LstSubShape)))
				(close Stream)                                 
			)
		)
		LstShape
)
;
; Tools Poliline
;
(defun vtx-add02 (EnameShape PtAdd / k*bulge ew norm nw Obj old_bulge pt-o pt-w sw vi vr Rtn)

	(defun k*bulge (b k / a)
		(setq a (atan b))
		(/ (sin (* k a)) (cos (* k a)))
	)
	;
	; Main ++++++++++++++++
	;	
	
	(if (and EnameShape PtAdd)
		(progn
			(setq Obj (vlax-ename->vla-object EnameShape))
			(setq PNear (vlax-curve-getclosestpointto Obj PtAdd))
	
			(if (MyEqualPoint PNear PtAdd 1e-5)
				(progn
					(setq norm (cdr (assoc 210 (entget EnameShape)))
						  pt-w PNear
						  pt-o (trans pt-w 0 norm)
						  pt-o (list (car pt-o) (cadr pt-o))
						  vr (vlax-curve-getparamatpoint Obj pt-w)
						  vi (fix vr)
						  vr (- vr vi)
						  old_bulge (vla-getbulge Obj vi)
						  Rtn T
					)
					(vla-GetWidth Obj vi 'sw 'ew)
					(vlax-invoke Obj 'AddVertex (1+ vi) pt-o)
			
					(if (Equal sw ew 0.0001)
						(vla-SetWidth Obj (1+ vi) sw ew)
						(progn
							(setq nw (* (+ sw ew) vr))
							(vla-SetWidth Obj vi sw nw)
							(vla-SetWidth Obj (1+ vi) nw ew)
						)
					)
			
					(if (not (zerop old_bulge))
						(progn
							(vla-setbulge Obj vi (k*bulge old_bulge vr))
							(vla-setbulge Obj (1+ vi) (k*bulge old_bulge (- 1 vr)))
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
(defun ExistVertexOnPolyLineList (Pt LstPtPolyline / itm Rtn)

	(if (and Pt LstPtPolyline)
		(progn
			(foreach itm LstPtPolyline
				(if (MyEqualPoint Pt (cdr (assoc 10 itm)) 1e-5)
					(setq Rtn T)
				)	
			)
		)
	)
	Rtn
)
;
; Sequenza
;
(defun SincronizzaShape (LstVertices PtStart PtEnd / conta itm Entra Esci LstTmp)
	
		(if (and LstVertices PtStart PtEnd)
			(progn
				
				; punto ingresso ++++++++++
				
				(setq conta 0)
				(foreach itm LstVertices
					;(princ (nth 0 itm)) (terpri)
					(if (MyEqualPoint PtStart (cdr (nth 0 itm)) 1e-3)
						(setq Entra Conta)
					)
					(setq Conta (1+ Conta))
				)
				
				; punto uscita ++++++++++++
				
				(setq conta 0)
				(foreach itm LstVertices
					(if (MyEqualPoint PtEnd (cdr (nth 0 itm)) 1e-3)
						(setq Esci Conta)
					)
					(setq Conta (1+ Conta))
				)
				
				(setq LstTmp nil)
				(if (> Esci Entra)
					(progn
						(setq Conta Entra)
						(setq LstTmp (list (nth Conta LstVertices)))
						(setq Conta (1+ Conta))
						(repeat (- Esci Entra)						
							(setq LstTmp (append  LstTmp (list (nth Conta LstVertices))))
							(setq Conta (1+ Conta))
						)
					)
					(progn
						(setq Conta Entra)
						(setq LstTmp (list (nth Conta LstVertices)))
						(setq Conta (1+ Conta))
						(repeat (- (- (length LstVertices) Entra) 1)
							(setq LstTmp (append  LstTmp (list (nth Conta LstVertices))))
							(setq Conta (1+ Conta))
						)
						(setq Conta 0)
						(repeat (1+ Esci)
							(setq LstTmp (append  LstTmp (list (nth Conta LstVertices))))
							(setq Conta (1+ Conta))
						)
					)
				)
			)
		)
		LstTmp
)
;
;
(defun WriteNeutralData (EnameShape LstVertices FileOut Intestazione FlagFile / NumDec Start Shape End SyncroShape 
																				Strm itm mmmin Timing minuti secondi Perimeter Rtn)


	(if (and EnameShape LstVertices FileOut Intestazione FlagFile)
		(progn
			(setq NumDec				 7)
			(setq Start (nth 0 LstVertices))
			(setq Shape (nth 1 LstVertices))
			(setq End   (nth 2 LstVertices))
			
			;(princ (strcat "\r [WriteNeutralData " (vl-princ-to-string EnameShape) "]")) 
			;(princ "\n----->") (princ Start)
			;(princ "\n----->") (princ Shape)
			;(princ "\n----->") (princ End) (terpri)
			
			
			(setq SyncroShape (SincronizzaShape Shape (nth 1 Start) (nth 0 End)))
		
			(setq Strm (open FileOut FlagFile))
			
			(cond
				((= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
					(setq Perimeter (vla-get-CIRCUMFERENCE (vlax-ename->vla-object EnameShape)))
				)
				((= (cdr (assoc 0 (entget EnameShape))) "ELLIPSE")
					(setq Perimeter (vlax-curve-getDistAtParam (vlax-ename->vla-object EnameShape) (* 2.0 pi)))
				)
				((= (cdr (assoc 0 (entget EnameShape))) "LWPOLYLINE")
					(setq Perimeter (vla-get-length (vlax-ename->vla-object EnameShape)))
				)
				
			)
			
			(setq Timing (/ Perimeter $SpeedCut)
				  minuti (fix Timing)
				  secondi (* (- Timing minuti) 60.0)
   				  Timing (strcat (rtos minuti 2 0) " minuti "  (rtos secondi 2 0) " secondi")
			)
		
			
			(princ (strcat Intestazione  
					" Area-> " 		(rtos (vla-get-area (vlax-ename->vla-object EnameShape)) 2 1)
					" Lunghezza-> " (rtos Perimeter 2 1)
					" Tempo-> "		Timing
					"\n") Strm)
			
			; ****** Ingresso
			(if (= (length Start) 4)
				(princ (strcat 
							(LM:rtos (nth 0 (nth 0 start)) 2 NumDec) " "
							(LM:rtos (nth 1 (nth 0 start)) 2 NumDec) " "
							(LM:rtos (nth 0 (nth 2 start)) 2 NumDec) " "
							(LM:rtos (nth 1 (nth 2 start)) 2 NumDec) " "
							(LM:rtos (nth 3 start) 2 NumDec) "\n") Strm)
							
				(princ (strcat 
							(LM:rtos (nth 0 (nth 0 Start)) 2 NumDec) " "
							(LM:rtos (nth 1 (nth 0 Start)) 2 NumDec) "\n") Strm)
			)
			;(setq riga (strcat (rtos (nth 0 (nth 1 start)) 2) " " (rtos (nth 1 (nth 1 start)) 2) "\n") Strm)

			; ****** Controno
			(setq conta 0)
			(repeat (- (length SyncroShape) 1)
			
				(if (= (cdr (assoc 42 (nth conta SyncroShape))) 0)
				
					(princ (strcat 
								(LM:rtos  (cadr (nth 0 (nth conta SyncroShape))) 2 NumDec) " " 
								(LM:rtos (caddr (nth 0 (nth conta SyncroShape))) 2 NumDec) "\n") Strm)
					
					(progn
						(setq Ce (LM:bulgecentre 
									(cdr (assoc 10 (nth conta SyncroShape)))
									(cdr (assoc 10 (nth (1+ conta) SyncroShape)))
									(cdr (assoc 42 (nth conta SyncroShape)))
								)
						)
						
						(if (> (cdr (assoc 42 (nth conta SyncroShape))) 0.0)
							(setq Rd  (distance (cdr (assoc 10 (nth conta SyncroShape))) Ce))
							(setq Rd  (- 0.0 (distance (cdr (assoc 10 (nth conta SyncroShape))) Ce)))
						)
						
						(princ (strcat 
									(LM:rtos (cadr  (nth 0 (nth conta SyncroShape))) 2 NumDec) " "
									(LM:rtos (caddr (nth 0 (nth conta SyncroShape))) 2 NumDec) " "
									(LM:rtos (nth 0 Ce) 2 NumDec) " "
									(LM:rtos (nth 1 Ce) 2 NumDec) " " 
									(LM:rtos Rd 2 NumDec) "\n") Strm)
					)
				)	
				(setq conta (1+ conta))
			)
			; ****** Uscita
			(if (= (length End) 4)
				(progn
					(princ (strcat 
								(LM:rtos (nth 0 (nth 0 End)) 2 NumDec) " "
								(LM:rtos (nth 1 (nth 0 End)) 2 NumDec) " "
								(LM:rtos (nth 0 (nth 2 End)) 2 NumDec) " "
								(LM:rtos (nth 1 (nth 2 End)) 2 NumDec) " "
								(LM:rtos (nth 3 End) 2 NumDec) "\n") Strm)
								
					(princ (strcat
								(LM:rtos (nth 0 (nth 1 End)) 2 NumDec) " "
								(LM:rtos (nth 1 (nth 1 End)) 2 NumDec) "\n") Strm)
				)
				(progn
					(princ (strcat
								(LM:rtos (nth 0 (nth 0 End)) 2 NumDec) " "
								(LM:rtos (nth 1 (nth 0 End)) 2 NumDec) "\n") Strm)
					(princ (strcat
								(LM:rtos (nth 0 (nth 1 End)) 2 NumDec) " "
								(LM:rtos (nth 1 (nth 1 End)) 2 NumDec) "\n") Strm)
				)
			)
			
			(close Strm)
			(setq Rtn T)
		)
	)
	Rtn
)
;
;
;
(defun WriteCutSequenceShape (EnameShape FileOut TypeSequence)

	(if (and EnameShape TypeSequence FileOut)
		(progn
			(vl-file-delete FileOut)
			(CutSequence02 EnameShape FileOut TypeSequence)
		)
	)
)
;
;
;
(defun WriteCutSequenceSheet (EnameSheet LstGrpName TypeSequence FileOut TypeShapeSequence)

	;
	;TypeSequence	1 libera
	;			2 ordinata per dimensioni di areee (dai contorni interni più grandi ai più piccoli / dai contorni esterni più grandi ai più piccoli)
	;			3
	
	(if (and EnameSheet LstGrpName TypeSequence FileOut)
		(progn
			(vl-file-delete FileOut)
			(cond
				((= TypeSequence "1")
					(CutSequence01 EnameSheet LstGrpName FileOut TypeShapeSequence) 
				)
				((= TypeSequence "2")
					(CutSequence01 EnameSheet LstGrpName FileOut TypeShapeSequence)
				)
				((= TypeSequence "3")
					(CutSequence01 EnameSheet LstGrpName FileOut TypeShapeSequence)
				)
				((= TypeSequence "4")
					(CutSequence01 EnameSheet LstGrpName FileOut TypeShapeSequence)
				)
				((= TypeSequence "5")
					(CutSequence01 EnameSheet LstGrpName FileOut TypeShapeSequence)
				)
				((= TypeSequence "6")
					(CutSequence01 EnameSheet LstGrpName FileOut TypeShapeSequence)
				)
			)
		)
	)
)
;
;
;
(defun CutSequence01 (EnameSheet LstGrpName FileOut TypeShapeSequence / FlagFile Num Nel itm LstShapeExternal LstShapeInternal LstEname EnameShape
																		EnameTrigger EnameEntra EnameEsci NVertices) 


	(setq FlagFile    "w")
	(setq Num 1)
	(setq Nel (length LstGrpName))
	
	(StartProgressBar "Taglio:" (length LstGrpName))
	(princ (testo_a_sinistra "\n" 100))
	(foreach itm LstGrpName

		(UpDateProgressBar)
		
		(princ "\rCutSequence01") (princ (strcat "[" (LM:rtos Num 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)
		(setq Num (1+ Num))
		
		(setq LstShapeExternal nil
			  LstShapeInternal nil
		)
		
		(setq LstEname (GetShapeByGroup itm))
		(if LstEname
			(progn
				(if (= (substr TypeShapeSequence 1 1) "1")
					(setq LstShapeExternal (append  LstShapeExternal (list (car LstEname))))
				)
				(if (= (substr TypeShapeSequence 2 1) "1")
					(setq LstShapeInternal (append  LstShapeInternal (cdr LstEname)))
				)
			)
		)
		; scrivo i contorni interni
		(foreach EnameShape LstShapeInternal
		
			(setq EnameTrigger (GetEnameTriggerByEnameShape EnameShape))
			(setq EnameEntra (nth 0 EnameTrigger))
			(setq EnameEsci  (nth 1 EnameTrigger))

			(setq NVertices (Contorno+Attacchi EnameShape EnameEntra EnameEsci))
			(WriteNeutralData EnameShape NVertices FileOut "01_Contorno interno" FlagFile)
			(if (= FlagFile "w")	(setq FlagFile "a"))
		)
		; scrivo i contorni esterni
		(foreach EnameShape LstShapeExternal
				
			(setq EnameTrigger (GetEnameTriggerByEnameShape EnameShape))
			(setq EnameEntra (nth 0 EnameTrigger))
			(setq EnameEsci  (nth 1 EnameTrigger))
			(setq NVertices (Contorno+Attacchi EnameShape EnameEntra EnameEsci))
			(WriteNeutralData EnameShape NVertices FileOut "02_Contorno esterno" FlagFile)
			(if (= FlagFile "w")(setq FlagFile "a"))
		)
	)
	(ClearProgressBar)
	(princ "\n")

)
;
;
;
(defun CutSequence02 (EnameShape FileOut TypeShapeSequence / FlagFile Num Nel LstGrpName itm LstShapeExternal LstShapeInternal LstEname EnameShape
															 EnameTrigger EnameEntra EnameEsci NVertices) 


	(setq FlagFile    "w")
	(setq Num 1)
	(setq LstGrpName (Gnames EnameShape))
	(setq Nel (length LstGrpName))
	
	(StartProgressBar "Taglio:" (length LstGrpName))
	(princ (testo_a_sinistra "\n" 100))
	(foreach itm LstGrpName

		(UpDateProgressBar)
		
		(princ "\rCutSequence01") (princ (strcat "[" (LM:rtos Num 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)
		(setq Num (1+ Num))
		
		(setq LstShapeExternal nil
			  LstShapeInternal nil
		)
		
		(setq LstEname (GetShapeByGroup itm))
		(if LstEname
			(progn
				(if (= (substr TypeShapeSequence 1 1) "1")
					(setq LstShapeExternal (append  LstShapeExternal (list (car LstEname))))
				)
				(if (= (substr TypeShapeSequence 2 1) "1")
					(setq LstShapeInternal (append  LstShapeInternal (cdr LstEname)))
				)
			)
		)
		; scrivo i contorni interni
		(foreach EnameShape LstShapeInternal
		
			(setq EnameTrigger (GetEnameTriggerByEnameShape EnameShape))
			(setq EnameEntra (nth 0 EnameTrigger))
			(setq EnameEsci  (nth 1 EnameTrigger))

			(setq NVertices (Contorno+Attacchi EnameShape EnameEntra EnameEsci))
			(WriteNeutralData EnameShape NVertices FileOut "01_Contorno interno" FlagFile)
			(if (= FlagFile "w")	(setq FlagFile "a"))
		)
		; scrivo i contorni esterni
		(foreach EnameShape LstShapeExternal
				
			(setq EnameTrigger (GetEnameTriggerByEnameShape EnameShape))
			(setq EnameEntra (nth 0 EnameTrigger))
			(setq EnameEsci  (nth 1 EnameTrigger))
			(setq NVertices (Contorno+Attacchi EnameShape EnameEntra EnameEsci))
			(WriteNeutralData EnameShape NVertices FileOut "02_Contorno esterno" FlagFile)
			(if (= FlagFile "w")(setq FlagFile "a"))
		)
	)
	(ClearProgressBar)
	(princ "\n")

)
;
; HTML
;
(defun CalculationQuantityShape (LstEnameShape / KeyControl LstCheck Record LstRtn)

	(foreach itm LstEnameShape
	
		(setq KeyControl (strcat (GetComShape itm) "|" (GetPhaseShape itm) "|" (GetNameShape itm)))
		
		(if (not (assoc KeyControl LstCheck))
			(setq LstCheck (append LstCheck (list (list KeyControl itm 1))))
			(progn
				(setq Record   (assoc KeyControl LstCheck))
				(setq LstCheck (subst (list (car  Record) 
											(cadr Record) 
											(+ (caddr Record) 1)) Record LstCheck))
			)
		)
	)
	(setq LstCheck (vl-sort LstCheck (function (lambda (e1 e2)  (< (car e1) (car e2))))))
	(foreach itm LstCheck
		(setq LstRtn (append LstRtn (list (cons (cadr itm) (caddr itm))))) 
	)
	LstRtn
)
;
;
;
(defun GetInfoCutSheet (EnameSheet / LstEnameShape TotSurface DataShape DataLstShape itm LgCut SpeedCut Timing Surface Rtn SheetSurface
									 TotLgCut TotLgExtCut TotLgIntCut TotLgTriggerCut)
	(if EnameSheet
		(if (CheckIfEasyCutSheetMember EnameSheet)
			(progn
				(setq SheetSurface (/ (vla-get-area (vlax-ename->vla-object EnameSheet)) 1000000.0))
				(setq LstEnameShape (GetEnameShapeByEnameSheet EnameSheet "CE"))
				
				(setq TotLgCut 			0.0)
				(setq TotLgExtCut		0.0)               
				(setq TotLgIntCut		0.0)   
				(setq TotLgTriggerCut	0.0)       

				(setq TotSurface 0.0)
				(foreach itm LstEnameShape					
					(setq LgCut (GetLengthShape itm))	;(PerimeterSelectShape PerimeterExternalShape PerimeterInternalShape PerimeterTrigger PerimeterTriggerSelect)
					
					(setq TotLgCut     		(+ TotLgCut 		(nth 1 LgCut) (nth 2 LgCut) (nth 3 LgCut)))
					(setq TotLgExtCut 		(+ TotLgExtCut		(nth 1 LgCut)))
					(setq TotLgIntCut		(+ TotLgIntCut		(nth 2 LgCut)))
					(setq TotLgTriggerCut	(+ TotLgTriggerCut	(nth 3 LgCut)))
		
					(setq TotSurface   (+ TotSurface (/ (vla-get-area (vlax-ename->vla-object itm)) 1000000.0)))
					(setq DataLstShape (append DataLstShape (list (strcat (GetComShape		itm) "\t" 
																		  (GetPhaseShape 	itm) "\t" 
																		  (GetNameShape 	itm) "\t" 
																		  (GetMatShape 		itm) "\t" 
																		  (GetTkShape 		itm)))))
					
				)
				
				(setq SpeedCut (GetSpeedCutByThickness (nth 4 (GetDataSheetByEname EnameSheet))))
				
				(if LstEnameShape
					(setq Timing (MinSec (/ TotLgCut SpeedCut))
									;minuti (fix Timing)
									;secondi (* (- Timing minuti) 60.0)
									;Timing (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")
						  Rtn (list DataLstShape 
									(LM:rtos TotLgCut        2 2)
									(LM:rtos TotLgExtCut     2 2)
									(LM:rtos TotLgIntCut     2 2)
									(LM:rtos TotLgTriggerCut 2 2)
									(LM:rtos SpeedCut        2 1)
									Timing 
									(LM:rtos TotSurface      2 2) 
									(LM:rtos SheetSurface    2 2))
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
(defun GetInfoCutSheetFound (LstFoundSearch / Sheet SheetSurface SpeedCut TotLgCut TotLgExtCut TotLgIntCut TotLgTriggerCut TotSurface Mark EnameShape
												Qta LgCut TotLgCut TotLgExtCut TotLgIntCut TotLgTriggerCut TotSurface DataLstShape Timing Rtn)

	;( (EnameSheet ("Com|Phase|Name" EnameShape EnameShape) 
	;		   	   ("Com|Phase|Name" EnameShape EnameShape) ....) 
	;  (EnameSheet ("Com|Phase|Name" EnameShape EnameShape))
	;)

	(foreach Sheet LstFoundSearch
		(setq EnameSheet 		(car Sheet))
		(setq SheetSurface 		(/ (vla-get-area (vlax-ename->vla-object EnameSheet)) 1000000.0))
		(setq SpeedCut 			(GetSpeedCutByThickness (GetTkSheet EnameSheet)))
	
		(setq TotLgCut 			0.0)
		(setq TotLgExtCut		0.0)               
		(setq TotLgIntCut		0.0)   
		(setq TotLgTriggerCut	0.0)       
		(setq TotSurface 		0.0)
		(setq DataLstShape nil)
		
		(foreach Mark (cdr Sheet)
			(setq EnameShape 		(cadr Mark))
			(setq Qta 				(- (length Mark) 1))
			(setq LgCut 			(GetLengthShape EnameShape))	;(PerimeterSelectShape PerimeterExternalShape PerimeterInternalShape PerimeterTrigger PerimeterTriggerSelect)
			(setq TotLgCut     		(+ TotLgCut 		(* (+ (nth 1 LgCut) (nth 2 LgCut) (nth 3 LgCut))  Qta)))
			(setq TotLgExtCut 		(+ TotLgExtCut		(* (nth 1 LgCut) Qta)))
			(setq TotLgIntCut		(+ TotLgIntCut		(* (nth 2 LgCut) Qta)))
			(setq TotLgTriggerCut	(+ TotLgTriggerCut	(* (nth 3 LgCut) Qta)))
			(setq TotSurface   		(+ TotSurface       (* (/ (vla-get-area (vlax-ename->vla-object EnameShape)) 1000000.0) Qta)))
			(setq DataLstShape 		(append DataLstShape (list (strcat 	(GetComShape	EnameShape) "\t" 
																		(GetPhaseShape 	EnameShape) "\t" 
																		(GetNameShape 	EnameShape) "\t" 
																		(GetMatShape 	EnameShape) "\t" 
																		(GetTkShape 	EnameShape)))))
		)
		
		(setq Timing (MinSec (/ TotLgCut SpeedCut)))
		(setq Rtn (append Rtn (list (list 	DataLstShape 
											(LM:rtos TotLgCut        2 2)
											(LM:rtos TotLgExtCut     2 2)
											(LM:rtos TotLgIntCut     2 2)
											(LM:rtos TotLgTriggerCut 2 2)
											(LM:rtos SpeedCut        2 1)
											Timing 
											(LM:rtos TotSurface      2 2) 
											(LM:rtos SheetSurface    2 2)))))
	

	)
	Rtn
)
;
;
;
(defun GetEnameShapeSequence (LstGrpName / itm LstExternalShape LstInternalShape Rtn)
	
	; la sequanza ordinata dei gruppi e catalogata nelle Ename della Sheet

	
	(if LstGrpName
		(progn
			(foreach itm LstGrpName
				(setq LstExternalShape (append LstExternalShape (list (car (GetShapeByGroup itm)))))
			)
			
			(foreach itm LstExternalShape ; sequenza contorni esterni
			
				(setq LstInternalShape (SortArea (GetEnameInternalShapeByDummyEnameSelect itm) 1))
				(if LstInternalShape
					(setq Rtn (append Rtn LstInternalShape))
				)
				(setq Rtn (append Rtn (list itm)))
			)
		)
	)
	
	
	Rtn
)
;
; ************************************   post processor  *************************************
;
(defun PostProccessShapeGui ( / x SelectFile EnameShape Order Phase Mark FileOut FileIn)
	(if (setq EnameShape (entsel "\nSelezionare il contorno "))
		(setq EnameShape (car EnameShape))
	)
	(PostProccessShape EnameShape)
)
;
;
;
(defun PostProccessShape (EnameShape / x SelectFile EnameShape Order Phase Mark FileOut FileIn)

	(defun SelectFile (Path FileName Ext Registry / FormatFileName
													FileImport FileToImportBars)
			
			(defun FormatFileName (FileName Ext)
				(if FileName
					(if (/= (vl-string-right-trim " \t" (vl-string-left-trim " \t" FileName)) "")
						(if (/= (strcase (last (splitxt (vl-string-right-trim " \t" (vl-string-left-trim " \t" FileName)) "."))) (strcase Ext))
							(strcat (vl-string-right-trim " \t" (vl-string-left-trim " \t" FileName)) "." Ext)
							FileName
						)
					)
				)
			)
			;
			; Main
			;
			(if (setq FileImport (OpenFileDialog  (list Path FileName (strcat "*." Ext) "FileDialog" nil T)))
				(progn
					(setq FileToImportBars (strcat (car FileImport) "\\" (FormatFileName (cadr FileImport) Ext)))
					(vl-registry-write EasyCutRegistryPath$ Registry (vl-filename-directory  FileToImportBars))
					FileToImportBars
				)
			)
	)	
	;
	; Main
	;
	;(if (setq EnameShape (entsel "\nSelezionare il contorno "))
	;	(setq EnameShape (car EnameShape))
	;)
	
	(if (CheckIfEasyCutShape EnameShape)
		(if (CheckSequenceTriggerOnShape EnameShape)
			(progn

				(setq Order (vl-remove-blanks (GetComShape		(GetEnameShapeByDummyEnameSelect EnameShape)))) 
				(setq Phase (vl-remove-blanks (GetPhaseShape 	(GetEnameShapeByDummyEnameSelect EnameShape)))) 
				(setq Mark  (vl-remove-blanks (GetNameShape 	(GetEnameShapeByDummyEnameSelect EnameShape))))
				(setq FileOut (strcat Order "_" Phase "_" Mark ".mpg"))
				
				(setq FileIn (OutNeutralShape (GetEnameShapeByDummyEnameSelect EnameShape)))
			
				(if FileIn 
					(if (setq x (ChoisePartProgramm))
						(if (setq FileOut (SelectFile (vl-registry-read EasyCutRegistryPath$ "PathOutput") FileOut "mpg" "PathOutput"))
							(progn

								(if (findfile FileOut)
									(if (= (LM:popup "avvertimento" "Il file esite \n vuoi sovrascriverlo ?" (+ 1 48 4096)) 2)
										(exit)
									)
								)
									
								(cond 
									((= x 1)
										(PostProEssiFro FileIn FileOut)
										(EasyCutViewer FileOut)
									)
									((= x 2)
										(PostProEssiEsab FileIn FileOut)
										(EasyCutViewer FileOut)
									)
									((= x 3)
										(PostProIsoKoike FileIn FileOut)
										(EasyCutViewer FileOut)
									)
									((= x 4)
										(PostProIsoSoitaab FileIn FileOut)
										(EasyCutViewer FileOut)
									)
								)
								(vl-file-delete FileIn)
							)
						)
					)
				)
			)
			(LM:popup "Avvertimento" "Controno senza attacchi [PostProccessShape]"  (+ 0 48 4096))
		)
		(LM:popup "Avvertimento" "Non e' un contorno [PostProccessShape]"  (+ 0 48 4096))
	)
)
;
;
(defun PostProccessSheet (EnameSheet / SelectFile
										x NameSheet FileOut FileIn)

	(defun SelectFile (Path FileName Ext Registry / FormatFileName
													FileImport FileToImportBars)
			
			(defun FormatFileName (FileName Ext)
				(if FileName
					(if (/= (vl-string-right-trim " \t" (vl-string-left-trim " \t" FileName)) "")
						(if (/= (strcase (last (splitxt (vl-string-right-trim " \t" (vl-string-left-trim " \t" FileName)) "."))) (strcase Ext))
							(strcat (vl-string-right-trim " \t" (vl-string-left-trim " \t" FileName)) "." Ext)
							FileName
						)
					)
				)
			)
			;
			; Main
			;
			(if (setq FileImport (OpenFileDialog  (list Path FileName (strcat "*." Ext) "FileDialog" nil T)))
				(progn
					(setq FileToImportBars (strcat (car FileImport) "\\" (FormatFileName (cadr FileImport) Ext)))
					(vl-registry-write EasyCutRegistryPath$ Registry (vl-filename-directory  FileToImportBars))
					FileToImportBars
				)
			)
	)	
	;
	;
	; Main
	;
	(if EnameSheet
		(progn
			(setq NameSheet (GetNameSheet EnameSheet))
			(setq FileOut 	(strcat NameSheet ".mpg"))
			(setq FileIn  	(OutNeutralSheet EnameSheet))
			
			(if FileIn
				(if (setq x (ChoisePartProgramm))
					(if (setq FileOut (SelectFile (vl-registry-read EasyCutRegistryPath$ "PathOutput") FileOut "mpg" "PathOutput"))
						(progn

							(if (findfile FileOut)
								(if (= (LM:popup "avvertimento" "Il file esite \n vuoi sovrascriverlo ?" (+ 1 48 4096)) 2)
									(exit)
								)
							)
						
							(cond 
								((= x 1)
									(PostProEssiFro FileIn FileOut)
									(EasyCutViewer FileOut)
								)
								((= x 2)
									(PostProEssiEsab FileIn FileOut)
									(EasyCutViewer FileOut)
								)
								((= x 3)
									(PostProIsoKoike FileIn FileOut)
									(EasyCutViewer FileOut)
								)
								((= x 4)
									(PostProIsoSoitaab FileIn FileOut)
									(EasyCutViewer FileOut)
								)
							)
							(vl-file-delete FileIn)
						)
					)
				)
			)
		)
	)
)
;
;
(defun OutNeutralShape (EnameShape / Rtn)

	; check trigger
	; check shape
	(setq Rtn T)
	(if EnameShape
		(if (CheckIfEasyCutShape EnameShape)
			(if (= (CheckTrigger EnameShape) 4)
				(setq Rtn (NeutralShape EnameShape))
				(progn
					(alert "Problema con gli attacchi")
					(setq Rtn nil)
				)
			)
			(progn
				(alert "Problema con il contorno")
				(setq Rtn nil)
			)
		)
		(setq Rtn nil)
	)
	Rtn
)
;
;
(defun OutNeutralSheet (EnameSheet / Rtn DataSequence)

	; check if exist list sheet

	(setq Rtn T)
	(if EnameSheet
		(if (CheckIfEasyCutSheet EnameSheet)
			(if (setq DataSequence (GetSequenceGroupOnSheet EnameSheet))
				(setq Rtn (NeutralSheet EnameSheet (cdr DataSequence)))
				(progn
					(alert "Problema non ci sono contorni da tagliare")
					(setq Rtn nil)
				)
			)
			(progn
				(alert "Non e' una lamiera")
				(setq Rtn nil)
			)
		)
		(setq Rtn nil)
	)
	Rtn
)
;
;
(defun NeutralShape (EnameShape / 	WriteNeutralShape
									LstInternalShape Num
									EnameTrigger EnameEntra EnameEsci MaxMin Vertices FileName Stream itm)

	(defun WriteNeutralShape (Vertices Stream / SplitVerticesArc SplitVerticesLwp StremOut
													)
		;
		;
		(defun SplitVerticesArc (LstVertices / Rtn Pmid)
			;		car						cadr				caddr			cadddr
			;((1920.97 745.293 0.0) (1926.34 752.96 0.0) (1928.97 745.404 0.0) -8.0)
			(if LstVertices
				(progn
					(cond
						((< (cadddr LstVertices) 0.0)
							(if (< (setq Rtn (- (angle (caddr LstVertices) (car LstVertices))
												(angle (caddr LstVertices) (cadr LstVertices)))) 0.0)
								(setq Rtn (+ (* 2.0 Pi) Rtn))
							)
							(if (> Rtn Pi)
								(setq Pmid (dca (car (caddr LstVertices)) (cadr (caddr LstVertices))
												(car (cadr LstVertices))  (cadr (cadr LstVertices)) (/ Rtn 2.0)))
							)
								
						)
						((> (cadddr LstVertices) 0.0)
							(if (< (setq Rtn (- (angle (caddr LstVertices) (cadr LstVertices))
												(angle (caddr LstVertices) (car LstVertices)))) 0.0)
								(setq Rtn (+ (* 2.0 Pi) Rtn))
							)
							(if (> Rtn Pi)
								(setq Pmid (dca (car (caddr LstVertices)) (cadr (caddr LstVertices))
												(car (car LstVertices))   (cadr (car LstVertices)) (/ Rtn 2.0)))
							)
						)
					)
					(if Pmid
						(list (list (car LstVertices) Pmid (caddr LstVertices)  (cadddr LstVertices))
							  (list Pmid (cadr LstVertices) (caddr LstVertices) (cadddr LstVertices))
						)
						(list LstVertices)
					)
				)
			)
		)
		;
		;
		(defun SplitVerticesLwP (LstVertices / ContaV VertX Bulge Radius Rtn)
			(if LstVertices
				(progn
																
					(setq ContaV 0)
					(repeat (- (length LstVertices) 1)
						(setq VertX  (list 	(cdr (car (nth (+ 0 ContaV) LstVertices)))
											(cdr (car (nth (+ 1 ContaV) LstVertices)))))
											
						(if (/= (setq Bulge (cdr (assoc 42 (nth (+ 0 ContaV) LstVertices)))) 0) ; -> arco
							(progn
								(setq Radius (LM:bulgeradius (cdr (car (nth (+ 0 ContaV) LstVertices)))
															 (cdr (car (nth (+ 1 ContaV) LstVertices))) Bulge))
								(setq VertX (append VertX (list (LM:bulgecentre (cdr (car (nth (+ 0 ContaV) LstVertices)))
																				(cdr (car (nth (+ 1 ContaV) LstVertices))) Bulge))))					
								(if (< Bulge 0)
									(setq VertX (append VertX (list (- 1.0 Radius))))
									(setq VertX (append VertX (list Radius)))
								)
							)
						)
						(setq ContaV (1+ ContaV))
						(setq Rtn (append Rtn (list VertX)))
					)
				)
			)
			Rtn
		)
		;
		;
		(defun StremOut (LstVertices TypeVertices Stream)
			(if (and LstVertices TypeVertices Stream)
				(progn
					(if (= TypeVertices 1)
						(write-line (strcat (LM:rtos (car (car LstVertices)) 2 2)  " " (LM:rtos (cadr (car LstVertices)) 2 2)) Stream)
					)
					(cond
						((or (= TypeVertices 1) (= TypeVertices 3)) ; entra / esci
							(cond 
								((= (length LstVertices) 4) ; fillet
									(foreach itm (SplitVerticesArc LstVertices)
										(write-line (strcat (LM:rtos (car (cadr itm)) 2 2)  " " (LM:rtos (cadr (cadr itm)) 2 2) " "
															(LM:rtos (car (caddr itm)) 2 2) " " (LM:rtos (cadr (caddr itm)) 2 2) " "
															(LM:rtos (cadddr itm) 2 2)) Stream)
									)
								)
								((= (length LstVertices) 2) ; line
									(write-line (strcat (LM:rtos (car (cadr LstVertices)) 2 2)  " " 
														(LM:rtos (cadr (cadr LstVertices)) 2 2)) Stream)
								)
							)
						)
						((= TypeVertices 2) ; contorno
							(foreach itm (SplitVerticesLwP LstVertices)
								(cond 
									((= (length itm) 4) ; fillet
										(foreach itm1 (SplitVerticesArc itm)
											(write-line (strcat (LM:rtos (car (cadr itm1)) 2 2)  " " (LM:rtos (cadr (cadr itm1)) 2 2) " "
																(LM:rtos (car (caddr itm1)) 2 2) " " (LM:rtos (cadr (caddr itm1)) 2 2) " "
																(LM:rtos (cadddr itm1) 2 2)) Stream)
										)
									)
									((= (length itm) 2) ; line
										(write-line (strcat (LM:rtos (car (cadr itm)) 2 2)  " " (LM:rtos (cadr (cadr itm)) 2 2)) Stream)
									)
								)
							)
						)
					)
				)
			)
		)
		;
		;Main
		;
		(if Vertices
			(progn
				(setq VerticesEntra (car Vertices)) 
				;((1920.97 745.293 0.0) (1926.34 752.96 0.0) (1928.97 745.404 0.0) -8.0) 
				(setq VerticesShape (SincronizzaShape (cadr Vertices) 
													  (nth 1 (car Vertices)) 
													  (nth 0 (caddr Vertices))))
				;(	(	(10 1746.91 690.57)  (40 . 0.0) (41 . 0.0) (42 . 0.0)) 
				;	(	(10 1926.34 752.96)  (40 . 0.0) (41 . 0.0) (42 . 0.0)) 
				;	(	(10 2080.74 806.646) (40 . 0.0) (41 . 0.0) (42 . 0.0)) 
				;	(	(10 1808.73 1033.86) (40 . 0.0) (41 . 0.0) (42 . 0.0)) 
				;	(	(10 1405.67 974.586) (40 . 0.0) (41 . 0.0) (42 . 0.0))
				;)
				(setq VerticesEsci  (caddr Vertices))
				;((1926.34 752.96 0.0) (1935.31 750.28 0.0) (1928.97 745.404 0.0) -8.0)
				
				
				(StremOut VerticesEntra 1 Stream)
				(StremOut VerticesShape 2 Stream)
				;(StremOut VerticesEsci  3 Stream)

				
			)
		)
	)
	;
	;Main
	;
	(if EnameShape
		(progn
			(setq EnameTrigger 	(GetEnameTriggerByEnameShape EnameShape))
			(setq EnameEntra 	(nth 0 EnameTrigger))
			(setq EnameEsci  	(nth 1 EnameTrigger))
			(setq MaxMin 		(BoundingBoxLstEname (list EnameShape  EnameEntra EnameEsci)))
			
			(setq FileName 	(vl-filename-mktemp nil nil ".txt"))
			(setq Stream 	(open FileName "w"))
			(write-line (strcat (LM:rtos (car 	(nth 1 MaxMin)) 2 2) " "
								(LM:rtos (cadr 	(nth 1 MaxMin)) 2 2) " "
								(LM:rtos (car 	(nth 2 MaxMin)) 2 2) " "
								(LM:rtos (cadr 	(nth 2 MaxMin)) 2 2) " "
								(LM:rtos (car 	(nth 0 MaxMin)) 2 2) " "
								(LM:rtos (cadr 	(nth 0 MaxMin)) 2 2)) Stream)

			(setq LstInternalShape (GetEnameInternalShapeByDummyEnameSelect EnameShape))
			(StartProgressBar "Contorni interni:" (length LstInternalShape))
			(setq Num 1)
								
			(foreach itm LstInternalShape ; internal shape
					
				(setq EnameTrigger 	(GetEnameTriggerByEnameShape itm))
				(setq EnameEntra 	(nth 0 EnameTrigger))
				(setq EnameEsci  	(nth 1 EnameTrigger))
				(if (and EnameEntra EnameEsci)
					(progn
						(setq Vertices 	(Contorno+Attacchi itm EnameEntra EnameEsci))
						;
						(write-line (strcat "> "
								(vl-remove-blanks (GetComShape		itm)) " " 
								(vl-remove-blanks (GetPhaseShape 	itm)) " " 
								(vl-remove-blanks (GetNameShape 	itm)) " " 
								(vl-remove-blanks (GetMatShape 		itm)) " " 
								(vl-remove-blanks (GetTkShape 		itm)) " "
								(vl-remove-blanks (LM:Rtos (GetSpeedCut    itm) 2 0)) " "
								(vl-remove-blanks (LM:Rtos (GetTypeShape   itm) 2 0)) " " 	; tipo_cont 0  non è un contorno trattato 
																							;			1  è un controno esterno 
																							;			2  è un contorno interno
								(vl-remove-blanks (GetJouShape	itm)) " " 					; perc_cont 3 oraria 2 antioraria
								(vl-remove-blanks (GetCutShape	itm)) " "					; compensa  1 auto 0 no 2 dx 3 sx
								"0"															
						) Stream )
						(WriteNeutralShape Vertices Stream)
					)
				)
				(princ "\rNeutralShape") (princ (strcat "[" (LM:rtos Num 2 0)  "/"  (LM:rtos (length LstInternalShape) 2 0) "] ")) (princ itm)
				(setq Num (1+ Num))
				(UpDateProgressBar)
			)
	
			(setq EnameTrigger 	(GetEnameTriggerByEnameShape EnameShape))
			(setq EnameEntra 	(nth 0 EnameTrigger))
			(setq EnameEsci  	(nth 1 EnameTrigger))
			(if (and EnameEntra EnameEsci)
				(progn
					(setq Vertices 	(Contorno+Attacchi EnameShape EnameEntra EnameEsci))
					;
					(write-line (strcat "> "
							(vl-remove-blanks (GetComShape		EnameShape)) " " 
							(vl-remove-blanks (GetPhaseShape 	EnameShape)) " " 
							(vl-remove-blanks (GetNameShape 	EnameShape)) " " 
							(vl-remove-blanks (GetMatShape 		EnameShape)) " " 
							(vl-remove-blanks (GetTkShape 		EnameShape)) " "
							(vl-remove-blanks (LM:Rtos (GetSpeedCut    EnameShape) 2 0)) " "
							(vl-remove-blanks (LM:Rtos (GetTypeShape   EnameShape) 2 0)) " " 	; tipo_cont 0  non è un contorno trattato 
																								;			1  è un controno esterno 
																								;			2  è un contorno interno
							(vl-remove-blanks (GetJouShape	EnameShape)) " " 					; perc_cont 3 oraria 2 antioraria
							(vl-remove-blanks (GetCutShape	EnameShape)) " "					; compensa  1 auto 0 no 2 dx 3 sx
							"0"															
							) Stream )
					(WriteNeutralShape Vertices Stream)
				)
			)
			(close Stream)
			;(EasyCutViewer FileName)
		)
	)
	FileName
)
;
;
(defun NeutralSheet (EnameSheet DataSequence / 	WriteNeutralShape
												LstInternalShape Num
												EnameSequence NameSheet MaxMin
												EnameTrigger EnameEntra EnameEsci Vertices FileName	Stream)

	(defun WriteNeutralShape (Vertices Stream / SplitVerticesArc SplitVerticesLwp StremOut
													)
		;
		;
		(defun SplitVerticesArc (LstVertices / Rtn Pmid)
			;		car						cadr				caddr			cadddr
			;((1920.97 745.293 0.0) (1926.34 752.96 0.0) (1928.97 745.404 0.0) -8.0)
			(if LstVertices
				(progn
					(cond
						((< (cadddr LstVertices) 0.0)
							(if (< (setq Rtn (- (angle (caddr LstVertices) (car LstVertices))
												(angle (caddr LstVertices) (cadr LstVertices)))) 0.0)
								(setq Rtn (+ (* 2.0 Pi) Rtn))
							)
							(if (> Rtn Pi)
								(setq Pmid (dca (car (caddr LstVertices)) (cadr (caddr LstVertices))
												(car (cadr LstVertices))  (cadr (cadr LstVertices)) (/ Rtn 2.0)))
							)
								
						)
						((> (cadddr LstVertices) 0.0)
							(if (< (setq Rtn (- (angle (caddr LstVertices) (cadr LstVertices))
												(angle (caddr LstVertices) (car LstVertices)))) 0.0)
								(setq Rtn (+ (* 2.0 Pi) Rtn))
							)
							(if (> Rtn Pi)
								(setq Pmid (dca (car (caddr LstVertices)) (cadr (caddr LstVertices))
												(car (car LstVertices))   (cadr (car LstVertices)) (/ Rtn 2.0)))
							)
						)
					)
					(if Pmid
						(list (list (car LstVertices) Pmid (caddr LstVertices)  (cadddr LstVertices))
							  (list Pmid (cadr LstVertices) (caddr LstVertices) (cadddr LstVertices))
						)
						(list LstVertices)
					)
				)
			)
		)
		;
		;
		(defun SplitVerticesLwP (LstVertices / ContaV VertX Bulge Radius Rtn)
			(if LstVertices
				(progn
																
					(setq ContaV 0)
					(repeat (- (length LstVertices) 1)
						(setq VertX  (list 	(cdr (car (nth (+ 0 ContaV) LstVertices)))
											(cdr (car (nth (+ 1 ContaV) LstVertices)))))
											
						(if (/= (setq Bulge (cdr (assoc 42 (nth (+ 0 ContaV) LstVertices)))) 0) ; -> arco
							(progn
								(setq Radius (LM:bulgeradius (cdr (car (nth (+ 0 ContaV) LstVertices)))
															 (cdr (car (nth (+ 1 ContaV) LstVertices))) Bulge))
								(setq VertX (append VertX (list (LM:bulgecentre (cdr (car (nth (+ 0 ContaV) LstVertices)))
																				(cdr (car (nth (+ 1 ContaV) LstVertices))) Bulge))))					
								(if (< Bulge 0)
									(setq VertX (append VertX (list (- 1.0 Radius))))
									(setq VertX (append VertX (list Radius)))
								)
							)
						)
						(setq ContaV (1+ ContaV))
						(setq Rtn (append Rtn (list VertX)))
					)
				)
			)
			Rtn
		)
		;
		;
		(defun StremOut (LstVertices TypeVertices Stream)
			(if (and LstVertices TypeVertices Stream)
				(progn
					(if (= TypeVertices 1)
						(write-line (strcat (LM:rtos (car (car LstVertices)) 2 2)  " " (LM:rtos (cadr (car LstVertices)) 2 2)) Stream)
					)
					(cond
						((or (= TypeVertices 1) (= TypeVertices 3)) ; entra / esci
							(cond 
								((= (length LstVertices) 4) ; fillet
									(foreach itm (SplitVerticesArc LstVertices)
										(write-line (strcat (LM:rtos (car (cadr itm)) 2 2)  " " (LM:rtos (cadr (cadr itm)) 2 2) " "
															(LM:rtos (car (caddr itm)) 2 2) " " (LM:rtos (cadr (caddr itm)) 2 2) " "
															(LM:rtos (cadddr itm) 2 2)) Stream)
									)
								)
								((= (length LstVertices) 2) ; line
									(write-line (strcat (LM:rtos (car (cadr LstVertices)) 2 2)  " " 
														(LM:rtos (cadr (cadr LstVertices)) 2 2)) Stream)
								)
							)
						)
						((= TypeVertices 2) ; contorno
							(foreach itm (SplitVerticesLwP LstVertices)
								(cond 
									((= (length itm) 4) ; fillet
										(foreach itm1 (SplitVerticesArc itm)
											(write-line (strcat (LM:rtos (car (cadr itm1)) 2 2)  " " (LM:rtos (cadr (cadr itm1)) 2 2) " "
																(LM:rtos (car (caddr itm1)) 2 2) " " (LM:rtos (cadr (caddr itm1)) 2 2) " "
																(LM:rtos (cadddr itm1) 2 2)) Stream)
										)
									)
									((= (length itm) 2) ; line
										(write-line (strcat (LM:rtos (car (cadr itm)) 2 2)  " " (LM:rtos (cadr (cadr itm)) 2 2)) Stream)
									)
								)
							)
						)
					)
				)
			)
		)
		;
		;Main
		;
		(if Vertices
			(progn
				(setq VerticesEntra (car Vertices)) 
				;((1920.97 745.293 0.0) (1926.34 752.96 0.0) (1928.97 745.404 0.0) -8.0) 
				(setq VerticesShape (SincronizzaShape (cadr Vertices) 
													  (nth 1 (car Vertices)) 
													  (nth 0 (caddr Vertices))))
				;(	(	(10 1746.91 690.57)  (40 . 0.0) (41 . 0.0) (42 . 0.0)) 
				;	(	(10 1926.34 752.96)  (40 . 0.0) (41 . 0.0) (42 . 0.0)) 
				;	(	(10 2080.74 806.646) (40 . 0.0) (41 . 0.0) (42 . 0.0)) 
				;	(	(10 1808.73 1033.86) (40 . 0.0) (41 . 0.0) (42 . 0.0)) 
				;	(	(10 1405.67 974.586) (40 . 0.0) (41 . 0.0) (42 . 0.0))
				;)
				(setq VerticesEsci  (caddr Vertices))
				;((1926.34 752.96 0.0) (1935.31 750.28 0.0) (1928.97 745.404 0.0) -8.0)
				
				
				(StremOut VerticesEntra 1 Stream)
				(StremOut VerticesShape 2 Stream)
				;(StremOut VerticesEsci  3 Stream)

				
			)
		)
	)
	;
	;Main
	;
	(if (and EnameSheet DataSequence)
		(progn
			(setq EnameSequence (CutSequence02 EnameSheet DataSequence))
			(if (or (car EnameSequence) (cadr EnameSequence))
				(progn
					(setq NameSheet (vl-remove-blanks (GetNameSheet EnameSheet)))
					(setq MaxMin (BoundingBoxLstEname (list EnameSheet)))
					(setq FileName 	(vl-filename-mktemp nil nil ".txt"))
					(setq Stream 	(open FileName "w"))
					(write-line (strcat (LM:rtos (car 	(nth 1 MaxMin)) 2 2) " "
								(LM:rtos (cadr 	(nth 1 MaxMin)) 2 2) " "
								(LM:rtos (car 	(nth 2 MaxMin)) 2 2) " "
								(LM:rtos (cadr 	(nth 2 MaxMin)) 2 2) " "
								(LM:rtos (car 	(nth 0 MaxMin)) 2 2) " "
								(LM:rtos (cadr 	(nth 0 MaxMin)) 2 2)) Stream)
					

					(foreach EnameShape (cadr EnameSequence) ; external shape

						(setq LstInternalShape (GetEnameInternalShapeByDummyEnameSelect EnameShape))
						;(alert (LM:rtos (length LstInternalShape) 2 0))
						
						
						;(if (> (length LstInternalShape) 0)
						;	(progn
						;		(StartProgressBar "Contorni interni:" (length LstInternalShape))
						;		(setq Num 1)
						;	)
						;)
						
						(foreach itm LstInternalShape ; internal shape
							(setq EnameTrigger 	(GetEnameTriggerByEnameShape itm))
							(setq EnameEntra 	(nth 0 EnameTrigger))
							(setq EnameEsci  	(nth 1 EnameTrigger))
							(if (and EnameEntra EnameEsci)
								(progn
									(setq Vertices 	(Contorno+Attacchi itm EnameEntra EnameEsci))
									;
									(write-line (strcat "> "
											(vl-remove-blanks (GetComShape		itm)) " " 
											(vl-remove-blanks (GetPhaseShape 	itm)) " " 
											(vl-remove-blanks (GetNameShape 	itm)) " " 
											(vl-remove-blanks (GetMatShape 		itm)) " " 
											(vl-remove-blanks (GetTkShape 		itm)) " "
											(vl-remove-blanks (LM:Rtos (GetSpeedCut    itm) 2 0)) " "
											(vl-remove-blanks (LM:Rtos (GetTypeShape   itm) 2 0)) " " 	; tipo_cont 0  non è un contorno trattato 
																										;			1  è un controno esterno 
																										;			2  è un contorno interno
											(vl-remove-blanks (GetJouShape	itm)) " " 					; perc_cont 3 oraria 2 antioraria
											(vl-remove-blanks (GetCutShape	itm)) " "					; compensa  1 auto 0 no 2 dx 3 sx
											"0"															
									) Stream )
									(WriteNeutralShape Vertices Stream)
								)
							)
							
							;(princ "\rNeutralSheet") (princ (strcat "[" (LM:rtos Num 2 0)  "/"  (LM:rtos (length LstInternalShape) 2 0) "] ")) (princ itm)
							;(setq Num (1+ Num))
							;(UpDateProgressBar)
						)
						
						;(if (> (length LstInternalShape) 0)	(ClearProgressBar))
						
						(setq EnameTrigger 	(GetEnameTriggerByEnameShape EnameShape))
						(setq EnameEntra 	(nth 0 EnameTrigger))
						(setq EnameEsci  	(nth 1 EnameTrigger))
						(if (and EnameEntra EnameEsci)
							(progn
								(setq Vertices 	(Contorno+Attacchi EnameShape EnameEntra EnameEsci))
								;
								(write-line (strcat "> "
										(vl-remove-blanks (GetComShape		EnameShape)) " " 
										(vl-remove-blanks (GetPhaseShape 	EnameShape)) " " 
										(vl-remove-blanks (GetNameShape 	EnameShape)) " " 
										(vl-remove-blanks (GetMatShape 		EnameShape)) " " 
										(vl-remove-blanks (GetTkShape 		EnameShape)) " "
										(vl-remove-blanks (LM:Rtos (GetSpeedCut    EnameShape) 2 0)) " "
										(vl-remove-blanks (LM:Rtos (GetTypeShape   EnameShape) 2 0)) " " 	; tipo_cont 0  non è un contorno trattato 
																											;			1  è un controno esterno 
																											;			2  è un contorno interno
										(vl-remove-blanks (GetJouShape	EnameShape)) " " 					; perc_cont 3 oraria 2 antioraria
										(vl-remove-blanks (GetCutShape	EnameShape)) " "					; compensa  1 auto 0 no 2 dx 3 sx
										"0"															
										) Stream )
								(WriteNeutralShape Vertices Stream)
							)
						)
					)
					(close Stream)
					;(EasyCutViewer FileName)
				)
			)
		)
	)
	FileName
)
;
;
(defun CutSequence02 (EnameSheet LstGrpName / Num Nel itm LstShapeExternal LstShapeInternal LstEname) 


	(setq Num 1)
	(setq Nel (length LstGrpName))
	
	(StartProgressBar "Taglio:" (length LstGrpName))
	(princ (testo_a_sinistra "\n" 100))
	
	(foreach itm LstGrpName

		(UpDateProgressBar)
		
		(princ "\rCutSequence02") (princ (strcat "[" (LM:rtos Num 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)
		(setq Num (1+ Num))
		
		;(setq LstShapeExternal nil
		;	  LstShapeInternal nil
		;)
		
		(setq LstEname (GetShapeByGroup itm))
		
		(if LstEname
			(progn
				(setq LstShapeExternal (append  LstShapeExternal (list (car LstEname))))
				(setq LstShapeInternal (append  LstShapeInternal (cdr LstEname)))
			)
		)
		
	)
	(ClearProgressBar)
	(list LstShapeInternal LstShapeExternal)

)
;
;
;

