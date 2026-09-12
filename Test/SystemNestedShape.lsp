;
;
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++ risultato finale
;
(defun  GetNestedShape (EnameShape Verbose / LstNestedShape Rtn)

	(if EnameShape
		(progn
			(setq LstNestedShape (GetNestedBody EnameShape Verbose))
			(setq Rtn  (SystemResolution LstNestedShape Verbose))
		)
	)
	Rtn

)
;
;
(defun GetNestedBody (EnameShape Verbose /  LstEnameInside Rtn itm )
	
	;
	; Main
	;
	(if EnameShape
		(progn
			(setq LstEnameInside (ShapeInside EnameShape))
			(setq Rtn (list LstEnameInside))
			; search composed ++++++++++++++++++++++++++++++++++++++
			(foreach itm (cdr LstEnameInside)
			 	(setq Rtn (append Rtn (list (ShapeInside itm))))
			)
			(if Verbose 
				(progn
					(princ "\n Nested List \n") 
					(princ Rtn) 
					(princ "\nEnd\n")
				)
			)
			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		)
	)
	Rtn
)
;
;
(defun ShapeInside (EnameShape / SortEnameByEname
								 Shape Ename ChechZoom Rtn)

	(defun SortEnameByEname (LstEname / itm AddLst Rtn)
		(if LstEname 
			(progn
				(foreach itm LstEname
					(setq AddLst (append AddLst (list (list (vl-prin1-to-string itm) itm))))
				)
				(setq AddLst (vl-sort AddLst (function (lambda (e1 e2)  (> (car e1) (car e2))))))
				(foreach itm AddLst
					(setq Rtn (append Rtn (list (cadr itm))))
				)
			)
		)
		Rtn
	)
	;
	;
	(if EnameShape
		(progn 
			(setq ChechZoom (VisibleEname EnameShape))
			(cond 
				((= (GetNameEname EnameShape) "LWPOLYLINE")
					(setq Shape (DiscretizeShape EnameShape))
				)
				((= (GetNameEname EnameShape) "CIRCLE")
					 (setq Shape (DiscretizeCircle EnameShape))
				)
				((= (GetNameEname EnameShape) "ELLIPSE")
					(setq Ename (Ellipse2LwPolyline EnameShape nil))
					(if  (IsClosed Ename T)
						(setq Shape (DiscretizeShape Ename))
					)
					(DeleteEntity (list Ename))
				)
			)
			(ZoomPrevius ChechZoom)
			(if Shape 
				(setq Rtn (SortEnameByEname (LM:RemoveOnce EnameShape (LM:ss->ent (ssget "_CP" Shape $FilterList)))))
			)
			(if (null Rtn)
				(setq Rtn (list EnameShape))
				(setq Rtn (cons EnameShape Rtn))
			)
		)
	)
	Rtn
)
;
;
(defun RebuildList (List1 List2 Verbose / MyMember ReplaceEach RemoveEach FormatList RemoveExtraParent
											 Rtn)

	; (setq List1 '(   "A" (( "H" ( "I" "L" ))                                  )))
	; (setq List2 '(   "B" (( "H" ( "I" "L" )) ( "D" ( "E" "F" )) "A"           )))
	;  Rtn -----> '(   "B" (( "D" ( "E" "F" )) ( "A" (("H"  ( "I" "L" )))       ))))
	
	; (setq List1 '(   "B" ("D" "E" "F") ( "A" ( "H" "I" "L" ))))
	; (setq List2 '(   "C" ("H" "I" "L")  "G" ("D" "E" "F")  ("A" ("H" "I" "L")) "B" ))
	;  Rtn  ----> '(   "C" ("G"  ("B" ("D" "E" "F") ("A" ("H" "I" "L")))))
	;              

	
	(defun MyMember (xEname lEname / L1 L2 Loop Num Rtn)
		(if (and xEname lEname)
			(progn
				(setq L1 (LM:flatten xEname))
				(setq L2 (LM:flatten lEname))
				(setq Loop T)
				(setq Num  0)
				(setq Rtn  T)
				(while Loop
					(if (not (member (nth Num L1) L2))
						(setq Rtn nil
						      Loop nil
						)
					)
					(setq Num (1+ Num))
					(if (> Num (- (length L1) 1))
						(setq Loop nil)
					)
				)
			)
		)
		Rtn
	)
	;
	;
	(defun ReplaceEach (New Old l All / Replace Rtn Num)
	
		(setq Num 0)
		;
		; Main
		;
		(defun Replace (New Old l All / Rtn)
			(cond 
				((null l) 
					nil
				)
				((atom (car l))
					(cond 
						((equal Old (car l))
						
							(if All
								(setq Rtn New)
								(if (= Num 0)
									(progn
										(setq Rtn New)
										(setq Num (1+ Num))
									)
									(setq Rtn Old)
								)
							)
							
							(setq Rtn (cons Rtn (Replace New Old (cdr l) ALL)))
						)
						(t 
							(setq Rtn (cons (car l) (Replace New Old (cdr l) All)))
							
						)
					)
				)
				(t 
					(setq Rtn (cons (Replace New Old (car l) All) (Replace New Old (cdr l) All)))
				)
			)
			Rtn
		)
		;
		; Main
		;
		(Replace New Old l All)
	)
	;
	;
	(defun RemoveEach (a l Sentinel / Remove 
									 Num itm Rtn)
	
		(defun Remove (itm l Sentinel / Rtn)
			(cond 
				((null l) 
					nil
				)
				((atom (car l))
					(cond 
						((equal itm (car l))
							(if (= Num 0)
								(setq Rtn Sentinel)
								(setq Rtn nil)
							)
							(setq Num (1+ Num))
							(setq Rtn (cons Rtn (Remove itm (cdr l) Sentinel)))
						)
						(t 
						    (setq Rtn (cons (car l) (Remove itm (cdr l) Sentinel)))
							
						)
					)
				)
				(t 
					(setq Rtn (cons (Remove itm (car l) Sentinel) (Remove itm (cdr l) Sentinel)))
				)
			)
			Rtn
		)
		;
		; Main
		;
		(if (and a l Sentinel)
			(progn
				(setq Rtn l)
				(setq Num 0)
				(foreach itm (LM:flatten a)
					(setq Rtn (Remove itm Rtn Sentinel))
				)
			)
		)
		Rtn
	)
	;
	;
	(defun RemoveExtraParent (Lst / Strip)

		; (((A)) ((D ((E F))))) -> ((A) (D (E F)))
		
		(defun Strip (lst)
			(if (or (null lst) (atom lst) (not (null (cdr lst))))
				lst
				(Strip (car lst))
			)
		)
		
		(cond 
			((or (null lst) (atom lst))
				lst
			)
			((null (Strip (car lst)))
				(RemoveExtraParent (cdr lst))
			)
			(t
				(Strip (append (RemoveExtraParent (Strip (car lst))) (RemoveExtraParent (cdr lst))))
			)
		)
	)
	;
	;
	(defun FormatList (l / itm Tmp Rtn)
		; (FormatList '("C" ((nil) "G" (nil) (((nil)))))) 	---> ("C" ("G"))
		;
		; Main
		;
		(foreach itm l
			(if (= (type itm) 'LIST)
				(if (setq Tmp (FormatList itm))
					(setq Rtn (append Rtn (list Tmp)))
				)
				(if itm
					(setq Rtn (append Rtn (list itm)))
				)
			)
		)
		Rtn
	)	
	;
	; Main
	;
	(if (and List1 List2)
		(progn
			(if (MyMember List1 List2)
				(progn
					(setq Rtn    (RemoveEach List1 List2 "void"))
					(if Verbose 
						(progn
							(princ "\n**************************\n")
							(princ "RemoveEach         ") (princ Rtn)
						)
					)
					(setq Rtn (ReplaceEach List1 "void" Rtn nil))
					(if Verbose 
						(progn
							(princ "\n**************************\n")
							(princ "ReplaceEach        ") (princ Rtn)
						)
					)
					(setq Rtn    (FormatList Rtn))
					(if Verbose
						(progn
							(princ "\n**************************\n")
							(princ "FormatList         ") (princ Rtn)
							(princ "\n")
						)
					)
					;(setq Rtn    (RemoveExtraParent Rtn))
					;(princ "RemoveExtraParent  ") (princ Rtn)
					;(princ "\n**************************\n")
				)
			)
		)
	)
	Rtn
)
;
;
(defun SystemResolution (ListSystem Verbose / SortSystem
												Loop Num Pos TmpLst Rtn)

	(defun SortSystem (ListSystem / itm Flat Rtn)
		(foreach itm ListSystem
			(setq Flat (append Flat (list (list (length (LM:flatten itm))
										        itm))))
		)
		(if Flat
			(foreach itm (vl-sort Flat (function (lambda (e1 e2)  (< (car e1) (car e2)))))
				(setq Rtn (append Rtn (list (cadr itm))))
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if ListSystem
		(progn
			(setq ListSystem (SortSystem ListSystem))
			
			(setq Loop T)
			(setq Pos 0)
			(setq Num (1+ Pos))
			
			
			(while Loop
				(if (setq TmpLst (RebuildList (nth Pos ListSystem) (nth Num ListSystem) Verbose))
					(setq ListSystem (subst TmpLst (nth Num ListSystem) ListSystem))
				)
				(setq Num (1+ Num))
				;(princ "\********************************")
				;(princ  ListSystem)
				;(getstring "\n<>")
				;(princ "\********************************")
				
				(if (> Num (- (length ListSystem) 1))
					(progn
						(setq Pos (1+ Pos))
						(setq Num (1+ Pos))
					)
				)
				(if (>= Pos (- (length ListSystem) 1))
					(setq Loop nil)
				)
			)
			
			(setq Rtn (car (reverse ListSystem)))
		)
	)
	Rtn
)
;
;
(defun ResolutionNetedShape (ResultSystemShape / Rtn)
	;
	; (setq ResultSystemShape '(L (I (A B C) (D (E F G)) (H))))
	; (setq ResultSystemShape '(A (B D) (C))
	;
	(defun ScanEach (l / Scan 
						 Num Rtn)
	
		(defun Scan (l / Rtn)
			(cond 
				((null l) 
					nil
				)
				((atom (car l))
					(setq Rtn (append Rtn (list (car l))))
				(progn
					(setq Rtn (append Rtn (list (car itm))))
		)
	)
		
		
		
		
			(cond 
				((null l) 
					nil
				)
				((atom (car l))
					(if (= Num 1)
						(progn
							(setq TmpLst (list (car l)))
							(setq Num 0)
						)
						(setq Rtn (append TmpLst (list (car l))))
					)
					(setq Rtn (cons Rtn (Scan (cdr l))))
				)
				(t 
					(setq Rtn (cons (Scan (car l)) (Scan (cdr l))))
					;(setq Rtn (Scan (car l)))
				)
			)
			Rtn
		)
		;
		; Main
		;
		(if l
			(progn
				(setq Num 1)
				(setq Rtn (Scan l))
			)
		)
		Rtn
	)
	;(if ResultSystemShape
	;	(setq Rtn (ScanEach ResultSystemShape))
	;)
	(setq LstTmp nil)
	(setq Rtn    nil)
	
	(foreach itm ResultSystemShape
		(if (atom itm)

			(setq Rtn (append Rtn (list itm)))

			(setq Rtn (append Rtn (list (car itm))))
		)
	)
	
	Rtn
)
;
;