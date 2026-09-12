 (defun c:remdupvert (/)
; choose the polyline
  (setq ent (entget (car (entsel))))
  (acet-lwpline-remove-duplicate-pnts ent)
  (princ)
)
;Takes an entity list of lwpolylines and modifies the object
;removing neighboring duplicate points. If no duplicated points
;are found then the object will not be passed to (entmod ).
;Returns the new elist when done.
(defun acet-lwpline-remove-duplicate-pnts (e1 / a n lst e2)
	(setq n 0)
	(repeat (length e1)
		(setq a (nth n e1))
		(cond
			((not (equal 10 (car a)))
				(setq e2 (cons a e2))
			)
			((not (equal (car lst) a))
				(setq lst (cons a lst)
					  e2  (cons a e2)
				)
			)
		)
		(setq n (+1 n))
	)
	(setq e2 (reverse e2))
	(if (and e2 (not (equal e1 e2)) lst)
		(progn
			(if (equal 1 (length lst))
				(progn
					(entdel (cdr (assoc -1 e1)))
					(setq e2 nil)
				)
				(progn
					(setq	e2 (subst (cons 90 (length lst)) (assoc 90 e2) e2)) ;setq
					(entmod e2)
				)
			)
		)
	)
	e2
)


;
;
(defun RemoveColinearLwPolyline (Ename / GetLstRegapp GetRegappEntity MakeDxfPolyline MakeDxfCircle
												 LstCo LstDxf Dxf NameRegapp Rtn) 

	(defun GetLstRegapp ( / f a Rtn)
		(setq f t)
		(while (setq a (tblnext "appid" f))
			(if f (setq f nil))
			(setq Rtn (cons (cdr (assoc 2 a)) Rtn))
		)
		Rtn
	)
	;
	(defun GetRegappEntity (LstDxf / Rtn)
		
		(if LstDxf
			(if (assoc -3 LstDxf)
				(setq Rtn (nth 0 (nth 1 (assoc -3 LstDxf))))
			)
		)
		Rtn
	)
	;
	(defun MakeDxfPolyline (LstDxf LstCo / Var itm Rtn)
	
		;((27591.6 30461.3) (27591.6 30431.3) 0.999772 (27591.6 30446.3)) 
		;((27591.6 30431.3) (27631.6 30431.3)) 
		;((27631.6 30431.3) (27631.6 30461.3)) 
		;((27631.6 30461.3) (27591.6 30461.3))
		
		(if LstCo
			(progn
			
				(if (setq Normal (assoc 210 LstDxf))
					(setq Normal '(210 0.0 0.0 1.0))
				)
				(setq Rtn (vl-remove-if  '(lambda (pair) (member (car pair) '(10 40 41 42 91 210 -3))) LstDxf))
				;(setq Rtn (append '((0 . "LWPOLYLINE") (100 . "AcDbEntity") (100 . "AcDbPolyline")) Rtn))
				(setq Rtn (subst (cons 90 (length LstCo)) (assoc 90 Rtn) Rtn))	; n. vertici	
				
				(foreach itm LstCo
					(cond
						((> (length itm) 2)
							(setq Rtn 	(append Rtn (list (cons 10 (car itm)) '(40 . 0.0) '(41 . 0.0) (cons 42 (caddr itm))	'(91 . 0))))
						)
						(t
							(setq Rtn 	(append Rtn (list (cons 10 (car itm)) '(40 . 0.0) '(41 . 0.0) '(42 . 0.0) '(91 . 0))))
						)
					)
				)
				(setq Rtn (append Rtn (list Normal)))
				(if (setq Var (assoc -3 LstDxf)) (setq Rtn (append Rtn (list Var))))
			)
		)
		Rtn
	)
	;
	(defun MakeDxfCircle (LstDxf LstCo / Normal Var Rtn)
	
		(if (and LstDxf LstCo)
			(progn
				(if (setq Normal (assoc 210 LstDxf))
					(setq Normal '(210 0.0 0.0 1.0))
				)
				(setq Rtn (vl-remove-if  '(lambda (pair) (member (car pair) '(10 40 41 42 70 90 91 210 -3))) LstDxf))
				(setq Rtn 	(append Rtn 
									'((90 . 2) (70 . 1))
									(list 	(cons 10 (list (- (car (car  LstCo)) (cadr LstCo)) (cadr (car  LstCo))))
											'(40 . 0.0) '(41 . 0.0) '(42 . 1) '(91 . 0)
											(cons 10 (list (+ (car (car  LstCo)) (cadr LstCo)) (cadr (car  LstCo))))
											'(40 . 0.0) '(41 . 0.0) '(42 . 1) '(91 . 0)
											Normal
									)
							)
				)
				(if (setq Var (assoc -3 LstDxf)) (setq Rtn (append Rtn (list Var))))
			)
		)
		Rtn
	)
	;
	; Main
	;
  	(setq LstDxf 	 (entget Ename (list "*")))
	(setq NameRegapp (GetRegappEntity LstDxf))

	(if NameRegapp
		(if (not (member NameRegapp (GetLstRegapp)))
			(regapp NameRegapp)
		)
	)
	
	(cond
		((setq LstCo (IsLwPolylineCircle Ename))
			(setq Dxf (MakeDxfCircle LstDxf LstCo))
		)
		(t
			(setq LstCo (RemoveCollinearArc Ename))
			(setq Dxf 	(MakeDxfPolyline LstDxf LstCo))
		)
	)
	(entmod Dxf)
	(entupd Ename)
	;(if (setq Rtn (entmakex Dxf))
	;	(if Replace	(DeleteEntity (list Ename)))
	;)
	;Rtn
)
;
;
;
(defun RemoveCollinearArc (EnamePolyLine / MakeList CombineSimple
										   LstCo Num Combo Loop1 Loop2 Find itm1 itm2 Co1 Co2)


	(defun MakeList (LstCo / Num P1 P2 Bu Rtn)
		(setq Num 0)
		(repeat (- (length LstCo) 1)
			(setq P1		(cdr (assoc 10 (nth (+ Num 0) LstCo))))
			(setq P2		(cdr (assoc 10 (nth (+ Num 1) LstCo))))
			(setq Bu		(cdr (assoc 42 (nth (+ Num 0) LstCo))))
			(if (/= Bu 0)
				(setq Rtn (append rtn (list (list P1 P2 Bu (LM:bulgecentre P1 P2 Bu)))))
				(setq Rtn (append rtn (list (list P1 P2))))
			)
			(setq Num (1+ Num))
		)
		Rtn
	)
	;
	;
	;
	(defun CombineSimple (Lst / Num Rtn)
		
		(if Lst
			(progn
				(setq Num 0)
				(setq Rtn (append Rtn (list (list Num (- (length Lst) 1)))))
				(repeat (- (length Lst) 1)
					(setq Rtn (append Rtn (list (list (+ Num 0)  (+ Num 1)))))
					(setq Num (1+ Num))
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if EnamePolyLine
		(progn
			(setq LstCo (LM:lwvertices (entget EnamePolyLine)))
			(if (not (equal (cdr (assoc 10 (car LstCo)))
							(cdr (assoc 10 (car (reverse LstCo)))) 0.01)
				)
				(setq LstCo (append LstCo (list (car LstCo))))
			)
			(setq LstCo (MakeList LstCo))
			
			(setq Loop1 T)
			(while Loop1
				;(setq Combo (CombineList NthLstCo 2))
				(setq Combo (CombineSimple LstCo))
				(setq Loop2 T)
				(setq Num 0)
				(setq Find nil)
				(while Loop2
					(setq itm1 (car  (nth Num Combo)))
					(setq itm2 (cadr (nth Num Combo)))
					
					(if (and (= (length (nth itm1 LstCo)) 4)
							 (= (length (nth itm2 LstCo)) 4)
						)
						(if (equal (nth 3 (nth itm1 LstCo))
								   (nth 3 (nth itm2 LstCo)) 0.1)
							(progn
								(setq Co1 (nth itm1 LstCo))
								(setq Co2 (nth itm2 LstCo))
								(setq Loop2 nil)
								(setq Find T)
								(cond
									((and (= itm1 0) (= itm2 (- (length LstCo) 1)))
										(setq LstCo (subst 	(list (nth 0 Co2) (nth 1 Co1) 
																  (LM:3p->bulge (nth 0 Co2) (nth 1 Co2) (nth 1 Co1)) 
																  (nth 3 Co1)
															)
															(nth itm1 LstCo)
															LstCo
													)
										)
									)
									(t
										(setq LstCo (subst 	(list (nth 0 Co1) (nth 1 Co2)
																  (LM:3p->bulge (nth 0 Co1) (nth 1 Co1) (nth 1 Co2)) 
																  (nth 3 Co1)
															)
															(nth itm1 LstCo)
															LstCo
													)
										)
									)
								)
								(setq LstCo (LM:RemoveNth itm2 LstCo))
								(setq Loop2 nil)
							)
						)
					)
					(setq Num (1+ Num)) (if (= Num (length LstCo)) (setq Loop2 nil))
				)
				(if (not Find) (setq Loop1 nil))
			)
		)
	)
	LstCo
)
;
;
;
