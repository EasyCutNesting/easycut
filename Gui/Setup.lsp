;(setq SetupPathEasyCut$ (strcat (getvar "XLOADPATH") "EasyCut\\"))
(defun GetUserUpData ()
	(strcat (getenv "LOCALAPPDATA") "\\EasyCut\\")
)
;
;
(defun DeleteSetupEasyCut (FileSetup)
	(if FileSetup
		(if (findfile FileSetup)
			(progn
				(if (vl-file-delete  FileSetup)
					(princ (strcat "\nconfigurazione cancellata     -> " FileSetup))
					(princ (strcat "\nproblema cancellazione setup  -> " FileSetup))
				)
			)
		)
	)
)
;
;
;
(defun LoadDefaultSetup ()
	(DefaultSetupEasyCut)
)
;
;
;
(defun DefaultSetupEasyCut ()

		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ versione ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq VersionEasyCut$ 	(vl-registry-read EasyCutRegistryPath$ "Version"))	; versione
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ utilizzo sfrido ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq ECPartInPart$   T)	; utilizzo sfrido fori pezzo
		(setq ECScrapInPart$  T)	; utilizzo sfrido controno pezzo
		(setq ECMergeScrap$ nil)	; ragruppamento di tutti gli sfridi lamiera
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ variabili attacchi ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $MargineAccosto   10.0) ; margine accosto contorno/contorno [mm]
		(setq $MargineLamieraDx 20.0) ; margine accosto contorno/bordo lamiera Dx [mm]
		(setq $MargineLamieraSx 20.0) ; margine accosto contorno/bordo lamiera Sx [mm]
		(setq $MargineLamieraTp 20.0) ; margine accosto contorno/bordo lamiera Alto [mm]
		(setq $MargineLamieraBt 20.0) ; margine accosto contorno/bordo lamiera Basso [mm]
		(setq $MargineLamiera   20.0) ; margine accosto contorno/bordo lamiera irregolare [mm]
		(setq $MargineRifilo    15.0) ; margine rifilo sezionatrice [mm]
		(setq $SpessoreLama      4.0) ; spessore lama sezionatrice [mm]
		(setq $LgSegEntra 5.0)        ; lunghezza attacco rettilineo in entrata [mm]
		(setq $LgSegEsci 5.0)         ; lunghezza attacco rettilineo in uscita [mm]
		(setq $SvArcEntra 10.0)       ; lunghezza attacco circolare in entrata [mm]
		(setq $SvArcEsci 10.0)        ; lunghezza attacco circolare in uscita [mm]
		(setq $RaggioEntra 8.0)       ; raggio attacco circolare in entrata [mm]
		(setq $RaggioEsci 8.0)        ; raggio attacco circolare in uscita [mm]
		(setq $ColorEntra 60)         ; colore attacco in entrata
		(setq $ColorEsci 150)         ; colore attacco in uscita
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ variabili contorni ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $SpeedCut 500)              ; velocita' taglio [mm/min]
		(setq $ColorShapeOra 1)           ; colore contorno esterno orario
		(setq $ColorShapeAntiOra 2)       ; colore contorno esterno antiorario
		(setq $ColorHoleOra 3)            ; colore contorno interno orario
		(setq $ColorHoleAntiOra 4)        ; colore contorno interno antiorario
		(setq $ColorCircle 5)             ; colore contorno interno circolari
		(setq $ColorEllipse 6)            ; colore contorno interno ellittici
		(setq $ColorDetatch 175)          ; colore contorni stacati
		(setq $ArrowArcDivision 1.0)      ; freccia massima per il calcolo della divisione dell'arco-cerchio [mm]
		(setq $AccuracyAngleRotation 0.5) ; precisione angolo [gradi] per LeanOn 
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ ragruppamenti ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $RgpSheet       "LAMIERA")   ; raggruppmento lamiera
		(setq $RgpSheetTarget "LAM_TRG")   ; raggruppmento blocco lamiera
		(setq $RgpShape       "PIATTO")    ; raggruppmento contorno piatto
		(setq $RgpShapeTarget "SHP_TRG")   ; raggruppmento blocco contorno piatto
		(setq $RgpTiggerOn    "ENTRA")     ; raggruppmento attacco in entrata
		(setq $RgpTiggeroff   "ESCI")      ; raggruppmento attacco in uscita
		;(setq $RgpRule        "RULE")      ; raggruppmento righello
		(setq $RgpSymula      "SIMULA")    ; raggruppmento simulazione taglio
		;(setq $RgpBom		  "EASYCUTBOM"); raggruppmento squadrature e cartigli
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ simulazione ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $Sequence    1)    ; sequenza
		(setq $ColorSymula 6)    ; colore simulazione
		(setq $TypSymula 1)      ; tipo simulazione
		(setq $TimeSymula 1000)  ; tempo azione simulazione [sec]
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ DXF import ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $DxfRemoveSingleObject 		T)		; DXF import	Rimozione oggetti singoli 
		(setq $DxfClosePolyline 			T)		; DXF import	Chiusura forzata polilinee
		(setq $DxfExplodeBlocks 			T)		; DXF import	Esplosione blocchi
		(setq $DxfPurgePolyline 			T)		; DXF import 	Semplificazione polilinee
		(setq $Overlapp 					nil) 	; DXF import	Controllo sovrapposizione line-archi-cerchi
		(setq $OverlappAcuracyCenter 		0.1)	; DXF import	Tolleranza controllo centro cerchi e archi
		(setq $OverlappAcuracyRadius 		0.1)	; DXF import	Tolleranza controllo raggi archi e archi
		(setq $OverlappAcuracyPoint 		0.1)	; DXF import	Tolleranza controllo vertici
		(setq $OverlappAcuracyCollinear		0.01)	; DXF import	Tolleranza controllo collinearita' punti su retta
		(setq $OverlappAcuracyAngleArc		0.01)	; DXF import	Tolleranza controllo angoli archi
		(setq $RemoveAmbiguosLength 		0.10) 	; DXF import	Rimozione entita' con lunghezza <=
		(setq $MaxOpenPolyline				0.20)	; DXF import    Massima distanza apertura polilinea
		(setq $CenterCirclePolyline 		0.05) 	; DXF import	Tolleranza per controllo centro LwPolyline
		(setq $DivideCsv 					(vl-registry-read "HKEY_CURRENT_USER\\Control Panel\\International" "sList")) 	; DXF import Carattere divisore file CSV		
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ folders e files ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq BinPathEasyCut$     	(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Bin\\"))    					; archivio Bin
		(setq GuiPathEasyCut$     	(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Gui\\"))    					; archivio interfaccia grafica DCL
		(setq FontPathEasyCut$    	(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Font\\"))   					; archivio font
		(setq LibPathEasyCut$     	(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Lib\\"))   					; archivio libreria blocchi
		
		(setq ExpertNestingEasyCut$   (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Apps\\DxfNest\\"))   		; path eseguibile Expert Nesting
		(setq RectPackNestingEasyCut$ (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Apps\\RectPack\\"))   		; path eseguibile RectPack Nesting
		
		(setq DbaseEasyCut$ 		(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Dbase\\"))   				; path DataBase
		(setq LoadEasyCut$ 			(strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Load\\"))   					; path Load
		
		(setq CncPathEasyCut$       (strcat (vl-registry-read EasyCutRegistryPath$ "PathNC") "\\"))		    ; input file CNC
		(setq OutputPathEasyCut$    (strcat (vl-registry-read EasyCutRegistryPath$ "PathWork") "\\"))		; output file
		(setq InfoPathEasyCut$      (strcat (vl-registry-read EasyCutRegistryPath$ "PathInfo") "\\"))		; output file info
		(setq CutPathEasyCut$     	(strcat (vl-registry-read EasyCutRegistryPath$ "PathOutput") "\\"))		; percorso taglio
		(setq HtmlStorageEasyCut$ 	(strcat (vl-registry-read EasyCutRegistryPath$ "PathDocs") "\\"))   	; archivio layout Html
		(setq DxfNestingEasyCut$  	(strcat (vl-registry-read EasyCutRegistryPath$ "PathNesting") "\\"))   	; archivio nesting lamiere

		(setq HtmlScriptEasyCut$ 	"http://adlproeng.altervista.org/easycut/script/")   		  			; archivio script Html

		(setq ECFolderSheet$  			"01Sheet\\")				; archivio lamiere html
		(setq ECFolderShape$  			"01Shape\\")				; archivio contorni html
		(setq ECFolderShapePreview$ 	"01ShapePreview\\")			; archivio preview contorni html
		(setq ECFolderReport$ 			"01Report\\")				; archivio report html

		(setq ECFileSetupExpertNesting$   "DxfNestSetup.txt")		; nome file dati setup Expert nesting
		(setq ECFileSetupRectPackNesting$ "RectPackSetup.xml")		; nome file dati setup RectPack nesting
		(setq ECFileExeExpertNesting$     "DxfNest.exe")			; nome file start ExpertNesting
		(setq ECFileExeRectPackNesting$   "RectPack.exe")			; nome file start RectPAckNesting
		(setq ECFileViewer$   			  "NotePad.exe")			; nome file Viewre
		(setq ECFileSheet$ 				  "Sheet")					; nome file lamiere html
		(setq ECFileShape$ 				  "Shape")					; nome file contorno html
		(setq ECFileReport$ 			  "Report")					; nome file report html
		(setq ECFileTree$ 				  "Index")					; nome file tree html

		(vl-registry-write EasyCutRegistryPath$ "DefaultPathCfg" (strcat (getenv "LOCALAPPDATA") "\\EasyCut"))
		(setq SetupPathEasyCut$	(strcat (getenv "LOCALAPPDATA") "\\EasyCut\\"))
		(setq SetupFileEasyCut$ "Default.cfg")
		(vl-registry-write EasyCutRegistryPath$ "DefaultFileCfg" SetupFileEasyCut$)
		
		(setq NameBlockSheet$      "BlockSheet01")                                     ; nome blocco info sheet
		(setq NameBlockShape$      "BlockShape_02")                                    ; nome blocco info shape
		(setq NameBlockShapeTmp$   "BlockShapeTmp_01")                                 ; nome blocco info tmp shape
		(setq FileBlockSheet$      "BlockSheet01.dwg")                                 ; file blocco info sheet
		(setq FileBlockShape$      "BlockShape02.dwg")                                 ; file blocco info shape
		(setq FileBlockShapeTmp$   "BlockShapeTmp01.dwg")                              ; file blocco info tmp shape
		(setq FileBlockLogo$       "Logo.dwg")                                         ; nome blocco logo
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;   ++ filtri ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $FilterList  '((-4 . "<OR") (0 . "LwPolyline") (0 . "Circle") (0 . "Ellipse") (0 . "Polyline") (-4 . "OR>"))) ; filtro contorni
		(setq $TriggerList '((-4 . "<OR") (0 . "Arc") (0 . "Line") (-4 . "OR>")))										    ; filtro attacchi	
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;   ++ testi ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $StyleEasyCut "EasyCutStyle")					; style testo
		(setq $StyleEasyCutBarCode "BarCode")				; style barcode
		(setq $HTextEasyCut 40)								; altezza testo
		;(setq $FontBarCodeEasyCut "C39TBNFZ.TTF")	        ; font codice a barre
		(setq $FontDefaultEasyCut "romans.shx")	            ; font default
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;   ++ dinamic info ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $LayerDinamicInfoEasyCut "DinfoEasyCut")		; layer info dinamico
		(setq $HTextDinamicInfoEasyCut 70.0)				; altezza testo info dinamico
		;(setq $AperturaDinamicInfoEasyCut 0)				; altezza apertura cath info dinamico
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ velocita' taglio x spessori ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $SpeedCutArray '(	(5 542 1)
								(8 458 1) 
								(10 425 1) 
								(12 383 1) 
								(15 358 1) 
								(20 308 0) 
								(25 283 0) 
								(30 242 0) 
								(35 225 0) 
								(40 217 0) 
								(50 200 0) 
								(75 167 0) 
								(100 158 0) 
								(125 150 0) 
								(150 133 0) 
								(200 117 0) 
								(250 108 0) 
								(300 75 0) 
								(400 58 0)
								(0 0 0))) 				; velocita' taglio [mm/min]
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ diametri esclusi dal taglio ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $CutOffArray '(	(1 18 1)
								(25 30 0) 
								(50 55 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0) 
								(0 0 0)
								(0 0 0))) ; diamteri esclusi [mm]
		(setq $CutOffIrregularShape 0)    ; contorni interni esclusi
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ codice a barre ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $BarCodeArray '(	(0 -1 0)
		
								(0 1 0) 	;1	ID CONTORNO
								(124 2 1) 	;2	COMMESSA
								(124 3 1)	;3	FASE
								(0 4 1)		;4	MARCA
								(0 0 0)		;5	SPESSORE
								(0 0 0)		;6	LUNGHEZZA
								(0 0 0)		;7	LARGHEZZA
								(0 0 0)		;8	PERIMETRO
								(0 0 0)		;9	MATERIALE
								(0 0 0)		;10	PESO
								(0 0 0)		;11	CONTORNO
								(0 0 0)		;12	PERCORRENZA
								(0 0 0)		;13	COMPENSAZIONE
								(0 0 0)		;14	TEMPO TAGLIO
								(0 0 0)		;15	ULTIMA MODIFICA
								
								(0 -1 0))) 			; codice a barre
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ Lista composizione codice a barre ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $LstDataBarCode (list "------" "ID CONTORNO" "COMMESSA" "FASE" "MARCA" 
									"SPESSORE" "LUNGHEZZA" "LARGHEZZA" "PERIMETRO" 
									"MATERIALE" "PESO" "CONTORNO" "PERCORRENZA" 
									"COMPENSAZIONE" "TEMPO TAGLIO" "ULTIMA MODIFICA"))
									
		(setq $HtmlCtbEasyCut 		"monochrome.ctb")
		(setq $HtmlPlotterEasyCut 	"PublishToWeb JPG.pc3")
		(setq $HtmlPaperSizeEasyCut "UserDefinedRaster (1200.00 x 1600.00Pixels)")
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ Lista composizione codice a linee ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $CharStartLineMessage 0.1)	;-> Start
		(setq $CharEndLineMessage	0.2)	;-> End
		(setq $LengthLineMessage 	(list 	(cons "0"	0.31)	;-> 0
											(cons "1"	0.32)	;-> 1
											(cons "2"	0.33)	;-> 2
											(cons "3"	0.34)	;-> 3
											(cons "4"	0.35)	;-> 4
											(cons "5"	0.36)	;-> 5
											(cons "6"	0.37)	;-> 6
											(cons "7"	0.38)	;-> 7
											(cons "8"	0.39)	;-> 8
											(cons "9"	0.40)	;-> 9
											(cons "A"	0.41)	;-> A
											(cons "B"	0.42)	;-> B
											(cons "C"	0.43)	;-> C
											(cons "D"	0.44)	;-> D
											(cons "E"	0.45)	;-> E
											(cons "F"	0.46)	;-> F
											(cons "G"	0.47)	;-> G
											(cons "H"	0.48)	;-> H
											(cons "I"	0.49)	;-> I
											(cons "J"	0.50)	;-> J
											(cons "L"	0.51)	;-> L
											(cons "M"	0.52)	;-> M
											(cons "N"	0.53)	;-> N
											(cons "O"	0.54)	;-> O
											(cons "P"	0.55)	;-> P
											(cons "Q"	0.56)	;-> Q
											(cons "R"	0.57)	;-> R
											(cons "S"	0.58)	;-> S
											(cons "T"	0.59)	;-> T
											(cons "U"	0.60)	;-> U
											(cons "V"	0.61)	;-> V
											(cons "W"	0.62)	;-> W
											(cons "X"	0.63)	;-> X
											(cons "Y"	0.64)	;-> Y
											(cons "Z"	0.65)	;-> Z
											(cons "+"	0.66)	;-> +
											(cons "-"	0.67)	;-> -
											(cons "*"	0.68)	;-> *
											(cons "/"	0.69)	;-> /
											(cons "_"	0.70)	;-> _
											(cons "."	0.71)	;-> .
											(cons "'"	0.72)	;-> '
									)
		)
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ Flessione ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $Flex 0.0)						; Flessione
		(setq $FlexHoleDiamExcludeFrom  0.0)	; Escludi flessione dal diametro ..
		(setq $FlexHoleDiamExcludeTo  30.0)		; Escludi flessione al diametro ..
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ Microconnessione ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $LgMicro         10.0)	; Lunghezza Micro
		(setq $WdMicro         10.0)	; Altezza Micro
		(setq $WdMicroAtPoint  15.0)	; Altezza Micro nel vertice polylinea
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		;	++ NestingBar ++
		;------------------------------------------------------------------------------------------------------------------------------------------------------
		(setq $TkCutBar         0.0)	; Spessore taglio barra
		(setq $BarMargStart     10.0)	; Margine iniziale barra
		(setq $BarMargEnd  		15.0)	; Margine minimo finale barra
		
		(princ "\nconfigurazione default caricata") ;(princ FileName)

		;(SaveSetupEasyCut FileName)
)
;
;
;
(defun CheckVarEasyCut ( / FileName Stream itm Num CodeBar)

	(setq FileName (vl-filename-mktemp))
	(setq Stream (open FileName "w"))
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                               ++ versione ++                                                           " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nversione EasyCut               VersioneEasyCut$             -> " Stream) (princ VersionEasyCut$ Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                            ++ configurazione ++                                                        " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nnome configurazione            NameConfigurationEasyCut$    -> " Stream) (princ NameConfigurationEasyCut$ Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                        ++ variabili utilizzo sfrido ++                                                 " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nutilizzo sfrido controni interni         ECPartInPart$      -> " Stream) (princ ECPartInPart$ Stream)
	(princ "\nutilizzo sfrido controni esterni         ECScrapInPart$     -> " Stream) (princ ECScrapInPart$ Stream)
	(princ "\nutilizzo sfrido lamiera                  ECMergeScrap$      -> " Stream) (princ ECMergeScrap$ Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                             ++ variabili attacchi ++                                                   " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nmargine accosto contorno                    $MargineAccosto    -> " Stream) (princ $MargineAccosto Stream)
	(princ "\nmargine accosto contorno/bordo lamiera Dx   $MargineLamieraDx  -> " Stream) (princ $MargineLamieraDx Stream)
	(princ "\nmargine accosto contorno/bordo lamiera Sx   $MargineLamieraSx  -> " Stream) (princ $MargineLamieraSx Stream)
	(princ "\nmargine accosto contorno/bordo lamiera Tp   $MargineLamieraTp  -> " Stream) (princ $MargineLamieraTp Stream)
	(princ "\nmargine accosto contorno/bordo lamiera Bt   $MargineLamieraBt  -> " Stream) (princ $MargineLamieraBt Stream)
	(princ "\nmargine accosto contorno/bordo lamiera irr  $MargineLamiera    -> " Stream) (princ $MargineLamiera Stream)
	(princ "\nmargine rifilo sezionatrice                 $MargineRifilo     -> " Stream) (princ $MargineRifilo Stream)
	(princ "\nspessore lama sezionatrice                  $SpessoreLama      -> " Stream) (princ $SpessoreLama Stream)
	(princ "\nlunghezza attacco rettilineo in entrata     $LgSegEntra        -> " Stream) (princ $LgSegEntra Stream)
	(princ "\nlunghezza attacco rettilineo in uscita      $LgSegEsci         -> " Stream) (princ $LgSegEsci Stream)
	(princ "\nlunghezza attacco circolare in entrata      $LgSegEntra        -> " Stream) (princ $SvArcEntra Stream)
	(princ "\nlunghezza attacco circolare in uscita       $SvArcEsci         -> " Stream) (princ $SvArcEsci Stream)
	(princ "\nraggio attacco circolare in entrata         $RaggioEntra       -> " Stream) (princ $RaggioEntra Stream)
	(princ "\nraggio attacco circolare in uscita          $RaggioEsci        -> " Stream) (princ $RaggioEsci Stream)
	(princ "\ncolore attacco in entrata                   $ColorEntra        -> " Stream) (princ $ColorEntra Stream)
	(princ "\ncolore attacco in uscita                    $ColorEsci         -> " Stream) (princ $ColorEsci Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                           ++ variabili contorni ++                                                     " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nvelocita' taglio mm / min                $SpeedCut               -> " Stream) (princ $SpeedCut Stream)
	(princ "\ncolore contorno esterno orario           $ColorShapeOra          -> " Stream) (princ $ColorShapeOra Stream)
	(princ "\ncolore contorno esterno antiorario       $ColorShapeAntiOra      -> " Stream) (princ $ColorShapeAntiOra Stream)
	(princ "\ncolore contorno interno orario           $ColorHoleOra           -> " Stream) (princ $ColorHoleOra Stream)
	(princ "\ncolore contorno interno antiorario       $ColorHoleAntiOra       -> " Stream) (princ $ColorHoleAntiOra Stream)
	(princ "\ncolore contorno interno circolari        $ColorCircle            -> " Stream) (princ $ColorCircle Stream)
	(princ "\ncolore contorno interno ellittici        $ColorEllipse           -> " Stream) (princ $ColorEllipse Stream)
	(princ "\ncolore contorno staccati                 $ColorDetatch           -> " Stream) (princ $ColorDetatch Stream)
	(princ "\nfreccia massima divisione arco/cerchio   $ArrowArcDivision       -> " Stream) (princ $ArrowArcDivision Stream)
	(princ "\nprecisione rotazione LeanOn [gradi]      $AccuracyAngleRotation  -> " Stream) (princ $AccuracyAngleRotation Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                             ++ raggruppamenti ++                                                       " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nraggruppamento lamiera                    $RgpSheet          -> " Stream) (princ $RgpSheet Stream)
	(princ "\nraggruppamento target lamiera             $RgpSheetTarget    -> " Stream) (princ $RgpSheetTarget Stream)
	(princ "\nraggruppamento contorno piatto            $RgpShape          -> " Stream) (princ $RgpShape Stream)
	(princ "\nraggruppamento target piatto              $RgpShapeTarget    -> " Stream) (princ $RgpShapeTarget Stream)
	(princ "\nraggruppamento attacco in entrata         $RgpTiggerOn       -> " Stream) (princ $RgpTiggerOn Stream)
	(princ "\nraggruppamento attacco in uscita          $RgpTiggeroff      -> " Stream) (princ $RgpTiggeroff Stream)
	;(princ "\nraggruppamento righello                   $RgpRule           -> " Stream) (princ $RgpRule Stream)
	(princ "\nraggruppamento simulazione taglio         $RgpSymula         -> " Stream) (princ $RgpSymula Stream)
	;(princ "\nraggruppamento squadrature e cartigli     $RgpBom            -> " Stream) (princ $RgpBom Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                                ++ simulazione ++                                                       " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nsequenza 1/2/3/4/5                       $Sequence          -> " Stream) (princ $Sequence Stream)
	(princ "\ncolore simulazione                       $ColorSymula       -> " Stream) (princ $ColorSymula Stream)
	(princ "\ntipo simulazione                         $TypSymula         -> " Stream) (princ $TypSymula Stream)
	(princ "\nsecondi di intervallo                    $TimeSymula        -> " Stream) (princ $TimeSymula Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                               ++ DXF import ++                                                         " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nRimozione oggetti singoli                         $DxfRemoveSingleObject    -> " Stream) (princ $DxfRemoveSingleObject Stream)
	(princ "\nChiusura forzata polilinee                        $DxfClosePolyline         -> " Stream) (princ $DxfClosePolyline Stream)
	(princ "\nEsplosione blocchi                                $DxfExplodeBlocks         -> " Stream) (princ $DxfExplodeBlocks Stream)
	(princ "\nSemplificazione polilinee                         $DxfPurgePolyline         -> " Stream) (princ $DxfPurgePolyline Stream)
	(princ "\nControllo sovrapposizione line-archi-cerchi       $Overlapp                 -> " Stream) (princ $Overlapp Stream)
	(princ "\nTolleranza controllo centro cerchi e archi        $OverlappAcuracyCenter    -> " Stream) (princ $OverlappAcuracyCenter Stream)
	(princ "\nTolleranza controllo raggi archi e archi          $OverlappAcuracyRadius    -> " Stream) (princ $OverlappAcuracyRadius Stream)
	(princ "\nTolleranza controllo vertici                      $OverlappAcuracyPoint     -> " Stream) (princ $OverlappAcuracyPoint Stream)
	(princ "\nTolleranza controllo collinearita' punti su retta $OverlappAcuracyCollinear -> " Stream) (princ $OverlappAcuracyCollinear Stream)
	(princ "\nTolleranza controllo angoli archi                 $OverlappAcuracyAngleArc  -> " Stream) (princ $OverlappAcuracyAngleArc Stream)
	(princ "\nRimozione entita' con lunghezza <=                $RemoveAmbiguosLength     -> " Stream) (princ $RemoveAmbiguosLength Stream)
	(princ "\nMassima distanza apertura polilinea               $MaxOpenPolyline          -> " Stream) (princ $MaxOpenPolyline Stream)
	(princ "\nTolleranza per controllo centro LwPolyline        $CenterCirclePolyline     -> " Stream) (princ $CenterCirclePolyline Stream)
	(princ "\nCarattere divisore CSV                            $DivideCsv                -> " Stream) (princ $DivideCsv Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                               ++ folders e files ++                                                    " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\npercorso Bin                         BinPathEasyCut$             -> " Stream) (princ BinPathEasyCut$ Stream)
	(princ "\npercorso Gui DCL                     GuiPathEasyCut$             -> " Stream) (princ GuiPathEasyCut$ Stream)
	(princ "\npercorso Font                        FontPathEasyCut$            -> " Stream) (princ FontPathEasyCut$ Stream)
	(princ "\npercorso Libreria blocchi            LibPathEasyCut$             -> " Stream) (princ LibPathEasyCut$ Stream)
	(princ "\npercorso Expert Nesting              ExpertNestingEasyCut$       -> " Stream) (princ ExpertNestingEasyCut$ Stream)
	(princ "\npercorso RectPack Nesting            RectPackNestingEasyCut$     -> " Stream) (princ RectPackNestingEasyCut$ Stream)
	(princ "\npercorso DataBase                    DbaseEasyCut$               -> " Stream) (princ DbaseEasyCut$ Stream)
	(princ "\npercorso Load                        LoadEasyCut$                -> " Stream) (princ LoadEasyCut$ Stream)
	(princ "\npercorso CNC import                  CncPathEasyCut$             -> " Stream) (princ CncPathEasyCut$ Stream)
	(princ "\npercorso lavoro                      OutputPathEasyCut$          -> " Stream) (princ OutputPathEasyCut$ Stream)
	(princ "\npercorso taglio                      CutPathEasyCut$             -> " Stream) (princ CutPathEasyCut$ Stream)
	(princ "\npercorso info                        InfoPathEasyCut$            -> " Stream) (princ InfoPathEasyCut$ Stream)
	(princ "\npercorso layout HTML                 HtmlStorageEasyCut$         -> " Stream) (princ HtmlStorageEasyCut$ Stream)
	(princ "\npercorso Dxf Nesting                 DxfNestingEasyCut$          -> " Stream) (princ DxfNestingEasyCut$ Stream)
	(princ "\narchivio script html                 HtmlScriptEasyCut$          -> " Stream) (princ HtmlScriptEasyCut$ Stream)
	(princ "\narchivio lamiere html                ECFolderSheet$              -> " Stream) (princ ECFolderSheet$ Stream)
	(princ "\narchivio contorni html               ECFolderShape$              -> " Stream) (princ ECFolderShape$ Stream)
	(princ "\narchivio view contorni html          ECFolderShapePreview$       -> " Stream) (princ ECFolderShapePreview$ Stream)
	(princ "\narchivio report html                 ECFolderReport$             -> " Stream) (princ ECFolderReport$ Stream)
	(princ "\nnome file lamiere html               ECFileSheet$                -> " Stream) (princ ECFileSheet$ Stream)
	(princ "\nnome file contorno html              ECFileShape$                -> " Stream) (princ ECFileShape$ Stream)
	(princ "\nnome file report html                ECFileReport$               -> " Stream) (princ ECFileReport$ Stream)	
	(princ "\nnome file tree html                  ECFileTree$                 -> " Stream) (princ ECFileTree$ Stream)
	(princ "\nnome file setup Expert Nesting       ECFileSetupExpertNesting$   -> " Stream) (princ ECFileSetupExpertNesting$ Stream)
	(princ "\nnome file setup RectPack Nesting     ECFileSetupRectPackNesting$ -> " Stream) (princ ECFileSetupRectPackNesting$ Stream)
	(princ "\nnome file exe Expert Nesting         ECFileExeExpertNesting$     -> " Stream) (princ ECFileExeExpertNesting$ Stream)
	(princ "\nnome file exe RectPack Nesting       ECFileExeRectPackNesting$   -> " Stream) (princ ECFileExeRectPackNesting$ Stream)
	(princ "\nnome file EasyCutViewer              ECFileViewer$               -> " Stream) (princ ECFileViewer$ Stream)
	(princ "\npercorso setup                       SetupPathEasyCut$           -> " Stream) (princ SetupPathEasyCut$ Stream)
	(princ "\nnome file setup                      SetupFileEasyCut$           -> " Stream) (princ SetupFileEasyCut$ Stream)
	(princ "\nblocco info sheet                    NameBlockSheet$             -> " Stream) (princ NameBlockSheet$ Stream)
	(princ "\nblocco info shape                    NameBlockShape$             -> " Stream) (princ NameBlockShape$ Stream)
	(princ "\nblocco info shape TMP                NameBlockShapeTmp$          -> " Stream) (princ NameBlockShapeTmp$ Stream)
	(princ "\nfile blocco info sheet               FileBlockSheet$             -> " Stream) (princ FileBlockSheet$ Stream)
	(princ "\nfile blocco info shape               FileBlockShape$             -> " Stream) (princ FileBlockShape$ Stream)
	(princ "\nfile blocco info shape TMP           FileBlockShapeTmp$          -> " Stream) (princ FileBlockShapeTmp$ Stream)
	(princ "\nfile blocco logo                     FileBlockLogo$              -> " Stream) (princ FileBlockLogo$ Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                                  ++ filtri ++                                                          " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nfiltro contorno $FilterList        -> " Stream) (princ $FilterList Stream)
	(princ "\nfiltro attacchi $TriggerList       -> " Stream) (princ $TriggerList Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                                   ++ testi ++                                                          " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nstile testo                            $StyleEasyCut        -> " Stream) (princ $StyleEasyCut Stream)
	(princ "\nstile codice a barre                   $StyleEasyCutBarCode -> " Stream) (princ $StyleEasyCutBarCode Stream)
	(princ "\naltezza testo                          $HTextEasyCut        -> " Stream) (princ $HTextEasyCut Stream)
	;(princ "\nfont codice a barre                    $FontBarCodeEasyCut  -> " Stream) (princ $FontBarCodeEasyCut Stream)
	(princ "\nfont default                           $FontDefaultEasyCut  -> " Stream) (princ $FontDefaultEasyCut Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                                ++ dianmic info ++                                                      " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nlayer info dianmico                      $LayerDinamicInfoEasyCut     -> " Stream) (princ $LayerDinamicInfoEasyCut    Stream)
	(princ "\naltezza testo info dianmico              $HTextDinamicInfoEasyCut     -> " Stream) (princ $HTextDinamicInfoEasyCut    Stream)
	;(princ "\napertura catch info dianmico             $AperturaDinamicInfoEasyCut  -> " Stream) (princ $AperturaDinamicInfoEasyCut Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                         ++ velocita' taglio x spessori ++                                              " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nVelocita' di taglio $SpeedCutArray -->" Stream)
	(setq Num 1)
	(foreach itm $SpeedCutarray
		(princ (strcat "\n " (testo_a_destra (LM:rtos num 2 0) 3) " Spessore [mm] ->" (testo_a_destra (LM:rtos (nth 0 itm) 2 1) 5)
								   "      Velocita' [mm/min] ->"    (testo_a_destra (LM:rtos (nth 1 itm) 2 1) 5)) Stream)
		(setq Num (1+ Num))
	)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                        ++ diametri esclusi dal taglio ++                                               " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nDiametri esclusi dal taglio $CutOffArray -->" Stream)
	(setq Num 1)
	(foreach itm $CutOffarray
		(princ (strcat "\n " (testo_a_destra (LM:rtos Num 2 0) 3) " Diametro [mm] <"  (testo_a_destra (LM:rtos (nth 0 itm) 2 1) 4) " ÷ "
											 " "                   (testo_a_destra (LM:rtos (nth 1 itm) 2 1) 4) ">") Stream)
		(setq Num (1+ Num))
	)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                     ++ taglio contorni interni irregolari ++                                           " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\ntaglio contorni interni irregolari $CutOffIrregularShape              -> " Stream) (princ $CutOffIrregularShape  Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                                ++ Codice a Barre ++                                                    " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nComposizione codice a barre  $BarCodeArray --> " Stream)
	(setq CodeBar "")
	(foreach itm $BarCodeArray
		
		(if (= (nth 2 itm) 1)
			(if (/= (nth 1 itm) -1)
				(progn
					(setq CodeBar (strcat CodeBar (nth (nth 1 itm) $LstDataBarCode) (chr (nth 0 itm))))
				)
				(setq CodeBar (strcat CodeBar  (chr (nth 0 itm))))
			)
		)
	)
	(princ CodeBar Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                           ++ lista dati codice a barre ++                                              " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nLista dati codice a barre $LstDataBarCode -->" Stream)
	(foreach itm $LstDataBarCode
		(princ (strcat "\n Campo  < "  itm " >") Stream)
	)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                            ++ Export Html Reports ++                                                   " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nHTML Ctb di riferimento layout    $HtmlCtbEasyCut       -> " Stream) (princ $HtmlCtbEasyCut Stream)
	(princ "\nHTML PC3 di riferimento layout    $HtmlPlotterEasyCut   -> " Stream) (princ $HtmlPlotterEasyCut Stream)
	(princ "\nHTML dimensione foglio layout     $HtmlPaperSizeEasyCut -> " Stream) (princ $HtmlPaperSizeEasyCut Stream)

	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                ++ Lista composizione codice a linee di messaggio ++                                    " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nLunghezza inizio linea controllo messaggio $CharStartLineMessage  -> "  Stream) (princ $CharStartLineMessage Stream)
	(princ "\nLunghezza fine linea controllo messaggio    $CharEndLineMessage    -> " Stream) (princ $CharEndLineMessage Stream)
	(foreach itm $LengthLineMessage
		(princ (strcat "\n Carattere "  (car itm) "  Lunghezza " (LM:rtos (cdr itm) 2 2)) Stream)
	)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                                ++ Flessione ++                                                         " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nFlessione                          -> " Stream) (princ $Flex Stream)
	(princ "\nEscludi diametro da                -> " Stream) (princ $FlexHoleDiamExcludeFrom Stream)
	(princ "\nEscludi diametro a                 -> " Stream) (princ $FlexHoleDiamExcludeTo Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                                 ++ Microconnessione ++                                                 " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nLunghezza Micro                     -> " Stream) (princ $LgMicro Stream)
	(princ "\nAltezza Micro                       -> " Stream) (princ $WdMicro Stream)
	(princ "\nAltezza Micro nel vertice polylinea -> " Stream) (princ $WdMicroAtPoint Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\n;                                                 ++ NestingBar ++                                                       " Stream)
	(princ "\n;------------------------------------------------------------------------------------------------------------------------" Stream)
	(princ "\nSpessore taglio barra               -> " Stream) (princ $TkCutBar Stream)
	(princ "\nMargine iniziale barra              -> " Stream) (princ $BarMargStart Stream)
	(princ "\nMargine minimo finale barra         -> " Stream) (princ $BarMargEnd Stream)

	(close  Stream)
	(EasyCutViewer FileName)
	(princ)
)
;
;
;
(defun SpliTxt (testo char / ncar glo temp a bak)
;
; procedura per la suddivisione di un testo
; testo  .......= testo da esaminare
; char .........= carattere separatore
;
(setq ncar (strlen testo) glo 1 temp "" bak nil)
;
 (while (<= glo ncar)
   (setq a (substr testo glo 1))
   (if (/= a char)
       (progn
         (while (and (/= a char) (<= glo ncar))
            (setq temp (strcat temp a) glo (+ 1 glo) a (substr testo glo 1))
         )
         (setq bak (append bak (list temp)) temp "")
       )
       (setq glo (+ 1 glo))
   )
 )

 (if (= bak nil) 
     (setq bak (list ""))
 )

 (setq bak bak)
)
;
;
;
(defun SplitPath (Path / LstChar itm Rtn)
	
	(if Path
		(progn
			(setq LstChar (vl-string->list Path))
			(setq Rtn "")
			(foreach itm LstChar
				(cond
					((= itm 92)
						(setq Rtn (strcat Rtn "*"))
					)
					((= itm 47)
						(setq Rtn (strcat Rtn "*"))
					)
					(t
						(setq Rtn (strcat Rtn (chr itm)))
					)
				)
			)
			(setq Rtn (splitxt Rtn "*"))
		)
	)
	Rtn
)
;
;
;
(defun GuiSetupEasyCut ( / selected LstSetup loop _xx_)

	(setq LstSetup (list "SETUP UTILIZZO SFRIDO"  
						 "SETUP DXF IMPORT"  
						 "SETUP ATTACCHI" 
					     "SETUP CONTORNI"
						 "SETUP VELOCITA"
						 "SETUP ESCLUDI CONTORNI"
						 "SETUP RAGGRUPPAMENTI"
						 "SETUP SEQUENZA E SIMULAZIONE"
						 "SETUP FLESSIONE"
						 "SETUP MICROCONNESSIONE"
						 "SETUP NESTING BARRE"
						 "SETUP ARCHIVIO"
						 "SETUP FILTRI"
						 "SETUP TESTO"
						 "SETUP BROWSER"
						 "SETUP IMMAGINI HTML"
						 "SETUP ARCHIVIO HTML"
						 "SETUP CODICE A BARRE"
						 "SETUP DIMSTYLE"
						 "SETUP LEADER"
					)
	)
						 
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	
	(setq loop T)
	(while loop
	
		(setq selected nil)
		(new_dialog "mainsetup" xx "" (cond ( *mainsetup* ) ( '(-1 -1) )))
		
			(start_list "box_info")	
			(mapcar 'add_list LstSetup)
			(end_list)
			(set_tile "NameSetup" (strcat "Configurazione attiva  [" NameConfigurationEasyCut$ "]"))
			(mode_tile   "box_info" 2)
			(action_tile "box_info" "(setq selected (nth (atoi (setq _j $value)) LstSetup))")
			(action_tile "accept"   (strcat "(setq IdSelect (get_tile \"box_info\"))"
											"(if (= IdSelect \"\")"
											"	(setq selected nil)"
											"	(setq selected (nth (atoi IdSelect) LstSetup))" 
											")"
											"(setq *mainsetup* (done_dialog)) (unload_dialog xx)"))
			(action_tile "cancel"   (strcat "(setq Loop nil selected nil)"
											"(setq *mainsetup* (done_dialog)) (unload_dialog xx)"))
			(action_tile "show"   	(strcat "(setq Loop nil)"
											"(setq selected \"SHOW CONFIGURATION\")"
											"(setq *mainsetup* (done_dialog)) (unload_dialog xx)"))
			(action_tile "delete"   (strcat "(setq selected \"DELETE CONFIGURATION\")"))
			(action_tile "saveAS"   (strcat "(setq selected \"SAVE CONFIGURATION\")"))
			(action_tile "load"     (strcat "(setq selected \"LOAD CONFIGURATION\")"))
				
		(start_dialog)
		
		(cond
			((= selected "DELETE CONFIGURATION")
				(DeleteConfiguration)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SAVE CONFIGURATION")
				(SaveAsConfiguration)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "LOAD CONFIGURATION")
				(LoadConfiguration)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SHOW CONFIGURATION")
				(ShowConfiguration)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP UTILIZZO SFRIDO")
				(LoadGuiAdminScrap)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP DXF IMPORT")
				(LoadGuiDxfImport)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP ATTACCHI")
				(LoadGuiTrigger)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP CONTORNI")
				(LoadGuiShape)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP VELOCITA")
				(LoadGuiSpeed)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP ESCLUDI CONTORNI")
				(LoadGuiCutOff)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP RAGGRUPPAMENTI")
				(LoadGuiRegapp)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP SEQUENZA E SIMULAZIONE")
				(LoadGuiSymula)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP FLESSIONE")
				(LoadGuiFlex)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP MICROCONNESSIONE")
				(LoadGuiMicro)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP NESTING BARRE")
				(LoadGuiNestingBar)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP ARCHIVIO")
				(LoadGuiFolders&Files)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP FILTRI")
				(LoadGuiFilter)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP TESTO")
				(LoadGuiText)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP IMMAGINI HTML")
				(GuiPlotHtml)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP BROWSER")
				(GuiLstBrowser)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP ARCHIVIO HTML")
				(LoadGuiHtml)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP CODICE A BARRE")
				(LoadGuiBarCode)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP DIMSTYLE")
				(GuiStyleDimension)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			((= selected "SETUP LEADER")
				(SetupLeader)
				(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
				(setq selected nil)
				(setq loop T)
			)
			(t
				(setq selected nil)
				(setq loop nil)
			)
		)
	)
	;(WriteConfigNestporfessor (strcat NestPorfessorEasyCut$ ECFileSetupNestProfessor$))
)
;
;
;
(defun CkeckDataDcl (LstCheckData / itm Rtn)

	(foreach itm LstCheckData
		(setq itm  (vl-string-right-trim  " \t" (vl-string-left-trim " \t" itm)))
		(if (= itm "")
			(setq Rtn T)
		)	
	)
	(if (not Rtn) 
		(setq Rtn LstCheckData)
		(setq Rtn nil)
	)
)	
;
;
;
(defun ShowConfiguration (/ Out FileOut ActualSetup)

	;(setq Out (MyGetField SetupPathEasyCut$ nil "*.cfg"))
	
	(if (setq Out (OpenFileDialog  (list SetupPathEasyCut$ nil "*.cfg" "Show Configuration" nil	T)))
		(progn
			(setq FileOut (strcat  (car Out) "\\" (vl-filename-base (cadr Out)) ".cfg"))
			(setq ActualSetup NameConfigurationEasyCut$)
			(LoadClientSetupEasyCut FileOut)
			(CheckVarEasyCut)
			(LoadClientSetupEasyCut ActualSetup)
		)
	)
)
;
;
;
(defun DeleteConfiguration (/ Out FileOut)

	;(setq Out (MyGetField SetupPathEasyCut$ nil "*.cfg"))
	
	(if (setq Out (OpenFileDialog  (list SetupPathEasyCut$ nil "*.cfg" "Delete Configuration" nil T)))
		(progn
			(setq FileOut (strcat  (car Out) "\\" (vl-filename-base (cadr Out)) ".cfg"))
			(if (= NameConfigurationEasyCut$ FileOut)
				(LM:popup "avvertimento" "configurazione attiva \n non puoi cancellarla" (+ 0 48 4096))
				(if (findfile FileOut)
					(if (vl-file-delete  FileOut)
						(alert (strcat "\nconfigurazione cancellata  -> " FileOut))
						(alert (strcat "\nproblema cancellazione configurazione  -> " FileOut))
					)
				)
			)
		)
	)
)
;
;
;
(defun LoadConfiguration (/ Out FileOut)

	;(setq Out (MyGetField SetupPathEasyCut$ nil "*.cfg"))
	

	(if (setq Out (OpenFileDialog  (list SetupPathEasyCut$ nil "*.cfg" "Load Configuration" nil	T)))
		(progn
			(setq FileOut (strcat  (car Out) "\\" (vl-filename-base (cadr Out)) ".cfg"))
			(LoadClientSetupEasyCut FileOut)
			(setq NameConfigurationEasyCut$ FileOut)
			(setq SetupPathEasyCut$ (strcat (car Out) "\\"))
			(setq SetupFileEasyCut$ (cadr Out))
			(vl-registry-write EasyCutRegistryPath$ "PathCfg" (car  Out))	
			(vl-registry-write EasyCutRegistryPath$ "FileCfg" (cadr Out))
		)
	)
)
;
;
;
(defun SaveAsConfiguration (/ Out FileOut Rtn)

	(if (setq Out (OpenFileDialog  (list SetupPathEasyCut$ nil "*.cfg" "Save As Configuration" nil	T)))
		(progn
			(setq FileOut 	(strcat  (car Out) "\\" (vl-filename-base (cadr Out)) ".cfg"))
			(if (findfile FileOut)
				(progn
					(setq Rtn (LM:popup "avvertimento" "Il file esite \n vuoi sovrascriverlo ?" (+ 1 48 4096)))
					(cond	
						((= Rtn 1)
							(setq NameConfigurationEasyCut$ FileOut)
							(SaveSetupEasyCut FileOut "\nconfigurazione client salvata -> ")
							(setq SetupPathEasyCut$ (strcat (car Out) "\\"))
							(setq SetupFileEasyCut$ (strcat (vl-filename-base (cadr Out)) ".cfg"))
							(vl-registry-write EasyCutRegistryPath$ "PathCfg" (car Out))	
							(vl-registry-write EasyCutRegistryPath$ "FileCfg" SetupFileEasyCut$)
						)
						(t
							nil
						)
					)
				)
				(progn
					(setq NameConfigurationEasyCut$ FileOut)
					(SaveSetupEasyCut FileOut "\nconfigurazione client salvata -> ")
					(setq SetupPathEasyCut$ (strcat (car Out) "\\"))
					(setq SetupFileEasyCut$ (strcat (vl-filename-base (cadr Out)) ".cfg"))
					(vl-registry-write EasyCutRegistryPath$ "PathCfg" (car Out))	
					(vl-registry-write EasyCutRegistryPath$ "FileCfg" SetupFileEasyCut$)
				)
			)
		)
	)
)
;
;
;
(defun CheckFolder (Folder / Rtn itm)
	;(CheckFolder "C:\\Users\\delucaa\\AppData\\Local\\EasyCut\\")
	(if Folder
		(progn
			(setq Rtn "")
			(foreach itm (splitxt Folder "\\")
				(setq Rtn (strcat Rtn itm "\\"))
			)
			;(if (/= (ascii (substr Folder (- (strlen Folder) 0) 1)) 92)
			;	(strcat Folder (chr 92))
			;	Folder
			;)		
		)
	)
	Rtn
)
;
;
;
(defun SaveSetupEasyCut (FileName Msg / nc Stream)

	(if (not (vl-file-directory-p SetupPathEasyCut$))	(vl-mkdir SetupPathEasyCut$))
	
	(setq SetupPathEasyCut$ (CheckFolder SetupPathEasyCut$))
	
	(setq Stream (open FileName "w")) 
	
	(if (not Stream)
		(progn
			(alert (strcat "[SaveSetupEasyCut] ERRORE!! apertura file " FileName))
			(exit)
		)
	)
	(setq nc 20)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ versione ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ (strcat VersionEasyCut$                   "    | VersionEasyCut$  | nome versione\n") Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ configurazione ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ (strcat NameConfigurationEasyCut$         "    | NameConfigurationEasyCut$  | nome configurazione\n") Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ variabili utilizzo sfrido ++\n" Stream)
	(princ ";------------------------------------++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------\n" Stream)
	(if ECPartInPart$
		(princ (strcat (testo_a_sinistra "T" nc)    " | ECPartInPart$    | Utilizzo sfrido controni interni\n") Stream)
		(princ (strcat (testo_a_sinistra "nil" nc)  " | ECPartInPart$    | Utilizzo sfrido controni interni\n") Stream)
	)
	(if ECScrapInPart$
		(princ (strcat (testo_a_sinistra "T" nc)    " | ECScrapInPart$   | Utilizzo sfrido controni esterni\n") Stream)
		(princ (strcat (testo_a_sinistra "nil" nc)  " | ECScrapInPart$   | Utilizzo sfrido controni esterni\n") Stream)
	)
	(if ECMergeScrap$
		(princ (strcat (testo_a_sinistra "T" nc)    " | ECMergeScrap$    | Utilizzo sfrido lamiera\n") Stream)
		(princ (strcat (testo_a_sinistra "nil" nc)  " | ECMergeScrap$    | Utilizzo sfrido lamiera\n") Stream)
	)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ variabili attacchi ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $MargineAccosto 2 2) nc)    " | $MargineAccosto  | margine accosto contorno [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $MargineLamieraDx 2 2) nc)  " | $MargineLamieraDx| margine accosto contorno/bordo lamiera Dx [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $MargineLamieraSx 2 2) nc)  " | $MargineLamieraSx| margine accosto contorno/bordo lamiera Sx [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $MargineLamieraTp 2 2) nc)  " | $MargineLamieraTp| margine accosto contorno/bordo lamiera Alto [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $MargineLamieraBt 2 2) nc)  " | $MargineLamieraBt| margine accosto contorno/bordo lamiera Basso [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $MargineLamiera 2 2) nc)    " | $MargineLamiera  | margine accosto contorno/bordo lamiera Irregolare [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $MargineRifilo 2 2) nc)     " | $MargineRifilo   | margine rifilo sezionatrice [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $SpessoreLama 2 2) nc)      " | $SpessoreLama    | spessore lama sezionatrice [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $LgSegEntra 2 2) nc)        " | $LgSegEntra      | lunghezza attacco rettilineo in entrata [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $LgSegEsci 2 2) nc)         " | $LgSegEsci       | lunghezza attacco rettilineo in uscita [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $SvArcEntra 2 2) nc)        " | $SvArcEntra      | lunghezza attacco circolare in entrata [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $SvArcEsci 2 2) nc)         " | $SvArcEsci       | lunghezza attacco circolare in uscita [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $RaggioEntra 2 2) nc)       " | $RaggioEntra     | raggio attacco circolare in entrata [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $RaggioEsci 2 2) nc)        " | $RaggioEsci      | raggio attacco circolare in uscita [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $ColorEntra 2 0) nc)        " | $ColorEntra      | colore attacco in entrata\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $ColorEsci 2 0) nc)         " | $ColorEsci       | colore attacco in uscita\n") Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ variabili contorni ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $SpeedCut 2 0) nc)          "| $SpeedCut         | velocita' taglio [mm/min]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $ColorShapeOra 2 0) nc)     "| $ColorShapeOra    | colore contorno esterno orario\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $ColorShapeAntiOra 2 0) nc) "| $ColorShapeAntiOra| colore contorno esterno antiorario\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $ColorHoleOra 2 0) nc)      "| $ColorHoleOra     | colore contorno interno orario\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $ColorHoleAntiOra 2 0) nc)  "| $ColorHoleAntiOra | colore contorno interno antiorario\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $ColorCircle 2 0) nc)       "| $ColorCircle      | colore contorno interno circolari\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $ColorEllipse 2 0) nc)      "| $ColorEllipse     | colore contorno interno ellittici\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $ColorDetatch 2 0) nc)      "| $ColorDetatch     | colore contorno e attacchi staccati\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $ArrowArcDivision 2 2) nc)  "| $ArrowArcDivision | freccia massima per il calcolo della divisione dell'arco-cerchio [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $AccuracyAngleRotation 2 2) nc)  "| $AccuracyAngleRotation | precisione rotazione LeanOn [gradi]\n") Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ raggruppamenti ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ (strcat (testo_a_sinistra $RgpSheet nc)                     "| $RgpSheet         | raggruppamento lamiera\n") Stream)
	(princ (strcat (testo_a_sinistra $RgpSheetTarget nc)               "| $RgpSheetTarget   | raggruppamento target lamiera\n") Stream)
	(princ (strcat (testo_a_sinistra $RgpShape nc)                     "| $RgpShape         | raggruppamento contorno piatto\n") Stream)
	(princ (strcat (testo_a_sinistra $RgpShapeTarget nc)               "| $RgpShapeTarget   | raggruppamento target piatto\n") Stream)
	(princ (strcat (testo_a_sinistra $RgpTiggerOn nc)                  "| $RgpTiggerOn      | raggruppamento attacco in entrata\n") Stream)
	(princ (strcat (testo_a_sinistra $RgpTiggeroff nc)                 "| $RgpTiggeroff     | raggruppamento attacco in uscita\n") Stream)
	;(princ (strcat (testo_a_sinistra $RgpRule nc)                      "| $RgpRule          | raggruppamento righello\n") Stream)
	(princ (strcat (testo_a_sinistra $RgpSymula nc)                    "| $RgpSymula        | raggruppamento simulazione taglio\n") Stream)
	;(princ (strcat (testo_a_sinistra $RgpBom nc)                       "| $RgpBom           | raggruppamento squadrature e cartigli\n") Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ simulazione ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $Sequence 2 0) nc)          "| $Sequence         | sequenza 1/2/3/4/5\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $ColorSymula 2 0) nc)       "| $ColorSymula      | colore simulazione\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $TypSymula 2 0) nc)         "| $TypSymula        | 1 = battere enter ad ogni segmento\n") Stream)
	(princ (strcat (testo_a_sinistra ";" nc) "|                   | 2 = automatico per ogni segmento (dare il tempo di attesa)\n") Stream)
	(princ (strcat (testo_a_sinistra ";" nc) "|                   | 3 = battere enter ad ogni spostamento veloce (il contorno viene inteso come un'unica entita')\n") Stream)
	(princ (strcat (testo_a_sinistra ";" nc) "|                   | 4 = automatico per ogni spostamento veloce (dare il tempo di attesa)\n") Stream)
    (princ (strcat (testo_a_sinistra (LM:rtos $TimeSymula 2 0) nc)        "| $TimeSymula       | tempo azione simulazione [sec]\n") Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";  ++ DXF import ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(if $DxfRemoveSingleObject
		(princ (strcat (testo_a_sinistra "T" nc)    "| $DxfRemoveSingleObject    | Rimozione oggetti singoli\n") Stream)
		(princ (strcat (testo_a_sinistra "nil" nc)  "| $DxfRemoveSingleObject    | Rimozione oggetti singoli\n") Stream)
	)
	(if $DxfClosePolyline
		(princ (strcat (testo_a_sinistra "T" nc)    "| $DxfClosePolyline         | Chiusura forzata polilinee\n") Stream)
		(princ (strcat (testo_a_sinistra "nil" nc)  "| $DxfClosePolyline         | Chiusura forzata polilinee\n") Stream)
	)
	(if $DxfExplodeBlocks
		(princ (strcat (testo_a_sinistra "T" nc)    "| $DxfExplodeBlocks         | Esplosione blocchi\n") Stream)
		(princ (strcat (testo_a_sinistra "nil" nc)  "| $DxfExplodeBlocks         | Esplosione blocchi\n") Stream)
	)
	(if $DxfPurgePolyline 
		(princ (strcat (testo_a_sinistra "T" nc)    "| $DxfPurgePolyline         | Semplificazione polilinee\n") Stream)
		(princ (strcat (testo_a_sinistra "nil" nc)  "| $DxfPurgePolyline         | Semplificazione polilinee\n") Stream)
	)
	(if $Overlapp
		(princ (strcat (testo_a_sinistra "T" nc)    "| $Overlapp                 | Controllo sovrapposizione line-archi-cerchi\n") Stream)
		(princ (strcat (testo_a_sinistra "nil" nc)  "| $Overlapp                 | Controllo sovrapposizione line-archi-cerchi\n") Stream)
	)
	(princ (strcat (testo_a_sinistra (LM:rtos $OverlappAcuracyCenter    2 4) nc)  "| $OverlappAcuracyCenter    | Tolleranza controllo centro cerchi e archi\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $OverlappAcuracyRadius    2 4) nc)  "| $OverlappAcuracyRadius    | Tolleranza controllo raggi archi e archi\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $OverlappAcuracyPoint     2 4) nc)  "| $OverlappAcuracyPoint     | Tolleranza controllo vertici\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $OverlappAcuracyCollinear 2 4) nc)  "| $OverlappAcuracyCollinear | Tolleranza controllo collinearita' punti su retta\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $OverlappAcuracyAngleArc  2 4) nc)  "| $OverlappAcuracyAngleArc  | Tolleranza controllo angoli archi\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $RemoveAmbiguosLength     2 4) nc)  "| $RemoveAmbiguosLength     | Rimozione entita' con lunghezza <=\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $MaxOpenPolyline          2 4) nc)  "| $MaxOpenPolyline          | Massima distanza apertura polilinea\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $CenterCirclePolyline     2 4) nc)  "| $CenterCirclePolyline     | Tolleranza per controllo centro LwPolyline\n") Stream)
	(princ (strcat (testo_a_sinistra $DivideCsv nc)                               "| $DivideCsv                | Carattere divisore file Csv\n") Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ folders e files ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(setq BinPathEasyCut$ (CheckFolder BinPathEasyCut$))
	(princ (strcat (testo_a_sinistra BinPathEasyCut$ 100)       "| BinPathEasyCut$       | archivio Bin\n") Stream)
	
	(setq GuiPathEasyCut$ (CheckFolder GuiPathEasyCut$))
	(princ (strcat (testo_a_sinistra GuiPathEasyCut$ 100)       "| GuiPathEasyCut$       | archivio interfaccia grafica DCL\n") Stream)
	
	(setq FontPathEasyCut$ (CheckFolder FontPathEasyCut$))
	(princ (strcat (testo_a_sinistra FontPathEasyCut$ 100)      "| FontPathEasyCut$      | archivio font\n") Stream)
	
	(setq LibPathEasyCut$ (CheckFolder LibPathEasyCut$))
	(princ (strcat (testo_a_sinistra LibPathEasyCut$ 100)       "| LibPathEasyCut$       | archivio libreria blocchi\n") Stream)
	
	;(setq NestPorfessorEasyCut$ (CheckFolder NestPorfessorEasyCut$))
	;(princ (strcat (testo_a_sinistra NestPorfessorEasyCut$ 100) "| NestPorfessorEasyCut$ | eseguibile NestProfessor\n") Stream)

	(setq ExpertNestingEasyCut$ (CheckFolder ExpertNestingEasyCut$))
	(princ (strcat (testo_a_sinistra ExpertNestingEasyCut$ 100) "| ExpertNestingEasyCut$ | eseguibile ExpertNesting\n") Stream)
	
	(setq RectPackNestingEasyCut$ (CheckFolder RectPackNestingEasyCut$))
	(princ (strcat (testo_a_sinistra RectPackNestingEasyCut$ 100) "| RectPackNestingEasyCut$ | eseguibile RectPackNestingEasyCut\n") Stream)
	
	(setq DbaseEasyCut$ (CheckFolder DbaseEasyCut$))
	(princ (strcat (testo_a_sinistra DbaseEasyCut$ 100)         "| DbaseEasyCut$         | archivio DataBase\n") Stream)
	
	(setq LoadEasyCut$ (CheckFolder LoadEasyCut$))
	(princ (strcat (testo_a_sinistra LoadEasyCut$ 100)          "| LoadEasyCut$          | archivio Load\n") Stream)
	
	(setq CncPathEasyCut$ (CheckFolder CncPathEasyCut$))
	(princ (strcat (testo_a_sinistra CncPathEasyCut$ 100)       "| CncPathEasyCut$       | archivio CNC import\n") Stream)
	
	(setq OutputPathEasyCut$ (CheckFolder OutputPathEasyCut$))
	(princ (strcat (testo_a_sinistra OutputPathEasyCut$ 100)    "| OutputPathEasyCut$    | archivio lavoro\n") Stream)
	
	(setq CutPathEasyCut$ (CheckFolder CutPathEasyCut$))
	(princ (strcat (testo_a_sinistra CutPathEasyCut$ 100)       "| CutPathEasyCut$       | archivio salva percorso taglio\n") Stream)
	
	(setq InfoPathEasyCut$ (CheckFolder InfoPathEasyCut$))
	(princ (strcat (testo_a_sinistra InfoPathEasyCut$ 100)      "| InfoPathEasyCut$      | archivio info \n") Stream)
	
	(setq HtmlStorageEasyCut$ (CheckFolder HtmlStorageEasyCut$))
	(princ (strcat (testo_a_sinistra HtmlStorageEasyCut$ 100)   "| HtmlStorageEasyCut$   | archivio layout Html\n") Stream)	
	
	(princ (strcat (testo_a_sinistra HtmlScriptEasyCut$ 100)    "| HtmlScriptEasyCut$    | archivio script Html\n") Stream)	

	(setq DxfNestingEasyCut$ (CheckFolder DxfNestingEasyCut$))
	(princ (strcat (testo_a_sinistra DxfNestingEasyCut$ 100)    "| DxfNestingEasyCut$    | archivio Dxf nesting\n") Stream)
	
	(setq SetupPathEasyCut$ (CheckFolder SetupPathEasyCut$))
	(princ (strcat (testo_a_sinistra SetupPathEasyCut$ 100)     "| SetupPathEasyCut$     | archivio setup\n") Stream)
	
	(princ (strcat (testo_a_sinistra SetupFileEasyCut$ 100)     "| SetupFileEasyCut$     | file setup\n") Stream)
	

	(princ (strcat (testo_a_sinistra ECFileSetupExpertNesting$   100)   "| ECFileSetupExpertNesting$   | file setup expertNesting\n") Stream)
	(princ (strcat (testo_a_sinistra ECFileSetupRectPackNesting$ 100)   "| ECFileSetupRectPackNesting$ | file setup RectPackNesting\n") Stream)
	(princ (strcat (testo_a_sinistra ECFileExeExpertNesting$     100)   "| ECFileExeExpertNesting$     | file exe ExpertNesting\n") Stream)
	(princ (strcat (testo_a_sinistra ECFileExeRectPackNesting$   100)   "| ECFileExeRectPackNesting$   | file exe RectPackNesting\n") Stream)
	(princ (strcat (testo_a_sinistra ECFileViewer$   100)               "| ECFileViewer$               | file EasyCutViewer\n") Stream)
	(princ (strcat (testo_a_sinistra NameBlockSheet$ 100)               "| NameBlockSheet$             | nome blocco info sheet\n") Stream)
	(princ (strcat (testo_a_sinistra NameBlockShape$ 100)               "| NameBlockShape$             | nome blocco info shape\n") Stream)
	(princ (strcat (testo_a_sinistra FileBlockSheet$ 100)               "| FileBlockSheet$             | file blocco info sheet\n") Stream)
	(princ (strcat (testo_a_sinistra FileBlockShape$ 100)               "| FileBlockShape$             | file blocco info shape\n") Stream)
	(princ (strcat (testo_a_sinistra FileBlockLogo$  100)               "| FileBlockLogo$              | file blocco logo\n") Stream)
	
	(setq ECFolderSheet$ (CheckFolder ECFolderSheet$))
	(princ (strcat (testo_a_sinistra ECFolderSheet$ 100)        "| ECFolderSheet$        | archivio lamiere html\n") Stream)
	
	(setq ECFolderShape$ (CheckFolder ECFolderShape$))
	(princ (strcat (testo_a_sinistra ECFolderShape$ 100)        "| ECFolderShape$        | archivio contorni html\n") Stream)
	
	(setq ECFolderShapePreview$ (CheckFolder ECFolderShapePreview$))
	(princ (strcat (testo_a_sinistra ECFolderShapePreview$ 100) "| ECFolderShapePreview$ | archivio preview contorni html\n") Stream)
	
	(setq ECFolderReport$ (CheckFolder ECFolderReport$))
	(princ (strcat (testo_a_sinistra ECFolderReport$ 100)       "| ECFolderReport$       | archivio report html\n") Stream)
	
	(princ (strcat (testo_a_sinistra ECFileSheet$ 100)          "| ECFileSheet$          | nome file lamiere html\n") Stream)
	(princ (strcat (testo_a_sinistra ECFileShape$ 100)          "| ECFileShape$          | nome file contorno html\n") Stream)
	(princ (strcat (testo_a_sinistra ECFileReport$ 100)         "| ECFileReport$         | nome file report html\n") Stream)
	(princ (strcat (testo_a_sinistra ECFileTree$ 100)           "| ECFileTree$           | nome file tree html\n") Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ filtri ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(prin1 $FilterList Stream)
	(princ "| $FilterList       | filtro contorni\n" Stream)
	(prin1 $TriggerList Stream)
	(princ "| $TriggerList      | filtro attacchi\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ varie ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ (strcat (testo_a_sinistra $StyleEasyCut nc)                  "| $StyleEasyCut       | style testo\n") Stream)
	(princ (strcat (testo_a_sinistra $StyleEasyCutBarCode nc)           "| $StyleEasyCutBarCode| style codice a barre\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $HTextEasyCut 2 0) nc)    "| $HTextEasyCut       | altezza testo\n") Stream)
	;(princ (strcat (testo_a_sinistra $FontBarCodeEasyCut nc)            "| $FontBarCodeEasyCut | font codice a barre\n") Stream)
	(princ (strcat (testo_a_sinistra $FontDefaultEasyCut nc)            "| $FontDefaultEasyCut | font default\n") Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ dinamic info ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ (strcat (testo_a_sinistra $LayerDinamicInfoEasyCut nc)                  "| $LayerDinamicInfoEasyCut    | layer info dinamico\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $HTextDinamicInfoEasyCut 2 0) nc)    "| $HTextDinamicInfoEasyCut    | altezza info dinamico\n") Stream)
	;(princ (strcat (testo_a_sinistra (LM:rtos $AperturaDinamicInfoEasyCut 2 0) nc) "| $AperturaDinamicInfoEasyCut | apertura info dianmico\n") Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ velocita' taglio x spessori ++ \n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(prin1 $SpeedCutArray Stream)
	(princ "| $SpeedCutarray       | velocita' taglio x spessori [mm/min]\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ diametri esclusi dal taglio ++ \n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(prin1 $CutOffArray Stream)
	(princ "| $CutOffArray       | diametri esclusi dal taglio [mm]\n" Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $CutOffIrregularShape 2 0) nc)    " | $CutOffIrregularShape  | contorni interni irregolari esclusi dal taglio\n") Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ composizione codice a barre  ++ \n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(prin1 $BarCodeArray Stream)
	(princ "| $BarCodeArray       | composizione codice a barre \n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ lista dati codice a barre  ++ \n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(prin1 $LstDataBarCode Stream)
	(princ "| $LstDataBarCode       | lista dati codice a barre \n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ Export Html Reports ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ (strcat (testo_a_sinistra $HtmlCtbEasyCut 50)         "| $HtmlCtbEasyCut        | HTML Ctb di riferimento layout\n") Stream)
	(princ (strcat (testo_a_sinistra $HtmlPlotterEasyCut 50)     "| $HtmlPlotterEasyCut    | HTML PC3 di riferimento layout\n") Stream)
	(princ (strcat (testo_a_sinistra $HtmlPaperSizeEasyCut 50)   "| $HtmlPaperSizeEasyCut  | HTML dimensione foglio layout\n") Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ ";   ++ Lista composizione codice a linee di messaggio  ++\n" Stream)
	(princ ";------------------------------------------------------------------------------------------------------------------------------------------------------\n" Stream)
	(princ (strcat (testo_a_sinistra  (LM:rtos $CharStartLineMessage 2 2) 50)  "| $CharStartLineMessage  | lunghezza inizio linea contrllo messaggio\n") Stream)
	(princ (strcat (testo_a_sinistra  (LM:rtos $CharEndLineMessage   2 2) 50)  "| $CharEndLineMessage    | lunghezza fine linea contrllo messaggio\n") Stream)
	(prin1 $LengthLineMessage  	 Stream)
	(princ "| $LengthLineMessage       | lunghezza linee messaggio \n" Stream)
	(princ ";----------------------------------------------------------------------------\n" Stream)
	(princ ";                            ++ Flessione                                  ++\n" Stream)
	(princ ";----------------------------------------------------------------------------\n" Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $Flex 2 2) nc)                     "| $Flex  | flessione [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $FlexHoleDiamExcludeFrom 2 1) nc)  "| $FlexHoleDiamExcludeFrom  | Escludi diametro da [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $FlexHoleDiamExcludeTo 2 1) nc)    "| $FlexHoleDiamExcludeTo    | Escludi diametro a [mm]\n") Stream)
	(princ ";----------------------------------------------------------------------------\n" Stream)
	(princ ";                            ++ Microconnessione                           ++\n" Stream)
	(princ ";----------------------------------------------------------------------------\n" Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $LgMicro 2 3) nc)                  "| $LgMicro  | Lunghezza Micro [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $WdMicro 2 3) nc)                  "| $WdMicro  | Altezza Micro [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $WdMicroAtPoint 2 3) nc)           "| $WdMicroAtPoint | Altezza Micro nel vertice polylinea [mm]\n") Stream)
	(princ ";----------------------------------------------------------------------------\n" Stream)
	(princ ";                            ++ NestingBar                                 ++\n" Stream)
	(princ ";----------------------------------------------------------------------------\n" Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $TkCutBar 2 3) nc)                 "| $TkCutBar      | Spessore taglio barra [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $BarMargStart 2 3) nc)             "| $BarMargStart  | Margine iniziale barra [mm]\n") Stream)
	(princ (strcat (testo_a_sinistra (LM:rtos $BarMargEnd 2 3) nc)               "| $BarMargEnd    | Margine minimo finale barra [mm]\n") Stream)

	(close Stream)
	(if Msg (progn (princ Msg) (princ FileName)))
	(princ)
)
;
;
;
(defun LoadGuiAdminScrap (/ LoadSetupAdminScrapDcl GetDataSetupAdminScrapDcl xx)

	(defun LoadSetupAdminScrapDcl ()
		
		(if ECPartInPart$ 	(set_tile "OkPartInPart"  "1") (set_tile "NoPartInPart"  "1"))
		(if ECScrapInPart$ 	(set_tile "OkScrapInPart" "1") (set_tile "NoScrapInPart" "1"))
		(if ECMergeScrap$	(set_tile "OkMergeScrap"  "1") (set_tile "NoMergeScrap"  "1"))
	)
	;
	(defun GetDataSetupAdminScrapDcl ()
		(if (= (get_tile "OkPartInPart" ) "1") (setq ECPartInPart$  T) (setq ECPartInPart$  nil))
		(if (= (get_tile "OkScrapInPart") "1") (setq ECScrapInPart$ T) (setq ECScrapInPart$ nil))
		(if (= (get_tile "OkMergeScrap" ) "1") (setq ECMergeScrap$  T) (setq ECMergeScrap$  nil))

		(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
	)
	;
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "setupadminscrap" xx "" (cond ( *setupAaminscrap* ) ( '(-1 -1) )))
		(LoadSetupAdminScrapDcl)
		(action_tile "accept" (strcat "(GetDataSetupAdminScrapDcl) (setq *setupAaminscrap* (done_dialog)) (unload_dialog xx)"))
		(action_tile "cancel" "(setq *setupAaminscrap* (done_dialog)) (unload_dialog xx)")
	(start_dialog)

)
;
;
;
(defun LoadGuiDxfImport (/ LoadSetupDxfImportDcl GetDataImportDxfDcl ChangeMode xx loop Rtn)

	(defun LoadSetupDxfImportDcl ()
		
		(if $DxfRemoveSingleObject 	(set_tile "OkRemove"   "1") (set_tile "NoRemove"   "1"))
		(if $DxfClosePolyline 	   	(set_tile "OkClose"    "1") (set_tile "NoClose"    "1"))
		(if $DxfExplodeBlocks		(set_tile "OkExplode"  "1") (set_tile "NoExplode"  "1"))
		(if $DxfPurgePolyline		(set_tile "OkSimple"   "1") (set_tile "NoSimple"   "1"))
		(if $Overlapp				(set_tile "OkOverlapp" "1") (set_tile "NoOverlapp" "1"))
		
		(set_tile "OverlappAcuracyCenter"    	(LM:rtos $OverlappAcuracyCenter   	2 4))
		(set_tile "OverlappAcuracyRadius"	  	(LM:rtos $OverlappAcuracyRadius	   	2 4))
		(set_tile "OverlappAcuracyPoint" 	  	(LM:rtos $OverlappAcuracyPoint 	   	2 4))
		(set_tile "OverlappAcuracyCollinear"  	(LM:rtos $OverlappAcuracyCollinear 	2 4))
		(set_tile "OverlappAcuracyAngleArc"   	(LM:rtos $OverlappAcuracyAngleArc 	2 4))
		(set_tile "RemoveAmbiguosLength" 	  	(LM:rtos $RemoveAmbiguosLength 		2 4))
		(set_tile "MaxOpenPolyline" 		  	(LM:rtos $MaxOpenPolyline 			2 4))
		(set_tile "CenterCirclePolyline" 	  	(LM:rtos $CenterCirclePolyline 		2 4))
		(set_tile "DivideCsv" 	  				$DivideCsv)
		
		(if (not $Overlapp) (ChangeMode 1))

		(if $DxfClosePolyline (mode_tile "MaxOpenPolyline" 1))
	)
	;
	(defun LoadDefault ()
		(setq $OverlappAcuracyCenter 		0.10)
		(setq $OverlappAcuracyRadius 		0.10)
		(setq $OverlappAcuracyPoint 		0.10)
		(setq $OverlappAcuracyCollinear		0.01)
		(setq $OverlappAcuracyAngleArc		0.01)
		(setq $RemoveAmbiguosLength 		0.10)
		(setq $MaxOpenPolyline				0.20)
		(setq $CenterCirclePolyline 		0.05)
		(setq $DivideCsv 					(vl-registry-read "HKEY_CURRENT_USER\\Control Panel\\International" "sList"))
		(LoadSetupDxfImportDcl)
	)
	;
	(defun GetDataImportDxfDcl (/ OverlappAcuracyCenter OverlappAcuracyRadius OverlappAcuracyPoint OverlappAcuracyCollinear
								  OverlappAcuracyAngleArc RemoveAmbiguosLength MaxOpenPolyline CenterCirclePolyline DivideCsv Rtn)


		(if (= (get_tile "OkRemove"  ) "1") (setq $DxfRemoveSingleObject T) (setq $DxfRemoveSingleObject nil))
		(if (= (get_tile "OkClose"   ) "1") (setq $DxfClosePolyline      T) (setq $DxfClosePolyline      nil))
		(if (= (get_tile "OkExplode" ) "1") (setq $DxfExplodeBlocks      T) (setq $DxfExplodeBlocks      nil))
		(if (= (get_tile "OkSimple"  ) "1") (setq $DxfPurgePolyline      T) (setq $DxfPurgePolyline      nil))
		(if (= (get_tile "OkOverlapp") "1") (setq $Overlapp              T) (setq $Overlapp              nil))

		(setq OverlappAcuracyCenter		(get_tile "OverlappAcuracyCenter"))
		(setq OverlappAcuracyRadius		(get_tile "OverlappAcuracyRadius"))
		(setq OverlappAcuracyPoint		(get_tile "OverlappAcuracyPoint"))
		(setq OverlappAcuracyCollinear	(get_tile "OverlappAcuracyCollinear"))
		(setq OverlappAcuracyAngleArc	(get_tile "OverlappAcuracyAngleArc"))
		(setq RemoveAmbiguosLength		(get_tile "RemoveAmbiguosLength"))
		(setq MaxOpenPolyline			(get_tile "MaxOpenPolyline"))
		(setq CenterCirclePolyline		(get_tile "CenterCirclePolyline"))
		(setq DivideCsv					(get_tile "DivideCsv"))

		(setq Rtn (CkeckDataDcl (list OverlappAcuracyCenter OverlappAcuracyRadius OverlappAcuracyPoint OverlappAcuracyCollinear
									  OverlappAcuracyAngleArc RemoveAmbiguosLength MaxOpenPolyline CenterCirclePolyline DivideCsv)))
		
		(if Rtn
			(progn
				(setq $OverlappAcuracyCenter	(atof OverlappAcuracyCenter))
				(setq $OverlappAcuracyRadius	(atof OverlappAcuracyRadius))
				(setq $OverlappAcuracyPoint	 	(atof OverlappAcuracyPoint))
				(setq $OverlappAcuracyCollinear	(atof OverlappAcuracyCollinear))
				(setq $OverlappAcuracyAngleArc	(atof OverlappAcuracyAngleArc))
				(setq $RemoveAmbiguosLength		(atof RemoveAmbiguosLength))
				(setq $MaxOpenPolyline			(atof MaxOpenPolyline))
				(setq $CenterCirclePolyline		(atof CenterCirclePolyline))
				(setq $DivideCsv				DivideCsv)
				(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
			)
		)
		Rtn
	)
	;
	(defun ChangeMode (Flag)
		(mode_tile "OverlappAcuracyCenter"    Flag)               
		(mode_tile "OverlappAcuracyRadius"    Flag)        
		(mode_tile "OverlappAcuracyPoint"     Flag)       
		(mode_tile "OverlappAcuracyCollinear" Flag)            
		(mode_tile "OverlappAcuracyAngleArc"  Flag)       
		;(mode_tile "RemoveAmbiguosLength"     Flag)     
		;(mode_tile "MaxOpenPolyline"          Flag)   
		;(mode_tile "CenterCirclePolyline"     Flag)             
	)
	;
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq loop T)
	(while loop
		(new_dialog "setupdxfimport" xx "" (cond ( *setupdxfimport* ) ( '(-1 -1) )))
			(LoadSetupDxfImportDcl)
			(action_tile "OkOverlapp" "(ChangeMode 0)")
			(action_tile "NoOverlapp" "(ChangeMode 1)")
			(action_tile "OkClose"    "(mode_tile \"MaxOpenPolyline\"  1)")
			(action_tile "NoClose"    "(mode_tile \"MaxOpenPolyline\"  0)")

			(action_tile "accept" (strcat "(setq Rtn (GetDataImportDxfDcl))"
 			                              "(if Rtn"
										  "   (progn (setq *setupdxfimport* (done_dialog)) (unload_dialog xx))"
										  "   (alert \"Compilare i campi\"))"))
			(action_tile "cancel" "(setq loop nil) (setq *setupdxfimport* (done_dialog)) (unload_dialog xx)")
			
			(action_tile "loaddefault" "(LoadDefault)")
			
			
		(start_dialog)
		(if Rtn 
			(setq loop nil)
		)
	)

)
;
;
;
(defun LoadGuiTrigger (/ LoadSetupTriggerDcl GetDataTriggerDcl xx loop Rtn)

	(defun LoadSetupTriggerDcl ()
		(set_tile "MargineAccosto"    (LM:rtos $MargineAccosto 2 2))
		(set_tile "MargineLamieraDx"  (LM:rtos $MargineLamieraDx 2 2))
		(set_tile "MargineLamieraSx"  (LM:rtos $MargineLamieraSx 2 2))
		(set_tile "MargineLamieraTp"  (LM:rtos $MargineLamieraTp 2 2))
		(set_tile "MargineLamieraBt"  (LM:rtos $MargineLamieraBt 2 2))
		(set_tile "MargineLamiera"    (LM:rtos $MargineLamiera 2 2))
		(set_tile "MargineRifilo"     (LM:rtos $MargineRifilo 2 2))
		(set_tile "SpessoreLama"      (LM:rtos $SpessoreLama 2 2))
		(set_tile "LgSegEntra"		  (LM:rtos $LgSegEntra 2 2))
		(set_tile "LgSegEsci" 		  (LM:rtos $LgSegEsci 2 2))
		(set_tile "SvArcEntra" 		  (LM:rtos $SvArcEntra 2 2))
		(set_tile "SvArcEsci" 		  (LM:rtos $SvArcEsci 2 2))
		(set_tile "RaggioEntra" 	  (LM:rtos $RaggioEntra 2 2))
		(set_tile "RaggioEsci" 		  (LM:rtos $RaggioEsci 2 2))
		(set_tile "ColorEntra" 		  (LM:rtos $ColorEntra 2 2))
		(set_tile "ColorEsci" 		  (LM:rtos $ColorEsci 2 2))
	)
	(defun GetDataTriggerDcl (/ MargineAccosto MargineLamieraDx MargineLamieraSx MargineLamieraTp MargineLamieraBt MargineLamiera
								MargineRifilo SpessoreLama
								LgSegEntra gSegEsci SvArcEntra SvArcEsci RaggioEntra RaggioEsci ColorEntra ColorEsci Rtn)
		
		
		(setq MargineAccosto   (get_tile "MargineAccosto"))
		(setq MargineLamieraDx (get_tile "MargineLamieraDx"))
		(setq MargineLamieraSx (get_tile "MargineLamieraSx"))
		(setq MargineLamieraTp (get_tile "MargineLamieraTp"))
		(setq MargineLamieraBt (get_tile "MargineLamieraBt"))
		(setq MargineLamiera   (get_tile "MargineLamiera"))
		(setq MargineRifilo    (get_tile "MargineRifilo"))
		(setq SpessoreLama     (get_tile "SpessoreLama"))
		(setq LgSegEntra	   (get_tile "LgSegEntra"))
		(setq LgSegEsci		   (get_tile "LgSegEsci"))
		(setq SvArcEntra	   (get_tile "SvArcEntra"))
		(setq SvArcEsci		   (get_tile "SvArcEsci"))
		(setq RaggioEntra	   (get_tile "RaggioEntra"))
		(setq RaggioEsci	   (get_tile "RaggioEsci"))
		(setq ColorEntra	   (get_tile "ColorEntra"))
		(setq ColorEsci		   (get_tile "ColorEsci"))
		
		(setq Rtn (CkeckDataDcl (list MargineAccosto MargineLamieraDx MargineLamieraSx MargineLamieraTp MargineLamieraBt MargineLamiera 
									  MargineRifilo SpessoreLama
									  LgSegEntra LgSegEsci SvArcEntra SvArcEsci RaggioEntra RaggioEsci ColorEntra ColorEsci)))
									  
		(if Rtn		; distanze
			(progn
				(setq DCheck (max (* (* 2.0 (atof RaggioEntra)) (sin (/ (atof SvArcEntra) (* 2.0 (atof RaggioEntra)))))
					              (* (* 2.0 (atof RaggioEsci))  (sin (/ (atof SvArcEsci)  (* 2.0 (atof RaggioEsci)))))
					              (atof LgSegEntra) 
								  (atof LgSegEsci)
							 )
				)
				
				;(alert (rtos DCheck 2 2))
				
				(if (< (atof MargineAccosto)   DCheck)
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Margine accosto contorno < lunghezza attacco"					(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (< (atof MargineLamieraDx) DCheck)	
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Margine accosto borodo lamiera Dx < lunghezza attacco"			(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (< (atof MargineLamieraSx) DCheck)	
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Margine accosto borodo lamiera Sx < lunghezza attacco"			(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (< (atof MargineLamieraTp) DCheck)	
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Margine accosto borodo lamiera Sup < lunghezza attacco"			(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (< (atof MargineLamieraBt) DCheck)	
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Margine accosto borodo lamiera Inf < lunghezza attacco"			(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (< (atof MargineLamiera)   DCheck)	
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Margine accosto borodo lamiera irregolare < lunghezza attacco"	(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (< MargineRifilo 0)
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Margine rifilo sezionatrice < 0"	(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (< SpessoreLama 2.0)
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Spessore lama sezionatrice >= 2"	(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				;
				(if (< (atof MargineAccosto) 2.0)		
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Margine accosto contorno deve essere >= 2 mm "					(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (= (atof LgSegEntra)     0.0)		
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Lunghezza segmento attacco in entrata deve essere > 0 mm"		(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (= (atof LgSegEsci)      0.0)		
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Lunghezza segmento attacco in uscita deve essere > 0 mm"		(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (= (atof SvArcEntra)     0.0)		
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Lunghezza sviluppo attacco in entrata deve essere > 0 mm"		(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (= (atof SvArcEsci)      0.0)		
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Lunghezza sviluppo attacco in uscita deve essere > 0 mm"		(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (= (atof RaggioEntra)    0.0)		
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Lunghezza raggio attacco in entrata deve essere > 0 mm"			(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
				(if (= (atof RaggioEsci)     0.0)		
					(progn
						(LM:popup "Errore [GetDataTriggerDcl]" "Lunghezza raggio attacco in uscita deve essere > 0 mm"			(+ 0 16 4096))
						(setq Rtn nil)
					)
				)
			)
		)
									  
									  
		(if Rtn
			(progn
				(setq $MargineAccosto 	(atof MargineAccosto))
				(setq $MargineLamieraDx (atof MargineLamieraDx))
				(setq $MargineLamieraSx (atof MargineLamieraSx))
				(setq $MargineLamieraTp (atof MargineLamieraTp))
				(setq $MargineLamieraBt (atof MargineLamieraBt))
				(setq $MargineLamiera 	(atof MargineLamiera))
				(setq $MargineRifilo    (atof MargineRifilo))
				(setq $SpessoreLama 	(atof SpessoreLama))
				(setq $LgSegEntra	  	(atof LgSegEntra))
				(setq $LgSegEsci	  	(atof LgSegEsci))
				(setq $SvArcEntra	  	(atof SvArcEntra))
				(setq $SvArcEsci	  	(atof SvArcEsci))
				(setq $RaggioEntra	  	(atof RaggioEntra))
				(setq $RaggioEsci	  	(atof RaggioEsci))
				(setq $ColorEntra	  	(atoi ColorEntra))
				(setq $ColorEsci	  	(atoi ColorEsci))
				(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
			)
		)
		Rtn
	)
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq loop T)
	(while loop
		(new_dialog "setupattacchi" xx "" (cond ( *setupattacchi* ) ( '(-1 -1) )))
			(LoadSetupTriggerDcl)
			(action_tile "accept" (strcat "(setq Rtn (GetDataTriggerDcl))"
										  "(if Rtn"
										  "	  (progn (setq *setupattacchi* (done_dialog)) (unload_dialog xx))"
										  "   (alert \"Compilare i campi\"))"))
			(action_tile "cancel" "(setq loop nil) (setq *setupattacchi* (done_dialog)) (unload_dialog xx)")
		(start_dialog)
		
		(if Rtn 
			(setq loop nil)
		)
	)
)
;
;
;
(defun LoadGuiShape  ( / LoadSetupShapeDcl GetDataShapeDcl loop xx Rtn)

	(defun LoadSetupShapeDcl ()
		(set_tile "SpeedCut"				(LM:rtos $SpeedCut 2 0))
		(set_tile "ColorShapeOra"			(LM:rtos $ColorShapeOra 2 0))
		(set_tile "ColorShapeAntiOra"		(LM:rtos $ColorShapeAntiOra 2 0))
		(set_tile "ColorHoleOra"			(LM:rtos $ColorHoleOra 2 0))
		(set_tile "ColorHoleAntiOra"		(LM:rtos $ColorHoleAntiOra 2 0))
		(set_tile "ColorCircle"				(LM:rtos $ColorCircle 2 0))
		(set_tile "ColorEllipse"		  	(LM:rtos $ColorEllipse 2 0))
		(set_tile "ColorDetatch"		  	(LM:rtos $ColorDetatch 2 0))
		(set_tile "ArrowArcDivision"	  	(LM:rtos $ArrowArcDivision 2 2))
		(set_tile "AccuracyAngleRotation"	(LM:rtos $AccuracyAngleRotation 2 2))

	)
	(defun GetDataShapeDcl (/ CheckColor
							  SpeedCut ColorShapeOra ColorShapeAntiOra ColorHoleOra ColorHoleAntiOra ColorCircle ColorEllipse 
							  ColorDetatch ArrowArcDivision AccuracyAngleRotation Rtn1 Rtn2)

		(defun CheckColor (LstColor)
			(if LstColor
				(if (equal LstColor (LM:Unique LstColor))
					T
				)
			)
		)
	
		
		(setq SpeedCut				(get_tile "SpeedCut"))
		(setq ColorShapeOra			(get_tile "ColorShapeOra"))
		(setq ColorShapeAntiOra		(get_tile "ColorShapeAntiOra"))
		(setq ColorHoleOra			(get_tile "ColorHoleOra"))
		(setq ColorHoleAntiOra		(get_tile "ColorHoleAntiOra"))
		(setq ColorCircle			(get_tile "ColorCircle"))
		(setq ColorEllipse			(get_tile "ColorEllipse"))
		(setq ColorDetatch			(get_tile "ColorDetatch"))
		(setq ArrowArcDivision		(get_tile "ArrowArcDivision"))
		(setq AccuracyAngleRotation	(get_tile "AccuracyAngleRotation"))

		(setq Rtn1 (CkeckDataDcl (list SpeedCut ColorShapeOra ColorShapeAntiOra ColorHoleOra ColorHoleAntiOra ColorCircle ColorEllipse 
									   ColorDetatch
									   ArrowArcDivision AccuracyAngleRotation)))
		(setq Rtn2 (CheckColor (list ColorShapeOra ColorShapeAntiOra ColorHoleOra ColorHoleAntiOra ColorCircle ColorEllipse ColorDetatch)))
		
		(if (and Rtn1 Rtn2)
			(progn
				(setq $SpeedCut				 (atoi SpeedCut))
				(setq $ColorShapeOra		 (atoi ColorShapeOra))
				(setq $ColorShapeAntiOra	 (atoi ColorShapeAntiOra))
				(setq $ColorHoleOra			 (atoi ColorHoleOra))
				(setq $ColorHoleAntiOra		 (atoi ColorHoleAntiOra))
				(setq $ColorCircle			 (atoi ColorCircle))
				(setq $ColorEllipse			 (atoi ColorEllipse))
				(setq $ColorDetatch			 (atoi ColorDetatch))
				(setq $ArrowArcDivision		 (atof ArrowArcDivision))
				(setq $AccuracyAngleRotation (atof AccuracyAngleRotation))
				(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
				T
			)
			nil
		)
	)
	
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq loop T)
	(while loop
		(new_dialog "setupcontorni" xx "" (cond ( *setupcontorni* ) ( '(-1 -1) )))
			(LoadSetupShapeDcl)
			(action_tile "accept" (strcat "(setq Rtn (GetDataShapeDcl))"
 			                              "(if Rtn"
										  "   (progn (setq *setupcontorni* (done_dialog)) (unload_dialog xx))"
										  "   (alert \"Compilare i campi o differenziare i colori\"))"))
			(action_tile "cancel" "(setq loop nil) (setq *setupcontorni* (done_dialog)) (unload_dialog xx)")
		(start_dialog)
		(if Rtn 
			(setq loop nil)
		)
	)
)
;
;
;
(defun LoadGuiRegapp ( / LoadSetupRegappDcl GetDataRegappDcl loop xx Rtn)

	(defun LoadSetupRegappDcl ()
		(set_tile "RgpSheet"		$RgpSheet)
		(set_tile "RgpSheetTarget"	$RgpSheetTarget)
		(set_tile "RgpShape"		$RgpShape)
		(set_tile "RgpShapeTarget"	$RgpShapeTarget)
		(set_tile "RgpTiggerOn"		$RgpTiggerOn)
		(set_tile "RgpTiggeroff"	$RgpTiggeroff)
		;(set_tile "RgpRule"	        $RgpRule)
		(set_tile "RgpSymula"		$RgpSymula)
		;(set_tile "RgpBom"		    $RgpBom)
	)
	(defun GetDataRegappDcl (/ RgpSheet RgpSheetTarget RgpShape RgpShapeTarget RgpTiggerOn RgpTiggeroff RgpRule RgpSymula RgpBom Rtn)
		(setq RgpSheet		 (get_tile "RgpSheet"))
		(setq RgpSheetTarget (get_tile "RgpSheetTarget"))
		(setq RgpShape		 (get_tile "RgpShape"))
		(setq RgpShapeTarget (get_tile "RgpShapeTarget"))
		(setq RgpTiggerOn	 (get_tile "RgpTiggerOn"))
		(setq RgpTiggeroff	 (get_tile "RgpTiggeroff"))
		;(setq RgpRule	     (get_tile "RgpRule"))
		(setq RgpSymula		 (get_tile "RgpSymula"))
		;(setq RgpBom		 (get_tile "RgpBom"))
		(setq Rtn (CkeckDataDcl (list RgpSheet RgpSheetTarget RgpShape RgpShapeTarget RgpTiggerOn RgpTiggeroff RgpSymula)))
		(if Rtn
			(progn
				(setq $RgpSheet			RgpSheet)
				(setq $RgpSheetTarget	RgpSheetTarget)
				(setq $RgpShape			RgpShape)
				(setq $RgpShapeTarget	RgpShapeTarget)
				(setq $RgpTiggerOn		RgpTiggerOn)
				(setq $RgpTiggeroff		RgpTiggeroff)
				;(setq $RgpRule		    RgpRule)
				(setq $RgpSymula		RgpSymula)
				;(setq $RgpBom		    RgpBom)
				(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
			)
		)
		Rtn
	)
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq loop T)
	(while loop
		(new_dialog "setupragg" xx "" (cond ( *setupragg* ) ( '(-1 -1) )))
			(LoadSetupRegappDcl)
			(action_tile "accept" (strcat "(setq Rtn (GetDataRegappDcl))"
										  "(if Rtn"
										  "	  (progn (setq *setupragg* (done_dialog)) (unload_dialog xx))"
										  "   (alert \"Compilare i campi\"))"))
			(action_tile "cancel" "(setq loop nil) (setq *setupragg* (done_dialog)) (unload_dialog xx)")
		(start_dialog)
		(if Rtn 
			(setq loop nil)
		)
	)
)
;
;
;
(defun LoadGuiSymula ( / MinTime MaxTime LoadSetupSymulaDcl GetDataSymulaDcl loop xx Rtn)

	(defun LoadSetupSymulaDcl (MinTime MaxTime)
		(set_tile "Sequence"		(LM:rtos (- $Sequence 1) 2 0))
		(set_tile "ColorSymula"		(LM:rtos $ColorSymula 2 0))
		(set_tile "TypSymula"		(LM:rtos (- $TypSymula 1) 2 0))
		;(setq MinTime 1)
		;(setq MaxTime 5000)
		(if (and (>= $TimeSymula MinTime) (<= $TimeSymula MaxTime))
			(set_tile "TimeSymula"		(LM:rtos (- MaxTime $TimeSymula) 2 0))
			(progn
				(setq $TimeSymula 1000)
				(set_tile "TimeSymula"	(LM:rtos (- MaxTime $TimeSymula) 2 0))
			)
		)

	)
	(defun GetDataSymulaDcl (MinTime MaxTime / Sequence ColorSymula TypSymula TimeSymula Rtn)
		(setq Sequence	    (get_tile "Sequence"))
		(setq ColorSymula	(get_tile "ColorSymula"))
		(setq TypSymula		(get_tile "TypSymula"))
		(setq TimeSymula	(get_tile "TimeSymula"))
		(setq Rtn (CkeckDataDcl (list Sequence ColorSymula TypSymula TimeSymula)))
		(if Rtn
			(progn
				(setq $Sequence	    (1+ (atoi Sequence)))
				(setq $ColorSymula	(atoi ColorSymula))
				(setq $TypSymula	(1+ (atoi TypSymula)))
				(setq $TimeSymula	(- MaxTime (atoi TimeSymula)))
				(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
			)
		)
		Rtn
	)
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq loop T)
	(while loop
		(new_dialog "setupsymula" xx "" (cond ( *setupsymula* ) ( '(-1 -1) )))
			(LoadSetupSymulaDcl 1 5000)
			(action_tile "accept" (strcat "(setq Rtn (GetDataSymulaDcl 1 5000))"
										  "(if Rtn"
										  "   (progn (setq *setupsymula* (done_dialog)) (unload_dialog xx))"
										  "   (alert \"Compilare i campi\"))"))
			(action_tile "cancel" "(setq loop nil) (setq *setupsymula* (done_dialog)) (unload_dialog xx)")
		(start_dialog)
		(if Rtn 
			(setq loop nil)
		)
	)
)
;
;
;
(defun LoadGuiFlex (/ LoadSetupFlexDcl GetDataFlexDcl xx Rtn)

	(defun LoadSetupFlexDcl ()
		(set_tile "Flex"					(LM:rtos $Flex 2 2))
		(set_tile "FlexHoleDiamExcludeFrom"	(LM:rtos $FlexHoleDiamExcludeFrom 2 1))
		(set_tile "FlexHoleDiamExcludeTo"	(LM:rtos $FlexHoleDiamExcludeTo 2 1))
	)

	(defun GetDataFlexDcl (/ Flex FlexHoleDiamExcludeFrom FlexHoleDiamExcludeTo Rtn)
		(setq Flex	    				(get_tile "Flex"))
		(setq FlexHoleDiamExcludeFrom	(get_tile "FlexHoleDiamExcludeFrom"))
		(setq FlexHoleDiamExcludeTo		(get_tile "FlexHoleDiamExcludeTo"))
		(if (CkeckDataDcl (list Flex FlexHoleDiamExcludeFrom FlexHoleDiamExcludeTo))
			(if (and (numberp (read Flex))
					 (numberp (read FlexHoleDiamExcludeFrom))
					 (numberp (read FlexHoleDiamExcludeTo))
				)
				(if (<= (atof FlexHoleDiamExcludeFrom) (atof FlexHoleDiamExcludeTo))
					(progn
						(setq $Flex	    				(atof Flex))
						(setq $FlexHoleDiamExcludeFrom	(atof FlexHoleDiamExcludeFrom))
						(setq $FlexHoleDiamExcludeTo	(atof FlexHoleDiamExcludeTo))
						
						;(alert (strcat "Flex " 				   (LM:rtos Flex 2 2)))
						;(alert (strcat "FlexHoleDiamExcludeFrom " (LM:rtos FlexHoleDiamExcludeFrom 2 2)))
						;(alert (strcat "FlexHoleDiamExcludeTo"    (LM:rtos FlexHoleDiamExcludeTo 2 2)))

						(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
						(setq Rtn T)
					)
				)
			)
		)
		Rtn
	)
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq loop T)
	(while loop
		(new_dialog "setupflex" xx "" (cond ( *setupflex* ) ( '(-1 -1) )))
			(LoadSetupFlexDcl)
			(action_tile "accept" (strcat "(setq Rtn (GetDataFlexDcl))"
										  "(if Rtn"
										  "   (progn (setq *setupflex* (done_dialog)) (unload_dialog xx))"
										  "   (alert \"Dati non validi\"))"))
			(action_tile "cancel" "(setq loop nil) (setq *setupflex* (done_dialog)) (unload_dialog xx)")
		(start_dialog)
		(if Rtn (setq loop nil))
	)
)
;
;
;
(defun LoadGuiMicro (/ LoadSetupMicroDcl GetDataMicroDcl xx Rtn)

	(defun LoadSetupMicroDcl ()
		(set_tile "LgMicro"			(LM:rtos $LgMicro 2 3))
		(set_tile "WdMicro"			(LM:rtos $WdMicro 2 3))
		(set_tile "WdMicroAtPoint"	(LM:rtos $WdMicroAtPoint 2 3))
	)

	(defun GetDataMicroDcl (/ LgMicro WdMicro WdMicroAtPoint Rtn)
		(setq LgMicro	    	(get_tile "LgMicro"))
		(setq WdMicro			(get_tile "WdMicro"))
		(setq WdMicroAtPoint	(get_tile "WdMicroAtPoint"))
		(if (CkeckDataDcl (list LgMicro WdMicro WdMicroAtPoint))
			(if (and (numberp (read LgMicro)) (numberp (read WdMicro)) (numberp (read WdMicroAtPoint)))
				(progn
					(setq $LgMicro	    	(atof LgMicro))
					(setq $WdMicro			(atof WdMicro))
					(setq $WdMicroAtPoint	(atof WdMicroAtPoint))
					(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
					(setq Rtn T)
				)
			)
		)
		Rtn
	)
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq loop T)
	(while loop
		(new_dialog "setupmicro" xx "" (cond ( *setupmicro* ) ( '(-1 -1) )))
			(LoadSetupMicroDcl)
			
			(mode_tile "LgMicro" 		0)
			(mode_tile "WdMicro" 		1)
			(mode_tile "WdMicroAtPoint" 1)
			
			(action_tile "accept" (strcat "(setq Rtn (GetDataMicroDcl))"
										  "(if Rtn"
										  "   (progn (setq *setupmicro* (done_dialog)) (unload_dialog xx))"
										  "   (alert \"Dati non validi\"))"))
			(action_tile "cancel" "(setq loop nil) (setq *setupmicro* (done_dialog)) (unload_dialog xx)")
		(start_dialog)
		(if Rtn (setq loop nil))
	)
)
;
;
;
(defun LoadGuiNestingBar (/ LoadSetupNestingBarDcl GetDataNestingBarDcl xx Rtn)

	(defun LoadSetupNestingBarDcl ()
		(set_tile "TkCutBar"			(LM:rtos $TkCutBar 2 3))
		(set_tile "BarMargStart"		(LM:rtos $BarMargStart 2 3))
		(set_tile "BarMargEnd"			(LM:rtos $BarMargEnd 2 3))
	)

	(defun GetDataNestingBarDcl (/ TkCutBar BarMargStart BarMargEnd Rtn)
		(setq TkCutBar	    (get_tile "TkCutBar"))
		(setq BarMargStart	(get_tile "BarMargStart"))
		(setq BarMargEnd	(get_tile "BarMargEnd"))
		(if (CkeckDataDcl (list TkCutBar BarMargStart BarMargEnd))
			(if (and (numberp (read TkCutBar)) (numberp (read BarMargStart)) (numberp (read BarMargEnd)))
				(progn
					(setq $TkCutBar	    (atof TkCutBar))
					(setq $BarMargStart	(atof BarMargStart))
					(setq $BarMargEnd	(atof BarMargEnd))
					(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
					(setq Rtn T)
				)
			)
		)
		Rtn
	)
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq loop T)
	(while loop
		(new_dialog "setupnestingbar" xx "" (cond ( *setupnestingbar* ) ( '(-1 -1) )))
			(LoadSetupNestingBarDcl)
			
			(mode_tile "TkCutBar" 		0)
			(mode_tile "BarMargStart" 	0)
			(mode_tile "BarMargEnd" 	0)
			
			(action_tile "accept" (strcat "(setq Rtn (GetDataNestingBarDcl))"
										  "(if Rtn"
										  "   (progn (setq *setupnestingbar* (done_dialog)) (unload_dialog xx))"
										  "   (alert \"Dati non validi\"))"))
			(action_tile "cancel" "(setq loop nil) (setq *setupnestingbar* (done_dialog)) (unload_dialog xx)")
		(start_dialog)
		(if Rtn (setq loop nil))
	)
)
;
;
;
(defun LoadGuiFolders&Files ( / LoadSetupFolders&FilesDcl GetDataFolders&FilesDcl loop xx Rtn)

	(defun LoadSetupFolders&FilesDcl ()
		(set_tile "InfoPathEasyCut"	     InfoPathEasyCut$)
		(set_tile "CutPathEasyCut"	     CutPathEasyCut$)
		(set_tile "BinPathEasyCut"	     BinPathEasyCut$)
		(set_tile "GuiPathEasyCut"	     GuiPathEasyCut$)
		(set_tile "FontPathEasyCut"	     FontPathEasyCut$)
		(set_tile "LibPathEasyCut"	     LibPathEasyCut$)
		
		(set_tile "ExpertNestingEasyCut"   ExpertNestingEasyCut$)
		(set_tile "RectPackNestingEasyCut" RectPackNestingEasyCut$)
		(set_tile "CncPathEasyCut"       CncPathEasyCut$)
		(set_tile "DbaseEasyCut"         DbaseEasyCut$)
		(set_tile "LoadEasyCut"          LoadEasyCut$)
		(set_tile "HtmlStorageEasyCut"	 HtmlStorageEasyCut$)
		(set_tile "DxfNestingEasyCut"	 DxfNestingEasyCut$)
		(set_tile "NameBlockSheet"	     NameBlockSheet$)
		(set_tile "NameBlockShape"	     NameBlockShape$)
		(set_tile "NameBlockShapeTmp"	 NameBlockShapeTmp$)


		(set_tile "ECFileSetupExpertNesting"   ECFileSetupExpertNesting$)
		(set_tile "ECFileSetupRectPackNesting" ECFileSetupRectPackNesting$)
		(set_tile "ECFileExeExpertNesting"     ECFileExeExpertNesting$)
		(set_tile "ECFileExeRectPackNesting"   ECFileExeRectPackNesting$)
		(set_tile "ECFileViewer"   			   ECFileViewer$)
		
		(set_tile "FileBlockSheet"	     FileBlockSheet$)
		(set_tile "FileBlockShape"	     FileBlockShape$)
		(set_tile "FileBlockShapeTmp"	 FileBlockShapeTmp$)
		(set_tile "FileBlockLogo"	     FileBlockLogo$)
		
		(set_tile "SetupPathEasyCut"	 SetupPathEasyCut$)
		(set_tile "SetupFileEasyCut"	 SetupFileEasyCut$)
		
	)
	(defun GetDataFolders&FilesDcl (/ InfoPathEasyCut CutPathEasyCut BinPathEasyCut GuiPathEasyCut FontPathEasyCut LibPathEasyCut
									  HtmlStorageEasyCut NestPorfessorEasyCut DbaseEasyCut LoadEasyCut CncPathEasyCut
									  NameBlockSheet NameBlockShape NameBlockShapeTmp FileBlockSheet FileBlockShape FileBlockShapeTmp FileBlockLogo DxfNestingEasyCut 
									  SetupPathEasyCut SetupFileEasyCut ECFileSetupExpertNesting ECFileSetupRectPackNesting 
									  ECFileExeExpertNesting ECFileExeRectPackNesting ECFileViewer Rtn)
	
		(setq InfoPathEasyCut      (get_tile "InfoPathEasyCut"))
		(setq CutPathEasyCut       (get_tile "CutPathEasyCut"))
		(setq BinPathEasyCut       (get_tile "BinPathEasyCut"))
		(setq GuiPathEasyCut       (get_tile "GuiPathEasyCut"))
		(setq FontPathEasyCut      (get_tile "FontPathEasyCut"))
		(setq LibPathEasyCut       (get_tile "LibPathEasyCut"))

		(setq ExpertNestingEasyCut   (get_tile "ExpertNestingEasyCut"))
		(setq RectPackNestingEasyCut (get_tile "RectPackNestingEasyCut"))
		(setq DbaseEasyCut         (get_tile "DbaseEasyCut"))
		(setq LoadEasyCut          (get_tile "LoadEasyCut"))
		(setq CncPathEasyCut       (get_tile "CncPathEasyCut"))

		(setq HtmlStorageEasyCut   (get_tile "HtmlStorageEasyCut"))
		(setq DxfNestingEasyCut    (get_tile "DxfNestingEasyCut")) 
		(setq NameBlockSheet       (get_tile "NameBlockSheet"))
		(setq NameBlockShape       (get_tile "NameBlockShape"))
		(setq NameBlockShapeTmp    (get_tile "NameBlockShapeTmp"))
		(setq FileBlockSheet       (get_tile "FileBlockSheet"))
		(setq FileBlockShape       (get_tile "FileBlockShape"))
		(setq FileBlockShapeTmp    (get_tile "FileBlockShapeTmp"))
		(setq FileBlockLogo        (get_tile "FileBlockLogo"))

		(setq ECFileSetupExpertNesting 	 (get_tile "ECFileSetupExpertNesting"))
		(setq ECFileSetupRectPackNesting (get_tile "ECFileSetupRectPackNesting"))
		(setq ECFileExeExpertNesting   	 (get_tile "ECFileExeExpertNesting"))
		(setq ECFileExeRectPackNesting   (get_tile "ECFileExeRectPackNesting"))
		(setq ECFileViewer  			 (get_tile "ECFileViewer"))
		
		(setq SetupPathEasyCut     (get_tile "SetupPathEasyCut"))
		(setq SetupFileEasyCut     (get_tile "SetupFileEasyCut"))
		
		
		
		(setq Rtn (CkeckDataDcl (list InfoPathEasyCut CutPathEasyCut BinPathEasyCut GuiPathEasyCut FontPathEasyCut LibPathEasyCut
									  ExpertNestingEasyCut RectPackNestingEasyCut
									  DbaseEasyCut LoadEasyCut HtmlStorageEasyCut CncPathEasyCut
		                              NameBlockSheet NameBlockShape NameBlockShapeTmp FileBlockSheet FileBlockShape FileBlockShapeTmp FileBlockLogo DxfNestingEasyCut
									  SetupPathEasyCut SetupFileEasyCut ECFileSetupExpertNesting ECFileExeExpertNesting ECFileExeRectPackNesting ECFileViewer)))
		(if Rtn
			(progn
				(setq InfoPathEasyCut$       InfoPathEasyCut)
				(setq CutPathEasyCut$        CutPathEasyCut)
				(setq BinPathEasyCut$        BinPathEasyCut)
				(setq GuiPathEasyCut$        GuiPathEasyCut)
				(setq FontPathEasyCut$       FontPathEasyCut)
				(setq LibPathEasyCut$        LibPathEasyCut)
				(setq ExpertNestingEasyCut$    ExpertNestingEasyCut)
				(setq RectPackNestingEasyCut$  RectPackNestingEasyCut)
				(setq DbaseEasyCut$          DbaseEasyCut)
				(setq LoadEasyCut$           LoadEasyCut)
				(setq CncPathEasyCut$        CncPathEasyCut)
				(setq HtmlStorageEasyCut$    HtmlStorageEasyCut)
				(setq DxfNestingEasyCut$     DxfNestingEasyCut)
				(setq NameBlockSheet$        NameBlockSheet)
				(setq NameBlockShape$        NameBlockShape)
				(setq NameBlockShapeTmp$     NameBlockShapeTmp)
				(setq FileBlockSheet$        FileBlockSheet)
				(setq FileBlockShape$        FileBlockShape)
				(setq FileBlockShapeTmp$     FileBlockShapeTmp)
				(setq FileBlockLogo$         FileBlockLogo)
				
				(setq SetupPathEasyCut$      SetupPathEasyCut)
				(setq SetupFileEasyCut$      SetupFileEasyCut)

				(setq ECFileSetupExpertNesting$   ECFileSetupExpertNesting)
				(setq ECFileSetupRectPackNesting$ ECFileSetupRectPackNesting)
				
				(setq ECFileExeExpertNesting$   ECFileExeExpertNesting)
				(setq ECFileExeRectPackNesting$ ECFileExeRectPackNesting)
				(setq ECFileViewer$ 			ECFileViewer)
				
				(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut) "\nconfigurazione salvata        -> ")
			)
		)
		Rtn
	)

	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq loop T)
	(while loop
		(new_dialog "setuparchivio" xx "" (cond ( *setuparchivio* ) ( '(-1 -1) )))
		(LoadSetupFolders&FilesDcl)
		
		(mode_tile "BinPathEasyCut"    1)
		(mode_tile "GuiPathEasyCut"    1)
		(mode_tile "FontPathEasyCut"   1)
		(mode_tile "LibPathEasyCut"    1)
		(mode_tile "ExpertNestingEasyCut" 1)
		(mode_tile "RectPackNestingEasyCut" 1)
		(mode_tile "DbaseEasyCut"      1)
		(mode_tile "LoadEasyCut"       1)
		(mode_tile "CncPathEasyCut"    1)
		(mode_tile "NameBlockSheet"    1)
		(mode_tile "NameBlockShape"    1)
		(mode_tile "NameBlockShapeTmp" 1)
		(mode_tile "FileBlockSheet"    1)
		(mode_tile "FileBlockShape"    1)
		(mode_tile "FileBlockShapeTmp" 1)
		(mode_tile "FileBlockLogo"     1)

		(mode_tile "ECFileSetupExpertNesting"  	1)
		(mode_tile "ECFileSetupRectPackNesting" 1)
		(mode_tile "ECFileExeExpertNesting"    	1)
		(mode_tile "ECFileExeRectPackNesting"  	1)
		(mode_tile "ECFileViewer"  				0)

		
		(mode_tile "SetupPathEasyCut" 1)
		(mode_tile "SetupFileEasyCut" 1)
		(action_tile "accept" (strcat "(setq Rtn (GetDataFolders&FilesDcl))"
									  "(if Rtn"
									  "   (progn (setq *setuparchivio* (done_dialog)) (unload_dialog xx))"
									  "   (alert \"Compilare i campi\"))"))
		(action_tile "cancel" "(setq loop nil) (setq *setuparchivio* (done_dialog)) (unload_dialog xx)")
		(start_dialog)
		(if Rtn 
			(setq loop nil)
		)
	)
)
;
;
;
(defun LoadGuiFilter ( / LoadSetupFilterDcl GetDataFilterDcl loop xx Rtn)

	(defun LoadSetupFilterDcl ( / Stream FileName FilterList TriggerList)
	
		(setq FileName (vl-filename-mktemp))
		(setq Stream (open FileName "w"))
		(prin1 $FilterList Stream)  (princ "\n" Stream)
		(prin1 $TriggerList Stream) (princ "\n" Stream)
		(close Stream)
		(setq Stream (open FileName "r"))
		(setq FilterList (read-line Stream))
		(setq TriggerList (read-line Stream))
		(close Stream)
	
		(set_tile "FilterList"	FilterList)
		(set_tile "TriggerList"	TriggerList)
		
		(mode_tile "FilterList"	 1)
		(mode_tile "TriggerList" 1)
		
	)
	(defun GetDataFilterDcl (/ FilterList TriggerList Rtn)
		(setq FilterList  (get_tile "FilterList"))
		(setq TriggerList (get_tile "TriggerList"))
		(setq Rtn (CkeckDataDcl (list FilterList TriggerList)))
		(if Rtn
			(progn
				(setq $FilterList (read FilterList))
				(setq $TriggerList (read TriggerList))
				(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
			)
		)
		Rtn
	)

	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq loop T)
	(while loop
		(new_dialog "setupfiltri" xx "" (cond ( *setupfiltri* ) ( '(-1 -1) )))
			(LoadSetupFilterDcl)
			(action_tile "accept" (strcat "(setq Rtn (GetDataFilterDcl))"
										  "(if Rtn"
										  "   (progn (setq *setupfiltri* (done_dialog)) (unload_dialog xx))"
										  "   (alert \"Compilare i campi\"))"))
			(action_tile "cancel" "(setq loop nil) (setq *setupfiltri* (done_dialog)) (unload_dialog xx)")
		(start_dialog)
		(if Rtn 
			(setq loop nil)
		)
	)
)
;
;
;
(defun GuiPlotHtml (/ UpdateSheetName Doc LstPlotDeviceName LstSheetName LstStyleName xx)

	;
	;
	;
	(defun UpdateSheetName (Doc NamePlotDevice / LstSheetName)
		(if (and Doc NamePlotDevice)
			(progn
				(setq LstSheetName (GetCanonicalMediaNamesOfConfigname Doc NamePlotDevice (list "UserDefinedRaster")))
				(start_list "box_info2")	
				(mapcar 'add_list LstSheetName)
				(end_list)
			)
		)
		LstSheetName
	)
	;
	;
	;
	;key="PlotterName"
	;key="SheetName"
	;key="Stylename"
	
	(setq Doc (vla-get-activedocument (vlax-get-acad-object)))
	(setq LstPlotDeviceName (GetPlotDevices Doc (list "png" "jpg")))
	(setq LstSheetName		(GetCanonicalMediaNamesOfConfigname Doc $HtmlPlotterEasyCut (list "UserDefinedRaster")))
	(setq LstStyleName 		(GetPlotStyleTableNames Doc (list "ctb")))
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	
		(new_dialog "setuplayout" xx "" (cond ( *setuplayout* ) ( '(-1 -1) )))
		
			(start_list "box_info1")	
			(mapcar 'add_list LstPlotDeviceName)
			(end_list)
			(start_list "box_info2")	
			(mapcar 'add_list LstSheetName)
			(end_list)
			(start_list "box_info3")	
			(mapcar 'add_list LstStyleName)
			(end_list)
				
			(set_tile "PlotDeviceName" $HtmlPlotterEasyCut)
			(set_tile "SheetName"      $HtmlPaperSizeEasyCut)
			(set_tile "StyleName"      $HtmlCtbEasyCut)

				;(mode_tile   "box_info1" 2)
				
			(action_tile "box_info1" 	(strcat "(set_tile \"PlotDeviceName\" 	(setq SelectedPloter (nth (atoi $value) LstPlotDeviceName)))"
												"(setq LstSheetName 			(UpdateSheetName Doc SelectedPloter))"
												"(set_tile \"SheetName\" 	   	(setq SelectedShape  (nth 0 LstSheetName)))"
										)
			)
			
			;(action_tile "box_info2" "(princ (type (get_tile \"box_info2\"))) (terpri)")
			(action_tile "box_info2" "(set_tile \"SheetName\" (setq SelectedShape  (nth (atoi $value) LstSheetName)))")
			
			(action_tile "box_info3" "(set_tile \"StyleName\" (setq SelectedStyle  (nth (atoi $value) LstStyleName)))")

			(action_tile "accept"   (strcat "(setq $HtmlPlotterEasyCut	 (get_tile \"PlotDeviceName\"))"
											"(setq $HtmlPaperSizeEasyCut (get_tile \"SheetName\"))"
											"(setq $HtmlCtbEasyCut  	 (get_tile \"StyleName\"))"
											"(setq *setuplayout* (done_dialog)) (unload_dialog xx)"))
											
			(action_tile "cancel"   (strcat "(setq Loop nil selected nil)"
											"(setq *setuplayout* (done_dialog)) (unload_dialog xx)"))
				
		(start_dialog)
		
		(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
)
;
;
;
(defun LoadGuiHtml ( / LoadSetupTextDcl GetDataTextDcl loop xx Rtn)

	(defun LoadSetupTextDcl ()

	
		(set_tile "HtmlPlotterEasyCut" 			$HtmlPlotterEasyCut)
		(set_tile "HtmlPaperSizeEasyCut"      	$HtmlPaperSizeEasyCut)
		(set_tile "HtmlCtbEasyCut"      		$HtmlCtbEasyCut)

		(set_tile "HtmlScriptEasyCut"			HtmlScriptEasyCut$)
		
		(set_tile "ECFolderSheet"				ECFolderSheet$)
		(set_tile "ECFolderShape"				ECFolderShape$)
		(set_tile "ECFolderShapePreview"		ECFolderShapePreview$)
		(set_tile "ECFolderReport"				ECFolderReport$)
		(set_tile "ECFileSheet"					ECFileSheet$)
		(set_tile "ECFileShape"					ECFileShape$)
		(set_tile "ECFileReport"				ECFileReport$)	
		(set_tile "ECFileTree"					ECFileTree$)	

		(mode_tile "HtmlPlotterEasyCut" 1)
		(mode_tile "HtmlPaperSizeEasyCut" 1)
		(mode_tile "HtmlCtbEasyCut" 1)
		(mode_tile "ECFolderSheet" 1)
		(mode_tile "ECFolderShape" 1)
		(mode_tile "ECFolderShapePreview" 1)
		(mode_tile "ECFolderReport" 1)
		(mode_tile "ECFileSheet" 1)
		(mode_tile "ECFileShape" 1)
		(mode_tile "ECFileReport" 1)
		(mode_tile "ECFileTree"	1)

	)
	(defun GetDataTextDcl (/ HtmlPlotterEasyCut HtmlPaperSizeEasyCut HtmlCtbEasyCut
							 ECFolderSheet ECFolderShape ECFolderShapePreview ECFolderReport ECFileSheet 
							 ECFileShape ECFileReport ECFileTree HtmlScriptEasyCut Rtn)
							 
		(setq HtmlPlotterEasyCut 		(get_tile "HtmlPlotterEasyCut"))
		(setq HtmlPaperSizeEasyCut 		(get_tile "HtmlPaperSizeEasyCut"))
		(setq HtmlCtbEasyCut 			(get_tile "HtmlCtbEasyCut"))
		
		(setq HtmlScriptEasyCut			(get_tile "HtmlScriptEasyCut"))
		
		(setq ECFolderSheet				(get_tile "ECFolderSheet"))
		(setq ECFolderShape				(get_tile "ECFolderShape"))
		(setq ECFolderShapePreview		(get_tile "ECFolderShapePreview"))
		(setq ECFolderReport			(get_tile "ECFolderReport"))
		(setq ECFileSheet				(get_tile "ECFileSheet"))
		(setq ECFileShape				(get_tile "ECFileShape"))
		(setq ECFileReport				(get_tile "ECFileReport"))	
		(setq ECFileTree				(get_tile "ECFileTree"))
		
		(setq Rtn (CkeckDataDcl (list HtmlPlotterEasyCut HtmlPaperSizeEasyCut HtmlCtbEasyCut
									  ECFolderSheet ECFolderShape ECFolderReport ECFileSheet 
									  ECFileShape ECFileReport ECFileTree ECFolderShapePreview
									  HtmlScriptEasyCut)))
		(if Rtn
			(progn
				(setq $HtmlPlotterEasyCut 		HtmlPlotterEasyCut)
				(setq $HtmlPaperSizeEasyCut 	HtmlPaperSizeEasyCut)
				(setq $HtmlCtbEasyCut 			HtmlCtbEasyCut)

				(setq HtmlScriptEasyCut$		HtmlScriptEasyCut)
				
				(setq ECFolderSheet$			ECFolderSheet)
				(setq ECFolderShape$			ECFolderShape)
				(setq ECFolderShapePreview$		ECFolderShapePreview)
				(setq ECFolderReport$			ECFolderReport)
				(setq ECFileSheet$				ECFileSheet)
				(setq ECFileShape$				ECFileShape)
				(setq ECFileReport$				ECFileReport)	
				(setq ECFileTree$				ECFileTree)
							
				(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
			)
		)
		Rtn
	)

	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq loop T)
	(while loop
		(new_dialog "setuphtlm" xx "" (cond ( *setuphtlm* ) ( '(-1 -1) )))
			(LoadSetupTextDcl)
			(action_tile "accept" (strcat "(setq Rtn (GetDataTextDcl))"
										  "(if Rtn"
										  "   (progn (setq *setuphtlm* (done_dialog)) (unload_dialog xx))"
										  "   (alert \"Compilare i campi\"))"))
			(action_tile "cancel" "(setq loop nil) (setq *setuphtlm* (done_dialog)) (unload_dialog xx)")
		(start_dialog)
		(if Rtn 
			(setq loop nil)
		)
	)
)
;
;
;
(defun LoadGuiText ( / LoadSetupTextDcl GetDataTextDcl loop xx Rtn)

	(defun LoadSetupTextDcl ()
	
		(mode_tile "StyleEasyCutBarCode"	 1)
		(set_tile "StyleEasyCut"				$StyleEasyCut)
		(set_tile "StyleEasyCutBarCode"			$StyleEasyCutBarCode)
		(set_tile "HTextEasyCut"				(LM:rtos $HTextEasyCut 2 0))
		(set_tile "LayerDinamicInfoEasyCut"		$LayerDinamicInfoEasyCut)
		(set_tile "HTextDinamicInfoEasyCut"		(LM:rtos $HTextDinamicInfoEasyCut 2 0))
		;(set_tile "AperturaDinamicInfoEasyCut"	(LM:rtos $AperturaDinamicInfoEasyCut 2 0))
		;(set_tile "FontBarCodeEasyCut"			$FontBarCodeEasyCut)
		(set_tile "FontDefaultEasyCut"			$FontDefaultEasyCut)

	)
	(defun GetDataTextDcl (/ StyleEasyCut StyleEasyCutBarCode HTextEasyCut HTextDinamicInfoEasyCut 
							 LayerDinamicInfoEasyCut FontDefaultEasyCut Rtn)
							 
		(setq StyleEasyCut 					(get_tile "StyleEasyCut"))
		(setq StyleEasyCutBarCode			(get_tile "StyleEasyCutBarCode"))
		(setq HTextEasyCut 					(get_tile "HTextEasyCut"))
		(setq LayerDinamicInfoEasyCut 		(get_tile "LayerDinamicInfoEasyCut"))
		(setq HTextDinamicInfoEasyCut 		(get_tile "HTextDinamicInfoEasyCut"))
		;(setq AperturaDinamicInfoEasyCut 	(get_tile "AperturaDinamicInfoEasyCut"))
		;(setq FontBarCodeEasyCut 			(get_tile "FontBarCodeEasyCut"))
		(setq FontDefaultEasyCut 			(get_tile "FontDefaultEasyCut"))
		
		(setq Rtn (CkeckDataDcl (list StyleEasyCut StyleEasyCutBarCode HTextEasyCut 
		                              HTextDinamicInfoEasyCut FontDefaultEasyCut)))
		(if Rtn
			(progn
				(setq $StyleEasyCut 					StyleEasyCut)
				(setq $StyleEasyCutBarCode 				StyleEasyCutBarCode)
				(setq $HTextEasyCut 					(atoi HTextEasyCut))
				(setq $LayerDinamicInfoEasyCut 			LayerDinamicInfoEasyCut)
				(setq $HTextDinamicInfoEasyCut 			(atoi HTextDinamicInfoEasyCut))
				;(setq $AperturaDinamicInfoEasyCut	 	(atoi AperturaDinamicInfoEasyCut))
				;(setq $FontBarCodeEasyCut	 			FontBarCodeEasyCut)
				(setq $FontDefaultEasyCut	 			FontDefaultEasyCut)
				
				(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
			)
		)
		Rtn
	)

	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(setq loop T)
	(while loop
		(new_dialog "setuptesto" xx "" (cond ( *setuptesto* ) ( '(-1 -1) )))
			(LoadSetupTextDcl)
			(action_tile "accept" (strcat "(setq Rtn (GetDataTextDcl))"
										  "(if Rtn"
										  "   (progn (setq *setuptesto* (done_dialog)) (unload_dialog xx))"
										  "   (alert \"Compilare i campi\"))"))
			(action_tile "cancel" "(setq loop nil) (setq *setuptesto* (done_dialog)) (unload_dialog xx)")
		(start_dialog)
		(if Rtn 
			(setq loop nil)
		)
	)
)
;
;
;
(defun LoadGuiSpeed ( / LoadSetupSpeedDcl GetDataSpeedDcl IncludeExclude xx Rtn)

	(defun LoadSetupSpeedDcl (/ itm conta modet)
	
		(setq conta 1)
		(foreach itm $SpeedCutArray
			(set_tile 	(strcat "tk" 		  	(LM:rtos conta 2 0))	(LM:rtos (nth 0 itm) 2 2))
			(set_tile 	(strcat "speedcut" 		(LM:rtos conta 2 0))	(LM:rtos (nth 1 itm) 2 2))
			(if (= (nth 2 itm) 0)
				(set_tile   (strcat "include"	(LM:rtos conta 2 0))	"0")
				(set_tile   (strcat "include"	(LM:rtos conta 2 0))	"1")
			)
				
			(if (= (nth 2 itm) 0)
				(setq modet 1)
				(setq modet 0)
			)
			
			(mode_tile 	(strcat "tk" 			(LM:rtos conta 2 0))     		modet)
			(mode_tile 	(strcat "speedcut" 		(LM:rtos conta 2 0)) 			modet)
			(mode_tile 	(strcat "tk" 			(LM:rtos conta 2 0) 	"_1") 	modet)
			(mode_tile 	(strcat "tk" 			(LM:rtos conta 2 0) 	"_2") 	modet)
			(setq conta (1+ conta))
		)
		(set_tile "speedcut" (LM:rtos $SpeedCut 2 0))
	)
	;
	;
	;
	(defun GetDataSpeedDcl ( / CheckDataSpeedArray itm conta Data Include Rtn)
	
		(defun CheckDataSpeedArray (Data / conta Rtn)
			
			(setq Rtn T)
			(setq conta 1)
			(foreach itm Data
				(if (= (nth 2 itm) 1)
					(progn
						(if (zerop (nth 0 itm))	(progn (alert (strcat "[Riga " (LM:rtos conta 2 0) "] Parametro spessore non valido > 0")) (setq Rtn nil)))
						(if (zerop (nth 1 itm))	(progn (alert (strcat "[Riga " (LM:rtos conta 2 0) "] Parametro velocita' non valido > 0")) (setq Rtn nil)))
					)
				)
				(setq conta (1+ conta))
			)
			Rtn
		
		)
		;
		;
		;
		(setq conta 1)
		(foreach itm $SpeedCutArray

			(if (= (atoi (get_tile (strcat "include"  (LM:rtos conta 2 0)))) 0)
				(setq Include "0")
				(setq Include "1")
			)
			
			(setq Data  (append Data (list (list (atof (get_tile (strcat "tk" 	    (LM:rtos conta 2 0))))
											     (atof (get_tile (strcat "speedcut" (LM:rtos conta 2 0))))
												 (atoi Include)
											)
									)
						)
			)
			(setq conta (1+ conta))
		)

		
		(setq Rtn (CheckDataSpeedArray Data))
		(if Rtn 
			(progn 
				(setq $SpeedCutArray Data)
				(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
			)
		)
	)
	;
	;
	;
	(defun IncludeExclude (itm  mode / modet)
	
		(if (= (atoi mode) 0)
			(setq modet 1)
			(setq modet 0)
		)
		(mode_tile (strcat "tk" itm)  		modet)
		(mode_tile (strcat "speedcut" itm)  modet)
		(mode_tile (strcat "tk" itm "_1")  	modet)
		(mode_tile (strcat "tk" itm "_2") 	modet)
	)

	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	
	(new_dialog "setupspeedcut" xx "" (cond ( *setupspeedcut* ) ( '(-1 -1) )))
			
			(LoadSetupSpeedDcl)
			
			(action_tile "include1"  "(IncludeExclude \"1\"  (get_tile \"include1\"))")
			(action_tile "include2"  "(IncludeExclude \"2\"  (get_tile \"include2\"))")
			(action_tile "include3"  "(IncludeExclude \"3\"  (get_tile \"include3\"))")
			(action_tile "include4"  "(IncludeExclude \"4\"  (get_tile \"include4\"))")
			(action_tile "include5"  "(IncludeExclude \"5\"  (get_tile \"include5\"))")
			(action_tile "include6"  "(IncludeExclude \"6\"  (get_tile \"include6\"))")
			(action_tile "include7"  "(IncludeExclude \"7\"  (get_tile \"include7\"))")
			(action_tile "include8"  "(IncludeExclude \"8\"  (get_tile \"include8\"))")
			(action_tile "include9"  "(IncludeExclude \"9\"  (get_tile \"include9\"))")
			(action_tile "include10" "(IncludeExclude \"10\" (get_tile \"include10\"))")
			(action_tile "include11" "(IncludeExclude \"11\" (get_tile \"include11\"))")
			(action_tile "include12" "(IncludeExclude \"12\" (get_tile \"include12\"))")
			(action_tile "include13" "(IncludeExclude \"13\" (get_tile \"include13\"))")
			(action_tile "include14" "(IncludeExclude \"14\" (get_tile \"include14\"))")
			(action_tile "include15" "(IncludeExclude \"15\" (get_tile \"include15\"))")
			(action_tile "include16" "(IncludeExclude \"16\" (get_tile \"include16\"))")
			(action_tile "include17" "(IncludeExclude \"17\" (get_tile \"include17\"))")
			(action_tile "include18" "(IncludeExclude \"18\" (get_tile \"include18\"))")
			(action_tile "include19" "(IncludeExclude \"19\" (get_tile \"include19\"))")
			(action_tile "include20" "(IncludeExclude \"20\" (get_tile \"include20\"))")
			
			(action_tile "_Salva_"  (strcat "(setq Rtn (GetDataSpeedDcl))"
										    "(if Rtn (progn (setq *setupspeedcut* (done_dialog)) (unload_dialog xx)))"
									)
			)
			(action_tile "_Esci_"  "(setq *setupspeedcut* (done_dialog)) (unload_dialog xx)")
			(start_dialog)
)
;
;
;
(defun LoadGuiCutOff ( / LoadSetupCutOffDcl GetDataCutOffDcl IncludeExclude xx Rtn)

	(defun LoadSetupCutOffDcl (/ itm conta modet)
	
		(setq conta 1)
		(foreach itm $CutOffArray
			(set_tile 	(strcat "dia" 			(LM:rtos conta 2 0) 	"_1")	(LM:rtos (nth 0 itm) 2 2))
			(set_tile 	(strcat "dia" 			(LM:rtos conta 2 0) 	"_2")	(LM:rtos (nth 1 itm) 2 2))
			
			(if (= (nth 2 itm) 0)
				(set_tile   (strcat "include"	(LM:rtos conta 2 0))	"0")
				(set_tile   (strcat "include"	(LM:rtos conta 2 0))	"1")
			)
				
			(if (= (nth 2 itm) 0)
				(setq modet 1)
				(setq modet 0)
			)
			
			(mode_tile 	(strcat "tdia" 			(LM:rtos conta 2 0) 	"_1") 	modet)
			(mode_tile 	(strcat "tdia" 			(LM:rtos conta 2 0) 	"_2") 	modet)
			(mode_tile 	(strcat "dia" 			(LM:rtos conta 2 0) 	"_1") 	modet)
			(mode_tile 	(strcat "dia" 			(LM:rtos conta 2 0) 	"_2") 	modet)
			(setq conta (1+ conta))
		)
		(if (= $CutOffIrregularShape 0)
			(set_tile   "irregularshape" "0")
			(set_tile   "irregularshape" "1")
		)
	)
	;
	;
	;
	(defun GetDataCutOffDcl ( / CheckDataCutOffArray itm conta Data Include Rtn)
	
		(defun CheckDataCutOffArray (Data / conta Rtn)
			
			(setq Rtn T)
			(setq conta 1)
			(foreach itm Data
				(if (= (nth 2 itm) 1)
					(if (> (nth 0 itm) (nth 1 itm))
						(progn (alert (strcat "[Riga " (LM:rtos conta 2 0) "] Diametro 1 > Diametro 2\nParametro non valido")) (setq Rtn nil))
					)
				)
				(setq conta (1+ conta))
			)
			Rtn
		)
		;
		;
		;
		(setq conta 1)
		(foreach itm $SpeedCutArray
		
			(if (= (atoi (get_tile (strcat "include"  (LM:rtos conta 2 0)))) 0)
				(setq Include "0")
				(setq Include "1")
			)

			(setq Data  (append Data (list (list (atof (get_tile (strcat "dia" 			(LM:rtos conta 2 0) 	"_1")))
											     (atof (get_tile (strcat "dia" 			(LM:rtos conta 2 0) 	"_2")))
												 (atoi Include)
										  )
									)
						)
			)
			(setq conta (1+ conta))
		)
		
		(setq Rtn (CheckDataCutOffArray Data))
		(if Rtn 
			(progn 
				(setq $CutOffArray Data)
				(setq $CutOffIrregularShape (atoi (get_tile "irregularshape")))
				(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
			)
		)
	)
	;
	;
	;
	(defun IncludeExclude (itm  mode / modet)
	
		(if (= (atoi mode) 0)
			(setq modet 1)
			(setq modet 0)
		)
		
		(mode_tile (strcat "tdia" itm "_1")  	modet)
		(mode_tile (strcat "tdia" itm "_2") 	modet)
		(mode_tile (strcat "dia" itm "_1")  	modet)
		(mode_tile (strcat "dia" itm "_2") 	modet)
	)
	;
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	
	(new_dialog "setupcutoff" xx "" (cond ( *setupcutoff* ) ( '(-1 -1) )))
			
			(LoadSetupCutOffDcl)
			
			(action_tile "include1"  "(IncludeExclude \"1\"  (get_tile \"include1\"))")
			(action_tile "include2"  "(IncludeExclude \"2\"  (get_tile \"include2\"))")
			(action_tile "include3"  "(IncludeExclude \"3\"  (get_tile \"include3\"))")
			(action_tile "include4"  "(IncludeExclude \"4\"  (get_tile \"include4\"))")
			(action_tile "include5"  "(IncludeExclude \"5\"  (get_tile \"include5\"))")
			(action_tile "include6"  "(IncludeExclude \"6\"  (get_tile \"include6\"))")
			(action_tile "include7"  "(IncludeExclude \"7\"  (get_tile \"include7\"))")
			(action_tile "include8"  "(IncludeExclude \"8\"  (get_tile \"include8\"))")
			(action_tile "include9"  "(IncludeExclude \"9\"  (get_tile \"include9\"))")
			(action_tile "include10" "(IncludeExclude \"10\" (get_tile \"include10\"))")
			(action_tile "include11" "(IncludeExclude \"11\" (get_tile \"include11\"))")
			(action_tile "include12" "(IncludeExclude \"12\" (get_tile \"include12\"))")
			(action_tile "include13" "(IncludeExclude \"13\" (get_tile \"include13\"))")
			(action_tile "include14" "(IncludeExclude \"14\" (get_tile \"include14\"))")
			(action_tile "include15" "(IncludeExclude \"15\" (get_tile \"include15\"))")
			(action_tile "include16" "(IncludeExclude \"16\" (get_tile \"include16\"))")
			(action_tile "include17" "(IncludeExclude \"17\" (get_tile \"include17\"))")
			(action_tile "include18" "(IncludeExclude \"18\" (get_tile \"include18\"))")
			(action_tile "include19" "(IncludeExclude \"19\" (get_tile \"include19\"))")
			(action_tile "include20" "(IncludeExclude \"20\" (get_tile \"include20\"))")
			
			(action_tile "_Salva_"  (strcat "(setq Rtn (GetDataCutOffDcl))"
										    "(if Rtn (progn (setq *setupcutoff* (done_dialog)) (unload_dialog xx)))"
									)
			)
			(action_tile "_Esci_"  "(setq *setupcutoff* (done_dialog)) (unload_dialog xx)")
			(start_dialog)
)
;
;
;
(defun LoadGuiBarCode ( / UpdatePopList xx UpdatePopList LoadSetupBarCodeDcl IncludeExclude GetDataBarCodeDcl)

	(defun UpdatePopList (LstData KeyAction)

		(if (and LstData KeyAction)
			(progn
				(start_list KeyAction)
				(mapcar 'add_list LstData)
				(end_list)    
				(set_tile KeyAction "0")
			)
		)
    
	)
	;
	;
	;
	(defun LoadSetupBarCodeDcl (LstData / itm conta modet)
	
		(setq conta 1)
		
		(foreach itm $BarCodeArray
			
			(setq Status (LM:rtos (nth 2 itm) 2 0))
		
			(if (= (nth 2 itm) 0)
				(setq modet 1)
				(setq modet 0)
			)
			;(terpri) (princ itm)
			;(alert (strcat "Conta " (LM:rtos conta 2 0) " ->" Status))
			
			(cond
				((= conta 1)
					(set_tile  (strcat "Include" (LM:rtos conta 2 0)) Status)
					(set_tile  (strcat "separa"  (LM:rtos conta 2 0)) (chr (nth 0 itm)))
					(mode_tile (strcat "separa"  (LM:rtos conta 2 0)) modet)
				)
				((and (> conta 1) (< conta (length $BarCodeArray)))
					(set_tile 	(strcat "Include" (LM:rtos conta 2 0)) Status)
					(mode_tile  (strcat "campo"   (LM:rtos conta 2 0)) modet)
					(mode_tile  (strcat "separa"  (LM:rtos conta 2 0)) modet)
					(set_tile   (strcat "separa"  (LM:rtos conta 2 0)) (chr  (nth 0 itm)))
					(set_tile 	(strcat "campo"   (LM:rtos conta 2 0)) (LM:rtos (nth 1 itm) 2 0))

				)
				((= conta (length $BarCodeArray))
					(set_tile  (strcat "Include" (LM:rtos conta 2 0)) Status)
					(set_tile  (strcat "separa"  (LM:rtos conta 2 0)) (chr (nth 0 itm)))
					(mode_tile (strcat "separa"  (LM:rtos conta 2 0)) modet)
				)
			)
			
			(setq conta (1+ conta))
		)

	)
	;
	;
	;
	(defun IncludeExclude (itm  mode / modet)
	
		(if (= (atoi mode) 0)
			(setq modet 1)
			(setq modet 0)
		)
		
		(mode_tile (strcat "campo" itm)  	modet)
		(mode_tile (strcat "separa" itm) 	modet)

	)
	;
	;
	;
	(defun GetDataBarCodeDcl ( / CheckDataCutOffArray itm conta Data Include)
		;
		;
		;
		(setq conta 1)
		(setq Data nil)
		
		(foreach itm $BarCodeArray
		
			(if (= (atoi (get_tile (strcat "Include"  (LM:rtos conta 2 0)))) 0)
				(setq Include 0)
				(setq Include 1)
			)
			
			(cond 
				((= conta 1)
					(setq Data  (append Data (list 	(list 	(ascii (get_tile (strcat "separa"	(LM:rtos conta 2 0))))
															-1
															 Include
													)
											)
								)
					)
				)
				((and (> conta 1) (< conta (length $BarCodeArray)))
					(setq Data  (append Data (list 	(list 	(ascii (get_tile (strcat "separa"	(LM:rtos conta 2 0))))
															(atoi  (get_tile (strcat "campo" 	(LM:rtos conta 2 0))))
															Include
													)
											)
								)
					)
				)
				((= conta (length $BarCodeArray))
					(setq Data  (append Data (list 	(list 	(ascii (get_tile (strcat "separa"	(LM:rtos conta 2 0))))
															-1
															Include
													)
											)
								)
					)
				)
			)
			(setq conta (1+ conta))
		)
		
		
		(setq $BarCodeArray Data)
		(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "\nconfigurazione salvata        -> ")
	)
	;
	;
	;
							
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "setupbarcode" xx)

 
	(UpdatePopList $LstDataBarCode "campo2") 
	(UpdatePopList $LstDataBarCode "campo3") 
	(UpdatePopList $LstDataBarCode "campo4") 
	(UpdatePopList $LstDataBarCode "campo5") 
	(UpdatePopList $LstDataBarCode "campo6") 
	(UpdatePopList $LstDataBarCode "campo7") 
	(UpdatePopList $LstDataBarCode "campo8") 
	(UpdatePopList $LstDataBarCode "campo9") 
	(UpdatePopList $LstDataBarCode "campo10") 
	(UpdatePopList $LstDataBarCode "campo11") 
	(UpdatePopList $LstDataBarCode "campo12") 
	(UpdatePopList $LstDataBarCode "campo13") 
	(UpdatePopList $LstDataBarCode "campo14") 
	(UpdatePopList $LstDataBarCode "campo15")
	(UpdatePopList $LstDataBarCode "campo16")
	(LoadSetupBarCodeDcl $LstDataBarCode)

	(action_tile "Include1"  "(IncludeExclude \"1\"  	(get_tile \"Include1\"))")
	(action_tile "Include2"  "(IncludeExclude \"2\"  	(get_tile \"Include2\"))")
	(action_tile "Include3"  "(IncludeExclude \"3\"  	(get_tile \"Include3\"))")
	(action_tile "Include4"  "(IncludeExclude \"4\"  	(get_tile \"Include4\"))")
	(action_tile "Include5"  "(IncludeExclude \"5\"  	(get_tile \"Include5\"))")
	(action_tile "Include6"  "(IncludeExclude \"6\"  	(get_tile \"Include6\"))")
	(action_tile "Include7"  "(IncludeExclude \"7\"  	(get_tile \"Include7\"))")
	(action_tile "Include8"  "(IncludeExclude \"8\"  	(get_tile \"Include8\"))")
	(action_tile "Include9"  "(IncludeExclude \"9\"  	(get_tile \"Include9\"))")
	(action_tile "Include10"  "(IncludeExclude \"10\"  	(get_tile \"Include10\"))")
	(action_tile "Include11"  "(IncludeExclude \"11\"  	(get_tile \"Include11\"))")
	(action_tile "Include12"  "(IncludeExclude \"12\"  	(get_tile \"Include12\"))")
	(action_tile "Include13"  "(IncludeExclude \"13\"  	(get_tile \"Include13\"))")
	(action_tile "Include14"  "(IncludeExclude \"14\"  	(get_tile \"Include14\"))")
	(action_tile "Include15"  "(IncludeExclude \"15\"  	(get_tile \"Include15\"))")
	(action_tile "Include16"  "(IncludeExclude \"16\"  	(get_tile \"Include16\"))")
	(action_tile "Include17"  "(IncludeExclude \"17\"  	(get_tile \"Include17\"))")
	
	(action_tile "accept" 	(strcat	"(GetDataBarCodeDcl)"
									"(done_dialog)"
									"(unload_dialog xx)"
							)
	)
	(action_tile "cancel"   (strcat	"(done_dialog)"
									"(unload_dialog xx)"
							)
	)
	;
	; ------------- fine azione
	;
   (start_dialog)
)
;
;
;
(defun LoadClientSetupEasyCut (FileName / *error* 
										  Stream riga rigasplit itm itm1 itm2 Rtn)

	(defun *error* (msg / PathEasyCut FileEasyCut)
		(LoadDefaultSetup)
		(setq PathEasyCut 		(vl-registry-read EasyCutRegistryPath$ "DefaultPathCfg"))
		(setq FileEasyCut 		(vl-registry-read EasyCutRegistryPath$ "DefaultFileCfg"))
		(setq NameConfigurationEasyCut$ (strcat PathEasyCut "\\" FileEasyCut))
		(SaveSetupEasyCut (strcat PathEasyCut "\\" FileEasyCut) "\nconfigurazione salvata        -> ")
		(vl-registry-write EasyCutRegistryPath$ "PathCfg" PathEasyCut)
		(vl-registry-write EasyCutRegistryPath$ "FileCfg" FileEasyCut)
	)

	(if (findfile FileName)
		(progn
				(setq Rtn T)
				;
				; load parameter Client
				;
				(setq Stream (open FileName "r")) 
	
				(if (not Stream)
					(progn
						(alert (strcat "[LoadClientSetupEasyCut] ERRORE!! apertura file " FileName))
						(exit)
					)
					(setq riga (read-line Stream))
				)
				(if (not riga)
					(progn
						(alert (strcat "[LoadClientSetupEasyCut] ERRORE!! file vuoto " FileName))
						(close Stream)
						(exit)
					)
				)
				;
				; lettura contorno
				;
				(while riga
					;(terpri) (princ riga)
					(setq riga  (vl-string-right-trim  " \t" (vl-string-left-trim " \t" riga)))
					;(princ riga)
					;(getstring "")
					(if (/= (substr riga 1 1) ";") ; commento
						(progn
							(setq rigasplit (splitxt riga "|"))
					
							(cond
								((>= (length rigasplit) 2)
								
									(setq itm1  (vl-string-right-trim  " \t" (vl-string-left-trim " \t" (nth 0 rigasplit))))
									(setq itm2  (vl-string-right-trim  " \t" (vl-string-left-trim " \t" (nth 1 rigasplit))))
					
									(cond 
										((= (strcase itm1) "T")
											(set (read itm2) T)
										)
										((= (strcase itm1) "NIL")
											(set (read itm2) nil)
										)
										(t
											(setq itm (read itm1))
					
											(cond
												((= (type itm) 'INT)
													(set (read itm2) itm)
												)
												((= (type itm) 'REAL)
													(set (read itm2) itm)
												)
												((= (type itm) 'LIST)
													(set (read itm2) itm)
												)
												((= (type itm) 'SYM)
													(set (read itm2) itm1)
												)
												(t
													(set (read itm2) itm1)
												)
											)
										)
									)
								)
								(t
									(alert (strcat "\n[LoadClientSetupEasyCut] ERRORE!! caricamento setup -> " FileName))
									(close Stream)
									(exit)
								)
							)
						)
					)
					(setq riga (read-line Stream))
				)
				(close Stream)         
				(princ "\nconfigurazione client caricata-> ") (princ FileName)
		)
	)
	Rtn
)
;
;
;
(defun CheckIfExistFontFile (FontName / key1 key2 itm Rtn) 

	;"Code 128 (TrueType)"
	
	(if FontName
		(progn
			(if (= (substr (getvar "platform") 1 17) "Microsoft Windows") 
				(setq 	key1 "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts" 
						key2 "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Fonts" 
				) 
			) 
			; check Key1
			(foreach itm (vl-registry-descendents key1 T)
				(if (= (strcase itm) (strcase FontName))
					(setq Rtn T)
				)
			)
			; check Key2
			(foreach itm (vl-registry-descendents key2 T)
				(if (= (strcase itm) (strcase FontName))
					(setq Rtn T)
				)
			)
		)
	)
	
	Rtn
)
;
;
;
(defun testo_a_sinistra (testo n_car / out conta)
;
; procedura per formattare un testo con enne caratteri partendo da sinistra
; es testo= "122 124" 
;    n_car=10
;    risultato "123 124   "
;
  (setq out ""
        conta 1
  )
  (repeat n_car
     (if (<= conta (strlen testo))
         (setq out (strcat out (substr testo conta 1)))
         (setq out (strcat out " "))
     )
     (setq conta (+ conta 1))
  )    
  (setq out out)
)
;
;
;
(defun testo_a_destra (testo n_car / out conta)
;
; procedura per formattare un testo con enne caratteri partendo da sinistra
; es testo= "122 124" 
;    n_car=10
;    risultato "   123 124"
;
  (setq out testo
        conta 1
  )
  (repeat (- n_car (strlen testo))
          (setq out (strcat " " out))
          (setq conta (+ conta 1))
  )    
  (setq out out)
)
;
;
;
(defun MakeStyle (FileFont NameStyle LstAttribute ActivateStyle / acadApp acadDoc styles objStyle HeigthStyle  WidthStyle  ObliqueAgleStyle)
 
	;LstAttribute
	;	0	height
	;	1	width
	;	2	obliqueangle
		
	(if (and FileFont NameStyle)
		(if (not (tblobjname "style" NameStyle))
			(progn
				(setq acadApp  (vlax-get-acad-object)) 
				(setq acadDoc  (vla-get-activedocument acadApp)) 
				(setq styles   (vla-get-textstyles acadDoc))
				(setq objStyle (vla-add styles NameStyle))
				(vla-put-fontfile objStyle FileFont)
				
				(if (null (nth 0 LstAttribute))
					(setq HeigthStyle 0)
					(setq HeigthStyle (nth 0 LstAttribute))
				)
				(if (null (nth 1 LstAttribute))
					(setq WidthStyle 1)
					(setq WidthStyle (nth 1 LstAttribute))
				)
				(if (null (nth 2 LstAttribute))
					(setq ObliqueAgleStyle 0.0)
					(setq ObliqueAgleStyle (nth 2 LstAttribute))
				)
				(vla-put-height       objStyle HeigthStyle)
				(vla-put-width        objStyle WidthStyle)
				(vla-put-obliqueangle objStyle (/ (* ObliqueAgleStyle PI) 180.0))
				
				(if (= ActivateStyle 1)
					(vla-put-activetextstyle acadDoc objStyle)
				)
			)
		)
	)
	
)
;
;
;
(defun MakeText (Text Px Style Heigth Rotation Factor Color Layer  / EnameText)
	
		(if (and Text Style Heigth Color)
			(setq EnameText (entmakex (list 	'(0 . "TEXT")
												(if Layer (cons 8 Layer))
												(cons 10 Px)
												(cons 40 Heigth)
												(cons 41 Factor)
												(cons 1  Text)
												(cons 50 Rotation) ; radianti
												(cons 7  Style)
												'(71 . 0)
												'(72 . 0) ; giustificato
												'(73 . 0)
										)
							)
			)
		)
		(if (and EnameText Color)
			(vla-put-Color (vlax-ename->vla-object EnameText) Color)
		)
		EnameText
)
