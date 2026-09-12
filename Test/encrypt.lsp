;
;(code01 "C:\\cad3d\\tmp\\test_code\\cdorder.lsp" "C:\\cad3d\\tmp\\test_code\\cdorder.lsc" "chisiamo" 1)
;(code01 "C:\\cad3d\\tmp\\test_code\\cdorder.lsc" "C:\\cad3d\\tmp\\test_code\\cdorder.lsp" "chisiamo" 2)
;(code01 "C:\\EasyCutBeta\\Test\\Test\\test.lsp" "C:\\EasyCutBeta\\Test\\Test\\test.lsc" "!" 1)


(defun code01 (file_import file_export key mode / ffile_import ffile_export
												  riga conta_pas conta_car
											      ncar_pas)
	;
	; mode 1 = crittografa il file
	; mode 2 = decrittografa il file
	; key    = stringa (chiave di codifica)
	; 
	;
	(setq ffile_import (open file_import "r"))
	(setq ffile_export (open file_export "w"))

    (cond 
		((= mode 1) ; crypt file

				(if ffile_import
					(progn
						(setq riga (read-line ffile_import)
							  conta_pas 1
							  ncar_pas (strlen key)
						)
						(while riga
							(setq conta_car 1)
							(repeat (strlen riga)
		
								(if (> conta_pas ncar_pas) (setq conta_pas 1))
								
								;(princ (+  (ascii (substr key conta_pas 1)) (ascii (substr riga   conta_car 1)))) (terpri)
								
								;(princ (chr (+  (ascii (substr key conta_pas 1))
								;				(ascii (substr riga   conta_car 1)))) ffile_export)
								
								
								
								(if (> (strlen (LM:dec->base
														(+ 	(ascii (substr key  conta_pas 1))
															(ascii (substr riga conta_car 1))) 16)) 1)
										  
									(princ (LM:dec->base (+ (ascii (substr key  conta_pas 1))
											                (ascii (substr riga conta_car 1))) 16) ffile_export)
											  
									(princ (strcat "0" (LM:dec->base 
															(+ 	(ascii (substr key  conta_pas 1))
																(ascii (substr riga conta_car 1))) 16)) ffile_export)
								)
												
				
								(setq conta_pas (1+ conta_pas)
									  conta_car (1+ conta_car)
								)
							)
							(princ "\n" ffile_export)
							(setq riga (read-line ffile_import))
						)
						(close ffile_import)
						(close ffile_export)
					)
				)
		)
	
		((= mode 2) ; decrypt and load
					
				(if ffile_import
					(progn
						(setq riga (read-line ffile_import)
							  conta_pas 1
							  ncar_pas (strlen key)
						)
						(while riga
									
							;(terpri) (princ riga)
							(setq conta_car 1)
							(repeat (strlen riga)
											
								(if (> conta_pas ncar_pas) (setq conta_pas 1))
														
								(princ (chr (-  (ascii (substr riga   conta_car 1))
												(ascii (substr key conta_pas 1)))) ffile_export)
								(setq conta_car (1+ conta_car))
								(setq conta_pas (1+ conta_pas))
							)
							(princ "\n" ffile_export)
							(setq riga (read-line ffile_import))
						)
						(close ffile_import)
						(close ffile_export)
					)
				)
		)
	)
	(princ)
)
;
;(code02 "C:\\cad3d\\tmp\\test_code\\cdorder.lsp" "C:\\cad3d\\tmp\\test_code\\cdorder.lsc" "chisiamo" 1)
;(code02 "C:\\cad3d\\tmp\\test_code\\cdorder.lsc" "C:\\cad3d\\tmp\\test_code\\cdorder.lsp" "chisiamo" 2)
;
(defun code02 (file_import file_export key mode / ffile_import ffile_export
												  ncar_line code_control_new_line
												  riga conta_pas conta_car conta_for conta_code_ctr
											      ncar_pas)
	;
	; mode 1 = crittografa il file
	; mode 2 = decrittografa il file
	; key    = stringa (chiave di codifica)
	; 
	;
	
	(setq ffile_import (open file_import "r"))
	(setq ffile_export (open file_export "w"))
	
	(setq ncar_line 128)
	(setq code_control_new_line (list (chr 17) (chr 30) (chr 18) (chr 28) (chr 20) (chr 27) (chr 29) (chr 31) (chr 19)))
	
    (cond 
		((= mode 1) ; crypt file

				(if ffile_import
					(progn
						(setq riga (read-line ffile_import)
							  conta_pas 1
							  conta_for 1
							  conta_code_ctr 1
							  ncar_pas (strlen key)
							  
						)
						
						(while riga
							(setq conta_car 1)
							(repeat (strlen riga)
		
								(if (> conta_pas ncar_pas) (setq conta_pas 1))

								(if (> conta_for ncar_line)
									(progn
										(princ "\n" ffile_export)
										(setq conta_for 1)
									)
								)
								
								
								(princ (chr (+  (ascii (substr key  conta_pas 1))
												(ascii (substr riga conta_car 1)))) ffile_export)
				
								(setq conta_pas (1+ conta_pas)
									  conta_car (1+ conta_car)
									  conta_for (1+ conta_for)
								)
							)
							(setq riga (read-line ffile_import))
							
							;
							; controllo inserimento nuova linea +++++
							;
							(if riga 
								(progn
									(if (> conta_code_ctr (length code_control_new_line))
										(setq conta_code_ctr 1)
									)
									(princ (nth (1- conta_code_ctr) code_control_new_line) ffile_export)
									(setq conta_code_ctr (1+ conta_code_ctr))
								)
							)
						)
						
						(close ffile_import)
						(close ffile_export)
					)
				)
		)
	
		((= mode 2) ; decrypt and load
					
				(if ffile_import
					(progn
						(setq riga (read-line ffile_import)
							  conta_pas 1
							  ncar_pas (strlen key)
						)
						(while riga
							(setq conta_car 1)
							(repeat (strlen riga)
											
								(if (> conta_pas ncar_pas) (setq conta_pas 1))
								
							    (if (member (substr riga conta_car 1) code_control_new_line)
									(princ "\n" ffile_export)
									(progn
										(princ (chr (-  (ascii (substr riga conta_car 1))
														(ascii (substr key  conta_pas 1)))) ffile_export)
										(setq conta_pas (1+ conta_pas))
									)
								)
								(setq conta_car (1+ conta_car))
							)
							(setq riga (read-line ffile_import))
						)
						(close ffile_import)
						(close ffile_export)
					)
				)
		)
	)
	(princ)
)
;
;
;
