;http://www.theswamp.org/index.php?topic=48889.msg540140#msg540140
;(setq TestBar	
;	'(	
;		("Job 20 items"
;			(3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0)
;			(5 2 1 2 4 2 1 3)
;			(13.0 13.5 14.0 14.5 15.0 15.5)
;		)
;		("job 20 items"
;			(7000.0 4000.0)
;			(5 2)
;			6000.0)
;		("Job 50 items"
;			(3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0)
;			(4 8 5 7 8 5 5 8)
;			15.0)
;		("Job 60 items" 
;			(3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0)
;			(6 12 6 5 15 6 4 6)
;			25.0)
;		("Job 60 items"
;			(5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0)
;			(7 12 15 7 4 6 8 1)
;			25.0)

;		("Job 125"							; id lavoro
;			(1000.0 1000.0 2000.0)			; lunghezza pezzi
;			(2 4 3)							; quantità pezzi
;			("P1028" "MK3025-5" "P10281")	; id pezzi
;			(0.0 0.0)						; margine iniziale / finale
;			(500 1000 2000)						; barre disponibili
;		)


;		("Job 123456"
;			(2350.0 2250.0 2200.0 2100.0 2050.0 2000.0 1950.0 1900.0 1850.0 1700.0 1650.0 1350.0 1300.0 1250.0 1200.0 1150.0 1100.0 1050.0)
;			(2 4 4 15 6 11 6 15 13 5 2 9 3 6 10 4 8 3)
;			("P1" "P2" "P3" "P4" "P5" "P6" "P7" "P8" "P9" "P10" "P11" "P12" "P13" "P14" "P15" "P16" "P17" "P18")	; id pezzi
;			(10.5 20.6 0.0)									; margine iniziale / finale / spessore di taglio
;			(6000.0 7000.0 8000.0))


;		("Job 200 items"
;			(21.0 23.0 24.0 25.0 26.0 27.0 28.0 29.0 31.0 33.0 34.0 35.0 37.0 38.0 41.0 42.0 44.0 47.0)
;			(10 14 10 7 14 4 13 9 5 10 13 10 11 15 12 15 15 13)
;			86.0)
;		("Job 200 items"
;			(22.0 26.0 27.0 28.0 29.0 30.0 31.0 32.0 34.0 36.0 37.0 38.0 39.0 46.0 47.0 48.0 52.0 53.0 54.0 56.0 58.0 60.0 63.0 64.0)
;			(6 3 14 12 9 15 11 10 11 13 4 3 6 14 7 3 14 9 7 3 5 14 4 3)
;			120.0)
;		("Job 400 items"
;			(22.0 23.0 24.0 26.0 27.0 28.0 29.0 30.0 31.0 36.0 39.0 41.0 42.0 48.0 49.0 50.0 51.0 54.0 121.0 55.0 56.0 59.0 60.0 66.0 67.0)
;			(12 8 27 15 25 7 10 22 5 16 19 21 26 16 12 26 20 25 9 17 22 14 17 35 9)
;			120.0)
;		("Job 400 items"
;			(21.0 22.0 24.0 25.0 27.0 29.0 30.0 31.0 32.0 33.0 34.0 35.0 38.0 39.0 42.0 44.0 45.0 46.0 47.0 48.0 49.0 50.0 51.0 52.0 53.0 54.0 55.0 56.0 57.0 59.0 60.0 61.0 63.0 65.0 66.0 67.0)
;			(13 15 7 5 9 9 3 15 18 17 4 17 20 9 4 19 9 12 15 3 20 14 15 6 4 7 5 19 19 6 3 7 20 5 10 17)
;			120.0)
;		("Job 600 items"
;			(21.0 22.0 23.0 24.0 25.0 27.0 28.0 29.0 30.0 31.0 33.0 35.0 36.0 39.0 40.0 41.0 42.0 43.0 44.0 45.0 46.0 47.0 48.0 50.0 51.0 54.0 56.0 57.0 58.0 61.0 62.0 63.0 64.0 65.0 66.0 67.0)
;			(13 19 24 20 23 24 15 5 24 16 12 24 16 4 20 24 6 14 21 20 24 2 11 26 23 25 8 16 10 14 6 19 18 11 27 16)
;			120.0)
;		("Job 600 items"
;			(44.5)
;			(40)
;			240.0)
;	)
;)
(defun Cut_Printres (Algo tit ti l d ls LstCut / a su w Rtn)

	;;                                                                            ;
	;; Statistic Output to the Text Screen.                    ;
	;;                                                                            ;
	(princ (strcat "\n" Algo " - Elapsed time: " (rtos (/ (- (car (_vl-times)) ti) 1000.) 2 4) " secs." ))
	(princ (strcat "\n" tit))
	(princ (strcat "\n D: " (vl-princ-to-string d)))
	(princ (strcat "\n L: " (vl-princ-to-string l)))
	(princ (strcat "\nLs: " (if (= 'INT (type ls)) (itoa ls) (rtos ls 2 3))))
	(princ "\n")
	;(foreach i LstCut
	;	(princ (strcat "\n" (vl-princ-to-string i)))
	;)
	(princ "\n")
	(princ (strcat "\nNb of Stock used    : " (itoa (setq su (apply '+ (mapcar 'car LstCut))))))
	(princ (strcat "\nNb of Parts Cut     : " (itoa (apply '+ (mapcar '(lambda (a) (* (car a) (length (cadr a)))) LstCut)))))
	(princ (strcat "\nTotal Length Wasted : " (if (= 'INT (type (setq w (apply '+ (mapcar '(lambda (a) (* (car a) (caddr a))) LstCut))))) (itoa w) (rtos w 2 2))))
	(princ (strcat "\nNb Patterns used    : " (itoa (length LstCut))))
	(princ (strcat "\nPercent Efficiency  : " (rtos (* 100 ( / (- (* su (float ls)) w) (* su ls))) 2 4) " %"))
	(princ "\n---------------------------------------------------------\n")

)
;
(defun ResolutionNestingBar (DataJob / 	FilterLenghtPart EfficiencyCut MultiSortRaking StatisticEfficientyBarCut AssocNameLength PrintList PerformTime
										BarMargStart BarMargEnd ThiCut DimScale Performance LstLengthPro itm ProBar
										Nel Pr PrF ti Job l d id Ls LsT Ranking LstDataOptimizedBar FileResolution Rtn LstRtn Out)

	
	;
	(defun FilterLenghtPart (Pr Ls BarMargStart BarMargEnd ThiCut / RemoveListNthFromList
																	tit l d id Ls Pos itm LstRmoveItm LstNotRmoveItm)
	
		(defun RemoveListNthFromList (Lst LstNth / LstPos Pos itm)
			(setq Pos 0)
			(foreach itm LstNth
				(setq LstPos (append LstPos (list (- itm Pos))))
				;(setq Pos (- itm Pos))
				(setq Pos (1+ Pos))
			)
			(foreach itm LstPos	(setq Lst (LM:RemoveNth itm Lst)))
			Lst
		)
		;
		(if Pr
			(progn
			
				;	"Job"						; 0 tit 	id lavoro
				;	(1000.0 1000.0 1000.0)		; 1 l 		lunghezza pezzi
				;	(2 4 3)						; 2 d 		quantità pezzi
				;	("A" "B" "C")				; 3 id 		pezzi
				;	(10.5 20.6 5.0)				; 4 		margine iniziale / finale / spesore taglio
				;	(1500.0 2000.0 3500.0)		; 5 		barre disponibili
			
				(setq tit (car pr) l (cadr pr) d (caddr pr) id (cadddr pr)) ;Ls (last pr))
				
				(setq Pos 0)
				(foreach itm l
					(if (> itm (- Ls BarMargStart BarMargEnd ThiCut)) 
							(setq LstRmoveItm    (append LstRmoveItm    (list Pos)))
							(setq LstNotRmoveItm (append LstNotRmoveItm (list Pos)))
					)
					(setq Pos (1+ Pos))
				)
				(list (list tit (RemoveListNthFromList l  LstRmoveItm)    		; <--- lista rimossa
								(RemoveListNthFromList d  LstRmoveItm) 
								(RemoveListNthFromList id LstRmoveItm) 
								Ls)
					  (list tit (RemoveListNthFromList l  LstNotRmoveItm) 		; <--- lista non rimossa
								(RemoveListNthFromList d  LstNotRmoveItm)
								(RemoveListNthFromList id LstNotRmoveItm) 
								Ls))
			)
		)
	)
	;
	(defun EfficiencyCut (l d Ls BarMargStart BarMargEnd ThiCut LstCut / itm TotLgCut StockUsed NPartsCut WasteLenght PatternsUsed Efficiency)

		(setq StockUsed 	(apply '+ (mapcar 'car (cadr LstCut))))
		(setq NPartsCut 	(apply '+ (mapcar '(lambda (a) (* (car a) (length (cadr a)))) (cadr LstCut))))
		;(setq WasteLenght	(apply '+ (mapcar '(lambda (a) (* (car a) (caddr a))) (cadr LstCut))))
		(setq PatternsUsed 	(length (cadr LstCut)))
		
		(setq TotLgCut 0.0)
		(foreach itm  (cadr LstCut)
			(setq TotLgCut (+ TotLgCut (* (car itm) (- (apply '+ (cadr itm)) (* ThiCut (length (cadr itm)))))))
		)
		(setq WasteLenght (- (* StockUsed (float Ls)) TotLgCut))
		
		(setq Efficiency  	(/ (- (* StockUsed (float Ls)) WasteLenght) (* StockUsed Ls)))
		
		(list 	(car LstCut)		; ---> Algo
				Efficiency 
				StockUsed 
				NPartsCut 
				WasteLenght 
				PatternsUsed 
				(last LstCut)		; ---> Elapsed Time
				Ls
		)
	)
	;
	(defun MultiSortRaking ( l / BuildLst)
		;(multisort '((80 10) (90 30) (100 1) (90 10)))
		;-> ((100 1) (90 10) (90 30) (80 10))
		;(mapcar
		;	(function
		;		(lambda ( x )(nth x l))
		;	)
		(foreach itm l
			(setq BuildLst (append BuildLst (list (list (nth 1 itm) (nth 5 itm)))))
		)
		;(terpri) (princ BuildLst) (terpri)
		(vl-sort-i BuildLst
			(function
				(lambda ( a b )
					(if (eq (car a) (car  b))
						(< (cadr a) (cadr b))
						(> (car a)  (car b))
					)
				)
			)
		)
		;)
	)
	;
	(defun StatisticEfficientyBarCut (Ranking LstOptimizedBar / itm Ls)

		;	0 Algo
		;	1 Efficiency 
		;	2 StockUsed 
		;	3 NPartsCut 
		;	4 WasteLenght 
		;	5 PatternsUsed 
		;	6 Elapsed Time
		;	7 Ls

		(if (and Ranking LstOptimizedBar)
			(progn
				(princ "\n+++ Raking ++++++++++++++++++++++++++++++")
				(foreach itm Ranking
					(setq Ls (nth 7 (nth itm LstOptimizedBar)))
					(princ (strcat "\nAlgo                   "	(nth 0 (nth itm LstOptimizedBar))))
					(princ (strcat "\nLength Bar Used    mm. "	(LM:rtos Ls    		  								  2 2)))
					(princ (strcat "\nStock Bar Used      n. "	(LM:rtos (nth 2 (nth itm LstOptimizedBar))    		  2 0)))
					(princ (strcat "\nNParts Cut          n. "	(LM:rtos (nth 3 (nth itm LstOptimizedBar))    		  2 0)))
					(princ (strcat "\nTotal Length Bar   mm. "	(LM:rtos (* Ls  (nth 2 (nth itm LstOptimizedBar)))    2 2)))       
					(princ (strcat "\nTotal Waste Lenght mm. "	(LM:rtos (nth 4 (nth itm LstOptimizedBar))  		  2 2)))
					(princ (strcat "\nPatterns Used       n. "	(LM:rtos (nth 5 (nth itm LstOptimizedBar)) 			  2 0)))
					(princ (strcat "\nEfficiency           % "	(LM:rtos (* (nth 1 (nth itm LstOptimizedBar)) 100.0 ) 2 2)))
					(princ (strcat "\nElapsed time      sec. "	(LM:rtos (/ (nth 6 (nth itm LstOptimizedBar)) 1000.0) 2 5)))
					(princ "\n++++++++++++++++++++++++++++++++++++++")
				)
			)
		)
	)
	;
	(defun AssocNameLength (LstLength Qta LstName / Pos SplitName Name NewLength LstNewLength LstAssocLengthName Rtn)

		(if (and LstLength Qta LstName)
			(progn
				(setq Pos 0)
				(repeat (length LstLength)
					
					;(setq SplitName (splitxt (nth Pos LstName) " "))
					;(cond
					;	;
					;	;$RappPart     0          1                2                   3               		4    		5   
					;	; 			"Marca" "Fase  Marca" "Commessa  Marca" "Commessa  Fase  Marca" "Marca Profilo" "Nessuna"
					;	;
					;	;"Order" "Phase" "Mark" "Profile"
					;	;   0       1      2        3 
					;	;
					;	((= $RappPart "0")
					;		(setq Name (nth 2 SplitName))
					;	)
					;	((= $RappPart "1")
					;		(setq Name (strcat (nth 1 SplitName) " " (nth 2 SplitName)))
					;	)
					;	((= $RappPart "2")
					;		(setq Name (strcat (nth 0 SplitName) " " (nth 2 SplitName)))
					;	)
					;	((= $RappPart "3")
					;		(setq Name (strcat (nth 0 SplitName) " " (nth 1 SplitName) " " (nth 2 SplitName)))
					;	)
					;	((= $RappPart "4")
					;		(setq Name (strcat (nth 2 SplitName) " " (nth 3 SplitName)))
					;	)
					;	((= $RappPart "5")
					;		(setq Name "-")
					;	)
					;)
					
					(setq Name (nth Pos LstName))
					(setq Rtn (append Rtn (list (list (nth Pos LstLength) Name (nth Pos Qta)))))
					
					(setq Pos (1+ Pos))
				)
			)
		)
		Rtn
	)
	;
	(defun PrintList (LstDataOptimizedBar / itm Rtn)

		(foreach itm LstDataOptimizedBar
			(cond
				((not itm)            (setq Rtn (append Rtn (list nil))))
				((= (type itm) 'INT)  (setq Rtn (append Rtn (list (LM:Rtos itm 2 0)))))
				((= (type itm) 'REAL) (setq Rtn (append Rtn (list (LM:Rtos itm 2 4)))))
				((= (type itm) 'STR)  (setq Rtn (append Rtn (list itm))))
				((= (type itm) 'LIST)
					(setq Rtn (append Rtn (list (PrintList itm))))
				)
			)
		)
		Rtn
	)
	;
	(defun PerformTime (l d Lb / Pos LstLg Loop TotLgParts LstPartVar Rtn)
		;
		; l   list length parts
		; d   list parts per length
		; Lb  length bar
		;
		(if (and l d Lb)
			(progn
				(setq Pos 0)
				(repeat (length d)
					(repeat (nth Pos d)
						(setq LstLg (append LstLg (list (nth Pos l))))
					)
					(setq Pos (1+ Pos))
				)
				(setq LstLg (mapcar '(lambda (x) (nth x LstLg)) (vl-sort-i LstLg '<)))

				(setq Loop T)
				(setq TotLgParts 0)
				(setq Pos 0)
				
				(while Loop

					(if (<= (+ TotLgParts (nth Pos LstLg)) Lb)
						(progn
							(setq TotLgParts (+ TotLgParts (nth Pos LstLg)))
							(setq LstPartVar (append LstPartVar (list (nth Pos LstLg))))
							(setq Pos (1+ Pos))
						)
						(progn
							(setq Loop nil)
						)
					)

					(if (= Pos (length LstLg))
						(setq Loop nil)
					)
				)

				; *******************************************************************
				(cond 
					((and (>= (length LstPartVar) 1) (< (length LstPartVar) 5))
						(setq Rtn (list 3 (length LstPartVar)))
					)
					((and (>= (length LstPartVar) 5) (< (length LstPartVar) 7))
						(setq Rtn (list 2 (length LstPartVar)))
					)
					(t
						(setq Rtn (list 1 (length LstPartVar)))
					)
				)
				; *******************************************************************
				
				(princ "\n----------> ") (princ Rtn) (princ " <----------\n")
			)
		)
		Rtn
	)
	;
	;Main +++++++
	;
	(foreach Pr DataJob
	
		(foreach itm (last Pr)
			(setq LstLengthPro (append LstLengthPro (list (car itm))))
		)
		
		(setq DimScale      (/ (apply 'max LstLengthPro) 207.0)) ; A4 Landscape (297 - 90)
		(setq BarMargStart 	(nth 0 (nth 4 Pr)))
		(setq BarMargEnd   	(nth 1 (nth 4 Pr)))
		(setq ThiCut   		(nth 2 (nth 4 Pr)))
		(setq Performance  	(nth 3 (nth 4 Pr)))
		(setq Job   		(car Pr))

		
		(foreach Ls (last Pr)
		
			(setq ProBar (cadr Ls)) 
			(setq Ls 	 (car Ls))  
			
			(setq PrF   (FilterLenghtPart Pr Ls BarMargStart BarMargEnd ThiCut))
			
			(if (cadr  (car PrF))
				(progn
					(setq 	l   	(cadr   (car PrF))
							d   	(caddr  (car PrF))
							id  	(cadddr (car PrF))
							LsT (- Ls BarMargStart BarMargEnd)
							Rtn nil
					)
					;Add thickness cut
					(setq l (mapcar '(lambda (x) 
										(+ ThiCut x) 
									) 
							l)) 


					(setq id (AssocNameLength l d id))
					;(setq l  (car Rtn))
					;(setq id (cadr Rtn))
					
					(setq Rtn nil)
					
					
					(if (= Performance -1) ; Auto
						(setq Performance (car (PerformTime l d LsT)))
						(progn
							(setq Nel (cadr (PerformTime l d LsT)))
							(if (and (= Performance 3) (>= Nel 7)) ; declass performance
								(setq Performance 2)
							)
						)
					)
										
					(cond 
						((= Performance 1)
						   ;(setq ti (car (_vl-times)))	(setq Rtn (append Rtn (list (list "Pinpack-Cut" (Pinpack-Cut l d lsT) (- (car (_vl-times)) ti))))) 
							(setq ti (car (_vl-times))) (setq Rtn (append Rtn (list (list "Adl-Cut" 	(MyNstBar l d LsT)    (- (car (_vl-times)) ti))))) 
						   ;(setq ti (car (_vl-times))) (setq Rtn (append Rtn (list (list "Ld-Csp"      (Ld-Csp  l d LsT)     (- (car (_vl-times)) ti))))) 
						   ;(setq ti (car (_vl-times)))	(setq Rtn (append Rtn (list (list "Roy-Cut" 	(Roy_Cut l d LsT)  	  (- (car (_vl-times)) ti)))))
						   ;(setq ti (car (_vl-times))) (setq Rtn (append Rtn (list (list "EP-Cut" 		(EP-Cut l d LsT) 	  (- (car (_vl-times)) ti)))))
				
							(setq LstRtn (list 	(EfficiencyCut l d Ls BarMargStart BarMargEnd ThiCut (nth 0 Rtn))))
						)
						((= Performance 2)
						   ;(setq ti (car (_vl-times)))	(setq Rtn (append Rtn (list (list "Pinpack-Cut" (Pinpack-Cut l d lsT) (- (car (_vl-times)) ti))))) 
							(setq ti (car (_vl-times))) (setq Rtn (append Rtn (list (list "Adl-Cut" 	(MyNstBar l d LsT)    (- (car (_vl-times)) ti))))) 
							(setq ti (car (_vl-times))) (setq Rtn (append Rtn (list (list "Ld-Csp"      (Ld-Csp  l d LsT)     (- (car (_vl-times)) ti))))) 
						   ;(setq ti (car (_vl-times)))	(setq Rtn (append Rtn (list (list "Roy-Cut" 	(Roy_Cut l d LsT)  	  (- (car (_vl-times)) ti)))))
						   ;(setq ti (car (_vl-times))) (setq Rtn (append Rtn (list (list "EP-Cut" 		(EP-Cut l d LsT) 	  (- (car (_vl-times)) ti)))))
				
							(setq LstRtn (list 	(EfficiencyCut l d Ls BarMargStart BarMargEnd ThiCut (nth 0 Rtn)) 
												(EfficiencyCut l d Ls BarMargStart BarMargEnd ThiCut (nth 1 Rtn))))
						)
						((= Performance 3)
						   ;(setq ti (car (_vl-times)))	(setq Rtn (append Rtn (list (list "Pinpack-Cut" (Pinpack-Cut l d lsT) (- (car (_vl-times)) ti))))) 
							(setq ti (car (_vl-times))) (setq Rtn (append Rtn (list (list "Adl-Cut" 	(MyNstBar l d LsT)    (- (car (_vl-times)) ti))))) 
							(setq ti (car (_vl-times))) (setq Rtn (append Rtn (list (list "Ld-Csp"      (Ld-Csp  l d LsT)     (- (car (_vl-times)) ti))))) 
							(setq ti (car (_vl-times)))	(setq Rtn (append Rtn (list (list "Roy-Cut" 	(Roy_Cut l d LsT)  	  (- (car (_vl-times)) ti)))))
						   ;(setq ti (car (_vl-times))) (setq Rtn (append Rtn (list (list "EP-Cut" 		(EP-Cut l d LsT) 	  (- (car (_vl-times)) ti)))))
				
							(setq LstRtn (list 	(EfficiencyCut l d Ls BarMargStart BarMargEnd ThiCut (nth 0 Rtn)) 
												(EfficiencyCut l d Ls BarMargStart BarMargEnd ThiCut (nth 1 Rtn))
												(EfficiencyCut l d Ls BarMargStart BarMargEnd ThiCut (nth 2 Rtn))))
						)
					)	
					
					(setq Ranking (MultiSortRaking LstRtn))
					(StatisticEfficientyBarCut Ranking LstRtn)
					(setq LstDataOptimizedBar (nth (car Ranking) Rtn))
				)
			)
			(setq Out (append Out  (list (PrintList (list 	Job
															LstDataOptimizedBar
															Id
															Ls
															ProBar
															BarMargStart BarMargEnd ThiCut
															(cadr PrF)
															DimScale))
			)))
			
		)
	)
	Out
)
;
(defun GraphicNestingBar (LstDataGraphics PointInsert / ReadList 
														Pos LstRead itm LstEname Box)
	
	;
	(defun ReadList (LstDataOptimizedBar / itm Rtn)

		(foreach itm LstDataOptimizedBar
			(cond
				((not itm)            		 (setq Rtn (append Rtn (list nil))))
				((= (type itm) 'LIST)
					(setq Rtn (append Rtn (list (ReadList itm))))
				)
				((if (vl-string-search " " itm) (setq Rtn (append Rtn (list itm)))))
				((= (type (read itm)) 'INT)  (setq Rtn (append Rtn (list (read itm)))))
				((= (type (read itm)) 'REAL) (setq Rtn (append Rtn (list (read itm)))))
				((= (type (read itm)) 'SYM)  (setq Rtn (append Rtn (list itm))))
			)
		)
		Rtn
	)
	;
	(setq Pos 1)
	(foreach itm LstDataGraphics
		
		(setq LstRead (ReadList itm))
		(Open_Block_Entity)
			(OuputGraphicNestingBar PointInsert										; PtInsert
									(strcat (nth 0 LstRead) "_" (LM:rtos Pos 2 0))	; IdJob
									(nth 1 LstRead)									; LstDataOptimizedBar
									(nth 2 LstRead)									; Id
									(nth 3 LstRead)									; Ls
									(nth 4 LstRead)									; Profile bar
									(nth 5 LstRead)									; BarMargStart
									(nth 6 LstRead)									; BarMargend
									(nth 7 LstRead)									; ThiCut
									(nth 8 LstRead)									; LstNotOptimezedBar
									(nth 9 LstRead))								; DimScale
									
		(setq LstEname (Close_Block_Entity))									
		(setq Box (BoundingBoxLstEname  LstEname))
		(setq PointInsert (list (+ (car (caddr Box)) (* 10.0 (nth 9 LstRead))) (cadr PointInsert)))
		(Open_Block_Entity)
			(TableNestingBar 		PointInsert										; PtInsert
									(strcat (nth 0 LstRead) "_" (LM:rtos Pos 2 0))	; IdJob
									(nth 1 LstRead)									; LstDataOptimizedBar
									(nth 2 LstRead)									; Id
									(nth 3 LstRead)									; Ls
									(nth 4 LstRead)									; ProfileBar
									(nth 5 LstRead)									; BarMargStart
									(nth 7 LstRead)									; ThiCut
									(nth 9 LstRead))								; DimScale
		
		(setq LstEname (Close_Block_Entity))									
		(setq Box (BoundingBoxLstEname  LstEname))
		(setq PointInsert (list (+ (car (caddr Box)) (* 50.0 (nth 9 LstRead))) (cadr PointInsert)))		
		(setq Pos (1+ Pos))
	)
)
;
(defun OuputGraphicNestingBar (PtInsert IdJob LstDataOptimizedBar Id Ls ProfileBar BarMargStart BarMargEnd ThiCut
										LstNotOptimezedBar DimScale / 
										MakeBar MakePart MakeTextBar MakeTextPart MakeDimContinue MakeLogo MakeHeadBar01 MakeHeadBar02 MakeFooterBar MakeBom GetNameByLength
										HA4 LA4 OffsetDim1 OffsetDim2 InterPage
										HBar HTextInfo HTextDim HTextPart TextPart StepYBar 
										ClrBoxPart XOffsetBar DimStyleName TextStyleName NumBar Page HTextPage
										ClrBar PtHead PtBar PtTextBar PtBom PtPart Part Bar LgPart HPart IdX IdY LstDim Pos Rtn)
	;
	(defun MakeBar (PtBar LBar HBar ClrBar)
		(ChangeColor (MakeRectangle PtBar LBar HBar) (nth 0 ClrBar) (nth 1 ClrBar))
	)
	;
	(defun MakePart (PtPart LPart HPart ClrPart ClrBoxPart)
		(ChangeColor (LM:MakeSolid 	PtPart
									(list (+ (car PtPart) LPart) (cadr PtPart))
									(list (car PtPart) (+ (cadr PtPart) HPart))
									(list (+ (car PtPart) LPart) (+ (cadr PtPart) HPart)))
								    (nth 0 ClrPart) (nth 1 ClrPart))
		(vla-put-Color (vlax-ename->vla-object (MakeRectangle PtPart LPart HPart)) ClrBoxPart)
	)
	;
	(defun MakeTextPart (PtPart LgPart HPart TextPart HTextPart DimScale / EntMkxTxt
																		   Point WdTextFactor EnameText InfoEname Lcar)
		
		(defun EntMkxTxt (Point TextPart HTextPart WdTextFactor Rotation Position1 Position2)
		
			(if (and Point TextPart HTextPart WdTextFactor Rotation Position1 Position2)
				(entmakex (list (cons 000 "TEXT")
								(cons 100 "AcDbEntity")
								(cons 100 "AcDbText")
								(cons 010 Point)	
								(cons 040 HTextPart)
								(cons 001 TextPart)  
								(cons 050 Rotation)  
								(cons 041 WdTextFactor)  
								(cons 051 0.0)  
								(cons 007 $StyleEasyCut)
								(cons 071 0)  
								(cons 072 Position1) ; 
								(cons 011 (list (+ (nth 0 Point) 1) (nth 1 Point)))	
								(cons 073 Position2)
						  )
				)
			)
		)
		;
		; Main
		;
		(if (and PtPart LgPart HPart TextPart HTextPart DimScale)
			(progn
				;(setq Point (list (+ (car PtPart) (/ LgPart 2.0)) (+ (cadr PtPart) HPart (/ (* HTextPart DimScale) 2.0))))
				(setq Point (list (+ (car PtPart) (/ LgPart 2.0)) (+ (cadr PtPart) HPart (/ HTextPart 2.0))))
				(setq WdTextFactor 0.75)
				;(setq HTextPart (* HTextPart DimScale))
				(if (setq EnameText (EntMkxTxt Point TextPart HTextPart WdTextFactor 0.0 1 0))
					(if EnameText
						(progn
							(setq InfoEname (GeoText EnameText))
							(DeleteEntity (list EnameText))
							(setq Lcar (/ (car InfoEname) 0.8)) 
							(cond
								((<= Lcar LgPart)
									(EntMkxTxt Point TextPart HTextPart WdTextFactor 0.0 1 0)
								)
								(t
									(if (>= (/ LgPart Lcar) 0.75)
										(progn
											;(setq WdTextFactor (/ LgPart Lcar))
											(setq WdTextFactor 0.75)
											(EntMkxTxt Point TextPart HTextPart WdTextFactor 0.0 1 0)
										)
										(progn
											(setq WdTextFactor 0.75)
											(EntMkxTxt Point TextPart HTextPart WdTextFactor (/ Pi 2.0) 0 2)
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
	;
	(defun MakeTextBar (PtText HText DataBar Ls ProfileBar 
						BarMargStart ThiCut CodeBar DimScale /  ResizeBlock PrincToString
																ClrBom MarginBox HBarCode MaxHBarCode MaxWBarCode 
																EnameBlockBarcode
																XCodeBar YCodeBar PosBarCode DimBarCode
																TotalThiCut BarMargEnd Waste
																InfoBar Str Box Rtn)
		;0  PtText 		 (200007.0 976.579) 
		;1	Htext 		 100 
		;2	DataBar      (1 (200.0 200.0) 5575.0) 
		;3	Ls 			 12001.0 
		;4	ProfileBar	"L80*8"
		;5	BarMargStart 10.0 
		;7	ThiCut 		 0.0
		;8	CodeBar 	 "6000_1" 
		;9	DimScale	 57.9758

		;
		(defun ResizeBlock (EnameBlock LMax WMax / ScaleX ScaleY BoxEname)
		
			(if (and EnameBlock LMax WMax)
				(progn
					(setq ScaleX 1.0)
					(setq ScaleY 1.0)

					(setq BoxEname	(BoundingBoxLstEname (list EnameBlock)))
					;(if (> (distance (car BoxEname) (cadr BoxEname)) LMax)
						(setq ScaleX (/ LMax (distance (car BoxEname) (cadr BoxEname))))
					;)
					;(if (> (distance (cadr BoxEname) (caddr BoxEname)) WMax)
						(setq ScaleY (/ WMax (distance (cadr BoxEname) (caddr BoxEname))))
					;)
					(min ScaleX ScaleY)
				)
			)
		)
		;
		(defun PrincToString (Val / Rtn)
		
			(if Val
				(cond
					((= (type Val) 'STR)
						(setq Rtn Val)
					)
					((= (type Val) 'INT)
						(setq Rtn (vl-princ-to-string Val))
					)
					((= (type Val) 'REAL)
						(if (= (- Val (fix Val)) 0)
							(setq Rtn (LM:rtos Val 2 0))
							(setq Rtn (vl-princ-to-string Val))
						)
					)
				)
			)
		)

		;
		; Main
		;
		(setq ClrBom 5)
		(setq MarginBox 3.0)
		(setq HBarCode	12.0)
		(setq MaxHBarCode 	(*  12.0 DimScale))
		(setq MaxWBarCode 	(*  60.0 DimScale))
		(setq XCodeBar 		(*   5.0 DimScale))
		(setq YCodeBar 		(*   4.5 DimScale))
		
		(if (and PtText HText DataBar Ls ProfileBar BarMargStart ThiCut CodeBar DimScale)
			(progn
				;(setq Waste (- Ls (+ BarMargStart (apply '+ (cadr DataBar)) (* (- (length (cadr DataBar)) 1.0) ThiCut))))
				(setq TotalThiCut 0.0) (repeat (- (length (cadr DataBar)) 1) (setq TotalThiCut (+ TotalThiCut ThiCut)))
				(setq BarMargEnd (- Ls (- (+ BarMargStart (apply '+ (cadr DataBar))) ThiCut)))
				(setq Waste 	 (+ BarMargStart BarMargEnd TotalThiCut))
				
				(if (= (car DataBar) 1) 
					(setq InfoBar (strcat "n. " (LM:Rtos (car DataBar) 2 0) " Barra " (PrincToString ProfileBar)))
					(setq InfoBar (strcat "n. " (LM:Rtos (car DataBar) 2 0) " Barre " (PrincToString ProfileBar)))
				)
				(setq Str (strcat 	"{\\Fromans|c0;\\W0.8;"
									"\\C2;"								InfoBar
									"\n\\C1;Sfrido barra\t\\C7;"	   (LM:rtos Waste 2 1) " " (LM:Rtos (* (- 1.0 (/ Waste Ls)) 100.0) 2 2) "%"
						   )
                )			
				(setq Rtn 	(entmakex	(list	(cons 0 "MTEXT")                              
											(cons 100 "AcDbEntity")
											(cons 100 "AcDbMText")
											(cons 1  Str)
											(cons 10 (list (+ (car PtText) (* MarginBox DimScale 2.0)) (- (cadr PtText) (* MarginBox DimScale 2.5))))
											(cons 40 HText)
											(cons 50 0.0)
											(cons 62 71)
											(cons 90 3)
											(cons 63 9)
											(cons 210 (list 0.0 0.0 1.0))
											(cons 11 (list 1.0 0.0 0.0))
										)
							)			
				)
				;
				(BrCode128 CodeBar 		(strcat "BARCODE128_" CodeBar)  (list 0.0 0.0) HBarCode (* HBarCode 0.2))
				(setq EnameBlockBarcode	(entlast))
				(vla-ScaleEntity 	    (vlax-ename->vla-object EnameBlockBarcode) (vlax-3d-point (list 0.0 0.0)) (ResizeBlock EnameBlockBarcode MaxWBarCode MaxHBarCode))
				(setq PosBarCode 	  	(list (+ (car PtText) XCodeBar) (+ (cadr PtText) YCodeBar)))
				(setq DimBarCode	  	(BoundingBoxLstEname (list EnameBlockBarcode)))
				(vla-move 				(vlax-ename->vla-object EnameBlockBarcode)  (vlax-3d-point (nth 3 DimBarCode)) (vlax-3d-point PosBarCode))
				(PurgeBlock 		   	(strcat "BARCODE128_" CodeBar))

				
				(setq Box (BoundingBoxLstEname  (list Rtn EnameBlockBarcode)))
				;(setq Box (BoundingBoxLstEname  (list Rtn)))
				(vla-put-Color 	(vlax-ename->vla-object
											(MakeRectangle (list (- (car (car Box))  (* DimScale MarginBox))
																 (- (cadr (car Box)) (* DimScale MarginBox)))
																 (+ (distance (car Box) (cadr Box))   (* MarginBox 2.0 DimScale)) 
																 (+ (distance (car Box) (cadddr Box)) (* MarginBox 2.0 DimScale)))
								)
								ClrBom)
			)
		)
		Rtn
	)
	;
	(defun MakeDimContinue (LstPt Ppos DimStyleName DimScale / RepositionTextDimContinue
															   EnameDim)
	
		(defun RepositionTextDimContinue (LstEnameDim / pos_pre pos_att MargHText itm 
														ObjDimension Dimension ScaleDim LengthText)
			(setq pos_pre acAbove)
			(setq MargHText 2.5)
			(foreach itm LstEnameDim
			
				(setq ObjDimension (vlax-ename->vla-object itm))
				(setq Dimension    (vla-get-measurement    ObjDimension)) 
				(setq ScaleDim     (vla-get-scalefactor    ObjDimension))
				(setq LengthText   (+ (GetTextLengthDim itm) (* 2.0 MargHText ScaleDim)))
				
				(if (> LengthText Dimension)
					(if (= pos_pre acAbove)
						(if (null acUnder)
							(setq pos_att "\\X")
							(setq pos_att acUnder)
						)
						(setq pos_att acAbove)
					)
					(setq pos_att acAbove)
				)
				(ChangePosText itm pos_att)
				(setq pos_pre pos_att)
			)
		)
		;
		;Main
		;
		(setq Rtn (QuotaContinua LstPt 4 Ppos))
		(foreach itm (cadr Rtn) 
			(vla-put-StyleName   (vlax-ename->vla-object itm) DimStyleName) 
			(vla-put-ScaleFactor (vlax-ename->vla-object itm) DimScale)
		)
		(RepositionTextDimContinue (cadr Rtn))
	)
	;
	(defun MakeLogo (PtLogo StrBarCode DimScale / ResizeBlock
													  XCodeBar YCodeBar XLogo YLogo MaxHBarCode MaxHLogo MaxWBarCode MaxWLogo
													  EnameBlockLogo EnameBlockBarcode PosLogo PosBarCode DimLogo DimBarCode HBarCode)

		

		(defun ResizeBlock (EnameBlock LMax WMax / ScaleX ScaleY BoxEname)
		
			(if (and EnameBlock LMax WMax)
				(progn
					(setq ScaleX 1.0)
					(setq ScaleY 1.0)

					(setq BoxEname	(BoundingBoxLstEname (list EnameBlock)))
					;(if (> (distance (car BoxEname) (cadr BoxEname)) LMax)
						(setq ScaleX (/ LMax (distance (car BoxEname) (cadr BoxEname))))
					;)
					;(if (> (distance (cadr BoxEname) (caddr BoxEname)) WMax)
						(setq ScaleY (/ WMax (distance (cadr BoxEname) (caddr BoxEname))))
					;)
					(min ScaleX ScaleY)
				)
			)
		)
		;
		; Main
		;
		(if (and PtLogo StrBarCode DimScale)
			(progn
				(setq XCodeBar 		(* 160.0 DimScale))
				(setq YCodeBar 		(*  -5.0 DimScale))
				(setq XLogo 		(* 180.0 DimScale))
				(setq YLogo 		(*  -20.0 DimScale))
				(setq MaxHBarCode 	(*  15.0 DimScale))
				(setq MaxHLogo 	  	(*  15.0 DimScale))
				(setq MaxWBarCode 	(* 100.0 DimScale))
				(setq MaxWLogo 		(*  60.0 DimScale))
				(setq HBarCode		20.0)
				
				(setq EnameBlockLogo  (vlax-vla-object->ename (InsertBlock (strcat LibPathEasyCut$ FileBlockLogo$) (list 0.0 0.0) nil)))
				(vla-ScaleEntity (vlax-ename->vla-object EnameBlockLogo) (vlax-3d-point (list 0.0 0.0)) (ResizeBlock EnameBlockLogo MaxWLogo MaxHLogo))
				(setq PosLogo 		  (list (+ (car PtLogo) XLogo) (+ (cadr PtLogo) YLogo)))
				(setq DimLogo	  	  (BoundingBoxLstEname (list EnameBlockLogo)))
				(vla-move (vlax-ename->vla-object EnameBlockLogo)  (vlax-3d-point (nth 3 DimLogo)) (vlax-3d-point PosLogo))

				
				(BrCode128 StrBarCode 	(strcat "BARCODE128_" StrBarCode)  (list 0.0 0.0) HBarCode (* HBarCode 0.2))
				(setq EnameBlockBarcode	(entlast))
				(vla-ScaleEntity (vlax-ename->vla-object EnameBlockBarcode) (vlax-3d-point (list 0.0 0.0)) (ResizeBlock EnameBlockBarcode MaxWBarCode MaxHBarCode))
				(setq PosBarCode 	  	(list (+ (car PtLogo) XCodeBar) (+ (cadr PtLogo) YCodeBar)))
				(setq DimBarCode	  	(BoundingBoxLstEname (list EnameBlockBarcode)))
				(vla-move (vlax-ename->vla-object EnameBlockBarcode)  (vlax-3d-point (nth 3 DimBarCode)) (vlax-3d-point PosBarCode))
				(PurgeBlock 		  (strcat "BARCODE128_" StrBarCode))
			)
		)
	)	
	;
	(defun MakeHeadBar01 (PtHead IdJob LstDataOptimizedBar Ls ProfileBar BarMargStart 
						  BarMargEnd ThiCut HText DimScale / PrincToString
															 MarginBox ClrBom Algo LstCut Time StockUsed PartsCut Bar TotalThiCut BarMargEnd_
															 TotalLenghtWasted 
															 TotalLenghtBar PatternsUsed Efficiency Box Str Rtn)

		;
		;0  PtHead 		 (200007.0 976.579) 
		;1	IdJob 		 "2022_12_05-16.28.23_1" 
		;2	LstDataOptimizedBar ("Ld-Csp" ((1 (2355.0 2355.0 2355.0 2355.0 2355.0) 16.0) (1 (2355.0) 9436.0)) 31) 
		;3	Ls 			 12001.0 
		;4	ProfileBar	"L80*8"
		;5	BarMargStart 200.0 
		;6	BarMargEnd 	 10.0 
		;7	ThiCut 		 5.0 
		;8	HText 		 173.927 
		;9	DimScale	 57.9758
		;
		;
		(defun PrincToString (Val / Rtn)
		
			(if Val
				(cond
					((= (type Val) 'STR)
						(setq Rtn Val)
					)
					((= (type Val) 'INT)
						(setq Rtn (vl-princ-to-string Val))
					)
					((= (type Val) 'REAL)
						(if (= (- Val (fix Val)) 0)
							(setq Rtn (LM:rtos Val 2 0))
							(setq Rtn (vl-princ-to-string Val))
						)
					)
				)
			)
		)
		
		(setq MarginBox 3.0)
		(setq ClrBom 5)

		(if (and PtHead IdJob LstDataOptimizedBar Ls HText BarMargStart BarMargEnd ThiCut HText DimScale)
			(progn
				(setq Algo 				(car LstDataOptimizedBar))
				(setq LstCut 			(cadr LstDataOptimizedBar))
				(setq Time 				(/ (caddr LstDataOptimizedBar) 1000.))
				(setq StockUsed 		(apply '+ (mapcar 'car LstCut)))
				(setq PartsCut 			(apply '+ (mapcar '(lambda (a) (* (car a) (length (cadr a)))) LstCut)))
				; ((1 (2355.0 2355.0 2355.0 2355.0 2355.0) 16.0) (1 (2355.0) 9436.0))
				(setq TotalLenghtWasted 0.0)
				(foreach Bar (cadr LstDataOptimizedBar)

					(setq TotalThiCut 0.0) (repeat (- (length (cadr Bar)) 1) (setq TotalThiCut (+ TotalThiCut ThiCut)))
					(setq BarMargEnd_ (- Ls (- (+ BarMargStart (apply '+ (cadr Bar))) ThiCut)))
					(setq TotalLenghtWasted (+ TotalLenghtWasted (+ BarMargStart BarMargEnd_ TotalThiCut)))
					
				)
				
				
				(setq TotalLenghtBar  	(* StockUsed Ls))
				(setq PatternsUsed  	(length LstCut))
				(setq Efficiency    	(* 100 ( / (- (* StockUsed (float Ls)) TotalLenghtWasted) (* StockUsed Ls))))
				
				
				
				(setq Str (strcat 	"{\\Fromans|c0;\\W0.8;"
									"\\C2;Nesting\t\t\t\t\\C7;"						IdJob
									"\n\\C3;Algoritmo\t\t\t\t\\C7;"					Algo
									"\n\\C1;Profilo barra\t\t\t\t\\C7;"	 			(PrincToString ProfileBar)
									"\n\\C1;Lunghezza barra\t\t\t\\C7;"	 			(LM:rtos Ls 2 1)
									"\n\\C1;Quantita' barre usate\t\t\\C7;"	 		(LM:rtos StockUsed 2 0)
									"\n\\C1;Quantita' parti tagliate\t\t\\C7;" 		(LM:rtos PartsCut 2 0)
									"\n\\C1;Lunghezza totale barre\t\t\\C7;" 		(LM:rtos TotalLenghtBar 2 2)
									"\n\\C1;Lunghezza totale sfrido\t\t\\C7;" 		(LM:rtos (lm:roundm TotalLenghtWasted 0.5) 2 2)
									"\n\\C1;Quantita' modelli barre\t\t\\C7;" 		(LM:rtos PatternsUsed 2 0)
									"\n\\C1;Margine iniziale barra\t\t\\C7;" 		(LM:rtos BarMargStart 2 2)
									"\n\\C1;Spessore di taglio\t\t\t\\C7;" 			(LM:rtos ThiCut 2 2)
									"\n\\C1;Margine minimo finale barra\t\\C7;" 	(LM:rtos BarMargEnd 2 2)
									"\n\\C1;Efficienza\t\t\t\t\\C7;" 				(LM:rtos Efficiency 2 2) " %"
									"\n\\C1;Tempo elaborazione\t\t\\C7;" 			(LM:rtos Time 2 2) " sec."
							)
                )
				(setq Rtn (entmakex	(list	(cons 0 "MTEXT")                              
											(cons 100 "AcDbEntity")
											(cons 100 "AcDbMText")
											(cons 1  Str)
											;(cons 10 PtHead)
											(cons 10 (list 	(+ (car  PtHead) (* DimScale (* MarginBox 2.0))) 
															(- (cadr PtHead) (* DimScale (* MarginBox 3.0)))))
											(cons 40 HText)
											(cons 50 0.0)
											(cons 62 71)
											;(cons 71 Giustificato)
											(cons 90 3)
											(cons 63 9)
											;(cons 421 13158600)
											;(cons 441 9434636)
											(cons 210 (list 0.0 0.0 1.0))
											(cons 11 (list 1.0 0.0 0.0))
									)
						)
				)
				(setq Box (BoundingBoxLstEname  (list Rtn)))
				
				(vla-put-Color (vlax-ename->vla-object 
									(MakeRectangle (list (- (car (car Box))  (* DimScale MarginBox))
														 (- (cadr (car Box)) (* DimScale MarginBox)))
														 (+ (distance (car Box) (cadr Box))   (* MarginBox 2.0 DimScale)) 
														 (+ (distance (car Box) (cadddr Box)) (* MarginBox 2.0 DimScale)))
							   )
							   ClrBom
				)
			)
		)
	)
	;
	(defun MakeHeadBar02 (PtHead IdJob Ls BarMargStart BarMargEnd HText DimScale / MarginBox Str Box ClrBom Rtn)
	
		(setq MarginBox 3.0)
		(setq ClrBom 5)
		
		(if (and PtHead IdJob Ls HText)
			(progn
				(setq Str (strcat 	"{\\Fromans|c0;\\W0.8;"
									"\\C2;Nesting\t\t\t\t\\C7;"						IdJob
									"\n\\C3;Algoritmo\t\t\t\t\\C7;"					"--"
									"\n\\C1;Lunghezza barra\t\t\t\\C7;"	 			(LM:rtos Ls 2 1)
									"\n\\C1;Quantita' barre usate\t\t\\C7;"	 		"--"
									"\n\\C1;Quantita' parti tagliate\t\t\\C7;" 		"--"
									"\n\\C1;Lunghezza totale barre\t\t\\C7;" 		"--"
									"\n\\C1;Lunghezza totale sfrido\t\t\\C7;" 		"--"
									"\n\\C1;Quantita' modelli barre\t\t\\C7;" 		"--"
									"\n\\C1;Margine iniziale barra\t\t\\C7;" 		"--"
									"\n\\C1;Margine minimo finale barra\t\\C7;" 	"--"
									"\n\\C1;Efficienza\t\t\t\t\\C7;" 				"0%"
									"\n\\C1;Tempo elaborazione\t\t\\C7;" 			"--"
							)
                )
				(setq Rtn 	(entmakex	(list	(cons 0 "MTEXT")                              
												(cons 100 "AcDbEntity")
												(cons 100 "AcDbMText")
												(cons 1  Str)
												;(cons 10 PtHead)
												(cons 10 (list 	(+ (car  PtHead) (* DimScale (* MarginBox 2.0))) 
																(- (cadr PtHead) (* DimScale (* MarginBox 2.0)))))
												(cons 40 HText)
												(cons 50 0.0)
												(cons 62 71)
												;(cons 71 Giustificato)
												(cons 90 3)
												(cons 63 9)
												;(cons 421 13158600)
												;(cons 441 9434636)
												(cons 210 (list 0.0 0.0 1.0))
												(cons 11 (list 1.0 0.0 0.0))
										)
							)
				)
				(setq Box (BoundingBoxLstEname  (list Rtn)))
				(vla-put-Color 	(vlax-ename->vla-object				
									(MakeRectangle (list (- (car (car Box))  (* DimScale MarginBox))
														 (- (cadr (car Box)) (* DimScale MarginBox)))
														 (+ (distance (car Box) (cadr Box))   (* MarginBox 2.0 DimScale)) 
														 (+ (distance (car Box) (cadddr Box)) (* MarginBox 2.0 DimScale)))
								)
								ClrBom
				)
			)
		)
	)
	;
	(defun MakeFooterBar (PtText LstNotOptimezedBar HText DimScale / GetIdPart
																	 MarginBox l d LstId Str Pos Box ClrBom Rtn)
	

		(defun GetIdPart (LstID / SplitName)
			(if LstID
				(progn
					(setq SplitName (splitxt LstID " "))
					(cond
						;
						;$RappPart     0          1                2                   3               		4    		5   
						; 			"Marca" "Fase  Marca" "Commessa  Marca" "Commessa  Fase  Marca" "Marca Profilo" "Nessuna"
						;
						;"Order" "Phase" "Mark" "Profile"
						;   0       1      2        3 
						;
						((= $RappPart "0")
							(setq Rtn1 (nth 2 SplitName))
						)
						((= $RappPart "1")
							(setq Rtn1 (strcat (nth 1 SplitName) " " (nth 2 SplitName)))
						)
						((= $RappPart "2")
							(setq Rtn1 (strcat (nth 0 SplitName) " " (nth 2 SplitName)))
						)
						((= $RappPart "3")
							(setq Rtn1 (strcat (nth 0 SplitName) " " (nth 1 SplitName) " " (nth 2 SplitName)))
						)
						((= $RappPart "4")
							(setq Rtn1 (strcat (nth 2 SplitName) " " (nth 3 SplitName)))
						)
						((= $RappPart "5")
							(setq Rtn1 "-")
						)
					)
				)
			)
		)
		;
		; Main
		;
		(setq MarginBox 3.0)
		(setq ClrBom 5)
		
		(if (and PtText LstNotOptimezedBar HText)
			(progn
				(setq l  (cadr   LstNotOptimezedBar)
					  d  (caddr  LstNotOptimezedBar)
					  LstId (cadddr LstNotOptimezedBar)
				)
				(setq Str (strcat 	"{\\Fromans|c0;\\W0.8;"
									"\\C2;PARTI NON OTTIMIZZATE"
									"\n"))
				(setq Pos 0)
				(repeat (length l)
					(setq TextPart (GetIdPart (nth Pos LstId)))
					(setq Str (strcat Str
										"\n\\C1;ID. \\C7;"			TextPart
										"\t\t\\C1;L. \\C7;"			(LM:rtos (nth Pos l) 2 1)
										"\t\t\\C1;N. \\C7;"			(LM:rtos (nth Pos d) 2 0)
										"\t\t\\C1;L. Tot. \\C7;"	(LM:rtos (* (nth Pos l) (nth Pos d)) 2 1)
							   )
					)
					(setq Pos (1+ Pos))
				)
				(if (= Pos 0)
					(setq Str (strcat Str "\n\t\\C7;Nessuna"))
				)
				
				(setq Rtn 	(entmakex	(list	(cons 0 "MTEXT")                              
												(cons 100 "AcDbEntity")
												(cons 100 "AcDbMText")
												(cons 1  Str)
												;(cons 10 PtText)
												(cons 10 (list 	(+ (car  PtText) (* DimScale (* MarginBox 2.0))) 
															    (- (cadr PtText) (* DimScale (* MarginBox 2.0)))))
												(cons 40 HText)
												(cons 50 0.0)
												(cons 62 71)
												;(cons 71 Giustificato)
												(cons 90 3)
												(cons 63 9)
												;(cons 421 13158600)
												;(cons 441 9434636)
												(cons 210 (list 0.0 0.0 1.0))
												(cons 11 (list 1.0 0.0 0.0))
										)
							)
				)
				(setq Box (BoundingBoxLstEname  (list Rtn)))
				(vla-put-Color (vlax-ename->vla-object 
									(MakeRectangle (list (- (car (car Box))  (* DimScale MarginBox))
													(- (cadr (car Box)) (* DimScale MarginBox)))
													(+ (distance (car Box) (cadr Box))   (* MarginBox 2.0 DimScale)) 
													(+ (distance (car Box) (cadddr Box)) (* MarginBox 2.0 DimScale)))
								)
								ClrBom
				)
			)
		)
	)
	;
	(defun GetNameByLength (Lng AssocLengthName / PosLst LstChk SplitName Rtn1 Rtn2)

		; (GETNAMEBYLENGTH 2355.0 ((2355.0 "Mk01 L80*8" 2)))
		(defun PosLst ( l e / n p r)
		 (setq n -1)
		 (while
		   (and
			 (setq p (vl-position e l))
			 (setq n (+ 1 n p)
				   r (cons n r)
				   l (cdr (member e l))
			 )
		   )
		 )
		 (reverse r)
		)
		;
		;
		;
		(if (and Lng AssocLengthName)
			(if (setq LstChk (assoc Lng AssocLengthName))
				(progn
					;(setq Rtn1 (cadr LstChk))
					(setq SplitName (splitxt (cadr LstChk) " "))
					(cond
						;
						;$RappPart     0          1                2                   3               		4    		5   
						; 			"Marca" "Fase  Marca" "Commessa  Marca" "Commessa  Fase  Marca" "Marca Profilo" "Nessuna"
						;
						;"Order" "Phase" "Mark" "Profile"
						;   0       1      2        3 
						;
						((= $RappPart "0")
							(setq Rtn1 (nth 2 SplitName))
						)
						((= $RappPart "1")
							(setq Rtn1 (strcat (nth 1 SplitName) " " (nth 2 SplitName)))
						)
						((= $RappPart "2")
							(setq Rtn1 (strcat (nth 0 SplitName) " " (nth 2 SplitName)))
						)
						((= $RappPart "3")
							(setq Rtn1 (strcat (nth 0 SplitName) " " (nth 1 SplitName) " " (nth 2 SplitName)))
						)
						((= $RappPart "4")
							(setq Rtn1 (strcat (nth 2 SplitName) " " (nth 3 SplitName)))
						)
						((= $RappPart "5")
							(setq Rtn1 "-")
						)
					)
					(if (= (- (caddr LstChk) 1) 0)
						(setq Rtn2 (LM:RemoveNth (car (PosLst AssocLengthName LstChk)) AssocLengthName))
						(setq Rtn2 (subst (list (car LstChk) (cadr LstChk) (- (caddr LstChk) 1)) LstChk AssocLengthName))
					)
					(list Rtn1 Rtn2)
				)
			)
		)
	)	
	;
	(defun MakeBom (PtBom H W TextPage HTextPage / ClrBom)
		(setq ClrBom 5)
		(if (and PtBom H W Page)
			(progn
				(vla-put-Color (vlax-ename->vla-object (MakeRectangle (list (car PtBom) (- (cadr PtBom) H)) W H)) ClrBom)
				(setq Point (list (+ (car PtBom) HTextPage) (- (cadr PtBom) (* HTextPage 1.5))))
				(entmakex (list (cons 000 "TEXT")
								(cons 100 "AcDbEntity")
								(cons 100 "AcDbText")
								(cons 010 Point)	
								(cons 040 HTextPage)
								(cons 001 TextPage)  
								(cons 050 0)  
								(cons 041 1)  
								(cons 051 0.0)  
								(cons 007 $StyleEasyCut)
								(cons 071 0)  
								;(cons 072 Position1) ; 
								(cons 011 (list (+ (nth 0 Point) 1) (nth 1 Point)))	
								;(cons 073 Position2)
						  )
				)
			)
		)
	)	
	;
	; Main
	;
	;(setq RefDim   		250.0) ; Reference Lenghy Bar for A4 Landscape
	(setq HA4 			(* 297.0 DimScale))
	(setq LA4 			(* 210.0 DimScale))
	(setq OffsetDim1  	(*   8.0 DimScale))
	(setq OffsetDim2 	(*  18.0 DimScale))
	(setq HBar       	(*   3.5 DimScale))
	(setq HTextInfo  	(*   3.0 DimScale))
	(setq XOffsetBar    (*  80.0 DimScale))
	(setq StepYBar  	(*  42.0 DimScale))
	(setq InterPage		(*  10.0 DimScale))
	(setq BorderV		(*  20.0 DimScale))
	(setq HTextPart     (* HBar 0.6))
	(setq HTextDim  	2.7)
	(setq ClrBoxPart    7)
	(setq Page			1)
	(setq HTextPage		(* 2.7 DimScale))
	(setq DimStyleName  "EasyCutDimOptimezeBars")
	(setq TextStyleName "EasyCutStyleOptimezeBars")
	
	(if (not (tblsearch "DIMSTYLE" DimStyleName))
		(MakeDimStyleToEntmake DimStyleName DimScale HTextDim TextStyleName "0")
	)
	(setq PtHead 	 	(list (car PtInsert) (cadr PtInsert)))
	(setq PtBom 	 	(list (car PtInsert) (cadr PtInsert)))
	(setq PtTextBar 	(list (car PtInsert) (- (cadr PtInsert) (* DimScale 103.0))))
	(setq PtBar 	 	(list (+ (car PtInsert) XOffsetBar) (- (cadr PtInsert) (* DimScale 103.0))))
	(setq IdY			(cadr PtInsert))

	
	(cond
		((and PtInsert LstDataOptimizedBar Id Ls BarMargStart BarMargEnd ThiCut)
			(setq ClrBar 	 (Set_Color_Length (LM:Rtos Ls 2 2)))
			(setq HPart 	 HBar)
			
			(MakeHeadBar01 PtHead IdJob LstDataOptimizedBar Ls ProfileBar BarMargStart BarMargEnd ThiCut HTextInfo DimScale )
			(MakeLogo PtHead IdJob DimScale)
			(MakeBom PtBom LA4 HA4 (LM:rtos Page 2 0) HTextPage)
			(setq NumBar 1)
			(foreach Bar (vl-sort (cadr LstDataOptimizedBar) (function (lambda (e1 e2)  (< (caddr e1) (caddr e2)))))
				
				; ++++++++++++++++ Bar
				
				(MakeTextBar PtTextBar HTextInfo Bar Ls ProfileBar BarMargStart ThiCut (strcat (LM:rtos Ls 2 0) "_" (LM:rtos NumBar 2 0)) DimScale)
				(MakeBar PtBar Ls HBar ClrBar)
				(setq NumBar (1+ NumBar))
				
				(setq PtPart (list (+ (car PtBar) BarMargStart) (cadr PtBar)))
				
				(if (> BarMargStart 0.0)
						(setq LstDim (list PtBar PtPart))
						(setq LstDim (list PtPart))
				)

				(setq Pos 1)
				(foreach Part (cadr Bar)
					
					; ++++++++++++++++ Part
					
					(setq LgPart (- Part ThiCut)) ;<-----------------
					
					(MakePart PtPart LgPart HPart (Set_Color_Length (LM:Rtos LgPart 2 2)) ClrBoxPart)

					(setq TextPart (car  (GetNameByLength (+ LgPart ThiCut) Id)))
					(setq Id  	   (cadr (GetNameByLength (+ LgPart ThiCut) Id)))
					
					(if (/= TextPart "-")
						(MakeTextPart PtPart LgPart HPart TextPart HTextPart DimScale)
					)
				
					(setq LstDim (append LstDim (list (list (+ (car PtPart) LgPart) (cadr PtPart)))))
					
					(if (/= ThiCut 0.0)
						(if (/= Pos (length (cadr Bar)))
							(setq LstDim (append LstDim (list (list (+ (car PtPart) LgPart ThiCut) (cadr PtPart)))))
						)
					)
				
					(setq PtPart (list (+ (car PtPart) LgPart ThiCut) (cadr PtPart)))
					(setq Pos (1+ Pos))
				)
				;
				(if (> (caddr Bar) 0.0) ; ++++++++++++++++ WasteLenght
					(setq LstDim (append LstDim (list (list (+ (car PtBar) Ls) (cadr PtBar)))))
				)
				; ++++++++++++++++ Lenght Parts
				(MakeDimContinue LstDim	 (list (car PtBar) (- (cadr PtBar) OffsetDim1)) DimStyleName DimScale)
				; ++++++++++++++++ Lenght Bar
				(MakeDimContinue (list PtBar (list (+ (car PtBar) Ls) (cadr PtBar))) 
							     (list (car PtBar) (- (cadr PtBar) OffsetDim2))
								 DimStyleName DimScale)
								 
				
				
				(if (> (abs (- (- (cadr PtBar) StepYBar OffsetDim2) IdY)) LA4)
					(progn
						(setq IdY 	(- IdY LA4 InterPage))
						(setq Page (1+ Page))
						(MakeBom (list (car PtBom) Idy) LA4 HA4 (LM:rtos Page 2 0) HTextPage)
						
						(setq PtBar 	(list (car PtBar)     (- IdY BorderV)))
						(setq PtTextBar (list (car PtTextBar) (- IdY BorderV)))
					)
					(progn
						(setq PtBar 	(list (car PtBar)     (- (cadr PtBar)     StepYBar))) 
						(setq PtTextBar (list (car PtTextBar) (- (cadr PtTextBar) StepYBar)))
					)
				)
			)
			(MakeFooterBar PtTextBar LstNotOptimezedBar HTextInfo DimScale)
		)
		(t
			(MakeHeadBar02 PtHead IdJob Ls BarMargStart BarMargEnd HTextInfo DimScale)
			(MakeLogo PtHead IdJob DimScale)
			(MakeBom PtBom LA4 HA4 (LM:rtos Page 2 0) HTextPage)
			(MakeFooterBar PtTextBar LstNotOptimezedBar HTextInfo DimScale)
		)
	)
)
;
