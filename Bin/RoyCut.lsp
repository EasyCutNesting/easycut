; Testing with CAB's example.
; (c:Roy_Cut_Test)
;   => (
;        (44 (9.71) 101.2)
;        (23 (7.65 4.0) 8.28) 
;        (10 (5.3 4.0 2.66) 0.5) 
;        (29 (4.0 4.0 4.0) 0.29) 
;        (19 (3.67 2.66 2.66 2.66) 6.84) 
;        (11 (3.67 3.67 3.67) 11.0) 
;        (1 (3.67 3.67) 4.67)
;      )
;
;      137 Standard lengths
(defun Roy_Cut (l d Ls / MakeListPieces Roy_Cut_Patterns Roy_Cut_PatternsSort Roy_Cut_PatternIndexList Roy_Cut_RemovePattern
						 _List_DuplicateRemoveAll _List_IndexListRemove _List_IndexSeqMakeLength
						 todoLst doneLst Rtn patternAndRest tmpLst)

	(defun MakeListPieces (l d / Pos itm Rtn)
		(setq Pos 0)
		(foreach itm l
			(repeat (nth Pos d)
				(setq Rtn (append Rtn (list itm)))
			)
			(setq Pos (1+ Pos))
		)
		Rtn
	)

	;
	(defun Roy_Cut_Patterns (todoLst doneLst rest)
		;(Roy_Cut_Patterns '(9 3 3 3 2 2 1) '(9) 3)
		;   => (((9 3) 0) ((9 3) 0) ((9 3) 0) ((9 2 1) 0) ((9 2 1) 0) ((9 1 1) 1))
	  (cond
		(
		  (apply
			'append
			(mapcar
			  '(lambda (len)
				(if (<= len rest)
				  (Roy_Cut_Patterns
					(setq todoLst (cdr todoLst))
					(append doneLst (list len))
					(- rest len)
				  )
				)
			  )
			  todoLst
			)
		  )
		)
		(
		  (list (list doneLst rest))
		)
	  )
	)
	;
	(defun Roy_Cut_PatternsSort (lst)
		; (Roy_Cut_PatternsSort (Roy_Cut_Patterns '(9 3 3 3 2 2 1) '(9) 3))
		;   => (((9 3) 0) ((9 2 1) 0) ((9 1 1) 1))
	 (vl-sort
		(_List_DuplicateRemoveAll lst) ; Required.
		'(lambda (a b)
		  (or
			(< (cadr a) (cadr b)) ; Compare rest.
			(and
			  (= (cadr a) (cadr b))
			  (< (length (car a)) (length (car b))) ; Compare number of lengths.
			)
		  )
		)
	  )
	)
	; 
	(defun Roy_Cut_PatternIndexList (todoLst pattern / idx idxLst)
		; (Roy_Cut_PatternIndexList '(9 9 3 3 3 2 2 1) '(3 2)) => (2 5)
	  (setq idx -1)
	  (if
		(not
		  (vl-position
			nil
			(setq idxLst
			  (mapcar
				'(lambda (itm / fndIdx)
				  (if (setq fndIdx (vl-position itm todoLst))
					(progn
					  (setq todoLst (cdr (member itm todoLst)))
					  (setq idx (+ fndIdx idx 1))
					)
				  )
				)
				pattern
			  )
			)
		  )
		)
		idxLst
	  )
	)
	; 
	(defun Roy_Cut_RemovePattern (todoLst pattern / cnt idxLst)
		; Format of return:
		; (newTodoLst numberOfOccurences)
	  (setq cnt 0)
	  (while (setq idxLst (Roy_Cut_PatternIndexList todoLst pattern))
		(setq cnt (1+ cnt))
		(setq todoLst (_List_IndexListRemove todoLst idxLst))
	  )
	  (list todoLst cnt)
	)
	;
	(defun _List_DuplicateRemoveAll (lst / ret)
		; (_List_DuplicateRemoveAll '(nil (1 1) nil (1 1) 3 5 6 7 3 7 7 3 nil)) => (NIL (1 1) 3 5 6 7)
	  (mapcar
		'(lambda (itm) (if (not (vl-position itm ret)) (setq ret (cons itm ret))))
		lst
	  )
	  (reverse ret)
	)
	;
	(defun _List_IndexListRemove (lst idxLst)
		; (_List_IndexListRemove '("a" "b" "c" "d" "e" "f") '(0 1 5)) => ("c" "d" "e")
	  (apply ; A (vl-remove nil ...) structure is impossible here.
		'append
		(mapcar
		  '(lambda (idx itm) (if (not (vl-position idx idxLst)) (list itm)))
		  (_List_IndexSeqMakeLength (length lst))
		  lst
		)
	  )
	)
	;
	(defun _List_IndexSeqMakeLength (len / ret)
		; Make a zero based list of integers.
		; With speed improvement based on Reini Urban's (std-%setnth).
		; (_List_IndexSeqMakeLength 7) => (0 1 2 3 4 5 6)
	  (repeat (rem len 4)
		(setq ret (cons (setq len (1- len)) ret))
	  )
	  (repeat (/ len 4)
		(setq ret
		  (vl-list*
			(- len 4)
			(- len 3)
			(- len 2)
			(- len 1)
			ret
		  )
		)
		(setq len (- len 4))
	  )
	  ret
	)
	;	
	;Main
	;
	; (Roy_Cut '(9 9 3 2 2 2 2 1 1) 12)
	; Format of return:
	; ((numberOfOccurences (pattern as list of lengths) totalWaste) ...)
	;
	(setq todoLst (MakeListPieces l d))
	(setq todoLst (mapcar '(lambda (x) (nth x todoLst)) (vl-sort-i todoLst '>)))	
	
	(while todoLst
		(setq patternAndRest
			(car
				(Roy_Cut_PatternsSort
					(Roy_Cut_Patterns
										(cdr todoLst)
										(list (car todoLst))
										(- Ls (car todoLst))
					)
				)
			)
		)
		(setq tmpLst (Roy_Cut_RemovePattern todoLst (car patternAndRest)))
		(setq doneLst
					(cons
						(list
							(cadr tmpLst)        ; Number of occurences.
							(car patternAndRest) ; Pattern.
							(* (cadr tmpLst) (cadr patternAndRest)) ; Total waste.
						)
						doneLst
					)
		)
		(setq todoLst (car tmpLst))
	)
	(reverse doneLst)
	; change array
	(foreach i doneLst
		(setq Rtn (append Rtn (list (list (car i) (cadr i) (/ (caddr i) (car i))))))
	)
	Rtn
)
;

