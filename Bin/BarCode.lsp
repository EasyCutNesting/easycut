	; https://www.barcoderesource.com/code128_barcodefont.html
	; http://www.codiceabarre.it/bc128.htm
	; http://support.idautomation.com/Code-128/Manually-calculate-check-digit-for-Code-128/_1025
	; http://www.idautomation.com/barcode-faq/code-128/#Code-128CharacterSet
	
(defun Barcode128 (/ Testo BlockName StartPoint Hbar Htxt Rtn)

	(setq Testo (getstring T "\nstringa [solo lettere e numeri]="))
	(setq StartPoint (getpoint "\nPunto inserimento "))
	
	(setq Hbar 40)				; altezza barra
	(setq Htxt (* Hbar 0.2))	; altezza testo
	(setq BlockName (strcat "BARCODE128_" (Random_Str 9)))
	
	(setq Rtn (BrCode128 Testo BlockName StartPoint Hbar Htxt))
	(if (null Rtn) (alert "Codice non Valido"))
)
;
;
;
(defun Barcode39 (/ Testo BlockName StartPoint Lb Hb Ib Ht Rtn)

	(setq Testo (getstring T "\nTesto [solo numeri]="))
	(setq StartPoint (getpoint "\nPunto inserimento "))
	
	(setq Lb 1.0)         ; larghezza barra singola
	(setq Hb 40.0)        ; altezza barra
	(setq Ib 1.5)         ; larghezza intercarattere 
	(setq Ht (* Hb 0.2))  ; altezza testo
	(setq BlockName (strcat "BARCODE39_" (Random_Str 9)))

	(setq Rtn (BrCode39 Testo BlockName StartPoint Lb Hb Ib Ht))
	(if (null Rtn) (alert "Codice non Valido"))
)
;
;
;	
(defun BrCode128 (Testo BlockName StartPoint Hbar Htxt / conta lstascii codec Brcode ListEnameBar ss itm minmax pmid TextB Rtn)

	
	(if (and Testo StartPoint Hbar Htxt)
		(progn
			(setq conta 1)
			(setq lstascii nil)
			(repeat (strlen Testo)
				(setq lstascii (append lstascii (list (ascii (substr Testo conta 1)))))
				(setq conta (1+ conta))
			)
			(setq codec  (AutoChechTypeCode128 lstascii))
			(if codec
				(progn
					;(princ (strcat "\nAuto Check Barcode Tipo 128" codec))
					(setq Brcode (CalcDigit128 codec lstascii))
					(setq ListEnameBar (DrawBarcode128 Brcode StartPoint Hbar))
					(if ListEnameBar
						(progn
							(setq ss (ssadd))
							(foreach itm ListEnameBar (ssadd itm ss))
							
							(setq minmax (LM:SSBoundingBox ss))
							(setq pmid  (list (/ (+ (nth 0 (nth 0 minmax)) (nth 0 (nth 1 minmax))) 2.0)
											     (- (nth 1 (nth 0 minmax)) (* Htxt 1.75))
										)
							)
							(setq TextB (BarText Pmid lstascii Htxt))
							(ssadd TextB ss)
							
							(setq Rtn (obj2blk BlockName StartPoint ss))
							(vla-Move (vlax-ename->vla-object Rtn)  (vlax-3d-point (nth 0 pmid) (nth 1 pmid))
																	(vlax-3d-point (nth 0 StartPoint) (nth 1 StartPoint))) 
						)
					)
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun BrCode39 (Testo BlockName StartPoint Lb Hb Ib Ht / conta lstascii Brcode ListEnameBar ss itm minmax pmid TextB Rtn)

	
	(if (and Testo StartPoint Lb Hb Ib Ht)
		(progn
			(setq conta 1)
			(setq lstascii nil)
			(repeat (strlen Testo)
					(setq lstascii (append lstascii (list (ascii (substr Testo conta 1)))))
					(setq conta (1+ conta))
			)
			(setq Brcode (CalcDigit39 lstascii))
			
			(setq ListEnameBar (DrawBarcode39 Brcode StartPoint Lb Hb Ib))
			(if ListEnameBar
				(progn
					(setq ss (ssadd))
					(foreach itm ListEnameBar (ssadd itm ss))
					(setq minmax (LM:SSBoundingBox ss))
					(setq pmid (list (/ (+ (nth 0 (nth 0 minmax)) (nth 0 (nth 1 minmax))) 2.0)
										(- (nth 1 (nth 0 minmax)) (* Ht 1.75))
								)
					)
					(setq TextB (BarText Pmid lstascii Ht))
					(ssadd TextB ss)
					
					(setq Rtn (obj2blk BlockName StartPoint ss))
					(vla-Move (vlax-ename->vla-object Rtn)  (vlax-3d-point (nth 0 pmid) (nth 1 pmid))
															(vlax-3d-point (nth 0 StartPoint) (nth 1 StartPoint))) 
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun AutoChechTypeCode128 (ListCodeAsciiBarCode / TypeCodec itm CodeSpecial CodeNumber Codechk) 
			
			
	(setq TypeCodec nil)
	; controllo se ci sono caratteri speciali
	(setq CodeSpecial nil)
	(foreach itm ListCodeAsciiBarCode
		(if (<= itm 31) 			; caratteri speciali
			(setq CodeSpecial T)
		)
	)			
	(if CodeSpecial
		(foreach itm ListCodeAsciiBarCode
			(if (> itm 95)
				(setq CodeSpecial nil)
			)	
		)
	)
	
	(if CodeSpecial
		(setq TypeCodec "A")
		(progn
			(setq CodeNumber T)
			(foreach itm ListCodeAsciiBarCode
				(if (or (< itm 48) (> itm 57))
					(setq CodeNumber nil)
				)
			)
			(if CodeNumber
				(setq TypeCodec "C")
				(progn
					(setq Codechk T)
					(foreach itm ListCodeAsciiBarCode
						(if (or (< itm 32) (> itm 127))
							(setq Codechk nil)
						)
					)
					(if Codechk	(setq TypeCodec "B"))
				)
			)	
		)
	)

	TypeCodec
)
;
;
;
(defun CalcDigit128 (TypeCodec ListCodeAsciiBarCode / LstCodecAB ChekDigit conta Sum loop idx Val Bar)
	
	
		(setq AsciToCode (list (list 0 "64" "")    (list 1 "65" "")    (list 2 "66" "")    (list 3 "67" "")    (list 4 "68" "")
							   (list 5 "69" "")    (list 6 "70" "")    (list 7 "71" "")    (list 8 "72" "")    (list 9 "73" "")
							   (list 10 "74" "")   (list 11 "75" "")   (list 12 "76" "")   (list 13 "77" "")   (list 14 "78" "")
							   (list 15 "79" "")   (list 16 "80" "")   (list 17 "81" "")   (list 18 "82" "")   (list 19 "83" "")
							   (list 20 "84" "")   (list 21 "85" "")   (list 22 "86" "")   (list 23 "87" "")   (list 24 "88" "")
							   (list 25 "89" "")   (list 26 "90" "")   (list 27 "91" "")   (list 28 "92" "")   (list 29 "93" "")
							   (list 30 "94" "")   (list 31 "95" "")   (list 32 "0" "0")   (list 33 "1" "1")   (list 34 "2" "2")
							   (list 35 "3" "3")   (list 36 "4" "4")   (list 37 "5" "5")   (list 38 "6" "6")   (list 39 "7" "7")   
							   (list 40 "8" "8")   (list 41 "9" "9")   (list 42 "10" "10") (list 43 "11" "11") (list 44 "12" "12")
							   (list 45 "13" "13") (list 46 "14" "14") (list 47 "15" "15") (list 48 "16" "16") (list 49 "17" "17")
							   (list 50 "18" "18") (list 51 "19" "19") (list 52 "20" "20") (list 53 "21" "21") (list 54 "22" "22")
							   (list 55 "23" "23") (list 56 "24" "24") (list 57 "25" "25") (list 58 "26" "26") (list 59 "27" "27")
							   (list 60 "28" "28") (list 61 "29" "29") (list 62 "30" "30") (list 63 "31" "31") (list 64 "32" "32")
							   (list 65 "33" "33") (list 66 "34" "34") (list 67 "35" "35") (list 68 "36" "36") (list 69 "37" "37")
							   (list 70 "38" "38") (list 71 "39" "39") (list 72 "40" "40") (list 73 "41" "41") (list 74 "42" "42")
							   (list 75 "43" "43") (list 76 "44" "44") (list 77 "45" "45") (list 78 "46" "46") (list 79 "47" "47")
							   (list 80 "48" "48") (list 81 "49" "49") (list 82 "50" "50") (list 83 "51" "51") (list 84 "52" "52")
							   (list 85 "53" "53") (list 86 "54" "54") (list 87 "55" "55") (list 88 "56" "56") (list 89 "57" "57")
							   (list 90 "58" "58") (list 91 "59" "59") (list 92 "60" "60") (list 93 "61" "61") (list 94 "62" "62")
							   (list 95 "63" "63") (list 96 ""  "64")  (list 97 "" "65")   (list 98 "" "66")   (list 99 "" "67")
							   (list 100 "" "68")  (list 101 "" "69")  (list 102 ""  "70") (list 103 "" "71")  (list 104 "" "72")
							   (list 105 "" "73")  (list 106 "" "74")  (list 107 "" "75")  (list 108 ""  "76") (list 109 "" "77")
							   (list 110 "" "78")  (list 111 "" "79")  (list 112 "" "80")  (list 113 "" "81")  (list 114 ""  "82")
							   (list 115 "" "83")  (list 116 "" "84")  (list 117 "" "85")  (list 118 "" "86")  (list 119 "" "87")
							   (list 120 "" "88")  (list 121 "" "89")  (list 122 "" "90")  (list 123 "" "91")  (list 124 "" "92")
							   (list 125 "" "93")  (list 126 ""  "94")
						)
		)
		(setq CodeToBar (list (cons 0 "212222")  (cons 1 "222122")  (cons 2 "222221")  (cons 3 "121223")  (cons 4 "121322")
							  (cons 5 "131222")  (cons 6 "122213")  (cons 7 "122312")  (cons 8 "132212")  (cons 9 "221213")
							  (cons 10 "221312") (cons 11 "231212") (cons 12 "112232") (cons 13 "122132") (cons 14 "122231")
							  (cons 15 "113222") (cons 16 "123122") (cons 17 "123221") (cons 18 "223211") (cons 19 "221132")
							  (cons 20 "221231") (cons 21 "213212") (cons 22 "223112") (cons 23 "312131") (cons 24 "311222")
							  (cons 25 "321122") (cons 26 "321221") (cons 27 "312212") (cons 28 "322112") (cons 29 "322211")
							  (cons 30 "212123") (cons 31 "212321")	(cons 32 "232121") (cons 33 "111323") (cons 34 "131123")
							  (cons 35 "131321") (cons 36 "112313") (cons 37 "132113") (cons 38 "132311") (cons 39 "211313")
							  (cons 40 "231113") (cons 41 "231311") (cons 42 "112133") (cons 43 "112331") (cons 44 "132131")
							  (cons 45 "113123") (cons 46 "113321") (cons 47 "133121") (cons 48 "313121") (cons 49 "211331")
							  (cons 50 "231131") (cons 51 "213113")	(cons 52 "213311") (cons 53 "213131") (cons 54 "311123")
							  (cons 55 "311321") (cons 56 "331121") (cons 57 "312113") (cons 58 "312311") (cons 59 "332111")
							  (cons 60 "314111") (cons 61 "221411") (cons 62 "431111") (cons 63 "111224") (cons 64 "111422")
							  (cons 65 "121124") (cons 66 "121421") (cons 67 "141122") (cons 68 "141221") (cons 69 "112214")
							  (cons 70 "112412") (cons 71 "122114")	(cons 72 "122411") (cons 73 "142112") (cons 74 "142211")
							  (cons 75 "241211") (cons 76 "221114") (cons 77 "413111") (cons 78 "241112") (cons 79 "134111")
							  (cons 80 "111242") (cons 81 "121142") (cons 82 "121241") (cons 83 "114212") (cons 84 "124112")
							  (cons 85 "124211") (cons 86 "411212") (cons 87 "421112") (cons 88 "421211") (cons 89 "212141")
							  (cons 90 "214121") (cons 91 "412121") (cons 92 "111143") (cons 93 "111341") (cons 94 "131141")		
							  (cons 95 "114113") (cons 96 "114311") (cons 97 "411113") (cons 98 "411311") (cons 99 "113141")
							  (cons 100 "114131") (cons 101 "311141") (cons 102 "411131")
							  (cons "StartA" "211412")
							  (cons "StartB" "211214")
							  (cons "StartC" "211232")
							  (cons "Stop"   "2331112") 
						)
		)
						
		(setq Bar nil)
		(setq ChekDigit nil)
		(if (and TypeCodec ListCodeAsciiBarCode)
			(progn
				(setq conta 1)
				(cond 
					((= TypeCodec "C")
						
						(if (> (rem (length ListCodeAsciiBarCode) 2) 0) 
							(progn
								(setq ListCodeAsciiBarCode (cons 48 ListCodeAsciiBarCode))
								(setq Sum (+ 105 102))
								(setq conta (1+ conta))
							)
							(setq Sum 105)	
						)
						(setq loop (/ (length ListCodeAsciiBarCode) 2))
						(setq idx   0)
						(repeat loop
							(setq Val (atoi (strcat (chr (nth (+ idx 0) ListCodeAsciiBarCode)) (chr (nth (+ idx 1) ListCodeAsciiBarCode)))))
							
							(setq Bar (append Bar (list	(cdr (assoc (atoi (strcat (chr (nth (+ idx 0) ListCodeAsciiBarCode))
							                                                      (chr (nth (+ idx 1) ListCodeAsciiBarCode))
																		   )
																	 ) CodeToBar
															  )
														)
													)
										)
							)
							
							
							(setq Sum (+ Sum (* conta Val)))
							(setq idx (+ idx 2))
							(setq conta (1+ conta))
						)
					)
					((or (= TypeCodec "A") (= TypeCodec "B"))
						(setq Sum 104)
						(foreach itm ListCodeAsciiBarCode
							(cond
								((= TypeCodec "A")
									(setq Sum (+ Sum (* (atoi (cadr (assoc itm AsciToCode))) conta)))
									(setq code (cdr (assoc (atoi (cadr (assoc itm AsciToCode))) CodeToBar)))
								)
								((= TypeCodec "B")
									(setq Sum (+ Sum (* (atoi (caddr (assoc itm AsciToCode))) conta)))
									(setq code (cdr (assoc (atoi (caddr (assoc itm AsciToCode))) CodeToBar)))
								)	
							)
   						    (setq Bar (append Bar (list code)))
							(setq conta (1+ conta))
						)
					)
				)
				(setq ChekDigit (rem Sum 103))
			)
		)
		(if (= TypeCodec "A") (setq start "StartA"))
		(if (= TypeCodec "B") (setq start "StartB"))
		(if (= TypeCodec "C") (setq start "StartC"))
		
		(setq Bar (append 	(list (cdr (assoc start CodeToBar)))
							Bar
							(list (cdr (assoc ChekDigit CodeToBar)))
							(list (cdr (assoc "Stop" CodeToBar)))
				  )
		)
		
		
		Bar
)


;
;
;
(defun DrawBarcode128 (BarList StartPoint Hbar / BarCodeText BarCodeList BarCodeValList BarList TextLength Counter Char Bar OldLunits ListEnameBar)
	
	;; Set units to decimal
	(setq OldLunits (getvar "LUNITS"))
	(setvar "LUNITS" 2)
	(setq ListEnameBar (DrawBar BarList StartPoint Hbar))
	(setvar "LUNITS" OldLunits)
	ListEnameBar
)
;
;
;
(defun CalcDigit39 (LstAscii / AsciToCode Bar itm Chk)

	; Il Codice 39
	; Il carattere speciale " * " assume la funzione di carattere di Start/Stop.
	; B1 - B5 = barra  1 - 5
	; S1 - S4 = spazio 1 - 4
	; 1 = elemento largo
	; 0 = elemento stretto
	; Carattere	B1	S1	B2	S2	B3	S3	B4	S4	B5


	(setq AsciToCode
		(list	(cons 48 "000110100") (cons 49 "100100001") (cons 50 "001100001") (cons 51 "101100000")
				(cons 52 "000110001") (cons 53 "100110000") (cons 54 "001110000") (cons 55 "000100101")
				(cons 56 "100100100") (cons 57 "001100100") (cons 65 "100001001") (cons 66 "001001001")
				(cons 67 "101001000") (cons 68 "000011001") (cons 69 "100011000") (cons 70 "001011000")
				(cons 71 "000001101") (cons 72 "100001100") (cons 73 "001001100") (cons 74 "000011100")
				(cons 75 "100000011") (cons 76 "001000011") (cons 77 "101000010") (cons 78 "000010011")
				(cons 79 "100010010") (cons 80 "001010010") (cons 81 "000000111") (cons 82 "100000110")
				(cons 83 "001000110") (cons 84 "000010110") (cons 85 "110000001") (cons 86 "011000001") 
				(cons 87 "111000000") (cons 88 "010010001") (cons 89 "110010000") (cons 90 "011010000")
				(cons 45 "010000101") (cons 46 "110000100") (cons 32 "011000100") (cons 42 "010010100")
				(cons 36 "010101000") (cons 47 "010100010") (cons 43 "010001010") (cons 37 "000101010"))
	)
	
	(if LstAscii
		(progn
			(setq Bar (list (cdr (assoc 42 AsciToCode))))
			(setq Chk T)
			(foreach itm LstAscii
				
				(if (assoc itm AsciToCode)
					(setq Bar (append Bar (list (cdr (assoc itm AsciToCode)))))
					(setq Chk nil)
				)
			)
			(setq Bar (append Bar (list (cdr (assoc 42 AsciToCode)))))
		)
	)
	(if Chk
		Bar
		nil
	)
)
;
;
;
(defun DrawBarcode39 (Brcode StartPoint Lb Hb Ib / OldLunits ListEnameBar Counter itm DrawBar Loop BarChr BarPoint StartPoint)
	
	
	(setq OldLunits (getvar "LUNITS"))
	(setvar "LUNITS" 2)
	
	(setq ListEnameBar  nil)
	(setq Counter 1)
	(foreach itm Brcode
			
			(setq DrawBar T)
			(setq Loop 1)
			(repeat (strlen itm)
				(setq BarChr (substr itm Loop 1))
				(cond 
				  ((= BarChr "0") (setq BarChr (rtos Lb 2 0)))
				  ((= BarChr "1") (setq BarChr (rtos (* Lb 2) 2 0)))
				) 
				
				(setq BarPoint   (polar StartPoint 0.0 (* 0.5 (atoi BarChr))))
				(setq StartPoint (polar StartPoint 0.0 (atoi BarChr)))
				
				
				(if DrawBar
					(progn
						(setq ListEnameBar (append ListEnameBar (list (BarPline (list BarPoint (polar BarPoint (/ pi 2.0) Hb)) (atoi BarChr)))))
						(setq DrawBar nil)
					)
					(setq DrawBar T)
				)
				(setq Loop (1+ Loop))
			)
			(setq BarPoint   (polar StartPoint 0.0 (- Ib (atoi BarChr))))
			(setq StartPoint (polar StartPoint 0.0 Ib))
			
			(setq Counter (1+ Counter))
	)
	(setvar "LUNITS" OldLunits)
	ListEnameBar 
)
;
;
;
(defun DrawBar (BarList StartPoint Hbar /  BarPoint Counter BarCodeGroup Loop DrawBar BarChr ListEnameBar)

	(setq Counter 0)
	(setq ListEnameBar nil)
	(repeat (length BarList)

		(setq BarCodeGroup (nth Counter BarList))
		(setq Loop 1)
		(setq DrawBar T)

		(repeat (strlen BarCodeGroup)
			(setq BarChr (substr BarCodeGroup Loop 1))
			(setq BarPoint (polar StartPoint 0.0 (* 0.5 (atoi BarChr))))
			(setq StartPoint (polar StartPoint 0.0 (atoi BarChr)))
			(if DrawBar
				(progn
					(setq ListEnameBar (append ListEnameBar (list (BarPline (list BarPoint (polar BarPoint (/ pi 2.0) Hbar)) (atoi BarChr)))))
					(setq DrawBar nil)
				)
				(setq DrawBar T)
			)
			(setq Loop (1+ Loop))
		)
		(setq Counter (1+ Counter))
	)
	ListEnameBar
)
;
;
;
(defun BarPline (PointList Width / Group10List PolyLineList)

	; se color =1 Nero		
	; se color =0 Bianco
    
	
	(setq PolyLineList
		(list 
			(cons 0 "LWPOLYLINE")
			(cons 100 "AcDbEntity")
			(cons 100 "AcDbPolyline")
			(cons 6 "Continuous")
			(cons 8 "0")	
			(cons 43 Width)  
			(cons 90 (length PointList))
			(cons 70 0)
		)
	)
	(setq Group10List (mapcar '(lambda (Coord) (cons 10 Coord)) PointList)) 
	(setq PolyLineList (append PolyLineList Group10List))
	(setq EnPoly (entmakex PolyLineList))
	
	;(setq oColor (vlax-create-object "AutoCAD.AcCmColor.17"))
	
	;(if (= color 1)
	;	(vla-SetRGB oColor 0 0 0) 			; nero
	;	(vla-SetRGB oColor 255 255 255) 	; bianco
	;)
	
	;(vlax-put-property (vlax-ename->vla-object EnPoly) 'TrueColor oColor) 
	;(vla-update (vlax-ename->vla-object EnPoly)) 
	
	EnPoly
)
;
;
;
(defun BarText (Point LstAscii Width / EText itm Text)



	(setq Text "")
	(foreach itm LstAscii
		
		(cond 
			((= itm 0) (setq Char "~NUL~"))
			((= itm 1) (setq Char "~SOH~"))
			((= itm 2) (setq Char "~STX~"))
			((= itm 3) (setq Char "~ETX~"))
			((= itm 4) (setq Char "~EOT~"))
			((= itm 5) (setq Char "~ENQ~"))
			((= itm 6) (setq Char "~ACK~"))
			((= itm 7) (setq Char "~BEL~"))
			((= itm 8) (setq Char "~BS~"))
			((= itm 9) (setq Char "~HT~"))
			((= itm 10) (setq Char "~LF~"))
			((= itm 11) (setq Char "~VT~"))
			((= itm 12) (setq Char "~FF~"))
			((= itm 13) (setq Char "~CR~"))
			((= itm 14) (setq Char "~SO~"))
			((= itm 15) (setq Char "~SI~"))
			((= itm 16) (setq Char "~DLE~"))
			((= itm 17) (setq Char "~DC1~"))
			((= itm 18) (setq Char "~DC2~"))
			((= itm 19) (setq Char "~DC3~"))
			((= itm 20) (setq Char "~DC4~"))
			((= itm 21) (setq Char "~NAK~"))
			((= itm 22) (setq Char "~SYN~"))
			((= itm 23) (setq Char "~ETB~"))
			((= itm 24) (setq Char "~CAN~"))
			((= itm 25) (setq Char "~EM~"))
			((= itm 26) (setq Char "~SUB~"))
			((= itm 27) (setq Char "~ESC~"))
			((= itm 28) (setq Char "~FS~"))
			((= itm 29) (setq Char "~GS~"))
			((= itm 30) (setq Char "~RS~"))
			((= itm 31) (setq Char "~US~"))
			(t
				(setq Char (chr itm))
			)
		)
		(setq Text (strcat Text Char))
	)

	(setq EText
		(list 
			(cons 0 "TEXT")
			(cons 100 "AcDbEntity")
			(cons 100 "AcDbText")
			(cons 8 "0")	
			(cons 10 Point)	
			(cons 40 Width)  
			(cons 1 Text)  
			(cons 50 0.0)  
			(cons 41 1)  
			(cons 51 0.0)  
			(cons 7 "Standard")
			(cons 71 0)  
			(cons 72 1)  
			(cons 11 (list (+ (nth 0 Point) 1) (nth 1 Point)))	
			(cons 73 0)
		)
	)
	(entmakex EText)
)

