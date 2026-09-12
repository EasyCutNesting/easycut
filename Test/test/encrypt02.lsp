(defun load_prg (mode passwd load / path_file disk lst_path dir list_file file
							        Fimport Fexport extension_file_input extension_file_output)

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
				(setq Fimport (strcat dir "\\" (nth 0 split_file) "." extension_file_input)
					  Fexport (strcat dir "\\" (nth 0 split_file) "." extension_file_output)
				)
				(if (= load 1) (setq Fexport (strcat path_file  "structura." extension_file_output)))
				(code02 Fimport Fexport passwd mode)
				(if (= load 1) (load Fexport))
		)
	)
)
;
;(code02 "C:\\EasyCutBeta\\Test\\test\\test.lsp" "C:\\EasyCutBeta\\Test\\test\\test.enc" "chisiamo" 1)
;(code02 "C:\\EasyCutBeta\\Test\\test\\test.enc" "C:\\EasyCutBeta\\Test\\test\\test.dec" "chisiamo" 2)
;
;(code02 "C:\\EasyCutBeta\\Test\\test\\test.lsp" "C:\\EasyCutBeta\\Test\\test\\test.enc" nil 1)
;(code02 "C:\\EasyCutBeta\\Test\\test\\test.enc" "C:\\EasyCutBeta\\Test\\test\\test.dec" nil 2)

(defun code02 (FileImport FileExport Key Mode / Guid GA-Random-Num RandomChar MakeKey GetKey SplitAsciiToList StringToAscii CharToAscii
												Encrypt Decrypt CheckKey FindManualKey
											    MaxCarLine CodeControlNewLine _Key)
	;
	; mode 1 = crittografa il file
	; mode 2 = decrittografa il file
	; Key    = stringa (chiave di codifica)
	; 
	;
	(setq MaxCarLine 50)
	(setq CodeControlNewLine (list "000" "001" "002" "003" "004" "005" "006" "007" "008" "009"))
	;
	(defun Guid  (/ tl g)
		(if (setq tl (vlax-get-or-create-object "Scriptlet.TypeLib"))
			(progn 
				(setq g (vlax-get tl 'Guid)) 
				(vlax-release-object tl) 
				(substr g 2 36)
			)
		)
	)
	;
	(defun GA-Random-Num (Rmi Rma / mid is_go_on)
		(setq is_go_on T)
		(while (and is_go_on (setq mid (fix (rem (getvar "CPUTICKS") Rma))))
			(if	(>= mid Rmi)
				(setq is_go_on NIL)
			)
		)
		mid
	)	
	;
	(defun RandomChar ()
		(chr (GA-Random-Num 1 255))
	)
	;
	(defun MakeKey (NumChar / Key Code)
	
		(setq Key "")
		(repeat NumChar
			(setq Code (GA-Random-Num 1 255))
			(cond 
				((and (> Code 0) (< Code 10))
					(setq Key (strcat Key "00" (rtos Code 2 0)))
				)
				((and (> Code 9) (< Code 100))
					(setq Key (strcat Key "0"   (rtos Code 2 0)))
				)
				(t
					(setq Key (strcat Key (rtos Code 2 0)))
				)
			)
		)
		Key
	)
	;
	(defun GetKey (FileKey / FKey Line)
		(if (findfile FileKey)
			(progn
				(setq FKey (open FileKey "r"))
				(setq Line (read-line FKey))
				(close FKey)
			)
		)
		Line
	)
	;
	(defun SplitAsciiToList (StringKey Div / NumKey Rtn)

			;StringKey   "010025122125" -> ("010" "0252 "122" "125")
			
			(setq NumKey 1)
			(if (and StringKey Div)
				(progn
					(if (= (fix (/ (strlen StringKey) Div)) (/ (strlen StringKey) Div))
						(repeat (fix (/ (strlen StringKey) Div))
							(setq Rtn (append Rtn (list (atoi (substr StringKey NumKey (fix Div))))))
							(setq NumKey (+ NumKey (fix Div)))
						)
					)
				)
			)
			Rtn
	)
	;
	(defun StringToAscii (StringKey / Key)
	
		;	StringKey "sHkyj" -> "115072107121106"
		
		(setq Key "")
		(foreach itm (vl-string->list StringKey)
			(cond 
				((and (> itm 0) (< itm 10))
					(setq Key (strcat Key "00" (rtos itm 2 0)))
				)
				((and (> itm 9) (< itm 100))
					(setq Key (strcat Key "0"  (rtos itm 2 0)))
				)
				(t
					(setq Key (strcat Key (rtos itm 2 0)))
				)
			)
		)
		Key
	)
	;
	(defun CharToAscii (Char / Rtn)
		; Char "1" -> "049"
		(if Char
			(cond 
				((and (> (ascii Char) 0) (< (ascii Char) 10))
					(setq Rtn (strcat "00" (rtos (ascii Char) 2 0)))
				)
				((and (> (ascii Char) 9) (< (ascii Char) 100))
					(setq Rtn (strcat "0"  (rtos (ascii Char) 2 0)))
				)
				(t
					(setq Rtn (rtos (ascii Char) 2 0))
				)
			)
		)
		Rtn
	)
	;
	(defun FindManualKey (FileName / ControlAscii Rtn)
		(setq ControlAscii 256) 
		(setq Rtn "")
		(foreach itm (reverse (cdr (member ControlAscii (reverse (SplitAsciiToList (GetKey FileName) 3.0)))))
			(setq Rtn (strcat Rtn (chr itm)))
		)
		(if (= Rtn "")
			nil
			Rtn
		)
	)
	;
	(defun Encrypt (FileImport FileExport Key / PrintCode
												Fimport Fexport NumPas NumCarLine NCarPass Line LstKey NumCar itm)
	
		;
		(defun PrintCode (Code Stream)
			(if (and Code Stream)
				(cond
					((and (> Code 0) (< Code 10))
						(princ (strcat "00" (rtos Code 2 0)) Stream)
					)
					((and (> Code 9) (< Code 100))
						(princ (strcat "0"  (rtos Code 2 0)) Stream)
					)
					(t
						(princ Code Stream)
					)
				)
			)
		)
		;
		; Main
		;
		(setq Fimport (open FileImport "r")
		      Fexport (open FileExport "w")
			  NumPas 0
			  NumCarLine 1
			  
		      Line (read-line Fimport)
			  LstKey (SplitAsciiToList Key 3.0)
			  NCarPass (length LstKey)
		)
		
		
		(write-line Key Fexport)	; print HeadCode
		
		
		(while Line
			(setq NumCar 1)
			(foreach itm (vl-string->list Line)
				(if (> (1+ NumPas) NCarPass) (setq NumPas 0))
				(if (> NumCarLine MaxCarLine)
					(progn
						(princ "\n" Fexport)
						(setq NumCarLine 1)
					)
				)
				
				(PrintCode (+ (nth NumPas LstKey) itm) Fexport)

				(setq NumPas (1+ NumPas)
					  NumCar (1+ NumCar)
					  NumCarLine (1+ NumCarLine)
				)
			)
			(setq Line (read-line Fimport))
			;
			; controllo inserimento nuova linea +++++
			;
			(if Line 
				(progn
					(if (> NumCarLine MaxCarLine)
						(progn
							(princ "\n" Fexport)
							(setq NumCarLine 1)
						)
					)
					(princ (nth (GA-Random-Num 0 9) CodeControlNewLine) Fexport)
					(setq NumCarLine (1+ NumCarLine))
				)
			)
		)
		(close Fimport)
		(close Fexport)
	)
	;
	(defun Decrypt (FileImport FileExport Key / Fimport Fexport NumPas LstKey NCarPass Line NumCar Code)

		(setq Fimport (open FileImport "r")
		      Fexport (open FileExport "w")
			  NumPas 0
			  LstKey (SplitAsciiToList Key 3.0)
			  NCarPass (length LstKey)
			  Line (read-line Fimport)
			  Line (read-line Fimport)
		)
		(while Line
			(setq NumCar 1)
			(repeat (/ (strlen Line) 3)
				(setq Code (substr Line NumCar 3))
				(if (> (1+ NumPas) NCarPass) (setq NumPas 0))
			    (if (member Code CodeControlNewLine)
					(princ "\n" Fexport)
					(progn
						(princ (chr (-  (atoi Code)	(nth NumPas LstKey))) Fexport)
						(setq NumPas (1+ NumPas))
					)
				)
				(setq NumCar (+ NumCar 3))
			)
			(setq Line (read-line Fimport))
		)
		(close Fimport)
		(close Fexport)
	)
	;
	(defun CheckKey (Key / NewKey ControlAscii)
	
		(setq ControlAscii "256")
		(if Key
			(cond
				((< (strlen Key) MaxCarLine)
					(setq NewKey (strcat (StringToAscii Key) ControlAscii))
					
					(repeat (- MaxCarLine (strlen Key) 1)
						(setq NewKey (strcat NewKey (CharToAscii (RandomChar))))
					)
				)
				(t
					(setq NewKey (strcat (StringToAscii (substr Key 1 (- MaxCarLine 1))) ControlAscii))
				)
			)
		)
		NewKey
	)
	;
	; Main ++++
	;
	(if (and FileImport FileExport Mode (findfile FileImport))
		(cond
			((= Mode 1)
				(if (and Key (> (strlen Key) 0))
					(setq _Key (CheckKey Key))
					(setq _Key (MakeKey MaxCarLine))
				)
				(Encrypt FileImport FileExport _Key)
			)
			((= Mode 2)
				(if (setq _Key (FindManualKey FileImport))
					(if (and Key (> (strlen Key) 0))
						(if (= Key _Key)
							(Decrypt FileImport FileExport (GetKey FileImport))
							(princ "\nWrong Key")
						)
						(princ "\nKey not defined")
					)
					(Decrypt FileImport FileExport (GetKey FileImport))
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
                   "\n \nPress 'X' to eXit or any Key to continue: "
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