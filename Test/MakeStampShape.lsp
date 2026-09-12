(defun MakeStampShape (EnameShape MgX MgY Text Htxt / MrgX MrgY Num
											          MaxDimensionLengthCode Shape Jou DataCircle Loop conta
											          p1g p2g p3g p1l p2l p3l Rtn)

	(defun CheckText (P1G P2G Jou)
	
		(if (and p1g p2g)
			(if (= (car Jou) 3)
				(setq tmp p2g
					  p2g p1g
					  p1g tmp
				)
			)
		)
		(setq p3g (per (car p2g) (cadr p2g) (car p1g) (cadr p1g) -1.0))
		
		(if p3g
			(progn
				(setq CosDir (DefPiano (car p1g) (cadr p1g) 0.0 (car p2g) (cadr p2g) 0.0 (car p3g) (cadr p3g) 0.0))
				(setq p1l (list    MrgX      MrgY 0.0))
				(setq p2l (list (+ MrgX 1.0) MrgY 0.0))
				(setq p3l (list    MrgX   (+ MrgY 1.0) 0.0))
				(setq p1g (TransG (car p1l) (cadr p1l) (caddr p1l) CosDir))
				(setq p2g (TransG (car p2l) (cadr p2l) (caddr p2l) CosDir))
				(setq p3g (TransG (car p3l) (cadr p3l) (caddr p3l) CosDir))
				(setq Rtn (list p1g p2g p3g))
			)
		)
	)
	

	)
	
	(setq Shape (DiscretizeShape Ename))
	(setq Jou 	(CheckPoly Ename))
	
	(if (setq DataCircle (IsLwPolylineCircle Ename))
		(progn
			(if (> (- (* (nth 1 DataCircle) 2.0) $MargineAccosto $MargineAccosto) MaxDimensionLengthCode)
				(progn
					(setq p1g (list (- (nth 0 (nth 0 DataCircle)) (nth 1 DataCircle))
									(- (nth 1 (nth 0 DataCircle)) MrgY)))
					(setq p2g (list    (nth 0 (nth 0 DataCircle))
									(- (nth 1 (nth 0 DataCircle)) MrgY)))
				)
			)
		)
		(progn
			(setq Num 0)
			(setq Loop T)
			(while Loop
	
				(setq p1g 	(nth (+ Num 0) Shape))
				(setq p2g 	(nth (+ Num 1) Shape))
				
				(MakeText "Text" Px Style Heigth Rotation Factor Color Layer
				
					
				(if (= (1+ Num) (length Shape))
					(setq Loop nil)
				)
				(setq Num (1+ Num))
				
			)
		)
	)


	Rtn ; ((-294.092 878.124 0.0) (-293.352 878.797 0.0) (-293.42 877.384 0.0) )
)