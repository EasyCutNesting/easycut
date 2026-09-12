;; 1d-csp       by ymg                                                        ;
;;                                                                            ;
;; Cutting Stock Problem as per approach described in:                        ;
;;                                                                            ;
;;               A GENERALIZED APPROACH TO THE SOLUTION                       ;
;;                  OF ONE-DIMENSIONAL STOCK-CUTTING                          ;
;;                    PROBLEM FOR SMALL SHIPYARDS.                            ;
;;              by Ahmet Cemil Dikili and Baris Barlas                        ;
;;                                                                            ;
;; Link:  http://jmst.ntou.edu.tw/marine/19-4/368-376.pdf                     ;
;;                                                                            ;
;; Argument: l   List, Demanded Lengths in Decreasing order.                  ;
;;           d   List, Number of Corresponding Demanded Length.               ;
;;          ls   Real, Length of Standard Stock.                              ;
;;                                                                            ;
;; Returns: A List of Cutting Patterns, where each member is composed         ;
;;          of 3 items as follow: Item 1, Nb of times to apply Pattern.       ;
;;                                Item 2, List of integers where each         ;
;;                                        element correspond to the nb of     ;
;;                                        times to use a demanded length.     ;
;;                                Item 3, Waste per Bar for this Pattern.     ;
;;                                                                            ;
; Notes that variables bsol, bcost, bstoc, sol, costc and stocc   ;
; are not declared so that we can inspect other solutions.        ;
; Sample problems also will need to bet to nil manually           ;
;
(defun Ld-Csp (l d ls / GenPat massoc distinct# FFD-binpack longlst pat2len len2pat
					a ch cp idx maxint p tl sm pu v)

	(defun GenPat (lenLst demLst stockLen allPatP / i j cntLst maxIdx patLst usedLen)
		;; 20150929: Fixed by Roy.
		;; 20150918: Very minor changes by Roy.
		;; GenPat                    (By Ymg)                                         ;
		;;                                                                            ;
		;; http://www.theswamp.org/index.php?topic=48889.0                            ;
		;;                                                                            ;
		;; Procedure for Generating the Efficient Feasible Cutting Patterns           ;
		;; http://www.cs.bham.ac.uk/~wbl/biblio/gecco2006/docs/p1675.pdf              ;
		;; Appendix 1                                                                 ;
		;; Part of "Cutting Stock Waste Reduction Using Genetic Algorithms"           ;
		;;              by Y. Khalifa, O. Salem and A. Shahin                         ;
		;;                                                                            ;
		;; Argument: lenLst     List, Demanded Lengths in Descending Order.           ;
		;;           demLst     List, Number of Corresponding Demanded Length.        ;
		;;           stockLen   Real, Length of Standard Stock.                       ;
		;;           allPatP    Boolean, if true,  Generate all Feasible Patterns.    ;
		;;                               if false, Generate only the Set of Patterns  ;
		;;                                         for the First Demand > 0.          ;
		(setq maxIdx (length lenLst))
		(setq i 0)
		(while (zerop (nth i demLst)) (setq i (1+ i)))
		(while
			(or
				(not cntLst)
				(if allPatP
					(> (apply '+ cntLst) 0)
					(> (nth i (reverse cntLst)) 0)
				)
			)
			(cond
				(cntLst
					(while (zerop (car cntLst)) (setq cntLst (cdr cntLst))) ; Last item in cntLst is for the first item (= longest) in lenLst.
					(setq cntLst (cons (1- (car cntLst)) (cdr cntLst)))
					(setq j (length cntLst))
					(setq usedLen (apply '+ (mapcar '(lambda (cnt len) (* cnt len)) (reverse cntLst) lenLst)))
				)
				(T
					(setq j 0)
					(setq usedLen 0.0)
				)
			)
			(while (< j maxIdx)
				(setq cntLst (cons (min	(fix (/ (- stockLen usedLen) (nth j lenLst))) (nth j demLst)) cntLst))
				(setq usedLen (+ usedLen (* (car cntLst) (nth j lenLst))))
				(setq j (1+ j))
			)
			(setq patLst (cons (reverse cntLst) patLst))
		)
		(reverse (cdr patLst)) ; Remove 'zero pattern'.
	)
	;
	(defun massoc (k l / i)       ; recursive version    ;
		;; massoc                                                                     ;
		;;                                                                            ;
		;; Returns a list of all items associated with the specified key              ;
		;; in an association list.                                                    ;
		;;                                                                            ;
		;; Arguments:                                                                 ;
		;;    k,  The value to search for in the list.                                ;
		;;    l,  List of Associations                                                ;
		;;                                                                            ;
		(if (setq i (assoc k l))
			(cons (cdr i) (massoc k (cdr (member i l))))
		)
	)
	;
	(defun distinct# (l / i)
		;; distinct#    by ymg  (Derived from Distinct by Gile Chanteau               ;
		;; Returns a list of distinct Item and Quantity ((item qty)......)            ;
		;; Argument                                                                   ;
		;; l   List                                                                   ;
		;;                                                                            ;
		; Modified to return ((qty (pattern) waste) (...) (...))
		(if l
			(cons (cons (- (length l) (length (setq l (vl-remove (setq i (car l)) l)))) i) (distinct# l))     
		)
	)
	; 
	(defun FFD-binpack (l c / i b tb)
		;; FFD-binpack         by ymg                                                 ;
		;; First Fit Decreasing                                                       ;	
		;; Arguments: l  List of items to put in bins                                 ;
		;;            c  Capacity of a bin                                            ;
		;;                                                                            ;
		(foreach  i (vl-sort-i l '>)
			(setq i (nth i l) tb nil)
			(cond      
				(b (while (and (> i (cadar b)) b)
						(setq tb (cons (car b) tb)  b (cdr b))
					)
					(setq b (append (reverse (cons (list (reverse (cons i (reverse (caar b))))(if (cadar b) (- (cadar b) i) (- c i))) tb)) (cdr b)))
				)
				(t (setq b (list (list (list i) (- c i)))))
			)          
		)
	)
	;
	(defun longlst (l d / i j ll)
		;; longlst                                                                    ;
		;; Expand a list of length and quantity into a long list with repeating items ;
		;;                                                                            ;
		(setq j 0)
		(foreach i d
			(repeat i (setq ll (cons (nth j l) ll)))
			(setq j (1+ j))
		)
		ll
	)
	; 
	(defun pat2len (p l /  r)
		;; pat2len                                                                    ;
		;; Expand a pattern to length                                                 ;
		;; (0 2 0 1 0) -> (l1 l1 l3)                                                  ;
		(while p
			(repeat (car p) (setq r (cons (car l) r)))
			(setq l (cdr l) p (cdr p))
		)
		(reverse r)
	)
	;
	(defun len2pat (p l)
		;; len2pat                                                                    ;
		;; Inverse of pat2len                                                         ;
		;; (l1 l1 l3) -> (0 2 0 1 0)                                                  ;
		(setq p (mapcar '(lambda (a) (cons (cdr a) (car a))) (distinct# p)))
		(mapcar '(lambda (a) (if (setq c (assoc a p)) (cdr c) 0)) l)  
	)  
	;
	; MAIN
	;
	(setq maxint 2147483647)
		
	(while  (> (apply '+ d) 0)
		(setq v (genpat l d ls nil) p nil)      
		(foreach a v
			(setq 	tl (- ls (apply '+ (mapcar '(lambda (a l) (* a l)) a l)))
					sm (apply 'min (mapcar '(lambda (a d) (if (> a 0) (/ d a) maxint)) a d))
					pu (* sm (apply '+ a))
					p (cons (list a tl sm pu) p)
			)
		)
		; Here we Sort the Set of Patterns on Min tl, Max sm and Min pu         ;
		; The Chosen Pattern will bubble up to top of the list.                 ;
 
		(setq p (vl-sort (reverse p) 	'(lambda (a b) 	(if (= (cadr a) (cadr b))
														(if (= (caddr a) (caddr b))
															(< (cadddr a) (cadddr b))  
															(> (caddr a) (caddr b))
														)     
														(< (cadr  a) (cadr  b))
													)
									)
			)
		)
		; Building the Cutting Plan, then Adjusting the Demand List.            ;
		;(if (not (setq i (getint "\nChoose pattern : "))) 0)
		(setq ch (car p))
		(setq cp (cons (list (caddr ch) (pat2len (car ch) l) (cadr ch) ) cp))
		(setq  d (mapcar '(lambda (d p) (- d (* p (caddr ch)))) d (car ch)))    
	)   
	(reverse cp)	
)
;
