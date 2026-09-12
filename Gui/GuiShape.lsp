(defun TcEasyCut (EnamePicked / *error* SplitPicked
						        Ename TypUpdate Loop Picked LstPicked Rtn)
	
	(defun *error* (msg)
		(if (setq *wsh* (cond (*wsh*) ((vlax-create-object "WScript.Shell"))))
			(vl-catch-all-apply 'vlax-invoke (list *wsh* 'sendkeys "{ESC}"))
		)
	)
	;
	;
	;
	(defun SplitPicked (EnamePicked / Rtn)
		(if EnamePicked
			(progn
				(setq Rtn (GetTypeEnamePicked EnamePicked))
				(if Rtn
					(setq Rtn (list (car Rtn) (cadr Rtn)))
					(setq Rtn nil)
				)
			)
		)
		Rtn
	)
	;
	; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(if EnamePicked 
		(progn
			(setq LstPicked (SplitPicked EnamePicked))
			(if LstPicked
				(setq Ename     (car LstPicked)
					  TypUpdate (cadr LstPicked)
				)
			)
			(setq Picked nil)
		)
		(setq Picked T)
	)
	(setq Loop T)
	;
	; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(setq EnameDoubleClickGetInfo$ nil)
	
	
	(while Loop
	
		(if Picked
			(progn
				(setq LstPicked (GetTypeEnamePicked (car (entsel "\rSelezionare ....."))))
				(if LstPicked
					(setq Ename     (car  LstPicked)
						  TypUpdate (cadr LstPicked)
					)
				)
			)
		)
			
		(if LstPicked
			(setq Rtn (TecnoSwitchUpdate Ename TypUpdate))
			(setq Rtn nil)
		)
		
		(cond
			((= Rtn nil)
				(setq Loop nil)
			)
			((= (type Rtn) 'ENAME)
				(progn
					(setq Ename Rtn)
					(setq LstPicked (SplitPicked Ename))
					(setq TypUpdate (cadr LstPicked))
				)
				(setq Picked nil)
			)
			((= Rtn T)
				(setq Picked T)
			)
		)
	)
	
)
;
;
;
(defun GetTypeEnamePicked (EnamePicked / Rtn Ename TypPicked)
	
	(if EnamePicked
		(progn
			(setq Rtn (GetEnameEasyCutByDummyEname EnamePicked)) 
			(if Rtn
				(progn
					(setq TypPicked (car  Rtn))
					(setq Ename 	(cadr Rtn))
					(if (= TypPicked 0)
						(progn
							(setq Rtn (DummyChoise "Tecno contorno" (list "Definisci contorno" "Definisci lamiera") 40 nil))
							(if Rtn
								(cond
									((= (car Rtn) "1") 
										(setq TypPicked 1)
									)
									((= (cadr Rtn) "1") 
										(setq TypPicked 2)
									)
								)
							)	
						)
					)
					(setq Rtn (list Ename TypPicked))
				)
				(setq Rtn nil)
			)
		)
	)
	Rtn
)
;
;
;
(defun TecnoSwitchUpdate (Ename TypUpdate / Rtn)

	(cond 
		((= TypUpdate 1)
			(setq Rtn (UpDateShape Ename TypUpdate))
		)
		((= TypUpdate 2)
			(setq Rtn (UpDateSheet Ename TypUpdate))
		)
		((= TypUpdate 100)
			(setq Rtn (UpDateShape Ename TypUpdate))
		)
		((= TypUpdate 101)
			(setq Rtn (UpDateShapeByBlock Ename))
		)
		((= TypUpdate 200)
			(setq Rtn (UpDateSheet Ename TypUpdate))
		)
		((= TypUpdate 201)
			(setq Rtn (UpDateSheetByBlock Ename))
		)
		((= TypUpdate -1)
			(alert "selezione non significativa")
			(setq Rtn T)
		)
	)
	Rtn
)
;
; Gui Shape +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun GuiTecnoShape (EnameShape / GetInfoDcl LoadGuiInfoShape 
								   LstInfoShape xx loop Rtn)
	;
	; esempio di informazioni estese del contorno
	; (-3 ("PIATTO"	(1002 . "{") 
	;              	(1000 . ["CE"]["CI"] 				CE contorno esterno / CI contorno interno  -valore string-)
	;             	(1000 . ["123456789"]   			nome contorno -valore string-)
	;             	(1000 . ["0"]["2"]["3"]  			percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria  -valore stringa-)
	;             	(1000 . ["PIPPO"]  					nome piatto -valore stringa-)
	;             	(1000 . ["0"]["1"]["2"]["3"] 	 	compensazione taglio 0 nessuna 1 auto 2 dx 3 sx  -valore stringa-)
	;				(1000 . ["C2018032"]  	 	        nome commessa  -valore stringa-)
	;				(1000 . ["P100"]  	 	        	nome fase  -valore stringa-)
	;				(1000 . ["S355J0"]  	 	        nome qualita'  -valore stringa-)
	;				(1000 . ["10"]  	 	            spessore  -valore stringa-)
	;				(1000 . ["10/11/2018"]  	 	    ultima modifica  -valore stringa-)
	;				(1000 . ["100"]  	 	   			quanita  -valore stringa-)
	;             	(1002 . "}") 
	;     )
	; )
	;
	;
	(defun GetInfoDcl ( / 	info_1 info_2 info_3 info_4 info_5 info_6 info_7 
							info_8 info_9 info_10 info_11 info_12 info_13
							info_5_1 info_5_2 info_5_3 info_5_4
							info1 info2 info3 info4 info5 info6 info7
							info8 info9 info10 info11 info12 info13)
                        
		(setq info_1 	(get_tile "cont_est"))
		(setq info_2 	(get_tile "idshape"))
		
		(setq info_3 	(get_tile "perc_anti"))
		(setq info_4 	(get_tile "nameshape"))
	
		(setq info_5_1 	(get_tile "comp_auto"))
		(setq info_5_2 	(get_tile "comp_no"))
		(setq info_5_3 	(get_tile "comp_dx"))
		(setq info_5_4 	(get_tile "comp_sx"))

		(setq info_6   	(get_tile "lgshape"))
		(setq info_7	(list 	(get_tile "timecut") 
								(get_tile "timecut1")
								(get_tile "timecut2")
								(get_tile "timecut3")
								(get_tile "timecut4")
								(get_tile "timecut5")
						)
		)
								
		(setq info_8   	(vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "ordershape"))))
		(setq info_9   	(vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "phaseshape"))))
		(setq info_10  	(vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "matshape"))))
		(setq info_11  	(vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "tkshape"))))
		(setq info_12   (get_tile "lastmodshape"))
		(setq info_13   (get_tile "qtashape"))
		;
		;
		;
		(if (= info_1 "1")  (setq info1 "CE") (setq info1 "CI"))
		(setq info2 info_2)
		(if (= info_3 "1")  (setq info3 "2") (setq info3 "3"))
		(setq info4 info_4)
		(if (= info_5_1 "1") (setq info5 "1"))
		(if (= info_5_2 "1") (setq info5 "0"))
		(if (= info_5_3 "1") (setq info5 "2"))
		(if (= info_5_4 "1") (setq info5 "3"))
		(setq info6 info_6)
		(setq info7 info_7)
		(setq info8 info_8)
		(setq info9 info_9)
		(setq info10 (strcase info_10))
		(setq info11 info_11)
		(setq info12 info_12)
		(setq info13 info_13)

		(list 	info1	;	0  TypShape
				info2	;	1  IdShape
				info3	;	2  JouShape
				info4	;	3  NameShape
				info5	;	4  CutComp
				info6	;	5  LenghtCut
				info7	;	6  (Sltime ExTime InTime TgTime TotTime)
				info8	;	7  ComShape
				info9	;	8  PhaseShape
				info10	;	9  MatShape
				info11	;	10 TkShape
				info12	;	11 DateShape
				info13)	;	12 Quantita
	)
	;
	;
	;
	(defun LoadGuiInfoShape (EnameShape / 	TypShape JouShape CutShape IdShape TimeCut DateShape OrdShape PhaseShape NameShape
											MatShape TkShape QtaShape LgShape AreaShape WeightShape SpeedCutShape DimShape)

		;(SlTime ExTime InTime TgTime TgSTime TotTime)
		;(PerimeterSelectShape PerimeterExternalShape PerimeterInternalShape PerimeterTrigger PerimeterTriggerSelect TotPerimeter)
		;(AreaSelect AreaExternalShape AreaInternalShape)
		;(SelectWeight GrossWeight NetWeight)
		
		(if EnameShape
			(progn
				
				(setq TypShape		(GetTypShape		EnameShape))	; String
				(setq JouShape		(GetJouShape		EnameShape))	; String
				(setq CutShape		(GetCutShape		EnameShape))	; String
				(setq IdShape		(GetIdShape			EnameShape))	; String
				(setq TimeCut		(GetTimingShape		EnameShape))	; String
				(setq DateShape		(GetDateShape		EnameShape))	; String
				(setq OrdShape		(GetComShape		EnameShape))	; String
				(setq PhaseShape	(GetPhaseShape		EnameShape))	; String
				(setq NameShape		(GetNameShape		EnameShape))	; String
				(setq MatShape		(GetMatShape		EnameShape))	; String
				(setq TkShape		(GetTkShape			EnameShape))	; String
				(setq QtaShape		(GetQtaShape		EnameShape))	; String
				(setq LgShape		(GetLengthShape 	EnameShape))	; Real
				(setq AreaShape		(GetAreaShape  		EnameShape))	; Real
				(setq WeightShape	(GetWeightShape		EnameShape))	; Real
				(setq SpeedCutShape	(GetSpeedCut		EnameShape))	; Real
				(setq DimShape		(GetDimensionShape	EnameShape)) 	; Real
				
				(if (= TypShape "CE") (set_tile "cont_est" "1")  (set_tile "cont_int" "1"))
				(if (= JouShape "2")  (set_tile "perc_anti" "1") (set_tile "perc_ora" "1"))
			
				(set_tile "idshape"        	IdShape)
				(set_tile "lgshape"        	(LM:rtos (nth 0 LgShape) 2 1))
				(set_tile "lgshape1"       	(LM:rtos (nth 1 LgShape) 2 1))
				(set_tile "lgshape2"       	(LM:rtos (nth 2 LgShape) 2 1))
				(set_tile "lgshape3"       	(LM:rtos (nth 3 LgShape) 2 1))
				(set_tile "lgshape4"       	(LM:rtos (nth 4 LgShape) 2 1))
				(set_tile "lgshape5"       	(LM:rtos (nth 5 LgShape) 2 1))
				(set_tile "timecut"        	(nth 0 TimeCut))
				(set_tile "timecut1"       	(nth 1 TimeCut))
				(set_tile "timecut2"       	(nth 2 TimeCut))
				(set_tile "timecut3"       	(nth 3 TimeCut))
				(set_tile "timecut4"       	(nth 4 TimeCut))
				(set_tile "timecut5"       	(nth 5 TimeCut))
				(set_tile "lastmodshape" 	DateShape)
				(set_tile "ordershape"     	OrdShape)
				(set_tile "phaseshape"     	PhaseShape)
				(set_tile "nameshape"      	NameShape)
				(set_tile "matshape"       	MatShape)
				(set_tile "tkshape"       	(LM:rtos (atof TkShape) 2 1))
				(set_tile "qtashape"       	QtaShape)
				(set_tile "lengthshape"		(LM:rtos (car (car DimShape))  2 1))
				(set_tile "widthshape"		(LM:rtos (cadr (car DimShape)) 2 1))
				(set_tile "speedcut"		(LM:rtos SpeedCutShape 2 1))
				(set_tile "weight"			(LM:rtos (car WeightShape)    2 1))
				(set_tile "grossweight"		(LM:rtos (cadr WeightShape)   2 1))
				(set_tile "scrapweight"		(LM:rtos (caddr WeightShape)  2 1))
				(set_tile "netweight"		(LM:rtos (- (cadr WeightShape) (caddr WeightShape)) 2 1))
				
				(cond
					((= CutShape "0") (set_tile "comp_no" "1"))
					((= CutShape "1") (set_tile "comp_auto" "1"))
					((= CutShape "2") (set_tile "comp_dx" "1"))
					((= CutShape "3") (set_tile "comp_sx" "1"))
				)
			)
		)
	)
	;
	;
	;
	(if (CheckIfEasyCutShape EnameShape) 
		(progn
			(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(new_dialog "GeoShape" xx "" (cond ( *GeoShape* ) ( '(-1 -1) )))
				(LoadGuiInfoShape EnameShape)
			
				(mode_tile "idshape"		1)
				(mode_tile "lgshape"		1)
				(mode_tile "lengthshape"	1)
				(mode_tile "widthshape"		1)
				(mode_tile "lgshape1"		1)
				(mode_tile "lgshape2"		1)
				(mode_tile "lgshape3"		1)
				(mode_tile "lgshape4"		1)
				(mode_tile "lgshape5"		1)
				(mode_tile "timecut"		1)
				(mode_tile "timecut1"		1)
				(mode_tile "timecut2"		1)
				(mode_tile "timecut3"		1)
				(mode_tile "timecut4"		1)
				(mode_tile "timecut5"		1)
				(mode_tile "lastmodshape" 	1)
				(mode_tile "typecont" 		1)
				(mode_tile "speedcut" 		1)
				(mode_tile "weight"			1)
				(mode_tile "grossweight"	1)
				(mode_tile "scrapweight"	1)
				(mode_tile "netweight"		1)

				
				(if (= (GetTypShape	EnameShape) "CI")
					(progn
						(mode_tile "ordershape"		1)
						(mode_tile "phaseshape"		1)
						(mode_tile "nameshape"		1)
						(mode_tile "matshape"		1)
						(mode_tile "tkshape"		1)
						(mode_tile "qtashape"		1)
					)
				)

				(action_tile "cancel"   "(setq Rtn nil          *geo_tec* (done_dialog)) (unload_dialog xx)")
				(action_tile "apply"    "(setq Rtn (GetInfoDcl) *geo_tec* (done_dialog)) (unload_dialog xx)")
				(action_tile "select"   "(setq Rtn T            *geo_tec* (done_dialog)) (unload_dialog xx)")

				(start_dialog)
        )
	)
	Rtn
)
;
;
;
(defun GuiTecnoShapeOnSheet (EnameShape / GetInfoDcl LoadGuiInfoShape
										  LstInfoShape xx loop Rtn)
	;
	; esempio di informazioni estese del contorno
	; (-3 ("PIATTO"	(1002 . "{") 
	;              	(1000 . ["CE"]["CI"] 				CE contorno esterno / CI contorno interno  -valore string-)
	;             	(1000 . ["123456789"]   			nome contorno -valore string-)
	;             	(1000 . ["0"]["2"]["3"]  			percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria  -valore stringa-)
	;             	(1000 . ["PIPPO"]  					nome piatto -valore stringa-)
	;             	(1000 . ["0"]["1"]["2"]["3"] 	 	compensazione taglio 0 nessuna 1 auto 2 dx 3 sx  -valore stringa-)
	;				(1000 . ["C2018032"]  	 	        nome commessa  -valore stringa-)
	;				(1000 . ["P100"]  	 	        	nome fase  -valore stringa-)
	;				(1000 . ["S355J0"]  	 	        nome qualita'  -valore stringa-)
	;				(1000 . ["10"]  	 	            spessore  -valore stringa-)
	;				(1000 . ["10/11/2018"]  	 	    ultima modifica  -valore stringa-)
	;				(1000 . ["100"]  	 	   			quanita  -valore stringa-)
	;             	(1002 . "}") 
	;     )
	; )
	;
	;
	(defun GetInfoDcl ( / 	info_1 info_2 info_3 info_4 info_5 info_6 info_7 
							info_8 info_9 info_10 info_11 info_12 info_13
							info_5_1 info_5_2 info_5_3 info_5_4
							info1 info2 info3 info4 info5 info6 info7
							info8 info9 info10 info11 info12 info13)
                        
		(setq info_1 	(get_tile "cont_est"))
		(setq info_2 	(get_tile "idshape"))
		
		(setq info_3 	(get_tile "perc_anti"))
		(setq info_4 	(get_tile "nameshape"))
	
		(setq info_5_1 	(get_tile "comp_auto"))
		(setq info_5_2 	(get_tile "comp_no"))
		(setq info_5_3 	(get_tile "comp_dx"))
		(setq info_5_4 	(get_tile "comp_sx"))

		(setq info_6   	(get_tile "lgshape"))
		(setq info_7	(list 	(get_tile "timecut") 
								(get_tile "timecut1")
								(get_tile "timecut2")
								(get_tile "timecut3")
								(get_tile "timecut4")
								(get_tile "timecut5")
						)
		)
								
		(setq info_8   	(vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "ordershape"))))
		(setq info_9   	(vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "phaseshape"))))
		(setq info_10  	(vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "matshape"))))
		(setq info_11  	(vl-string-right-trim  " " (vl-string-left-trim " " (get_tile "tkshape"))))
		(setq info_12   (get_tile "lastmodshape"))
		(setq info_13   (get_tile "qtashape"))
		;
		;
		;
		(if (= info_1 "1")  (setq info1 "CE") (setq info1 "CI"))
		(setq info2 info_2)
		(if (= info_3 "1")  (setq info3 "2") (setq info3 "3"))
		(setq info4 info_4)
		(if (= info_5_1 "1") (setq info5 "1"))
		(if (= info_5_2 "1") (setq info5 "0"))
		(if (= info_5_3 "1") (setq info5 "2"))
		(if (= info_5_4 "1") (setq info5 "3"))
		(setq info6 info_6)
		(setq info7 info_7)
		(setq info8 info_8)
		(setq info9 info_9)
		(setq info10 (strcase info_10))
		(setq info11 info_11)
		(setq info12 info_12)
		(setq info13 info_13)

		(list 	info1	;	0  TypShape
				info2	;	1  IdShape
				info3	;	2  JouShape
				info4	;	3  NameShape
				info5	;	4  CutComp
				info6	;	5  LenghtCut
				info7	;	6  (Sltime ExTime InTime TgTime TotTime)
				info8	;	7  ComShape
				info9	;	8  PhaseShape
				info10	;	9  MatShape
				info11	;	10 TkShape
				info12	;	11 DateShape
				info13)	;	12 Quantita
	)
	;
	;
	;
	(defun LoadGuiInfoShape (EnameShape / 	TypShape JouShape CutShape IdShape TimeCut DateShape OrdShape PhaseShape NameShape
											MatShape TkShape QtaShape LgShape AreaShape WeightShape SpeedCutShape DimShape)

		;(SlTime ExTime InTime TgTime TgSTime TotTime)
		;(PerimeterSelectShape PerimeterExternalShape PerimeterInternalShape PerimeterTrigger PerimeterTriggerSelect TotPerimeter)
		;(AreaSelect AreaExternalShape AreaInternalShape)
		;(SelectWeight GrossWeight NetWeight)
		
		(if EnameShape
			(progn
				
				(setq TypShape		(GetTypShape		EnameShape))	; String
				(setq JouShape		(GetJouShape		EnameShape))	; String
				(setq CutShape		(GetCutShape		EnameShape))	; String
				(setq IdShape		(GetIdShape			EnameShape))	; String
				(setq TimeCut		(GetTimingShape		EnameShape))	; String
				(setq DateShape		(GetDateShape		EnameShape))	; String
				(setq OrdShape		(GetComShape		EnameShape))	; String
				(setq PhaseShape	(GetPhaseShape		EnameShape))	; String
				(setq NameShape		(GetNameShape		EnameShape))	; String
				(setq MatShape		(GetMatShape		EnameShape))	; String
				(setq TkShape		(GetTkShape			EnameShape))	; String
				(setq QtaShape		(GetQtaShape		EnameShape))	; String
				(setq LgShape		(GetLengthShape 	EnameShape))	; Real
				(setq AreaShape		(GetAreaShape  		EnameShape))	; Real
				(setq WeightShape	(GetWeightShape		EnameShape))	; Real
				(setq SpeedCutShape	(GetSpeedCut		EnameShape))	; Real
				(setq DimShape		(GetDimensionShape	EnameShape)) 	; Real
				
				
				(if (= TypShape "CE") (set_tile "cont_est" "1")  (set_tile "cont_int" "1"))
				(if (= JouShape "2")  (set_tile "perc_anti" "1") (set_tile "perc_ora" "1"))
			
				(set_tile "idshape"        	IdShape)
				(set_tile "lgshape"        	(LM:rtos (nth 0 LgShape) 2 1))
				(set_tile "lgshape1"       	(LM:rtos (nth 1 LgShape) 2 1))
				(set_tile "lgshape2"       	(LM:rtos (nth 2 LgShape) 2 1))
				(set_tile "lgshape3"       	(LM:rtos (nth 3 LgShape) 2 1))
				(set_tile "lgshape4"       	(LM:rtos (nth 4 LgShape) 2 1))
				(set_tile "lgshape5"       	(LM:rtos (nth 5 LgShape) 2 1))
				(set_tile "timecut"        	(nth 0 TimeCut))
				(set_tile "timecut1"       	(nth 1 TimeCut))
				(set_tile "timecut2"       	(nth 2 TimeCut))
				(set_tile "timecut3"       	(nth 3 TimeCut))
				(set_tile "timecut4"       	(nth 4 TimeCut))
				(set_tile "timecut5"       	(nth 5 TimeCut))
				(set_tile "lastmodshape" 	DateShape)
				(set_tile "ordershape"     	OrdShape)
				(set_tile "phaseshape"     	PhaseShape)
				(set_tile "nameshape"      	NameShape)
				(set_tile "matshape"       	MatShape)
				(set_tile "tkshape"       	(LM:rtos (atof TkShape) 2 1))
				(set_tile "qtashape"       	QtaShape)
				(set_tile "lengthshape"		(LM:rtos (car (car DimShape))  2 1))
				(set_tile "widthshape"		(LM:rtos (cadr (car DimShape)) 2 1))
				(set_tile "speedcut"		(LM:rtos SpeedCutShape 2 1))
				(set_tile "weight"			(LM:rtos (car WeightShape)    2 1))
				(set_tile "grossweight"		(LM:rtos (cadr WeightShape)   2 1))
				(set_tile "scrapweight"		(LM:rtos (caddr WeightShape)  2 1))
				(set_tile "netweight"		(LM:rtos (- (cadr WeightShape) (caddr WeightShape)) 2 1))
				
				(cond
					((= CutShape "0") (set_tile "comp_no" "1"))
					((= CutShape "1") (set_tile "comp_auto" "1"))
					((= CutShape "2") (set_tile "comp_dx" "1"))
					((= CutShape "3") (set_tile "comp_sx" "1"))
				)
			)
		)
	)
	;
	;
	;
	(if (CheckIfEasyCutShape EnameShape) 
		(progn
			(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
			(new_dialog "GeoShapeOnSheet" xx "" (cond ( *GeoShapeOnSheet* ) ( '(-1 -1) )))
			(LoadGuiInfoShape EnameShape)
			
			(mode_tile "qtashape" 1)
			(mode_tile "quantita" 1)
			(mode_tile "typecont" 1)

			(action_tile "cancel"   "(setq Rtn nil          *GeoShapeOnSheet* (done_dialog)) (unload_dialog xx)")
			(action_tile "apply"    "(setq Rtn (GetInfoDcl) *GeoShapeOnSheet* (done_dialog)) (unload_dialog xx)")
			(action_tile "select"   "(setq Rtn T            *GeoShapeOnSheet* (done_dialog)) (unload_dialog xx)")
			(start_dialog)
		)
	)
	Rtn
)
;
;
;
(defun GuiFindShapeOnSheet (/ SwapModeTile UpdateBoxShape FindShape UpdateBoxSheet EmptyBox _Choise
							  xx $LstEname$ GoToOutput GoFindReport)

	(defun SwapModeTile (Target Status)
		(if (= Status "1") (mode_tile Target 0) (mode_tile Target 1))
	)
	;
	(defun UpdateBoxShape (/ Itm LstMark Mark Ename Num Prog PrgShape IdShape OrderShape PhaseShape NameShape QtaShape ThikShape DimShape LengthShape Widthshape MatShape Rtn)
	
		(if $LstEname$
			(progn
			
				(start_list "box_info2") (end_list)
				(setq Itm (get_tile "box_infol"))
				
				(if (/= Itm "")
					(setq LstMark (cdr (nth (atoi Itm) $LstEname$)))
				)
				;(princ "\n") (princ LstMark) (princ "\n")
				
				(setq Prog 0)
				(foreach Mark LstMark
					(setq Num 0)
					(foreach Ename (cdr Mark)
							(setq Prog (1+ Prog))
							(setq Num  (1+ Num))
							; "Itm\tId\tCommessa\tFase\tMarca\tQuantita\tSpessore\tLunghezza\tLarghezza\tQualita'"
							(setq PrgShape 	  (rtos Prog 2 0))
							(setq IdShape     (GetIdShape    Ename))
							(setq OrderShape  (GetComShape   Ename))
							(setq PhaseShape  (GetPhaseShape Ename))
							(setq NameShape   (GetNameShape  Ename))
							(setq QtaShape    "1")
							(setq ThikShape   (GetTkShape    Ename))
							(setq DimShape    (car (GetDimensionShape Ename)))
							(setq LengthShape (LM:rtos (car  DimShape) 2 1))
							(setq Widthshape  (LM:rtos (cadr DimShape) 2 1))
							(setq MatShape    (GetMatShape   Ename))
							(setq Rtn	  	  (append Rtn (list (strcat PrgShape	"\t" 
																		IdShape		"\t"
																		OrderShape	"\t"
																		PhaseShape	"\t"
																		NameShape	"\t"
																		QtaShape	"\t"
																		ThikShape	"\t"
																		LengthShape	"\t"
																		Widthshape	"\t"
																		MatShape))))
					)
					(setq Rtn (append Rtn (list (strcat "\t\t\t\t           Tot\t" (rtos Num 2 0) "\t\t\t\t"))))
					(setq Rtn (append Rtn (list (strcat "\t\t\t\t\t\t\t\t\t"))))
				)
				(start_list "box_info2")
					(mapcar 'add_list Rtn)
				(end_list)
			)
		)
	)
	;
	(defun FindShape (/ Go OrderShape PhaseShape MarkShape Sheet Mark Ename LstSheet)
		
		(ClearProgressBarDcl "$progbarsearch$")
		(ClearProgressBarDcl "$progbarshadow$")
		;(ClearProgressBarDcl "$progbarotput$" )
		
		(setq Go T)
		(setq $LstEname$ nil)
		(if (= (get_tile "ActiveFilterOrder") "1") (setq OrderShape (get_tile "OrderFilter")) (setq OrderShape "<>")) 
		(if (= (get_tile "ActiveFilterPhase") "1") (setq PhaseShape (get_tile "PhaseFilter")) (setq PhaseShape "<>")) 
		(if (= (get_tile "ActiveFilterMark")  "1") (setq MarkShape  (get_tile "MarkFilter"))  (setq MarkShape  "<>")) 
		
		(if (= OrderShape "") (progn (setq Go nil) (alert "Valore errato ricerca Commessa")))
		(if (= PhaseShape "") (progn (setq Go nil) (alert "Valore errato ricerca Fase")))
		(if (= MarkShape "")  (progn (setq Go nil) (alert "Valore errato ricerca Marca")))
		
		(if Go (setq $LstEname$ (FindShapeOnSheet (GetEnameSheet) OrderShape PhaseShape MarkShape)))
		; ------------------------------------------------------------------------------

		(StartProgressBarDcl "$progbarshadow$" (length $LstEname$))
		(StartProgressBar    "Shadow"          (length $LstEname$))
		
		(foreach Sheet $LstEname$
			(UpDateProgressBar)
			(UpDateProgressBarDcl "$progbarshadow$")
			
			;(BatchHatchDummyShape (car Sheet) nil nil "SOLID" 50)
			
			(foreach Mark (cdr Sheet)
				(foreach Ename (cdr Mark)
					(BatchHatchDummyShape Ename (GetEnameInternalShapeByDummyEnameSelect Ename) 1 "SOLID" 30)
				)
			)
		)
		(ClearProgressBar)
		; ------------------------------------------------------------------------------
		;(OutputSearch01 $LstEname$ "Found")
		;(OutputSearchSheet (foreach Sheet $LstEname$ (setq LstSheet (append LstSheet (list (car Sheet))))) "Found")
	)
	;
	(defun UpdateBoxSheet (/ Num itm PrgSheet IdSheet NameSheet Rtn)
		
		(if $LstEname$
			(progn
				(setq Num 1)
				(foreach itm $LstEname$
					; "Itm\tId\tNome\tLarghezza\tLunghezza\tSpessore";
					(setq PrgSheet    (rtos Num 2 0))
					(setq IdSheet     (GetIdSheet        (car itm)))
					(setq NameSheet   (GetNameSheet      (car itm)))
					(setq Rtn (append Rtn (list (strcat PrgSheet "\t" IdSheet "\t" NameSheet))))
					
					(setq Num (1+ Num))
				)
				(start_list "box_infol")
					(mapcar 'add_list Rtn)
				(end_list)
			)
		)
	)
	;
	(defun EmptyBox ()
		(start_list "box_infol") (end_list)
		(start_list "box_info2") (end_list)
	)
	;
	(defun _Choise ()
		(setq $OrderFilter$       (get_tile "OrderFilter"))
		(setq $PhaseFilter$       (get_tile "PhaseFilter"))
		(setq $MarkFilter$        (get_tile "MarkFilter"))
		(setq $ActiveFilterOrder$ (get_tile "ActiveFilterOrder"))
		(setq $ActiveFilterPhase$ (get_tile "ActiveFilterPhase"))
		(setq $ActiveFilterMark$  (get_tile "ActiveFilterMark"))
		(setq *SearchShapeOnSheet* (done_dialog))
		(unload_dialog xx)
	)
	;
	; Main
	;
	(setq $LstEname$ nil)
	(DeletedHatchEasyCut)
	
	(if (not $ActiveFilterOrder$) (setq $ActiveFilterOrder$ "0"))
	(if (not $ActiveFilterPhase$) (setq $ActiveFilterPhase$ "0"))
	(if (not $ActiveFilterMark$)  (setq $ActiveFilterMark$ 	"0"))
	(if (not $OrderFilter$)		  (setq $OrderFilter$ 		"<>"))			
    (if (not $PhaseFilter$)	 	  (setq $PhaseFilter$ 		"<>"))			
 	(if (not $MarkFilter$)		  (setq $MarkFilter$ 		"<>"))

	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "SearchShapeOnSheet" xx "" (cond ( *SearchShapeOnSheet* ) ( '(-1 -1) )))
	
	(set_tile  "ActiveFilterOrder"		    $ActiveFilterOrder$)			
	(set_tile  "ActiveFilterPhase"		    $ActiveFilterPhase$)			
	(set_tile  "ActiveFilterMark"			$ActiveFilterMark$)	
	
	(set_tile  "OrderFilter"				$OrderFilter$)			
	(set_tile  "PhaseFilter"				$PhaseFilter$)			
	(set_tile  "MarkFilter"					$MarkFilter$)
	
	(set_tile "box_infol_title" "0")
	(set_tile "box_info2_title" "0")
	
	(SwapModeTile "OrderFilter" (get_tile "ActiveFilterOrder"))
	(SwapModeTile "PhaseFilter" (get_tile "ActiveFilterPhase"))
	(SwapModeTile "MarkFilter"  (get_tile "ActiveFilterMark"))

	(action_tile "ActiveFilterOrder" 	"(SwapModeTile \"OrderFilter\" (get_tile \"ActiveFilterOrder\"))")
	(action_tile "ActiveFilterPhase"	"(SwapModeTile \"PhaseFilter\" (get_tile \"ActiveFilterPhase\"))")
	(action_tile "ActiveFilterMark"		"(SwapModeTile \"MarkFilter\"  (get_tile \"ActiveFilterMark\") )")
	
	(action_tile "box_infol"			"(UpdateBoxShape)")
	(action_tile "search"				"(EmptyBox) (FindShape) (UpdateBoxSheet)")
	(action_tile "output"               "(_Choise) (setq GoToOutput T)")
	(action_tile "report"               "(_Choise) (setq GoFindReport T)")
	(action_tile "cancel"   			"(_Choise)")
												
	(start_dialog)
	(princ)
	
	(if GoToOutput 
		(progn
			(setq NameLayout "FoundSheet")
			(if (not $LstEname$)
				(LM:popup "avvertimento" "ricerca vuota" (+ 0 64 4096))
				(OutputSearch01 $LstEname$ NameLayout)
			)
		)
	)
	(if GoFindReport
		(if (not $LstEname$)
			(LM:popup "avvertimento" "ricerca vuota" (+ 0 64 4096))
			(if (setq NameReport (ReportFound $LstEname$))
				(DefaultBrowser NameReport)
			)
		)
	)

)
;
;
;
(defun GuiFindShape (/ SwapModeTile UpdateBoxShape FindShape EmptyBox _Choise
					   xx $LstEname$ GoToOutput GoFindReport NameLayout Rtn)

	(defun SwapModeTile (Target Status)
		(if (= Status "1") (mode_tile Target 0) (mode_tile Target 1))
	)
	;
	(defun UpdateBoxShape (/ Mark Ename Num Prog ObjBlock
							 PrgShape IdShape OrderShape PhaseShape NameShape QtaShape ThikShape DimShape LengthShape Widthshape MatShape Rtn)
	
		(if $LstEname$
			(progn
				(setq Prog 0)
				(foreach Mark $LstEname$
					(setq Num 0)
					(foreach Ename (cdr Mark)
						(setq ObjBlock (vlax-ename->vla-object Ename))
						(setq Prog (1+ Prog))
						(setq Num  (1+ Num))
						; "Itm\tId\tCommessa\tFase\tMarca\tQuantita\tSpessore\tLunghezza\tLarghezza\tQualita'"
						(setq PrgShape 	  (rtos Prog 2 0))
						
						(setq IdShape     (LM:vl-getattributevalue ObjBlock "IDSHAPE")) 		; id shape
						(setq OrderShape  (LM:vl-getattributevalue ObjBlock "ORDERSHAPE")) 		; nome commessa
						(setq PhaseShape  (LM:vl-getattributevalue ObjBlock "PHASESHAPE"))		; nome fase
						(setq NameShape   (LM:vl-getattributevalue ObjBlock "MKSHAPE"))			; nome pezzo
						(setq QtaShape    (LM:vl-getattributevalue ObjBlock "QTASHAPE"))		; quantità
						(setq ThikShape   (LM:vl-getattributevalue ObjBlock "TKSHAPE"))			; spessore
						(setq LengthShape (LM:vl-getattributevalue ObjBlock "LENGTHSHAPE"))		; lunghezza
						(setq Widthshape  (LM:vl-getattributevalue ObjBlock "HEIGHTSHAPE"))		; larghezza
						(setq MatShape    (LM:vl-getattributevalue ObjBlock "MATSHAPE"))		; materiale
						
						(setq Rtn	  	  (append Rtn (list (strcat PrgShape	"\t" 
																	IdShape		"\t"
																	OrderShape	"\t"
																	PhaseShape	"\t"
																	NameShape	"\t"
																	QtaShape	"\t"
																	ThikShape	"\t"
																	LengthShape	"\t"
																	Widthshape	"\t"
																	MatShape))))
					)
					(setq Rtn (append Rtn (list (strcat "\t\t\t\t           Tot\t" (rtos Num 2 0) "\t\t\t\t"))))
					(setq Rtn (append Rtn (list (strcat "\t\t\t\t\t\t\t\t\t"))))
				)
				(start_list "box_info")
					(mapcar 'add_list Rtn)
				(end_list)
			)
			(LM:popup "avvertimento" "ricerca vuota" (+ 0 64 4096))
		)
	)
	;
	(defun FindShape (/ Go OrderShape PhaseShape MarkShape Mark EnameBlock IdShape EnameShape LstCheck)
	
		(start_list "box_info") (end_list)

		(ClearProgressBarDcl "$progbarsearch$")
		(ClearProgressBarDcl "$progbarshadow$")
		
		(setq Go T)
		(setq $LstEname$ nil)
		(if (= (get_tile "ActiveFilterOrder") "1") (setq OrderShape (get_tile "OrderFilter")) (setq OrderShape "<>")) 
		(if (= (get_tile "ActiveFilterPhase") "1") (setq PhaseShape (get_tile "PhaseFilter")) (setq PhaseShape "<>")) 
		(if (= (get_tile "ActiveFilterMark")  "1") (setq MarkShape  (get_tile "MarkFilter"))  (setq MarkShape  "<>")) 
		
		(if (= OrderShape "") (progn (setq Go nil) (alert "Valore errato ricerca Commessa")))
		(if (= PhaseShape "") (progn (setq Go nil) (alert "Valore errato ricerca Fase")))
		(if (= MarkShape "")  (progn (setq Go nil) (alert "Valore errato ricerca Marca")))
		
		(if Go (setq $LstEname$ (FindEnameBomShape OrderShape PhaseShape MarkShape)))
		; ------------------------------------------------------------------------------
		(StartProgressBarDcl "$progbarshadow$" (length $LstEname$))
		(StartProgressBar    "Shadow"          (length $LstEname$))
		(setq LstCheck (GetLstIdAndEnameShape))
		(foreach Mark $LstEname$
			(UpDateProgressBar)
			(UpDateProgressBarDcl "$progbarshadow$")
			(foreach EnameBlock (cdr Mark)
				(setq EnameShape (cadr (assoc (LM:vl-getattributevalue (vlax-ename->vla-object EnameBlock) "IDSHAPE") LstCheck)))
				(BatchHatchDummyShape EnameShape (GetEnameInternalShapeByDummyEnameSelect EnameShape) 1 "SOLID" 30)
			)
		)
		(ClearProgressBar)
		; ------------------------------------------------------------------------------
	)
	;
	(defun EmptyBox ()
		(start_list "box_info") (end_list)
	)
	;
	(defun _Choise ()
		(setq $OrderFilter$       (get_tile "OrderFilter"))
		(setq $PhaseFilter$       (get_tile "PhaseFilter"))
		(setq $MarkFilter$        (get_tile "MarkFilter"))
		(setq $ActiveFilterOrder$ (get_tile "ActiveFilterOrder"))
		(setq $ActiveFilterPhase$ (get_tile "ActiveFilterPhase"))
		(setq $ActiveFilterMark$  (get_tile "ActiveFilterMark"))
		(setq *SearchShape* 	  (done_dialog))
		(unload_dialog xx)
	)
	;
	; Main
	;
	(setq $LstEname$ nil)
	(DeletedHatchEasyCut)
		
	(if (not $ActiveFilterOrder$) (setq $ActiveFilterOrder$ "0"))
	(if (not $ActiveFilterPhase$) (setq $ActiveFilterPhase$ "0"))
	(if (not $ActiveFilterMark$)  (setq $ActiveFilterMark$ 	"0"))
	(if (not $OrderFilter$)		  (setq $OrderFilter$ 		"<>"))			
    (if (not $PhaseFilter$)	 	  (setq $PhaseFilter$ 		"<>"))			
 	(if (not $MarkFilter$)		  (setq $MarkFilter$ 		"<>"))

	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "SearchShape" xx "" (cond ( *SearchShape* ) ( '(-1 -1) )))
	
	(set_tile  "ActiveFilterOrder"		    $ActiveFilterOrder$)			
	(set_tile  "ActiveFilterPhase"		    $ActiveFilterPhase$)			
	(set_tile  "ActiveFilterMark"			$ActiveFilterMark$)	
	
	(set_tile  "OrderFilter"				$OrderFilter$)			
	(set_tile  "PhaseFilter"				$PhaseFilter$)			
	(set_tile  "MarkFilter"					$MarkFilter$)
	
	(set_tile "box_info_title" "0")
	
	(SwapModeTile "OrderFilter" (get_tile "ActiveFilterOrder"))
	(SwapModeTile "PhaseFilter" (get_tile "ActiveFilterPhase"))
	(SwapModeTile "MarkFilter"  (get_tile "ActiveFilterMark"))

	(action_tile "ActiveFilterOrder" 	"(SwapModeTile \"OrderFilter\" (get_tile \"ActiveFilterOrder\"))")
	(action_tile "ActiveFilterPhase"	"(SwapModeTile \"PhaseFilter\" (get_tile \"ActiveFilterPhase\"))")
	(action_tile "ActiveFilterMark"		"(SwapModeTile \"MarkFilter\"  (get_tile \"ActiveFilterMark\") )")
	
	(action_tile "search"				"(EmptyBox) (FindShape) (UpdateBoxShape)")
	(action_tile "output"               "(_Choise) (setq GoToOutput T)")
	(action_tile "report"               "(_Choise) (setq GoFindReport T)")
	(action_tile "cancel"   			"(_Choise) (setq Rtn nil)")
	
												
	(start_dialog)
	(princ)
	
	(if GoToOutput 
		(progn
			(setq NameLayout "FoundShape")
			(if (not $LstEname$)
				(LM:popup "avvertimento" "ricerca vuota" (+ 0 64 4096))
				(progn
					(OutputSearch03 $LstEname$ NameLayout)
					
				)
			)
		)
	)
	(if GoFindReport
		(if (not $LstEname$)
			(LM:popup "avvertimento" "ricerca vuota" (+ 0 64 4096))
			(if (setq NameReport (ReportFoundShape $LstEname$))
				(DefaultBrowser NameReport)
			)
		)
	)
)
;
; Update Shape ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun WhoIsShape (EnameShape / ChkZoom EnameBlock _Min _Max Rtn)

	(if EnameShape
		(cond 
			
			;((GetEnameBlockByFence (LstEname->Ssget (list EnameShape)) NameBlockShape$ 10000)
			;	(setq Rtn 1)
			;)
			
			((setq EnameBlock (GetEnameBlockShapeById (GetIdShape EnameShape)))
				(setq ChkZoom (VisibleEname EnameShape))
					(vla-getboundingbox (vlax-ename->vla-object EnameBlock) '_Min '_Max)
					(if (member EnameShape (LM:ss->ent (ssget "_C" 	(vlax-safearray->list _Min)
																	(vlax-safearray->list _Max) (list (list -3 (list $RgpShape))))))
						(setq Rtn 1)
						(setq Rtn 2)
					)	
				(ZoomPrevius ChkZoom)
			)
			;((GetEnameSheetByFence EnameShape 20000)
			((GetEnameSheetByEnameShape EnameShape)
				(setq Rtn 3)
			)
			(t
				(setq Rtn 4)
			)
		)
	)
	Rtn
)
;
;
;
(defun UpDateShape (EnameShape TypeUpdate / TyShape Rtn IdShape EnameCopy Rtn)

	(cond
		((and (= TypeUpdate 100) (Gnames EnameShape))
			(setq TyShape (GetTypShape EnameShape))
			(setq Site (WhoIsShape EnameShape))
			(cond
				((= TyShape "CI")
				
					(if (or (= Site 1) (= Site 2) (= Site 4)) 		;on Block or Free
						(if (not (CheckInternalShape EnameShape 0.01 T))
							(LM:popup "Avverimento" "Contorno interno modificato [UpDateShape]" (+ 0 64 4096))
						)
					)
				
					(if (= Site 3)
						(setq Rtn (GuiTecnoShape EnameShape))
						(setq Rtn (GuiTecnoShapeOnSheet EnameShape))
					)
				)
				((= TyShape "CE")
				
					(if (or (= Site 1) (= Site 2) (= Site 4)) 		;on Block or Free
						(progn
							(if (not (CheckExternalShape EnameShape 0.01 T))
								(LM:popup "Avvertimento" "Contorno modificato [UpDateShape]" (+ 0 64 4096))
							)
							(setq EnameShape 	(SetShape   EnameShape))
						)
					)
					
					(cond 
						((= Site 1)
							(setq Rtn (GuiTecnoShape EnameShape))
						)
						((= Site 2)
							(alert "Contorno fuori dal cartiglio")
							(setq Rtn (GuiTecnoShape EnameShape))
						)
						((= Site 3)
							(setq Rtn (GuiTecnoShapeOnSheet EnameShape))
						)
						((= Site 4)
							(InquadraShape 	EnameShape T)
							(setq Rtn (GuiTecnoShape EnameShape))
						)
					)
				)
			)					
			
		)
		((= TypeUpdate 1)
			(vla-StartUndoMark 	(vla-get-activedocument (vlax-get-acad-object)))
			(setq EnameShape 	(SetShape EnameShape))
			(setq Rtn       	(GuiTecnoShape EnameShape))
			(vla-EndUndoMark 	(vla-get-activedocument (vlax-get-acad-object)))	
			(if (= (type Rtn) 'LIST)
				(InquadraShape 	EnameShape nil)
				(command "_undo" "1")
			)
		)
	)
	(if (= (type Rtn) 'LIST)
		(progn
			(UpdateInfoShape EnameShape Rtn)
			(EnameShape->UpdateBlockInfoShape EnameShape)
			(setq Rtn EnameShape)
		)
	)
	Rtn
)
;
;
;
(defun UpDateShapeByBlock (EnameBlockShape / EnameShape Rtn)

		(setq EnameShape (GetEnameShapeByEnameBlockShape EnameBlockShape)) 
		(setq Rtn 		 (GuiTecnoShape EnameShape))
		(if (= (type Rtn) 'LIST)
			(progn
				(ZoomEname EnameBlockShape 100)
				(UpdateBlockShape EnameBlockShape Rtn)
				(UpdateBarCode EnameBlockShape)
				(ZoomPrevius01)
				(BlockInfoShape->UpdateEnameShape Rtn)
				(setq Rtn EnameBlockShape) 
			)
		)
		Rtn
)
;
;
;
(defun UpdateEntityType (LstEname / Pos itm Ename Rtn)
	
	(setq Rtn LstEname)
	(setq Pos 0)
	
	(foreach itm LstEname
		
		(if (= (cdr (assoc 0 (entget itm))) "ELLIPSE")
			(progn
				(setq Ename (Ellipse2LwPolyline itm T))
				(setq Rtn (subst Ename itm Rtn))
			)
		)
		(if (= (cdr (assoc 0 (entget itm))) "POLYLINE")
			(Polyline2LwPolyline itm)
		)

		(cond 
			((= Pos 0)
				(if (= (cdr (assoc 0 (entget itm))) "CIRCLE")
					(progn
						(setq Ename (Circle2LwPolyline itm T))
						(setq Rtn (subst Ename itm Rtn))
					)
				)
			)
			((> Pos 0)
				(if (= (cdr (assoc 0 (entget itm))) "LWPOLYLINE")
					(if (IsLwPolylineCircle itm)
						(progn
							(setq Ename (LwPolyline2Circle itm T))
							(setq Rtn (subst Ename itm Rtn))
						)
						
					)
				)
			)
		)
		(setq Pos (1+ Pos))
	)
	;(foreach itm Rtn
	;	(if (= (cdr (assoc 0 (entget itm))) "LWPOLYLINE")
	;		(PurgePolyline itm)
	;	)
	;)
	Rtn
)
;
;
;
(defun UpdateInfoShape (EnameShape LstInfoDcl / NewTypShape NewIdShape NewJouShape NewCutComp NewLgShape NewTymecut
												NewComShape NewPhaseShape NewMatShape NewTkShape NewLastUpdateShape NewQtaShape
												OldTypShape OldIdShape OldJouShape OldCutComp OldLgShape OldTymecut DataShape
												OldComShape OldPhaseShape OldMatShape OldTkShape OldLastUpdateShape OldQtaShape 
												LstInternalEname itm)
		

		;	0	"cont_est"
		;	1	"idshape"
		;	2	"percorrenza"
		;	3	"marca"
		;	4	"compensazione"
		;	5	"lgshape"
		;	6	"timecut"
		;	7	"commessa"
		;	8	"fase"
		;	9	"qualita"
		;	10	"spessore"
		;	11	"ultimamodifica"
		;	12	"quantita"
		
		(if (and EnameShape LstInfoDcl)
			(progn
					(setq NewTypShape  			(nth 0 LstInfoDcl)) 			; modificabile			record 1
					(setq NewIdShape   			(nth 1 LstInfoDcl))				; modificabile		    record 2
					(setq NewJouShape  			(nth 2 LstInfoDcl))				; modificabile			record 3
					(setq NewNameShape 			(nth 3 LstInfoDcl))				; modificabile			record 4	
					(setq NewCutComp   			(nth 4 LstInfoDcl))				; modificabile			record 5
					(setq NewLgShape   			(nth 5 LstInfoDcl))				; non modificabile		
					(setq NewTymecut   			(nth 0 (nth 6 LstInfoDcl)))		; non modificabile
					
					(setq NewComShape  			(nth 7 LstInfoDcl)) 			; modificabile			record 8
					(setq NewPhaseShape			(nth 8 LstInfoDcl)) 			; modificabile			record 9
					(setq NewMatShape  			(nth 9 LstInfoDcl)) 			; modificabile			record 10
					(setq NewTkShape  			(nth 10 LstInfoDcl)) 			; modificabile			record 11
					(setq NewLastUpdateShape  	(nth 11 LstInfoDcl)) 			; non modificabile		record 12
					(setq NewQtaShape  			(nth 12 LstInfoDcl)) 			; modificabile			record 13
					
					(setq DataShape (GetDataShape EnameShape))
					
					;		0		1		2		3			4		5				6				7		 8			9		10		11
					;	TypShape IdShape JouShape NameShape CutComp LenghtCut (list TimingE TimingI) ComShape PhaseShape MatShape TkShape DateShape

					(setq OldTypShape  			(nth 0 DataShape)) 
					(setq OldIdShape   			(nth 1 DataShape))
					(setq OldJouShape  			(nth 2 DataShape))
					(setq OldNameShape 			(nth 3 DataShape))
					(setq OldCutComp   			(nth 4 DataShape))
					(setq OldLgShape   			(nth 5 DataShape))
					(setq OldTymecut   			(nth 0 (nth 6 DataShape)))
					(setq OldComShape  			(nth 7 DataShape)) 
					(setq OldPhaseShape			(nth 8 DataShape))
					(setq OldMatShape  			(nth 9 DataShape))
					(setq OldTkShape  		 	(nth 10 DataShape))
					(setq OldLastUpdateShape 	(nth 11 DataShape))
					(setq OldQtaShape 			(nth 12 DataShape))

					
					; 0	TypShape   					*  ["CE"] ["CI"]		CE contorno esterno / CI contorno interno
					; 1	IdShape    					*  ["123456789"]		nome contorno -valore string-)
					; 2	JouShape   					*  ["0"] ["2"] ["3"]	percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria
					; 3	NameShape  					*  ["PIPPO"]			nome piatto
					; 4	CutComp    					*  ["0"]["1"]["2"]["3"]	compensazione taglio 0 nessuna / 1 auto 2 dx / 3 sx
					; 5	(rtos LenghtCut 2 2)		*  ["100.3"]  			lunghezza taglio
					; 6	(SlTime ExTime InTime TrTime TotTime)	*   tempo di taglio
					; 7	ComShape   					*  ["C2018032"]  	 	nome commessa
					; 8	PhaseShape 					*  ["P100"]  	 	    nome fase
					; 9	MatShape   					*  ["S355J0"] 	 	    nome qualita'
					;10	TkShape    					*  ["10"]  	 	        spessore
					;11	DateShape  					*  ["10/11/2018"]  	 	ultima modifica
					;12	QtaShape  					*  ["100"]  	 		quantita
			

					(ChangeRecordShape EnameShape 1 NewTypShape)
					(ChangeRecordShape EnameShape 3 NewJouShape)
					(ChangeRecordShape EnameShape 4 NewNameShape)
					(ChangeRecordShape EnameShape 5 NewCutComp)
					
					(ChangeRecordShape EnameShape 6  NewComShape)
					(ChangeRecordShape EnameShape 7  NewPhaseShape)
					(ChangeRecordShape EnameShape 8  NewMatShape)
					(ChangeRecordShape EnameShape 9  NewTkShape)
					(ChangeRecordShape EnameShape 11 NewQtaShape)
					
					
					(if (= NewTypShape "CE")
						(progn
							(setq LstInternalEname (GetEnameInternalShapeByDummyEnameSelect EnameShape))
							(foreach itm LstInternalEname
									
									(ChangeRecordShape itm 4 NewNameShape)	;4	NameShape
									(ChangeRecordShape itm 6 NewComShape)	;6	ComShape
									(ChangeRecordShape itm 7 NewPhaseShape)	;7	PhaseShape
									(ChangeRecordShape itm 8 NewMatShape)	;8	MatShape 
									(ChangeRecordShape itm 9 NewTkShape)	;9	TkShape
									(ChangeRecordShape itm 11 NewQtaShape)	;11	QtaShape
							)
						)
					)
						
				
			)
		)
)
;
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun IntegrityGeometricalShape (LstEname / itm Check Rtn)

	;(setq Check (CheckPoly EnameShape))
	; Rtn 	-1 	non è una polilinea
	;		 0	polylinea aperta
	;		 1	polylinea con vertici duplicati
	;		 2	polylinea anti oraria
	;		 3	polylinea oraria
	;		 4	polylinea 1° e ultimo vertice coincidente 
	;		 5	polylinea autointersecante 


	(foreach itm LstEname
		(if (= (cdr (assoc 0 (entget itm))) "LWPOLYLINE")
			(progn
				(setq Rtn T)
				(setq Check (CheckPoly itm))
				(if (and (/= (car Check) 2) (/= (car Check) 3))
					(progn
						(setq Rtn nil)
						(ZoomEname itm 30.0)
						(vla-highlight (vlax-ename->vla-object itm) :vlax-true)
						(cond
							((= (car Check) 0) (LM:popup "Errore [IntegrityGeometricalShape]" "Polilinea aperta"							(+ 0 16 4096)))
							((= (car Check) 1) (LM:popup "Errore [IntegrityGeometricalShape]" "Polylinea con vertici duplicati"				(+ 0 16 4096)))
							((= (car Check) 4) (LM:popup "Errore [IntegrityGeometricalShape]" "Polylinea 1° e ultimo vertice coincidente"	(+ 0 16 4096)))
							((= (car Check) 5) (LM:popup "Errore [IntegrityGeometricalShape]" "Polylinea autointersecante"					(+ 0 16 4096)))
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
(defun UpdateStatusShapeAndTrigger (NewListShapeAndTrigger OldListShapeAndTrigger / NewExternalShape OldExternalShape
																				    NewInternalShape OldInternalShape 
																				    NewTrigger OldTrigger 
																				    itm tr)


	(if (and NewListShapeAndTrigger OldListShapeAndTrigger)
		(progn
			(setq NewExternalShape (car (car NewListShapeAndTrigger)))
			(setq OldExternalShape (car (car OldListShapeAndTrigger)))
			(setq NewInternalShape (cdr (car NewListShapeAndTrigger)))
			(setq OldInternalShape (cdr (car OldListShapeAndTrigger)))
			(setq NewTrigger       (cadr NewListShapeAndTrigger))
			(setq OldTrigger       (cadr OldListShapeAndTrigger))
			
			(if (or (not (equal NewExternalShape OldExternalShape))
					(not (EqualValueOnList NewInternalShape OldInternalShape))
					(not (EqualValueOnList NewTrigger OldTrigger))
				)
				(SetShape NewExternalShape)
			)
			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			(foreach itm OldInternalShape
				(if itm
					(if (not (gnames itm)) (progn (DetatchGroupToEname itm) (vla-put-Color (vlax-ename->vla-object itm) 6)))
				)
			)
			(foreach itm NewInternalShape
				(if itm
					(if (not (gnames itm)) (progn (DetatchGroupToEname itm) (vla-put-Color (vlax-ename->vla-object itm) 6)))
				)
			)
			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			(foreach itm OldTrigger
				(if (not (gnames itm)) (progn	(DetatchGroupToEname itm)  (vla-put-Color (vlax-ename->vla-object itm) 6)))
			)
			(foreach itm NewTrigger
				(if (not (gnames itm)) (progn	(DetatchGroupToEname itm)  (vla-put-Color (vlax-ename->vla-object itm) 6)))
			)
		)
	)
)
;
;
;
(defun SetShape (EnameShape / LstEname IdShape Name Cut Order Phase Mat Tk Date Qta itm tr Rtn)

	(if EnameShape
		(progn
			(setq LstEname (GetEntityForShape EnameShape))
			(setq LstEname (UpdateEntityType LstEname))
			
			
			
			(if (IntegrityGeometricalShape LstEname)
				(progn
					
					(if (CheckIfEasyCutShape EnameShape)
						(progn
							(setq IdShape	(GetIdShape	    EnameShape))
							(setq Name		(GetNameShape	EnameShape))
							(setq Cut		(GetCutShape	EnameShape))
							(setq Order		(GetComShape	EnameShape))
							(setq Phase		(GetPhaseShape	EnameShape))
							(setq Mat		(GetMatShape	EnameShape))
							(setq Tk		(GetTkShape		EnameShape))
							(setq Date		(Today))
							(setq Qta		(GetQtaShape	EnameShape))
						)
						(progn
							(setq Name	"---")
							(setq Cut	"1"	 )
							(setq Order	"---")
							(setq Phase "---")
							(setq Mat	"---")
							(setq Tk	"---")
							(setq Date (Today))
							(setq Qta	"1"  )
							
						)
					)
					
					(setq Rtn (AssignNameShape (car LstEname) (list	Name 	;nome piatto
																	Cut 	;compensazione taglio
																	Order	;nome commessa
																	Phase 	;nome fase
																	Mat 	;nome qualita
																	Tk		;spessore
																	Date	;ultima modifica
																	Qta)) 	;quantita
					)
					
					
					; Trigger contact +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					(if IdShape
						(ChangeRecordShape Rtn 2 IdShape)
					)
					(foreach itm (append (list Rtn) (GetEnameInternalShapeByDummyEnameSelect Rtn)) 	; verifica virtuale
						(foreach tr	(GetContactEnameTriggerByDummyShape itm)						; verifica di posizione
							(ChangeRecordTrigger tr 1 (GetIdShape itm))
							(cond 
								((= (GetTypeShape tr) 3) 		; attacco entra
									(vla-put-Color (vlax-ename->vla-object tr) $ColorEntra)
								)
								((= (GetTypeShape tr) 4) 		; attacco esci
									(vla-put-Color (vlax-ename->vla-object tr) $ColorEsci)
								)
							)
						)
					)
					; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

				)
			)
		)
	)
	Rtn
)
;
;
;
(defun InfoCutSheet ( / Ssel EnameSheet LstFoundSearch DataCut DataSheet Mark EnameRef DimensionShape LstInfoCutShape LstInfoSheet xx itm1 itm2 StrRtn LstTab NameReport TotQta)

		(prompt "\nSelezionare la lamiera..")
		(setq Ssel (ssget "_+.:E:S" (list (list -3 (list (strcat $RgpSheet "," $RgpSheetTarget))))))
		(if Ssel	
			(setq EnameSheet (GetEnameSheetByDummyEname (ssname Ssel 0)))
		)
		
		(if EnameSheet
			(if (setq LstFoundSearch (FindShapeOnSheet (list EnameSheet) "<>" "<>" "<>"))
				(progn
					(setq DataCut (car (GetInfoCutSheetFound LstFoundSearch)))	; (DataLstShape TotLgCut  TotLgExtCut TotLgIntCut TotLgTriggerCut SpeedCut Timing         TotSurface SheetSurface)
																				;  (--------   "325802.36" "229412.02" "96390.35"      "0.00"       "425.0" "766 min 36 sec" "127.64"    "30.00")
				   ;(setq DataCut (GetInfoCutSheet EnameSheet))       			; (DataLstShape TotLgCut TotLgExtCut TotLgIntCut TotLgTriggerCut SpeedCut Timing TotSurface SheetSurface)
					(setq DataSheet (GetDataSheetByEname EnameSheet))           ; (IdSheet NameSheet Widthsheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet)
					(setq TotQta 0)
					(foreach Mark (cdr (car LstFoundSearch))
						(setq EnameRef 	(cadr Mark))
						(setq DimensionShape (GetDimensionShape EnameRef))
						(setq LstInfoCutShape 	(append LstInfoCutShape (list 	(list	(GetComShape   EnameRef) 		
																						(GetPhaseShape EnameRef) 		
																						(GetNameShape  EnameRef) 		
																						(rtos (- (length Mark) 1) 2 0) 						 ; Quantità
																						(GetMatShape   EnameRef) 		
																						(LM:rtos       (car  (cadr  DimensionShape)) 2 0)    ; Lunghezza
																						(LM:rtos       (cadr (cadr  DimensionShape)) 2 0)    ; Larghezza
																						(GetTkShape    EnameRef)
																				)
																		)
												)
						)
						(setq TotQta (+ TotQta (- (length Mark) 1)))
					)
			
					(setq LstInfoSheet 	(list 	(nth 0 DataSheet)	; Sheet Id				0
												(nth 1 DataSheet)	; Sheet Name			1
												(nth 2 DataSheet)	; Sheet Width			2
												(nth 3 DataSheet)	; Sheet Height			3
												(nth 4 DataSheet)	; Sheet Thick			4
												(nth 5 DataSheet)	; Sheet Surface			5
												(nth 6 DataSheet) 	; Sheet Weight			6
												(nth 7 DataSheet) 	; Sheet Mat				7
												(nth 1 DataCut)		; Shape TotLgCut		8
												(nth 2 DataCut)		; Shape LgExtCut		9
												(nth 3 DataCut)		; Shape LgIntCut		10
												(nth 4 DataCut)		; Shape LgTriggerCut	11
												(nth 5 DataCut)		; Shape SpeedCut		12
												(nth 6 DataCut)		; Shape TimingCut		13
												(nth 7 DataCut)		; Shape Surface			14
												(LM:rtos (* (atof (nth 7 DataCut)) (atof (nth 4 DataSheet)) 7.85) 2 2)  							; Shape Weight  	 15
												(LM:rtos (- (atof (nth 8 DataCut)) (atof (nth 7 DataCut))) 2 2)										; SheetScrapsSurface 16
												(LM:rtos (* (- (atof (nth 8 DataCut)) (atof (nth 7 DataCut)))  (atof (nth 4 DataSheet)) 7.85) 2 2)  ; SheetScrapsWeigth  17
												(LM:rtos (- 100.0 (* (/ (atof (nth 7 DataCut)) (atof (nth 8 DataCut))) 100.0)) 2 2)					; SheetScraps%       18
										)
					)
					(princ 	LstInfoSheet)
					(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
					(new_dialog "InfoCut" xx "" (cond ( *InfoCut* ) ( '(-1 -1) )))
				
					(start_list "box_info1")
						(mapcar 'add_list (list "COMMESSA\tFASE\tMARCA\tQUANTITA'\tQUALITA'\tLUNGHEZZA\tLARGHEZZA\tSPESSORE"))
					(end_list)
				
					(foreach itm1 LstInfoCutShape
						(setq StrRtn "")
						(foreach itm2 itm1
							(setq StrRtn (strcat StrRtn itm2 "\t"))
						)
						(setq LstTab (append LstTab (list StrRtn)))
					)
					(start_list "box_info2")
						(mapcar 'add_list LstTab)
					(end_list)
				
					(start_list "box_info3")
						(mapcar 'add_list (list (strcat "\t\ttot pezzi ->\t"(LM:rtos TotQta 2 0)"\t\t")))
					(end_list)
				
					(set_tile "box_info1" "0")
					(set_tile "box_info3" "0")
				
					(set_tile "SheetSurface"		(nth 5 LstInfoSheet))
					(set_tile "WeightSheet"		    (nth 6 LstInfoSheet))
					(set_tile "MatSheet"		    (nth 7 LstInfoSheet))
					(set_tile "TotLgCut" 			(nth 8 LstInfoSheet))
					(set_tile "LgExtCut"			(nth 9 LstInfoSheet))               
					(set_tile "LgIntCut"			(nth 10 LstInfoSheet))               
					(set_tile "LgTriggerCut"		(nth 11 LstInfoSheet))             
					(set_tile "SpeedCut"			(nth 12 LstInfoSheet))              
					(set_tile "TimingCut"			(nth 13 LstInfoSheet))
					(set_tile "ShapeSurface"		(nth 14 LstInfoSheet))
					(set_tile "WeightShape"		    (nth 15 LstInfoSheet))
					(set_tile "SheetScrapsSurface"  (nth 16 LstInfoSheet))
					(set_tile "SheetScrapsWeigth"   (nth 17 LstInfoSheet))
					(set_tile "SheetScrapsPercent"  (nth 18 LstInfoSheet))
				
					(action_tile "cancel"    (strcat "(setq *InfoCut* (done_dialog)) (unload_dialog xx)"))
					(action_tile "report"	 (strcat "(setq NameReport (ReportFound LstFoundSearch))"
													 "(if NameReport (startapp \"explorer\" NameReport))"))
					(start_dialog)
				)
				(LM:popup "Avvertimento" "Nessun contorno presente nella lamiera" (+ 1 48 4096))
			)
		)
)
;
;
;
(defun ChangeRecordShape (EnameShape IdRecord NewRecord / ultent TypShape IdShape JouShape NameShape CutComp ComShape PhaseShape MatShape TkShape DateShape Qta
														  xd_list nuova_entita
														  ColorShapeOra ColorShapeAntiOra ColorHoleOra ColorHoleAntiOra ColorCircle ColorEllipse)
														  
														  
		;1	TypShape   *  ["CE"] ["CI"]			CE contorno esterno / CI contorno interno
		;2	IdShape       ["123456789"]			nome contorno -valore string-)
		;3	JouShape   *  ["0"] ["2"] ["3"]		percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria
		;4	NameShape  *  ["PIPPO"]				nome piatto
		;5	CutComp    *  ["0"]["1"]["2"]["3"]	compensazione taglio 0 nessuna / 1 auto 2 dx / 3 sx
		;6	ComShape   *  ["C2018032"]  	 	nome commessa
		;7	PhaseShape *  ["P100"]  	 	    nome fase
		;8	MatShape   *  ["S355J0"] 	 	    nome qualita'
		;9	TkShape    *  ["10"]  	 	        spessore
		;10	DateShape     ["10/11/2018"]  	 	ultima modifica
		;11	Quantita      ["100"]  	 			quantita

	
		(if (and EnameShape IdRecord NewRecord)
			(if (assoc -3 (entget EnameShape (list "*")))
				(if (= (nth 0 (nth 1 (assoc -3 (entget EnameShape (list "*"))))) $RgpShape)			
					(progn
						
						(setq TypShape   (cdr (nth 2  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))) ;	["CE"] ["CI"]
						(setq IdShape    (cdr (nth 3  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))) ;	["123456789"]
						(setq JouShape   (cdr (nth 4  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))) ;	["0"]["2"]["3"]
						(setq NameShape  (cdr (nth 5  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))) ;	["PIPPO"]
						(setq CutComp    (cdr (nth 6  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))) ;	["0"]["1"]["2"]["3"]
						(setq ComShape   (cdr (nth 7  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))) ;	["C2018032"]
						(setq PhaseShape (cdr (nth 8  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))) ;	["P100"]
						(setq MatShape   (cdr (nth 9  (nth 1 (assoc -3 (entget EnameShape (list "*"))))))) ;	["S355J0"]
						(setq TkShape    (cdr (nth 10 (nth 1 (assoc -3 (entget EnameShape (list "*"))))))) ;	["10"]
						(setq DateShape  (cdr (nth 11 (nth 1 (assoc -3 (entget EnameShape (list "*"))))))) ;	["10/11/2018"]
						(setq QtaShape   (cdr (nth 12 (nth 1 (assoc -3 (entget EnameShape (list "*"))))))) ;	["100"]
						
						(cond 
							((= IdRecord 1) (setq TypShape  NewRecord))
							((= IdRecord 2) (setq IdShape   NewRecord))
							
							;((= IdRecord 3)
							;	(setq JouShape  NewRecord)
							;	(if (and (= JouShape "2") (= (nth 0 Journey) 3)) (RevLwpline EnameShape))
							;	(if (and (= JouShape "3") (= (nth 0 Journey) 2)) (RevLwpline EnameShape))
							;	(setq Journey (CheckPoly EnameShape))
							;)
							
							((= IdRecord 3)
								
								(cond 
									((= (cdr (assoc 0 (entget EnameShape))) "LWPOLYLINE")
									
										(setq Journey (CheckPoly EnameShape))
										(setq JouShape  NewRecord)
										(if (and (= JouShape "2") (= (nth 0 Journey) 3)) (RevLwpline EnameShape))
										(if (and (= JouShape "3") (= (nth 0 Journey) 2)) (RevLwpline EnameShape))
										(setq JouShape (rtos (nth 0 (CheckPoly EnameShape)) 2 0))
										
										; Rtn 	-1 	non è una polilinea
										;		 0	polylinea aperta
										;		 1	polylinea con vertici duplicati
										;		 2	polylinea anti oraria
										;		 3	polylinea oraria
										;		 4	polylinea 1° e ultimo vertice coincidente 

									)
									((or (= (cdr (assoc 0 (entget EnameShape))) "CIRCLE") (= (cdr (assoc 0 (entget EnameShape))) "ELLIPSE"))
										(setq JouShape NewRecord)
										
									)
								)
							)						
														
							((= IdRecord 4) (setq NameShape NewRecord))
							((= IdRecord 5) (setq CutComp   NewRecord))

							((= IdRecord 6)  (setq ComShape   NewRecord))
							((= IdRecord 7)  (setq PhaseShape NewRecord))
							((= IdRecord 8)  (setq MatShape   NewRecord))
							((= IdRecord 9)  (setq TkShape    NewRecord))
							((= IdRecord 10) (setq DateShape  NewRecord))
							((= IdRecord 11) (setq QtaShape   NewRecord))
					
						)
						
						(setq ultent    (entget EnameShape))
						(setq xd_list (list '(1002 . "}")))
						
						(setq xd_list (cons (cons 1000 QtaShape)   xd_list)
							  xd_list (cons (cons 1000 DateShape)  xd_list)
							  xd_list (cons (cons 1000 TkShape)    xd_list)
							  xd_list (cons (cons 1000 MatShape)   xd_list)
							  xd_list (cons (cons 1000 PhaseShape) xd_list)
							  xd_list (cons (cons 1000 ComShape)   xd_list)
						
							  xd_list (cons (cons 1000 CutComp)   xd_list)
							  xd_list (cons (cons 1000 NameShape) xd_list)
							  xd_list (cons (cons 1000 JouShape)  xd_list)
							  xd_list (cons (cons 1000 IdShape)   xd_list)
							  xd_list (cons (cons 1000 TypShape)  xd_list)
							  xd_list (cons '(1002 . "{")         xd_list)
							  xd_list (cons $RgpShape xd_list)
							  xd_list (list -3 xd_list)
						)
						(setq nuova_entita (append ultent (list xd_list)))
						(entmod nuova_entita)
						(entupd EnameShape)
						
						; modifica grafica controno ++
						
						(setq ColorShapeOra  	$ColorShapeOra)
						(setq ColorShapeAntiOra $ColorShapeAntiOra)
						(setq ColorHoleOra		$ColorHoleOra)
						(setq ColorHoleAntiOra 	$ColorHoleAntiOra)
						;(setq ColorCircle 		$ColorCircle)
						;(setq ColorEllipse 	$ColorEllipse)
						
						
						(cond
							((= TypShape "CE")
								(if (= JouShape "3") (vla-put-Color (vlax-ename->vla-object EnameShape) ColorShapeOra))	
								(if (= JouShape "2") (vla-put-Color (vlax-ename->vla-object EnameShape) ColorShapeAntiOra))
							)
							((= TypShape "CI")
								(if (= JouShape "3") (vla-put-Color (vlax-ename->vla-object EnameShape) ColorHoleOra))
								(if (= JouShape "2") (vla-put-Color (vlax-ename->vla-object EnameShape) ColorHoleAntiOra))
							)
						)
					)
				)
			)
		)
)
;
;
;
(defun ChangeRecordTrigger (EnameTrigger IdRecord NewRecord / RgpTrigger Color IdTrigger JouTrigger ultent xd_list nuova_entita)
	
		(if (and EnameTrigger IdRecord NewRecord)
			(if (assoc -3 (entget EnameTrigger (list "*")))
				(progn
					(if (= (nth 0 (nth 1 (assoc -3 (entget EnameTrigger (list "*"))))) $RgpTiggerOn)
						(setq RgpTrigger $RgpTiggeron)
					)
					(if (= (nth 0 (nth 1 (assoc -3 (entget EnameTrigger (list "*"))))) $RgpTiggerOff)
						(setq RgpTrigger $RgpTiggeroff)
					)
					(if (or (= (nth 0 (nth 1 (assoc -3 (entget EnameTrigger (list "*"))))) $RgpTiggerOn)
							(= (nth 0 (nth 1 (assoc -3 (entget EnameTrigger (list "*"))))) $RgpTiggerOff)
						)
						(progn
						
							(setq IdTrigger  (cdr (nth 2 (nth 1 (assoc -3 (entget EnameTrigger (list "*")))))))
							(setq JouTrigger (cdr (nth 3 (nth 1 (assoc -3 (entget EnameTrigger (list "*")))))))
						
							;1	IdTrigger     ["123456789"]	        	nome attacco -valore string-)
							;2	JouTrigger    ["-"] ["+"] ["*"] 		percorrenza attacco raggio [-/+] se "*" rettilineo
						
							(cond 
								((= IdRecord 1) (setq IdTrigger  NewRecord))
								((= IdRecord 2) (setq JouTrigger NewRecord))
							)
						
							(setq ultent    (entget EnameTrigger))
							(setq xd_list (list '(1002 . "}")))
							(setq xd_list (cons (cons 1000 JouTrigger)  xd_list))
							(setq xd_list (cons (cons 1000 IdTrigger)   xd_list))
							(setq xd_list (cons '(1002 . "{")           xd_list))
							(setq xd_list (cons RgpTrigger xd_list))
							(setq xd_list (list -3 xd_list))
							(setq nuova_entita (append ultent (list xd_list)))
							(entmod nuova_entita)
							(entupd EnameTrigger)
						
						)
					)
				)
			)
		)
)
;
;
;
(defun GetFoldrNc (/ PathNc)

	(setq PathNc (vl-registry-read EasyCutRegistryPath$ "PathNc"))
	
	(if (not PathNc)
		(setq PathNc "c:\\")
	)
	
	(setq PathNc (LM:browseforfolder "Archivio Nc" PathNc 16384))
	
	(if PathNc
		(vl-registry-write EasyCutRegistryPath$ "PathNc" PathNc)
	)
	PathNc
)
;
;
;
(defun Dcl_Handle_Folder_List ( Path TypeFile / Set_Tile_Folder Get_Tile_List
												ListFolder ListFile
												xx Rtn)

	;											
	; esempio 	Path "C:/Temp"
	;			Typefile "*.nc"
	;											
	; ***************************
	(defun Set_Tile_Folder (ActualFolder LstSubFolder / Itm FolderSelect SplitFolder Conta Path)
	
		
		(if (and ActualFolder LstSubFolder (= 4 $reason))
		
			(progn
				
				(setq Itm (get_tile "box_active"))
				(setq FolderSelect (nth (atoi Itm) LstSubFolder))
		
				;(alert FolderSelect)
		
				(cond
					((= FolderSelect  "<--")
						(setq SplitFolder (splitxt ActualFolder "\\"))
						(setq Conta 0)
						(setq Path "")
						(repeat (- (length Splitfolder) 1)
							(setq Path (strcat Path (nth Conta SplitFolder) "\\"))
							(setq Conta (1+ Conta))
						)
					)
					(t
						(if (= (substr ActualFolder (strlen ActualFolder) 1) "\\")
							(setq Path (strcat ActualFolder FolderSelect "\\"))
							(setq Path (strcat ActualFolder "\\" FolderSelect "\\"))
						)
					)
				)
				
				;(alert Path)
				
				(if Path
					(progn
					
						;(Set_Tile_List "box_active" nil "")
						;(Set_Tile_List "box_select" nil "")
						(setq ListFolder 	(vl-remove "." (vl-directory-files Path nil -1)))
						(setq ListFolder    (LM:SubstNth "<--" 0 ListFolder))
						(setq ListFile 		(vl-directory-files Path "*.nc" 1))
						(set_tile "nome_dir" Path)
						(Set_Tile_List "box_active" ListFolder "")
						(Set_Tile_List "box_select" ListFile  "")
		
					)
				)
			)
			(setq Path ActualFolder)
		)
		Path
	)
	; ***************************
	(defun Set_Tile_List (KeyName ListName Selected / Item)
		(start_list KeyName 3)
		(mapcar 'add_list ListName)
		(end_list)
		;(foreach Item (if (listp Selected) Selected (list Selected))
		;	(if (member Item ListName)
		;		(set_tile KeyName (itoa (- (length ListName) (length (member Item ListName)))))
		;	)
		;)
	)
	
	
	; ***************************
	(if (and Path TypeFile)
		(progn
			(setq ListFolder 	(vl-remove "." (vl-directory-files Path nil -1)))
			(setq ListFolder    (LM:SubstNth "<--" 0 ListFolder))
			(setq ListFile 		(vl-directory-files Path TypeFile 1))
			
			(setq xx (load_dialog (strcat GuiPathEasyCut$ "Dstv.dcl")))
			(new_dialog "handle_folder_list" xx)
			
			
			
			(set_tile "nome_dir" Path)
			(set_tile "title" "Selezione archivio")
			(Set_Tile_List "box_active" ListFolder "")
			(Set_Tile_List "box_select" ListFile  "")
			

			(action_tile "box_active"  "(setq Rtn (Set_Tile_Folder Path ListFolder))
									    (setq Path Rtn)")
										
			
			
			(action_tile "accept" 	   "(done_dialog) 	(unload_dialog xx)")
			(action_tile "cancel"      "(setq Rtn nil) (done_dialog) (unload_dialog xx)")
			(start_dialog)
		)
	)
	Rtn
)
;
;
;
(defun GuiBlockInfoShape (LstInfoBlock / GetInfoDcl IdShape OrderShape PhaseShape MkShape TkShape
									     LengthShape HeightShape MatShape LastModifyShape QtaShape
										 PerimeterShape WeigthShape TypeShape JouShape CompShape 
										 TimeCutShape Rtn loop xx)


	;
	;
	;	
	(defun GetInfoDcl ( / 	info_1 info_2 info_3 info_4 info_5 info_6 info_7 
							info_8 info_9 info_10 info_11 info_12 info_13
							info_5_1 info_5_2 info_5_3 info_5_4
							info1 info2 info3 info4 info5 info6 info7
							info8 info9 info10 info11 info12 info13)
                        

		(setq info_1 	(get_tile "cont_est"))
		(setq info_2 	(get_tile "idshape"))
		
		(setq info_3 	(get_tile "perc_anti"))
		(setq info_4 	(get_tile "marca"))
	
		(setq info_5_1 	(get_tile "comp_auto"))
		(setq info_5_2 	(get_tile "comp_no"))
		(setq info_5_3 	(get_tile "comp_dx"))
		(setq info_5_4 	(get_tile "comp_sx"))

		(setq info_6   (get_tile "lgshape"))
		(setq info_7   (get_tile "timecut"))
		;
		(setq info_8   	(get_tile "commessa"))
		(setq info_9   	(get_tile "fase"))
		(setq info_10  	(get_tile "qualita"))
		(setq info_11  	(get_tile "spessore"))
		(setq info_12   (get_tile "ultimamodifica"))
		(setq info_13   (get_tile "quantita"))
		;
		;
		;
		(if (= info_1 "1")  (setq info1 "CE") (setq info1 "CI"))
		(setq info2 info_2)
		(if (= info_3 "1")  (setq info3 "2") (setq info3 "3"))
		(setq info4 info_4)
		(if (= info_5_1 "1") (setq info5 "1"))
		(if (= info_5_2 "1") (setq info5 "0"))
		(if (= info_5_3 "1") (setq info5 "2"))
		(if (= info_5_4 "1") (setq info5 "3"))
		(setq info6 info_6)
		(setq info7 info_7)
		(setq info8 info_8)
		(setq info9 info_9)
		(setq info10 (strcase info_10))
		(setq info11 info_11)
		(setq info12 info_12)
		(setq info13 info_13)

		(list info1 info2 info3 info4 info5 info6 info7 info8 info9 info10 info11 info12 info13)
		;	
		;0	TypShape   *  ["CE"] ["CI"]			CE contorno esterno / CI contorno interno
		;1	IdShape    *  ["123456789"]			nome contorno -valore string-)
		;2	JouShape   *  ["0"] ["2"] ["3"]		percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria
		;3	NameShape  *  ["PIPPO"]				nome piatto
		;4	CutComp    *  ["0"]["1"]["2"]["3"]	compensazione taglio 0 nessuna / 1 auto / 2 dx / 3 sx
		;5	Perimeter  *  "2320" 				perimetro
		;6	Tyming	   *  "11 min 36 sec"		tempo di taglio
		;7	ComShape   *  ["C2018032"]  	 	nome commessa
		;8	PhaseShape *  ["P100"]  	 	    nome fase
		;9	MatShape   *  ["S355J0"] 	 	    nome qualita'
		;10	TkShape    *  ["10"]  	 	        spessore
		;11	DateShape  *  ["10/11/2018"]  	 	ultima modifica
		;12	QtaShape   *  ["100"]  	 			quantita
	)
	;
	;
	;
	(if LstInfoBlock
		
		(progn
		
				(setq IdShape	 		(nth 0  LstInfoBlock))
				(setq OrderShape		(nth 1  LstInfoBlock))
				(setq PhaseShape		(nth 2  LstInfoBlock))
				(setq MkShape			(nth 3  LstInfoBlock))
				(setq TkShape			(nth 4  LstInfoBlock))
				(setq LengthShape		(nth 5  LstInfoBlock))
				(setq HeightShape		(nth 6  LstInfoBlock))
				(setq MatShape			(nth 7  LstInfoBlock))
				(setq LastModifyShape	(nth 8  LstInfoBlock))
				(setq PerimeterShape	(nth 9  LstInfoBlock))
				(setq WeigthShape		(nth 10 LstInfoBlock))
				(setq TypeShape			(nth 11 LstInfoBlock))
				(setq JouShape			(nth 12 LstInfoBlock))
				(setq CompShape			(nth 13 LstInfoBlock))
				(setq TimeCutShape		(nth 14 LstInfoBlock))
				(setq QtaShape			(nth 15 LstInfoBlock))
				;
				;+++++++++++ load Gui +++++++++++
				;
				;(setq loop T)
				;(while loop
					(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
			
					(new_dialog "AtteditShape" xx "" (cond ( *AtteditShape* ) ( '(-1 -1) )))
					
					(mode_tile "idshape" 1)
					(mode_tile "lgshape" 1)
					(mode_tile "timecut" 1)
					(mode_tile "ultimamodifica" 1)
					(mode_tile "typecont" 1)
				
					; ------
				
					(set_tile "cont_est" "1")
					(set_tile "cont_int" "0")
				
					(if (= JouShape "Antioraria")
						(set_tile "perc_anti" "1")
						(set_tile "perc_ora" "1")
					)
			
					(set_tile "idshape"        IdShape)
					(set_tile "lgshape"        PerimeterShape)
					(set_tile "timecut"        TimeCutShape)
					(set_tile "ultimamodifica" LastModifyShape)
					(set_tile "quantita" 	   QtaShape)
				
					(set_tile "commessa"       OrderShape)
					(set_tile "fase"           PhaseShape)
					(set_tile "marca"          MkShape)
					(set_tile "qualita"        MatShape)
					(set_tile "spessore"       TkShape)
		
					(cond
						((= CompShape "Nessuna")    (set_tile "comp_no" "1"))
						((= CompShape "Automatica") (set_tile "comp_auto" "1"))
						((= CompShape "Destra")     (set_tile "comp_dx" "1"))
						((= CompShape "Sinistra")   (set_tile "comp_sx" "1"))
					)
					; azioni
					(action_tile "cancel"   (strcat  "(setq *AtteditShape* (done_dialog))"
													 "(unload_dialog xx) (setq loop nil Rtn nil)"
											)
					)
					(action_tile "apply"    (strcat "(setq Rtn (GetInfoDcl))"
													 "(setq *AtteditShape* (done_dialog))"
													 "(unload_dialog xx) (setq loop nil)"
											)
					)
					(action_tile "select"   (strcat  "(setq *AtteditShape* (done_dialog))"
													 "(unload_dialog xx) (setq loop nil Rtn 1)"
											)
					)
					(start_dialog)				
				;)
		)
	)
	Rtn
)
;
;
;
(defun UpdateBarCode (EnameBlockShape / LstInfoBlock LstDataBarCode LstBarCode StrBarCode itm ssel PosBarCode EnameBlockBarCode minmax pmid)

	(if EnameBlockShape
		(progn
			(setq LstInfoBlock (GetInfoBlockShape EnameBlockShape))
			;
			; modifica codice a barre ++++++++++++++++++++
			;
			;BARCODESHAPE
			;TXTBARCODE
			;$LstDataBarCode	"------"			
			;					"ID CONTORNO"		(nth 0  LstInfoBlock)
			;					"COMMESSA"			(nth 1  LstInfoBlock)
			;					"FASE"				(nth 2  LstInfoBlock)
			;					"MARCA" 			(nth 3  LstInfoBlock)
			;					"SPESSORE" 			(nth 4  LstInfoBlock)
			;					"LUNGHEZZA"			(nth 5  LstInfoBlock)
			;					"LARGHEZZA" 		(nth 6  LstInfoBlock)
			;					"PERIMETRO" 		(nth 9  LstInfoBlock)
			;					"MATERIALE" 		(nth 7  LstInfoBlock)
			;					"PESO" 				(nth 10 LstInfoBlock)
			;					"CONTORNO" 			(nth 11 LstInfoBlock)
			;					"PERCORRENZA"		(nth 12 LstInfoBlock)
			;					"COMPENSAZIONE"		(nth 13 LstInfoBlock) 
			;					"TEMPO TAGLIO"		(nth 14 LstInfoBlock) 
			;					"ULTIMA MODIFICA"	(nth 8 LstInfoBlock)
			
			(setq LstDataBarCode 	(list 	"------"
											(nth 0  LstInfoBlock)
											(nth 1  LstInfoBlock)
											(nth 2  LstInfoBlock)
											(nth 3  LstInfoBlock)
											(nth 4  LstInfoBlock)
											(nth 5  LstInfoBlock)
											(nth 6  LstInfoBlock)
											(nth 9  LstInfoBlock)
											(nth 7  LstInfoBlock)
											(nth 10 LstInfoBlock)
											(nth 11 LstInfoBlock)
											(nth 12 LstInfoBlock)
											(nth 13 LstInfoBlock) 
											(nth 14 LstInfoBlock) 
											(nth 8 LstInfoBlock)
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
			
			(setq ssel (ssget "_X" (list (cons 67 0) (cons 0  "INSERT") (cons 2 (strcat "BARCODE128_" (nth 0 LstInfoBlock))))))
			(if ssel
				(progn
					
					(setq minmax (LM:SSBoundingBox (LstEname->Ssget (list (ssname ssel 0)))))
					(setq PosBarCode  (list (/ (+ (nth 0 (nth 0 minmax)) (nth 0 (nth 1 minmax))) 2.0)
											(/ (+ (nth 1 (nth 0 minmax)) (nth 1 (nth 1 minmax))) 2.0)
									)
					)
					
					(entdel (ssname ssel 0))
					(BrCode128 StrBarCode (strcat "BARCODE128_" (nth 0 LstInfoBlock))  PosBarCode 30 (* 30 0.2))
					(setq EnameBlockBarCode (entlast))
					(setq minmax (LM:SSBoundingBox (LstEname->Ssget (list EnameBlockBarCode))))
					(setq pmid  (list 	(/ (+ (nth 0 (nth 0 minmax)) (nth 0 (nth 1 minmax))) 2.0)
										(/ (+ (nth 1 (nth 0 minmax)) (nth 1 (nth 1 minmax))) 2.0)
								)
					)
					(vla-Move (vlax-ename->vla-object EnameBlockBarCode)  (vlax-3d-point (nth 0 pmid) (nth 1 pmid))
																		  (vlax-3d-point (nth 0 PosBarCode) (nth 1 PosBarCode))) 
				)
			)
		)
	)
)
;
;
;
(defun UpdateBlockShape (EnameBlockShape LstInfoBlock / JouShape CompShape WeightShape TkShape NewWeightShape)

	(if EnameBlockShape
		(progn
				
				(setq EnameShape     (nth 0 (GetEnameById (nth 1 LstInfoBlock))))
				(setq TkShape		 (nth 10 LstInfoBlock))
				
				(princ "\n----- ") (princ TkShape) (terpri)
				
				(setq NewWeightShape 	(rtos (* (/ (vla-get-area (vlax-ename->vla-object EnameShape)) 1000000.0)
										  (atof TkShape) 7.85) 2 2))
										  
				;0	TypShape   *  ["CE"] ["CI"]			CE contorno esterno / CI contorno interno
				;1	IdShape    *  ["123456789"]			nome contorno -valore string-)
				;2	JouShape   *  ["0"] ["2"] ["3"]		percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria
				;3	NameShape  *  ["PIPPO"]				nome piatto
				;4	CutComp    *  ["0"]["1"]["2"]["3"]	compensazione taglio 0 nessuna / 1 auto / 2 dx / 3 sx
				;5	Perimeter  *  "2320" 				perimetro
				;6	Tyming	   *  "11 min 36 sec"		tempo di taglio
				;7	ComShape   *  ["C2018032"]  	 	nome commessa
				;8	PhaseShape *  ["P100"]  	 	    nome fase
				;9	MatShape   *  ["S355J0"] 	 	    nome qualita'
				;10	TkShape    *  ["10"]  	 	        spessore
				;11	DateShape  *  ["10/11/2018"]  	 	ultima modifica
				;12	QtaShape   *  ["100"]  	 			quantita
				
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "IDSHAPE" 		(nth 1  LstInfoBlock))
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "ORDERSHAPE" 		(nth 7  LstInfoBlock))
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "PHASESHAPE" 		(nth 8  LstInfoBlock))
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "MKSHAPE"			(nth 3  LstInfoBlock))
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "TKSHAPE"			(nth 10	LstInfoBlock)) 
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "MATSHAPE"		(nth 9	LstInfoBlock))
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "LASTMODIFYSHAPE"	(nth 11	LstInfoBlock))
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "PERIMETERSHAPE" 	(nth 5	LstInfoBlock))
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "WEIGTHSHAPE"		NewWeightShape)
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "TYPESHAPE" 		"Esterno")
				
				(cond 
					((= (nth 2	LstInfoBlock) "2")
						(setq JouShape "Antioraria")
					)
					((= (nth 2	LstInfoBlock) "3")
						(setq JouShape "Oraria")
					)	
				)
				
				(cond 
					((= (nth 4	LstInfoBlock) "0")
						(setq CompShape "Nessuna")
					)
					((= (nth 4	LstInfoBlock) "1")
						(setq CompShape "Automatica")
					)
					((= (nth 4	LstInfoBlock) "2")
						(setq CompShape "Destra")
					)
					((= (nth 4	LstInfoBlock) "3")
						(setq CompShape "Sinistra")
					)
				)
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "JOUSHAPE" JouShape)
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "COMPSHAPE" CompShape)
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "TIMECUTSHAPE"	(nth 5 (nth 6 LstInfoBlock)))
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlockShape) "QTASHAPE"		(nth 12	LstInfoBlock))
		)
	)
)
;
;
;
(defun BlockInfoShape->UpdateEnameShape (LstInfo / EnameShape LstEnameInternalShape itm)

				;0	TypShape   *  ["CE"] ["CI"]			CE contorno esterno / CI contorno interno
				;1	IdShape    *  ["123456789"]			nome contorno -valore string-)
				;2	JouShape   *  ["0"] ["2"] ["3"]		percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria
				;3	NameShape  *  ["PIPPO"]				nome piatto
				;4	CutComp    *  ["0"]["1"]["2"]["3"]	compensazione taglio 0 nessuna / 1 auto / 2 dx / 3 sx
				;5	Perimeter  *  "2320" 				perimetro
				;6	Tyming	   *  "11 min 36 sec"		tempo di taglio
				;7	ComShape   *  ["C2018032"]  	 	nome commessa
				;8	PhaseShape *  ["P100"]  	 	    nome fase
				;9	MatShape   *  ["S355J0"] 	 	    nome qualita'
				;10	TkShape    *  ["10"]  	 	        spessore
				;11	DateShape  *  ["10/11/2018"]  	 	ultima modifica
				;12	QtaShape   *  ["100"]  	 			quantita

				; dati modificabili	valori possibili +++++++++
				
				;1	TypShape   *  ["CE"] ["CI"]			CE contorno esterno / CI contorno interno
				;2	IdShape    *  ["123456789"]			nome contorno -valore string-)
				;3	JouShape   *  ["0"] ["2"] ["3"]		percorrenza di taglio 0 contorno aperto 2 percorrenza antioraria 3 percorrenza oraria
				;4	NameShape  *  ["PIPPO"]				nome piatto
				;5	CutComp    *  ["0"]["1"]["2"]["3"]	compensazione taglio 0 nessuna / 1 auto / 2 dx / 3 sx
				;6	ComShape   *  ["C2018032"]  	 	nome commessa
				;7	PhaseShape *  ["P100"]  	 	    nome fase
				;8	MatShape   *  ["S355J0"] 	 	    nome qualita'
				;9	TkShape    *  ["10"]  	 	        spessore
				;10	DateShape  *  ["10/11/2018"]  	 	ultima modifica
				;11	QtaShape   *  ["100"]  	 			quantita
				
				(setq EnameShape (nth 0 (GetEnameById (nth 1 LstInfo))))
				(if EnameShape
					(progn
						(ChangeRecordShape EnameShape 1  (nth 0  LstInfo))	;1	TypShape
						(ChangeRecordShape EnameShape 2  (nth 1  LstInfo))	;2	IdShape
						(ChangeRecordShape EnameShape 3  (nth 2  LstInfo))	;3	JouShape
						(ChangeRecordShape EnameShape 4  (nth 3  LstInfo))	;4	NameShape 
						(ChangeRecordShape EnameShape 5  (nth 4  LstInfo))	;5	CutComp
						(ChangeRecordShape EnameShape 6  (nth 7  LstInfo))	;6	ComShape
						(ChangeRecordShape EnameShape 7  (nth 8  LstInfo))	;7	PhaseShape
						(ChangeRecordShape EnameShape 8  (nth 9  LstInfo))	;8	MatShape 
						(ChangeRecordShape EnameShape 9  (nth 10 LstInfo))	;9	TkShape
						(ChangeRecordShape EnameShape 10 (nth 11 LstInfo))	;10	DateShape
						(ChangeRecordShape EnameShape 11 (nth 12 LstInfo))	;11	QtaShape
						
						(setq LstEnameInternalShape (GetEnameInternalShapeByDummyEnameSelect EnameShape))
						(foreach itm LstEnameInternalShape
							(ChangeRecordShape itm 6  (nth 7  LstInfo))	;6	ComShape
							(ChangeRecordShape itm 7  (nth 8  LstInfo))	;7	PhaseShape
							(ChangeRecordShape itm 8  (nth 9  LstInfo))	;8	MatShape 
							(ChangeRecordShape itm 9  (nth 10 LstInfo))	;9	TkShape
							(ChangeRecordShape itm 11 (nth 12 LstInfo))	;11	QtaShape
						)
					)
				)
)
;
;
;
(defun EnameShape->UpdateBlockInfoShape (EnameShape / DataInfoShape LstBlk pmnl pmxl WidthShape HeightShape SurfaceShape WeightShape LenghtCut EnameBlock Find)

	(if EnameShape
		(progn
			(setq DataInfoShape (GetDataShape EnameShape))
			
			;0  TypShape
			;1  IdShape 
			;2  JouShape 
			;3  NameShape 
			;4  CutComp 
			;5  LenghtCut 
			;6  (SeTime ExTime InTime TotTime) 
			;7  ComShape 
			;8  PhaseShape 
			;9	MatShape
			;10	TkShape 
			;11	DateShape
			;12	QtaShape
			
			(setq Find nil)
			(if DataInfoShape
				(progn
					;(setq LstBlk (GetLstBlock "BlockShape01"))
					;(setq LstBlk (GetLstBlock NameBlockShape$))
					;(setq EnameBlock (GetEnameBlockByFence (LstEname->Ssget (list EnameShape)) NameBlockShape$ 10000))
					(setq EnameBlock (GetEnameBlockShapeById (cadr DataInfoShape)))
					(if EnameBlock
						(progn
							(setq Find T)
							;IDSHAPE			id contorno
							;ORDERSHAPE			commessa
							;PHASESHAPE			fase
							;MKSHAPE			marca
							;TKSHAPE			spessore
							;LENGTHSHAPE		lunghezza	
							;HEIGHTSHAPE		larghezza
							;MATSHAPE			materiale
							;LASTMODIFYSHAPE	ultima modifica
							;PERIMETERSHAPE		perimetro
							;WEIGTHSHAPE		peso
							;TYPESHAPE			tipo contorno
							;JOUSHAPE			percorrenza
							;COMPSHAPE			compensazione
							;TIMECUTSHAPE		tempo taglio
							;QTASHAPE			quantità

							(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
							(setq pmnl			(vlax-safearray->list mnl))
							(setq pmxl 			(vlax-safearray->list mxl))
							(setq WidthShape   	(rtos (abs (- (nth 0 pmxl) (nth 0 pmnl))) 2 1))
							(setq HeightShape  	(rtos (abs (- (nth 1 pmxl) (nth 1 pmnl))) 2 1))
							(setq SurfaceShape 	(rtos (/ (vla-get-area (vlax-ename->vla-object EnameShape)) 1000000.0) 2 2))
							(setq WeightShape  	(rtos (* (* 7.85 (atof SurfaceShape)) (atof (nth 10  DataInfoShape))) 2 2))							
							
							(cond 
								((= (nth 2 DataInfoShape) "0") (setq Percorrenza "Contorno Aperto"))
								((= (nth 2 DataInfoShape) "2") (setq Percorrenza "Antioraria"))
								((= (nth 2 DataInfoShape) "3") (setq Percorrenza "Oraria"))
							)
							
							(cond 
								((= (nth 4 DataInfoShape) "0") (setq Compensa "Nessuna"))
								((= (nth 4 DataInfoShape) "1") (setq Compensa "Automatica"))
								((= (nth 4 DataInfoShape) "2") (setq Compensa "Destra"))
								((= (nth 4 DataInfoShape) "3") (setq Compensa "Sinistra"))
							)
							
							(cond
								((= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
									(setq LenghtCut (vla-get-Circumference (vlax-ename->vla-object EnameShape)))
								)
								((= (cdr (assoc 0 (entget EnameShape))) "ELLIPSE")
									(setq LenghtCut (vlax-curve-getDistAtParam (vlax-ename->vla-object EnameShape)
													(vlax-curve-getendparam (vlax-ename->vla-object EnameShape))))
								)
								(t
									(setq LenghtCut (vla-get-length (vlax-ename->vla-object EnameShape)))
								)
							)
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "IDSHAPE" 			(nth 1  DataInfoShape))
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "ORDERSHAPE" 		(nth 7  DataInfoShape))
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "PHASESHAPE" 		(nth 8  DataInfoShape))
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "MKSHAPE"			(nth 3  DataInfoShape))
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "TKSHAPE"			(nth 10	DataInfoShape)) 
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "LENGTHSHAPE" 		WidthShape)
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "HEIGHTSHAPE" 		HeightShape)
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "MATSHAPE"			(nth 9	DataInfoShape))
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "LASTMODIFYSHAPE"	(Today))
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "PERIMETERSHAPE" 	(rtos  LenghtCut 2 2))
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "WEIGTHSHAPE"		WeightShape)
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "TYPESHAPE" 		"Esterno")
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "JOUSHAPE" 		Percorrenza)
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "COMPSHAPE"		Compensa)
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "TIMECUTSHAPE"		(nth 0 (nth 6 DataInfoShape)))
							(LM:vl-setattributevalue (vlax-ename->vla-object EnameBlock) "QTASHAPE"			(nth 12	DataInfoShape))
							(UpdateBarCode EnameBlock)
						)
					)
				)
			)
		)
	)
)			
;
;
;
(defun GetChoiseShape (/ xx SymulaChoiseShape include1 include2 DefaulChoise)
	
		(setq SymulaChoiseShape (vl-registry-read EasyCutRegistryPath$ "SymulaChoiseShape"))
		(setq DefaulChoise "11")
		
		(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
		(new_dialog "ChoiseTypeShape" xx "" (cond ( *ChoiseTypeShape* ) ( '(-1 -1) )))
		
		(if SymulaChoiseShape
			(if (/= SymulaChoiseShape "")
				(progn
					(set_tile "include1" (substr SymulaChoiseShape 1 1))
					(set_tile "include2" (substr SymulaChoiseShape 2 1))
				)
			)
			(progn
				(set_tile "include1" (substr DefaulChoise 1 1))
				(set_tile "include2" (substr DefaulChoise 2 1))
			)
		)
		
		(action_tile "accept"   (strcat "(setq include1 (get_tile \"include1\"))"
										"(setq include2 (get_tile \"include2\"))"
										"(setq *ChoiseTypeShape* (done_dialog)) (unload_dialog xx)"
								))
		(start_dialog)
		(vl-registry-write EasyCutRegistryPath$ "SymulaChoiseShape" (strcat include1 include2))
)
;
; (DummyChoise "Titolo" (list "A" "B" "C") 40 20)
;
(defun DummyChoise (Title LstChoise Width Height / GetChoise dcl dch des Num itm Rtn)

	(defun GetChoise (LstChoise / Num itm Rtn)
		(setq Num 1)
		(foreach itm LstChoise
			(setq Rtn (append Rtn (list (get_tile (strcat "var" (rtos Num 2 0))))))
			(setq Num (1+ Num))
		)
		Rtn
	)
	;
	;
	;
	(setq dcl (vl-filename-mktemp nil nil ".dcl"))
    (setq des (open dcl "w"))
	(write-line "DummyChoise:dialog" 													des)
	(write-line "{" 																	des)
	(write-line (strcat "label=\"" Title "\";")											des)
	(write-line ":boxed_radio_column" 													des)
	(write-line "{" 																	des)
	(if Width  (write-line (strcat "width="  (rtos Width  2 0) ";fixed_width=true;")  	des))
	(if Height (write-line (strcat "height=" (rtos Height 2 0) ";fixed_height=true;") 	des))
	(setq Num 1)
	(foreach itm LstChoise
		(write-line ":radio_button {" 													des)
		(write-line (strcat "label=\"" itm "\";") 										des)
		(write-line (strcat "key=\"var" (rtos Num 2 0) "\";") 							des)
		(write-line "}" 																des)
		(setq Num (1+ Num))
	)
	(write-line "}" 																	des)
	(write-line "ok_cancel;" 															des)
	(write-line "}" 																	des)
    (close des)

    (setq dch (load_dialog dcl))
    (new_dialog "DummyChoise" dch)
	(set_tile "var1" "1")
	(action_tile "accept" "(setq Rtn (GetChoise LstChoise) *DummyChoise* (done_dialog)) (unload_dialog dch)")
	(start_dialog)
	;(EasyCutViewer dcl)
	(vl-file-delete dcl)
	Rtn
)
