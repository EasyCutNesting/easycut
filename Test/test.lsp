(setq Mx 0.0)
(setq My 0.0)

; vedi dwg terix1

(LM:MakeLWPoly (LM:SSBoundingBox (ssget)) 1)

;(setq LstShpPt1 (list (list (+ Mx 0.0)  (+ My 0.0))
;					  (list (+ Mx 10.0) (+ My 0.0))
;					  (list (+ Mx 5.0)  (+ My 10.0))))
					  
;(setq LstShpPt2 (list (list (+ Mx 20.0)  (+ My 0.0))
;					  (list (+ Mx 30.0)  (+ My 0.0))
;					  (list (+ Mx 25.0)  (+ My 10.0))))
					
(setq LstShpPt1 (list 	(list (+ Mx 0.0) (+ My 0.0))
						(list (+ Mx 10.0) (+ My 0.0))
						(list (+ Mx 10.0) (+ My 10.0))
						(list (+ Mx 20.0) (+ My 10.0))
						(list (+ Mx 20.0) (+ My 20.0))
						(list (+ Mx 0.0) (+ My 20.0))))
(Tetrix LstShpPt1 LstShpPt1)
(Tetrix LstShpPt1 LstShpPt2)

(defun PullOver (/ ReferenceAlign 
				   LstCoShape MarkerAlign LstRef)

	(defun ReferenceAlign (LstCoShape1 LstCoShape2 MarkerAlign / NewLstCoShape1 NewLstCoShape2 P1Start P1Start P1Start P1End P1End P1End Rtn)
	
		; ((5 6) (6 5 "a"))
		
		(if (and  LstCoShape1 LstCoShape2 MarkerAlign)
			(progn
				(setq NewLstCoShape2 (append LstCoShape2 (list (car LstCoShape2))))
				(setq P1Start (nth (car  (cadr MarkerAlign)) NewLstCoShape2))
				(setq P2Start (nth (cadr (cadr MarkerAlign)) NewLstCoShape2))
				(setq P3start (per (car P2Start) (cadr P2Start) (car P1Start) (cadr P1Start) -1.0))
				
				(setq NewLstCoShape1 (append LstCoShape1 (list (car LstCoShape1))))
				(setq P1End (nth (car  (car MarkerAlign)) NewLstCoShape1))
				(setq P2End (nth (cadr (car MarkerAlign)) NewLstCoShape1))
				(setq P3End (per (car P2End) (cadr P2End) (car P1End) (cadr P1End) -1.0))
				(setq Rtn (list P1Start P2Start P3Start P1End P2End P3End))
			)
		)
		Rtn
	)
	;	
	; Main
	;
	(prompt "\nShape1 ") (setq EnamePoly1 (getent))
	(prompt "\nShape2 ") (setq EnamePoly2 (getent))
	
	(setq EnamePoly1$ EnamePoly1)
	(setq EnamePoly2$ EnamePoly2)

	(setq LstCoShape1 	(DiscretizeShapeNoControl EnamePoly1))
	(setq LstCoShape2 	(DiscretizeShapeNoControl EnamePoly2))
	
	(if (LM:ListClockwise-p LstCoShape1)(setq LstCoShape1 (reverse LstCoShape1)))
	(if (LM:ListClockwise-p LstCoShape2)(setq LstCoShape2 (reverse LstCoShape2)))
	
	(setq MarkerAlign  	(Tetrix LstCoShape1 LstCoShape2))
	;    car   cadr  caddr
	; (600.0 (5 6) (6 5 "a"))
	
	(setq LstRef (ReferenceAlign LstCoShape1 LstCoShape2 (cdr MarkerAlign)))
	
	
	(AlignObject (vlax-ename->vla-object EnamePoly2)
				 (nth 0 LstRef) (nth 1 LstRef) (nth 2 LstRef) 
				 (nth 3 LstRef) (nth 4 LstRef) (nth 5 LstRef)
				 T)

)
;
(defun ReferenceAlign (LstCoShape1 LstCoShape2 MarkerAlign / NewLstCoShape1 NewLstCoShape2 P1Start P1Start P1Start P1End P1End P1End Rtn)
	
	; ((5 6) (6 5 "a"))
	
	(if (and  LstCoShape1 LstCoShape2 MarkerAlign)
		(progn
			(setq NewLstCoShape2 (append LstCoShape2 (list (car LstCoShape2))))
			(setq P1Start (nth (car  (cadr MarkerAlign)) NewLstCoShape2))
			(setq P2Start (nth (cadr (cadr MarkerAlign)) NewLstCoShape2))
			(setq P3start (per (car P2Start) (cadr P2Start) (car P1Start) (cadr P1Start) -1.0))
			
			(setq NewLstCoShape1 (append LstCoShape1 (list (car LstCoShape1))))
			(setq P1End (nth (car  (car MarkerAlign)) NewLstCoShape1))
			(setq P2End (nth (cadr (car MarkerAlign)) NewLstCoShape1))
			(setq P3End (per (car P2End) (cadr P2End) (car P1End) (cadr P1End) -1.0))
			(setq Rtn (list P1Start P2Start P3Start P1End P2End P3End))
		)
	)
	Rtn
)
;
(defun Tetrix (LstShpPt1 LstShpPt2 / TransLocalLstPt TransGlobalLstPt IsCollinear PointInside MatchMinRect MatchMinRect02
									 DiscretizeSegment LstShpM LstShpS
									 PosM PosS
									 Pm1 Pm2 Pm3 Ps1 Ps2 Ps3 NewOrigin
									 CosDirM CosDirS NewCosDirM Surface
									 LstShpLocM LstShpLocS LstGl_1 LstGl_2
									 MaxX MinX MaxY MinY Rtn)
									 
	
	(defun TransLocalLstPt (LstPt CosDir / Rtn)
		(foreach itm LstPt
			(setq Rtn (append Rtn (list (TransLPtNoZero itm CosDir))))
		)
		Rtn
	)
	;
	(defun TransGlobalLstPt (LstPt CosDir / Rtn)
		(foreach itm LstPt
			(setq Rtn (append Rtn (list (TransGPtNoZero itm CosDir))))
		)
		Rtn
	)
	;
	(defun IsCollinear (Pt LstCoo / Loop Pos Rtn)
	
		(if (and Pt LstCoo)
			(progn
				(setq Loop T
					  Pos 0
				)
				(while Loop
					(if (equal (+ (distance (nth Pos      LstCoo) Pt) 
								  (distance (nth (1+ Pos) LstCoo) Pt))
								  (distance (nth Pos      LstCoo) 
											(nth (1+ Pos) LstCoo)) 1e-8)
						(setq Rtn T Loop nil)
						(setq Pos (1+ Pos))
					)
					(if (= (1+ Pos) (length LstCoo)) (setq Loop nil))
				)
			)
		)
		Rtn
	)
	;
	(defun PointInside (Pt LstCoo Ray Flag Accuracy / xrandom yrandom PEnd PtInt LstInt Pos Rtn)
		;
		;
		(setq Pos 0)
		(cond
			((IsCollinear Pt LstCoo) ; punto nel contorno
				(if Flag
					(if (not (MemberWithAccuracy PtInt LstInt Accuracy)) 
						(setq LstInt (append LstInt (list PtInt)))
					)
				)
			)
			(T
				(setq xrandom 	(atof (Random_Str 5))
					  yrandom 	(+ (atof (Random_Str 5)) xrandom)
					  PEnd		(polar Pt (/ xrandom yrandom) (* 1.5 Ray))
				)
				(repeat (- (length LstCoo) 1)
					(if (setq PtInt (inters (nth Pos LstCoo) (nth (1+ Pos) LstCoo) Pt PEnd T))
						(if (not (MemberWithAccuracy PtInt LstInt Accuracy)) 
							(setq LstInt (append LstInt (list PtInt)))
						)
					)
					(setq Pos (1+ Pos))
				)

			)
		)
		(if LstInt
			(if (= (rem (length LstInt) 2) 0)
				nil
				T
			)
			nil
		)
	)
	;
	(defun MatchMinRect (LstPtM LstPtS / PosM CosDirM LstLl_1 LstLl_2 MaxX MinX MaxY MinY Rtn)
		(setq PosM 0)
		(repeat (1- (length	LstPtM))
			(setq Pm1 (nth PosM LstShpM))
			(setq Pm2 (nth (1+ PosM) LstShpM))
			(setq Pm3 (per (car Pm2) (cadr Pm2) (car Pm1) (cadr Pm1) -1.0))

			(setq CosDirM (DefPianoPt Pm1 Pm2 Pm3))
			(setq LstLl_1 (TransLocalLstPt LstPtM CosDirM))
			(setq LstLl_2 (TransLocalLstPt LstPtS CosDirM))
			
			(setq MinX (apply 'min (mapcar 'car  (append LstLl_1 LstLl_2))))
			(setq MaxX (apply 'max (mapcar 'car  (append LstLl_1 LstLl_2))))
			(setq MinY (apply 'min (mapcar 'cadr (append LstLl_1 LstLl_2))))
			(setq MaxY (apply 'max (mapcar 'cadr (append LstLl_1 LstLl_2))))
			
			(setq Rtn  (append Rtn 	(list (list (* 	(- MaxX MinX) (- MaxY MinY)) PosM (1+ PosM)))))
			(setq PosM (1+ PosM))
		)
		;(princ "\n") (princ Rtn)
		(nth (car (vl-sort-i Rtn (function (lambda (e1 e2) (< (car e1) (car e2)))))) Rtn)
	)
	;
	(defun MatchMinRect02 (LstPtM LstPtS Discretize / MinRectPoolOver
													  NDiv Accuracy MaxX MinX MaxY MinY PosS Loop1 Loop2 Pos Inside Pt1 Pt2 PtChk Rtn
													  Marker LstRef EnamCopy
													)
		
		
		(defun MinRectPoolOver (LstPtM LstPtS / PosM Pm1 Pm2 Pm3 CosDirM LstLl_1 LstLl_2 MaxX MinX MaxY MinY Rtn)
		
			(setq PosM 0)
			(repeat (1- (length	LstPtM))
				(setq 	Pm1 (nth PosM LstShpM)
						Pm2 (nth (1+ PosM) LstShpM)
						Pm3 (per (car Pm2) (cadr Pm2) (car Pm1) (cadr Pm1) -1.0)

						CosDirM (DefPianoPt Pm1 Pm2 Pm3)
						LstLl_1 (TransLocalLstPt LstPtM CosDirM)
						LstLl_2 (TransLocalLstPt LstPtS CosDirM)
		
						MinX (apply 'min (mapcar 'car  (append LstLl_1 LstLl_2)))
						MaxX (apply 'max (mapcar 'car  (append LstLl_1 LstLl_2)))
						MinY (apply 'min (mapcar 'cadr (append LstLl_1 LstLl_2)))
						MaxY (apply 'max (mapcar 'cadr (append LstLl_1 LstLl_2)))
		
						;(setq Rtn  (append Rtn 	(list (list (* 	(- MaxX MinX) (- MaxY MinY)) PosM (1+ PosM)))))
						Rtn  (append Rtn (list (* (- MaxX MinX) (- MaxY MinY))))
						PosM (1+ PosM)
				)
			)
			(nth (car (vl-sort-i Rtn '<)) Rtn)
		)
		;
		; Main
		;
		(setq Accuracy 0.001)
		
		(if (and LstPtM LstPtS Discretize)
			(progn
			
				; Check inside point  +++++
				
				(setq PosS 0)
				(setq Loop1 T)
				
				
				
				(while (and Loop1 (< PosS (1- (length LstPtS))))
					
					
					(setq Pt1 	(nth PosS LstPtS)
						  Pt2 	(nth (1+ PosS) LstPtS)
						  NDiv 	(fix (* (distance Pt1 Pt2) Discretize))
						  PtChk (append (list Pt1) (div (car Pt1) (cadr Pt1) (car Pt2) (cadr Pt2) Ndiv) (list Pt2))
				  		  Pos 	0	
					      Loop2 T
					)
					
					(while (and Loop2 (< Pos (length PtChk)))
						(if (PointInside (nth Pos PtChk) LstPtM 100000.0 nil Accuracy)
							(setq Inside 	T
								  Loop1 	nil
								  Loop2 	nil
							)
							(setq Pos (1+ Pos))
						)
					)
					(princ Pos) (princ " ")
					(setq PosS (1+ PosS))
				)
				
				
				
				; -----------------------------------------------------------------------------------------------------------------
				(setq Marker (list (list PosM$ (1+ PosM$)) (list (1+ PosS$) PosS$ "a")))
				(setq LstRef (ReferenceAlign (TransGlobalLstPt LstPtM CosDirM$) (TransGlobalLstPt LstPtS CosDirS$) Marker))
				(setq EnamCopy (AlignObject (vlax-ename->vla-object EnamePoly2$)
											(nth 0 LstRef) (nth 1 LstRef) (nth 2 LstRef) 
											(nth 3 LstRef) (nth 4 LstRef) (nth 5 LstRef)
											T))
				(getstring "<>") (entdel EnamCopy)
				; -----------------------------------------------------------------------------------------------------------------

				(princ "\nSegmenti controllati -> ") (princ PosS) (princ "  Punti controllati -> ") (princ Pos) 
				
				(if (not Inside)
					(setq Rtn (MinRectPoolOver LstPtM LstPtS))
					;(setq Rtn (* (- MaxX MinX) (- MaxY MinY)))
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq DiscretizeSegment (/ 30.0 100.0))
	(setq LstShpM (append LstShpPt1 (list (car LstShpPt1))))
	(setq LstShpS (append LstShpPt2 (list (car LstShpPt2))))
	
	(setq PosM 0) (setq PosM$ PosM)
	
	(repeat  (1- (length LstShpM))
		(setq Pm1 (nth PosM LstShpM))
		(setq Pm2 (nth (1+ PosM) LstShpM))
		(setq Pm3 (per (car Pm2) (cadr Pm2) (car Pm1) (cadr Pm1) -1.0))

		(setq CosDirM (DefPianoPt Pm1 Pm2 Pm3)) (setq CosDirM$ CosDirM)
		
		(setq LstShpLocM (TransLocalLstPt LstShpM CosDirM))
	
		(princ "\nMaster-> ") (princ PosM) (princ "\n")
	
		(setq PosS 0) (setq PosS$ PosS)
		
		(repeat (1- (length LstShpS))
			(setq Ps1 (nth (1+ PosS) LstShpS))
			(setq Ps2 (nth PosS LstShpS))
			(setq Ps3 (per (car Ps2) (cadr Ps2) (car Ps1) (cadr Ps1) -1.0))
			
			(setq CosDirS (DefPianoPt Ps1 Ps2 Ps3)) (setq CosDirS$ CosDirS)
			
			(setq LstShpLocS (TransLocalLstPt LstShpS CosDirS))
			(princ "\n--->Slave ") (princ PosS) (princ "\n")
			
			;(if (/= (setq Gap (- (distance Ps1 Ps2) (distance Pm1 Pm2))) 0.0)
			;	(progn
			;		(princ "\n--->Gap ") (princ Gap) (princ "\n")
			;		(setq NewOrigin (prol (car Pm2) (cadr Pm2) (car Pm1) (cadr Pm1) Gap))
			;		(setq NewCosDirM (LM:SubstNth (list (nth 0 NewOrigin) (nth 1 NewOrigin) 0.0) 0 CosDirM))
			;		
			;		(if (setq Surface (MatchMinRect02 (TransGlobalLstPt LstShpLocM CosDirM) (TransGlobalLstPt LstShpLocS CosDirM) DiscretizeSegment))
			;			(setq Rtn (append Rtn (list (list Surface (list PosM (1+ PosM)) (list (1+ PosS) PosS "a")))))
			;		)
			;		;(if (setq Surface (MatchMinRect02 (TransGlobalLstPt LstShpLocM CosDirM) (TransGlobalLstPt LstShpLocS NewCosDirM) DiscretizeSegment))
			;		;	(setq Rtn (append Rtn (list (list Surface (list PosM (1+ PosM)) (list (1+ PosS) PosS "b")))))
			;		;)
			;	)
			;	(progn
			;		(if (setq Surface (MatchMinRect02 (TransGlobalLstPt LstShpLocM CosDirM) (TransGlobalLstPt LstShpLocS CosDirM) DiscretizeSegment))
			;			(setq Rtn (append Rtn (list (list Surface (list PosM (1+ PosM)) (list (1+ PosS) PosS "a")))))
			;		)
			;	)
			;)
			
			(if (/= (setq Gap (- (distance Ps1 Ps2) (distance Pm1 Pm2))) 0.0)
				(progn
					(princ "\n--->Gap ") (princ Gap) (princ "\n")
					(setq NewOrigin (prol (car Pm2) (cadr Pm2) (car Pm1) (cadr Pm1) Gap))
					(setq NewCosDirM (LM:SubstNth (list (nth 0 NewOrigin) (nth 1 NewOrigin) 0.0) 0 CosDirM))
					
					(if (setq Surface (MatchMinRect02 (TransGlobalLstPt LstShpLocM CosDirM) (TransGlobalLstPt LstShpLocS CosDirM) DiscretizeSegment))
						(setq Rtn (append Rtn (list (list Surface (list PosM (1+ PosM)) (list (1+ PosS) PosS "a")))))
					)
					;(if (setq Surface (MatchMinRect02 (TransGlobalLstPt LstShpLocM CosDirM) (TransGlobalLstPt LstShpLocS NewCosDirM) DiscretizeSegment))
					;	(setq Rtn (append Rtn (list (list Surface (list PosM (1+ PosM)) (list (1+ PosS) PosS "b")))))
					;)
				)
				(progn
					(if (setq Surface (MatchMinRect02 (TransGlobalLstPt LstShpLocM CosDirM) (TransGlobalLstPt LstShpLocS CosDirM) DiscretizeSegment))
						(setq Rtn (append Rtn (list (list Surface (list PosM (1+ PosM)) (list (1+ PosS) PosS "a")))))
					)
				)
			)
			
			
			(setq PosS (1+ PosS)) (setq PosS$ (1+ PosS$))
		)
		(setq PosM (1+ PosM)) (setq PosM$ (1+ PosM$))
	)
	(nth (car (vl-sort-i Rtn (function (lambda (e1 e2) (< (car e1) (car e2)))))) Rtn)
)
;
;
;https://www.cadtutor.net/forum/topic/55408-optimizing-cutting-rebars-for-least-waste/
;http://www.theswamp.org/index.php?topic=48889.0

