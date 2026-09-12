(defun c:TestXYSort (/ ss order fuzz lst)

	;(setq lst (list (list 10 1) (list 5 1) (list 1 2) (list 2 1) (list 100 20)))
	
	(if (and (setq ss (ssget (list (cons 0 "TEXT"))))
			(progn
				(initget "XY X-Y -XY -X-Y YX Y-X -YX -Y-X")
				(setq order (getkword "Select order [XY/X-Y/-XY/-X-Y/YX/Y-X/-YX/-Y-X]: "))
			)
			(or (setq fuzz (getreal "Fuzz factor <10.0>: "))
				(setq fuzz 10.)
			)
		)
		(progn
			(setq lst (zk:LST_SS->List ss))
			(setq lst (sort-XY lst (read order) fuzz))
			(prin1 (setq lst (mapcar '(lambda (item) (cdr (assoc 1 (entget item)))) lst)))
			;(if (vl-every 'eq lst (acad_strlsort lst))
			;	(princ "\nSorted correctly.")
			;	(princ "\nThere's an error.")
			;)
		)
	)
	lst
)
;
;
(defun zk:LST_SS->List (sel / % l)
	(repeat 
		(setq % (sslength sel))
		(setq % (1- %) 
			l (cons (ssname sel %) l)
		)
	)
)
;
;
(defun sort-XY (entLst order fuzz / lst func comp)

	(defun comp (opr1 item1 opr2 item2)
		(if (equal (item2 a) (item2 b) fuzz)
			(opr1 (item1 a) (item1 b))
			(opr2 (item2 a) (item2 b))
		)
	)
	
	(setq lst (mapcar '(lambda (ename) (cdr (assoc 10 (entget ename)))) entLst))
	(getstring "<>")
	(princ lst)
	(getstring "<>")
	
	(setq func 	(cond
					((= order 'XY) 		'(lambda (a b) (comp < car < cadr)))
					((= order 'X-Y) 	'(lambda (a b) (comp < car > cadr)))
					((= order '-XY) 	'(lambda (a b) (comp > car < cadr)))
					((= order '-X-Y)	'(lambda (a b) (comp > car > cadr)))
					((= order 'YX) 		'(lambda (a b) (comp < cadr < car)))
					((= order 'Y-X) 	'(lambda (a b) (comp < cadr > car)))
					((= order '-YX) 	'(lambda (a b) (comp > cadr < car)))
					((= order '-Y-X) 	'(lambda (a b) (comp > cadr > car)))
					(t '(lambda (a b) t))
				)
	)
	(mapcar '(lambda (idx) (nth idx entLst)) (vl-sort-i lst func))
)







(defun SortXY (LstPt Mode Fuzz / Comp func Rtn)
	; (sort-XY (list '(10 1) '(5 1) '(1 2) '(2 1) '(100 20)) "XY" 0.01)
	(defun Comp (opr1 item1 opr2 item2)
		(if (equal (item2 a) (item2 b) fuzz)
			(opr1 (item1 a) (item1 b))
			(opr2 (item2 a) (item2 b))
		)
	)
	;
	; Main
	;
	(if (and LstPt Mode Fuzz)
		(progn
			(setq func 	(cond
							((= Mode "XY"  )	'(lambda (a b) (Comp < car < cadr)))
							((= Mode "X-Y" ) 	'(lambda (a b) (Comp < car > cadr)))
							((= Mode "-XY" ) 	'(lambda (a b) (Comp > car < cadr)))
							((= Mode "-X-Y")	'(lambda (a b) (Comp > car > cadr)))
							((= Mode "YX"  )	'(lambda (a b) (Comp < cadr < car)))
							((= Mode "Y-X" ) 	'(lambda (a b) (Comp < cadr > car)))
							((= Mode "-YX" ) 	'(lambda (a b) (Comp > cadr < car)))
							((= Mode "-Y-X") 	'(lambda (a b) (Comp > cadr > car)))
							(t '(lambda (a b) t))
						)
			)
			(setq Rtn (vl-sort LstPt func))
		)
	)
	Rtn
)