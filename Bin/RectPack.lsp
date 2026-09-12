(defun RectPack:CreateNesting 	(LstShape LstSheet 
								 FileDataShape FileDataSheet
								 FileConfigRectPack	/ 	FileTmp Stream itm Num Nel SplitLst IdShape EnameShape IdGroupShape 
															NumTorch OriginShape Ssel PosMessage EnameCode FileNameDxf Rtn 
															LstFileNameShape IdSheet EnameSheet HeightSheet 
															NewEnameSheet LstFileNameSheet Error)



	;
	; Main
	;
	(if (not LstSheet)
		(progn
			(LM:popup "Errore" "Nessuna lamiera selezionata" (+ 0 16 4096))
			(setq Error T)
		)
	)
	(if (not LstShape)
		(progn
			(LM:popup "Errore" "Nessun contorno selezionato" (+ 0 16 4096))
			(setq Error T)
		)
	)
	

	(if (and LstSheet LstShape)
		(progn
			
			(setq FileTmp (vl-filename-mktemp))
			(setq Stream  (open FileTmp "w"))
			(princ (today) Stream)
			(princ "\n ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" Stream)
			(princ "\n +                    log Export nesting                    +" Stream)
			(princ "\n ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" Stream)
			
			
			(foreach itm (vl-directory-files (vl-filename-directory FileDataShape) "*.dxf")
				(vl-file-delete  (strcat (vl-filename-directory FileDataShape) "\\" itm))
			)
			(vl-file-delete FileDataShape)
			(vl-file-delete FileDataSheet)
			
			;
			; DXF Shape ++++++++++++++
			;
			(setq Num 1)
			(setq Nel (LM:rtos (length LstShape) 2 0))

			(foreach itm LstShape
		
				; 0		  1			2	  3		  4	     5	 6	  7	      8		9		10
				;"2" "516645398" "C872" "300" "178-370" "2" "1" "277.5" "290" "S355J0"  "1"
				;itm     id       comm   fase    mk     qta  sp   lung   larg    qua	n.torce
	
				(setq SplitLst		itm)	
				(setq IdShape  		(nth 1 SplitLst))
				(setq EnameShape	(nth 0 (GetEnameById IdShape)))
				(setq IdGroupShape  (car   (Gnames EnameShape)))
				;(setq NumTorch	 	(nth 10 SplitLst))
				(setq NumTorch	 	"1")
			
				(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
				(setq OriginShape	(vlax-safearray->list mnl))
				(ZoomEname EnameShape 20.0)
				
				(setq Ssel 			(SelectShape EnameShape))
						
				(if Ssel
					(if (setq PosMessage (RectPack:PutPosLineMessageShape EnameShape))
						(progn
							(if (ClockWeis (vlax-get (vlax-ename->vla-object EnameShape) 'coordinates))
								(setq EnameCode  (RectPack:PutMessageShape (strcat "O" IdGroupShape) PosMessage))
								(setq EnameCode  (RectPack:PutMessageShape (strcat "A" IdGroupShape) PosMessage))
							)
							;es "O448062598"
							;   "A448062598"
							(setq Ssel (ssadd EnameCode Ssel))
							(setq FileNameDxf 	(strcat (vl-filename-directory FileDataShape) "\\" (nth 4 SplitLst) ".dxf"))
							(setq Rtn (RectPack:DxfOutShape Ssel FileNameDxf))
					
							(cond 
								((= Rtn 0)
									(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Contorno - file creato " FileNameDxf))
								)
								((= Rtn 1)
									(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Contorno - problema nella cancellazione del file " FileNameDxf))
									(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Contorno - problema nella cancellazione del file " FileNameDxf) Stream)
									(setq Error T)
								) 
								((= Rtn 3)
									(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Cloni vuoti " FileNameDxf))
									(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Cloni vuoti " FileNameDxf) Stream)
									(setq Error T)
								)
							)
							(DeleteEntity (list EnameCode))
							;(DeleteSsel SselCode)
							
							(setq LstFileNameShape (append LstFileNameShape (list (list FileNameDxf (nth 4 SplitLst) (nth 5 SplitLst)))))
						)
						(progn
							(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Contorno troppo piccolo escluso da nesting " IdShape))
							(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Contorno troppo piccolo escluso da nesting " IdShape) Stream)
							(setq Error T)
						)
					)
				)
				(setq Num (1+ Num))
			)
			;
			; DXF Sheet ++++++++++++++
			;
			(setq Num 1)
			(setq Nel (LM:rtos (length LstSheet) 2 0))
			(foreach itm LstSheet

				; 0        1          2         3      4    5     6       7        8	
				;"2" "162504882" "STK_GGG_2" "2500" "5000" "10" "12.5" "981.25" "S355J0"
				;itm      id        nome      larg   lung   sp    mq     peso     qua	

				(setq SplitLst	 itm)
				(setq IdSheet  	 (nth 1 SplitLst))
				(setq EnameSheet (GetEnameSheetById IdSheet))
				;
				;
				;
				(if (and (> (atoi NumTorch) 1) (not (IsRectangle EnameSheet)))
					(progn
						(LM:popup "Avvertimento" (strcat "Lamiera id." IdSheet " esclusa dal nesting\n"
														 "Se viene eseguito il nesting con piu' di una torcia la lamiera deve essere di forma rettangolare")
														 (+ 0 64 4096))
						(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Lamiera id. " IdSheet " esclusa del nesting con torcie > 1"))
						(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Lamiera id. " IdSheet " esclusa dal nesting con torcie > 1") Stream)
						(setq Error T)
					)
					(progn
						; per RectPack NumTorch sempre uguale 1 ++++++++++++++++++++++++++++++++++
						(if (and (> (atoi NumTorch) 1) (IsRectangle EnameSheet))
							(progn
								;(setq HeightSheet 	(/ (- (atof (nth 3 SplitLst)) $MargineLamieraSx (* $MargineAccosto (- (atoi NumTorch) 1)) $MargineLamieraDx)
								;						  (atof NumTorch)
								;					)
								;)
								(setq HeightSheet 	(+ (/ (- (atof (nth 3 SplitLst)) $MargineRifilo (* $SpessoreLama (- (atoi NumTorch) 1)) $MargineRifilo)
														  (atof NumTorch)
														) $MargineRifilo $MargineRifilo
													)
								)
								(setq NewEnameSheet 	(MakePolyline 	(list (list 0.0 0.0)    (list HeightSheet 0.0) 
																		(list HeightSheet (atof (nth 4 SplitLst))) 
																		(list 0.0         (atof (nth 4 SplitLst)))) T))
							)
							(setq NewEnameSheet (LwPolylineToSegmentPolyline EnameSheet nil))
						)
					)
				)

				(if NewEnameSheet
					(progn
						(setq PosMessage (RectPack:PutPosLineMessageSheet NewEnameSheet))
						(setq EnameCode	 (RectPack:PutMessageSheet (strcat "S" IdSheet NumTorch) PosMessage))
						;es S507671
						(if (and PosMessage EnameCode)
							(progn
								;(setq FileNameDxf 	(strcat (vl-filename-directory FileDataSheet) "\\"
								;												(nth 1 SplitLst)    "_" 
								;												(nth 3 SplitLst)    "_" 
								;												(nth 4 SplitLst)    "_"
								;												(nth 5 SplitLst)    ".dxf"))
								
								(setq FileNameDxf 	(strcat (vl-filename-directory FileDataSheet) "\\" (nth 1 SplitLst) ".dxf"))
								(setq Ssel (ssadd)) 
								(ssadd NewEnameSheet Ssel)
								
								;(setq Ssel (MergeSelectionSets (list Ssel SselCode)))
								(setq Ssel (ssadd EnameCode Ssel))
								(setq Rtn  (RectPack:DxfOutShape Ssel FileNameDxf))
								
								;++++++++++++++++++
								;(DeleteEntity (list  NewEnameSheet))
								(DeleteSsel Ssel)
								;++++++++++++++++++
								(cond 
									((= Rtn 0)
										(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Lamiera - file creato " FileNameDxf))
									)
									((= Rtn 1)
										(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Lamiera - problema nella cancellazione del file " FileNameDxf))
										(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Lamiera - problema nella cancellazione del file " FileNameDxf) Stream)
										(setq Error T)
									)
									((= Rtn 3)
										(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Cloni vuoti " FileNameDxf))
										(princ (strcat "\n[" (LM:rtos Num 2 0) "/" Nel "] Cloni vuoti " FileNameDxf) Stream)
										(setq Error T)
									)
								)
								(setq LstFileNameSheet (append LstFileNameSheet (list (list FileNameDxf IdSheet))))
							)
							(progn
								(princ "Problema nella creazione del codice lamiera [CreateNestingExpert]")
								(princ "Problema nella creazione del codice lamiera [CreateNestingExpert]" Stream)
								(setq Error T)
							)
						)
					)
				)
				(setq Num (1+ Num))
			)
			
			
			(if (= (length LstFileNameShape) 0)
				(progn
					(princ "\nNessun contorno da includere nel nesting")
					(princ "\nNessun contorno da includere nel nesting" Stream)
					(LM:popup "Avvertimento" "Nessun contorno da includere nel nesting" (+ 0 64 4096))
					(setq Error T)
				)
			)

			(if (= (length LstFileNameSheet) 0)
				(progn
					(princ "\nNessuna lamiera da includere nel nesting")
					(princ "\nNessuna lamiera da includere nel nesting" Stream)
					(LM:popup "Avvertimento" "Nessuna lamiera da includere nel nesting" (+ 0 64 4096))
					(setq Error T)
				)
			)

			(close Stream)
			(EasyCutViewer FileTmp)
		)
	)
	(RectPack:MakeFileConfig FileConfigRectPack FileDataShape FileDataSheet)
	(RectPack:WriteImportDataDxfNest FileDataSheet		; (strcat (getenv "USERPROFILE") "\\EasyCut\\Output\\Nesting\\Sheet.txt")
									 FileDataShape		; (strcat (getenv "USERPROFILE") "\\EasyCut\\Output\\Nesting\\Part.txt")
									 LstFileNameSheet
									 LstFileNameShape)
	(RectPack:RunSynchronous)
	(RectPack:ImportDxfFileNesting)
)
;
;
;
(defun RectPack:MakeFileConfig (FileConfigRectPack FileDataShape FileDataSheet / 	RectPackthcut RectPacktrim RectPackprefixfile
																					RectPackshow  RectPacktxtoffset_x
																					RectPacktxtoffset_y	RectPackhtxt wf)
;<?xml version="1.0" encoding="UTF-8"?>
;<configuration>
;	<DxfSourceShape>C:\Users\adl20\EasyCut\Output\Nesting\RectPackShape.xml</DxfSourceShape>
;	<DxfSourceSheet>C:\Users\adl20\EasyCut\Output\Nesting\RectPackSheet.xml</DxfSourceSheet>
;	<outputfile>C:\Users\adl20\EasyCut\Output\Nesting</outputfile>
;	<prefixfile>RectPack</prefixfile>
;	<show>False</show>
;	<thcut>4</thcut>  						---> $SpessoreLama
;	<trim>15</trim>   						---> $MargineRifilo
;	<txtoffset_x>10</txtoffset_x>
;	<txtoffset_y>10</txtoffset_y>
;	<htxt>10</htxt>
;</configuration>

	(setq RectPackthcut 			(LM:Rtos $SpessoreLama 2 0	))
	(setq RectPacktrim  			(LM:Rtos $MargineRifilo 2 0	))
	(setq RectPackprefixfile 		"RectPack"					)
	(setq RectPackshow 				"True"						)
	(setq RectPacktxtoffset_x 		(LM:Rtos 10 2 0				))
	(setq RectPacktxtoffset_y 		(LM:Rtos 10 2 0				))
	(setq RectPackhtxt 				(LM:Rtos 10 2 0				))

	(if (and FileConfigRectPack FileDataShape FileDataSheet)
		(progn
			(vl-file-delete FileConfigRectPack)
			(setq wf (open FileConfigRectPack "w"))
			(write-line "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"								 									wf)
			(write-line "<configuration>"								 																wf)
			(write-line (strcat "   <DxfSourceShape>" 	FileDataShape 	"</DxfSourceShape>")											wf)
			(write-line (strcat "   <DxfSourceSheet>" 	FileDataSheet 	"</DxfSourceSheet>") 											wf)
			(write-line (strcat "   <outputfile>" 		(vl-registry-read EasyCutRegistryPath$ "PathNesting") 	"</outputfile>") 		wf)
			(write-line (strcat "   <prefixfile>" 		RectPackprefixfile 	"</prefixfile>")											wf)
			(write-line (strcat "   <show>" 			RectPackshow 			"</show>")												wf)
			(write-line (strcat "   <thcut>" 			RectPackthcut 			"</thcut>")												wf)
			(write-line (strcat "   <trim>" 			RectPacktrim 			"</trim>")												wf)
			(write-line (strcat "   <txtoffset_x>" 		RectPacktxtoffset_x 	"</txtoffset_x>")										wf)
			(write-line (strcat "   <txtoffset_y>" 		RectPacktxtoffset_y 	"</txtoffset_y>")										wf)
			(write-line (strcat "   <htxt>" 			RectPackhtxt 			"</htxt>")												wf)
			(write-line "</configuration>" 																								wf)
			(close wf)
		)
	)
)
;
;
;
(defun RectPack:WriteImportDataDxfNest (FileDataSheet FileDataShape 
									   LstFileNameSheet LstFileNameShape  / wf itm	NameFileShape QtaShape NameShape
																					NameFileSheet IdSheet)
				

;
; File data sheet +++++++++++++++++++++++
;
;<?xml version="1.0" encoding="UTF-8"?>
;<storage>
;   <sheet name="Pannello_Madre_MDF" path="C:\Users\adl20\EasyCut\Output\Nesting\standard_3000x2000.dxf" />
;</storage>
;
; File data shape +++++++++++++++++++++++
;
; name="Fianco_Sx"
; path="C:\Users\adl20\EasyCut\Output\Nesting\fianco_armadio.dxf"
; quantity="8"
; rotation="0"  --> 0 la rotazione e bloccata --> 1 la rotazione è libera (0/90)
;<?xml version="1.0" encoding="UTF-8"?>
;<parts>
;	<shape name="Fianco_Sx" path="C:\Users\adl20\EasyCut\Output\Nesting\fianco_armadio.dxf" quantity="8" rotation="0" />/>
;	<shape name="Ripiano" path="C:\Users\adl20\EasyCut\Output\Nesting\ripiano.dxf" quantity="8" rotation="0" />/>
;</parts>
	
	(if (and FileDataSheet FileDataShape LstFileNameSheet LstFileNameShape)
		(progn
			(setq wf (open FileDataShape "w"))
			(if wf
				(progn
					(write-line "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" wf)
					(write-line "<parts>" wf)
					(foreach itm LstFileNameShape
						(setq NameFileShape (car itm))
						(setq NameShape 	(cadr itm))
						(setq QtaShape 		(caddr itm))
						(write-line (strcat "	<shape name=\"" NameShape "\" path=\"" NameFileShape "\" quantity=\"" QtaShape "\" rotation=\"" "1" "\" />") wf)
					)
					(write-line "</parts>" wf)
					(close wf)
				)
			)
			(setq wf (open FileDataSheet "w"))
			(if wf
				(progn
					(write-line "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" wf)
					(write-line "<storage>" wf)
					(foreach itm LstFileNameSheet
						(setq NameFileSheet (car itm))
						(setq IdSheet 		(cadr itm))
						(write-line (strcat "   <sheet name=\"" IdSheet "\" path=\"" NameFileSheet "\" />") wf)
					)	
					(write-line "</storage>" wf)
					(close wf)
				)
			)
		)
	)
)
;
;
;
(defun RectPack:GetLineMessage (LstEname / Fuzz MaxLengthSegment TypeEntity Ssel itm LstPline NumShape NumSheet Code LstMessageShape LstMessageSheet)

	(setq Fuzz 0.001)
	(setq MinArea 0.5)
	(setq TypeEntity "AcDbPolyline")
	
	(foreach itm LstEname
		(if (= (vlax-get-property (vlax-ename->vla-object itm) 'ObjectName) TypeEntity)
			(if (vlax-property-available-p (vlax-ename->vla-object itm) 'Area)
				(if (<= (vla-get-Area (vlax-ename->vla-object itm)) MinArea)
					(progn
						(setq NumShape 0)
						(setq NumSheet 0)
						(if (or (= (length (LM:lwvertices (entget itm))) 14)
								(= (length (LM:lwvertices (entget itm))) 11)
							)
							(progn
								(setq Code (RectPack:DecodeLineMessage itm Fuzz))
								; Sheet (IdGroup Jou P1G P2G P3G)    Jour = O or A
								; Shape (IdShape S 1 P1G P2G P3G)
								(if Code
									(progn
										(cond 
											((or (= (nth 1 Code) "O") (= (nth 1 Code) "A"))
												(princ "\n") (princ (setq NumShape (1+ NumShape))) (princ " Decode Shape ") (princ (car Code))
												(setq LstMessageShape (append LstMessageShape (list (cons itm Code))))
											)
											((= (nth 1 Code) "S")
												(princ "\n") (princ (setq NumSheet (1+ NumSheet))) (princ " Decode Sheet ") (princ (car Code))
												(setq LstMessageSheet (append LstMessageSheet (list (cons itm Code))))
											)
										)
									)
								)
							)
						)
						;(if FlagRemove (DeleteEntity (list  itm)))
					)
				)
			)
		)
	)
	(list LstMessageSheet LstMessageShape)		
)
;
;
;
(defun RectPack:DecodeLineMessage (EnamePolyline Fuzz / LengthToChar
											   Vertex Num LstLength TypeElement Pos Id P1G P2G P3G Rtn)
	;     0   1234567890  1         1                        123456789
	;es start+O448062598+end		O = contorno orario      448062595 = indice gruppo  (9 caratteri)
	;   start+A448062598+end		A = contorno antiorario  448062595 = indice gruppo  (9 caratteri)
	;     0   1234567  8            1                        12345
	;   start+S507671+end			S = lamiera              50767     = indice lamiera (5 caratteri)  1 = numero torce usate per il taglio

	(defun LengthToChar (LengthLine Fuzz / Rtn)
		(foreach itm $LengthLineMessage
			(if (equal  (cdr itm) LengthLine Fuzz)
				(setq Rtn (car itm))
			)
		)
		Rtn
	)										   
	;
	; Main ++++++++++++++++++++++++++++++++++++
	;
	(if (and EnamePolyline Fuzz)
		(progn
			(setq Vertex (LM:lwvertices (entget EnamePolyline)))
			
			(setq Num 0)
			(repeat (- (length Vertex) 1)
				(setq LstLength (append LstLength (list (distance (cdr (assoc 10 (nth (+ Num 0) Vertex)))
																  (cdr (assoc 10 (nth (+ Num 1) Vertex)))))))
				(setq Num (1+ Num))
			)
			
			(if (and (equal (car LstLength) $CharEndLineMessage Fuzz) (equal (last LstLength) $CharStartLineMessage Fuzz))
				(progn
					(setq LstLength (reverse LstLength))
					(setq Vertex    (reverse Vertex))
				)
			)
			;
			; Start Decode
			;
			(setq TypeElement (LengthToChar (nth 1 LstLength) Fuzz))
			(cond
				((or (= TypeElement "O") (= TypeElement "A"))
					(setq Pos 2)
					(setq Id "")
					(repeat 9
						(setq Id (strcat Id (LengthToChar (nth Pos LstLength) Fuzz)))
						(setq Pos (1+ Pos))
					)
					(setq P1G (cdr (assoc 10 (nth 1   Vertex))))
					(setq P2G (cdr (assoc 10 (nth 11  Vertex))))
					(setq P3G (cdr (assoc 10 (nth 0   Vertex))))
					(setq Rtn (list Id TypeElement P1G P2G P3G))
				)
				((= TypeElement "S")
					(setq Pos 2)
					(setq Id "")
					(repeat 5
						(setq Id (strcat Id (LengthToChar (nth Pos LstLength) Fuzz)))
						(setq Pos (1+ Pos))
					)
					(setq NTorch (LengthToChar (nth 7 LstLength) Fuzz))
					
					(setq P1G (cdr (assoc 10 (nth 1   Vertex))))
					(setq P2G (cdr (assoc 10 (nth 8  Vertex))))
					(setq P3G (cdr (assoc 10 (nth 0   Vertex))))
					(setq Rtn (list Id TypeElement NTorch P1G P2G P3G))
				)
			)
		)
	)
	;Shape-> ("194929738" "A" (678.3 4382.3) (682.02 4382.3) (678.3 4382.4)) 
	;Sheet-> ("50767" "S" "1" (1.0 1.0) (3.7 1.0) (1.0 1.1))
	Rtn
)
;
;
;
(defun RectPack:PutMessageShape (Code InfoPosLineMessage / modelSpace P1 P2 P3 Px Ang Rtn 
														  Num Char LengthChar PtsList SafePts)

	; InfoPosLineMessage ((-294.092 878.124 0.0) (-293.352 878.797 0.0) (-293.42 877.384 0.0))
	; (setq InfoPosLineMessage '((0.0 0.0 0.0) (1.0 0.0 0.0) (0.0 1.0 0.0)))
	; (setq Code "Ciao")
	(if (and Code  InfoPosLineMessage)
		(progn

			(setq modelSpace (vla-get-modelspace(vla-get-activedocument (vlax-get-acad-object))))
			(setq P1   (car   InfoPosLineMessage))
			(setq P2   (cadr  InfoPosLineMessage))
			(setq P3   (caddr InfoPosLineMessage))
			(setq Ang  (angle P1 P2))
			
			; Calcola il punto iniziale perpendicolare Px
			(setq Px (polar P1 (+ (/ PI 2.0) Ang) $CharStartLineMessage))
			
			; Inizializza la lista dei punti in ordine per formare un unico tracciato
			; Partiamo da Px, scendiamo a P1 e poi ci sposteremo lungo l'asse
			(setq PtsList (list (car Px) (cadr Px) (car P1) (cadr P1)))
			
			; Attach Code ------------------------------------------------
			(setq Num 1)
			(repeat (strlen Code)
				(setq Char (substr Code Num 1))
				(setq LengthChar (cdr (assoc Char $LengthLineMessage)))
				(if LengthChar
					(progn 
						(setq P2 (polar P1 Ang LengthChar))
						; Aggiunge il nuovo vertice alla lista
						(setq PtsList (append PtsList (list (car P2) (cadr P2))))
						(setq P1 P2)
					)
				)
				(setq Num (1+ Num))
			)
				
			; EndChar ------------------------------------------------
			; Calcola l'ultimo punto finale distanziato
			(setq P2 (polar P1 Ang $CharEndLineMessage))
			
			; Chiude il tracciato aggiungendo l'ultimo punto a terra (P2) e tornando a Px in alto
			(setq PtsList (append PtsList (list (car P2) (cadr P2) (car Px) (cadr Px))))

			; Converti la lista di numeri in una variante di tipo SafeArray richiesta da AutoCAD
			(setq SafePts (vlax-make-variant
			                (vlax-safearray-fill
			                  (vlax-make-safearray vlax-vbDouble (cons 0 (1- (length PtsList))))
			                  PtsList
			                )
			              ))

			; Crea la LWPolyline effettiva nel Model Space
			(setq Rtn (vlax-vla-object->ename (vla-AddLightWeightPolyline modelSpace SafePts)))
			
			; Opzionale: se vuoi che sia una polilinea chiusa geometricamente dal CAD
			; (vla-put-closed Rtn :vlax-true)
		)
	)
	Rtn
)
;
;
;
(defun RectPack:PutMessageSheet (Code InfoPosLineMessage / modelSpace IdGroup P1 P2 P3 Px Ang Rtn 
													      Num Char LengthChar)

		
		;								p1					p2						p3			
		; InfoPosLineMessage ((-294.092 878.124 0.0) (-293.352 878.797 0.0) (-293.42 877.384 0.0) )

	(if (and Code  InfoPosLineMessage)
		(progn

			(setq modelSpace (vla-get-modelspace(vla-get-activedocument (vlax-get-acad-object))))
			(setq P1   (car   InfoPosLineMessage))
			(setq P2   (cadr  InfoPosLineMessage))
			(setq P3   (caddr InfoPosLineMessage))
			(setq Ang  (angle P1 P2))
			
			; Calcola il punto iniziale perpendicolare Px
			(setq Px (polar P1 (+ (/ PI 2.0) Ang) $CharStartLineMessage))
			
			; Inizializza la lista dei punti in ordine per formare un unico tracciato
			; Partiamo da Px, scendiamo a P1 e poi ci sposteremo lungo l'asse
			(setq PtsList (list (car Px) (cadr Px) (car P1) (cadr P1)))
			
			; Attach Code ------------------------------------------------
			(setq Num 1)
			(repeat (strlen Code)
				(setq Char (substr Code Num 1))
				(setq LengthChar (cdr (assoc Char $LengthLineMessage)))
				(if LengthChar
					(progn 
						(setq P2 (polar P1 Ang LengthChar))
						; Aggiunge il nuovo vertice alla lista
						(setq PtsList (append PtsList (list (car P2) (cadr P2))))
						(setq P1 P2)
					)
				)
				(setq Num (1+ Num))
			)
				
			; EndChar ------------------------------------------------
			; Calcola l'ultimo punto finale distanziato
			(setq P2 (polar P1 Ang $CharEndLineMessage))
			
			; Chiude il tracciato aggiungendo l'ultimo punto a terra (P2) e tornando a Px in alto
			(setq PtsList (append PtsList (list (car P2) (cadr P2) (car Px) (cadr Px))))

			; Converti la lista di numeri in una variante di tipo SafeArray richiesta da AutoCAD
			(setq SafePts (vlax-make-variant
			                (vlax-safearray-fill
			                  (vlax-make-safearray vlax-vbDouble (cons 0 (1- (length PtsList))))
			                  PtsList
			                )
			              ))

			; Crea la LWPolyline effettiva nel Model Space
			(setq Rtn (vlax-vla-object->ename (vla-AddLightWeightPolyline modelSpace SafePts)))
			
			; Opzionale: se vuoi che sia una polilinea chiusa geometricamente dal CAD
			; (vla-put-closed Rtn :vlax-true)
		)
	)
	Rtn
)
;
;
;
(defun RectPack:PutPosLineMessageSheet (Ename / pmnl pmxl Rtn)
	(if ename
		(progn
			(vla-getboundingbox (vlax-ename->vla-object Ename) 'mnl 'mxl)
			(setq pmnl (vlax-safearray->list mnl))
			(setq pmxl (vlax-safearray->list mxl))
			(setq Rtn (list (list (+ (car pmnl) 1.0) (+ (caDr pmnl) 1.0))
							(list (+ (car pmnl) 2.0) (+ (caDr pmnl) 1.0))
						(list (+ (car pmnl) 1.0) (+ (caDr pmnl) 2.0))
						)
			)
		)
	)
	Rtn
)
;
;
;
(defun RectPack:PutPosLineMessageShape (Ename / 	RandomPointInside ValidatePos
												Margin Num
												MaxDimensionLengthCode Shape Jou DataCircle Loop conta
												p1g p2g p3g p1l p2l p3l tmp CosDir Rtn)


;
	;
	(defun ValidatePos (Ename p1g p2g Jou DistA DistB Verbose / Px P1 P2 LstP1a Pos Rtn)

		; Jou = 3 oraria
		(if (= Jou 3)
			(setq 	tmp p2g
					p2g p1g
					p1g tmp
			)
		)
		(setq Pos 1.0)
		
		(setq Px (prol (car p2g) (cadr p2g) (car p1g) (cadr p1g) (* DistA -1.0)))	; ((9084.11 5766.92 0.0))
		(setq P1 (per (car p1g) (cadr p1g) (car Px) (cadr Px) (* DistA Pos)))
		(setq P2 (per (car p1g) (cadr p1g) (car Px) (cadr Px) (* (+ 0.1 DistA) Pos)))
		(setq LstP1a (par (car P2) (cadr P2) (car P1) (cadr P1) (* DistB Pos)))
		
		(if Verbose (LM:MakeLWPoly (append LstP1a (list P1 P2)) 1))

		(if (and 	(LM:PointInside-p (car  LstP1a) (vlax-ename->vla-object Ename) nil)
					(LM:PointInside-p (cadr LstP1a) (vlax-ename->vla-object Ename) nil)
					(LM:PointInside-p P1  			(vlax-ename->vla-object Ename) nil)
					(LM:PointInside-p P2 			(vlax-ename->vla-object Ename) nil)
			)
			(setq Rtn T)
		)
	)
	;
	; Main
	;	
	(setq Margin  				  1.0)
	(setq MaxDimensionLengthCode 10.0)
	(setq Shape (DiscretizeShapeNoControl Ename))
	(setq Jou   (ClockWeisEname Ename))
	
	(if (setq DataCircle (IsLwPolylineCircle Ename))
		(progn
			(if (> (- (* (nth 1 DataCircle) 2.0) (* 2.0 Margin)) MaxDimensionLengthCode)
				(progn
					(setq p1g (list (- (nth 0 (nth 0 DataCircle)) (nth 1 DataCircle))
									(- (nth 1 (nth 0 DataCircle)) Margin)))
					(setq p2g (list    (nth 0 (nth 0 DataCircle))
									(- (nth 1 (nth 0 DataCircle)) Margin)))
				)
			)
		)
		(progn
			(setq Num 0)
			(setq Loop T)
			(setq Shape (append Shape (list (car Shape))))
			(while Loop
	
				(setq p1g 	(nth (+ Num 0) Shape))
				(setq p2g 	(nth (+ Num 1) Shape))
				
				;(if (> (distance p1g p2g) MaxDimensionLengthCode)
				(if (ValidatePos Ename p1g p2g Jou Margin MaxDimensionLengthCode nil)
					(setq Loop nil)
					(setq p1g nil p2g nil)
				)
					
				(if (= (1+ Num) (- (length Shape) 1))
					(setq Loop nil)
				)
				(setq Num (1+ Num))
			)
		)
	)

	;(if (or (not p1g) (not p2g))
	;	(progn
	;		(setq Rtn (RandomPointInside Ename MaxDimensionLengthCode))
	;		(if Rtn (setq p1g (car Rtn) p2g (cadr Rtn)))
	;	)
	;)
				
	(if (and p1g p2g)
		(progn
			;(if (= (car Jou) 3)
			(if (= Jou 3) ; antioraria
				(setq tmp p2g
					  p2g p1g
					  p1g tmp
				)
			)
			(setq p3g (per (car p2g) (cadr p2g) (car p1g) (cadr p1g) -1.0))
		)
		
	)

	(if p3g
		(progn
			(setq CosDir (DefPiano (car p1g) (cadr p1g) 0.0 (car p2g) (cadr p2g) 0.0 (car p3g) (cadr p3g) 0.0))
			(setq p1l (list    Margin      Margin 0.0))
			(setq p2l (list (+ Margin 1.0) Margin 0.0))
			(setq p3l (list    Margin      (+ Margin 1.0) 0.0))
			(setq p1g (TransG (car p1l) (cadr p1l) (caddr p1l) CosDir))
			(setq p2g (TransG (car p2l) (cadr p2l) (caddr p2l) CosDir))
			(setq p3g (TransG (car p3l) (cadr p3l) (caddr p3l) CosDir))
			(setq Rtn (list p1g p2g p3g))
		)
	)

	Rtn ; ((-294.092 878.124 0.0) (-293.352 878.797 0.0) (-293.42 877.384 0.0) )
)
;
;
;
(defun RectPack:ImportDxfFileNesting (/ GetPosInsertDxfNesting GetFileNesting
										ListFile LstIdSheet PtInsert LstEntityImport LstMessage IdSheet NumTorch LstRtn EnameSheet LstEname
										MinX MinY MaxX MaxY WidthSheet HeightSheet PosX
										MaxMinLstEname WidthLstEname IsSheetNestProfessor itm OriginSheet Num ObjCopy LstRefenceEnameMessage)									
										
	;
	;
	(defun GetPosInsertDxfNesting (/ DimScreen ScrMin ScrMax ExtMax ExtMin Xrtn Yrtn)
		(setq DimScreen (VpCoords))
		(setq ScrMin (car DimScreen))
		(setq ScrMax (cadr DimScreen))
		(setq XRtn (car  ScrMin))
		(setq YRtn (cadr ScrMax))
		(list XRtn (+ YRtn 1000.0))
	)
	;
	;
	(defun GetFileNesting (/ Rtn)
		(foreach itm (vl-directory-files PathWorkDxfNest$ "RectPack_*.dxf")
			(setq Rtn (append Rtn (list (strcat PathWorkDxfNest$ "\\" itm))))
		)
		Rtn
	)
	;
	; Main +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	;(setq ListFile (list "C:\\Users\\adl20\\EasyCut\\Output\\Nesting\\NEST_0.dxf"))
	;(setq DrawOrderCtlSave (getvar "DRAWORDERCTL"))
	;(setvar "DRAWORDERCTL" 0)

	(setq ListFile   (GetFileNesting))
	(setq LstIdSheet (GetListIdSheet))
	
	(foreach File ListFile
		(command "_.zoom" "_E")
		(setq PtInsert 			(GetPosInsertDxfNesting))
		(setq LstEntityImport 	(Dxf2Entity File PtInsert nil))
		(setq LstMessage 		(RectPack:GetLineMessage LstEntityImport))
		(if (and (car LstMessage) (cadr LstMessage))
			;((<Entity name: 23c1e9cbbc0> IdShape S 1 P1G P2G P3G))
			;((<Entity name: 23c1e9cbbc0> IdGroup Jou P1G P2G P3G) (IdGroup Jou P1G P2G P3G) ....)
			(progn
				(setq IdSheet 			(cadr (car (car LstMessage))))
				(setq NumTorch 			(cadddr (car (car LstMessage))))
				(setq LstRtn 			(RectPack:SplitSheetAndShape LstEntityImport))
				(setq EnameSheet  		(nth 0 LstRtn))
				(setq LstEname    		(nth 1 LstRtn))
				(vla-getboundingbox 	(vlax-ename->vla-object EnameSheet) 'mnl 'mxl)
				(setq MinX   			(nth 0 (vlax-safearray->list mnl)))
				(setq MinY   			(nth 1 (vlax-safearray->list mnl)))
				(setq MaxX   			(nth 0 (vlax-safearray->list mxl)))
				(setq MaxY   			(nth 1 (vlax-safearray->list mxl)))
				(setq WidthSheet  		(abs (- MaxX  MinX)))
				(setq HeightSheet  		(abs (- MaxY  MinY)))
				(setq MaxMinLstEname	(BoundingBoxLstEname (vl-remove (car (car (car LstMessage))) LstEname)))
				(setq WidthLstEname		(distance (car MaxMinLstEname) (cadr MaxMinLstEname)))
				
				(if (member IdSheet LstIdSheet) 
					(if (null (GetEnameShapeByEnameSheet (GetEnameSheetById IdSheet) "CE+CI+TR"))
						(setq IsSheetNestProfessor 1) 	; Void Sheet
						(setq IsSheetNestProfessor 2)	; Full Sheet
					)
				)
				;
				(if (= IsSheetNestProfessor 2)
					(if (= (LM:popup "avvertimento" "Lamiera utilizzata \n vuoi eliminare il contenuto ?" (+ 1 48 4096)) 1)
						(progn
							(foreach itm (GetEnameShapeByEnameSheet (GetEnameSheetById IdSheet) "CE+CI+TR")
								(entdel itm)
							)
							(setq IsSheetNestProfessor 1)
						)
						(DeleteEntity LstEntityImport)
					)
				)
				;
				(cond
					((= IsSheetNestProfessor 1)
						(setq EnameSheet  (GetEnameSheetById IdSheet))
						(setq OriginSheet (GetOriginSheet EnameSheet))
						;
						; Position Refered Shape in Sheet EasyCut
						; LstMessage  ( ((<Entity name: 23c1e9cbbc0> IdShape S 1 P1G P2G P3G))
						;				((<Entity name: 23c1e9cbbc0> IdGroup Jou P1G P2G P3G) (IdGroup Jou P1G P2G P3G) ....)
						;			  )
						(setq Num 0)
						(setq PosX MinX)
						(setq LstRefenceEnameMessage nil)
						(repeat (atoi NumTorch)
							(foreach itm (cadr LstMessage)
								(setq ObjCopy (vla-copy (vlax-ename->vla-object (car itm))))
								(vla-move 	ObjCopy 
											(vlax-3d-point (list PosX MinY))
											(vlax-3d-point OriginSheet)
								)
								(setq LstRefenceEnameMessage (append LstRefenceEnameMessage (list (vlax-vla-object->ename ObjCopy))))
							)
							(setq Num  (1+ Num))
							;(setq PosX (- MinX (* WidthLstEname Num) (* 0.037 Num)))
							(setq PosX (- MinX (* WidthLstEname Num)))
						)
						(DeleteEntity LstEntityImport)
						(RectPack:BuildSheet EnameSheet LstRefenceEnameMessage)
						
					)
				)
			)
		)
	)
)
;
;
;
(defun RectPack:RunSynchronous (/ wsh exitCode)

	(if (findfile (strcat RectPackNestingEasyCut$ ECFileExeRectPackNesting$))
		(progn
			(setq wsh (vlax-get-or-create-object "WScript.Shell"))
			;; Sintassi: (vlax-invoke-method wsh 'Run "Comando" TipoFinestra bWaitOnReturn)
			;; - TipoFinestra = 1: Permette la visualizzazione del popup e dei grafici generati da Python.
			;; - bWaitOnReturn = 1: AutoCAD attende in modo sincrono che l'utente prema OK nel popup o chiuda i grafici.
			(setq exitCode (vlax-invoke-method wsh 'Run (strcat "\"" RectPackNestingEasyCut$ ECFileExeRectPackNesting$ "\"") 0 1))
			;; Rilascia l'oggetto COM dalla memoria per non lasciare processi appesi
			(vlax-release-object wsh)
			;; VERIFICA E NOTIFICA DEL RISULTATO NELLA RIGA DI COMANDO
			(if (= exitCode 0)
				(princ "\n[EasyCut] Nesting completato. File DXF generati con successo.")
				(princ (strcat "\n[EasyCut] Processo interrotto o errore nel modulo Nesting. Codice d'uscita: " (itoa exitCode)))
			)
		)
		(LM:popup "Errore" (strcat RectPackNestingEasyCut$ ECFileExeRectPackNesting$ " file non trovato") (+ 0 16 4096))
	)
)
;
;
;
(defun RectPack:SplitSheetAndShape (LstEname / MaxArea Itm EnameSheet MinMaxSheet MinMaxShape LstShape Rtn)

	(setq MaxArea 0.0)
	(if LstEname 
		(progn
			(foreach Itm LstEname
				(if (vlax-property-available-p (vlax-ename->vla-object Itm) 'Area)
					(if (> (vla-get-Area (vlax-ename->vla-object Itm)) MaxArea)
						(progn
							(setq MaxArea (vla-get-Area (vlax-ename->vla-object Itm)))
							(setq EnameSheet Itm)
						)
					)
				)
			)
			(setq LstShape (vl-remove EnameSheet LstEname))
		)
	)	
	(list EnameSheet LstShape)
)
;
;
;
(defun RectPack:BuildSheet (EnameSheet LstRefenceEnameMessage / 	MSecStart LstCodeLine MSecEnd Num Rtn)

	;
	; Main +++++++
	;
	(setq MSecStart (getvar "MILLISECS"))
	(vla-StartUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))

	(if (CheckIfEasyCutSheetMember EnameSheet)
		(progn
			(ZoomEname EnameSheet 200)
			(setq LstCodeLine (RectPack:GetLineMessage LstRefenceEnameMessage))
			(DeleteEntity LstRefenceEnameMessage)
					
			(StartProgressBar "Create Nesting :" (length LstCodeLine))
			(setq Num 1)
			(foreach itm (cadr LstCodeLine)
				(UpDateProgressBar)
				(if (not (RectPack:CloneShapeOnSheet itm)) (princ (strcat "\nMancata corrispondenza del contorno [RectPack:CloneShapeOnSheet] id " (cadr itm))))
				(setq Num (1+ Num))
			)
			(ClearProgressBar)
			
			(setq MSecEnd (getvar "MILLISECS"))
			(princ "\nBenchMark  GetLineMessageShape ") (princ (/ (- MSecEnd MSecStart) 1000.0))
		)
	)
	(vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
)
;
;
;
(defun RectPack:CloneShapeOnSheet (CodeMessageOnSheet / IdGroup MatrixOri LstEnameShape itm Ename LstEname Rtn)
	
	; (<Entity name: 23c1ef4f200> "726962391" "A" (19683.5 8591.3) (19686.4 8589.15) (19683.5 8591.38))
	
	(if CodeMessageOnSheet
		(progn
			(setq IdGroup (cadr CodeMessageOnSheet))
			(if (setq LstEnameShape (GetShapeByGroup IdGroup))
				(if (setq MatrixOri (RectPack:PutPosLineMessageShape (car LstEnameShape)))
					(progn
						(foreach itm LstEnameShape
							(setq Ename (AlignObject 	itm
														;(cdr itm)
														(car MatrixOri)
														(cadr MatrixOri)
														(caddr MatrixOri) 
														(nth 3 CodeMessageOnSheet)
														(nth 4 CodeMessageOnSheet)
														(nth 5 CodeMessageOnSheet)
														T))
							(setq LstEname (append LstEname (list Ename)))
						)
						(setq Rtn (CloneShape LstEname))
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
(defun RectPack:DxfOutShape (Ssel FileNameDxf / Catch ptoRif ptoZero obj objCopy LstObj 
                                                 oldExpert oldFileDia ssExport Go Rtn) ; <-- Aggiunte Go e Rtn locali
  (if (and Ssel FileNameDxf)
    (progn
      (setq Go T
            Rtn 0) ;; 0 = Successo standard di default
      
      ;; Controlla se il file esiste e se è bloccato da altri programmi
      (if (findfile FileNameDxf)
        (if (not (vl-file-delete FileNameDxf))
          (progn
            (setq Go nil)
            (setq Rtn 1) ;; 1 = Errore: File esistente e protetto/aperto altrove
          )
          ;; Se rimosso con successo, manteniamo Go su T per procedere
          (setq Rtn 0) 
        )
      )    
    
      (if Go
        (progn 
          (setq oldExpert  (getvar "EXPERT")
                oldFileDia (getvar "FILEDIA")
          )    
          (setvar "EXPERT" 5)   
          (setvar "FILEDIA" 0)  
        
          (setq Catch   (LM:SSBoundingBox Ssel))
          (setq ptoRif  (list (car (car Catch)) (cadr (car Catch)) 0.0))
          (setq ptoZero '(0.0 0.0 0.0))
        
          ;; Clona e sposta gli oggetti nell'origine
          (foreach obj (LM:ss->vla Ssel)
            (setq objCopy (vla-Copy obj))
            (vla-Move objCopy (vlax-3d-point ptoRif) (vlax-3d-point ptoZero))
            (setq LstObj (cons objCopy LstObj))
          )
          
          ;; Converte la lista in Selection Set
          (setq ssExport (LstObj->Ssget LstObj))
          
          (if (and ssExport (> (sslength ssExport) 0))
            (progn
              ;; Usa direttamente la variabile ssExport ottimizzata
              (command "_.DxfOut" FileNameDxf "_Objects" ssExport "" "_Version" "2007" "16")
              (setq Rtn 0) ;; Esportazione riuscita
            )
            (setq Rtn 3) ;; 3 = Errore: Selezione cloni vuota o non valida
          )

          ;; Pulizia accurata delle copie ActiveX
          (foreach obj LstObj 
            (vl-catch-all-apply 'vla-delete (list obj))
          )
          (setq ssExport nil)
		  
          ;; Ripristino delle variabili di AutoCAD
          (setvar "EXPERT" oldExpert)
          (setvar "FILEDIA" oldFileDia)
        )
      )
    )
  )
  Rtn ;; Restituisce lo stato finale (0=OK, 1=File Bloccato, 3=Selezione Fallita)
)



