;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;
;       interpreti programmi
;       1_ codice essi per FRO       (interprete_essi_fro)
;       2_ codice essi per ESAB      (interprete_essi_esab)
;       3_ codice iso  per KOIKE     (interprete_iso_koike)
;       4_ codice iso  per SOITAAB   (interprete_iso_soi)
;
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;
;
;**********************************
;      INTERPRETE_ESSI_ESAB
;**********************************
(defun PostProEssiEsab (FileIn FileOut / fin fout riga start trovato_compensa
                            testa marca tipo_cont perc_cont compensa aperta
                            x_r y_r bingobongo x_coord y_coord sposta
                            x_r y_r x_c y_c ra d_x_r d_y_r d_x_c d_y_c out_loc 
							WriteSpeed preci$ PreciCut Speed)
    ;
    ; procedura di conversione formato neutro to ESSI ESAB
    ;
	(setq preci$ 0.01)
	(setq PreciCut 1)
	(setq WriteSpeed T)

    (setq fin (open  FileIn "r") 
          fout (open FileOut "w") 
          riga nil 
          riga (read-line fin)
    )

    (if (not riga)
        (progn
           (alert "ERRORE!! file temporaneo vuoto")
           (exit)
        )
        (progn 
          (setq rif (splitxt riga " "))
          (if (= (length rif) 6)
              (progn
                 (command "_ucs" "")
                 (command "_ucs" "3p" (list (atof (nth 0 rif))
                                            (atof (nth 1 rif))
                                      )
                                      (list (atof (nth 2 rif))
                                            (atof (nth 3 rif))
                                      )
                                      (list (atof (nth 4 rif))
                                            (atof (nth 5 rif))
                                      )
                 )
              )
              (exit)
          )
          (setq riga (read-line fin))
        )
    )                      
    ;
    ; tipo_cont = 1  contorno esterno  
    ; tipo_cont = 2  contorno interno
    ; perc_cont = 1  percorrenza antioraria 2
    ; perc_cont =-1  percorrenza oraria		3
    ; compensa  = 0  nessuna compensazione
    ; compensa  = 1  compensazione automatica   
    ; compensa  = 2  compensazione a destra
    ; compensa  = 3  compensazione a sinistra
    ; aperta    = 0  il contorno e' chiuso
    ; aperta    = 1  il contorno e' aperto
    ;
    ;                                            se il contorno e' esterno       = 1
    ;                                            se la percorrenza e antioraria  = 1
    ;                                            compensa                        = 2 (a destra)
    ;
    ;                                            se il contorno e' esterno       = 1
    ;                                            se la percorrenza e oraria      = -1
    ;                                            compensa                        = 3 (a sinistra)
    ;
    ;                                            se il contorno e' interno       = 2
    ;                                            se la percorrenza e antioraria  = 1
    ;                                            compensa                        = 3 (a sinistra)
    ;
    ;                                            se il contorno e' interno       = 2
    ;                                            se la percorrenza e oraria      = -1
    ;                                            compensa                        = 2 (a destra)
    ;
    ;
    (setq start nil)
    (setq trovato_compensa nil)
    (princ "81\n" fout)                                   ; coordinate assolute
    (while riga
       ;;;
       ;;; se trovo l'intestazione della marca
       ;;;
       (if (= (substr riga 1 1) ">")
           ;        ho trovato un nuovo contorno
           (progn
               (if (= start -1)
                   (progn
                      (if (= trovato_compensa 1)
                          (progn 
                             (princ "8\n" fout)  ; taglio off
                             (princ "38\n" fout) ; compensazione off
                          )
                      )
                   )
               )
			   ; Head
			   ; 0  1      2    3   4   5    6    7    8   9   10
			   ; > Order Phase Mark Mat Tk Speed Type Jou Cut Close
               (setq testa (splitxt riga " ")

               ;      marca     (nth 0 testa)
               ;      tipo_cont (nth 1 testa)     
               ;      perc_cont (nth 2 testa)
               ;      compensa  (nth 3 testa)
               ;      aperta    (nth 4 testa)
               ;      start 1
			   
					  marca (strcat (nth 1 testa) "_" (nth 2 testa) "_" (nth 3 testa))
					  ;speed 	(atof (nth 6  testa))
					  speed 0
					  tipo_cont (nth 7  testa)     
					  perc_cont (nth 8  testa)
					  compensa  (nth 9  testa)
					  aperta    (nth 10 testa)
					  start 1
			   
               )
		       (if (> Speed 0)
					(if WriteSpeed
						(progn
							(princ (strcat "39+" (LM:rtos Speed 2 0) "\n") fout) ; velocita' torcia
							(setq WriteSpeed nil)
						)
					)
			   )

               (princ "3\n" fout)
               (princ (strcat marca "\n") fout)
               (princ "4\n" fout)              
           )                
       )
       ;;;
       ;;; prima riga dopo l'intestazione della marca
       ;;;
       (if (= start 1)
           ;       iniziano le coordinate del nuovo contorno
           (progn 

               (setq riga (read-line fin))
               ;
               ;  verifico se devo fare uno spostamento veloce
               ;
               (if riga
                  (progn 
                      (setq testa (splitxt riga " "))
                      ;
                      ; estraggo le coordinate
                      ;
                      (setq x_r (atof (nth 0 testa))
                            y_r (atof (nth 1 testa))
                            out_loc (trans (list x_r y_r) 0 1)
                            x_r (nth 0 out_loc)
                            y_r (nth 1 out_loc)
                      )
                      (setq d_x x_r
                            d_y y_r
                      )
                      (if (and (< (abs d_x) preci$) (< (abs d_y) preci$))
                          (setq bingobongo nil)
                          (progn          

                             (princ "5\n" fout)                   ; spostamento rapido on 

                             (if (< (abs d_x) preci$)
                                 (setq x_coord "+")
                                 (progn
                                    (if (> d_x 0)
                                        (setq x_coord (strcat "+" (LM:rtos (* d_x 10) 2 PreciCut)))
                                        (setq x_coord (LM:rtos (* d_x 10) 2 PreciCut))
                                    )
                                 )
                             )                           
                             
                             (if (< (abs d_y) preci$)
                                 (setq y_coord "+")
                                 (progn
                                    (if (> d_y 0)
                                        (setq y_coord (strcat "+" (LM:rtos (* d_y 10) 2 PreciCut)))
                                        (setq y_coord (LM:rtos (* d_y 10) 2 PreciCut))
                                    )                                       
                                 )
                             )
                             
                             (setq sposta (strcat x_coord y_coord))

                             (princ (strcat sposta "\n") fout)    ; coordinata di spostamento
                             (princ "6\n" fout)                   ; spostamento rapido off

                          )
                      )
                      ;
                      ;
                      ; verifico le compensazioni
                      ;
                      ;
                      (setq trovato_compensa 0)
                      (if (= compensa "2")
                          (progn 
                             (princ "30\n" fout)                    ;............. compensa dx
                             (setq trovato_compensa 1)
                          )
                      )
                      (if (= compensa "3") 
                          (progn 
                             (princ "29\n" fout)                    ;............. compensa sx
                             (setq trovato_compensa 1)
                          )                   
                      )
                      (if (= trovato_compensa 0)  ; caso AUTO
                          (progn 
                             (if (and (= aperta "0") (= tipo_cont "1") (= perc_cont "2")) 
                                 (progn
                                      (princ "30\n" fout)           ;............. compensa dx
                                      (setq trovato_compensa 1)
                                 )
                             )
                             (if (and (= aperta "0") (= tipo_cont "1") (= perc_cont "3")) 
                                 (progn
                                      (princ "29\n" fout)           ;............. compensa sx
                                      (setq trovato_compensa 1)
                                 )
                             )
                             (if (and (= aperta "0") (= tipo_cont "2") (= perc_cont "2")) 
                                 (progn
                                      (princ "29\n" fout)           ;............. compensa sx
                                      (setq trovato_compensa 1)
                                 )
                             )
                             (if (and (= aperta "0") (= tipo_cont "2") (= perc_cont "3")) 
                                 (progn
                                      (princ "30\n" fout)           ;............. compensa dx
                                      (setq trovato_compensa 1)
                                 )
                             )
                          )
                      )
                       

                      (princ "7\n" fout) ; ciclo di taglio on

                      (setq start -1)
                  )
               )
           )
           (progn                      
              (setq testa (splitxt riga " "))
              ;
              ; estraggo le coordinate
              ;
              (if (> (length testa) 2)
                  (progn 
                     (setq x_r (atof (nth 0 testa))
                           y_r (atof (nth 1 testa))
                           x_c (atof (nth 2 testa))
                           y_c (atof (nth 3 testa))
                           ra  (atof (nth 4 testa))
                           out_loc (trans (list x_r y_r) 0 1)
                           x_r (nth 0 out_loc)
                           y_r (nth 1 out_loc)
                           out_loc (trans (list x_c y_c) 0 1)
                           x_c (nth 0 out_loc)
                           y_c (nth 1 out_loc)
                           d_x_r x_r
                           d_y_r y_r 
                           d_x_c x_c
                           d_y_c y_c 
                     ) 
                     (if (< (abs d_x_r) preci$)
                         (setq x_coord "+")
                         (progn
                            (if (> d_x_r 0)
                                (setq x_coord (strcat "+" (LM:rtos (* d_x_r 10) 2 PreciCut)))
                                (setq x_coord (LM:rtos (* d_x_r 10) 2 PreciCut))
                            )
                         )
                     )    
                     (if (< (abs d_y_r) preci$)
                         (setq y_coord "+")
                         (progn
                            (if (> d_y_r 0)
                                (setq y_coord (strcat "+" (LM:rtos (* d_y_r 10) 2 PreciCut)))
                                (setq y_coord (LM:rtos (* d_y_r 10) 2 PreciCut))
                            )                                       
                         )
                     )
                     (if (< (abs d_x_c) preci$)
                         (setq x_coord_c "+")
                         (progn
                            (if (> d_x_c 0)
                                (setq x_coord_c (strcat "+" (LM:rtos (* d_x_c 10) 2 PreciCut)))
                                (setq x_coord_c (LM:rtos (* d_x_c 10) 2 PreciCut))
                            )
                         )
                     )    
                     (if (< (abs d_y_c) preci$)
                         (setq y_coord_c "+")
                         (progn
                            (if (> d_y_c 0)
                                (setq y_coord_c (strcat "+" (LM:rtos (* d_y_c 10) 2 PreciCut)))
                                (setq y_coord_c (LM:rtos (* d_y_c 10) 2 PreciCut))
                            )                                       
                         )
                     )
                     (if (> ra 0)
                         (setq r_ "+")
                         (setq r_ "-")
                     )                                       
                     (setq sposta (strcat x_coord y_coord 
                                          x_coord_c y_coord_c 
                                          r_
                                  )
                     )
                  )
                  (progn 
                     (setq x_r (atof (nth 0 testa))
                           y_r (atof (nth 1 testa))
                           out_loc (trans (list x_r y_r) 0 1)
                           x_r (nth 0 out_loc)
                           y_r (nth 1 out_loc)
                           d_x_r x_r
                           d_y_r y_r 
                     )
                     (if (< (abs d_x_r) preci$)
                         (setq x_coord "+")
                         (progn
                            (if (> d_x_r 0)
                                (setq x_coord (strcat "+" (LM:rtos (* d_x_r 10) 2 PreciCut)))
                                (setq x_coord (LM:rtos (* d_x_r 10) 2 PreciCut))
                            )
                         )
                     )    
                     (if (< (abs d_y_r) preci$)
                         (setq y_coord "+")
                         (progn
                            (if (> d_y_r 0)
                                (setq y_coord (strcat "+" (LM:rtos (* d_y_r 10) 2 PreciCut)))
                                (setq y_coord (LM:rtos (* d_y_r 10) 2 PreciCut))
                            )                                       
                         )
                     )
                     (setq sposta (strcat x_coord y_coord))
                  )
              )
              (princ (strcat sposta "\n") fout)
              (setq start -1)
           )
       )
       (setq riga (read-line fin))
    )
    (princ "8\n" fout)  ; taglio off
    (princ "38\n" fout) ; compensazione off
    (princ "63\n" fout) ; fine programma
    (close fout)                                 
    (close fin)                                 
    (command "_ucs" "")
    (princ)
)
;**********************************
;      INTERPRETE_ESSI_FRO
;**********************************
(defun PostProEssiFro (FileIn FileOut / fin fout riga start trovato_compensa
                            testa marca tipo_cont perc_cont compensa aperta
                            x_r y_r bingobongo x_coord y_coord sposta
                            x_r y_r x_c y_c ra d_x_r d_y_r d_x_c d_y_c out_loc
							WriteSpeed preci$ PreciCut Speed)
    ;
    ; procedura di conversione formato neutro to ESSI FRO
    ;
	(setq preci$ 0.01)
	(setq PreciCut 1)
	(setq WriteSpeed T)
	
    (setq fin (open  FileIn "r") 
          fout (open FileOut "w") 
          riga nil 
          riga (read-line fin)
    )
    (if (not riga)
        (progn
           (alert "ERRORE!! file temporaneo vuoto")
           (exit)
        )
        (progn 
          (setq rif (splitxt riga " "))
          (if (= (length rif) 6)
              (progn
                 (command "_ucs" "")
                 (command "_ucs" "3p" (list (atof (nth 0 rif))
                                            (atof (nth 1 rif))
                                      )
                                      (list (atof (nth 2 rif))
                                            (atof (nth 3 rif))
                                      )
                                      (list (atof (nth 4 rif))
                                            (atof (nth 5 rif))
                                      )
                 )
              )
              (exit)
          )
          (setq riga (read-line fin))
        )
    )                      
    ;
    ; tipo_cont = 1  contorno esterno  
    ; tipo_cont = 2  contorno interno
    ; perc_cont = 1  percorrenza antioraria	2
    ; perc_cont =-1  percorrenza oraria		3
    ; compensa  = 0  nessuna compensazione
    ; compensa  = 1  compensazione automatica   
    ; compensa  = 2  compensazione a destra
    ; compensa  = 3  compensazione a sinistra
    ; aperta    = 0  il contorno e' chiuso
    ; aperta    = 1  il contorno e' aperto
    ;
    ;                                            se il contorno e' esterno       = 1
    ;                                            se la percorrenza e antioraria  = 1
    ;                                            compensa                        = 2 (a destra)
    ;
    ;                                            se il contorno e' esterno       = 1
    ;                                            se la percorrenza e oraria      = -1
    ;                                            compensa                        = 3 (a sinistra)
    ;
    ;                                            se il contorno e' interno       = 2
    ;                                            se la percorrenza e antioraria  = 1
    ;                                            compensa                        = 3 (a sinistra)
    ;
    ;                                            se il contorno e' interno       = 2
    ;                                            se la percorrenza e oraria      = -1
    ;                                            compensa                        = 2 (a destra)
    ;
    ;
    (setq start nil)
    (setq trovato_compensa nil)
    (princ "82\n" fout)                                   ; coordinate assolute
    ;(if (> velocita$ 0)
    ;    (princ (strcat "39+" (LM:rtos velocita$ 2 0) "\n") fout) ; velocita' torcia
    ;)
    (while riga
       ;;;
       ;;; se trovo l'intestazione della marca
       ;;;
       (if (= (substr riga 1 1) ">")
           ;        ho trovato un nuovo contorno
           (progn
               (if (= start -1)
                   (progn
                      (if (= trovato_compensa 1)
                          (progn 
                             (princ "8\n" fout)  ; taglio off
                             (princ "38\n" fout) ; compensazione off
                          )
                      )
                   )
               )
               (setq testa (splitxt riga " ")
                     ;marca     (nth 0 testa)
                     ;tipo_cont (nth 1 testa)     
                     ;perc_cont (nth 2 testa)
                     ;compensa  (nth 3 testa)
                     ;aperta    (nth 4 testa)
                     ;start 1

					 marca (strcat (nth 1 testa) "_" (nth 2 testa) "_" (nth 3 testa))
					 speed 		(atof (nth 6  testa))
					 tipo_cont 	(nth 7  testa)     
					 perc_cont 	(nth 8  testa)
					 compensa  	(nth 9  testa)
					 aperta    	(nth 10 testa)
					 start 1
					 
               )                                 
     		   (if (> Speed 0)
					(if WriteSpeed
						(progn
							(princ (strcat "39+" (LM:rtos Speed 2 0) "\n") fout) ; velocita' torcia
							(setq WriteSpeed nil)
						)
					)
			   )
			   (princ "3\n" fout)
               (princ (strcat marca "\n") fout)
               (princ "4\n" fout)              
           )                
       )
       ;;;
       ;;; prima riga dopo l'intestazione della marca
       ;;;
       (if (= start 1)
           ;       iniziano le coordinate del nuovo contorno
           (progn 

               (setq riga (read-line fin))
               ;
               ;  verifico se devo fare uno spostamento veloce
               ;
               (if riga
                  (progn 
                      (setq testa (splitxt riga " "))
                      ;
                      ; estraggo le coordinate
                      ;
                      (setq x_r (atof (nth 0 testa))
                            y_r (atof (nth 1 testa))
                            out_loc (trans (list x_r y_r) 0 1)
                            x_r (nth 0 out_loc)
                            y_r (nth 1 out_loc)
                      )
                      (setq d_x x_r
                            d_y y_r
                      )
                      (if (and (< (abs d_x) preci$) (< (abs d_y) preci$))
                          (setq bingobongo nil)
                          (progn          

                             (princ "5\n" fout)                   ; spostamento rapido on 

                             (if (< (abs d_x) preci$)
                                 (setq x_coord "+0")
                                 (progn
                                    (if (> d_x 0)
                                        (setq x_coord (strcat "+" (LM:rtos (* d_x 10) 2 PreciCut)))
                                        (setq x_coord (LM:rtos (* d_x 10) 2 PreciCut))
                                    )
                                 )
                             )                           
                             
                             (if (< (abs d_y) preci$)
                                 (setq y_coord "+0")
                                 (progn
                                    (if (> d_y 0)
                                        (setq y_coord (strcat "+" (LM:rtos (* d_y 10) 2 PreciCut)))
                                        (setq y_coord (LM:rtos (* d_y 10) 2 PreciCut))
                                    )                                       
                                 )
                             )
                             
                             (setq sposta (strcat x_coord y_coord))

                             (princ (strcat sposta "\n") fout)    ; coordinata di spostamento
                             (princ "6\n" fout)                   ; spostamento rapido off

                          )
                      )
                      ;
                      ;
                      ; verifico le compensazioni
                      ;
                      ;
                      (setq trovato_compensa 0)
                      (if (= compensa "2")
                          (progn 
                             (princ "30\n" fout)                    ;............. compensa dx
                             (setq trovato_compensa 1)
                          )
                      )
                      (if (= compensa "3") 
                          (progn 
                             (princ "29\n" fout)                    ;............. compensa sx
                             (setq trovato_compensa 1)
                          )                   
                      )
                      (if (= trovato_compensa 0)  ; caso AUTO
                          (progn 
                             (if (and (= aperta "0") (= tipo_cont "1") (= perc_cont "2")) 
                                 (progn
                                      (princ "30\n" fout)           ;............. compensa dx
                                      (setq trovato_compensa 1)
                                 )
                             )
                             (if (and (= aperta "0") (= tipo_cont "1") (= perc_cont "3")) 
                                 (progn
                                      (princ "29\n" fout)           ;............. compensa sx
                                      (setq trovato_compensa 1)
                                 )
                             )
                             (if (and (= aperta "0") (= tipo_cont "2") (= perc_cont "2")) 
                                 (progn
                                      (princ "29\n" fout)           ;............. compensa sx
                                      (setq trovato_compensa 1)
                                 )
                             )
                             (if (and (= aperta "0") (= tipo_cont "2") (= perc_cont "3")) 
                                 (progn
                                      (princ "30\n" fout)           ;............. compensa dx
                                      (setq trovato_compensa 1)
                                 )
                             )
                          )
                      )
                       

                      (princ "7\n" fout) ; ciclo di taglio on

                      (setq start -1)
                  )
               )
           )
           (progn                      
              (setq testa (splitxt riga " "))
              ;
              ; estraggo le coordinate
              ;
              (if (> (length testa) 2)
                  (progn 
                     (setq x_r (atof (nth 0 testa))
                           y_r (atof (nth 1 testa))
                           out_loc (trans (list x_r y_r) 0 1)
                           x_r (nth 0 out_loc)
                           y_r (nth 1 out_loc)
                           x_c (atof (nth 2 testa))
                           y_c (atof (nth 3 testa))
                           out_loc (trans (list x_c y_c) 0 1)
                           x_c (nth 0 out_loc)
                           y_c (nth 1 out_loc)
                           ra  (atof (nth 4 testa))
                           d_x_r x_r
                           d_y_r y_r 
                           d_x_c x_c
                           d_y_c y_c 
                     ) 
                     (if (< (abs d_x_r) preci$)
                         (setq x_coord "+0")
                         (progn
                            (if (> d_x_r 0)
                                (setq x_coord (strcat "+" (LM:rtos (* d_x_r 10) 2 PreciCut)))
                                (setq x_coord (LM:rtos (* d_x_r 10) 2 PreciCut))
                            )
                         )
                     )    
                     (if (< (abs d_y_r) preci$)
                         (setq y_coord "+0")
                         (progn
                            (if (> d_y_r 0)
                                (setq y_coord (strcat "+" (LM:rtos (* d_y_r 10) 2 PreciCut)))
                                (setq y_coord (LM:rtos (* d_y_r 10) 2 PreciCut))
                            )                                       
                         )
                     )
                     (if (< (abs d_x_c) preci$)
                         (setq x_coord_c "+0")
                         (progn
                            (if (> d_x_c 0)
                                (setq x_coord_c (strcat "+" (LM:rtos (* d_x_c 10) 2 PreciCut)))
                                (setq x_coord_c (LM:rtos (* d_x_c 10) 2 PreciCut))
                            )
                         )
                     )    
                     (if (< (abs d_y_c) preci$)
                         (setq y_coord_c "+0")
                         (progn
                            (if (> d_y_c 0)
                                (setq y_coord_c (strcat "+" (LM:rtos (* d_y_c 10) 2 PreciCut)))
                                (setq y_coord_c (LM:rtos (* d_y_c 10) 2 PreciCut))
                            )                                       
                         )
                     )
                     (if (> ra 0)
                         (setq r_ "+")
                         (setq r_ "-")
                     )                                       
                     (setq sposta (strcat x_coord y_coord 
                                          x_coord_c y_coord_c 
                                          r_
                                  )
                     )
                  )
                  (progn 
                     (setq x_r (atof (nth 0 testa))
                           y_r (atof (nth 1 testa))
                           out_loc (trans (list x_r y_r) 0 1)
                           x_r (nth 0 out_loc)
                           y_r (nth 1 out_loc)
                           d_x_r x_r
                           d_y_r y_r 
                     )
                     (if (< (abs d_x_r) preci$)
                         (setq x_coord "+0")
                         (progn
                            (if (> d_x_r 0)
                                (setq x_coord (strcat "+" (LM:rtos (* d_x_r 10) 2 PreciCut)))
                                (setq x_coord (LM:rtos (* d_x_r 10) 2 PreciCut))
                            )
                         )
                     )    
                     (if (< (abs d_y_r) preci$)
                         (setq y_coord "+0")
                         (progn
                            (if (> d_y_r 0)
                                (setq y_coord (strcat "+" (LM:rtos (* d_y_r 10) 2 PreciCut)))
                                (setq y_coord (LM:rtos (* d_y_r 10) 2 PreciCut))
                            )                                       
                         )
                     )
                     (setq sposta (strcat x_coord y_coord))
                  )
              )
              (princ (strcat sposta "\n") fout)
              (setq start -1)
           )
       )
       (setq riga (read-line fin))
    )
    (princ "8\n" fout)  ; taglio off
    (princ "38\n" fout) ; compensazione off
    (princ "99\n" fout) ; fine programma
    (close fout)                                 
    (close fin)                                 
    (command "_ucs" "")
    (princ)
)
;**********************************
;      INTERPRETE_ISO_KOIKE
;**********************************
(defun PostProIsoKoike (FileIn FileOut / fin fout rif riga start trovato_compensa
                            testa marca tipo_cont perc_cont compensa aperta
                            x_r y_r x_p y_p prima_riga x_c y_c ra i j
                            out_loc comp
							WriteSpeed preci$ PreciCut Speed)
    ;
    ; procedura di conversione formato neutro to ISO KOIKE
    ;
	(setq preci$ 0.01)
	(setq PreciCut 1)
	(setq WriteSpeed T)

    (setq fin (open  FileIn "r") 
          fout (open FileOut "w") 
          riga nil 
          riga (read-line fin)
    )
    (if (not riga)
        (progn
           (alert "ERRORE!! file temporaneo vuoto")
           (exit)
        )
        (progn 
          (setq rif (splitxt riga " "))
          (if (= (length rif) 6)
              (progn
                 (command "_ucs" "")
                 (command "_ucs" "3p" (list (atof (nth 0 rif))
                                            (atof (nth 1 rif))
                                      )
                                      (list (atof (nth 2 rif))
                                            (atof (nth 3 rif))
                                      )
                                      (list (atof (nth 4 rif))
                                            (atof (nth 5 rif))
                                      )
                 )
              )
              (exit)
          )
          (setq riga (read-line fin))
        )
    )                      
    ;
    ; tipo_cont = 1  contorno esterno  
    ; tipo_cont = 2  contorno interno
    ; perc_cont = 1  percorrenza antioraria	2
    ; perc_cont =-1  percorrenza oraria		3
    ; compensa  = 0  nessuna compensazione
    ; compensa  = 1  compensazione automatica   
    ; compensa  = 2  compensazione a destra
    ; compensa  = 3  compensazione a sinistra
    ; aperta    = 0  il contorno e' chiuso
    ; aperta    = 1  il contorno e' aperto
    ;
    ;                                            se il contorno e' esterno       = 1
    ;                                            se la percorrenza e antioraria  = 1
    ;                                            compensa                        = 2 (a destra)
    ;
    ;                                            se il contorno e' esterno       = 1
    ;                                            se la percorrenza e oraria      = -1
    ;                                            compensa                        = 3 (a sinistra)
    ;
    ;                                            se il contorno e' interno       = 2
    ;                                            se la percorrenza e antioraria  = 1
    ;                                            compensa                        = 3 (a sinistra)
    ;
    ;                                            se il contorno e' interno       = 2
    ;                                            se la percorrenza e oraria      = -1
    ;                                            compensa                        = 2 (a destra)
    ;
    ;
    (setq start nil)
    (setq trovato_compensa nil)
    (setq comp "")

    (princ "%\n" fout)             ; inizio programma
    (princ "G21\n" fout)           ; programma in mm.
    (princ "G90\n" fout)           ; coordinate assolute

    (while riga
       ;;;
       ;;; se trovo l'intestazione della marca
       ;;;
       (if (= (substr riga 1 1) ">")
           ;        ho trovato un nuovo contorno
           (progn             
               (if (= start -1)
                 (progn
                   (if (/= comp "")
                       (princ "G40\n" fout)  ; compensazione off
                   )
                   (princ "M18\n" fout)      ; taglio off
                 )
               )
               (setq testa     (splitxt riga " ")
                     ;marca     (nth 0 testa)
                     ;tipo_cont (nth 1 testa)     
                     ;perc_cont (nth 2 testa)
                     ;compensa  (nth 3 testa)
                     ;aperta    (nth 4 testa)
                     ;start 1
                     ;prima_riga 1
 
					 marca 		(strcat (nth 1 testa) "_" (nth 2 testa) "_" (nth 3 testa))
					 speed 		(atof (nth 6  testa))
					 tipo_cont 	(nth 7  testa)     
					 perc_cont 	(nth 8  testa)
					 compensa  	(nth 9  testa)
					 aperta    	(nth 10 testa)
					 start 1
                     prima_riga 1
			   )
           )                
       )
       ;;;
       ;;; prima riga dopo l'intestazione della marca
       ;;;
       (if (= start 1)
           ;       iniziano le coordinate del nuovo contorno
           (progn 
               ;
               ;  verifico se devo fare uno spostamento veloce
               ;
               (setq riga (read-line fin))
               (if riga
                  (progn 
                      (setq testa (splitxt riga " "))
                      ;
                      ; estraggo le coordinate
                      ;
                      (setq x_r (atof (nth 0 testa))
                            y_r (atof (nth 1 testa))
                            out_loc (trans (list x_r y_r) 0 1)
                            x_r (nth 0 out_loc)
                            y_r (nth 1 out_loc)
                            x_p x_r 
                            y_p y_r 
                      )
                      (princ (strcat "G00X" (LM:rtos x_r 2 PreciCut) 
                                        "Y" (LM:rtos y_r 2 PreciCut) "\n") fout)
                      (princ "M17\n" fout) ; ciclo di taglio on
                      (setq start -1)
                      ;
                      ;
                      ; verifico le compensazioni
                      ;
                      ;
                      (setq trovato_compensa 0
                            comp ""
                      )
                      (if (= compensa "0")
                          (setq comp ""                  ;............. nessuna compensazione
                                trovato_compensa 1
                          )
                      )
                      (if (= compensa "2")
                          (setq comp "G42"               ;............. compensa dx
                                trovato_compensa 1
                          )
                      )
                      (if (= compensa "3") 
                          (setq comp "G41"               ;............. compensa sx
                                trovato_compensa 1
                          )
                      )
                      (if (= trovato_compensa 0)  ; caso AUTO
                          (progn 
                             (if (and (= aperta "0") (= tipo_cont "1") (= perc_cont "2")) 
                                 (progn 
                                    (setq comp "G42")     ;............. compensa dx
                                    (setq trovato_compensa 1)
                                 )
                             )
                             (if (and (= aperta "0") (= tipo_cont "1") (= perc_cont "3")) 
                                 (progn 
                                    (setq comp "G41")     ;............. compensa sx
                                    (setq trovato_compensa 1)
                                 )
                             )
                             (if (and (= aperta "0") (= tipo_cont "2") (= perc_cont "2")) 
                                 (progn 
                                    (setq comp "G41")     ;............. compensa sx
                                    (setq trovato_compensa 1)
                                 )
                             )
                             (if (and (= aperta "0") (= tipo_cont "2") (= perc_cont "3")) 
                                 (progn 
                                    (setq comp "G42")     ;............. compensa dx
                                    (setq trovato_compensa 1)
                                 )
                             )
                          )
                      )
                  )
               )
           )
           (progn                      
              (setq testa (splitxt riga " "))
              ;
              ; estraggo le coordinate
              ;
              (if (> (length testa) 2)
                  (progn 
                     (setq x_r (atof (nth 0 testa))
                           y_r (atof (nth 1 testa))
                           out_loc (trans (list x_r y_r) 0 1)
                           x_r (nth 0 out_loc)
                           y_r (nth 1 out_loc)
                           x_c (atof (nth 2 testa))
                           y_c (atof (nth 3 testa))
                           out_loc (trans (list x_c y_c) 0 1)
                           x_c (nth 0 out_loc)
                           y_c (nth 1 out_loc)
                           ra  (atof (nth 4 testa))
                           i (- x_c x_p)
                           j (- y_c y_p)
                           x_p x_r 
                           y_p y_r 
                     )                 
                     (if ( > ra 0) 
                         (setq int_ora "G03")
                         (setq int_ora "G02")
                     )
                     (if (= prima_riga 1)
                         (progn 
                           (princ (strcat int_ora comp "X" (LM:rtos x_r 2 PreciCut)
                                                       "Y" (LM:rtos y_r 2 PreciCut)
                                                       "I" (LM:rtos i   2 PreciCut)
                                                       "J" (LM:rtos j   2 PreciCut)
                                                       "D00F2\n"
                                   ) fout
                           )
                           (setq prima_riga -1)
                         )
                         (princ (strcat int_ora "X" (LM:rtos x_r 2 PreciCut)
                                                "Y" (LM:rtos y_r 2 PreciCut)
                                                "I" (LM:rtos i   2 PreciCut)
                                                "J" (LM:rtos j   2 PreciCut) "\n"
                                 ) fout
                         )
                     )
                  )
                  (progn 
                     (setq x_r (atof (nth 0 testa))
                           y_r (atof (nth 1 testa))
                           out_loc (trans (list x_r y_r) 0 1)
                           x_r (nth 0 out_loc)
                           y_r (nth 1 out_loc)
                           x_p x_r 
                           y_p y_r 
                     )
                     (if (= prima_riga 1)
                         (progn 
                           (princ (strcat "G01" comp "X" (LM:rtos x_r 2 PreciCut)
                                                     "Y" (LM:rtos y_r 2 PreciCut)
                                                      "D00F2\n"
                                   ) fout
                           )
                           (setq prima_riga -1)
                         )
                         (princ (strcat "G01" "X" (LM:rtos x_r 2 PreciCut)
                                              "Y" (LM:rtos y_r 2 PreciCut) "\n"
                                ) fout
                         )
                     )
                  )
              )
           )
       )
       (setq riga (read-line fin))
    )
    (if (/= comp "")
        (princ "G40\n" fout)  ; compensazione off
    )
    (princ "M18\n" fout)  ; taglio off
    (princ "M02\n" fout)  ; taglio off
    (princ "%\n" fout)    ; taglio off
    (close fout)                                 
    (close fin)                                 
    (command "_ucs" "")
    (princ)
)
;**********************************
;      INTERPRETE_ISO_SOITAAB
;**********************************
(defun PostProIsoSoitaab (FileIn FileOut / fin fout rif riga start trovato_compensa
                            testa marca tipo_cont perc_cont compensa aperta
                            x_r y_r x_p y_p prima_riga x_c y_c ra i j
                            out_loc comp
							WriteSpeed preci$ PreciCut Speed)
    ;
    ; procedura di conversione formato neutro to ISO KOIKE
    ;
	(setq preci$ 0.01)
	(setq PreciCut 1)
	(setq WriteSpeed T)

    (setq fin (open  FileIn "r") 
          fout (open FileOut "w") 
          riga nil 
          riga (read-line fin)
    )
    (if (not riga)
        (progn
           (alert "ERRORE!! file temporaneo vuoto")
           (exit)
        )
        (progn 
          (setq rif (splitxt riga " "))
          (if (= (length rif) 6)
              (progn
                 (command "_ucs" "")
                 (command "_ucs" "3p" (list (atof (nth 0 rif))
                                            (atof (nth 1 rif))
                                      )
                                      (list (atof (nth 2 rif))
                                            (atof (nth 3 rif))
                                      )
                                      (list (atof (nth 4 rif))
                                            (atof (nth 5 rif))
                                      )
                 )
              )
              (exit)
          )
          (setq riga (read-line fin))
        )
    )                      
    ;
    ; tipo_cont = 1  contorno esterno  
    ; tipo_cont = 2  contorno interno
    ; perc_cont = 1  percorrenza antioraria	2
    ; perc_cont =-1  percorrenza oraria		3
    ; compensa  = 0  nessuna compensazione
    ; compensa  = 1  compensazione automatica   
    ; compensa  = 2  compensazione a destra
    ; compensa  = 3  compensazione a sinistra
    ; aperta    = 0  il contorno e' chiuso
    ; aperta    = 1  il contorno e' aperto
    ;
    ;                                            se il contorno e' esterno       = 1
    ;                                            se la percorrenza e antioraria  = 1
    ;                                            compensa                        = 2 (a destra)
    ;
    ;                                            se il contorno e' esterno       = 1
    ;                                            se la percorrenza e oraria      = -1
    ;                                            compensa                        = 3 (a sinistra)
    ;
    ;                                            se il contorno e' interno       = 2
    ;                                            se la percorrenza e antioraria  = 1
    ;                                            compensa                        = 3 (a sinistra)
    ;
    ;                                            se il contorno e' interno       = 2
    ;                                            se la percorrenza e oraria      = -1
    ;                                            compensa                        = 2 (a destra)
    ;
    ;
    (setq start nil)
    (setq trovato_compensa nil)
    (setq comp "")
    ;(if (> velocita$ 0) 
    ;    (setq vl velocita$)
    ;    (setq vl 400)
    ;)
    (princ "G70G90\n" fout)         ; programma in mm. /  quote in assoluto

    (while riga
       ;;;
       ;;; se trovo l'intestazione della marca
       ;;;
       (if (= (substr riga 1 1) ">")
           ;        ho trovato un nuovo contorno
           (progn             
               (if (= start -1)
                 (progn
                   (if (/= comp "")
                       (princ "G40G0\n" fout)  ; compensazione off
                   )
                   (princ "M5\n" fout)         ; taglio off
                   (princ "G4F2\n" fout)       ; tempo 
                 )
               )
               (setq testa     (splitxt riga " ")
                     ;marca     (nth 0 testa)
                     ;tipo_cont (nth 1 testa)     
                     ;perc_cont (nth 2 testa)
                     ;compensa  (nth 3 testa)
                     ;aperta    (nth 4 testa)
                     ;start 1
                     ;prima_riga 1

					 marca 		(strcat (nth 1 testa) "_" (nth 2 testa) "_" (nth 3 testa))
					 speed 		(atof (nth 6  testa))
					 tipo_cont 	(nth 7  testa)     
					 perc_cont 	(nth 8  testa)
					 compensa  	(nth 9  testa)
					 aperta    	(nth 10 testa)
					 start 1
                     prima_riga 1

				)
				(if (> velocita$ 0) 
					(setq vl speed)
					(setq vl 400)
				)
			)                
       )
       ;;;
       ;;; prima riga dopo l'intestazione della marca
       ;;;
       (if (= start 1)
           ;       iniziano le coordinate del nuovo contorno
           (progn 
               ;
               ;  verifico se devo fare uno spostamento veloce
               ;
               (setq riga (read-line fin))
               (if riga
                  (progn 
                      (setq testa (splitxt riga " "))
                      ;
                      ; estraggo le coordinate
                      ;
                      (setq x_r (atof (nth 0 testa))
                            y_r (atof (nth 1 testa))
                            out_loc (trans (list x_r y_r) 0 1)
                            x_r (nth 0 out_loc)
                            y_r (nth 1 out_loc)
                            x_p x_r 
                            y_p y_r 
                      )
                      (princ (strcat "GX" (LM:rtos y_r 2 PreciCut) 
                                      "Z" (LM:rtos x_r 2 PreciCut) "(TLD,1)G44G28\n") fout)
                      (princ "M3\n" fout) ; ciclo di taglio on
                      (setq start -1)
                      ;
                      ;
                      ; verifico le compensazioni
                      ;
                      ;
                      (setq trovato_compensa 0
                            comp ""
                      )
                      (if (= compensa "0")
                          (setq comp ""                  ;............. nessuna compensazione
                                trovato_compensa 1
                          )
                      )
                      (if (= compensa "2")
                          (setq comp "G42"               ;............. compensa dx
                                trovato_compensa 1
                          )
                      )
                      (if (= compensa "3") 
                          (setq comp "G41"               ;............. compensa sx
                                trovato_compensa 1
                          )
                      )
                      (if (= trovato_compensa 0)  ; caso AUTO
                          (progn 
                             (if (and (= aperta "0") (= tipo_cont "1") (= perc_cont "2")) 
                                 (progn 
                                    (setq comp "G42")     ;............. compensa dx
                                    (setq trovato_compensa 1)
                                 )
                             )
                             (if (and (= aperta "0") (= tipo_cont "1") (= perc_cont "3")) 
                                 (progn 
                                    (setq comp "G41")     ;............. compensa sx
                                    (setq trovato_compensa 1)
                                 )
                             )
                             (if (and (= aperta "0") (= tipo_cont "2") (= perc_cont "2")) 
                                 (progn 
                                    (setq comp "G41")     ;............. compensa sx
                                    (setq trovato_compensa 1)
                                 )
                             )
                             (if (and (= aperta "0") (= tipo_cont "2") (= perc_cont "3")) 
                                 (progn 
                                    (setq comp "G42")     ;............. compensa dx
                                    (setq trovato_compensa 1)
                                 )
                             )
                          )
                      )
                  )
               )
           )
           (progn                      
              (setq testa (splitxt riga " "))
              ;
              ; estraggo le coordinate
              ;
              (if (> (length testa) 2)
                  (progn 
                     (setq x_r (atof (nth 0 testa))
                           y_r (atof (nth 1 testa))
                           out_loc (trans (list x_r y_r) 0 1)
                           x_r (nth 0 out_loc)
                           y_r (nth 1 out_loc)
                           x_c (atof (nth 2 testa))
                           y_c (atof (nth 3 testa))
                           out_loc (trans (list x_c y_c) 0 1)
                           x_c (nth 0 out_loc)
                           y_c (nth 1 out_loc)
                           ra  (atof (nth 4 testa))
                           i (- x_c x_p)
                           j (- y_c y_p)
                           x_p x_r 
                           y_p y_r 
                     )                 
                     (if ( > ra 0)              
                         (progn 
                           (setq int_ora "G3")
                           (setq ra (- 0 ra))
                         )
                         (progn 
                           (setq int_ora "G2")
                           (setq ra (abs ra))
                         )
                     )
                     (if (= prima_riga 1)
                         (progn 
                           (princ (strcat int_ora comp "X" (LM:rtos y_r 2 PreciCut)
                                                       "Z" (LM:rtos x_r 2 PreciCut)
                                                       "R" (LM:rtos ra  2 PreciCut)
                                                       "G94F" (LM:rtos vl 2 0) "\n"
                                   ) fout
                           )
                           (setq prima_riga -1)
                         )
                         (princ (strcat int_ora "X" (LM:rtos y_r 2 PreciCut)
                                                "Z" (LM:rtos x_r 2 PreciCut)
                                                "R" (LM:rtos ra  2 PreciCut) "\n"
                                 ) fout
                         )
                     )
                  )
                  (progn 
                     (setq x_r (atof (nth 0 testa))
                           y_r (atof (nth 1 testa))
                           out_loc (trans (list x_r y_r) 0 1)
                           x_r (nth 0 out_loc)
                           y_r (nth 1 out_loc)
                           x_p x_r 
                           y_p y_r 
                     )
                     (if (= prima_riga 1)
                         (progn 
                           (princ (strcat "G1" comp "X" (LM:rtos y_r 2 PreciCut)
                                                    "Z" (LM:rtos x_r 2 PreciCut)
                                                    "G94F" (LM:rtos vl 2 0) "\n"
                                   ) fout
                           )
                           (setq prima_riga -1)
                         )
                         (princ (strcat "G1" "X" (LM:rtos y_r 2 PreciCut)
                                             "Z" (LM:rtos x_r 2 PreciCut) "\n"
                                ) fout
                         )
                     )
                  )
              )
           )
       )
       (setq riga (read-line fin))
    )
    (if (/= comp "")
        (princ "G40G0\n" fout)  ; compensazione off
    )
    (princ "M5\n" fout)         ; ciclo off
    (princ "M30\n" fout)        ; fine programma + reset
    (close fout)                                 
    (close fin)                                 
    (command "_ucs" "")
    (princ)
)

