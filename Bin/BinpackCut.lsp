;; binpack-cut               by ymg                                           ;
;;                                                                            ;
;;                                                                            ;
;;                                                                            ;
;; Will return a Patterns List for Cutting the Demanded Lengths               ;
;;         
(defun Pinpack-Cut (l d ls / distinct# FFD-binpack longlst
							 bins i p )


	(defun distinct# (l)
		;; distinct#    by ymg  (Derived from Distinct by Gile Chanteau               ;
		;; Returns a list of distinct Item and Quantity ((item qty)......)            ;
		;; Argument                                                                   ;
		;; l   List                                                                   ;
		;;                                                                            ;
		(if l
			(cons (list (car l) (- (length l) (length (setq l (vl-remove (car l) l))))) (distinct# l))     
		)
	)
	;
	(defun FFD-binpack (l c / i b tmp)
		;; FFD-binpack         by ymg    (Simplified Gile Chanteau's solution.        ;
		;; First Fit Decreasing                                                       ;
		;; Arguments: l  List of items to put in bins                                 ;
		;;            c  Capacity of a bin                                            ;
		;;                                                                            ;
		(foreach  i (vl-sort-i l '>)
			(setq i (nth i l)  tmp nil)
			(cond   (b (while (and (> i (- c (apply '+ (car b)))) b)
						(setq tmp (cons (car b) tmp)  b (cdr b))
					  )	  
					  (setq b (append (reverse (cons (reverse (cons i (car b))) tmp)) (cdr b)))               
					)
					(t (setq b (list (list i))))
			)
		)
	)
	; 
	(defun longlst (l d / i j ll)
		; Expand a list of length and quantity into a long list with repeating items  ;
		(setq j -1)
		(foreach i d
			(setq j (1+ j))
			(repeat i (setq ll (cons (nth j l) ll)))
		)
	)
	;
	; MAIN
	;
	(setq bins (distinct# (ffd-binpack (longlst l d) ls)))
	(foreach i bins
		(setq p (cons (reverse (cons (- ls (apply '+ (car i))) i)) p))
	)
	(reverse p)
)	
;
