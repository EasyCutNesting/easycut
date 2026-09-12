(defun load_prg (mode passwd load / path_file disk lst_path dir list_file file
							        ffile_import ffile_export extension_file_input extension_file_output)

	(setq path_file (getvar "XLOADPATH")
		  disk      (substr path_file 1 1)
		  lst_path  (list  (strcat disk ":\\StructuraCP\\comm")
						   (strcat disk ":\\StructuraCP\\database\\export")
						   (strcat disk ":\\StructuraCP\\database\\import")
						   (strcat disk ":\\StructuraCP\\database\\rec")
						   (strcat disk ":\\StructuraCP\\database\\rec_viti")
					       (strcat disk ":\\StructuraCP\\gest_pts")
					       (strcat disk ":\\StructuraCP\\menu")
					       (strcat disk ":\\StructuraCP\\profil")
					       (strcat disk ":\\StructuraCP\\startup")
					       (strcat disk ":\\StructuraCP\\tools")
					       (strcat disk ":\\StructuraCP\\utilita")
					)
	)
	(foreach dir lst_path
		(cond 
			((= mode 1) ; crypt file	
					(setq extension_file_input  "lsp")
					(setq extension_file_output "lsc")
			)
			((= mode 2) ; decrypt file	
					(setq extension_file_input  "lsc")
					(setq extension_file_output "lsp")
			)
		)
		(setq list_file (vl-directory-files dir (strcat "*." extension_file_input)))
		(foreach file list_file
				(cond 
					((= mode 1) (princ "\n-----crypt----->")  (princ file))
					((= mode 2) (princ "\n-----decrypt--->")  (princ file))
				)
				(setq split_file (splitxt file "."))
				(setq ffile_import (strcat dir "\\" (nth 0 split_file) "." extension_file_input)
					  ffile_export (strcat dir "\\" (nth 0 split_file) "." extension_file_output)
				)
				(if (= load 1) (setq ffile_export (strcat path_file  "structura." extension_file_output)))
				(code02 ffile_import ffile_export passwd mode)
				(if (= load 1) (load ffile_export))
		)
	)
)
;
;(code01 "C:\\cad3d\\tmp\\test_code\\cdorder.lsp" "C:\\cad3d\\tmp\\test_code\\cdorder.lsc" "chisiamo" 1)
;(code01 "C:\\cad3d\\tmp\\test_code\\cdorder.lsc" "C:\\cad3d\\tmp\\test_code\\cdorder.lsp" "chisiamo" 2)
;(code01 "C:\\EasyCutBeta\\Test\\test\\test.lsp" "C:\\EasyCutBeta\\Test\\test\\test.enc" "chisiamo" 1)
;(code01 "C:\\EasyCutBeta\\Test\\test\\test.enc" "C:\\EasyCutBeta\\Test\\test\\test.dec" "chisiamo" 2)

(defun code01 (file_import file_export key mode / ffile_import ffile_export
												  riga conta_pas conta_car
											      ncar_pas NewText)
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
							(setq NewText "")
							(repeat (strlen riga)
		
								(if (> conta_pas ncar_pas) (setq conta_pas 1))

								(setq NewText (strcat NewText (chr (+ (ascii (substr key  conta_pas 1))
																	  (ascii (substr riga conta_car 1))))))
											  
								(setq conta_pas (1+ conta_pas)
									  conta_car (1+ conta_car)
								)
							)
							(write-line (vl-prin1-to-string  (vl-string->list NewText)) ffile_export)
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
									
							(setq NewText "")
							
							(foreach itm  (read riga)
							
									(if (> conta_pas ncar_pas) (setq conta_pas 1))
														
									(setq NewText 	(strcat NewText (chr (-  itm (ascii (substr key conta_pas 1))
																		 )
																	)
													))
													
									(setq conta_pas (1+ conta_pas))
							)
							(write-line NewText ffile_export)
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
;(code02 "C:\\EasyCutBeta\\Test\\test\\test.lsp" "C:\\EasyCutBeta\\Test\\test\\test.enc" "chisiamo" 1)
;(code02 "C:\\EasyCutBeta\\Test\\test\\test.enc" "C:\\EasyCutBeta\\Test\\test\\test.dec" "chisiamo" 2)

(defun code02 (file_import file_export key mode / ffile_import ffile_export
												  ncar_line code_control_new_line
												  riga conta_pas conta_car conta_for conta_code_ctr
											      ncar_pas Code)
	;
	; mode 1 = crittografa il file
	; mode 2 = decrittografa il file
	; key    = stringa (chiave di codifica)
	; 
	;
	
	(setq ffile_import (open file_import "r"))
	(setq ffile_export (open file_export "w"))
	
	(setq ncar_line 50)
	(setq code_control_new_line (list "000" "001" "002" "003" "004" "005" "006" "007" "008" "009"))
	
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
							
							(foreach itm (vl-string->list riga)
		
								(if (> conta_pas ncar_pas) (setq conta_pas 1))

								(if (> conta_for ncar_line)
									(progn
										(princ "\n" ffile_export)
										(setq conta_for 1)
									)
								)
								
								(if (< (+ (ascii (substr key conta_pas 1)) itm) 100)
									(progn
										(princ "0" ffile_export)
										(princ (+ (ascii (substr key conta_pas 1)) itm) ffile_export)
									)
									(princ (+ (ascii (substr key conta_pas 1)) itm) ffile_export)
								)
								
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
									(if (> conta_for ncar_line)
										(progn
											(princ "\n" ffile_export)
											(setq conta_for 1)
										)
									)
									(princ (strcat "00" (Random_Str 1)) ffile_export)
									(setq conta_for (1+ conta_for))
								)
							)
						)
						
						(close ffile_import)
						(close ffile_export)
					)
				)
		)
	
		((= mode 2) ; decrypt
					
				(if ffile_import
					(progn
						(setq riga (read-line ffile_import)
							  conta_pas 1
							  ncar_pas (strlen key)
						)
						(while riga
							(setq conta_car 1)
							
							(repeat (/ (strlen riga) 3)
							
								(setq Code (substr riga conta_car 3))
								
								(if (> conta_pas ncar_pas) (setq conta_pas 1))
								
							    (if (member Code code_control_new_line)
									(princ "\n" ffile_export)
									(progn
										(princ (chr (-  (atoi Code)	(ascii (substr key  conta_pas 1)))) ffile_export)
										(setq conta_pas (1+ conta_pas))
									)
								)
								(setq conta_car (+ conta_car 3))
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
(defun BASE (bas int / ret yyy zot)

  (defun zot (i1 i2 / xxx)
    (if (> (setq xxx (rem i2 i1)) 9)
      (chr (+ 55 xxx))
      (itoa xxx)
    )
  )

  (setq ret (zot bas int)
        yyy (/ int bas)
  )
  (setq ret (strcat (zot bas yyy) ret))
  (setq yyy (/ yyy bas))

  (strcat (zot bas yyy) ret)
)

(defun C:ASCII (/)                      ;chk out ct code dec oct hex )
  (initget "Yes")
  (setq chk (getkword "\nWriting to ASCII.TXT, continue? <Y>: "))
  (if (or (= chk "Yes") (= chk nil))
    (progn
      (setq out  (open "C:\\EasyCutBeta\\Test\\test\\ascii.txt" "w")
            chk  1
            code 0
            ct   0
      )
      (princ "\n \n CHAR DEC OCT HEX \n")
      (princ "\n \n CHAR DEC OCT HEX \n" out)
      (while chk
        (setq dec (strcat "  " (itoa code))
              oct (base 8 code)
              hex (base 16 code)
        )
        (setq dec (substr dec (- (strlen dec) 2) 3))
        (if (< (strlen oct) 3)
          (setq oct (strcat "0" oct))
        )

        (princ (strcat "\n " (chr code) " " dec " " oct " " hex))
        (princ (strcat "\n " (chr code) " " dec " " oct " " hex)
               out
        )

        (cond
          ((= code 255) (setq chk nil))
          ((= ct 20)
           (setq
             xxx (getstring
                   "\n \nPress 'X' to eXit or any key to continue: "
                 )
           )
           (if (= (strcase xxx) "X")
             (setq chk nil)
             (progn
               (setq ct 0)
               (princ "\n \n CHAR DEC OCT HEX \n")
             )
           )
          )
        )
        (setq ct   (1+ ct)
              code (1+ code)
        )
      )
      (close out)
      (setq out nil)
    )
  )
 (princ)
)