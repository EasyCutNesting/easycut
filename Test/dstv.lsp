(defun DstvReadFile (FileIn Expert / GetReal PurgeLine IsVoidString Stram riga
									IdOrder IdDrawing IdPhase IdIdentification IdQuality IdQuantity IdProfile IdCode IdLength IdHeigth
									IdThickness IdWeightmt IdSurfacemt IdName skeep
									OpenBo OpenAk OpenSi RigaSplit X Y D R H Tx LstHole LstAkShape LstIkShape LstIkShapeTotal LstStamp
									LstDiscrete Clock PerimeterShape conta TypShape CutShape Weigth fuzztable LstHead)
							

	
	 
		;(alert FileIn)
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
		(defun PurgeLine (String / conta Rtn F1 F2)
			(if String
				(progn
					(setq conta 1)
					(setq Rtn "")
					(setq F1 "0" F2 "0")
					
					(repeat (strlen String)
						(cond
							((= (substr String conta 1) "v") (setq Rtn (strcat Rtn " ")) (setq F1 "1"))
							((= (substr String conta 1) "u") (setq Rtn (strcat Rtn " ")) (setq F2 "1"))
							(t
								(setq Rtn (strcat Rtn (substr String conta 1)))
							)
						)
						(setq conta (1+ conta))
					)
					(setq Rtn (list (strcat F1 F2) Rtn))
				)
			)
			Rtn
		)
		;
		;
		(defun GetReal (String / conta Rtn)
		
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
		; Main
		;
		(setq fuzztable 2)
		
		(if FileIn
			(progn
				(setq Stream (open FileIn "r")) 
	
				(if (not Stream)
					(progn
						(alert (strcat "ERRORE!! apertura file -> " FileIn))
						(exit)
					)
					(setq riga (read-line Stream))
				)
				(if (not riga)
					(progn
						(alert (strcat "ERRORE!! file vuoto -> " FileIn))
						(close Stream)
						(exit)
					)
				)

				(read-line Stream)
				(setq IdOrder          (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))		;	C872 
				(setq IdPhase          (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))		;	100
				(setq IdDrawing        (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))		;	171-110
				(setq IdIdentification (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))		;	011124
				(setq IdQuality        (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))		;	S355J2
				(setq IdQuantity       (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))		;	1
				(setq IdProfile        (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))		;	PL1540*15
				(setq IdCode           (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))		;	B
				(if (= IdCode "B")
					(progn
						(setq IdLength    (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	1183.50
						(setq IdHeigth    (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	1540.00
						(setq skeep	      (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	0.00
						(setq skeep       (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	0.00
						(setq IdThickness (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	15.00	
						(setq skeep       (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	0.00
						(setq IdWeightmt  (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	64.25
						(setq IdSurfacemt (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	1.13
						(setq skeep       (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	0.00
						(setq skeep       (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	0.00
						(setq skeep       (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	0.00
						(setq skeep       (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	0.00
						(setq IdName	  (vl-string-right-trim " " (vl-string-left-trim " " (read-line Stream))))	;	PIATTO
						
						(if (= (- (atof IdThickness) (atoi IdThickness)) 0)
							(setq IdThickness (rtos (atoi IdThickness) 2 0))
						)

						(setq LstHead 	  (list IdOrder IdDrawing IdPhase IdIdentification
												(strcase IdQuality) IdQuantity IdProfile IdCode IdLength IdHeigth
												IdThickness IdWeightmt IdSurfacemt IdName))
						

					)	
				)

				(setq riga (read-line Stream))
				
				
				(while riga
					
					(setq riga (vl-string-right-trim " " (vl-string-left-trim " " riga)))
					
					(cond
						((= (substr riga 1 2) "BO") 		; fori
							(setq riga (read-line Stream))
							(setq OpenBo T)
							(setq OpenAk nil)
							(setq OpenIk nil)
							(setq OpenSi nil)
						)
						((= (substr riga 1 2) "AK") 		; controni esterni
							(setq riga (read-line Stream))
							(setq OpenAk T)
							(setq OpenIk nil)
							(setq OpenBo nil)
							(setq OpenSi nil)
						)
						((= (substr riga 1 2) "IK") 		; controni interni
							(if LstIkShape 
								(progn
									(setq LstIkShapeTotal (append LstIkShapeTotal (list LstIkShape)))
									;(princ "\nScarico su LstIkShapeTotal") (princ "    " )(princ LstIkShapeTotal)
								)
							)
							(setq LstIkShape nil)
							(setq riga (read-line Stream))
							(setq OpenIk T)
							(setq OpenAk nil)
							(setq OpenBo nil)
							(setq OpenSi nil)
						)
						((= (substr riga 1 2) "SI") 		; stamp
							(setq riga (read-line Stream))
							(setq OpenSi T)
							(setq OpenBo nil)
							(setq OpenAk nil)
							(setq OpenIk nil)
						)
						((= (substr riga 1 2) "EN") 		; end
							(setq OpenBo nil)
							(setq OpenAk nil)
							(setq OpenIk nil)
							(setq OpenSi nil)
						)
					)
				
					(if (and OpenBo (not (IsVoidString riga)))
						(progn
							(setq riga (PurgeLine riga))
							(setq RigaSplit (splitxt (nth 1 riga) " "))
							
							(cond 
								((= (length RigaSplit) 3)
									(if (and (= (nth 0 riga) "11") (/= (GetReal (nth 2 RigaSplit)) 0))
										(progn
											(setq X (GetReal (nth 0 RigaSplit))
												  Y (GetReal (nth 1 RigaSplit))
												  D (GetReal (nth 2 RigaSplit))
												  LstHole (append LstHole (list (list X Y D)))
											)
										)
										(alert "origine coordinata foro non implementata")
									)
								)
								
								(t
									(alert "formattazione fori non riconosciuta")
									
								)
							)
						)
					)
					(if (and OpenAk (not (IsVoidString riga)))
						(progn
							(setq riga (PurgeLine riga))
							(setq RigaSplit (splitxt (nth 1 riga) " "))
							
							(cond 
								((= (length RigaSplit) 3)
									(if (= (nth 0 riga) "11")
										(progn
											(setq X (GetReal (nth 0 RigaSplit))
												  Y (GetReal (nth 1 RigaSplit))
												  R (GetReal (nth 2 RigaSplit))
												  LstAkShape (append LstAkShape (list (list X Y R)))
											)
										)
										(alert "origine coordinata contorno non implementata")
									)
								)
								(t
									(if (= (nth 0 riga) "11")
										(progn
											(setq X (GetReal (nth 0 RigaSplit))
												  Y (GetReal (nth 1 RigaSplit))
												  R (GetReal (nth 2 RigaSplit))
												  LstAkShape (append LstAkShape (list (list X Y R)))
											)
										)
										(alert "origine coordinata contorno non implementata")
									)
									(alert "formattazione contorno non riconosciuta")
								)
							)
						)
					)
					(if (and OpenIk (not (IsVoidString riga)))
						(progn
							(setq riga (PurgeLine riga))
							(setq RigaSplit (splitxt (nth 1 riga) " "))
							
							(cond 
								((= (length RigaSplit) 3)
									(if (= (nth 0 riga) "11")
										(progn
											(setq X (GetReal (nth 0 RigaSplit))
												  Y (GetReal (nth 1 RigaSplit))
												  R (GetReal (nth 2 RigaSplit))
												  LstIkShape (append LstIkShape (list (list X Y R)))
											)
										)
										(alert "origine coordinata contorno non implementata")
									)
								)
								(t
									(if (= (nth 0 riga) "11")
										(progn
											(setq X (GetReal (nth 0 RigaSplit))
												  Y (GetReal (nth 1 RigaSplit))
												  R (GetReal (nth 2 RigaSplit))
												  LstIkShape (append LstIkShape (list (list X Y R)))
											)
										)
										(alert "origine coordinata contorno non implementata")
									)
									(alert "formattazione contorno non riconosciuta")
								)
							)
						)
					)
					
					(if (and OpenSi (not (IsVoidString riga)))
						(progn
							(setq RigaSplit (splitxt riga " "))
							(cond 
								((= (length RigaSplit) 6)
									(if (= (nth 0 RigaSplit) "v")
										(progn
											(setq X (GetReal (nth 1 RigaSplit))
												  Y (GetReal (nth 2 RigaSplit))
												  R (GetReal (nth 3 RigaSplit))
												  H (GetReal (nth 4 RigaSplit))
												  Tx (nth 5 RigaSplit)
												  LstStamp (append LstStamp (list (list X Y R H Tx)))
											)
										)
										(alert "origine coordinata stampa non implementata")
									)
								)
								(t
									(alert "formattazione stampa non riconosciuta")
								)
							)
						)
					)
					
					(setq riga (read-line Stream))
				)
				
			)
		)
		(close Stream)
		
		
		(if (and (= IdCode "B") (not LstAkShape)) ; piatto senza contorno (inteso come piatto)
			(progn				
				(setq X 0.0     		   Y 0.0 			    LstAkShape (append LstAkShape (list (list X Y 0.0)))
					  X (GetReal IdLength) Y 0.0                LstAkShape (append LstAkShape (list (list X Y 0.0)))
					  X (GetReal IdLength) Y (GetReal IdHeigth) LstAkShape (append LstAkShape (list (list X Y 0.0)))
					  X 0.0 			   Y (GetReal IdHeigth) LstAkShape (append LstAkShape (list (list X Y 0.0)))
					  X 0.0     		   Y 0.0 			    LstAkShape (append LstAkShape (list (list X Y 0.0)))
				)
			)
		)
		
		(if Expert
			(progn
				(setq LstDiscrete 	(DiscretizeDstvShape LstAkShape))
				;(setq Clock 		(cadr LstDiscrete))
				(setq Clock 		(LM:ListClockwise-p (car LstDiscrete)))
				
				;(setq PerimeterShape 	(LM:rtos  (caddr LstDiscrete) 2 fuzztable))
				(setq PerimeterShape 	(LM:rtos  (cadr LstDiscrete) 2 fuzztable))
				
				(setq LstDiscrete 		(car LstDiscrete))
				(if Clock (setq JouShape "3") (setq JouShape "2"))
				(setq TypShape "CE")
				(setq CutShape "1")
				(setq Weigth (rtos (abs (* (/ (area01 (mapcar 'car LstDiscrete) (mapcar 'cadr LstDiscrete)) 1000000.0) (atof IdThickness) 7.85)) 2 2))
				(setq LstHead (append LstHead (list JouShape TypShape CutShape PerimeterShape Weigth (today))))
			)
		)
		(if LstIkShape 
			(progn
				;(princ "\n Scarico finale")
				(setq LstIkShapeTotal (append LstIkShapeTotal (list LstIkShape)))
			)
		)
		(list LstHead LstAkShape LstHole LstStamp LstIkShapeTotal)
)	