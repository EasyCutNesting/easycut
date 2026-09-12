;
;
;
(defun c:arrow (/ *error* MakeArrow DeletedArrow EnameShape LocalDimBox)

	;
    ; *error* ++++++++++++++++++
    ;
    (defun *error* (msg)
		(DeletedArrow)
 

		(or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
			(princ (strcat "\n** Error: " msg " **")))
		(princ)
    )
	;
	;
	;
	(defun MakeArrow (Pmin Pmax)
	
		(if (and Pmin Pmax)
			(progn 
				(ArrowGraph 1 Pmin Pmax)
				(ArrowGraph 2 Pmin Pmax)
				(ArrowGraph 3 Pmin Pmax)
				(ArrowGraph 4 Pmin Pmax)

			)
		)
	)
	;
	;
	;
	(defun DeletedArrow ()
		(redraw)
	)
	;
	;
	;
    (setq EnameShape (ssname (ssget) 0))
	(setq LocalDimBox (ucs-bbox EnameShape))
	
    (while
  
        (setq gr (grread t 15 0) code (car gr) data (cadr gr))
        (cond
			((and (= code 5) (listp data))            ; Mouse rolling

                (DeletedArrow)
				(MakeArrow (nth 0 LocalDimBox) (nth 1 LocalDimBox))
			)
			(t 
				nil
			)
		)

    )
)
;
;
;
(defun c:PolarArw (/ *error* MakeArrow DeletedArrow EnameShape LocalDimBox CenterSheet)

	;
    ; *error* ++++++++++++++++++
    ;
    (defun *error* (msg)
		(DeletedArrow)
		(or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
			(princ (strcat "\n** Error: " msg " **")))
		(princ)
    )
	;
	;
	;
	(defun MakePolarRular (PtCenter Radius)
	
		(if (and PtCenter Radius)
			(PolarRuler PtCenter Radius)
		)
	)
	;
	;
	;
	(defun DeletedArrow ()
		(redraw)
	)
	;
	;
	;
    (setq EnameShape (ssname (ssget) 0))
	(setq LocalDimBox (ucs-bbox EnameShape))
	
    (while
  
        (setq gr (grread t 15 0) code (car gr) data (cadr gr))
        (cond
			((and (= code 5) (listp data))            ; Mouse rolling

                (DeletedArrow)
				(setq CenterSheet (list (/ (+ (nth 0 (nth 0 LocalDimBox)) (nth 0 (nth 1 LocalDimBox))) 2.0)
								        (/ (+ (nth 1 (nth 0 LocalDimBox)) (nth 1 (nth 1 LocalDimBox))) 2.0)
								  )
				)
				(MakePolarRular CenterSheet (/ (distance (nth 0 LocalDimBox) (nth 1 LocalDimBox)) 2.0))
			)
			(t 
				nil
			)
		)

    )
)
;
;
;
(defun PolarRuler (PtCenter Radius / Prol
									 LstAngleRuler1 LstAngleRuler2 LstAngleRuler3 LstAngleRuler4
									 HBodyRuler HBodyMRuler ColorRuler ColorMRuler DivRulerAngle AngleDivision
									 LstAngleMRuler Ang p1 p2 conta) 
									 

		(defun Prol (x1 y1 x2 y2 lung / ang x y punto)

			;procedura PROL.LSP   (prolungamento di una retta)
			;
			; dato di output          : variabile contenente la lista del valore X e Y
			(setq ang (angle (list x1 y1) (list x2 y2)))
			(setq x (+ x2 (* lung (cos ang))))
			(setq y (+ y2 (* lung (sin ang))))
			(setq punto (list x y))
		)
		;
		;
		;
		(setq HBodyRuler  60.0) 									; altezza tacche intermedie
		(setq HBodyMRuler 20.0) 									; altezza tacche principali
		(setq ColorRuler 1)    										; colore tacche intermedie
		(setq ColorMRuler 2)    									; colore tacche principale
		(setq DivRulerAngle 10)										; divisione angolo 90°
		(setq AngleDivision (/ (/ pi 2.0) (1+ DivRulerAngle)))
		
		(if (and PtCenter Radius)
			(progn
				
				; inserimento tacche principali
				
				(setq Radius (+ Radius (/ (getvar 'VIEWSIZE) 50.0)))
				(setq HBodyMRuler (/ (getvar 'VIEWSIZE) HBodyMRuler))
				(setq HBodyRuler  (/ (getvar 'VIEWSIZE) HBodyRuler))
								
				(setq LstAngleMRuler (list 0.0 (/ pi 2.0) pi (* (/ pi 2.0) 3.0)))
				(foreach Ang LstAngleMRuler
				
					(setq p1 	(polar PtCenter Ang Radius))
					(setq p2	(Prol (nth 0 PtCenter) (nth 1 PtCenter) (nth 0 p1) (nth 1 p1) (- 0.0 HBodyMRuler)))
					(grdraw p1 p2 ColorMRuler)
				)
				
				(setq conta 1)
				(repeat DivRulerAngle
					(setq LstAngleRuler1 (append LstAngleRuler1 (list (+ 0.0 (* conta AngleDivision)))))
					(setq conta (1+ conta))
				)
				(setq conta 1)
				(repeat DivRulerAngle
					(setq LstAngleRuler2 (append LstAngleRuler2 (list (+ (/ pi 2.0) (* conta AngleDivision)))))
					(setq conta (1+ conta))
				)
				(setq conta 1)
				(repeat DivRulerAngle
					(setq LstAngleRuler3 (append LstAngleRuler3 (list (+ pi (* conta AngleDivision)))))
					(setq conta (1+ conta))
				)
				(setq conta 1)
				(repeat DivRulerAngle
					(setq LstAngleRuler4 (append LstAngleRuler4 (list (+ (* (/ pi 2.0) 3.0) (* conta AngleDivision)))))
					(setq conta (1+ conta))
				)
				
				(foreach Ang LstAngleRuler1
				
					(setq p1 	(polar PtCenter Ang Radius))
					(setq p2	(Prol (nth 0 PtCenter) (nth 1 PtCenter) (nth 0 p1) (nth 1 p1) (- 0.0 HBodyRuler)))
					(grdraw p1 p2 ColorRuler)
				)
				(foreach Ang LstAngleRuler2
				
					(setq p1 	(polar PtCenter Ang Radius))
					(setq p2	(Prol (nth 0 PtCenter) (nth 1 PtCenter) (nth 0 p1) (nth 1 p1) (- 0.0 HBodyRuler)))
					(grdraw p1 p2 ColorRuler)
				)
				(foreach Ang LstAngleRuler3
				
					(setq p1 	(polar PtCenter Ang Radius))
					(setq p2	(Prol (nth 0 PtCenter) (nth 1 PtCenter) (nth 0 p1) (nth 1 p1) (- 0.0 HBodyRuler)))
					(grdraw p1 p2 ColorRuler)
				)
				(foreach Ang LstAngleRuler4
				
					(setq p1 	(polar PtCenter Ang Radius))
					(setq p2	(Prol (nth 0 PtCenter) (nth 1 PtCenter) (nth 0 p1) (nth 1 p1) (- 0.0 HBodyRuler)))
					(grdraw p1 p2 ColorRuler)
				)
				
				
			)
		)

)
;
;
;
(defun ArrowGraph (quad p1 p2 /  ArrowColor HBodyArrow LBodyArrow LArrow HArrow 
								 pm dist pa pb pc pd pe pf pg lista_out EnameArrow cos_dir)
	

			(setq ArrowColor 1)    ; colore freccia
		  
			(setq HBodyArrow 30.0) 	; altezza corpo freccia
			(setq LBodyArrow 20.0) 	; lunghezza corpo freccia
			(setq LArrow 60.0) 		; lunghezza freccia 
			(setq HArrow 60.0) 		; altezza freccia
			(setq Harrow (/ Harrow 2.0))
  
			(setq pm   (nth 0 (div (nth 0 p1) (nth 1 p1) (nth 0 p2) (nth 1 p2) 1)))
			(setq dx (nth 0 pm) dy (nth 1 pm))
			(setq lista_out nil)
			
			(cond
				((or (= quad 1) (= quad 3))
					(setq dist (- (nth 0 p2) (nth 0 pm)))
				)
				((or (= quad 2) (= quad 4))
					(setq dist (- (nth 1 p2) (nth 1 pm)))
				)
			)
			
			(setq dist (+ dist (/ (getvar 'VIEWSIZE) 50.0)))
			
			(cond
				((= quad 1)
;											X																Y
					(setq pa 	(list 	(* dist 1.0)  									             (* (/ (getvar 'VIEWSIZE) HBodyArrow)  1.0)))
					(setq pb 	(list 	(* dist 1.0)  									             (* (/ (getvar 'VIEWSIZE) HBodyArrow) -1.0)))
					(setq pc 	(list 	(* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) 1.0)           (* (/ (getvar 'VIEWSIZE) HBodyArrow)  1.0)))
					(setq pd 	(list 	(* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) 1.0)           (* (/ (getvar 'VIEWSIZE) HBodyArrow) -1.0)))
					(setq pe 	(list 	(* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) 1.0)           (* (+ (/ (getvar 'VIEWSIZE) HBodyArrow) (/ (getvar 'VIEWSIZE) HArrow))  1.0)))
					(setq pf 	(list 	(* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) 1.0)           (* (+ (/ (getvar 'VIEWSIZE) HBodyArrow) (/ (getvar 'VIEWSIZE) HArrow)) -1.0)))
					(setq pg 	(list 	(* (+ dist (* (/ (getvar 'VIEWSIZE) HArrow) 3.0)) 1.0)       0.0))
				)
				((= quad 2)
;											X																Y
					(setq pa 	(list 	(* (/ (getvar 'VIEWSIZE) HBodyArrow) -1.0) 		                             (* dist 1.0)))				
					(setq pb 	(list 	(* (/ (getvar 'VIEWSIZE) HBodyArrow)  1.0) 		                             (* dist 1.0)))				
					(setq pc 	(list 	(* (/ (getvar 'VIEWSIZE) HBodyArrow) -1.0) 		                             (* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) 1.0)))				
					(setq pd 	(list 	(* (/ (getvar 'VIEWSIZE) HBodyArrow)  1.0) 		                             (* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) 1.0)))				
					(setq pe 	(list 	(* (+ (/ (getvar 'VIEWSIZE) HBodyArrow) (/ (getvar 'VIEWSIZE) HArrow)) -1.0) (* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) 1.0)))				
					(setq pf 	(list 	(* (+ (/ (getvar 'VIEWSIZE) HBodyArrow) (/ (getvar 'VIEWSIZE) HArrow))  1.0) (* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) 1.0)))				
					(setq pg 	(list 	0.0   		                                                                 (* (+ dist (* (/ (getvar 'VIEWSIZE) HArrow)  3.0)) 1.0)))
				)
				((= quad 3)
;											X																Y
					(setq pa 	(list 	(* dist -1.0)  									                (* (/ (getvar 'VIEWSIZE) HBodyArrow) -1.0)))
					(setq pb 	(list 	(* dist -1.0)  									                (* (/ (getvar 'VIEWSIZE) HBodyArrow)  1.0)))
					(setq pc 	(list 	(* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) -1.0)             (* (/ (getvar 'VIEWSIZE) HBodyArrow) -1.0)))									
					(setq pd 	(list 	(* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) -1.0)             (* (/ (getvar 'VIEWSIZE) HBodyArrow)  1.0)))									
					(setq pe 	(list 	(* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) -1.0)             (* (+ (/ (getvar 'VIEWSIZE) HBodyArrow) (/ (getvar 'VIEWSIZE) HArrow)) -1.0)))
					(setq pf 	(list 	(* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) -1.0)             (* (+ (/ (getvar 'VIEWSIZE) HBodyArrow) (/ (getvar 'VIEWSIZE) HArrow))  1.0)))
					(setq pg	(list 	(* (+ dist (* (/ (getvar 'VIEWSIZE) HArrow) 3.0)) -1.0)     0.0))
				)	
				((= quad 4)
;											X																Y
					(setq pa 	(list 	(* (/ (getvar 'VIEWSIZE) HBodyArrow)  1.0) 										(* dist -1.0)))
					(setq pb 	(list 	(* (/ (getvar 'VIEWSIZE) HBodyArrow) -1.0) 										(* dist -1.0)))
					(setq pc 	(list 	(* (/ (getvar 'VIEWSIZE) HBodyArrow)  1.0) 										(* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) -1.0)))
					(setq pd 	(list 	(* (/ (getvar 'VIEWSIZE) HBodyArrow) -1.0) 										(* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) -1.0)))				
					(setq pe 	(list 	(* (+ (/ (getvar 'VIEWSIZE) HBodyArrow) (/ (getvar 'VIEWSIZE) HArrow))  1.0)  	(* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) -1.0)))				
					(setq pf 	(list 	(* (+ (/ (getvar 'VIEWSIZE) HBodyArrow) (/ (getvar 'VIEWSIZE) HArrow)) -1.0)  	(* (+ dist (/ (getvar 'VIEWSIZE) LBodyArrow)) -1.0)))				
					(setq pg 	(list 	0.0   		                                                               	  	(* (+ dist (* (/ (getvar 'VIEWSIZE) HArrow)  3.0)) -1.0)))
				)
			)
			(setq pa    (list   (+ (nth 0 pa) dx) (+ (nth 1 pa) dy)))
			(setq pb    (list   (+ (nth 0 pb) dx) (+ (nth 1 pb) dy)))
			(setq pc    (list   (+ (nth 0 pc) dx) (+ (nth 1 pc) dy)))
			(setq pd    (list   (+ (nth 0 pd) dx) (+ (nth 1 pd) dy)))
			(setq pe    (list   (+ (nth 0 pe) dx) (+ (nth 1 pe) dy)))
			(setq pf    (list   (+ (nth 0 pf) dx) (+ (nth 1 pf) dy)))
			(setq pg    (list   (+ (nth 0 pg) dx) (+ (nth 1 pg) dy)))
			
			(grdraw pa pb  ArrowColor)
			(grdraw pa pc  ArrowColor)
			(grdraw pb pd  ArrowColor)
			(grdraw pc pe  ArrowColor)
			(grdraw pd pf  ArrowColor)
			(grdraw pe pg  ArrowColor)
			(grdraw pf pg  ArrowColor)
			(list pa pb pc pd pe pf pg)
)
;
;
;
(defun DinamicInfo (/ ;;      { Funzioni locali }
						  
                          *error*
						  GetSizeAperture
                          Reset
                          SaveInfo
						  GetEnameMember
						  GetInfoShapeText
						  GetInfoSheetText
						  MakeTextShape
						  MakeTextSheet
						  DataRuler
						  MakeRule
						  
						  ;;   { Variabili globali }

						  $Rule
						  $LstEnamePicked
						  $StatusSheet
						  $StatusShape
						  
                          ;;   { Variabili locali }
 
                          ViewSize_apertura ViewSize_htxt gr code data msgLstShape msgLstSheet
						  TextDefault TextInfoSheet TextInfoShape DataPost ViewCtr NewViewCtr EnameMember)

 
    ;
    ; *error* ++++++++++++++++++
    ;
    (defun *error* (msg)
     
	  (UnHighlight $LstEnamePicked)
	  (Reset)
      (SaveInfo)

      (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
          (princ (strcat "\n** Error: " msg " **")))
      (princ)
    )
	;
	;
	;
	(defun GetSizeAperture (/ SS VS PB SWP SHP AR WSD PPDU BOX)

		(setq 	SS (getvar "SCREENSIZE") 	; screen size in pixels
				VS (getvar "VIEWSIZE") 		; screen height in drawing units
				PB (getvar "pickbox") 		; get current pickbox size
				SWP (car SS) 				; width of screen in pixels
				SHP (cadr SS) 				; height of screen in pixels
				AR (/ SWP SHP) 				; aspect ratio width/height
				WSD (* VS AR) 				; width of screen dwg units = ratio times height
				PPDU (/ WSD SWP) 			; pixels per drawing unit
				BOX (/ (* VS (* 2 PB)) SHP) ; drawing units per pixel
		)
		;(command "._polygon" "4" (getvar "viewctr") "_c" (/ box 2))
		BOX
	)
	;
	;
	;
    (defun Reset (/ Sset Ne)
  
		(setq Sset (ssget "_X" (list (cons 8 $LayerDinamicInfoEasyCut)))); selection set for Entities to delete
        (if Sset
		    (repeat (setq nE (sslength Sset))
               (entdel (ssname Sset (setq nE (1- nE))))
			)
        )
		
    )
	;
	;
	;
	(defun DeleteShapeText (/ itm)
		(foreach itm (LM:ss->ent (ssget "_X" (list (cons 0 "MTEXT") (cons 8  $LayerDinamicInfoEasyCut) (list -3 (list $InfoMtextShape)))))
			(if (entget itm) (entdel itm))
		)
	)
	;
	;
	;
	(defun DeleteSheetText (/ itm)
		(foreach itm (LM:ss->ent (ssget "_X" (list (cons 0 "MTEXT") (cons 8  $LayerDinamicInfoEasyCut) (list -3 (list $InfoMtextSheet)))))
			(if (entget itm) (entdel itm))
		)
	)
	;
	;
	;
	(defun DeleteDefaultText (/ itm)
		(foreach itm (LM:ss->ent (ssget "_X" (list (cons 67 0) (cons 0 "MTEXT") (cons 8  $LayerDinamicInfoEasyCut) (list -3 (list $InfoMtextDefault)))))
			(if (entget itm) (entdel itm))
		)
	)

	;
	;
	;
	(defun DeleteRule (/ itm)
		(foreach itm (LM:ss->ent $Rule)
			(if (entget itm) (entdel itm))
		)
	)
	;
	;
	;
    (defun SaveInfo (/ errore wf)
		(SaveSetupEasyCut (strcat SetupPathEasyCut$ SetupFileEasyCut$) "")
	)
	;
	;
	;
	(defun UnHighlight (LstEnamePicked / itm)
		(foreach itm LstEnamePicked
			(vla-highlight (vlax-ename->vla-object itm) :vlax-false)
		)
	)
	;
	;
	;
    (defun GetEnameMember (Ssel / Rtn)
	
		(if Ssel
			(if (entget (ssname Ssel 0))
				(if (assoc -3 (entget (ssname Ssel 0) (list "*")))
					(progn
						(if (= (nth 0 (nth 1 (assoc -3 (entget (ssname Ssel 0) (list "*"))))) $RgpSheet)
							(progn
								(setq Rtn (list (ssname Ssel 0) nil))
								(UnHighlight $LstEnamePicked)
								(vla-highlight (vlax-ename->vla-object (ssname Ssel 0)) :vlax-true)
								(if (not (member (ssname Ssel 0) $LstEnamePicked)) (setq $LstEnamePicked (append $LstEnamePicked (list (ssname Ssel 0))))) 
							)
						)
						(if (= (nth 0 (nth 1 (assoc -3 (entget (ssname Ssel 0) (list "*"))))) $RgpSheetTarget)
							(progn
								;(setq Rtn (list (GetEnameSheetByName (vl-remove-blanks (nth 1 (GetInfoBlockSheet (ssname Ssel 0))))) nil))
								(setq Rtn (list (GetEnameSheetById (vl-remove-blanks (nth 0 (GetInfoBlockSheet (ssname Ssel 0))))) nil))
								(UnHighlight $LstEnamePicked)
								(vla-highlight (vlax-ename->vla-object (car Rtn)) :vlax-true)
								(if (not (member (car Rtn) $LstEnamePicked)) (setq $LstEnamePicked (append $LstEnamePicked (list (car Rtn))))) 
							)
						)
						
						(if (= (nth 0 (nth 1 (assoc -3 (entget (ssname Ssel 0) (list "*"))))) $RgpShape)
							(progn
								(setq Rtn (list nil (ssname Ssel 0)))
								(UnHighlight $LstEnamePicked)
								(vla-highlight (vlax-ename->vla-object (ssname Ssel 0)) :vlax-true)
								(if (not (member (ssname Ssel 0) $LstEnamePicked)) (setq $LstEnamePicked (append $LstEnamePicked (list (ssname Ssel 0))))) 
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
    (defun GetInfoShapeText (EnameShape / LstInfoShape LstDimension Percorrenza Compensa Contorno Weigth1 Weigth2 Rtn)
  
		(if EnameShape
			(progn
				(setq LstInfoShape (GetDataShape EnameShape))
				;		0		1		2		3			4		5				6						7		  8			9		10		11
				;	TypShape IdShape JouShape NameShape CutComp LenghtCut (SlTime ExTime InTime TotTime) ComShape PhaseShape MatShape TkShape DateShape
				(setq LstDimension (GetDimensionShape EnameShape))
				(cond 
					((= (nth 2 LstInfoShape) "0") 	(setq Percorrenza "Contorno Aperto"))
					((= (nth 2 LstInfoShape) "2") 	(setq Percorrenza "Antioraria"))
					((= (nth 2 LstInfoShape) "3") 	(setq Percorrenza "Oraria"))
				)
				(cond 
					((= (nth 4 LstInfoShape) "0") (setq Compensa "Nessuns"))
					((= (nth 4 LstInfoShape) "1") (setq Compensa "Automatica"))
					((= (nth 4 LstInfoShape) "2") (setq Compensa "Destra"))
					((= (nth 4 LstInfoShape) "3") (setq Compensa "Sinistra"))
				)
				(cond
					((= (nth 0 LstInfoShape) "CE") (setq Contorno "Esterno"))
					((= (nth 0 LstInfoShape) "CI") (setq Contorno "Interno"))
				)

				(setq Weigth1 (rtos (* (/ (vla-get-area (vlax-ename->vla-object (GetEnameShapeByDummyEnameSelect EnameShape))) 1000000.0)
										  (atof (nth 10 LstInfoShape)) 7.85) 2 2))
				(setq Weigth2 (rtos (* (/ (vla-get-area (vlax-ename->vla-object EnameShape)) 1000000.0)
										  (atof (nth 10 LstInfoShape)) 7.85) 2 2))
				
				(if (= (nth 0 LstInfoShape) "CI")
					(setq Weigth2 (strcat "-" Weigth2))
				)
				
				(setq Rtn (strcat 	"{\\Fromans|c0;\\W0.8;"
									"\\C2\[INFO GENERALI CONTORNO]"										
									"\n\\C1;Commessa\t\t\t\t\\C7;"				(nth 7 LstInfoShape)
									"\n\\C1;Fase\t\t\t\t\t\\C7;"	 			(nth 8 LstInfoShape)
									"\n\\C1;Marca\t\t\t\t\t\\C7;" 				(nth 3 LstInfoShape)
									"\n\\C1;Lunghezza (mm)\t\t\t\\C7;" 			(rtos (nth 0 (nth 1 LstDimension)) 2 1)
									"\n\\C1;Altezza (mm)\t\t\t\\C7;" 			(rtos (nth 1 (nth 1 LstDimension)) 2 1)
									"\n\\C1;Spessore (mm)\t\t\t\\C7;" 			(nth 10 LstInfoShape)
                					"\n\\C1;Peso (kq)\t\t\t\t\\C7;" 			Weigth1
                                    "\n\\C1;Qualita'\t\t\t\t\\C7;" 				(nth 9 LstInfoShape)
									"\n\\C1;Velocita' taglio (mm/min)\t\\C7;"	(rtos (GetSpeedCut EnameShape) 2 1)
									"\n\\C1;Tempo contorno esterno\t\t\\C7;" 	(nth 1 (nth 6 LstInfoShape))
									"\n\\C1;Tempo contorno interno\t\t\\C7;" 	(nth 2 (nth 6 LstInfoShape))
									"\n\\C1;Tempo contorno attacchi\t\t\\C7;" 	(nth 3 (nth 6 LstInfoShape))
									"\n\\C1;Tempo totale\t\t\t\\C7;" 			(nth 4 (nth 6 LstInfoShape))
									"\n"
                                    "\n\\C2;[INFO SELEZIONE CONTORNO]\\l"										
									"\n\\C1;ID\t\t\t\t\t\\C252;" 				(vl-princ-to-string EnameShape)
									"\n\\C1;Id Selezione\t\t\t\t\\C252;"		(nth 1 LstInfoShape)										
                                    "\n\\C1;Tipo contorno\t\t\t\\C252;" 		Contorno
									"\n\\C1;Percorrenza taglio\t\t\t\\C252;" 	percorrenza
                                    "\n\\C1;Compensazione torcia\t\t\\C252;" 	Compensa
                                    "\n\\C1;Perimetro percorrenza\t\t\\C252;" 	(nth 5 LstInfoShape)
									"\n\\C1;Peso (kq)\t\t\t\t\\C252;" 			Weigth2
                                    "\n\\C1;Ultima modifica\t\t\t\\C252;" 		(nth 11 LstInfoShape)
								)
                )
            )
		)
		(if (not Rtn)	
			"{\\fArial|b0|i0|c0|p34;\\C2;[Ricerca]"
			Rtn
		)
	)
	;
	;
	;
    (defun GetInfoSheetText (EnameSheet / LstInfoSheet LstEnameSheet LstEnameSequence Rtn Num itm Pt LstInfo LstGrpSequence)
  
		(if EnameSheet
			(cond
				((= $StatusSheet 0)
					(setq LstInfoSheet (GetDataSheetByEname EnameSheet))
					;	  0		   1		  2		    3 			4		   5			6		  7
					;  IdSheet NameSheet Widthsheet HeightSheet ThickSheet SurfaceSheet WeightSheet MatSheet))
					;
					(if LstInfoSheet 
						(setq 	Rtn (strcat 	"{\\Fromans|c0;\\W0.8;"
												"\\C2;[INFO SELEZIONE LAMIERA]\\l"										
												"\n\\C1;ID\t\t\t\\C252;" 					(vl-princ-to-string EnameSheet)
												"\n\\C1;Id Selezione\t\t\\C252;"			(nth 0 LstInfoSheet)
												"\n\\C1;Nome\t\t\t\\C252;"					(nth 1 LstInfoSheet)
												"\n\\C1;Lunghezza (mm)\t\\C252;" 			(nth 2 LstInfoSheet)
												"\n\\C1;Altezza (mm)\t\\C252;" 				(nth 3 LstInfoSheet)
												"\n\\C1;Spessore (mm)\t\\C252;" 			(nth 4 LstInfoSheet)
												"\n\\C1;Superficie (mq)\t\\C252;" 			(nth 5 LstInfoSheet)
												"\n\\C1;Peso (kg)\t\t\\C252;" 				(nth 6 LstInfoSheet)
												"\n\\C1;Materiale\t\t\\C252;" 				(nth 7 LstInfoSheet) "}"
								)
						)
					)
				)
				((= $StatusSheet 1)
					(setq LstEnameSheet     (GetEnameShapeByEnameSheet EnameSheet "CE"))
					(setq LstEnameSequence  (mapcar (function (lambda (x) (car (GetShapeByGroup x)))) 
													(cdr (GetSequenceGroupOnSheet EnameSheet))
											)
					)
					; Sequence ++++++++					
					(setq Num 1)
					(foreach itm LstEnameSequence
						(if itm
							(progn
								(setq Pt 		(LM:PolyCentroid itm))
								(setq LstInfo	(strcat "{\\Fromans|c0;\\W0.8;\\C3;" (rtos Num 2 0) "}"))
								(setq Rtn (append Rtn (list (list Pt LstInfo))))
								(setq Num (1+ Num))
							)
						)
					)
					; No Sequence ++++++
					(foreach itm LstEnameSheet
						(if (not (member itm LstEnameSequence))
							(progn
								(setq Pt 		(LM:PolyCentroid itm))
								(setq LstInfo	"{\\Fromans|c0;\\W0.8;\\C1;[0]}")
								(setq Rtn (append Rtn (list (list Pt LstInfo))))
							)
						)
					)
				)
				((= $StatusSheet 2)
					(setq LstEnameSheet     (GetEnameShapeByEnameSheet EnameSheet "CE"))
					(setq LstEnameSequence  (mapcar (function (lambda (x) (car (GetShapeByGroup x)))) 
													(cdr (GetSequenceGroupOnSheet EnameSheet))
											)
					)
					; Sequence ++++++++					
					(foreach itm LstEnameSequence
						(if itm
							(progn
								(setq Pt 		(LM:PolyCentroid itm))					
								(setq LstInfo	(strcat "{\\Fromans|c0;\\W0.8;"
														"\\C3;"		(GetComShape   itm)
														"\n\\C3;"	(GetPhaseShape itm)
														"\n\\C3;" 	(GetNameShape  itm)
														"}"))
								(setq Rtn (append Rtn (list (list Pt LstInfo))))													
							)					
						)
					)
					; No Sequence ++++++
					(foreach itm LstEnameSheet
						(if (not (member itm LstEnameSequence))
							(progn
								(setq Pt 		(LM:PolyCentroid itm))					
								(setq LstInfo	(strcat "{\\Fromans|c0;\\W0.8;"
														"\\C1;"		(GetComShape   itm)
														"\n\\C1;"	(GetPhaseShape itm)
														"\n\\C1;" 	(GetNameShape  itm)
														"}"))
								(setq Rtn (append Rtn (list (list Pt LstInfo))))													
							)
						)
					)
				)
			)
		)
		;(if (not Rtn)	
		;	"{\\fArial|b0|i0|c0|p34;\\C2;[Ricerca]"
		;	Rtn
		;)
		Rtn
    )
	
	;
	;
	;
    (defun MakeTextDefault   (Text pstart HText / MakeDxfList 
												 Pt offsetx offsety itm)
	
		(defun MakeDxfList (Text Pt Htext Giustificato)
		
			(if (and Text Pt Htext)
				(list	(cons 0 "MTEXT")                              
						(cons 100 "AcDbEntity")
						(cons 100 "AcDbMText")
						(cons 8   $LayerDinamicInfoEasyCut)
						(cons 1  Text)
						(cons 10 Pt)
						(cons 40 HText)
						(cons 50 0.0)
						(cons 62 71)
						(cons 71 Giustificato)
						(cons 90 3)
						;(cons 90 19)
						(cons 63 9)
						(cons 421 13158600)
						(cons 441 9434636)
						(cons 210 (list 0.0 0.0 1.0))
						(cons 11 (list 1.0 0.0 0.0))
						(list -3 (list $InfoMtextDefault '(1002 . "{") '(1002 . "}")))
				)
			)
		)
		;
		;
		;
		(Reset)
		;(DeleteRule)
		(if (and Text HText)
			(setq 	offsetx (*  HText 2.0)
					offsety HText
					Pt (trans (list (+ (nth 0 pstart) offsetx) (- (nth 1 pstart) offsety)) 1 0)
					TextDefault$ 	(entmakex (MakeDxfList Text Pt Htext 1))
			)
		)
	)
	;
	;
	;
    (defun MakeTextShape (Text pstart HText / MakeDxfList
											 MakeRectngleMtext
											 Pt offsetx offsety itm)
	
		(defun MakeDxfList (Text Pt Htext Giustificato)
			(if (and Text Pt Htext)
				(list	(cons 0 "MTEXT")                              
						(cons 100 "AcDbEntity")
						(cons 100 "AcDbMText")
						(cons 8   $LayerDinamicInfoEasyCut)
						(cons 1  Text)
						(cons 10 Pt)
						(cons 40 HText)
						(cons 50 0.0)
						(cons 62 71)
						(cons 71 Giustificato)
						;(cons 90 3)
						(cons 90 19)
						(cons 63 9)
						(cons 421 13158600)
						(cons 441 9434636)
						(cons 210 (list 0.0 0.0 1.0))
						(cons 11 (list 1.0 0.0 0.0))
						(cons 45 1.5)
						(list -3 (list $InfoMtextShape '(1002 . "{") '(1002 . "}")))
				)
			)
		)
		;
		;
		;
		(if (and Text HText)
			(cond
				((= $StatusShape 0)
					(DeleteShapeText)
					(DeleteDefaultText)
					
					(if (= $StatusSheet 0)
						(DeleteSheetText)
					)

					(setq 	offsetx (*  HText 2.0)
							offsety HText
							Pt (trans (list (+ (nth 0 pstart) offsetx) (- (nth 1 pstart) offsety)) 1 0)
					)
					(entmakex (MakeDxfList Text Pt Htext 1))
				)
				(t
					nil
				)
			)
		)
	)
    ;
    ;
    ;
    (defun MakeTextSheet (Text pstart HText  / MakeDxfList MakeRectangleMtext 
													 Pt offsetx offsety itm)
	
		(defun MakeDxfList (Text Pt Htext Giustificato)
			(if (and Text Pt Htext)
				(list	(cons 0 "MTEXT")                              
						(cons 100 "AcDbEntity")
						(cons 100 "AcDbMText")
						(cons 8   $LayerDinamicInfoEasyCut)
						(cons 1  Text)
						(cons 10 Pt)
						(cons 40 HText)
						(cons 50 0.0)
						(cons 62 71)
						(cons 71 Giustificato)
						;(cons 90 3)
						(cons 90 19)
						(cons 63 9)
						(cons 421 13158600)
						(cons 441 9434636)
						(cons 210 (list 0.0 0.0 1.0))
						(cons 11 (list 1.0 0.0 0.0))
						(cons 45 1.5)
						(list -3 (list $InfoMtextSheet '(1002 . "{") '(1002 . "}")))
				)
			)
		)
		;
		;
		;

		(if (and Text HText)
			(progn
				(setq 	offsetx (*  HText 2.0)
						offsety HText
						Pt (list (+ (nth 0 pstart) offsetx) (- (nth 1 pstart) offsety))
				)
				(cond
					((= $StatusSheet 0)
						(DeleteSheetText)
						(DeleteShapeText)
						(DeleteDefaultText)
						;(DeleteRule)
						(entmakex (MakeDxfList Text Pt Htext 1))
					)
					((= $StatusSheet 1)
						;
						; range H Text +++++++++++
						;
						;(setq HText 30.0)
						(DeleteSheetText)
						(DeleteShapeText)
						(DeleteDefaultText)
						;(DeleteRule)
						(if (= (Type Text) 'LIST)
							(foreach itm Text
								(entmakex (MakeDxfList (cadr itm) (car itm) Htext 5))
							)
							(entmakex (MakeDxfList Text Pt Htext 1))
						)
					)
					((= $StatusSheet 2)
						;
						; range H Text +++++++++++
						;
						;(setq HText 30.0)
						(DeleteSheetText)
						(DeleteShapeText)
						(DeleteDefaultText)
						;(DeleteRule)
						(if (= (Type Text) 'LIST)
							(foreach itm Text
								(entmakex (MakeDxfList (cadr itm) (car itm) Htext 5))
							)
							(entmakex (MakeDxfList Text Pt Htext 1))
						)
					)
				)
			)
		)
	)
	;
	;
	;
    (defun DataRuler (p1 p2 / cl1 cl2 cl3 al1 al2 al3 pm dist ndiv pa pb cos_dir paa pbb erule lista_out)

          (setq cl1 7)    ; colore laterale
          (setq cl2 2)    ; colore centrale
          (setq cl3 8)    ; colore intermedio
          (setq al1 30.0) ; altezza laterale
          (setq al2 20.0) ; altezza centrale
          (setq al3 60.0) ; altezza intermedia
   
          (setq pm   (div (nth 0 p1) (nth 1 p1) (nth 0 p2) (nth 1 p2) 1))
          (setq lista_out nil)
          (setq dist (distance p1 (nth 0 pm)))
          (setq ndiv (fix (/ dist  (/ (getvar 'VIEWSIZE) 50.0))))
          (setq pa   (div  (nth 0 p1) (nth 1 p1) (nth 0 (nth 0 pm)) (nth 1 (nth 0 pm)) ndiv))
          (setq pb   (div  (nth 0 (nth 0 pm)) (nth 1 (nth 0 pm)) (nth 0 p2) (nth 1 p2) ndiv))
          


          (setq paa p1)
          (setq pbb (per (nth 0 p2) (nth 1 p2) (nth 0 paa) (nth 1 paa) (* (/ (getvar 'VIEWSIZE) al1) -1.0)))
          (setq erule (entmakex (list (cons 0 "LINE")
                                      (cons 100 "AcDbEntity")
                                      (cons 67 0)
                                      (cons 8 $LayerDinamicInfoEasyCut)
                                      (cons 62 cl1)
                                      (cons 100 "AcDbLine")
                                      (cons 10 (trans paa 1 0)) (cons 11 (trans pbb 1 0)) (cons 210 (list 0.0 0.0 1.0)))))
          (if erule (setq lista_out (append lista_out (list erule))))
          (setq paa p2)
          (setq pbb (per (nth 0 p1) (nth 1 p1) (nth 0 paa) (nth 1 paa) (/ (getvar 'VIEWSIZE) al1)))
          (setq erule (entmakex (list (cons 0 "LINE")
                                      (cons 100 "AcDbEntity")
                                      (cons 67 0)
                                      (cons 8 $LayerDinamicInfoEasyCut)
                                      (cons 62 cl1)
                                      (cons 100 "AcDbLine")
                                      (cons 10 (trans paa 1 0)) (cons 11 (trans pbb 1 0)) (cons 210 (list 0.0 0.0 1.0)))))
          (if erule (setq lista_out (append lista_out (list erule))))
          (setq paa (nth 0 pm))
          (setq pbb (per (nth 0 p1) (nth 1 p1) (nth 0 paa) (nth 1 paa) (/ (getvar 'VIEWSIZE) al2)))
          (setq erule (entmakex (list (cons 0 "LINE")
                                      (cons 100 "AcDbEntity")
                                      (cons 67 0)
                                      (cons 8 $LayerDinamicInfoEasyCut)
                                      (cons 62 cl2)
                                      (cons 100 "AcDbLine")
                                      (cons 10 (trans paa 1 0)) (cons 11 (trans pbb 1 0)) (cons 210 (list 0.0 0.0 1.0)))))   
          (if erule (setq lista_out (append lista_out (list erule))))
  

          (foreach co pa
                (setq paa co)
                (setq pbb (per (nth 0 p1) (nth 1 p1) (nth 0 paa) (nth 1 paa) (/ (getvar 'VIEWSIZE) al3)))
                (setq erule (entmakex (list (cons 0 "LINE")
                                            (cons 100 "AcDbEntity")
                                            (cons 67 0)
                                            (cons 8 $LayerDinamicInfoEasyCut)
                                            (cons 62 cl3)
                                            (cons 100 "AcDbLine")
                                            (cons 10 (trans paa 1 0)) (cons 11 (trans pbb 1 0)) (cons 210 (list 0.0 0.0 1.0)))))   
               (if erule (setq lista_out (append lista_out (list erule))))
          )
          (foreach co pb
                (setq paa co)
                (setq pbb (per (nth 0 p1) (nth 1 p1) (nth 0 paa) (nth 1 paa) (/ (getvar 'VIEWSIZE) al3)))
                (setq erule (entmakex (list (cons 0 "LINE")
                                            (cons 100 "AcDbEntity")
                                            (cons 67 0)
                                            (cons 8 $LayerDinamicInfoEasyCut)
                                            (cons 62 cl3)
                                            (cons 100 "AcDbLine")
                                            (cons 10 (trans paa 1 0)) (cons 11 (trans pbb 1 0)) (cons 210 (list 0.0 0.0 1.0)))))   
                (if erule (setq lista_out (append lista_out (list erule))))
          )
          lista_out
    )
    ;
    ;
    ;
    (defun MakeRule (EnameShape /  min_x_box_dim max_x_box_dim min_y_box_dim max_y_box_dim pbox1 box2 pbox3 pbox4
                                   eruler1 eruler2 eruler3 eruler4)

		(DeleteRule)
		
		(if EnameShape
			(progn
				(setq box_dim (ucs-bbox EnameShape))
				(setq 	min_x_box_dim (- (nth 0 (nth 0 box_dim)) (/ (getvar 'VIEWSIZE) 70.0))
						min_y_box_dim (- (nth 1 (nth 0 box_dim)) (/ (getvar 'VIEWSIZE) 70.0))
						max_x_box_dim (+ (nth 0 (nth 1 box_dim)) (/ (getvar 'VIEWSIZE) 70.0))
						max_y_box_dim (+ (nth 1 (nth 1 box_dim)) (/ (getvar 'VIEWSIZE) 70.0))
					
						pbox1 (trans (list min_x_box_dim min_y_box_dim 0.0) 1 0)
						pbox2 (trans (list max_x_box_dim min_y_box_dim 0.0) 1 0)
						pbox3 (trans (list max_x_box_dim max_y_box_dim 0.0) 1 0)
						pbox4 (trans (list min_x_box_dim max_y_box_dim 0.0) 1 0)
				)

				(setq eruler1   (DataRuler (list min_x_box_dim max_y_box_dim 0.0) (list max_x_box_dim max_y_box_dim 0.0)))
				(setq eruler2   (DataRuler (list max_x_box_dim max_y_box_dim 0.0) (list max_x_box_dim min_y_box_dim 0.0)))
				(setq eruler3   (DataRuler (list max_x_box_dim min_y_box_dim 0.0) (list min_x_box_dim min_y_box_dim 0.0)))
				(setq eruler4   (DataRuler (list min_x_box_dim min_y_box_dim 0.0) (list min_x_box_dim max_y_box_dim 0.0)))
			)
		)


		(setq $Rule (ssadd))
	  
		(foreach ent eruler1 (ssadd ent $Rule))
        (foreach ent eruler2 (ssadd ent $Rule))
        (foreach ent eruler3 (ssadd ent $Rule))
 		(foreach ent eruler4 (ssadd ent $Rule))
 
    )
	
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;                         MAIN
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	(setq ViewSize_apertura (GetSizeAperture))
	(setq ViewSize_htxt     (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
	(setq gr (grread t 15 2) code (car gr) data (cadr gr))

	(setq 	msgLstShape		 (list 	"\r[+/- Dimensione testo  ] Click su piatto per info...")
			msgLstShapeMouse (list 	"{\\fArial|b0|i0|c0|p34;\\C2;------}")
			$StatusShape 		0
	)
	(setq 	msgLstSheet		 (list 	"\r[TAB Mode Info Sheet   ] [+/- Dimensione testo ] Click su lamiera per info..."
									"\r[TAB Mode Info Sequence] [+/- Dimensione testo ] Click su lamiera per info..."
									"\r[TAB Mode Info Shape   ] [+/- Dimensione testo ] Click su lamiera per info...")
			msgLstSheetMouse (list 	"{\\fArial|b0|i0|c0|p34;\\C2;------}"
									"{\\fArial|b0|i0|c0|p34;\\C2;[Sequenza vuota]}"
									"{\\fArial|b0|i0|c0|p34;\\C2;[Nessun pezzo presente]}")
			$StatusSheet 		0
	)
	(princ "\rSeleziona ...")
		
   	(setq TextDefault "{\\fArial|b0|i0|c0|p34;\\C2;[Ricerca]}")
	(MakeTextDefault TextDefault data ViewSize_htxt)
	(setq DataPost Data)
	(setq ViewCtr (getvar "viewctr"))

	(while

		(setq ViewSize_apertura (GetSizeAperture))
		(setq ViewSize_htxt     (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
        (setq gr (grread t 15 2) code (car gr) data (cadr gr))

        (cond
			((and (= code 3) (listp data))            ; Left click mouse
		   
				(setq EnameMember  (GetEnameMember (ssget "_C" (list (- (nth 0 data) (/ ViewSize_apertura 2.0)) (- (nth 1 data) (/ ViewSize_apertura 2.0))) 
															   (list (+ (nth 0 data) (/ ViewSize_apertura 2.0)) (+ (nth 1 data) (/ ViewSize_apertura 2.0))))))
				
				(if (car EnameMember)	; Sheet
					(progn
						(setq TextInfoSheet (GetInfoSheetText (car EnameMember)))
						(if TextInfoSheet 
							(MakeTextSheet TextInfoSheet data ViewSize_htxt)
							(MakeTextDefault (nth $StatusSheet msgLstSheetMouse) data ViewSize_htxt)
						)
						(princ (nth $StatusSheet msgLstSheet))
					)
				)
				
				(if (cadr EnameMember)	; Shape
					(progn
						(setq TextInfoShape (GetInfoShapeText (cadr EnameMember)))
						(MakeTextShape TextInfoShape data ViewSize_htxt)
						;(MakeRule (cadr EnameMember))
						(princ (nth $StatusShape msgLstShape))
					)
				)
				
				(if (not EnameMember)
					(progn
						(MakeTextDefault TextDefault data ViewSize_htxt)
						(UnHighlight $LstEnamePicked)
					)
				)
			)		   
		   
			((and (= code 5) (listp data))            	; Mouse rolling
				(setq NewViewCtr (getvar "viewctr"))	; ++++++++++++++++++++++++++++++++++
				(cond
					((= (equal NewViewCtr ViewCtr) T)
						;(princ "\nRooling")
						(if (not (equal Data DataPost))
							(progn
								(setq ViewSize_htxt (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
								
								(if (car EnameMember)	; Sheet
									(if TextInfoSheet
										(if (= $StatusSheet 0) (MakeTextSheet TextInfoSheet DataPost ViewSize_htxt))
										(MakeTextDefault (nth $StatusSheet msgLstSheetMouse) DataPost ViewSize_htxt)
									)
								)
								
								(if (cadr EnameMember)	; Shape
									(MakeTextShape TextInfoShape data ViewSize_htxt)
								)
								
								(if (not EnameMember)
									(MakeTextDefault TextDefault data ViewSize_htxt)
								)
								
								(setq DataPost Data)
							)
						)
					)
					(t
						;(princ "\nZoom")
						(setq ViewSize_htxt (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
						;(if (cadr EnameMember)
						;	(MakeRule (cadr EnameMember))
						;)
					)
				)
				(setq ViewCtr NewViewCtr)				; ++++++++++++++++++++++++++++++++++
			)

			((and (= code 2) (= data 43)) 
				(setq $HTextDinamicInfoEasyCut (1- $HTextDinamicInfoEasyCut))
				(setq ViewSize_htxt (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
				
				(if (car EnameMember)	; Sheet
					(if TextInfoSheet
							(MakeTextSheet TextInfoSheet DataPost ViewSize_htxt)
							(MakeTextDefault (nth $StatusSheet msgLstSheetMouse) DataPost ViewSize_htxt)
					)
					;(MakeTextSheet TextInfoSheet DataPost ViewSize_htxt)
				)
				(if (cadr EnameMember)	; Shape
					(MakeTextShape TextInfoShape DataPost ViewSize_htxt)
				)
			)
			
			((and (= code 2) (= data 45)) 
				(setq $HTextDinamicInfoEasyCut (1+ $HTextDinamicInfoEasyCut))
				(setq ViewSize_htxt (/ (getvar 'VIEWSIZE) $HTextDinamicInfoEasyCut))
				
				(if (car EnameMember)	; Sheet
					(if TextInfoSheet
							(MakeTextSheet TextInfoSheet DataPost ViewSize_htxt)
							(MakeTextDefault (nth $StatusSheet msgLstSheetMouse) DataPost ViewSize_htxt)
					)
					;(MakeTextSheet TextInfoSheet DataPost ViewSize_htxt)
				)
				(if (cadr EnameMember)	; Shape
					(MakeTextShape TextInfoShape DataPost ViewSize_htxt)
				)
			)
			;
			; Tab key -------------------------------------------------------------------------------------------------
			;
			((and (= code 2) (= data 9))                
				(if (car EnameMember)					; Sheet
					(progn
						(setq $StatusSheet (1+ $StatusSheet))
						(if (= $StatusSheet 3) (setq $StatusSheet 0))
						
						(setq TextInfoSheet (GetInfoSheetText (car EnameMember)))
						
						(if TextInfoSheet
							(MakeTextSheet TextInfoSheet DataPost ViewSize_htxt)
							(MakeTextDefault (nth $StatusSheet msgLstSheetMouse) DataPost ViewSize_htxt)
						)
						(princ (nth $StatusSheet msgLstSheet))
					)
				)
				(if (cadr EnameMember)					; Shape
					(princ (nth $StatusShape msgLstShape))
				)
			)
        )
    )
)
;
;
;
(defun test (/ Pos)
	(setq Pos 0)
	(while
		(setq gr (grread 't 15 0) code (car gr) data (cadr gr))
		;(setq gr (grread T) code (car gr) data (cadr gr))
		(princ (strcat "\r" (LM:rtos Pos 2 0)))
		(setq Pos (1+ Pos))
		
		(cond
			((and (= code 5) (listp data)) 
				(princ "Point device \n")
				;(setq code nil)
			)
			((and (= code 3) (listp data)) 
				(princ "Select \n")
				;(setq code nil)
			)
			;(princ "code ") (princ code) (princ " gr ") (princ gr) (terpri)
		)
		(princ "code ") (princ code) (princ " data ") (princ data) (terpri)
		;(princ code) (princ " ") (princ data) (terpri)     
	)
)
;
(defun test (/ Pos)
	(setq Pos 0)
	(while
		;(grread T 8)
		;(grread nil 15 0)
		(grread 5)
		(princ (strcat "\r" (LM:rtos Pos 2 0)))
		(setq Pos (1+ Pos))
	)
)

