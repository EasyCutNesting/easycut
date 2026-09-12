;;                       Example Problems                                     ;
;; From:                                                                      ;
;; Genetic algorithms for cutting stock problems: with and without contiguity ;
;;      by Hinterding R, Khan L.                                              ;
;;                                                                            ;
;;   http://vuir.vu.edu.au/25789/1/TECHNICALREPORT40_compressed.pdf           ;
;;                                                                            ;
;; EP-Cut              by ymg                                                 ;
;;                                                                            ;
;;        A New Evolutionary Approach to Cutting Stock Problems               ;
;;                  With and Without Contiguity                               ;
;;       By: Ko-Hsin Liang, Xin Yao, Charles Newton, David Hoffman	          ;
;;  https://www.cs.bham.ac.uk/~xin/papers/COR_LiangYaoNewtonHoffman.pdf       ;
;;                                                                            ;
;; Contiguity is not implemented yet in the following                         ;
;;                                                                            ;
(defun Ep-Cut (l d ls / longlst FF-binpack rand randrng roulette checkroulette relcost swapnth shuffle shuffle2 distinct# take
						a b bc c cost gmul graf i k mn mu mx n n3ps ngen opp
						popu popuc prob  probc s st stid stidc stoc sz tsiz vexg w win)
  
			; Notes that variables bsol, bcost, bstoc, sol, costc and stocc   ;
			; are not declared so that we can inspect other solutions.        ;
			; Sample problems also will need to bet to nil manually           ;


	;
	(defun longlst (l d / i j ll)
		;; longlst                                                                    ;
		;; Expand a list of length and quantity to a                                  ;
		;; Sorted long list with repeating items                                      ;
		;;                                                                            ;
		(setq j 0)
		(foreach i d
			(repeat i (setq ll (cons (nth j l) ll)))
			(setq j (1+ j))
		)
		(mapcar '(lambda (a) (nth a ll)) (vl-sort-i ll '>))
	)
	; 
	(defun FF-binpack (l c / i b tb)
		;; FF-binpack          by ymg                                                 ;
		;; First Fit                                                                  ;
		;; Arguments: l  List of items to put in bins                                 ;
		;;            c  Capacity of a bin                                            ;
		;;                                                                            ;
		(setq r nil)
		(while l
			(setq w ls b nil)
			(while (and l (>= w (setq i (car l))))
				(setq b (cons i b)
					  w (- w i)
					  l (cdr l)
				)
			)
			(setq r (cons (list (reverse b) w) r))
		)
		(reverse r)
	)
	; 
	(defun rand (/ x)
		;; Random number generator, #s(eed) remains Global.                           ;
		(/ (setq x 4294967296.0 #s (rem (1+ (* 1664525.0 (cond (#s) ((getvar 'DATE))))) x)) x)
	)
	;
	(defun randrng (i j) (+ i (fix (* (rand) (- j i -1))))
		;; Random in range i j  (Integer Range)                                   ;
	)
	; 
	(defun roulette (l / k m n)
		;; roulette      by ymg                                                       ;
		;;                                                                            ;
		;; Roulette-Wheel Selection Via Stochastic Acceptance                         ;
		;;    by Adam Lipowski and Dorota Lipowska                                    ;
		;;          http://arxiv.org/pdf/1109.3627v2.pdf                              ;
		;;                                                                            ;
		;; Argument: l   List of Probabilities. (No need to normalize)                ;
		;; Returns : Index in List of Chosen Item According to Probabilities.         ;
		;;                                                                            ;
		(setq  m (float (apply 'max l)) n (length l))
		(while (> (rand) (/ (nth (setq k (fix (* (rand) n))) l) m)))
		k
	)
	; 
	(defun checkroulette (/ l p r c0 c1 c2 c3 c4)
		;; For Debugging Check Frquency of Returns of Roulette's Function             ;
		(setq l '((0.4 0.0 0.3 1.2 0.1)  ; Raw Probabilities                       ;
				 (0.2 0 0.15 0.6 0.05)) ; Same Probailities Normalized to 1       ;
				r nil
		)
		(foreach p l
			(setq c0 0 c1 0 c2 0 c3 0 c4 0)
			(repeat 10000
				(setq i (roulette p))
				(cond
					((= i 0)(setq c0 (1+ c0)))
					((= i 1)(setq c1 (1+ c1)))
					((= i 2)(setq c2 (1+ c2)))
					((= i 3)(setq c3 (1+ c3)))
					((= i 4)(setq c4 (1+ c4)))  
				)      
			)
			; Should return close to (2000 0 1500 6000 500)                         ;
			(setq r (cons (list c0 c1 c2 c3 c4) r))
		)
		(reverse r)
	)
	; 
	(defun relcost (l / m)
		;; relcost     by ymg                                                         ;
		;;                                                                            ;
		;; Calculates Relative Cost of Solution                                       ;
		;; From: Genetic Algorithms for Cutting Stock Problems:                       ;
		;;       With and Without Contiguity.                                         ;
		;; By Robert Hinterding & Lutfar Khan                                         ;
		;;      http://vuir.vu.edu.au/25789/1/TECHNICALREPORT40_compressed.pdf        ;
		;;                                                                            ;
		;; ls is defined in main program                                              ;
		(setq m (length l))
		(/ (apply '+
				(mapcar '(lambda (a) (+ (sqrt (/ (cadr a) (float ls)))
									 (/ (if (zerop (cadr a)) 0 1.0) m)
								  )
					  )
					  l
				)
			)
			(1+ m)
		)
	)
	; 
	(defun swapnth (n1 n2 l / i)
		;; swapnth     by CAB    (3 times faster than above)                          ;
		;;                                                                            ;
		(setq i -1)
		(mapcar '(lambda (a) (setq i (1+ i))
							(cond
							   ((= i n2) (nth n1 l))
							   ((= i n1) (nth n2 l))
							   (a)
							)
				)
				l
		)
	)
	; 
	(defun shuffle (l / a d  i  n tmp)
		; shuffle     (Original idea by highflyingbird)                               ;
		;             Simplified the code   ymg                                       ;
		(setq d (1- (length l))
			  a (vlax-safearray-fill (vlax-make-safearray vlax-vbinteger (cons 0 d)) l)                    
			  i -1
		)
		(repeat d
			(setq  i (1+ i)
				 n (+ i (fix (* (rand) (- d i))))  
			   tmp (vlax-safearray-get-element a n)
			)
			(vlax-safearray-put-element a n (vlax-safearray-get-element a i))
			(vlax-safearray-put-element a i tmp)
		)
		(vlax-safearray->list a)
	)
	 
	; 
	(defun shuffle2 (l / p i)
		; This one by Irneb, list based. Actually quite fast, and even faster once    ;
		; we replace repetitive call to function length by variable i                 ;
		; in the vl-sort-i lambda clauses.                                            ;
		(setq p (/ (setq i (length l)) 2))
		(mapcar '(lambda (n) (nth n l))
				  (vl-sort-i l '(lambda (a b) (<= (fix (* (rand) i)) p))))
	)
	; 
	(defun distinct# (l / i)
		;; distinct#    by ymg  (Derived from Distinct by Gile Chanteau               ;
		;; Returns a list of distinct Item and Quantity ((item qty)......)            ;
		;; Argument                                                                   ;
		;; l   List                                                                   ;
		;;                                                                            ;
		(if l
			(cons (cons (- (length l) (length (setq l (vl-remove (setq i (car l)) l)))) i) (distinct# l))     
		)
	)
	; 
	(defun take (n l / r)
		; take   by ymg                                                               ;
		;                                                                             ;
		; Returns the first n items from a list as a list                             ;
		;                                                                             ;
		; Iterative version of Gile Chanteau's take                                   ;
		(repeat n 
			(setq r (cons (car l) r) l (cdr l))
		)
		(reverse r)
	)
	;
	; Main
	;
	(setq   mu 75             ; Size of Population                             ;
		  tsiz 10             ; Tournament Size (Number of Opponents)          ;
		  gmul 20             ; Multiplier for Max # of Generation to Run      ;
		  n3ps  2             ; Number of 3PS Repetitions to Creates Offspring ;
		  stop 400            ; Exit Loop if Best Cost Show no Improvement     ;
	)                         
	  
	(setq popu nil)
	(setq popu (list (longlst l d)); Adding Ordered List eq. to FFD-binpack ;
			 n (length (car popu)) ; Nomber of Items to Cut                 ;
	)
	(repeat (1- mu)
		(setq popu (cons  (shuffle (car popu)) popu))
	)
	 
	; popu, Population                                                      ;
	; stoc, Population Decoded by First Fit Binpack                         ;
	; stid, Indices to popu to Start of a Cut Stock                         ;
	; prob, Probability of Selecting a Given Stock for Mutations            ;
	; cost, Relative Cost of Each Individual                                ;
	  
	(setq popu (reverse popu)
		  stoc (mapcar '(lambda (a) (ff-binpack a ls)) popu)
		  stid (mapcar '(lambda (a) (setq i 0) (cons 0 (mapcar '(lambda (a) (setq i (+ i (length (car a))))) a))) stoc)
		  prob (mapcar '(lambda (a) (mapcar '(lambda (a) (if (> (cadr a) 0) (/ 1.0 (sqrt (cadr a))) 0.01)) a)) stoc)
		  cost (mapcar 'relcost  stoc)
		 k 0
	)
	(setq bc (apply 'min cost)         ; Best Cost So Far                ;
		  bstoc stoc                      ; Copy of stoc List               ;
		  bcost cost                      ; Copy of cost List               ;
		  bk 0                         ; Generation# of Best Cost        ;
		  ngen (+ bk stop)               
	)

	(princ (strcat "\nGeneration: " (itoa k) " \\ " (itoa ngen) "   -  Min. Cost: " (rtos bc 2 9)))
	 
	; Each Idividual in Population is Mutated by 3 Point Swap (3PS)         ;
	(while (and (< (- k bk) stop) (> bc 0))
		(setq i 0 popuc nil)
		(foreach ind popu
			(setq pro (nth i prob) sti (nth i stid))
			(setq a (fix (* (rand) n)) 
					 s (roulette pro)
					mn (nth s sti)
					mx (1- (nth (1+ s) sti))
					 b (randrng mn mx)     
					 s (roulette pro)
					mn (nth s sti)
					mx (1- (nth (1+ s) sti))                
					 c (randrng mn mx)     
				   ind (swapnth a b ind) 
				   ind (swapnth a c ind) 
			)
			(setq popuc (cons ind popuc)
				  i (1+ i)
			)      
		)
		 
		(setq popuc (reverse popuc)
			  stocc (mapcar '(lambda (a) (ff-binpack a ls)) popuc)
			  stidc (mapcar '(lambda (a) (setq i 0) (cons 0 (mapcar '(lambda (a) (setq i (+ i (length (car a))))) a))) stocc)
			  probc (mapcar '(lambda (a) (mapcar '(lambda (a) (if (> (cadr a) 0) (/ 1.0 (sqrt (cadr a))) 0.01)) a)) stocc)
			  costc (mapcar 'relcost  stocc)
		   
			  popuc (append popu popuc)
			  stocc (append stoc stocc)
			  stidc (append stid stidc)
			  probc (append prob probc)
			  costc (append cost costc)
		)
	 
		; Conduct Comparisons Over the Union of Parents and Offspring        ;
		; Tournament Size is Defined at Beginning of Proram                  ;
		
		(setq i 0  u (+ mu mu) win nil b 1.0)
		(foreach c costc
			(setq w 0)
			(repeat tsiz
			   (while (= i (setq opp (fix (* (rand) u)))))
			   (if (<= c (nth opp costc)) (setq w (1+ w)))
			)
			(setq win (cons w win)
					i (1+ i)
			)      
		)
		 
		; Choose the Solution With Most Win for New Generation               ;
		
		(setq  win (take mu (vl-sort-i (reverse win) '>))
			   popu (mapcar '(lambda (a) (nth a popuc)) win)
			   stoc (mapcar '(lambda (a) (nth a stocc)) win)
			   stid (mapcar '(lambda (a) (nth a stidc)) win)
			   prob (mapcar '(lambda (a) (nth a probc)) win)
			   cost (mapcar '(lambda (a) (setq b (min b (setq a (nth a costc)))) a) win)
				  k (1+ k)
		)
				  
		(if (< b bc)
			(setq  bc b
				   bk k
				   bstoc stocc
				   bcost costc
				   ngen (+ bk stop)  
					** (princ (strcat "\rGeneration: " (itoa k) " \\ " (itoa ngen) "   -  Min. Cost: " (rtos b 2 9)))             
			)
		)  
	 ) ; Goto next generation ;
	 ; Order of the last 150 solutions in stocc                               ;
	 (setq sol (vl-sort-i bcost '<))  
	 (princ (strcat "\rGeneration: " (itoa k) " \\ " (itoa ngen) "   -  Min. Cost: " (rtos b 2 9)))
	 ; Here Sorting the Cuts in Best Solutions and Outputting                 ;
	 (setq bsol (mapcar '(lambda (a) (list (mapcar '(lambda (b) (nth b (car a))) (vl-sort-i (car a) '>)) (cadr a))) (nth (car sol) bstoc)))
	 (distinct# bsol)
)
; 