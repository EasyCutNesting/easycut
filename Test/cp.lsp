(defun c:test ()

	(CheckDirectionPoint (car (entsel "\nContorno ")) (getpoint "\nPunto..") (getint "\nDirezione.."))

)


(defun CheckDirectionPoint (EnameShape PointCheck Dir / LM:bulgecentre Obj ParamNum StParam Bulge coordsecs nv
														Vertex SegStPt SegEndPt ang1 ang2 Center)

					  
	(defun LM:bulgecentre ( p1 p2 b )
		;; Bulge Centre  -  Lee Mac
		;; p1 - start vertex
		;; p2 - end vertex
		;; b  - bulge
		;; Returns the centre of the arc described by the given bulge and vertices
		(polar p1
			(+ (angle p1 p2) (- (/ pi 2) (* 2 (atan b))))
			(/ (* (distance p1 p2) (1+ (* b b))) 4 b)
		)
	)					  
	;
	;
	;	
	(if (and EnameShape PointCheck Dir)
		(progn
		
			(setq Obj       (vlax-ename->vla-object EnameShape))
			(setq Pt        (vlax-curve-getClosestPointTo EnameShape PointCheck))
			(setq ParamNum  (vlax-curve-getParamAtPoint EnameShape Pt))
			(setq StParam   (fix ParamNum))
			(setq Bulge     (vla-getbulge Obj StParam))
			(setq coordsecs (vlax-get Obj 'coordinates))
			(setq nv	    (fix (/ (length coordsecs) 2.0)))
			
	
			(if (> (- ParamNum (fix ParamNum)) 0.0)
				(setq Vertex nil)
				(setq Vertex T)
			)
		
			(if (= Bulge 0)
				(progn
					(if Vertex
						(progn
							(cond 
								((= (fix ParamNum) 0)
									(setq SegStPt  (vlax-curve-getPointAtParam EnameShape StParam))
									(setq SegEndPt (vlax-curve-getPointAtParam EnameShape (1+ StParam)))
									(setq ang1     (angle SegStPt SegEndPt))
									(setq SegStPt  (vlax-curve-getPointAtParam EnameShape StParam))
									(setq bulge    (vla-getbulge Obj (- nv 1)))
									(setq SegEndPt (vlax-curve-getPointAtParam EnameShape (- nv 1)))
									(setq ang2     (angle SegStPt SegEndPt))
								)
								(t
									(setq SegStPt  (vlax-curve-getPointAtParam EnameShape StParam))
									(setq SegEndPt (vlax-curve-getPointAtParam EnameShape (1+ StParam)))
									(setq ang1     (angle SegStPt SegEndPt))
									(setq SegStPt  (vlax-curve-getPointAtParam EnameShape StParam))
									(setq bulge    (vla-getbulge Obj (- nv 1)))
									(setq SegEndPt (vlax-curve-getPointAtParam EnameShape (- StParam 1)))
									(setq ang2     (angle SegStPt SegEndPt))
								)
							)
							(if (/= Bulge 0)							
								(progn
									(setq Center    (LM:bulgecentre SegStPt SegEndPt Bulge))
									(setq ang2 		(angle Center Pt))
								)
							)
							
						)
						(progn
							(setq SegStPt  	(vlax-curve-getPointAtParam EnameShape StParam))
							(setq SegEndPt 	(vlax-curve-getPointAtParam EnameShape (1+ StParam)))
							(setq ang1 		(angle SegStPt SegEndPt))
						)
					)
				)
				(progn
					(setq SegStPt  	(vlax-curve-getPointAtParam EnameShape StParam))
					(setq SegEndPt 	(vlax-curve-getPointAtParam EnameShape (1+ StParam)))
					(setq Center    (LM:bulgecentre SegStPt SegEndPt Bulge))
					(setq ang1 		(angle Center Pt))
				)
			)
	
			(setq Rtn nil)
			(cond
				
				((and (/= Bulge 0) (or (= dir 1) (= dir 2))) 			; Basso Alto
					(if (or (equal ang1 0.0 1e-6) 
							(equal ang1 pi 1e-6)
							(equal ang1 (* pi 2.0) 1e-6)
						)
						(setq Rtn T)
					)
				)
				((and (/= Bulge 0) (or (= dir 3) (= dir 4))) 			; Dx Sx
					(if (or (equal ang1 (/ pi 2.0) 1e-6) 
							(equal ang1 (/ (* 3.0 pi) 2.0) 1e-6)
						)
						(setq Rtn T)
					)
				)
				((and (null Vertex) (or (= dir 1) (= dir 2))) 			; Basso Alto
					(if (or (equal ang1 (/ pi 2.0) 1e-6) 
							(equal ang1 (/ (* 3.0 pi) 2.0) 1e-6)
						)
						(setq Rtn T)
					)
				)
				((and (null Vertex)  (or (= dir 3) (= dir 4))) 			; Dx Sx
					(if (or (equal ang1 0.0 1e-6) 
							(equal ang1 pi 1e-6)
							(equal ang1 (* pi 2.0) 1e-6)
						)
						(setq Rtn T)
					)
				)
				((and Vertex (or (= dir 1) (= dir 2))) 					; Basso Alto
					(if (or (equal ang1 (/ pi 2.0) 1e-6) 
							(equal ang1 (/ (* 3.0 pi) 2.0) 1e-6)
							(equal ang2 (/ pi 2.0) 1e-6) 
							(equal ang2 (/ (* 3.0 pi) 2.0) 1e-6)
						)
						(setq Rtn T)
					)
				)
				((and Vertex  (or (= dir 3) (= dir 4))) 			; Dx Sx
					(if (or (equal ang1 0.0 1e-6) 
							(equal ang1 pi 1e-6)
							(equal ang1 (* pi 2.0) 1e-6)
							(equal ang2 0.0 1e-6) 
							(equal ang2 pi 1e-6)
							(equal ang2 (* pi 2.0) 1e-6)
						)
						(setq Rtn T)
					)
				)
				
			)


			;(if Rtn
			;	(setq Chk "\nPunto da riconsiderare")
			;	(setq Chk "\nPunto confermato")
			;)
			
			;(prompt
			;	(strcat	"\n Segment start point is: "  (vl-princ-to-string SegStPt)
			;			"\n Segment ending point is: " (vl-princ-to-string SegEndPt)
			;			"\n Segment bulge value is: "  (rtos bulge 2 2)
			;			"\n numero segmento       : "  (rtos (fix ParamNum) 2 2)
			;			Chk
			;	)
			;)
		)
	)
	Rtn
)

