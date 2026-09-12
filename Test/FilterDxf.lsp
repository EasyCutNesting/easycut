(defun LeggiDxfCompleto (file_percorso / fp linea tipo LstRecord)

  
	(if file_percorso
		(progn
			(setq LstRecord nil) ; Inizializza la lista dei vertici per questa polilinea
			(setq fp (open file_percorso "r"))
			(princ "\n--- ANALISI FILE DXF (LINEE, CERCHI, POLILINEE) ---")
			
			(if (setq linea (read-line fp)) (setq Loop T))
			
			
			(while linea
				(if (= linea "  0") ; ingresso
					(progn
						(setq linea (read-line fp))
						;(princ "\nEntro trim")
						(setq tipo (vl-string-trim " " linea))
						;(princ "\nEsco trim")
            
						;; --- CASO LINEA ---
						(if (= tipo "LINE")
							(progn
								(princ "\nentro su linea")
								(setq LstRecord (append LstRecord (list "  0" tipo)))
								(setq LstRecord (append LstRecord (list "  8")))
								(setq LstRecord (append LstRecord (list "0")))
								(while (and (setq linea (read-line fp)) (/= linea "  0"))
									(cond
										((= (vl-string-trim " " linea) "10") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "20") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "30") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "11") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "21") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "31") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
									)
								)
								;(princ (strcat "\n[LINEA] Inizio: (" (rtos x1) "," (rtos y1) "," (rtos z1) ") -> Fine: (" (rtos x2) "," (rtos y2) "," (rtos z2) ")"))
								;(if (= linea "  0") (setq Loop T) (setq Loop nil))
								;(princ (strcat "\n<" linea ">"))
								(princ "\nesco da linea")
							)
						)
				
						;; --- CASO CERCHIO ---
						(if (= tipo "CIRCLE")
							(progn
								(princ "\nentro su cerchio")
								(setq LstRecord (append LstRecord (list "  0" tipo)))
								(setq LstRecord (append LstRecord (list "  8")))
								(setq LstRecord (append LstRecord (list "0")))

								(while (and (setq linea (read-line fp)) (/= linea "  0"))
									(cond
										((= (vl-string-trim " " linea) "10") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "20") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "40") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
									)
								)
								;(princ (strcat "\n[CERCHIO] Centro: (" (rtos x1) "," (rtos y1) "," (rtos z1) ") | Raggio: " (rtos raggio)))
								;(if (= linea "  0") (setq Loop T) (setq Loop nil))
								(princ "\nesco da cerchio")
							)
						)
			
						;; --- CASO POLILINEA (LWPOLYLINE / POLYLINE) ---
						(if (or (= tipo "LWPOLYLINE") (= tipo "POLYLINE"))
							(progn
								(princ "\nentro su polilinea")
								(setq LstRecord (append LstRecord (list "  0" tipo)))
								(setq LstRecord (append LstRecord (list "  8")))
								(setq LstRecord (append LstRecord (list "0")))
								(while (and (setq linea (read-line fp)) (/= linea "  0"))
									(cond
										((= (vl-string-trim " " linea) "90") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "70") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "43") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "38") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "39") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "10") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "20") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "91") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "40") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "41") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
										((= (vl-string-trim " " linea) "42") (setq LstRecord (append LstRecord (list linea (read-line fp)))))
									)
								)
								;(princ (strcat "\n[POLILINEA] Numero recordo: " (itoa (length LstRecord)) " -> Punti: "))
								;(if (= linea "  0") (setq Loop T) (setq Loop nil))
								(princ "\nesco da polilinea")
							)
						)
					)
					(setq linea (read-line fp))
				)
			)
			
			(close fp)
			(princ "\n--- FINE LETTURA FILE ---")
		)
		(princ "\nNessun file selezionato.")
	)
	(if LstRecord 
		(progn
			(setq fw (open (strcat (vl-filename-directory file_percorso) "\\Mod.dxf") "w"))
			(write-line "  0" fw)
			(write-line "SECTION" fw)
			(write-line "  2" fw)
			(write-line "ENTITIES" fw)		
			(foreach itm LstRecord
				(write-line itm fw) 
			)
			(write-line "  0" fw)
			(write-line "ENDSEC" fw)
			(write-line "  0" fw)
			(write-line "EOF" fw)
			(close fw)
		)
	)
)
;(LeggiDxfCompleto "C:\\EasyCutNesting Beta\\Test\\prova02.dxf")