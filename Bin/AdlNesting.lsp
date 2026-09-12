;https://www.cadtutor.net/forum/topic/55408-optimizing-cutting-rebars-for-least-waste/
;http://www.theswamp.org/index.php?topic=48889.0
(defun MyNstBar (l d ls / MakeListpieces RemoveNth RemoveItemsFromList AssocPieces Distinct#
					   Loop LstPieces Rtn Patterns l bins itm p)

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
	(defun RemoveNth ( n l / i )
		;(LM:RemoveNth 3 '("A" "B" "C" "D" "E" "F")) ---> ("A" "B" "C" "E" "F")
		(setq i -1)
		(vl-remove-if '(lambda ( x ) (= (setq i (1+ i)) n)) l)
	)
	;
	(defun RemoveItemsFromList (ListPiecese Patterns / itm ListPiecese)
		(if (and ListPiecese Patterns)
			(foreach itm Patterns
				;(setq ListPiecese (LM:RemoveNth (GetNth ListPiecese itm) ListPiecese))  
				(setq ListPiecese (RemoveNth (if (member itm ListPiecese)
													(- (length ListPiecese) (length (member itm ListPiecese)))
											 ) 
											 ListPiecese))  
			)
		)
		ListPiecese
	)
	;
	(defun AssocPieces (LstPieces Ls / Pos Loop Res itm LstAssocPieces)
		
		(setq Res Ls)
		(setq Pos 0)
		
		(while (and (>= Res 0.0) (< Pos (length LstPieces)))
			(setq itm (nth Pos LstPieces))
			(if  (>=  (- Res itm) 0.0)
				(progn
					(setq LstAssocPieces (append LstAssocPieces (list itm)))
					(setq Res (- Res itm))
				)
			)
			(setq Pos (1+ Pos))
		)
		LstAssocPieces
	)	
	;
	(defun Distinct# (l)
		(if l
			(cons (list (car l) (- (length l) (length (setq l (vl-remove (car l) l))))) (distinct# l))     
		)
	)
	;
	; Mian
	;
	(setq Loop T)
	(setq LstPieces (MakeListPieces l d))
	(setq LstPieces (mapcar '(lambda (x) (nth x LstPieces)) (vl-sort-i LstPieces '>)))
	
	(while Loop
		(if (setq Rtn (AssocPieces LstPieces Ls))
			(progn
				(setq Patterns (append Patterns (list Rtn)))
				(setq LstPieces (RemoveItemsFromList LstPieces Rtn))
			)
			(setq Loop nil)
		)
	)
	(setq bins (distinct# Patterns))
	(foreach itm bins
		(setq p (cons (reverse (cons (- ls (apply '+ (car itm))) itm)) p))
	)
	(reverse p)
)
;
