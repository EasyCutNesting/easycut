(defun GuiCodeX (/ IsEmptyBox IsOnlyNumberBox 
					 SwapCode SwapPass FillInFile FillOutFile ChkPsw EntropyKey GetCodex 
					 LoadDataCodex OutputDcl WriteDclCodex EditFile CharRandomAction RefreshKeyAction
					 DclCodex xx MinCharRandomPassword Rtn)
	;
	(defun IsEmptyBox (KeyBox)
		(= (GetTextBox KeyBox) "")
	)
	;
	(defun IsOnlyNumberBox (KeyBox / Value)
		(if (numberp (read (GetTextBox KeyBox)))
			(read (GetTextBox KeyBox))
		)
	)
	;
	(defun GetTextBox (KeyBox)
		(vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile KeyBox)))
	)
	;
	(defun SwapCode (Mode / Rtn)
		(cond 
			((= Mode 1)
				(set_tile "Mode1"		  "1")
				(mode_tile "Code"			0)
				;
				(if (= (get_tile "PassInput") "1")
					(progn
						(mode_tile "InputKeyMode1"	0)
						(mode_tile "CharRandom"	    1)
						(mode_tile "RefreshKey"	    1)
					)
					(progn
						(mode_tile "InputKeyMode1"	1)
						(mode_tile "CharRandom"	    0)
						(mode_tile "RefreshKey"	    0)
					)
				)
				;
				(mode_tile "Decode"			1)
				(mode_tile "Cube"			1)
				(setq Rtn 1)
			)
			((= Mode 2)
				(set_tile "Mode2"		  "1")
				(mode_tile "Code"			1)
				(mode_tile "Decode"			0)
				(mode_tile "Cube"			1)
				(setq Rtn 2)
			)
			((= Mode 3)
				(set_tile "Mode3"		  "1")
				(mode_tile "Code"			1)
				(mode_tile "Decode"			1)
				(mode_tile "Cube"			0)
				(setq Rtn 3)
			)
		)
		Rtn
	)
	;
	(defun SwapPass (Mode / Rtn)
	
		(if LastPassword  (set_tile  "InputKeyMode1" LastPassword))
		
		(cond 
			((= Mode 1)
				(set_tile "PassRandom"			  "1")
				(mode_tile "InputKeyMode1"			1)
				(mode_tile "CharRandom" 	        0)
				(mode_tile "RefreshKey" 	        0)
				
				(if (IsEmptyBox "InputKeyMode1")
					(if (setq Rtn (IsOnlyNumberBox "CharRandom"))
						(set_tile  "InputKeyMode1"	(vl-list->string  (MakeKey (fix Rtn))))
					)
					(if (setq Rtn (IsOnlyNumberBox "CharRandom"))
						(if (> (fix Rtn) MinCharRandomPassword)
								(set_tile  "InputKeyMode1"	(vl-list->string  (MakeKey (fix Rtn))))
						)
					)
				)
				(setq Rtn 1)
			)
			((= Mode 2)
				(set_tile "PassInput"			  "1")
				(mode_tile "InputKeyMode1"			0) 
				(mode_tile "CharRandom" 	        1)
				(mode_tile "RefreshKey" 	        1)
				(set_tile  "InputKeyMode1"	"")
				(setq Rtn 2)
			)
		)
		Rtn	
	)
	;
	(defun FillInFile (/ Mode InFileName PathFile Rtn)
	
		(cond
			((= (get_tile "Mode1") "1")
				(setq Mode 1)
			)
			((= (get_tile "Mode2") "1")
				(setq Mode 2)
			)
			((= (get_tile "Mode3") "1")
				(setq Mode 3)
			)
		)
		(cond
			((= Mode 1)
				(setq InFileName  (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "InFileNameMode1"))))
			)
			((= Mode 2)
				(setq InFileName  (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "InFileNameMode2"))))
			)
			((= Mode 3)
				(setq InFileName  (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "InFileNameCube"))))
			)
		)
		(if (/= InFileName "")
			(setq PathFile (vl-filename-directory InFileName))
			(setq PathFile (getenv "USERPROFILE"))
		)
		;(if (setq Rtn (FormsOpenFileDialog (list PathFile "" "All File (*.*)|*.*" "Explorer File" nil) nil))
		(if (setq Rtn (FormsOpenFileDialog (list PathFile nil "*.*" "Explorer File" nil)))
			(cond 
				((= Mode 1)
					(setq InFileNameMode1 (car Rtn))
					(setq OutFileNameMode1 (strcat (vl-filename-directory (car Rtn)) "\\" (vl-filename-base (car Rtn)) ".enc"))
					(set_tile "InFileNameMode1"  InFileNameMode1)
					(set_tile "OutFileNameMode1" OutFileNameMode1)
				)
				((= Mode 2)
					(setq InFileNameMode2 (car Rtn))
					(setq OutFileNameMode2 (strcat (vl-filename-directory (car Rtn)) "\\" (vl-filename-base (car Rtn)) ".dec"))
					(set_tile "InFileNameMode2"  InFileNameMode2)
					(set_tile "OutFileNameMode2" OutFileNameMode2)
				)
				((= Mode 3)
					(setq InFileNameCube (car Rtn))
					(set_tile "InFileNameCube"  InFileNameCube)
				)
			)
		)
	)
	;
	(defun FillOutFile (/ Mode InFileName PathFile Rtn)

		(if (= (get_tile "Mode1") "1")
			(setq Mode 1)
			(setq Mode 2)
		)
		(if (= Mode 1)
			(setq InFileName  (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "OutFileNameMode1"))))
			(setq InFileName  (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "OutFileNameMode2"))))
		)
		(if (/= InFileName "")
			(setq PathFile (vl-filename-directory InFileName))
			(setq PathFile (getenv "USERPROFILE"))
		)
	
		;(if (setq Rtn (FormsOpenFileDialog (list PathFile "" "All File (*.*)|*.*" "Explorer File" nil) nil))
		(if (setq Rtn (FormsOpenFileDialog (list PathFile nil "*.*" "Explorer File" nil)))
			(cond 
				((= Mode 1)
					(setq OutFileNameMode1 (car Rtn))
					(set_tile "OutFileNameMode1" OutFileNameMode1)
				)
				((= Mode 2)
					(setq OutFileNameMode2 (car Rtn))
					(set_tile "OutFileNameMode2" OutFileNameMode2)
				)
			)
		)
	)

	;
	(defun ChkPsw (StrPsw / Entropy Rtn)
	
		;	1-70    bit	Debole
		;	70-90   bit Media
		;	90-127  bit Forte
		;	128-255 bit Molto forte
	
		(cond
			((null StrPsw)
				(setq Rtn -2)
			)
			((= StrPsw "")
				(setq Rtn -1)
			)
			(t 
				(setq Entropy (EntropyKey (vl-string->list StrPsw)))
				(cond
					((and (>= Entropy 0) (< Entropy 70))
						(setq Rtn 1)
					)
					((and (>= Entropy 70) (< Entropy 90))
						(setq Rtn 2)
					)
					((and (>= Entropy 90) (< Entropy 128))
						(setq Rtn 3)
					)
					((and (>= Entropy 128) (< Entropy 255))
						(setq Rtn 4)
					)
					(t
						(setq Rtn 5)
					)
				)
			)
		)
		Rtn
	)
	;
	(defun EntropyKey (LstKey / Rtn Rtn1 Rtn2 Rtn3 Rtn4 R L)
		
		
	;Pool												Elements					Pool size
	;Digits													0-9							10
	;Lower case Latin letters								a-z							26
	;Upper case Latin letters								A-Z							26
	;Latin letters											a-z, A-Z					52
	;Alphanumeric											a-z, 0-9					36
	;Alphanumeric & Upper Case								a-z, A-Z, 0-9				62
	;Special symbols (typical U.S. keyboard)	`~!@#$%^&*()-=_+[{]}\|;':",.<>/?		32		
		
		
		(setq Rtn1 0)
		(setq Rtn2 0)
		(setq Rtn3 0)
		(setq Rtn4 0)

		;(setq MinLengthKey 7)
		;(if	(>= (length LstKey) MinLengthKey)
		;	(setq Rtn1 1)
		;)
		(if LstKey
			(progn
				(foreach itm LstKey
					(cond
						((member (chr itm) (list "#" "$" "%" "&" "'" "(" ")" "*" "+" "," "-" "." ":" ";" "<" "=" ">" "?" "@" "[" "]" "^" "_" "`" "{" "|" "}" "~"))
							(setq Rtn1 32)
						)
						((member (chr itm) (list "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"))
							(setq Rtn2 10)
						)
						((member (chr itm) (list "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"))
							(setq Rtn3 26)
						)
						((member (chr itm) (list "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"))
							(setq Rtn4 26)
						)
						(t
							(setq Rtn1 32)
						)
					)
				)
				(setq R (+ Rtn1 Rtn2 Rtn3 Rtn4))
				(setq L (length LstKey))
				;E = L * log2(R)
				(setq Rtn (* L (/ (log R) (log 2))))
			)
		)
		Rtn
	)
	;
	(defun GetCodex (/ MsgErr GestWarning
					   Mode InFileName OutFileName Key EntropyPassword LstWarning LstError)
	
		; Error 
		;	100	Input Key Missing
		;	101	Out Key Missing

		;	102 Input FileName ""
		;	103 Input FileName Missing
		;	104 Output FileName ""
		;	105 InFileName OutFileName equal name
		;	106 n° char key ""
		;	107 n° char key < min char key

		; Warning
		;	200 Output FileName exist
		
		(defun MsgErr (LstError / itm)
			
			(foreach itm LstError
				(if (= (car itm) 100)	(LM:popup "Errore" "[ ENCRYPT ] Chiave non dichiarata" (+ 0 16 4096)))
				(if (= (car itm) 101)	(LM:popup "Errore" "[ DECRYPT ] Chiave non dichiarata" (+ 0 16 4096)))
				(if (= (car itm) 102)	(LM:popup "Errore" "[ CUBE ]    Chiave non dichiarata" (+ 0 16 4096)))
				
				(if (= (car itm) 103)
					(cond	
						((= Mode 1) (LM:popup "Errore" "[ ENCRYPT ] In File non dichiarato" (+ 0 16 4096)))
						((= Mode 2)	(LM:popup "Errore" "[ DECRYPT ] In File non dichiarato" (+ 0 16 4096)))
						((= Mode 3)	(LM:popup "Errore" "[ CUBE ] In File non dichiarato"    (+ 0 16 4096)))
					)
				)
				(if (= (car itm) 104)
					(cond 
						((= Mode 1)	(LM:popup "Errore" (strcat "[ ENCRYPT ] " (cadr itm) " File non trovato") (+ 0 16 4096)))
						((= Mode 2)	(LM:popup "Errore" (strcat "[ DECRYPT ] " (cadr itm) " File non trovato") (+ 0 16 4096)))
						((= Mode 3)	(LM:popup "Errore" (strcat "[ CUBE ] "    (cadr itm) " File non trovato") (+ 0 16 4096)))
					)
				)
				(if (= (car itm) 105)
					(cond
						((= Mode 1) (LM:popup "Errore" "[ ENCRYPT ] Out File non dichiarato" (+ 0 16 4096)))
						((= Mode 2) (LM:popup "Errore" "[ DECRYPT ] Out File non dichiarato" (+ 0 16 4096)))
					)
				)
				(if (= (car itm) 106)
					(cond
						((= Mode 1)	(LM:popup "Errore" "[ ENCRYPT ] In File & Out File con lo stesso nome" (+ 0 16 4096)))
						((= Mode 2) (LM:popup "Errore" "[ DECRYPT ] In File & Out File con lo stesso nome" (+ 0 16 4096)))
					)
				)
				(if (= (car itm) 107) (LM:popup "Errore" "[ ENCRYPT ] Numero caratteri non valido" (+ 0 16 4096)))
			)
		)
		;
		(defun GestWarning (LstWarning / itm Rtn)
		
			(if (not LstWarning) (setq Rtn T))
			
			(foreach itm LstWarning
				(if (= (car itm) 200)
					(cond
						((= Mode 1)	
							(if (= (LM:popup "Avvertimento" (strcat "[ ENCRYPT ] " (cadr itm) "\n Vuoi sovrascriverlo ?") (+ 1 48 4096)) 1) 
								(setq Rtn T)
							)
							
						)
						((= Mode 2)	
							(if (= (LM:popup "Avvertimento" (strcat "[ DECRYPT ] " (cadr itm) "\n Vuoi sovrascriverlo ?") (+ 1 48 4096)) 1) 
								(setq Rtn T)
							)
						)
					)
				)
			)
			Rtn
		)
		;
		(defun GestPassword (Entropy / Rtn)
			
			(cond
				((= Entropy -2)
					(LM:popup "Avvertimento" "[ ENCRYPT ] Key non definita ?" (+ 0 48 4096))
				)
				((= Entropy -1)
					(LM:popup "Avvertimento" "[ ENCRYPT ] Key non definita ?" (+ 0 48 4096))
				)
				((= Entropy 1)
					(if (= (LM:popup "Avvertimento" "[ ENCRYPT ] Key debole vuoi ridefinirla ?" (+ 1 48 4096)) 2) 
						(setq Rtn T)
					)
				)
				(t 
					(setq Rtn T)
				)
			)
			Rtn
		)
		;
		
		;
		; Main
		;
		(cond 
			((= (get_tile "Mode1") "1")	(setq Mode 1))
			((= (get_tile "Mode2") "1") (setq Mode 2))
			((= (get_tile "Mode3") "1") (setq Mode 3))
		)
		;
		(setq InFileNameMode1  (GetTextBox "InFileNameMode1"))
		(setq OutFileNameMode1 (GetTextBox "OutFileNameMode1"))
		(setq Password1		   (GetTextBox "InputKeyMode1"))
		
		(setq InFileNameMode2  (GetTextBox "InFileNameMode2"))
		(setq OutFileNameMode2 (GetTextBox "OutFileNameMode2"))
		(setq Password2   	   (GetTextBox "InputKeyMode2"))
		
		;(setq InFileNameCube   (GetTextBox "InFileNameCube"))
		;(setq Password3   	   (GetTextBox "InputKeyCube"))


		(cond 
			((= Mode 1)
				(setq InFileName  InFileNameMode1)
				(setq OutFileName OutFileNameMode1)
				(setq EntropyPassword (ChkPsw Password1))
			)
			((= Mode 2)
				(setq InFileName  InFileNameMode2)
				(setq OutFileName OutFileNameMode2)
			)
			;((= Mode 3)
			;	(setq InFileName  InFileNameCube)
			;)
		)


		(cond 
			((= Mode 1)
				(if (= Password1 "") 
					(setq LstError (append LstError (list (list 100 ""))))
					(setq Key Password1)
				)
				(if (not (IsOnlyNumberBox "CharRandom")) (append LstError (list (list 107 ""))))
			)
			((= Mode 2)
				(if (= Password2 "") 
					(setq LstError (append LstError (list (list 101 ""))))
					(setq Key Password2)
				)
			)
			;((= Mode 3)
			;	(if (= Password3 "") 
			;		(setq LstError (append LstError (list (list 102 ""))))
			;		(setq Key Password3)
			;	)
			;)
		)

		(cond 
			((or (= Mode 1) (= Mode 2))
				(cond
					((= InFileName "")				(setq LstError   (append LstError (list (list 103 "")))))
					((not (findfile InFileName)) 	(setq LstError   (append LstError (list (list 104 InFileName)))))
					((equal InFileName OutFileName) (setq LstError   (append LstError (list (list 106 InFileName)))))
				)
				(cond
					((= OutFileName "")				(setq LstError   (append LstError   (list (list 105 "")))))
					((findfile OutFileName)			(setq LstWarning (append LstWarning (list (list 200 OutFileName)))))
				)
			)
			;((= Mode 3)
			;	(cond
			;		((= InFileName "")				(setq LstError (append LstError (list (list 103 "")))))
			;		((not (findfile InFileName))	(setq LstError (append LstError (list (list 104 InFileName)))))
			;	)
			;)
		)
		
		(if LstError
			(MsgErr LstError)
			(if (GestPassword EntropyPassword)
				(if (GestWarning LstWarning)
					(progn
						(setq *Codex* (done_dialog)) 
						(unload_dialog xx)
						(vl-file-delete DclCodex)
						(setq LastPassword Key)
						(list InFileName OutFileName Key Mode)
					)
					nil
				)
			)
		)
	)
	;
	(defun LoadDataCodex ()
	
		(if InFileNameMode1 
			(if (findfile InFileNameMode1) 
				(progn
					(set_tile "InFileNameMode1" InFileNameMode1)
					(if OutFileNameMode1 (set_tile "OutFileNameMode1" OutFileNameMode1))
				)
			)
		)
		(if InFileNameMode2 
			(if (findfile InFileNameMode2) 
				(progn
					(set_tile "InFileNameMode2" InFileNameMode2)
					(if OutFileNameMode2 (set_tile "OutFileNameMode2" OutFileNameMode2))
				)
			)
		)
		(if InFileNameCube 
			(if (findfile InFileNameCube) 
				(set_tile "InFileNameCube" InFileNameCube)
			)
		)
		
		(set_tile "CharRandom" CharRandom)
		
		(SwapPass GuiCodeValuePass)
		(SwapCode GuiCodeValueCode)
	)
	;
	(defun OutputDcl (KeyName / EditBox 
								DclKey xx)
		
		(defun EditBox (/ dcl des x)
		
			(setq dcl (vl-filename-mktemp nil nil ".dcl"))
			(setq des (open dcl "w"))
			(foreach x
				'(	"OutKey:dialog" 
					"{"
					"	label=\"Key\";"
					"	:row {"
					"		:text{edit_width=15; label=\"Name Key\";}"
					"		:edit_box {fixed_width = true; edit_width=60; key=\"KeyName\";}"
					"	}"
					"	ok_only;"
					"}"
				)
				(write-line x des)
			)
			(setq des (close des))
			dcl
		)
		;
		; Main
		;
		(if KeyName 
			(progn
			
				(princ "\n") 
				(princ KeyName)
				
				(setq DclKey (EditBox))
				(setq xx (load_dialog DclKey))
				(new_dialog "OutKey" xx "" (cond ( *OutKey* ) ( '(-1 -1) )))
				(set_tile "KeyName" KeyName)
				(action_tile "accept" "(setq *OutKey* (done_dialog)) (unload_dialog xx) (vl-file-delete DclKey)")
				(action_tile "cancel" "(vl-file-delete DclKey)")
				(start_dialog)
			)
		)
	)
	;
	(defun WriteDclCodex (/ dcl des x)

        (setq dcl (vl-filename-mktemp nil nil ".dcl"))
        (setq des (open dcl "w"))
		(foreach x
			'(	"CodeX:dialog"
				" {"
				"	label=\"Codex\";"
				"	: boxed_radio_row {"
				"			:radio_button {label=\"Cifra\"; key=\"Mode1\";}"
				"			:radio_button {label=\"Decifra\"; key=\"Mode2\";}"
				;"			:radio_button {label=\"Grafica\"; key=\"Mode3\";}"
				"	}"
				"	:boxed_column {"
				"		width=95;"
				"		label=\"Cifra\";"
				"		key=\"Code\";"
				"		:row {"
				"			:button   {width=20; fixed_width = true; label=\"In File\"; key=\"PathInFileMode1\";}" 
				"			:edit_box {fixed_width = true; edit_width=60; key=\"InFileNameMode1\";}"
				"			:button   {width=15; fixed_width = true; label=\"Edit\"; key=\"EditPathInFileMode1\";}" 
				"		}"
				"		:row {"
				"			:button   {width=20; fixed_width = true; label=\"Out File\"; key=\"PathOutFileMode1\";}" 
				"			:edit_box {fixed_width = true; edit_width=60; key=\"OutFileNameMode1\";}"
				"			:button   {width=15; fixed_width = true; label=\"Edit\"; key=\"EditPathOutFileMode1\";}" 
				"		}"
				"		: boxed_radio_row {"
				"			:radio_button {label=\"Chiave casuale\"; key=\"PassRandom\";}"
				"			:radio_button {label=\"Chiave imposta\";  key=\"PassInput\";}"
				"		}"
				"		:row {"
				"			:button   {width=20; fixed_width = true; label=\"Chiave\"; key=\"RefreshKey\";}" 
				;"			:text     {width=20; label=\"Chiave\";}"
				"			:edit_box {fixed_width = true; edit_width=55; fixed_width = true;  key=\"InputKeyMode1\";}"
				"			:text     {width=7; label=\"N. Car\";}"
				"			:edit_box {fixed_width = true; edit_width=8; fixed_width = true;  key=\"CharRandom\";}"
				"		}"
				"	}"
				"	:boxed_column {"
				"		width=95;"
				"		label=\"Decifra\";"
				"		key=\"Decode\";"
				"		:row {"
				"			:button   {width=20; fixed_width = true; label=\"In File\"; key=\"PathInFileMode2\";}" 
				"			:edit_box {fixed_width = true; edit_width=60; key=\"InFileNameMode2\";}"
				"			:button   {width=15; fixed_width = true; label=\"Edit\"; key=\"EditPathInFileMode2\";}" 
				"		}"
				"		:row {"
				"			:button   {width=20; fixed_width = true; label=\"Out File\"; key=\"PathOutFileMode2\";}" 
				"			:edit_box {fixed_width = true; edit_width=60; key=\"OutFileNameMode2\";}"
				"			:button   {width=15; fixed_width = true; label=\"Edit\"; key=\"EditPathOutFileMode2\";}" 
				"		}"
				"		:row {"
				"			:text     {width=20; label=\"Chiave\";}"
				"			:edit_box {fixed_width = true; edit_width=60; fixed_width = true;  key=\"InputKeyMode2\";}"
				"			:spacer   {width = 15;}"
				"		}"
				"	}"
				;"	:boxed_column {"
				;"		width=95;"
				;"		label=\"Grafica\";"
				;"		key=\"Cube\";"
				;"		:row {"
				;"			:button   {width=20; fixed_width = true; label=\"Importa file\"; key=\"PathInFileCube\";}" 
				;"			:edit_box {edit_width=60; key=\"InFileNameCube\";}"
				;"			:button   {width=15; fixed_width = true; label=\"Edit\"; key=\"EditPathInFileCube\";}" 
				;"		}"
				;"		:row {"
				;"			:button   {width=20; fixed_width = true; label=\"Esporta\"; key=\"ReadCube\";}" 
				;"		}"
				;"		:row {"
				;"			:text     {width=20; label=\"Chiave\";}"
				;"			:edit_box {fixed_width = true; edit_width=60; fixed_width = true;  key=\"InputKeyCube\";}"
				;"			:spacer   {width = 15;}"
				;"		}"
				;"	}"
				"	ok_cancel;"
				"}"		
			)
			(write-line x des)
		)
        (setq des (close des))
        dcl
	)
	;
	(defun EditFile (NameFile)
		(if NameFile
			(if (and (/= (vl-string-right-trim " \t" (vl-string-left-trim " \t" NameFile)) "")
					     (findfile (vl-string-right-trim " \t" (vl-string-left-trim " \t" NameFile)))
				)
				(EasyCutViewer (vl-string-right-trim " \t" (vl-string-left-trim " \t" NameFile)))
			)
		)
	)
	;
	(defun CharRandomAction (value_ reason_ / Rtn)

		(if (setq Rtn (IsOnlyNumberBox "CharRandom"))
			(if (>= (fix Rtn) MinCharRandomPassword)
				(if (IsEmptyBox "InputKeyMode1")
					(set_tile  "InputKeyMode1"	(vl-list->string  (MakeKey (fix Rtn))))
					(if (/= (fix Rtn) (strlen (get_tile "InputKeyMode1")))
						(set_tile  "InputKeyMode1"	(vl-list->string  (MakeKey (fix Rtn))))
					)
				)
				(progn
					(set_tile  "InputKeyMode1"	"")
					(LM:popup "Errore" (strcat "[ ENCRYPT ] Chiave minore di " (rtos MinCharRandomPassword 2 0) " caratteri") (+ 0 16 4096))
				)
			)
			(progn
				(set_tile  "InputKeyMode1"	"")
				(LM:popup "Errore" "[ ENCRYPT ] Numero caratteri della chiave non valido" (+ 0 16 4096))
			)
		)
		;(set_tile  "InputKeyMode1"	(vl-list->string  (MakeKey (atoi (get_tile "CharRandom")))))
		;(alert (strcat value_ " -- "(rtos reason_ 2 0)))
	)
	;
	(defun RefreshKeyAction (/ Rtn)

		(if (setq Rtn (IsOnlyNumberBox "CharRandom"))
			(if (>= (fix Rtn) MinCharRandomPassword)
				(set_tile  "InputKeyMode1"	(vl-list->string  (MakeKey (fix Rtn))))
				(progn
					(set_tile  "InputKeyMode1"	"")
					(LM:popup "Errore" (strcat "[ ENCRYPT ] Chiave minore di " (rtos MinCharRandomPassword 2 0) " caratteri") (+ 0 16 4096))
				)
			)
			(progn
				(set_tile  "InputKeyMode1"	"")
				(LM:popup "Errore" "[ ENCRYPT ] Numero caratteri della chiave non valido" (+ 0 16 4096))
			)
		)
	)

	;
	; Main
	;
	(setq MinCharRandomPassword	20)
	(if (not CharRandom)        (setq CharRandom "20"))
	(if (not GuiCodeValueCode)	(setq GuiCodeValueCode  1))
	(if (not GuiCodeValuePass) 	(setq GuiCodeValuePass  1))

	(setq DclCodex (WriteDclCodex))
	
	(setq xx (load_dialog DclCodex))
	(new_dialog "CodeX" xx "" (cond ( *Codex* ) ( '(-1 -1) )))
	(LoadDataCodex)
		
	(action_tile "Mode1" 				"(setq GuiCodeValueCode (SwapCode 1))")
	(action_tile "Mode2" 				"(setq GuiCodeValueCode (SwapCode 2))")
	(action_tile "Mode3"				"(setq GuiCodeValueCode (SwapCode 3))")
	
	(action_tile "PassRandom" 			"(setq GuiCodeValuePass (SwapPass 1))")
	(action_tile "PassInput"  			"(setq GuiCodeValuePass (SwapPass 2))")
	(action_tile "CharRandom" 			"(CharRandomAction $value $reason)")
	(action_tile "RefreshKey" 			"(RefreshKeyAction)")
	
	
	(action_tile "PathInFileMode1"  	"(FillInFile)")
	(action_tile "PathOutFileMode1" 	"(FillOutFile)")

	(action_tile "EditPathInFileMode1"  "(EditFile (get_tile \"InFileNameMode1\"))")
	(action_tile "EditPathOutFileMode1" "(EditFile (get_tile \"OutFileNameMode1\"))")
	
	(action_tile "PathInFileMode2"  	"(FillInFile)")
	(action_tile "PathOutFileMode2" 	"(FillOutFile)")

	(action_tile "EditPathInFileMode2"  "(EditFile (get_tile \"InFileNameMode2\"))")
	(action_tile "EditPathOutFileMode2" "(EditFile (get_tile \"OutFileNameMode2\"))")

	(action_tile "PathInFileCube"   	"(FillInFile)")
	(action_tile "ReadCube"   			"(setq Rtn (list nil nil nil 4) *Codex* (done_dialog)) (unload_dialog xx) (vl-file-delete DclCodex)")

	(action_tile "EditPathInFileCube"  	"(EditFile (get_tile \"InFileNameCube\"))")

	(action_tile "accept"   			"(setq Rtn (GetCodex))")
	(action_tile "cancel"   			"(setq Rtn nil  *Codex* (done_dialog)) (unload_dialog xx) (vl-file-delete DclCodex)")

	(start_dialog)

	(if Rtn
		(cond
			((= (nth 3 Rtn) 1)
				(if (code02 (nth 0 Rtn) (nth 1 Rtn) (vl-string->list (nth 2 Rtn)) (nth 3 Rtn))
					(progn
						(EasyCutViewer  (nth 1 Rtn))
						(OutputDcl (nth 2 Rtn))
					)
				)
			)
			((= (nth 3 Rtn) 2)
				(progn
					(code02 (nth 0 Rtn) (nth 1 Rtn) (vl-string->list (nth 2 Rtn)) (nth 3 Rtn))
					(EasyCutViewer  (nth 1 Rtn))
				)
			)
			((= (nth 3 Rtn) 3)
				(GraphicsCodex (nth 0 Rtn))
			)
			((= (nth 3 Rtn) 4)
				(ReadCube)
			)
		)
	)
	(princ)
)
;
(defun Code02 (FileImport FileExport Key Mode / SetupEncrypt PrintProgress GetNth
												EncryptAsciiFile DecryptAsciiFile EncryptKeyPassword DecryKeyPassword
												GetAsciiBigData CheckDecryKeyPassword
												GetItmList MsgError MakeHexadecimalDigits
												LstKey1 LstKey2 Rtn Error
												; Global Var 
												NextPw MaxCarLine CodeControlNewLine CodeAssoc)
	;
	; mode 1 = crittografa il file
	; mode 2 = decrittografa il file
	; Key    = stringa (chiave di codifica)
	;
	;(code02 "C:\\Users\\ut04\\Desktop\\Tmp\\test.lsp" "C:\\Users\\ut04\\Desktop\\Tmp\\test.enc" "a" 1)
	;(code02 "C:\\Users\\ut04\\Desktop\\Tmp\\test.enc" "C:\\Users\\ut04\\Desktop\\Tmp\\test.dec" "a" 2)
	;
	;(code02 "C:\\EasyCutBeta\\Decode\\test\\test.lsp" "C:\\EasyCutBeta\\Decode\\test\\test.enc" "a" 1)
	;(code02 "C:\\EasyCutBeta\\Decode\\test\\test.enc" "C:\\EasyCutBeta\\Decode\\test\\test.dec" "a" 2)
	;
	;
	(defun GetNth (List Value)
		(if (and List Value)
			(vl-position Value List)
		)
	)
	;
	(defun SetupEncrypt ()

		(setq NextPw 0)
		(setq MaxCarLine 20)
		(setq CodeControlNewLine (list 2 3 4 5 6 7 8))
		
		(setq CodeAssoc (list   "2m" "W~" "2=" ")8" ",A" ":i" "gp" "L^" "F|" "L[" ")y" "Zf" "@m" "Cf" "Vh" 
								".I" ")|" "El" "'0" "+1" "@j" "1X" "<q" "=z" "=Z" "R[" "Tq" ".7" "*," "GQ" 
								"6C" "Qx" "1b" "9u" "Rj" "Eh" "%I" ";V" "OP" ",L" "Oe" "&;" "(e" "(Z" "Nl" 
								"4@" ",1" "Rz" "OT" "Vr" "69" "8t" "&~" "il" "4C" "y|" ">W" "+7" "0u" "5O" 
								"Mo" "Rx" "4Z" "=u" "^i" "*o" "Z]" ".a" "DY" "%2" "O|" "5o" "$l" "Ir" "3C" 
								"]j" ";`" "%F" ",J" "4k" "n{" "'i" "+Z" "1`" "Jy" "Na" "3z" "Ym" "1e" "=k" 
								"6{" "?l" "O_" "BV" "Eg" "Mh" "Qy" "N}" "9M" "$5" ",:" "_c" "7i" "bf" "8C" 
								"09" "KR" "fj" "4d" "2u" "_}" "Yd" "#." "oq" "Mq" "(f" "0q" "KY" "17" "Mx" 
								"6k" "@G" "EO" ",|" "GN" "-5" "_i" "AK" "$c" "`d" "9b" "*W" "_|" "d{" "6f" 
								"z~" "Al" "+W" "O`" "^x" "(0" ";h" "%y" "(C" "5~" "nq" ")c" "=|" ":d" "-q" 
								".k" "Tm" "-F" "Jg" "i|" "C`" "o~" "RU" "DS" "&5" "+;" "<j" "UY" "%:" "3f" 
								"=J" "HJ" "29" ")C" "7O" "<E" "o|" "Ix" "M{" "4W" "t{" "lz" "Ny" "Ip" ")d" 
								":L" "&6" "Cz" "Ic" ")R" "bp" "dz" "=}" "<J" "&h" "n~" "3q" "$V" "9z" "=d" 
								"2Q" "Vi" ",{" "9f" "[i" "Ja" "6>" "8P" "+|" "$@" "(:" "$d" ",}" "(>" "n|" 
								">A" "$G" "(j" "0y" "bg" "8@" "6M" "Pv" "A^" "@F" "lq" "]w" "{|" "1w" "^|" 
								"Pr" "<t" "MO" "2R" "%t" ",k" "-|" "Co" ",c" "Cg" ",R" "6U" ">{" "2^" ">B" 
								"?n" "=I" "[s" "3W" "$%" ",@" "%T" ">n" "#%" "5=" "7J" "jp" ":[" "Gr" "9y" 
								"bn" "4w" "?V" "Pd" "2W" "6L" "4r" "PX" "8d" "*c" "CE" "Ax" "6p" "s|" "DX" 
								"v}" ">u" "18" ")7" "y~" "5r" "23" "Bm" ",3" "j|" "%4" "7^" "=A" "Ox" "$7" 
								"P}" "ST" "%a" "<I" "`g" "2G" "1O" "._" "IN" "%9" "X^" "Fa" "Lt" "7h" "Ts" 
								"4`" "^k" "S`" "]u" "Zo" "^}" "+E" "Nj" "Mm" "8y" "Mi" "*P" "8N" "*?" "9P" 
								"CG" "#'" "7I" "3K" "Eb" "Ju" "'G" ")V" "&," "U^" "mr" "9Q" "7Q" "$I" "9_" 
								"JW" "-{" "#2" "Lf" "%S" ")a" "(U" "OZ" "J^" "+n" "O~" "'H" "1r" "#*" "Yp" 
								"?W" "25" "YZ" "Rh" "AQ" "'O" "4z" "Ui" "<L" "3|" "24" "@T" "AR" "8:" ":J" 
								"7K" "(P" ">d" "+H" "N`" ".s" "#b" "]|" "5j" "V^" "S[" "Mz" ":f" "3O" "Y}" 
								"Uy" "$R" "aq" "Lb" "Em" "^u" "&:" "ho" "#V" "$;" "7T" "`v" "RY" "Da" "x|" 
								"Uh" "Ru" "@o" "Sg" "=y" "Wv" "5p" "?Q" "EN" "?C" ",^" "1P" "T]" "=`" "@U" 
								"&i" "Cn" "4g" "A}" "3;" "SY" "KX" "#K" "GI" "9D" "4F" "ox" "3p" "bc" "?g" 
								"Rw" "0W" "MU" "H}" "04" "ik" "Sl" "%5" "e{" "4=" "?x" ">s" "MT" "9@" "$D" 
								"_o" "6g" "QT" "nu" "Zc" "[]" "5^" ")s" "BE" "#P" "L~" "^f" "iz" "FV" "X|" 
								":I" "T^" ">E" "Dz" "<n" "Ud" "+U" "QS" "#&" ";Z" "CD" "5C" "0@" ".Q" "2y" 
								"Af" "Z~" "<^" "m{" "x}" "Oo" "#1" "0l" ",E" "q|" "9?" "Zt" "GV" "8w" "<u" 
								"58" "AB" "Db" "w{" "Yj" "D|" "Mb" "5Z" "]}" "dj" "3{" "4T" "Dd" "%]" "%)" 
								"%D" "XZ" "'Z" "Dm" "%K" "jt" "X_" "_{" "kt" "${" "DZ" "hl" "*Q" "GS" "A`" 
								"dx" "=H" "ey" "*." "=M" "Tb" ">`" "+K" "2N" "ij" "O]" "M^" ":E" "Kk" "9S" 
								"Rl" "a{" "-d" "<b" "BZ" "Gd" "Ef" "E]" "Bf" "I_" "26" "2_" "[{" ",p" "7w" 
								"FJ" ":O" "$3" "=E" "?U" ";H" ".=" "z{" "Zl" "DR" "6n" "Ga" "'q" "#l" "?F" 
								"-Y" "F~" "Fy" "C{" "#T" "]v" ">q" "5_" "48" "[g" "`b" "Eq" "%j" "%p" "cl" 
								"=q" "9Y" "+x" "'S" ")j" "iw" "J`" "2X" "v|" "JZ" "[t" "8L" "5i" "in" ",;" 
								"0x" "12" "4l" "fs" "Dt" "Hg" "EV" "vz" "DM" "*@" "E|" ".|" "Qt" "?K" "QR" 
								"-b" "-;" "#C" ".m" "bj" "*p" ";A" "2J" "4h" "G}" "dk" "%Z" "*d" "?q" "ek" 
								"Zy" "'u" ">K" "h{" ")p" "+=" "<v" "7o" "){" ".l" "@f" ";_" "%E" "#M" "?p" 
								":S" "3e" "EI" "[^" "=R" "DJ" "8g" "(1" "^q" "df" "Zg" "=V" "*k" "Dv" "%<" 
								"+@" "#+" "Sp" "Xr" "2C" "0I" ";x" "6Y" "a}" "`y" "Qp" "8a" ")t" "KZ" ";C" 
								"mw" "Va" "L_" "*}" "]o" ";@" "*|" "Zp" "@t" "-6" "(E" "(T" "d~" "g}" "jq" 
								"iu" "9B" "fy" "Vq" "Ey" ".z" "Yt" "<s" "T~" "HQ" "2q" "n}" "=G" "Gw" "3h" 
								"1h" "Vb" "ES" "DV" "aj" "*N" "EW" "-h" "X~" ")o" ".K" "Dh" "IK" ",b" "I}" 
								"*_" ";k" "ls" "Ws" "It" "Wp" "Jv" ")U" "at" "6_" "6B" "0o" "s~" ".H" "4H" 
								">]" "#g" "N{" "4Q" "%*" "+5" "^w" "EH" "1a" "rx" "P{" "3D" "FW" ",>" "NQ" 
								"8R" "EP" "9m" "et" "LP" ";y" "EG" "Ry" "Ro" "+," "Th" "-n" "'B" "JT" "%B" 
								"&0" "0n" "ju" "0s" "=h" ":`" "%n" "+q" "Qz" ".r" "0w" "&|" "NS" "]b" "bs" 
								"Uk" "37" "by" "FT" "%8" "B}" "9>" "*y" "1H" "Iv" "(d" "a|" ":V" "[_" "E{" 
								"8M" ":M" "Ch" ",r" "3b" ",e" "%v" "Ol" "%H" "D_" "i}" "4:" "Vo" ">C" "$|" 
								"#p" "<_" "#)" "+~" "Zb" "w~" ":o" "Il" "Cv" "9n" "Bu" "R{" ":Y" "Qk" "4>" 
								"BH" ".?" "*S" "cm" "Ka" "$&" "5F" "#}" "k~" "$i" "&2" "JN" "&^" ">j" "%3" 
								"Oc" "BI" "Mv" "Z}" ".4" "bq" "47" "9L" "'>" ";z" "^l" "4v" "Jq" "GM" "[b" 
								"'P" "@h" "+Q" "#B" "Ty" "%i" "$n" "@W" "*+" "vw" "Ld" "6R" "Tj" "$K" "&U" 
								"bt" "#Z" "dg" "D{" "Cu" "LN" "Q]" "Nw" "7}" "km" "Bg" "01" ")Q" "Jc" "(k" 
								"$H" "nv" ")I" "Lk" "&O" "Hx" "0{" "3J" "&Z" ">r" ".q" "<e" "Xl" "ir" "Aa" 
								"Fs" "(W" "'C" "G]" "My" "$." "l|" "U{" "Hq" "PQ" "%c" "%[" ">m" "4N" "<h" 
								"Wo" "R|" "%C" "Yi" "#6" "%Y" "'X" "FP" "Mn" "e|" "tw" "J|" "@l" "au" "ch" 
								",G" "3F" "Mk" "Ij" "(6" "Ma" "8k" "-1" "`f" "(Q" "Yc" "Q|" "0O" "B{" "G_" 
								"#d" ")k" "Wr" "Uq" "#i" "nt" "LX" "7r" "Ge" "$A" "7X" "m|" "Ow" "OX" "3M" 
								"Rn" ">M" "Pp" "Kg" "b|" "9W" ":G" "ms" "Ya" "$}" "'R" "NP" "%m" "7d" "di" 
								"Pl" "P`" "G^" "GY" "5c" "Ne" "@B" "3P" "(r" "'z" "CZ" "O{" "Km" "5H" "%b" 
								"2O" "0a" "KT" ",Q" ":Q" "fu" "(K" "6i" "#3" "qz" "9A" "fr" "$m" "Xi" "_p" 
								"st" "_m" "-7" "NZ" "@X" "Fc" "O}" "7C" ";B" "2?" "&Q" ")w" "5W" "2L" "*t" 
								"VY" "9l" "mn" ";t" "2z" "E^" "2:" "ef" "E[" "R^" ",Y" ".f" ")z" "TW" "]k" 
								"Vp" "Lo" "Iq" "pq" "qy" "?^" "&_" "y}" "g{" "is" "cp" "RW" "-Q" "%l" "^n" 
								"iq" ">D" "az" "(@" "0z" "6j" "7<" "59" "Ak" "+{" "ln" "(." "^a" ")J" "E_" 
								"%A" "9O" "*n" "Qj" "4S" "lt" "<F" "+." "Gc" "Zs" "AM" "cs" "2a" "%P" ")W" 
								"jo" "Cq" "G~" ">l" "$*" ")M" "MR" "[m" "Nt" "%," "I^" "dr" "&}" "+e" "34" 
								"ep" "jy" "JL" "0`" "@n" "'k" "G[" "BJ" "<c" "TV" "EX" "<V" "Vg" "'`" "1j" 
								"ej" "2M" "?a" ";U" "$t" "*Y" "7x" "1~" "Ob" "*M" "0B" "5{" "0k" "cf" "-R" 
								"$?" "0Q" "Q`" "cy" "(n" "Hh" "Mc" "En" "xy" ";K" ",P" "Ay" "8F" "68" "Ek" 
								"Ie" "Td" "De" "$q" "$v" "j{" ">T" "A|" "&9" "({" "PR" "dh" "gq" "ks" "-." 
								"E~" "f{" "kw" "e}" "K_" "Ua" "7;" "@z" "FO" "|~" "Dx" "0?" "-D" "P~" ":N" 
								"-=" "<A" "'A" "#-" "Qm" "E}" "6:" "&A" "'." "js" "bh" "mv" "&w" "*D" "W{" 
								">|" "@e" ");" "(V" "@g" "ly" "H~" ">V" "h}" "Dw" "3N" "Vc" "8p" "Ac" ">L" 
								"M|" "*O" "fo" "AJ" "+s" "7B" "@i" "*C" "ck" "2p" "Au" "NO" "FX" "`o" "&3" 
								"2V" "&C" "Nn" ">~" ",C" "z|" "FR" "<R" "=e" "=b" "Xg" ",[" "#G" "8Y" ")Y" 
								"^y" "9U" "_e" "#k" "FY" "Hn" "'6" "Ht" "?S" "KL" "Kw" "K`" "7S" "7p" "Oy" 
								"Qh" "io" "*A" "]i" "3X" "Cc" "+A" ")+" "2U" "#{" "cz" "Vl" "B[" "8>" "%?" 
								"s}" "16" "Me" "OS" "Op" "=@" "Ca" "-x" "0P" "Uw" "OV" "(R" "2Z" "Q[" "Pe" 
								"Gy" "F{" "+k" "hs" "eo" "?[" "#@" "9F" "')" "7F" "jn" "FU" "@A" "&{" ",U" 
								"qv" "d}" "Bw" "%g" ">U" "CF" "^d" "%Q" "56" "5l" "=m" "'9" "JX" "0V" "_n" 
								"Aq" ">c" "0p" "<P" "AV" "-T" ",S" "7z" "@s" "^m" "C[" "p}" "-@" "O[" "Yv" 
								">o" "1_" "8l" "0A" "$-" ">h" "Gv" "=_" "im" "-H" "EZ" "Rp" "dv" "$'" "1k" 
								"Vs" ",4" "If" ".~" "-a" "1}" "#?" "`m" "kx" "hv" "Jt" "#w" "nr" ":R" "sv" 
								"1d" ".o" "]{" "ao" "^t" "W_" "#[" "8r" ";d" "8X" "Kn" "=^" "2D" "Wy" "q{" 
								"7k" "lw" "5a" "@r" "*Z" "0C" "DF" "d|" ";n" "$U" "Bp" "KV" ",d" "(i" "+0" 
								"Gi" ":P" "HK" "$(" "?}" "HP" "0Z" "?h" "%O" "3[" "1A" "Go" "e~" "9R" "?i" 
								"@k" ";G" "0D" "Ab" "6X" "Xd" "HX" ">^" "Ei" "$z" "Ea" "JK" "Ve" "-}" "`z" 
								"Hw" "Rv" "Qi" "#=" "G`" "4n" "8o" "FM" ")m" "8v" "<B" "?{" "3t" "`k" "@}" 
								"AT" "Fe" "Ag" ":u" "em" "5f" "-o" "@P" "-~" "Ku" "HY" "*0" "^{" "Sn" "Wj" 
								"0;" "BX" "1z" "ty" "45" "7=" "@`" "0e" "%(" ":c" "Wg" "Kj" ":_" ")," "Wa" 
								"0_" ">y" ":B" "(7" "*E" "7v" "pz" ")H" "+[" "Ly" "Am" ",I" ",j" "CP" "=P" 
								"2;" "*3" "?t" "$f" "ct" "J~" ",-" "AD" "'<" "Qe" ">b" "0d" "1N" "J]" "k}" 
								"my" "c~" ".y" "_v" "JY" "Ns" "1R" "&B" "0b" "'e" "7?" "py" "Qg" "(c" "hz" 
								"<]" "9:" "'M" "Om" "^j" ")u" "Do" "4~" "?y" "MX" "<=" "Hr" "<f" "Oj" "-8" 
								"X{" "Xy" "HM" "Np" "OY" "Tg" "Yr" "7u" "=K" "@q" "av" "bi" "^c" "An" "=x" 
								"0G" "IS" "Y`" "8?" "#|" "ac" "-e" "QV" "Gm" "(^" "Y_" "6l" "3_" "Ki" ",i" 
								"#v" "#~" "UZ" "Ni" "@J" "3B" "o{" "9]" "BU" "0g" "y{" ".J" "0]" "In" "Ck" 
								"-p" "or" "(," "1>" ";~" "k{" "]`" "5I" "Be" "Mu" ">i" "Tv" "lo" "3V" "Nx" 
								"=W" ">}" "Vf" "U~" "2o" "'s" "S{" "K|" "Gj" "&x" ";W" "Iu" "H|" "cw" "#(" 
								"jx" "4U" "6;" "Zm" "^g" "]a" "#s" "5G" "6I" ",a" "qr" "fp" "dl" "Sf" "%@" 
								"AL" ".N" "Ce" "V`" "2l" "6S" ".w" "1M" "2Y" "Yf" "S_" "(h" "+N" ")Z" "kl" 
								"GW" "#x" "TU" "Y]" "ce" "5[" ";[" "Hf" "i{" "Fi" "-v" "lx" "Di" "1o" "P_" 
								")F" "DI" "6=" "[h" "6H" "&b" "-M" "-f" "Jz" "6~" "Ps" "Jb" "Xn" "sz" "6o" 
								":K" "$6" "Us" "=]" "Gx" "LR" "6v" ",q" "<[" "rz" "A{" "CS" "'g" "=j" "JR" 
								"MQ" "'I" "CM" "8j" "4<" "$L" ")^" "]z" "Tp" "CR" "Qo" "6a" "Bt" "&W" "HN" 
								"+`" "Nr" ">Z" "Gn" "*F" "]~" ":Z" "8=" "_q" "Hs" ".F" "5J" "qt" "Tx" "CT" 
								"'h" "=X" "(w" "0R" ":F" "IT" "0U" "Hz" "'Y" "4b" "Rb" "4{" "Up" "%U" "qw" 
								"]e" "9X" "3j" "eg" "=v" ",t" "Pz" "[a" "Bz" "4m" "'4" ":H" "Qw" "7|" "*5" 
								"D]" "-`" ":>" ";N" "<}" "Qu" "L|" "T|" "08" "'K" "2~" "+y" "8E" ")L" "0j" 
								"#z" "fi" "Yb" "Ug" "&M" "IV" "R~" "U[" "pv" "8|" "^_" "Te" "0:" "Z^" "QZ" 
								"bo" "^b" "'@" "AP" "B]" "$9" "QW" "1^" "#:" "Fh" "I|" "*K" "Pq" "OU" "<|" 
								"1c" "Q^" "O^" "*6" "M~" "Re" "+R" "Ib" "_`" "'+" "@R" "Un" "Et" "cg" "-_" 
								"Hj" "HV" "Sh" "PW" ")h" "#Y" "hp" "Nz" "bv" "Px" "Ct" "1F" "(G" "(5" "1K" 
								"Xe" "3H" "Uu" "z}" ";]" "*^" ",f" "NT" "<p" "J_" "Br" "8s" "<~" "=w" "@~" 
								"QY" "8B" "*m" "BC" "&c" ",V" "7]" "$J" "7b" ",X" "gn" "1<" "6m" "-<" "<w" 
								"Iw" "H]" "go" "Kr" "8i" "_a" "3L" "-B" "hi" ";=" "ai" ":T" "Yx" "Rq" ",D" 
								"2S" "]_" "19" "Tc" ",`" "3}" "#F" "?P" ".5" "ny" "*r" ")=" "Zq" "*f" "do" 
								"-L" "gt" "{~" "=n" "&X" "iy" "As" "8I" "->" "5K" ">Y" ")N" "7W" "OW" "Xw" 
								"Po" "6N" "-K" ",g" "2x" "hj" "'v" "<G" "as" "Ti" "Xh" ")g" "_r" "39" "Jo" 
								"jr" "6e" "8Q" "^s" "NR" "5s" "[~" "eq" "5k" "Pj" "fl" "5`" ";j" "5;" "%0" 
								"4E" "fx" "F`" "$Q" "Bc" "Jk" "B|" "#J" "MP" ".:" ".@" "f}" "(*" "Zu" "@_" 
								"Bi" ";e" "4a" "Dr" "-4" "w|" "es" "IZ" "<x" "pu" "IM" ",Z" "$T" "U|" "3I" 
								"$e" "w}" "$s" "Ky" "1g" "?o" "c}" "X]" "Lh" "M_" "7a" "AI" "Gl" "Kp" "R}" 
								"2f" "Ad" "[k" "0F" "0i" "%q" "9=" ".D" "(O" "MZ" "Ll" "p{" "v~" "-A" "hx" 
								"#m" ">S" "@y" ";T" "IX" "cx" "0~" "A]" "&z" "I`" ",2" "6W" "$_" "%z" "^e" 
								"H{" "1=" "KO" "Mt" "+<" ")S" "]^" "Yn" "(F" "X`" "2i" "M}" "]d" "3A" "Dj" 
								"5y" "b~" "'(" ":}" "Fd" "Pu" "%-" "BF" "R`" "([" "+J" "Gz" ";M" "[p" "$2" 
								"'a" "Xm" ".;" "Y|" "(|" "-?" "FL" ",0" ";F" "MN" "Nu" ".S" "bl" "Sk" "`h" 
								"ak" "9q" "67" "|}" "^r" ">t" "89" ".6" "#o" "Wt" "CO" "BP" "BK" "Jp" "Sd" 
								"Fp" "1?" "NW" "Ar" "He" "<D" "N^" "Ez" "5M" "?Z" "CN" "&(" "$)" "-S" "Vn" 
								"]q" "0L" ")X" ")0" "'1" "'}" "#R" "#9" "7g" "6O" ":n" "'?" "+V" "Aw" "]g" 
								")D" "4D" "No" "-N" "Js" ".Z" "tx" "gj" ">p" "bd" "FK" ".t" "ru" "cu" "&4" 
								"S~" "5z" "]t" "&f" "u~" "%r" "?j" "ow" "_b" "+S" "?D" "Kh" "-G" "i~" "Im" 
								"'f" "rt" "Xj" "+l" "R_" "U`" "9H" ",B" "(8" "Mr" "<m" "8]" "PY" ">@" "CV" 
								"g~" "1@" ",T" "5q" "@|" "r~" "`n" ".i" "Xv" ")4" "Fz" "1Z" "&P" "Vt" "-2" 
								"+I" "Sw" ">N" "&+" "$~" "3u" "hr" ";{" "'w" "ar" "QU" ")q" "DG" "al" "(s" 
								":A" "@^" ":r" "7E" "$P" "%^" "BQ" ",u" "Uo" "<M" "2b" "ux" ",s" ";b" "Pb" 
								"9;" "5?" "UX" "bz" ":@" "@[" "<Q" "B~" "$+" "-P" "Cp" "it" ";^" "0J" "OQ" 
								"=s" ".^" "-c" ",_" "8J" "<@" "&*" "(y" ";Y" "Bn" "-O" ",." "4J" "PT" "1s" 
								"[|" "Fv" "1q" "@c" "u|" "&'" "_d" "(=" "4I" "LM" "5Y" "?X" "9k" "&e" "Ex" 
								"^~" "Qv" "Pn" "Hu" "$`" "(m" "7Z" "gi" "6q" "Py" "J}" ";D" ")-" "CI" ">F" 
								"9w" "3?" "BL" "+i" ".j" "Ok" "*U" "cj" "(o" "Nq" "-^" "3i" "_h" "7V" "bm" 
								"+X" "8e" "C}" "<U" "BN" "#4" "&I" "%J" "HS" "<S" "3k" "?u" "Ai" "Xx" "%s" 
								"<T" "?b" "g|" ">v" "Cx" "2g" ".T" "`j" "en" "Qc" "Wn" "FN" ".O" "np" "'=" 
								"5<" "oy" "2`" "_z" "PU" "HR" ".c" "tz" "@p" "gr" "$u" "*X" "=F" "?B" "2[" 
								".v" "$1" ";s" ".B" "ht" "[}" "eu" ",H" "0[" "mu" "&F" "@d" "hw" "0Y" "dw" 
								"%N" "&r" "9c" "2|" "C^" "`w" ";J" "rv" ">H" "8O" "KU" "hu" "'3" "6[" "R]" 
								"-s" "#u" "Wf" "CJ" "Wz" "GH" "ov" ")6" ">e" "Ao" "7R" "kn" "F^" "Zn" "RZ" 
								"8m" ".u" "^h" ">_" "+M" "1V" "4]" "(q" "Ff" ")O" "9V" ")*" "On" "9v" "jm" 
								"Vj" "1Q" "GT" "NU" "0c" "SZ" "@I" "Xa" "6r" "W`" ".X" "7@" "Tk" "Za" "Ta" 
								"fm" "eh" "'d" "Jd" "H^" "FH" "K]" "pw" "#t" "'c" "]s" "Ph" "=C" "'|" "m~" 
								"r}" "8V" ">z" "9N" ")v" "2v" "X}" "+m" "0H" "(9" "5@" ",~" "ot" "(p" "Kx" 
								"KP" "#$" "Ep" "5]" "D~" "'L" ":q" "-l" "?]" "*e" "-:" "*R" "Gh" "6}" "CW" 
								"5|" "GZ" "5>" "dt" "Yy" "_~" "Ha" "@Y" "9E" "gl" "7D" "^z" "_w" "5g" "<`" 
								"DP" "9G" "<y" "Z|" "9i" "5B" "<?" "Z`" "0>" "Ng" "Sx" "4p" "IQ" "<W" "&v" 
								"BD" "ix" "#>" "%;" ">R" "AO" "=t" "DO" ";?" "'n" "9|" "D`" "#O" "KW" "Wk" 
								"&J" "@M" "v{" "5e" "2j" ",<" "?_" "?@" "?~" "Qb" "h|" "'x" "'D" "LQ" ",y" 
								"%k" "*q" "Q}" ".Y" ",?" "=p" "Gq" "#j" "=c" "Og" "5b" "Ba" "bk" "2e" "be" 
								",x" "Xt" "ev" "XY" "ex" "uw" "+j" "%x" "J[" "SW" "Y{" "%e" "0K" "bu" "CX" 
								"()" "ab" "M[" "Dg" "8_" "?Y" ".1" "3n" "(<" "Jr" "+:" "TX" "Cd" "6A" "8`" 
								"Ks" "Bx" "2t" "8Z" "0S" "$b" "6^" "Ys" ".n" "H`" "3^" "7_" "S|" ";E" "Zz" 
								"0f" "_s" "*w" "Zv" "(l" "Y[" "cn" ",o" "9Z" "Y~" "?L" "@b" "-u" ";}" "Ur" 
								"[u" ")>" "fg" ",9" "fq" "[x" "+b" "Pa" "Nc" "Bj" "BG" "8<" "?`" "oz" "ko" 
								")1" "1]" "_u" "*l" "+_" "6x" "Q{" ")r" "Cj" ")T" "+p" "9~" "Gf" ".<" "Hl" 
								"T}" "*z" "2A" "WY" "I]" "La" "+D" "5T" "Dy" "@x" "Qn" "Z{" ".8" "q}" "#5" 
								"8W" ",v" "Kt" "mp" "%|" "(`" "*G" "c|" "iv" "@C" "MW" "?s" "%+" ":s" ":z" 
								"%>" "SX" "#n" "1v" "Rm" "UV" "'J" "Ii" "4q" "Zi" "(A" "gm" "F_" "=f" "7{" 
								"+T" "'E" "qu" "Nh" ",7" ",w" "Hp" "hm" "Sy" "#y" "Uf" "Pw" "Bb" "q~" "@V" 
								"1n" "*a" "`}" "0t" "IJ" "*b" "3m" "os" "ft" "7`" "T_" "*V" ")l" "6z" "[r" 
								"5Q" ",m" "'2" "Um" "-w" "cr" "+F" "0<" "'~" "3Z" ";q" "8f" "3o" "6<" "4;" 
								"<Y" "4X" "3y" "*]" "4}" "'U" "?J" "4_" "Yh" "Vd" "6]" "aw" "&." "f|" "]r" 
								"4B" ":h" "6E" "VX" "gs" "Qd" "&R" "9x" "FG" "+?" ";L" "<d" "3v" "ku" "1u" 
								"IW" ")<" "9o" "*-" "yz" "%V" "Dp" "Es" "H[" "N[" ")b" "7t" "*;" "`~" "Wq" 
								"D}" ".2" "(}" "Jw" "AW" "78" ")}" ".G" "P^" "-t" "dp" "#7" "27" "*u" "*4" 
								"Ft" "4A" "L{" "(3" "EQ" "Vk" "NY" "Fl" "=N" ":D" "6w" "Q_" "dq" "5u" "AU" 
								"Tn" "du" ";r" "cv" ")2" "2w" "x~" "'b" "8z" "(~" "VW" ">w" "rw" "Cy" "S]" 
								"Hv" "=B" "CU" "`s" "5}" "3E" "*T" "+d" "pt" "]n" ">f" "AY" "2]" "1G" "Mw" 
								"c{" "1x" "Lc" "1E" "Ho" "7y" "Fj" "9`" "_l" "+v" "B_" "$>" "):" "PZ" "(;" 
								"Li" "Ke" "Kv" "@H" "&G" "1U" ",h" "Nv" "Kb" "06" "+B" "$F" "Sm" ".x" "0v" 
								"DW" "%G" "[d" "Ik" ";O" "xz" "';" "dn" "Vw" "AZ" "<H" "]l" "I[" "&p" "nw" 
								"KS" ")A" "$g" "5n" "Cb" ",z" "AN" "Cs" "Fg" "4y" "'l" "$p" "Yo" "<r" "&<" 
								"*g" "7j" ";w" "03" "C]" "<N" "Bs" "3s" "Dc" ";u" "de" "C_" "&j" "6`" "px" 
								"*v" "V{" "4?" "1p" "(g" "LT" "'_" ")i" "AG" "PV" "Nb" "%f" "Sq" "Jl" ";R" 
								"Zk" "So" "1:" "&E" "(]" "CY" "#;" "$B" "1B" "GX" "MV" "Wb" "%d" "TY" "(z" 
								"jw" "lv" "Oz" "CQ" "gz" "-r" ":X" "+c" "Eu" "KN" "RX" "@E" "9h" "Pi" "9[" 
								"5U" "?f" "ns" "mo" "Wc" "no" ".U" "*B" "JS" ")_" "<Z" ":W" "a~" ">Q" "4u" 
								"Zx" "'N" "Yu" "1{" "el" "9{" "%." "(H" "2P" "br" "ax" "Wi" "$x" "@v" "7P" 
								".L" "*L" "5P" "Bv" "V~" "2T" ";S" "ry" "ei" "%7" "LV" "+G" "Xc" "8h" "9s" 
								"Vy" "V_" "[j" "BS" "7A" "Vz" ";P" "fn" ";|" "Cl" "co" ">J" "5X" "4O" "6V" 
								"+f" "$[" "2F" "?O" "#h" "(t" "IP" "'V" "'r" "2d" "P]" "*>" "RT" "t|" "K[" 
								"4t" "6K" "W[" "<{" "0^" ")K" "Xp" "Hb" "Ql" "ae" "15" "GR" ":<" ",=" "V}" 
								"Fx" "[f" "Nm" "CL" "HT" "7>" "Tl" "S^" "`e" "6P" "%R" "6F" "Pg" "3=" "(a" 
								"f~" "%M" "+-" "GO" "5A" "2E" "`l" "DL" "@Q" "$^" "Zr" "Ah" "Ra" "Tw" "Yz" 
								"Tt" "Jn" "Yl" "Rr" ".p" "lu" "tu" "%h" "+]" "&D" ")n" "Kd" "_j" "cd" "8~" 
								"+t" "HW" "`{" "Jm" "vx" "ps" "uy" ")e" "#8" "Ih" "Sz" "<>" "9}" "7:" "Bh" 
								"$Z" "&H" "Jf" "W|" "Xu" ">k" "Gs" "an" "gv" "-j" "Rt" "EJ" "1L" "3c" "?R" 
								"bw" "I{" "8^" "Mp" "36" "$C" "#Q" "ky" "'*" "gu" "-E" "1|" "p|" "GJ" "U]" 
								".R" "@O" "Ou" "^`" "U_" "Ko" "*I" "Ev" "HL" "fh" "&[" "m}" ".{" "s{" "2I" 
								")G" ".9" "Dn" "ci" ":p" "79" "&=" "-y" "DK" "p~" "T`" "9j" "AS" "7G" "8x" 
								"8c" "ip" "2>" "Tz" "V[" "op" "Lp" "+a" "%W" "RV" "Wu" "0X" "r|" "MY" "4P" 
								"Ul" ":a" "Kl" "C~" "=r" "t}" "Je" "*x" "Ej" "(u" ".]" "0N" "#D" "9p" ":=" 
								"#L" "?A" "`a" "9K" "$N" "Pf" "AC" "_k" "?M" "Ov" ";I" "UW" "DN" "kq" "'T" 
								"7U" "Yq" "Nk" "*h" ")f" ">?" "7l" "*<" "7H" "0|" "cq" "3G" "E`" "[w" "4^" 
								"Gu" "Hd" ".b" "IL" "6@" ">X" "1i" "&@" "Ln" "(4" "fv" "5v" "%_" "JM" "(Y" 
								"Qf" "dy" "+r" "Lr" "9a" "'o" "3Y" "-z" "3w" ",n" "L]" "7L" "9I" "#N" "<i" 
								"K{" ".g" "PS" "8u" "3]" "0}" "4f" "&g" ",K" "H_" "@w" "#a" "+P" "=D" "+C" 
								"=Y" "?E" "1t" "Vm" "Rc" "`|" "?e" "(B" "Gb" "3l" "DH" "4K" "LS" "Ye" "'t" 
								"+2" "Qs" ":k" "dm" "6t" "2@" "<C" "N~" "=l" "Hm" "1S" "Lj" "L`" "Uc" "*9" 
								"'-" "ds" "=S" "Dq" "Ue" ")P" ")B" ";X" "Lm" ".h" "-W" "Id" "Qa" "*8" "2n" 
								"@u" ">G" "=a" "AH" "Gg" "28" "&o" ".e" "%o" "@S" "P[" "8;" "3<" "KQ" "4i" 
								"Fq" "1y" "NV" "#X" "%}" "&y" "9g" "-i" "QX" "@L" "Kq" "Pc" "Tu" ">I" "Kz" 
								"X[" "4L" "jk" "D^" "4G" "#e" "Iy" "&]" ":j" "Io" ">g" "&u" "+}" "'[" "9e" 
								"3`" "#r" "?d" "BO" "6|" "j~" "Oh" "Ap" "{}" "3R" "7m" "4M" "*{" "&7" "N]" 
								"6d" "<o" "_f" "?c" "&)" "ez" "Oq" "@D" "Mj" "Ut" "am" "2K" "3d" "ay" ")[" 
								".3" "'W" "Cr" "Tf" "6s" "BT" "ET" "]h" "+3" "2{" "(?" "Ed" "0T" "(_" "`u" 
								"^p" "$W" "*:" "=o" "4o" ";p" "Ci" "?I" ">a" "By" "Wl" "I~" "gk" "1D" "&-" 
								":g" "(2" "[v" ")9" "Nd" "(S" "#q" ":~" ":e" "Kc" "+w" "BM" ",]" "1f" "nx" 
								"57" "ER" "$Y" "7N" "&>" "7f" "IU" "LY" "HO" "l~" "'7" "SV" "We" "Md" "^v" 
								")E" "9^" ",l" "Xo" "Mf" "IR" "2h" "#H" "(v" "wy" ";l" "mx" "Oa" "3S" "7e" 
								";>" ";c" "6T" "$<" "FS" "%'" "HI" "$h" "Sa" "Cw" "%{" "3:" "M`" "`c" "7~" 
								"N_" "(L" "Yw" "'^" "Nf" "+^" "*`" "&s" "%&" "Uj" "4V" "=L" "SU" "qx" "_y" 
								"9r" "DT" ",N" ")3" "Sc" "sy" "]c" "wz" "Or" "Fw" "$E" "8D" ",8" "*i" "-X" 
								"Yk" "%=" ".V" "qs" "Ig" "l{" "?z" "3U" "-C" ".`" "%L" "5R" "$o" "Wx" "hn" 
								"LU" "]x" "Bd" ";i" "A_" "Rf" "(D" ".C" "2<" "Sr" "Av" "EU" "2H" "4|" "pr" 
								"GL" ",5" "Jj" ")?" "Bo" "HZ" "5E" "Z_" ")~" "?w" "={" "+z" "Fn" "mz" "Jx" 
								"=g" "&T" "Yg" "&S" ".E" "<k" ";a" "<X" "(I" "EM" "@Z" "Fb" "EL" "Gk" "Vx" 
								":t" "ag" "5S" "kp" "EF" "Wh" "Uv" "6h" "lm" "P|" "+6" "5x" "49" "7c" "4j" 
								"8U" "=>" "A~" "[c" "S}" "#S" "Rg" "Zh" "_x" "W}" "@{" "`x" "<O" "6Z" "M]" 
								"Lg" "3@" "K~" "&?" "9d" ":^" "gh" "&8" "Ri" "2s" "}~" "L}" "*s" "Ae" "FQ" 
								"DU" "$S" "_t" "Ec" "F[" "6u" "FI" "2k" "1Y" "?|" "K}" "Qr" "+h" "ou" "-[" 
								"At" "'8" "$O" "#^" "gx" "*~" "AX" "8G" "']" "Os" "&N" "Az" "5L" "`r" "Qq" 
								"#f" "kr" "`p" "Zw" "$w" "&d" "er" "5:" ")." "Su" "Xk" "1[" "Ml" "Bq" "#`" 
								"Hk" "%6" "2B" "0h" ")@" "?r" "[n" ":l" "[z" "-I" "V]" ":m" "'{" "+L" "1m" 
								":y" "=i" "gw" ">P" "LW" ")x" "$:" "[e" "-J" "fz" "Zj" "5N" "+Y" "Fr" "T[" 
								"#]" "#," "Z[" ":b" "6c" "$," "Rs" "rs" "(b" "Lu" "&V" "t~" "OR" "Jh" "$M" 
								"-3" ";v" "LZ" "&L" "Bl" "+>" "Ss" "Cm" "7q" "Of" "`t" "St" "o}" "&n" "u}" 
								"U}" "Du" "+g" "-V" "8q" "&t" "-m" "?k" "kv" "Xz" "1;" "7M" "6D" "=Q" "Vu" 
								"RS" "Kf" "C|" "l}" "#<" "&m" "?H" "8{" ",6" "$r" "*2" ":U" "`i" "*7" "6G" 
								".>" "Le" "]m" "`q" "Aj" "To" "1C" "ad" "[y" "2c" "nz" ",F" "HU" "9T" ";<" 
								"1W" "%1" "Uz" "Wm" "0m" "+8" "Sb" ".0" "?m" "7[" "4s" "Lw" "Rd" "Bk" "Lq" 
								"NX" "IO" "&`" "GU" "F]" "14" "$]" "wx" "3r" "jl" "%`" "'m" "7s" "9t" "Er" 
								"9J" "Dk" "@N" "F}" "Sj" "Xs" "'F" "r{" "BR" "(N" "?G" "Xq" "mq" "%~" "-9" 
								"Eo" "=?" "WX" "-]" "+u" "j}" "Gt" "5w" "b}" "'Q" "<K" ">O" "'j" ")]" "$=" 
								";o" "4R" "=[" ">[" "-0" "af" ":|" "h~" "jz" "AE" "lr" "=~" "Iz" "-U" "'p" 
								"Q~" "VZ" "sx" "ap" "(+" "uv" "*[" "?T" "1J" "Lx" "WZ" "=U" "Ls" "*j" "#E" 
								"Xf" "#U" "JP" "Zd" "6b" ":{" "Ww" "0E" ";g" "&K" "BW" "@K" "EY" "&k" "4Y" 
								"<z" ",M" "Ub" "8b" "ah" ",W" "fk" "JO" "Rk" "-k" "D[" "]f" "[`" "JU" "#c" 
								"A[" "5m" "$k" "GP" "^o" "-Z" "5d" "1l" "Vv" "46" "3>" "#I" "Ia" "k|" "38" 
								"AF" "%X" ":w" "[q" "8[" "5D" "CH" "+9" "#A" "Pt" "u{" "B^" ":x" "0r" ":?" 
								".A" "3~" "Fu" "<a" "Ze" "Ds" "3g" "+4" "3x" ",O" ")`" "]p" "*H" "02" "$4" 
								"*J" "Wd" "Hy" "Ew" "9<" "1I" "(J" "4x" "$a" "4[" "Ji" "8H" "TZ" "%u" "EK" 
								"4c" "<g" "G{" "IY" "=O" "0=" "Oi" "MS" "Lz" "Ee" "LO" "$y" "DE" "Ot" "-g" 
								"#W" ".[" "vy" "*1" "*=" "hy" "6y" "KM" "J{" "?v" "1T" "@a" "Sv" "3T" ":;" 
								"lp" "13" "7n" "'," "JQ" "uz" "9C" ".M" "<l" "(x" "05" "$X" "CK" "+O" "=T" 
								"mt" "5h" "8K" "[l" "Fm" "07" "W^" ".W" "]y" "_g" "'5" "GK" "$j" ";Q" "Fo" 
								"&a" "2}" "6?" "Pk" "Ux" "#0" "'y" "8T" "x{" "DQ" ".d" "8n" "BY" "&l" ":v" 
								"8}" "$0" "N|" "4e" "(M" "@]" "FZ" "(-" ";m" "bx" ".}" "Y^" "Tr" "Mg" "+o" 
								"35" "#_" "kz" "Od" "':" "fw" "[o" "2r" "Xb" "b{" "hk" "&1" "8A" "$8" "Hc" 
								".P" "G|" "&q" "&Y" "6J" "Ms" "W]" "Hi" "Si" "sw" "Pm" ":C" "6Q" "hq" "0M" 
								"7Y" "5V" "Fk" "?N" "ew" ">x" "(X" "Df" "Se" "%w" "T{" "Dl" "3Q" ":]" "K^" 
								")5" "3a" "JV" "gy" "5t" "8S" "tv" "su" "V|" "Is" "Lv" "jv" "B`" "Gp" ";f" 
						)
		)
	)
	;
	(defun PrintProgress (ProgLine LineFile ProgChar CharFile)
		(if (and ProgLine LineFile ProgChar CharFile)
			(princ (strcat "\r[Line " (rtos ProgLine 2 0) "-" (strcat (rtos LineFile 2 0)) "] [Char " (rtos ProgChar 2 0) "-" (strcat (rtos CharFile 2 0)) "] " (LM:rtos (* (/ (* ProgChar 1.0) (* CharFile 1.0)) 100.0) 2 1) "%"))
		)
	)
	;
	(defun EncryptAsciiFile (FileIn FileOut LstKey1 LstKey2 / WriteChar PrintCode NextPass
															  DataFile Error Fimport Fexport LineRead
															  ControlLengthPassword
															  NumPas NLine NChar itm LstAsciiCode)
		;
		; Error		101 FileIn not found
		;			102 FileIn busy
		;			103 FileIn empty
		;			104 FileOut not created
		;
		(defun WriteChar (LstAscii Stream / itm)
			(if (and LstAscii Stream)
				(progn
					(foreach itm LstAscii
						;(write-char itm Stream)
						(princ  (nth itm CodeAssoc) Stream)
					)
					(princ "\n" Stream)
				)
			)
		)
		;
		(defun PrintCode (LstAsciiCode AsciiEncrypt Stream / Rtn)
			
			;(princ "\n") (princ (length LstAsciiCode)) (princ "\n")
			
			(if (= (length LstAsciiCode) (- MaxCarLine 1))
				(progn
					;(getstring "<>")
					(WriteChar (append LstAsciiCode (list AsciiEncrypt)) Stream)
					;(getstring "<>")
					(setq Rtn nil)
				)
				(setq Rtn (append LstAsciiCode (list AsciiEncrypt)))
			)
			
			Rtn
		)
		;
		(defun NextPass ()
			;
			(if (= NumPas ControlLengthPassword)
				(progn
					(setq NextPw (1+ NextPw))
					(setq NumPas 0)
					(setq LstKey1 (LM:MD5 LstKey1))
					(setq LstKey2 (MakeHexadecimalDigits LstKey1))
					(setq ControlLengthPassword (length LstKey2))
				)
			)
		)
		;
		; Main
		;
		(if (= (type (setq DataFile (InfoFile FileIn))) 'INT)
			(setq Error DataFile)
		)
		;
		(if (not Error)
			(progn
				(cond 
					((> (setq MaxCarLine (fix (/ (sqrt  (/ (+ (* (car DataFile) 2) (* (cadr DataFile) 2)) 6)) 2))) 0)
					)
					((> (setq MaxCarLine (fix (/ (sqrt  (/ (+ (* (car DataFile) 2) (* (cadr DataFile) 2)) 5)) 2))) 0)
					)
					((> (setq MaxCarLine (fix (/ (sqrt  (/ (+ (* (car DataFile) 2) (* (cadr DataFile) 2)) 4)) 2))) 0)
					)
					((> (setq MaxCarLine (fix (/ (sqrt  (/ (+ (* (car DataFile) 2) (* (cadr DataFile) 2)) 3)) 2))) 0)
					)
					((> (setq MaxCarLine (fix (/ (sqrt  (/ (+ (* (car DataFile) 2) (* (cadr DataFile) 2)) 2)) 2))) 0)
					)
					((> (setq MaxCarLine (fix (/ (sqrt  (/ (+ (* (car DataFile) 2) (* (cadr DataFile) 2)) 1)) 2))) 0)
					)
				)
				
				(setq Fimport (open FileIn "r"))
				(setq LineRead (read-line Fimport))

				;(setq LstKey1 LstKey)
				;(setq LstKey2 LstKey)
				;(princ "\n") (princ LstKey2)
				
				(setq ControlLengthPassword (length LstKey2))
				
				(if (setq Fexport (open FileOut "w"))
					(progn

						(setq NLine  0)
						(setq NChar  0)
						(setq NumPas 0)
						
						(while LineRead
							
							(setq NLine (1+ NLine))
							
							(foreach itm (vl-string->list LineRead)
							
								(setq NChar (1+ NChar))
								(PrintProgress NLine (car DataFile) NChar (cadr DataFile))
								(setq LstAsciiCode (PrintCode LstAsciiCode (+ (nth NumPas LstKey2) itm) Fexport))
								;(princ "\nChar ") (princ itm) (princ " Pass ") (princ (nth NumPas LstKey2)) (princ " New ") (princ (+  itm	(nth NumPas LstKey2))) ;(getstring "   <>")
								(setq NumPas (1+ NumPas))
								(NextPass)
							
							)
							(if (setq LineRead (read-line Fimport))
								(progn
									(setq itm (nth (LM:randrange 0 (- (length CodeControlNewLine) 1)) CodeControlNewLine))
									(setq LstAsciiCode (PrintCode LstAsciiCode (+ (nth NumPas LstKey2) itm) Fexport))
									;(princ "\nChar a capo ") (princ itm) (princ " Pass ") (princ (nth NumPas LstKey2)) (princ " New ") (princ (+  itm	(nth NumPas LstKey2))) ;(getstring "   <>")
									(setq NumPas (1+ NumPas))
									(NextPass)
								)
							)
							
						)
		
						(if LstAsciiCode (WriteChar LstAsciiCode Fexport))
						(close Fexport)
					)
					(setq Error 104)
				)
			)
		)
		(close Fimport)
		Error
	)						
	;
	(defun DecryptAsciiFile (FileIn FileOut LstKey1 LstKey2  / 	NextPass
																DataFile Fimport Fexport Error
																LineRead 
																ControlLengthPassword
																NumPas NLine NChar itm NumberAscii)
		;
		;
		; Error		101 FileIn not found
		;			102 FileIn busy
		;			103 FileIn empty
		;		    104 FileOut not created
		;
		(defun NextPass ()
			;
			(if (=  NumPas ControlLengthPassword) 
				(progn
					(setq NextPw (1+ NextPw))
					(setq NumPas 0)
					(setq LstKey1 (LM:MD5 LstKey1))
					(setq LstKey2 (MakeHexadecimalDigits LstKey1))
					(setq ControlLengthPassword (length LstKey2))
				)
			)
		)
		;
		; Main
		;
		(if (= (type (setq DataFile (InfoFile FileIn))) 'INT)
			(setq Error DataFile)
		)
		;
		(if (not Error)
			(progn
				(setq Fimport (open FileIn "r"))
				;(setq LstKey1 LstKey)
				;(setq LstKey2 LstKey)
				;(princ "\n") (princ LstKey2)
				
				(setq ControlLengthPassword (length LstKey2))

				(if (setq Fexport (open FileOut "w"))
					(progn
					
						(setq NumPas 0)
						(setq NLine  0)
						(setq NChar  0)

						(setq LineRead (GetAsciiBigData (read-line Fimport)))
						
						(while LineRead
							(setq NLine (1+ NLine))
							
							(foreach itm LineRead
							
								(setq NChar (1+ NChar))
								(PrintProgress NLine (car DataFile) NChar (/ (cadr DataFile) 2))
								
								(setq NumberAscii (- itm (nth NumPas LstKey2)))
								(if (member NumberAscii CodeControlNewLine)
									(princ "\n" Fexport)
									(princ (chr NumberAscii) Fexport)
								)
								;(princ "\nChar ") (princ itm) (princ " Pass ") (princ (nth NumPas LstKey2)) (princ " New ") (princ NumberAscii) ;(getstring "   <>")

								(setq NumPas (1+ NumPas))
								(NextPass)

							)
							(setq LineRead (GetAsciiBigData (read-line Fimport)))
						)
						(close Fimport)
						(close Fexport)
					)
					(setq Error 104)
				)
			)
		)
		Error
	)
	;
	(defun EncryptKeyPassword (LstAsciiKey1 LstAsciiKey2)
		(if (and LstAsciiKey1 LstAsciiKey2)
			(EncryptAsciiList LstAsciiKey1 LstAsciiKey2)
		)
	)
	;
	(defun DecryKeyPassword (LstAsciiKey1 LstAsciiKey2)
		(if (and LstAsciiKey1 LstAsciiKey2)
			(DecryptAsciiList LstAsciiKey1 LstAsciiKey2)
		)
	)
	;
	(defun GetAsciiBigData (String / Num Rtn)
		(setq Num 1)
		(if String
			(repeat (/ (strlen String) 2) 
				(setq Rtn (append Rtn (list (GetNth CodeAssoc (substr String Num 2)))))
				(setq Num (+ 2 Num))
			)
		)
		Rtn
	)
	;
	(defun CheckDecryKeyPassword (FileName / Rf LineRead Key1 Key2 Rtn)
		;(CheckDecryKeyPassword "C:\\EasyCutBeta\\Decode\\test\\test.enc")
		(if FileName
			(if (findfile FileName)
				(if (setq Rf (open FileName "r"))
					(if (setq LineRead (read-line Rf))
						(progn
							(cond
								((or (= (substr LineRead 1 9) "Encrypt01") (= (substr LineRead 1 9) "Encrypt03"))
									(setq Key1 (GetAsciiBigData (read-line Rf)))
									(setq Key2 (GetAsciiBigData (read-line Rf)))
									(setq Rtn (DecryKeyPassword Key1 Key2))
								)
								((or (= (substr LineRead 1 9) "Encrypt02") (= (substr LineRead 1 9) "Encrypt04"))
									(setq Rtn nil)
								)
							)
							(close Rf)
						)
					)
				)
			)
		)
		Rtn
	)
	;
	(defun EncryptAsciiList (LstAsciiString LstAsciiKey / Pass itm Rtn)
	
		(if (and LstAsciiString LstAsciiKey)
			(progn
			
				; Complete string ++++
				
				(setq Pass 0)
				(foreach itm LstAsciiString
					(setq Rtn (append Rtn (list (+ (nth Pass LstAsciiKey) itm))))
					(if (= (1+ Pass) (length LstAsciiKey))
						(setq Pass 0)
						(setq Pass (1+ Pass))
					)
				)
			)
		)
		Rtn
	)
	;
	(defun DecryptAsciiList (LstAsciiString LstAsciiKey / Pass itm Rtn)
	
		(if (and LstAsciiString LstAsciiKey)
			(progn
				(setq Pass 0)
				(foreach itm LstAsciiString
			
					(setq Rtn (append Rtn (list (- itm (nth Pass LstAsciiKey)))))
					(if (= (1+ Pass) (length LstAsciiKey))
						(setq Pass 0)
						(setq Pass (1+ Pass))
					)
				
				)
			)
		)
		Rtn
	)
	;
	(defun GetItmList (Lst To From / Num Rtn)
		
		(setq Num 0)
		(repeat (1+ (- From To))
			(if (nth Num Lst)
				(setq Rtn (append Rtn (list (nth Num Lst))))
			)
			(setq Num (1+ Num))
		)
		Rtn
	)
	;
	(defun MsgError (NError)
		(cond 
			((= NError 101)  (princ "\n FileIn not found"))
			((= NError 102)  (princ "\n FileIn busy"))
			((= NError 103)  (princ "\n FileIn empty"))
			((= NError 104)  (princ "\n FileOut not created"))
			((= NError 200)  (princ "\n Missing key"))
		)
	)
	;
	(defun InfoFile (FileIn / Fimport LineRead Error NumLine NumChar)
	
		;
		; Error		101 FileIn not found
		;			102 FileIn busy
		;			103 FileIn empty
		;

		(if (findfile FileIn)
			(setq Fimport (open FileIn "r"))
			(setq Error 101)
		)
		(if Fimport
			(setq LineRead (read-line Fimport))
			(setq Error 102)
		)
		(if (not LineRead)
			(setq Error 103)
		)
		(setq NumLine 0)
		(setq NumChar 0)
		(if (not Error)
			(progn
				(while LineRead
					(setq NumLine (1+ NumLine))
					(setq NumChar (+ (length (vl-string->list LineRead)) NumChar))
					(setq LineRead (read-line Fimport))
				)
				(close Fimport)
			)
		)
		(if Error
			Error
			(list NumLine NumChar)
		)
	)
	;
	(defun MakeHexadecimalDigits (LstHexadecimal / LM:sublst SplitList SwapList LM:base->dec CombineList
												   LstCode
												   itm MaxNumber Rtn)

		;(MakeHexadecimalDigits (LM:MD5 (vl-string->list "abc123"))) ---> (233 154 24 196 40 203 56 213 242 96 133 54 120 146 46 3 1868 1292 1569 1125 454 761 772 667 964 279)

		(defun LM:sublst ( lst idx len / rtn )
			(setq len (if len (min len (- (length lst) idx)) (- (length lst) idx))
				  idx (+  idx len)
			)
			(repeat len (setq rtn (cons (nth (setq idx (1- idx)) lst) rtn)))
		)
		;
		(defun SplitList (Lst Div / Pos Loop Rtn)
			(setq Pos 0)
			(setq Loop T)
			(if (and Lst Div)
				(while Loop
					(setq SubLst (LM:sublst Lst Pos Div))
					(if (= (length SubLst) Div)
						(setq Rtn (append Rtn (list SubLst)))
						(setq Loop nil)
					)
					(setq Pos (1+ Pos))
				)
			)
			Rtn
		)
		;
		(defun SwapList (Lst / Pos1 Pos2 Rtn)
		
			(setq Pos1 1)
			(setq Pos2 0)
			
			(repeat (length Lst)
				(if (nth Pos1 Lst) (setq Rtn (append Rtn (list (nth Pos1 Lst)))))
				(if (nth Pos2 Lst) (setq Rtn (append Rtn (list (nth Pos2 Lst))))) 
				(setq Pos1 (+ 2 Pos1))
				(setq Pos2 (+ 2 Pos2))
			)
			Rtn
		)
		;
		(defun LM:base->dec ( n b )
			;(LM:base->dec "7B" 16)
			(   (lambda ( f ) (f (mapcar '(lambda ( x ) (- x (if (< x 65) 48 55))) (reverse (vl-string->list n)))))
				(lambda ( c ) (if c (+ (* b (f (cdr c))) (car c)) 0))
			)
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
		; Main
		;
		(setq MaxNumber (- (length CodeAssoc) 256))
		(if LstHexadecimal
			(progn
				; Condition 1
				(foreach itm (SplitList LstHexadecimal 2)
					(setq LstCode (append LstCode (list  (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm))) 16))))
					(setq LstCode (append LstCode (list  (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm)) T) 16))))
				)
				; Condition 2
				(foreach itm (SplitList LstHexadecimal 3)
					(setq LstCode (append LstCode (list (fix (/ (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm))) 16) 2)))))
					(setq LstCode (append LstCode (list (fix (/ (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm)) T) 16) 2)))))
				)
				; Condition 3
				(foreach itm (SplitList (reverse LstHexadecimal) 2)
					(setq LstCode (append LstCode (list  (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm))) 16))))
					(setq LstCode (append LstCode (list  (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm)) T) 16))))
				)
				; Condition 4
				(foreach itm (SplitList (reverse LstHexadecimal) 3)
					(setq LstCode (append LstCode (list (fix (/ (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm))) 16) 2)))))
					(setq LstCode (append LstCode (list (fix (/ (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm)) T) 16) 2)))))
				)
				;
				(setq LstHexadecimal (SwapList LstHexadecimal))
				; Condition 1
				(foreach itm (SplitList LstHexadecimal 2)
					(setq LstCode (append LstCode (list  (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm))) 16))))
					(setq LstCode (append LstCode (list  (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm)) T) 16))))
				)
				; Condition 2
				(foreach itm (SplitList LstHexadecimal 3)
					(setq LstCode (append LstCode (list (fix (/ (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm))) 16) 2)))))
					(setq LstCode (append LstCode (list (fix (/ (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm)) T) 16) 2)))))
				)
				; Condition 3
				(foreach itm (SplitList (reverse LstHexadecimal) 2)
					(setq LstCode (append LstCode (list  (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm))) 16))))
					(setq LstCode (append LstCode (list  (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm)) T) 16))))
				)
				; Condition 4
				(foreach itm (SplitList (reverse LstHexadecimal) 3)
					(setq LstCode (append LstCode (list (fix (/ (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm))) 16) 2)))))
					(setq LstCode (append LstCode (list (fix (/ (LM:base->dec (strcase (apply 'strcat (mapcar 'chr itm)) T) 16) 2)))))
				)
				
				
				(foreach itm LstCode
					(if (not (member itm Rtn))
						(if (and (<= itm MaxNumber)
								 (>= itm (apply 'max CodeControlNewLine))
							)
							(setq Rtn (append Rtn (list itm)))
						)
					)
				)
				
				;(getstring "<>") (princ LstHexadecimal)	(getstring "<>")
				;(foreach itm (combinelist LstHexadecimal 2)
				;	
				;	(princ (car itm))  (terpri)
				;	(princ (cadr itm)) (terpri)
				;	
				;	(setq Value (boole 6 (car itm) (cadr itm)))
				;	(princ Value) (terpri)
				;	(getstring "")
				;	(if (not (member Value Rtn))
				;		(setq Rtn (append Rtn (list Value)))
				;	)
				;)
				;(princ Rtn) (princ "\n")
			)
		)
		;(ShuffleList Rtn nil)
		Rtn
	)
	;
	; Main ++++
	;
	(StartBenchMark nil)
	(SetupEncrypt)
	(if (and FileImport FileExport Mode (findfile FileImport))
		(cond
			((= Mode 1)
				(setq LstKey1 (LM:MD5 Key))
				(setq LstKey2 (MakeHexadecimalDigits LstKey1))
				(setq Error   (EncryptAsciiFile FileImport FileExport LstKey1 LstKey2))
			)
			((= Mode 2) 
				(setq LstKey1 (LM:MD5 Key))
				(setq LstKey2 (MakeHexadecimalDigits LstKey1))
				(setq Error   (DecryptAsciiFile FileImport FileExport LstKey1 LstKey2))
			)
		)
	)
	(EndBenchMark "\nBenchmark ")
	(if Error 
		(MsgError Error)
		T
	)
)
;
(defun LM:rand ( / a c m )
	(setq m   4294967296.0
		  a   1664525.0
		  c   1013904223.0
		  $xn (rem (+ c (* a (cond ($xn) ((getvar 'date))))) m)
	)
	(/ $xn m)
)
;
(defun LM:randrange ( a b )
	(+ (min a b) (fix (* (LM:rand) (1+ (abs (- a b))))))
)
;
(defun MakeKey (NumChar / Key CodeKey Code)

	(setq CodeKey (list "#" "$" "%" "&" "'" "(" ")" "*" "+" "," "-" "." "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"
						":" ";" "<" "=" ">" "?" "@" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" 
						"P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" "[" "]" "^" "_" "`" "a" "b" "c" "d" "e" "f" 
						"g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "{" "|" "}" "~"
					)
	)
	(repeat NumChar
		(setq Key (append Key (list (ascii (nth (LM:randrange 0 (- (length CodeKey) 1)) CodeKey)))))
	)
	Key
)
;
(defun LM:MD5 ( lst / md5:int->bits md5:bits->int  md5:bits->bytes 
					  md5:bytes->bits md5:int->char md5:byte->hex 
					  md5:leftrotate md5:uint32_+ md5:uint32_0
					  a b c d f g h i k l r w x y )

	;; MD5 Cryptographic Hash Function  -  V1.1 2016-03-27  -  Lee Mac
	;; AutoLISP implementation of the MD5 algorithm by Ronald Rivest
	;; lst - [lst] List of bytes for which to generate hash
	;; Returns 128-bit (16-byte) hash string.

	(defun md5:int->bits ( n b / l x )
		(repeat b (setq l (cons 0 l)))
		(foreach x (vl-string->list (rtos n 2 0))
			(setq x (- x 48)
				  l (mapcar '(lambda ( a ) (setq a (+ (* a 10) x) x (/ a 2)) (rem a 2)) l)
			)
		)
		(reverse l) ;; output is big-endian
	)
	;	
	(defun md5:bits->int ( l ) ;; input is big-endian
		(   (lambda ( f ) (f (reverse l)))
			(lambda ( l ) (if l (+ (* 2.0 (f (cdr l))) (car l)) 0))
		)
	)
	;	
	(defun md5:bits->bytes ( l / b r ) ;; input is big-endian
		(repeat (/ (length l) 8)
			(repeat 8
				(setq b (cons (car l) b)
					  l (cdr l)
				)
			)
			(setq r (cons (fix (+ 1e-8 (md5:bits->int (reverse b)))) r)
				  b nil
			)
		)
		r ;; output is little-endian
	)
	;	
	(defun md5:bytes->bits ( l ) ;; input is little-endian
		(apply 'append (mapcar '(lambda ( b ) (md5:int->bits b 8)) (reverse l))) ;; output is big-endian
	)
	;	
	(defun md5:int->char ( n )
		(chr (+ n (if (< n 10) 48 87)))
	)
	;	
	(defun md5:byte->hex ( x )
		(strcat (md5:int->char (/ x 16)) (md5:int->char (rem x 16)))
	)
	;
	(defun md5:leftrotate ( l x )
		(repeat x (setq l (append (cdr l) (list (car l)))))
	)
	;
	(defun md5:uint32_+ ( bl1 bl2 / r ) ;; input is big-endian
		(setq r 0)
		(reverse
			(mapcar
			   '(lambda ( a b c / x )
					(setq x (boole 6 (boole 6 a b) r)
						  r (boole 7 (boole 1 a b) (boole 1 a r) (boole 1 b r))
					)
					x
				)
				(append (reverse bl1) (md5:uint32_0))
				(append (reverse bl2) (md5:uint32_0))
				(md5:uint32_0)
			)
		) ;; output is big-endian
	)
	;
	(defun md5:uint32_0 ( / l )
		(repeat 32 (setq l (cons 0 l)))
		(eval (list 'defun 'md5:uint32_0 nil (list 'quote l)))
		(md5:uint32_0)
	)
	;
	; Main
	;
    ;; k[n] = floor(abs(sin(n+1)))*2^32 ; n:1-64
    (setq k
        (mapcar '(lambda ( x ) (md5:int->bits x 32))
           '(
                3614090360 3905402710 0606105819 3250441966 4118548399 1200080426 2821735955 4249261313
                1770035416 2336552879 4294925233 2304563134 1804603682 4254626195 2792965006 1236535329
                4129170786 3225465664 0643717713 3921069994 3593408605 0038016083 3634488961 3889429448
                0568446438 3275163606 4107603335 1163531501 2850285829 4243563512 1735328473 2368359562
                4294588738 2272392833 1839030562 4259657740 2763975236 1272893353 4139469664 3200236656
                0681279174 3936430074 3572445317 0076029189 3654602809 3873151461 0530742520 3299628645
                4096336452 1126891415 2878612391 4237533241 1700485571 2399980690 4293915773 2240044497
                1873313359 4264355552 2734768916 1309151649 4149444226 3174756917 0718787259 3951481745
            )
        )
    )
    
    ;; bit-shift values
    (setq r
       '(
            07 12 17 22  07 12 17 22  07 12 17 22  07 12 17 22
            05 09 14 20  05 09 14 20  05 09 14 20  05 09 14 20
            04 11 16 23  04 11 16 23  04 11 16 23  04 11 16 23
            06 10 15 21  06 10 15 21  06 10 15 21  06 10 15 21
        )
    )
    
    ;; Initial hash values: forward/backward count in little-endian hex
    (setq h
        (mapcar '(lambda ( x ) (md5:int->bits x 32))
           '(
                1732584193 ; 0x67452301 = 01234567
                4023233417 ; 0xefcdab89 = 89abcdef
                2562383102 ; 0x98badcfe = fedcda98
                0271733878 ; 0x10325476 = 76543210
            )
        )
    )
    
    ;; Pre-processing:
    ;; Append 0x80 to list of byte values
    ;; Append 0x00 until list has length of 448 bits (mod 512)
    ;; Append length of string in bytes (little-endian) mod(2^64)
    (setq l (cons 128 (reverse lst)))
    (repeat (rem (+ 64 (- 56 (rem (length l) 64))) 64) (setq l (cons 0 l)))
    (setq l (append (reverse l) (md5:bits->bytes (md5:int->bits (* 8 (length lst)) 64))))
    
    ;; Process list in 512-bit (64-byte) chunks
    (repeat (/ (length l) 64)
        
        ;; Construct list of 16 32-bit (4-byte) words
        (repeat 16
            (setq w (cons (md5:bytes->bits (mapcar '+ l '(0 0 0 0))) w)
                  l (cddddr l)
            )
        )
        (setq w (reverse w))
        
        ;; Initialise variables to hash values
        ;; Lists of bit values are used as AutoLISP does not support 32-bit unsigned integers
        (mapcar 'set '(a b c d) h)

        ;; Main MD5 algorithm:
        (setq i 0)
        (repeat 64
            (cond
                (   (< i 16)
                    (setq f (mapcar 'logior (mapcar 'logand b c) (mapcar 'logand (mapcar '(lambda ( a ) (+ 2 (~ a))) b) d))
                          g i
                    )
                )
                (   (< i 32)
                    (setq f (mapcar 'logior (mapcar 'logand d b) (mapcar 'logand (mapcar '(lambda ( a ) (+ 2 (~ a))) d) c))
                          g (rem (1+ (* 5 i)) 16)
                    )
                )
                (   (< i 48)
                    (setq f (mapcar '(lambda ( a b c ) (boole 6 a b c)) b c d)
                          g (rem (+ 5 (* 3 i)) 16)
                    )
                )
                (   (setq f (mapcar '(lambda ( a b ) (boole 6 a b)) c (mapcar 'logior b (mapcar '(lambda ( a ) (+ 2 (~ a))) d)))
                          g (rem (* 7 i) 16)
                    )
                )
            )
            (mapcar 'set '(d c a b i)
                (list c b d
                    (md5:uint32_+ b
                        (md5:leftrotate
                            (md5:uint32_+
                                (md5:uint32_+
                                    (md5:uint32_+ a f)
                                    (nth i k)
                                )
                                (nth g w)
                            )
                            (nth i r)
                        )
                    )
                    (1+ i)
                )
            )
        )

        ;; Update hash values for this chunk
        (setq h (mapcar 'md5:uint32_+ h (list a b c d))
              w nil
        )
    )

    ;; Convert the 4 32-bit integer values to 128-bit hash string of 32 hex digits
    (vl-string->list 
		(apply 'strcat
			(mapcar 'md5:byte->hex
				(apply 'append (mapcar 'md5:bits->bytes h))
			)
		)
	)
)

;
(defun ShuffleList (Lst Verbose / LM:rand LM:randrange LM:RemoveNth
								  Num Rtn Lst)
	;
	(defun LM:rand ( / a c m )
		(setq m   4294967296.0
			  a   1664525.0
			  c   1013904223.0
			  $xn (rem (+ c (* a (cond ($xn) ((getvar 'date))))) m)
		)
		(/ $xn m)
	)
	;
	(defun LM:randrange ( a b )
		(+ (min a b) (fix (* (LM:rand) (1+ (abs (- a b))))))
	)
	;
	(defun LM:RemoveNth ( n l / i )
		(setq i -1)
		(vl-remove-if '(lambda ( x ) (= (setq i (1+ i)) n)) l)
	)
	;
	; Main
	;
	(while Lst
		(setq Num (LM:randrange 0 (- (length Lst) 1)))
		(setq Rtn (append Rtn (list (nth Num Lst))))
		(setq Lst (LM:REMOVENTH Num Lst))
		(if Verbose
			(progn
				(princ "\r") (princ (length Rtn)) (princ " ") (princ (length Lst))
			)
		)
	)
	Rtn
)
;
(defun CombineBigData (/ CombineList
						 Rf Num Cr NumItm LstItm Rtn itm)
	
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
	;
	; Main
	;
	(setq Rf (open "C:\\EasyCutBeta\\Decode\\BigData.txt" "w"))
	(setq Num 1)
	(setq Cr 1)
	(setq NumItm 15)
	(setq LstItm (COMBINELIST (list "#" "$" "%" "&" "'" "(" ")" "*" "+" "," "-" "." "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" 
									":" ";" "<" "=" ">" "?" "@" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" 
									"P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" "[" "]" "^" "_" "`" "a" "b" "c" "d" "e" "f" 
									"g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "{" "|" "}" "~") 2))
	
	(princ (strcat "(setq CodeAssoc (list ") Rf)
	(foreach itm (ShuffleList LstItm T)
		(princ (strcat "\"" (car itm) (cadr itm) "\" ") Rf)
		(if (= Cr NumItm)
			(progn
				(princ "\n" Rf)
				(setq Cr 1)
			)
			(setq Cr (1+ Cr))
		)
		(setq Num (1+ Num))
	)
	(princ "))" Rf)
	(close Rf)
)
;
(defun GraphicsCodex (InFile / InfoFile RowCube MakeStyleCube
							   Error rf Face Line DimCube StepY Htext Wtext Atext Space
							   NFaceCube itm Pinsert LineRead Num)
	;
	;(GraphicsCodex "C:\\EasyCutBeta\\Decode\\test\\test - Copia.enc")
	;(GraphicsCodex "C:\\Users\\ut04\\Desktop\\Tmp\\test.enc")
	;
	(defun InfoFile (InFile / Fimport LineRead Error NumLine NumChar LstCharLine)
	
		;
		; Error		101 FileIn not found
		;			102 FileIn busy
		;			103 FileIn empty
		;

		(if (findfile InFile)
			(setq Fimport (open InFile "r"))
			(setq Error 101)
		)
		(if Fimport
			(setq LineRead (read-line Fimport))
			(setq Error 102)
		)
		(if (not LineRead)
			(setq Error 103)
		)
		(setq NumLine 0)
		(setq NumChar 0)
		(if (not Error)
			(progn
				(while LineRead
					(setq NumLine (1+ NumLine))
					(setq LstCharLine (append LstCharLine (list (length (vl-string->list LineRead)))))
					(setq NumChar (+ (length (vl-string->list LineRead)) NumChar))
					(setq LineRead (read-line Fimport))
				)
				(close Fimport)
			)
		)
		
		(if Error
			Error
			(list NumLine NumChar (apply 'max LstCharLine))
		)
	)
	;
	(defun RowCube (Nrow NFace / Rtn)
	
		(if (and Nrow NFace)
			(progn
				(setq RowFace (/ Nrow NFace))
				(cond
					((> RowFace 0)
						(repeat (- NFace 1)
							(setq Rtn (append Rtn (list RowFace)))
						)
						(setq Rtn (append Rtn (list (- Nrow (* (- NFace 1) RowFace)))))
					)
					(t
						(repeat Nrow
							(setq Rtn (append Rtn (list 1)))
						)
					)
				)
			)
		)
		Rtn
	)
	;
	(defun MakeStyleCube (FileFont NameStyle LstAttribute ActivateStyle)

		;LstAttribute
		;	0	height
		;	1	width
		;	2	obliqueangle
		
		(if (and FileFont NameStyle)
			(if (not (tblobjname "style" NameStyle))
				(progn
					(entmakex
						(list
						   (cons 0 "STYLE")
						   (cons 100 "AcDbSymbolTableRecord")
						   (cons 100 "AcDbTextStyleTableRecord")
						   (cons 2 NameStyle)
						   (cons 70 0)
						   (cons 40 (car   LstAttribute)) ;<- text height not defined
						   (cons 41 (cadr  LstAttribute)) ;<- text width
						   (cons 50 (caddr LstAttribute)) ;<- text obliqueangle
						   (cons 71 0)
						   (cons 42 2.0)
						   (cons 3 FileFont)
						   (cons 4 "")
						)
					)
				)
			)
		)	
		(if (and NameStyle (= ActivateStyle 1))
			(if (findfile FileFont) 
				(progn
					(setq acadApp  (vlax-get-acad-object)) 
					(setq acadDoc  (vla-get-activedocument acadApp)) 
					(setq styles   (vla-get-textstyles acadDoc))
					(setq objStyle (vla-add styles NameStyle))		
					(vla-put-activetextstyle acadDoc objStyle)						
				)
			)
		)
		
		;(entmakex
		;	'(
		;	   (0 . "STYLE")
		;	   (100 . "AcDbSymbolTableRecord")
		;	   (100 . "AcDbTextStyleTableRecord")
		;	   (2 . "My TEXT")
		;	   (70 . 0)
		;	   (40 . 2.2);;<- text height
		;	   (41 . 1.0)
		;	   (50 . 0.0)
		;	   (71 . 0)
		;	   (42 . 2.2)
		;	   (3 . "arial.ttf")
		;	   (4 . "")
		;	   (-3
		;		 ("AcadAnnotative"
		;		   (1000 . "AnnotativeData")
		;		   (1002 . "{")
		;		   (1070 . 1)
		;		   (1070 . 1)
		;		   (1002 . "}")
		;		 )
		;	   )
		;	)
		;)
	)
	;
	; Main
	;
	(if (= (type (setq DataFile (InfoFile InFile))) 'INT)
			(setq Error DataFile)
	)
	;
	(if (not Error)
		(progn
			(setq Htext 2.75) ; heigth text
			(setq Wtext 1.0)  ; width text
			(setq Atext 0.0)  ; angle text
			(setq Space 4.0)  ; space rows
			
			(cond 
				((> (fix (/ (car DataFile) 6)) 0)	(setq NFaceCube 6))
				((> (fix (/ (car DataFile) 5)) 0)	(setq NFaceCube 5))
				((> (fix (/ (car DataFile) 4)) 0)	(setq NFaceCube 4))
				((> (fix (/ (car DataFile) 3)) 0)	(setq NFaceCube 3))
				((> (fix (/ (car DataFile) 2)) 0)	(setq NFaceCube 2))
				((> (fix (/ (car DataFile) 1)) 0)	(setq NFaceCube 1))
			)			
			
			(setq Rf (open InFile "r"))
			(setq Face 1)
			(setq DimCube (max  (* (apply 'max (RowCube (car DataFile) NFaceCube)) Space)
								(* (caddr DataFile) Space)))
			
			(setq StepY (/ DimCube (apply 'max (RowCube (car DataFile) NFaceCube))))
			(setq Wtext (/ DimCube (* (caddr DataFile) Htext)))
			(MakeStyleCube "monotxt8.shx" "Cube"  (list Htext Wtext Atext) 1)
			
			(foreach itm (RowCube (car DataFile) NFaceCube)
				(setq PInsert (list 0.0 0.0 0.0))
				(setq Line 1)
				(repeat itm
					(setq LineRead (read-line Rf))
					(ExtendedDataCodex 
						(MakeTextOnCube DimCube Face PInsert LineRead (list Htext Wtext Atext))
						"CodexCube"
						(list Line (strcat "Face_" (rtos Face 2 0)))
					)
					(setq Pinsert (list 0.0 (+ (cadr Pinsert) StepY) (caddr Pinsert)))
					(setq Line (1+ Line))
				)
				(setq Face (1+ Face))
			)
			(close Rf)
		)
	)
)
;
(defun MakeTextOnCube (DimCube FaceCube PInsertLocalFace String LstAttribute / SetCosDir TrG TrL
																			   DefPiano TransG TransL
																			   P1 P2 P3 P4 P5 P6 P7 P8
																			   Zdir1 Zdir2 Zdir3 Zdir4 Zdir5 Zdir6
																			   UcsDir1 UcsDir2 UcsDir3 UcsDir4 UcsDir5 UcsDir6
																			   PstartText textHeight PStartGlo PStartOcs Rtn)
	;+++++++++++++++++++++++++++++++++++++++++++++++
	;
	;		        +-------------+       
	;		      / |           / |
	;		    / 5 |     2   / 6 |
	;		  /		|	   	/     |
	;		+-------------+  3    |
	;		|       |     |       |
	;		|       +-----|-------+       
	;		|     /       |  4  /
	;		|   /   1     |   /
	;		| /			  |	/
	;		+-------------+
	;
	;++++++++++++++++++++++++++++++++++++++++++++++++
	
	;(MakeTextOnCube 1000.0 1 '(250.0 300.0 0.0) "Ciao1")
	;(MakeTextOnCube 1000.0 2 '(250.0 300.0 0.0) "Ciao2")
	;(MakeTextOnCube 1000.0 3 '(250.0 300.0 0.0) "Ciao3")
	;(MakeTextOnCube 1000.0 4 '(250.0 300.0 0.0) "Ciao4")
	;(MakeTextOnCube 1000.0 5 '(250.0 300.0 0.0) "Ciao5")
	;(MakeTextOnCube 1000.0 6 '(250.0 300.0 0.0) "Ciao6")
	
	(defun DefPiano (x1 y1 z1 x2 y2 z2 x3 y3 z3 / Xorigine Yorigine Zorigine
												  DeltaX DeltaY DeltaZ DeltaLung
												  T11 T21 T31
												  T12 T22 T32
												  T13 T23 T33
												  AAA cos_dir)
		;
		; procedura per il calcolo dei coseni direttori e degli assi di riferimento
		; locali e le coordinate dell'origine del sistema locale partendo da tre
		; punti nello spazio
		;
		(setq T11 nil T21 nil T31 nil)
		(setq T12 nil T22 nil T32 nil)
		(setq T13 nil T23 nil T33 nil)
		;
		; coordinate della nuova origine (1^ punto)
		;
		(setq Xorigine x1
			  Yorigine y1
			 Zorigine z1
		)
		;
		; coseni direttori dell'asse x locale
		;
		(setq DeltaX (- x2 x1)
			  DeltaY (- y2 y1)
			  DeltaZ (- z2 z1)
		)
		(setq DeltaLung (sqrt (+ (* DeltaX DeltaX)
							     (* DeltaY DeltaY)
							     (* DeltaZ DeltaZ)
							  )
					    )
		)
		(if (= DeltaLung 0)
			(exit)
			(progn
				(setq T11 (/ DeltaX DeltaLung)
					  T21 (/ DeltaY DeltaLung)
					  T31 (/ DeltaZ DeltaLung)
				)
			)
		)
		;
		; coseni direttori del secondo segmento del piano (1^ e 3^ punto)
		;
		(setq DeltaX (- x3 x1)
			  DeltaY (- y3 y1)
			  DeltaZ (- z3 z1)
		)
		(setq DeltaLung (sqrt (+ (* DeltaX DeltaX)
							     (* DeltaY DeltaY)
							     (* DeltaZ DeltaZ)
							  )
					    )
	    )
		(if (= DeltaLung 0)
			(exit)
			(progn
				(setq T12 (/ DeltaX DeltaLung)
					  T22 (/ DeltaY DeltaLung)
					  T32 (/ DeltaZ DeltaLung)
				)
			)
		)
		;
		; coseni direttori dell'asse z locale
		;
		(if (and (/= T11 nil) (/= T12 nil))
			(progn
				(setq T13 (- (* T21 T32) (* T31 T22))
					  T23 (- (* T31 T12) (* T11 T32))
					  T33 (- (* T11 T22) (* T21 T12))
					  AAA (+ (* T13 T13) (* T23 T23) (* T33 T33))
				)
			)
		)
		(if (and (/= AAA 0) (/= AAA nil))
			(progn
				(setq DeltaLung (/ 1 (sqrt AAA))
					  T13 (* T13 DeltaLung)
					  T23 (* T23 DeltaLung)
					  T33 (* T33 DeltaLung)
				)
			)
		)
		;
		; coseni direttori dell'asse y locale
		;
		(if (and (/= T21 nil) (/= T12 nil))
			(progn
				(setq T12 (- (* T23 T31) (* T33 T21))
					  T22 (- (* T33 T11) (* T13 T31))
					  T32 (- (* T13 T21) (* T23 T11))
					  AAA (+ (* T12 T12) (* T22 T22) (* T32 T32))
				)
			)
		)
		(if (and (/= AAA 0) (/= AAA nil))
			(progn
				(setq DeltaLung (/ 1 (sqrt AAA))
					  T12 (* T12 DeltaLung)
					  T22 (* T22 DeltaLung)
					  T32 (* T32 DeltaLung)
				)
			)
		)
		(list 	(list Xorigine Yorigine Zorigine)
				(list T11 T21 T31)
				(list T12 T22 T32)
				(list T13 T23 T33)
		)
	)
	;	
	(defun SetCosDir (Pg1 Pg2 Pg3)
		(if (and Pg1 Pg2 Pg3)
			(DefPiano (car Pg1) (cadr Pg1) (caddr Pg1)
					  (car Pg2) (cadr Pg2) (caddr Pg2)			
					  (car Pg3) (cadr Pg3) (caddr Pg3)			
			)
		)
	)
	;
	(defun TransG (x1 y1 z1 dir_cos / X0 Y0 Z0
									  T11 T21 T31
									  T12 T22 T32
									  T13 T23 T33)
		;
		; procedura per la conversione delle coordinate locali a globali
		; x1 y1 z1 ...: coordinata globale da convertire
		; dir_cos ....: lista  ( (X Y Z) (T11 T21 T31)  <--
		;                                (T12 T22 T32)  <-- coseni direttor
		;                                (T13 T23 T33)  <--
		;                      )
		;
		(setq X0  (nth 0 (nth 0 dir_cos))
			  Y0  (nth 1 (nth 0 dir_cos))
			  Z0  (nth 2 (nth 0 dir_cos))
			  T11 (nth 0 (nth 1 dir_cos))
			  T21 (nth 1 (nth 1 dir_cos))
			  T31 (nth 2 (nth 1 dir_cos))
			  T12 (nth 0 (nth 2 dir_cos))
			  T22 (nth 1 (nth 2 dir_cos))
			  T32 (nth 2 (nth 2 dir_cos))
			  T13 (nth 0 (nth 3 dir_cos))
			  T23 (nth 1 (nth 3 dir_cos))
			  T33 (nth 2 (nth 3 dir_cos))
		)
		;
		(list (+ (* T11 x1) (* T12 y1) (* T13 z1) X0) 
			  (+ (* T21 x1) (* T22 y1) (* T23 z1) Y0)
			  (+ (* T31 x1) (* T32 y1) (* T33 z1) Z0)
		)
	)
	;
	(defun TransL (x1 y1 z1 cos_dir / X0 Y0 Z0
									  T11 T21 T31
									  T12 T22 T32
									  T13 T23 T33)
		;
		; procedura per la conversione delle coordinate globali a locali
		; x1 y1 z1 ...: coordinata globale da convertire
		; dir_cos ....: lista  ( (X Y Z) (T11 T21 T31)  <--
		;                                (T12 T22 T32)  <-- coseni direttori
		;                                (T13 T23 T33)  <--
		;                      )
		;
		(setq X0  (nth 0 (nth 0 cos_dir))
			  Y0  (nth 1 (nth 0 cos_dir))
			  Z0  (nth 2 (nth 0 cos_dir))
			  T11 (nth 0 (nth 1 cos_dir))
			  T21 (nth 1 (nth 1 cos_dir))
			  T31 (nth 2 (nth 1 cos_dir))
			  T12 (nth 0 (nth 2 cos_dir))
			  T22 (nth 1 (nth 2 cos_dir))
			  T32 (nth 2 (nth 2 cos_dir))
			  T13 (nth 0 (nth 3 cos_dir))
			  T23 (nth 1 (nth 3 cos_dir))
			  T33 (nth 2 (nth 3 cos_dir))
		)
		;
		(list (+ (* T11 (- x1 X0)) (* T21 (- y1 Y0)) (* T31 (- z1 Z0)))
			  (+ (* T12 (- x1 X0)) (* T22 (- y1 Y0)) (* T32 (- z1 Z0)))
			  (+ (* T13 (- x1 X0)) (* T23 (- y1 Y0)) (* T33 (- z1 Z0)))
		)
	)
	;
	(defun TrG (PLoc CosDir )
		(if (and PLoc CosDir)
			(TransG (car PLoc) (cadr PLoc) (caddr PLoc) CosDir)
		)
	)
	;
	(defun TrL (PGlo CosDir )
		(if (and PGlo CosDir)
			(TransL (car PGlo) (cadr PGlo) (caddr PGlo) CosDir)
		)
	)
	;
	;Main
	;
	(setq 	P1 (list     0.0      0.0 0.0)
			P2 (list DimCube      0.0 0.0)
			P3 (list     0.0  DimCube 0.0)
			P4 (list DimCube  DimCube 0.0)

			P5 (list     0.0     0.0 DimCube)
			P6 (list DimCube     0.0 DimCube)
			P7 (list    0.0  DimCube DimCube)
			P8 (list DimCube DimCube DimCube)
	)

	(setq Zdir1 '( 0.0 -1.0  0.0))  ; 1-2-5
	(setq Zdir2 '( 0.0  0.0  1.0))  ; 5-6-7
	(setq Zdir3 '( 0.0  1.0  0.0))  ; 7-8-3
	(setq Zdir4 '( 0.0  0.0 -1.0))  ; 3-4-1
	(setq Zdir5 '(-1.0  0.0  0.0))  ; 3-1-7
	(setq Zdir6 '( 1.0  0.0  0.0))  ; 8-6-4
	;
	(setq UcsDir1 (SetCosDir P1 P2 P5))
	(setq UcsDir2 (SetCosDir P5 P6 P7))
	(setq UcsDir3 (SetCosDir P7 P8 P3))
	(setq UcsDir4 (SetCosDir P3 P4 P1))
	(setq UcsDir5 (SetCosDir P3 P1 P7))
	(setq UcsDir6 (SetCosDir P8 P6 P4))
	;
	(cond 
		((= FaceCube 1)
			(setq Rtn 
				(entmakex 
					(list 
						(cons 0 "TEXT")
						(cons 7 "Cube")
						(cons 10 (trans (TrG PInsertLocalFace UcsDir1) 0 Zdir1))
						(cons 40 (car LstAttribute))
						(cons 41 (cadr LstAttribute))
						(cons 51 (caddr LstAttribute))
						(cons 1  String) 
						(cons 210 Zdir1)
					) 
				)
			)
		)
		((= FaceCube 2)
			(setq Rtn 
				(entmakex 
					(list 
						(cons 0 "TEXT") 
						(cons 7 "Cube")
						(cons 10 (trans  (TrG PInsertLocalFace UcsDir2) 0 Zdir2))
						(cons 40 (car LstAttribute))
						(cons 41 (cadr LstAttribute))
						(cons 51 (caddr LstAttribute))
						(cons 1  String) 
						(cons 210 Zdir2)
					) 
				)
			)
		)
		((= FaceCube 3)
			(setq Rtn 
				(entmakex 
					(list 
						(cons 0 "TEXT") 
						(cons 7 "Cube")
						(cons 10 (trans (TrG PInsertLocalFace UcsDir3) 0 Zdir3))
						(cons 40 (car LstAttribute))
						(cons 41 (cadr LstAttribute))
						(cons 51 (caddr LstAttribute))
						(cons 50 Pi)
						(cons 1  String) 
						(cons 210 Zdir3)
					) 
				)
			)
		)
		((= FaceCube 4)
			(setq Rtn 
				(entmakex 
					(list 
						(cons 0 "TEXT") 
						(cons 7 "Cube")
						(cons 10 (trans (TrG PInsertLocalFace UcsDir4) 0 Zdir4))
						(cons 40 (car LstAttribute))
						(cons 41 (cadr LstAttribute))
						(cons 51 (caddr LstAttribute))
						(cons 50 Pi)			
						(cons 1  String) 
						(cons 210 Zdir4)
					) 
				)
			)
		)
		((= FaceCube 5)
			(setq Rtn 
				(entmakex 
					(list 
						(cons 0 "TEXT") 
						(cons 7 "Cube")
						(cons 10 (trans (TrG PInsertLocalFace UcsDir5) 0 Zdir5))
						(cons 40 (car LstAttribute))
						(cons 41 (cadr LstAttribute))
						(cons 51 (caddr LstAttribute))
						(cons 1  String) 
						(cons 210 Zdir5)
					) 
				)
			)
		)
		((= FaceCube 6)
			(setq Rtn 
				(entmakex 
					(list 
						(cons 0 "TEXT") 
						(cons 7 "Cube")
						(cons 10 (trans (TrG PInsertLocalFace UcsDir6) 0 Zdir6))
						(cons 40 (car LstAttribute))
						(cons 41 (cadr LstAttribute))
						(cons 51 (caddr LstAttribute))
						(cons 50 Pi)			
						(cons 1  String) 
						(cons 210 Zdir6)
					) 
				)
			)
		)
	)
	Rtn
)
;
(defun ReadCube (/ EditBox
				   FileReadCube DclKey xx OutFile)
	
	(defun EditBox (/ dcl des x)
	
		(setq dcl (vl-filename-mktemp nil nil ".dcl"))
		(setq des (open dcl "w"))
		(foreach x
			'(	"OutKey:dialog" 
				"{"
				"	label=\"Key\";"
				"	:row {"
				"		:text{edit_width=15; label=\"Name Key\";}"
				"		:edit_box {fixed_width = true; edit_width=60; key=\"KeyName\";}"
				"	}"
				"	ok_cancel;"
				"}"
			)
			(write-line x des)
		)
		(setq des (close des))
		dcl
	)
	;
	;Main
	;
	(if (setq FileReadCube (SortFace (SselCodexCube "CodexCube") "CodexCube"))
		(progn
			(setq DclKey (EditBox))
			(setq xx (load_dialog DclKey))
			(new_dialog "OutKey" xx "" (cond ( *OutKey* ) ( '(-1 -1) )))
			(action_tile "accept" (strcat "(setq KeyName (get_tile \"KeyName\"))"
										  "(setq *EditBox* (done_dialog))"
										  "(setq Go T)"
										  "(unload_dialog xx)"
										  "(vl-file-delete DclKey)"
									)
			)
			(action_tile "cancel" "(setq Go nil *EditBox* (done_dialog)) (unload_dialog xx) (vl-file-delete DclKey)")
			(start_dialog)
		
			(if Go
				(progn
					(setq OutFile (vl-filename-mktemp nil nil ".enc"))
					(Code02 FileReadCube OutFile (vl-string->list KeyName) 2)
					(EasyCutViewer OutFile)
					(vl-file-delete FileReadCube)
				)
			)	
		)
	)
)
;
(defun SselCodexCube (Rgp)
	(ssget (list (cons '0 "Text") (append (list -3) (list (list Rgp)))))
)
;
(defun SortFace (SsgetData Rgp / LM:ss->ent Ename Xdata
								 LstFace1 LstFace2 LstFace3
								 LstFace4 LstFace5 LstFace6 Xdata FileName Wf)

	(defun LM:ss->ent ( ss / i l )
		(if ss
			(repeat (setq i (sslength ss))
				(if (entget (ssname ss (setq i (1- i))))
					(setq l (cons (ssname ss i) l))
				)
			)
		)
		l
	)
	;
	;Main
	;
	(foreach Ename (LM:ss->ent SsgetData)
		(if (assoc -3 (entget Ename (list "*")))
			(if (= (nth 0 (nth 1 (assoc -3 (entget Ename (list "*"))))) Rgp)
				(progn
					(setq Xdata (nth 1 (assoc -3 (entget Ename (list "*")))))
					(cond
						((= (cdr (caddr Xdata)) "Face_1")
							(setq LstFace1 (append LstFace1 (list (list Ename (cdr (cadr Xdata))))))
						)
						((= (cdr (caddr Xdata)) "Face_2")
							(setq LstFace2 (append LstFace2 (list (list Ename (cdr (cadr Xdata))))))
						)
						((= (cdr (caddr Xdata)) "Face_3")
							(setq LstFace3 (append LstFace3 (list (list Ename (cdr (cadr Xdata))))))
						)
						((= (cdr (caddr Xdata)) "Face_4")
							(setq LstFace4 (append LstFace4 (list (list Ename (cdr (cadr Xdata))))))
						)
						((= (cdr (caddr Xdata)) "Face_5")
							(setq LstFace5 (append LstFace5 (list (list Ename (cdr (cadr Xdata))))))
						)
						((= (cdr (caddr Xdata)) "Face_6")
							(setq LstFace6 (append LstFace6 (list (list Ename (cdr (cadr Xdata))))))
						)
					)
				)
			)
		)
	)
	
	(if (or LstFace1 LstFace2 LstFace3 LstFace4 LstFace5 LstFace6)
		(progn
			(setq FileName (vl-filename-mktemp nil nil ".txt"))
			(setq Wf (open FileName "w"))
			
			(foreach itm  (vl-sort LstFace1 (function (lambda (e1 e2)  (< (cadr e1) (cadr e2)))))
				(write-line (cdr (assoc 1 (entget (car itm)))) Wf) 
			)
			(foreach itm  (vl-sort LstFace2 (function (lambda (e1 e2)  (< (cadr e1) (cadr e2)))))
				(write-line (cdr (assoc 1 (entget (car itm)))) Wf) 
			)
			(foreach itm  (vl-sort LstFace3 (function (lambda (e1 e2)  (< (cadr e1) (cadr e2)))))
				(write-line (cdr (assoc 1 (entget (car itm)))) Wf) 
			)
			(foreach itm  (vl-sort LstFace4 (function (lambda (e1 e2)  (< (cadr e1) (cadr e2)))))
				(write-line (cdr (assoc 1 (entget (car itm)))) Wf) 
			)
			(foreach itm  (vl-sort LstFace5 (function (lambda (e1 e2)  (< (cadr e1) (cadr e2)))))
				(write-line (cdr (assoc 1 (entget (car itm)))) Wf) 
			)
			(foreach itm  (vl-sort LstFace6 (function (lambda (e1 e2)  (< (cadr e1) (cadr e2)))))
				(write-line (cdr (assoc 1 (entget (car itm)))) Wf) 
			)
			(close Wf)
			;(EasyCutViewer FileName)
		)
	)
	FileName
)
;
(defun ExtendedDataCodex (Ename Rgp LstData / XList itm)

	(if (and Ename Rgp LstData)
		(progn
			(regapp Rgp)
			;(setq XList (list (cons 1002 "{")))
			(foreach itm LstData
				(cond
					((= (type itm) 'INT)
						(setq XList (append XList (list (cons 1070 itm))))
					)
					((= (type itm) 'STR)
						(setq XList (append XList (list (cons 1000 itm))))
					)
					((= (type itm) 'REAL)
						(setq XList (append XList (list (cons 1040 itm))))
					)
				)
			)
			;(setq XList (append XList (list (cons 1002 "}"))))
			(setq XList (list -3 (cons Rgp XList)))
			(setq XList (append (entget Ename) (list XList)))
			(entmod XList)
			(entupd Ename)
		)
	)
)
;
(defun StartBenchMark (Text)

	(setq StartMSecBenchMark (getvar "MILLISECS"))
	(if Text
		(princ Text)
	)
)
;
(defun EndBenchMark (Text)
	(if Text
		(princ Text)
	)
	(princ (/ (- (getvar "MILLISECS") StartMSecBenchMark ) 1000.0)) (princ "\n")
	
	(setq StartMSecBenchMark nil)
)
;
; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;(princ
;    (strcat
;        "\n:: CodeX.lsp | Version 1.0 | \\U+00A9 Adl"
;		 "\n:: Thanks Lee Mac for MD5 Cryptographic Hash Function"
;        "\n:: www.easycutnesting.it"
;        "\n:: GuiCodeX to Invoke"
;    )
;)
;(princ)