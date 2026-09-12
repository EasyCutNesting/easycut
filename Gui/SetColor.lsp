(defun Set_Color_Length (Lg / tonalita saturazione luminosita 
							 valutazione ton_min ton_max sat_min sat_max lum_min lum_max
							 rapporto ton sat lum rgb_c aci_c true_c strrgb out)
;
; ------------------------    PARAMETRI DI CONTROLLO COLORE
;
	(setq tonalita    (list 0 350))
	(setq saturazione (list 70 100))
	(setq luminosita  (list 30 70))
;
; ------------------------    PARAMETRI DI CONTROLLO COLORE
;
	
	(setq valutazione  (atof Lg)             ; spessore
		  min_  1                            ; valutato sullo spessore
		  max_  13000                        ; valutato sullo spessore
	)
	(if (< valutazione min_) (setq min_ valutazione))
	(if (> valutazione max_) (setq max_ valutazione))
		
	(setq ton_min (nth 0 tonalita))
	(setq ton_max (nth 1 tonalita))
	(setq sat_min (nth 0 saturazione))
	(setq sat_max (nth 1 saturazione))
	(setq lum_min (nth 0 luminosita))
	(setq lum_max (nth 1 luminosita))
	(setq rapporto     (/ (- valutazione min_) (-  max_  min_)))
	(setq ton (+ ton_min (* rapporto (- ton_max ton_min))))
	(setq sat (+ sat_min (* rapporto (- sat_max sat_min))))
	(setq lum (+ lum_min (* rapporto (- lum_max lum_min))))
	(setq rgb_c  (HSL->RGB ton sat lum))
	(setq aci_c  (RGB->ACI (nth 0 rgb_c) (nth 1 rgb_c) (nth 2 rgb_c)))
	(setq true_c (HSL->True ton sat lum))
	(setq out (list aci_c true_c))
)
;
;
;
(defun set_color (Thk / tonalita saturazione luminosita 
							 valutazione ton_min ton_max sat_min sat_max lum_min lum_max
							 rapporto ton sat lum rgb_c aci_c true_c strrgb out)
;
; ------------------------    PARAMETRI DI CONTROLLO COLORE
;
	(setq tonalita    (list 0 350))
	(setq saturazione (list 70 100))
	(setq luminosita  (list 30 70))
;
; ------------------------    PARAMETRI DI CONTROLLO COLORE
;
	
	(setq valutazione  (atof Thk)             ; spessore
		  min_  1                             ; valutato sullo spessore
		  max_  100                           ; valutato sullo spessore
	)
	(if (< valutazione min_) (setq min_ valutazione))
	(if (> valutazione max_) (setq max_ valutazione))
		
	(setq ton_min (nth 0 tonalita))
	(setq ton_max (nth 1 tonalita))
	(setq sat_min (nth 0 saturazione))
	(setq sat_max (nth 1 saturazione))
	(setq lum_min (nth 0 luminosita))
	(setq lum_max (nth 1 luminosita))
	(setq rapporto     (/ (- valutazione min_) (-  max_  min_)))
	(setq ton (+ ton_min (* rapporto (- ton_max ton_min))))
	(setq sat (+ sat_min (* rapporto (- sat_max sat_min))))
	(setq lum (+ lum_min (* rapporto (- lum_max lum_min))))
	(setq rgb_c  (HSL->RGB ton sat lum))
	(setq aci_c  (RGB->ACI (nth 0 rgb_c) (nth 1 rgb_c) (nth 2 rgb_c)))
	(setq true_c (HSL->True ton sat lum))
	(setq out (list aci_c true_c))
)
;
;
;
(defun get_kgmt_min_max ( / lista_out lista_nomi_profili nome_profilo
				  	        dati_pro classe_pro kg_mt max_kg_mt new_atom old_atom lista_out)

	(setq lista_out nil)
	(setq lista_nomi_profili (get_lista_nomi_profili))
	(if lista_nomi_profili 
		(progn
			(foreach nome_profilo lista_nomi_profili
					(setq dati_pro  (get_info_prof nome_profilo 7.85))
					(setq classe_pro (nth 21 dati_pro))
					
					(if (= classe_pro "0") (progn (princ dati_pro) (terpri)))
					
					(setq kg_mt 	 (atof (nth 8 dati_pro)))
					;(if (= classe_pro "2") (progn (princ kg_mt) (terpri)))
					
					(if (assoc classe_pro lista_out)
						(progn
							(setq new_atom  (assoc classe_pro lista_out))
							(setq min_kg_mt (nth 0 (cdr new_atom)))
							(setq max_kg_mt (nth 1 (cdr new_atom)))
							
							;(if (= classe_pro "2") (progn (princ min_kg_mt) (princ max_kg_mt) (terpri)(getstring)) ) 
							
							(if (> kg_mt max_kg_mt)
								(setq new_atom  (cons classe_pro (list min_kg_mt kg_mt)))
							)
							(if (< kg_mt min_kg_mt)
								(setq new_atom  (cons classe_pro (list kg_mt max_kg_mt)))
							)
							
							(setq old_atom  (assoc classe_pro lista_out))
							(setq lista_out (subst new_atom old_atom lista_out))
							
						)
						(progn
							(setq lista_out (append lista_out (list (cons classe_pro (list kg_mt kg_mt)))))
							;(if (= classe_pro "2") (progn (princ (cons classe_pro (list kg_mt kg_mt))) (terpri)))
						)
					)
			)
		)
	)
	(setq lista_kg_max_min$ lista_out)
)
;
;
;
(defun HSL->RGB ( h s l / u v )
    (setq h (/ h 360.0)
          s (/ s 100.0)
          l (/ l 100.0)
    )
    (cond
        (   (zerop s)
            (setq l (fix (+ 0.5 (* 255.0 l))))
            (list l l l)
        )
        (   (zerop l)
           '(0 0 0)
        )
        (   (if (< l 0.5)
                (setq v (* l (1+ s)))
                (setq v (- (+ l s) (* l s)))
            )
            (setq u (- (* 2.0 l) v))
            (mapcar
                (function
                    (lambda ( h )
                        (setq h (rem (1+ h) 1))
                        (cond
                            (   (< (* 6.0 h) 1.0)
                                (fix (+ 0.5 (* 255.0 (+ u (* 6.0 h (- v u))))))
                            )
                            (   (< (* 2.0 h) 1.0)
                                (fix (+ 0.5 (* 255.0 v)))
                            )
                            (   (< (* 3.0 h) 2.0)
                                (fix (+ 0.5 (* 255.0 (+ u (* 6.0 (- (/ 2.0 3.0) h) (- v u))))))
                            )
                            (   (fix (+ 0.5 (* 255.0 u))))
                        )
                    )
                )
                (list (+ h (/ 1.0 3.0)) h (- h (/ 1.0 3.0)))
            )
        )
    )
)
;
;
;
(defun RGB->ACI ( r g b / c o )
    (if (setq o (vla-getinterfaceobject (LM:acapp) (strcat "autocad.accmcolor." (substr (getvar 'acadver) 1 2))))
        (progn
            (setq c (vl-catch-all-apply '(lambda ( ) (vla-setrgb o r g b) (vla-get-colorindex o))))
            (vlax-release-object o)
            (if (vl-catch-all-error-p c)
                (prompt (strcat "\nError: " (vl-catch-all-error-message c)))
                c
            )
        )
    )
)
;
;
;
(defun True->HSL ( c )
    (apply 'RGB->HSL (True->RGB c))
)
;
;
;
(defun HSL->True ( h s l )
    (apply 'RGB->True (HSL->RGB h s l))
)
;
;
;
(defun RGB->True ( r g b )
    (logior (lsh (fix r) 16) (lsh (fix g) 8) (fix b))
)
;
;
;
(defun True->RGB ( c )
    (mapcar '(lambda ( x ) (lsh (lsh (fix c) x) -24)) '(8 16 24))
)
;
;
;
(defun LM:acapp nil
    (eval (list 'defun 'LM:acapp 'nil (vlax-get-acad-object)))
    (LM:acapp)
)


;
;
;
(defun ChangeColor (ssname_entita colore62 colore420 / nome lista)
       
       (if (and ssname_entita)
           (progn
                       (setq nome  ssname_entita)
                       (setq lista (entget nome))
					   (if colore62
							(progn
								(if (assoc 62 lista)
									(setq lista (subst (cons 62 colore62) (assoc 62 lista) lista))
									(setq lista (append lista (list (cons '62 colore62))))
								)
							)
						)
					   (if colore420
							(progn
								(if (assoc 420 lista)
									(setq lista (subst (cons 420 colore420) (assoc 420 lista) lista))
									(setq lista (append lista (list (cons '420 colore420))))
								)
							)
						)
						
                       (entmod lista)
                       (entupd nome)
           )
       )
)