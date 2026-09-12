;https://www.cadtutor.net/forum/topic/55408-optimizing-cutting-rebars-for-least-waste/
;http://www.theswamp.org/index.php?topic=48889.0
;(setq LstPieces (list 100.0 200.0 300.0 400.0 505.0 601.0 700.0 880.0 199.0 100.0 110.0))
;(setq LstLgBar  (list 6000.0 6500.0 7000.0 5000.0 4500.0))
;
(defun tt (/ LstPieces Pos)
	(setq LstPieces (list 1 2 3 4 5 6 7 8 9 10 11 12
						  13 14 15 16 17 18 19 20))
	(setq Pos 1)
	(repeat (length LstPieces)
		(princ (strcat "\r combinazione pezzo " (LM:rtos Pos 2 0)))
		(CombineList LstPieces Pos)
		(setq Pos (1+ Pos))
	)
	(princ)
)

(defun NestBar01 (/ ValueNotAllocated RebuildList AssocPiecesAllocated
					LstPieces LstLgBar
					LstPiecesAllocated LstPiecesNotAllocated DataPiecesAllocated itm)

	(defun ValueNotAllocated (LstPiecesAllocated LstPieces / Pos LstPosPieces itm Storage)
	
		;(foreach itm LstPiecesAllocated
		;	(setq Storage (append Storage (cadr itm)))
		;)
		;(foreach itm Storage
		;	(setq LstPieces (LM:SubstNth nil itm LstPieces))
		;)
		(foreach itm (cadr LstPiecesAllocated)
			(setq LstPieces (LM:SubstNth nil itm LstPieces))
		)
		
		LstPieces
	)
	;
	(defun RebuildList (LstPiecesNotAllocated / itm LstPieces)
		(foreach itm LstPiecesNotAllocated
			(if itm
				(setq LstPieces (append LstPieces (list itm)))
			)
		)
		LstPieces
	)
	;
	(defun AssocPiecesAllocated (LstPiecesAllocated LstPieces / itm Rtn)
		(if (and LstPiecesAllocated LstPieces)
			(foreach itm (cadr LstPiecesAllocated)
				(setq Rtn (append Rtn (list (nth itm LstPieces))))  
			)
		)
		Rtn
	)
	;
	; Main++
	;
	(setq LstPieces (list 550.0 550.0 550.0 550.0 550.0 550.0 550.0 550.0 550.0
						  1000.0 1000.0 1000.0))
	(setq LstLgBar  (list 6500.0))

	(foreach itm LstLgBar
		(setq LstPiecesAllocated 	(AssocPieces2Bar LstPieces itm))
		(setq LstPiecesNotAllocated (ValueNotAllocated LstPiecesAllocated LstPieces))
		(setq DataPiecesAllocated   (append DataPiecesAllocated (list (AssocPiecesAllocated LstPiecesAllocated LstPieces))))
		(setq LstPieces 			(RebuildList LstPiecesNotAllocated))

	)
	(startapp "notepad" (OutLstPiecesAllocated DataPiecesAllocated LstPiecesNotAllocated LstLgBar))
)
;
(defun OutLstPiecesAllocated (DataPiecesAllocated LstPiecesNotAllocated LstLgBar / itm)

	;(if (and DataPiecesAllocated LstPiecesNotAllocated LstLgBar)
	;	(progn
			
			(setq FileName (vl-filename-mktemp nil nil ".txt"))
			(setq Stream   (open FileName "w"))
			(write-line "" Stream)
			(write-line " +++ Nesting Bar +++" Stream)
			(write-line "" Stream)
			(write-line "" Stream)
			(setq Pos 0)
			(foreach itm LstLgBar
				(write-line (strcat "\t\tLunghezza verga " (LM:rtos itm 2 1)  " mm") Stream)
				(write-line "\t\tComposizione" Stream)
				(write-line "" Stream)
				(foreach itm1 (nth Pos DataPiecesAllocated)
					(write-line (strcat "\t\tn.1 " (LM:rtos itm1 2 1)) Stream)
				)
				(write-line "" Stream)
				(write-line (strcat "\t\tSfrido " (LM:rtos (- itm (apply '+ (nth Pos DataPiecesAllocated))) 2 1)) Stream)
				(write-line "" Stream)
				(setq Pos (1+ Pos))
			)
			(write-line "\t\tPezzi non allocati" Stream)
			(foreach itm LstPiecesNotAllocated
				(if itm
					(write-line (strcat "\t\tn.1 " (LM:rtos itm 2 1)) Stream)
				)
			)
			(write-line "" Stream)
			(write-line " --- Fine report ---" Stream)
			(close Stream)
	;	)
	;)
	FileName
)
;
(defun AssocPieces2Bar (LstPieces LgBar / MakePosPieces
										  LstPosPieces LstConsPieces Pos itm Res StepRes Rtn LstAllocated)
	
	;
	(defun MakePosPieces (LstPieces / Pos Rtn)
		(setq Pos 0)
		(repeat (length LstPieces)
			(setq Rtn (append Rtn (list Pos)))
			(setq Pos (1+ Pos))
		)
		Rtn
	)
	;
	; Main
	;
	(setq LstPosPieces  (MakePosPieces  LstPieces))
	(setq Pos 1)

	(repeat (length LstPieces)
		(princ (strcat "\r combinazione pezzo " (LM:rtos Pos 2 0)))
		(foreach itm (CombineList LstPosPieces Pos)
			;(setq LstLg (mapcar '(lambda (x) (cdr (assoc x LstConsPieces)))	itm))			
			(if (>= (setq Res (- LgBar (apply '+ (mapcar '(lambda (x) (nth x LstPieces)) itm)))) 0.0)
				(setq Rtn (append Rtn (list (list Res itm))))
			)
		)
		(setq Pos (1+ Pos))
	)
	(car (vl-sort Rtn (function (lambda (e1 e2)  (< (car e1) (car e2))))))
)
;
(defun AssocPieces (LstPieces LgBar / PosSx Res itm LstAssocPieces)
	
	(setq LstPieces (vl-sort LstPieces '>))
	(setq PosSx 1)
	(setq itm (car LstPieces))
	
	(setq LstAssocPieces (list itm))
	(setq Res (- LgBar itm))

	
	(repeat (1- (length LstPieces))
		(setq itm (nth PosSx LstPieces))
		(if (>=  (- Res itm) 0.0)
			(progn
				(setq LstAssocPieces (append LstAssocPieces (list itm)))
				(setq Res (- Res itm))
			)
		)
		(setq PosSx (1+ PosSx))
	)
	(list Res LstAssocPieces)
)

;
(defun CombineList ( l r )
   (cond
       (   (< r 2)
           (mapcar 'list l)
       )
       (   l
           (append
               (mapcar '(lambda ( x ) (cons (car l) x)) (CombineList (cdr l) (1- r)))
               (CombineList (cdr l) r)
           )
       )
   )
)
;
(defun LM:SubstNth ( a n l / i )
		(setq i -1)
		(mapcar '(lambda ( x ) (if (= (setq i (1+ i)) n) a x)) l)
)
;
(defun LM:rtos ( real units prec / dimzin result )

	;; rtos wrapper  -  Lee Mac
	;; A wrapper for the rtos function to negate the effect of DIMZIN
	
    (setq dimzin (getvar 'dimzin))
    (setvar 'dimzin 0)
    (setq result (vl-catch-all-apply 'rtos (list real units prec)))
    (setvar 'dimzin dimzin)
    (if (not (vl-catch-all-error-p result))
        result
    )
)
;
(defun LM:RemoveNth ( n l / i )
		;(LM:RemoveNth 3 '("A" "B" "C" "D" "E" "F")) ---> ("A" "B" "C" "E" "F")
		(setq i -1)
		(vl-remove-if '(lambda ( x ) (= (setq i (1+ i)) n)) l)
)
;
;++++++++++++++++++++++++++++++++++++++
;
(defun lst< ( l n )
    (vl-remove-if-not '(lambda ( x ) (< (sum x) n)) (combinations l))
)
;
(defun sum ( l )
    (apply '+ (mapcar '(lambda ( x ) (if (numberp x) x (sum x))) l))
)
; 
(defun combinations ( l )
    (defun nCr ( l r )
        (cond
            (   (< r 2)
                (mapcar 'list l)
            )
            (   l
                (append
                    (mapcar '(lambda ( x ) (cons (car l) x)) (nCr (cdr l) (1- r)))
                    (nCr (cdr l) r)
                )
            )
        )
    )
    (defun nCr< ( l r )
        (if (< 0 r)
            (append (nCr l r) (nCr< l (1- r)))
        )
    )
    (nCr< l (length l))
)
;
;++++++++++++++++++++++++++++++++++++++
;
(defun LM:Permutations ( l )
    (if (cdr l)
        (
            (lambda ( f )
                (f
                    (apply 'append
                        (mapcar
                            (function
                                (lambda ( a )
                                    (mapcar (function (lambda ( b ) (cons a b)))
                                        (LM:Permutations
                                            (   (lambda ( f ) (f a l))
                                                (lambda ( a l )
                                                    (if l
                                                        (if (equal a (car l))
                                                            (cdr l)
                                                            (cons (car l) (f a (cdr l)))
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                            l
                        )
                    )
                )
            )
            (lambda ( l ) (if l (cons (car l) (f (vl-remove (car l) (cdr l))))))
        )
        (list l)
    )
)
;
(defun combinations2 ( lst n / bits-list-m bit bits len mask result )
    (if (and (< (setq len (length lst)) 32) (< n len))
        (progn
            (setq bit  (expt 2 len)
                  mask (1- bit)
            )
            (eval
                (list 'defun 'bits-list-m '( n mask / idx result )
                    (list 'setq 'idx (1- len))
                    (list 'foreach 'bit (list 'quote (mapcar '(lambda ( x ) (setq bit (lsh bit -1))) lst))
                       '(if (/= 0 (logand bit mask))
                            (setq result (cons idx result))
                        )
                       '(setq idx (1- idx))
                    )
                   '(if (= n (length result)) result)
                )
            )
            (repeat mask
                (if (setq bits (bits-list-m n mask))
                    (setq result (cons (mapcar '(lambda ( n ) (nth n lst)) bits) result))
                )
                (setq mask (1- mask))
            )
            result
        )
    )
)
;
(defun combinations ( lst n / bits-sum bits-list-m combos )

    ;;--------------------------------------------------------------------
    ;;
    ;;  Combinations.lsp
    ;;
    ;;  Written by Michael Puckett 1999/07/30.
    ;;
    ;;  Released to public domain same date.
    ;;
    ;;--------------------------------------------------------------------
    ;;
    ;;  Written for a contest posted on comp.cad.autocad 1999/07/29.
    ;;
    ;;  See discussion here:
    ;;
    ;;  http://xarch.tu-graz.ac.at/autocad/stdlib/archive/7/msg00043.html
    ;;
    ;;  From my original coding: This can handle a maximum of 31 items
    ;;  for the combination, although if you try it with 31 items, you
    ;;  might as well go for a holiday. This ain't the fastest routine,
    ;;  but it does work (albeit tested very little).
    ;;
    ;;  The version presented here has been cleaned up but algorythmically
    ;;  is identical to the one at the link above.
    ;;
    ;;--------------------------------------------------------------------
    ;;
    ;;  Example:
    ;;
    ;;  (combinations '(A B C D E) 4)
    ;;
    ;;  Returns:
    ;;
    ;;  ((A B C D) (A B C E) (A B D E) (A C D E) (B C D E))
    ;;
    ;;--------------------------------------------------------------------
	;
    (defun bits-sum ( n / i result )
        (setq result 0)
        (repeat (setq i (1+ n))
            (setq result
                (+ result
                    (expt 2
                        (setq i (1- i))
                    )
                )
            )
        )
    )
	;
    (defun bits-list-m ( n m / power result )
        (repeat (setq power (fix (+ 1.5 (/ (log n) (log 2)))))
            (if (not (zerop (logand n (expt 2 (setq power (1- power))))))
                (setq result (cons power result))
            )
        )
        (if (eq m (length result)) result)
    )

	;
    (defun combos ( lst n / len mask bits result )
        (if (and (< (setq len (length lst)) 32) (< n len))
            (repeat (1- (setq mask (1+ (bits-sum (1- len)))))
                (if (setq bits (bits-list-m (setq mask (1- mask)) n))
					(progn
						(princ bits) (getstring "-")
						;(setq result
						;    (cons
						;        (mapcar '(lambda (m) (nth m lst)) bits)
						;        result
						;    )
						;)
						(setq result (cons bits result))
					)
					
                )
            )
        )
        result
    )

    (combos lst n)

)
;
;
(defun c:test(/ LstPieces LgBar)
	(setq Lst (list 550.0 550.0 550.0 550.0 550.0 550.0 550.0 550.0 550.0
						  1000.0 1000.0 1000.0))
	(setq LstPieces (list 550.0 551.0 552.0 553.0 554.0 555.0 556.0 557.0 558.0
						  1000.0 1001.0 1002.0))
	(setq LgBar  6500.0)

	;(setq LstPieces '(144 35 23 86 99 12 230 12 12 14 132 189 6 3 99))
	;(setq LgBar 240.0)
	(get_cutlist LstPieces LgBar)
)
;;  result ((99) (99 132) (86 144) (12 12 12 14 23 35 189) (3 6 230))

;;  CAB 03-10-06
(defun get_cutlist (lst maxlen / cutlst itm lst ptr tl x finallst remove-at)

	;
	;Main
	;
	;(setq Lst (mapcar '(lambda (x) (nth x lst)) (vl-sort-i lst '>)))
	(setq Lst (vl-sort Lst '>))
	;;  step through lst
	(while Lst
		(setq CutLst (list (car Lst)) 	; start new cutlist w/ first item
				Lst  (cdr Lst) 			; remove first item
				Ptr  (1- (length Lst)) 	; point to end of list
				Tl   (apply '+ CutLst) 	; total length so far
		)
		;; build the cutlst
		(while (and Lst CutLst)
			;; find largest next cut
			;; exit conditions ptr < 0 or itm length exceeds max
			(while (and (< (+ Tl (setq itm (nth Ptr Lst))) MaxLen) (> Ptr 0))
				(setq Ptr (1- Ptr))
			)

			(if (> Ptr -1)
				(if (= Ptr (1- (length Lst)))
					;;  no more cuts fit, go to next
					(setq finallst (cons cutlst finallst)
						  cutlst   nil
					)
					;(setq CutLst (cons (nth (1+ Ptr) Lst) CutLst)
					;		Lst  (LM:RemoveNth (1+ Ptr) Lst)
					;		Tl   (apply '+ CutLst) ; new total
					;)
					(setq CutLst (cons (nth Ptr Lst) CutLst)
							Lst  (LM:RemoveNth Ptr Lst)
							Tl   (apply '+ CutLst) ; new total
					)
				)
				;; else exausted pointer
				(setq finallst (cons cutlst finallst)
						cutlst  nil
				)
			) 
		) 
	)
	(if cutlst
		(cons cutlst finallst)
		finallst
	)
)