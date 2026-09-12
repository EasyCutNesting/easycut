;https://autolisp-exchange.com/Tutorials/MyDialogs.htm#ViewDcl
;
(defun GuiFlex (/ *error* WriteDclFlex SwitchFlexHole LoadGuiFlex SetGuiFlex 
				  SaveOsmode xx GoFlex Ename PtStartFlex PtEndFlex Flex Rtn)
	;
	(defun *error* (msg)
		(setvar 'osmode SaveOsmode)
	)
	;
	(defun WriteDclFlex (/ dcl des x)

        (setq dcl (vl-filename-mktemp nil nil ".dcl"))
        (setq des (open dcl "w"))
		(foreach x
			'(	
				"Flex:dialog"
				"{"
				"    label=\"Flex\";"
				"	:boxed_column {"
				"		label=\"Dati\";"
				"		width = 10;"
				"		fixed_width=true;"
				"		:row {width = 10; fixed_width=true;"
				"			:text{key = \"Text1\"; width = 31;}"
				"			:edit_box {width = 10; edit_width=5; key=\"Flex\";fixed_width = true;}"
				"		}"
				"		:row {"
				"			:toggle {"
				"				fixed_width=true;"
				"				key = \"FlexOnOffHole\";"
				"			}"
				"			:text{key = \"Text2\"; width = 27;}"
				"			:edit_box {width = 10; edit_width=5; key=\"DiamExcludeFrom\";fixed_width = true;}"
				"			:text{key = \"Text3\"; width = 8;}"
				"			:edit_box {width = 10; edit_width=5; key=\"DiamExcludeTo\";fixed_width = true;}" 
				"		}"
				"	}"
				"	:boxed_column {"
				"		label=\"Schema\";"
				"		:image_button {"
				"			key = \"FlexSlide\";"
				"			width = 90;"
				"			height =25;"
				"			color = 0;"
				"			fixed_width = true;"
				"			fixed_height = true;"
				"		}"
				"	}"
				"   ok_cancel;" 
				"}"	
			)
			(write-line x des)
		)
        (setq des (close des))
        dcl
	)

	;
	(defun SwitchFlexHole ()
		(if (= (setq $FlexOnOffHole (get_tile "FlexOnOffHole")) "0")
			(progn
				(mode_tile "DiamExcludeFrom" 1)
				(mode_tile "DiamExcludeTo" 1)
				(mode_tile "Text2" 1)
				(mode_tile "Text3" 1)
			)
			(progn
				(mode_tile "DiamExcludeFrom" 0)
				(mode_tile "DiamExcludeTo" 0)
				(mode_tile "Text2" 0)
				(mode_tile "Text3" 0)
			)
		)
	)
	;
	(defun LoadGuiFlex (/ start_sld_thum x_x y_y x y)
		(setq start_sld_thum (strcat GuiPathEasyCut$ "Flex.sld"))
		(setq x_x 0)
		(setq y_y -15)
		(setq 	x (dimx_tile "FlexSlide")
				y (dimy_tile "FlexSlide")
		)
		(start_image "FlexSlide")
		(fill_image x_x y_y x y -2)
		(slide_image x_x y_y x y start_sld_thum)
		(end_image)
		
		(set_tile "Flex" 			(LM:rtos $Flex 2 2))
		(set_tile "DiamExcludeFrom" (LM:rtos $FlexHoleDiamExcludeFrom 2 1))
		(set_tile "DiamExcludeTo"   (LM:rtos $FlexHoleDiamExcludeTo 2 1))
		
		(set_tile "Text1" "Flessione contorno [mm]")
		(set_tile "Text2" "Escludi flessione diametro da [mm]")
		(set_tile "Text3" "a [mm]")
		
		(set_tile "FlexOnOffHole" $FlexOnOffHole)

		(if (= $FlexOnOffHole "0")
			(progn
				(mode_tile "DiamExcludeFrom" 1)
				(mode_tile "DiamExcludeTo" 1)
				(mode_tile "Text2" 1)
				(mode_tile "Text3" 1)
			)
			(progn
				(mode_tile "DiamExcludeFrom" 0)
				(mode_tile "DiamExcludeTo" 0)
				(mode_tile "Text2" 0)
				(mode_tile "Text3" 0)
			)
		)
	)
	;
	(defun SetGuiFlex (/ Rtn Flex FlexHoleDiamExcludeFrom FlexHoleDiamExcludeTo)
	
		(setq Flex	    				(get_tile "Flex"))
		(setq FlexHoleDiamExcludeFrom	(get_tile "DiamExcludeFrom"))
		(setq FlexHoleDiamExcludeTo		(get_tile "DiamExcludeTo"))

		(if (and (numberp (read Flex))
				 (numberp (read FlexHoleDiamExcludeFrom))
				 (numberp (read FlexHoleDiamExcludeTo))
			)		
			(if (>= FlexHoleDiamExcludeTo FlexHoleDiamExcludeFrom)
				(progn
					(setq $Flex 					(atof Flex))
					(setq $FlexHoleDiamExcludeFrom 	(atof FlexHoleDiamExcludeFrom))
					(setq $FlexHoleDiamExcludeTo	(atof FlexHoleDiamExcludeTo))
					(setq Rtn T)
				)
				(LM:popup "Errore" "Diametro [da] maggiore [a]" (+ 0 16 4096))
			)
		)
		
		(if (not (numberp (read Flex))) 				   (LM:popup "Errore" "Manca il valore della flessione" (+ 0 16 4096)))
		(if (not (numberp (read FlexHoleDiamExcludeFrom))) (LM:popup "Errore" "Manca il valore diametro -> da"  (+ 0 16 4096)))
		(if (not (numberp (read FlexHoleDiamExcludeTo)))   (LM:popup "Errore" "Manca il valore diametro -> a"   (+ 0 16 4096)))
		Rtn
	)
	;
	; Main
	;
	(if (not $FlexOnOffHole) (setq $FlexOnOffHole "0"))
	
	(setq DclFlex (WriteDclFlex))
	(setq xx (load_dialog DclFlex))
	;(setq xx (load_dialog (strcat GuiPathEasyCut$ "Flex.dcl")))
	(new_dialog "Flex" xx "" (cond ( *Flex* ) ( '(-1 -1) )))				
		(LoadGuiFlex)
		(action_tile "FlexOnOffHole" "(SwitchFlexHole)")
		(action_tile "accept"	 (strcat "(if (setq GoFlex (SetGuiFlex)) (progn (setq *Flex* (done_dialog)) (unload_dialog xx) (vl-file-delete DclFlex)))"))
		(action_tile "cancel"    (strcat "(setq *Flex* (done_dialog)) (unload_dialog xx) (vl-file-delete DclFlex)"))
	(start_dialog)
	
	(if GoFlex
		(if	(not (zerop $Flex))
			(if (setq Ename (entsel "\nSeleziona il contorno.."))
				(progn

					(setq SaveOsmode (getvar 'osmode))
					(setvar 'osmode 561)	; Endpoint / Midpoint / Quadrant / Nearest
					(setq PtStartFlex (getpoint "\nPunto iniziale flessione : "))
					(setq PtEndFlex   (getpoint PtStartFlex "\nPunto finale flessione :"))
					(setvar 'osmode SaveOsmode)

					(if (and Ename PtStartFlex PtEndFlex (> (distance PtStartFlex PtEndFlex) 0.0))
						(cond 
							((CheckIfEasyCutShape (car Ename))
								(FlexShape  (car Ename) (trans PtStartFlex 1 0) (trans PtEndFlex 1 0) $Flex)
							)
							(t 
								(FlexEntity (car Ename) (trans PtStartFlex 1 0) (trans PtEndFlex 1 0) $Flex)
							)
						)
					)
				)
			)
		)
	)
)
;
(defun FlexShape (EnameShape PtStartFlex PtEndFlex Flex / FlexPoint FlexInternalShape FlexExternalShape RepositionTriggerShape PutDataFlexShape
														  Acdoc Ename TypeEntity 
														  GrName IdName LstShape)

	
    (defun FlexPoint (WPt PtStartFlex PtEndFlex Flex / DefUcs 
														 UcsName Pt LgAxe Radius x y Fle Alfa Rtn)

		(defun DefUcs (PtStartFlex PtEndFlex / MidPt PerpPt Rtn)
			(if (and PtStartFlex PtEndFlex)
				(progn
					(setq MidPt   (div (car PtStartFlex) (cadr PtStartFlex) (car PtEndFlex)   (cadr PtEndFlex) 1))
					(setq PerpPt  (Per (car PtStartFlex) (cadr PtStartFlex) (car (car MidPt)) (cadr (car MidPt)) 1.0))
					(setq Rtn     (DefPianoPt (car MidPt) PtEndFlex PerpPt))
				)
			)
			Rtn
		)
		;
		; Main
		;
        (if (and WPt PtStartFlex PtEndFlex Flex)
            (progn
				(setq UcsName 	(DefUcs PtStartFlex PtEndFlex))
				(setq Pt 		(TransLPt WPt UcsName))
				(setq LgAxe   	(distance PtStartFlex PtEndFlex))
				(setq Radius	(/ (+ (/ (* LgAxe LgAxe) 4.0) (* (abs Flex) (abs Flex))) (* 2.0 (abs Flex))))
                
				(setq x (car Pt))
                (setq y (cadr Pt))

                (if (> Flex 0.0)
                    (setq Fle  (- Flex (- Radius (sqrt (- (* Radius Radius) (/ (* (* 2.0 (abs x)) (* (abs x) 2.0)) 4.0))))))
                    (setq Fle  (+ Flex (- Radius (sqrt (- (* Radius Radius) (/ (* (* 2.0 (abs x)) (* (abs x) 2.0)) 4.0))))))
                )
                (setq Alfa (asin (/ x Radius)))

                (if (>= Flex 0)
                    (setq Rtn (TransGPt (dca x Fle x (+ y Fle) (- 0.0 Alfa)) UcsName))
                    (setq Rtn (TransGPt (dca x Fle x (+ y Fle) Alfa) 		 UcsName))
                )
            )
        )
    )
	;
	(defun FlexInternalShape (EnameShape PtStartFlex PtEndFlex Flex / Radius Center ModelSpace LstShapeFlex Accuracy)

		(setq Accuracy     0.001)
		(if EnameShape
			(cond 
				((= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
					(if (and (>= (vlax-get (vlax-ename->vla-object EnameShape) 'Diameter) $FlexHoleDiamExcludeFrom)
							 (<= (vlax-get (vlax-ename->vla-object EnameShape) 'Diameter) $FlexHoleDiamExcludeTo)
							 (= $FlexOnOffHole "1")
						)
						(progn
							(setq Radius 	   (vla-get-Radius (vlax-ename->vla-object EnameShape)))
							(setq Center       (vlax-get (vlax-ename->vla-object EnameShape) 'center))
							(setq ModelSpace   (vla-get-modelspace (vla-get-ActiveDocument (vlax-get-acad-object))))
							(setq LstShapeFlex (list (vlax-vla-object->ename (vla-addcircle ModelSpace (vlax-3d-point (FlexPoint Center PtStartFlex PtEndFlex Flex)) Radius))))
						)
						(progn
							(setq LstShapeFlex (MultiLineToPline (LstEname->Ssget (GraphicsFelx (Flex01 EnameShape PtStartFlex PtEndFlex Flex))) Accuracy))
							(if (/= (ClockWeisEname EnameShape) (ClockWeisEname (car LstShapeFlex))) (RevLwpline (car LstShapeFlex)))
						)
					)
				)
				((= (cdr (assoc 0 (entget EnameShape))) "LWPOLYLINE")
					(setq LstShapeFlex (MultiLineToPline (LstEname->Ssget (GraphicsFelx (Flex01 EnameShape PtStartFlex PtEndFlex Flex)))  Accuracy))
					(if (/= (ClockWeisEname EnameShape) (ClockWeisEname (car LstShapeFlex))) (RevLwpline (car LstShapeFlex)))
				)
			)
		)
		LstShapeFlex
	)
	;
	(defun FlexExternalShape (EnameShape PtStartFlex PtEndFlex Flex / LstShapeFlex Accuracy)
	
		(setq Accuracy     0.001)
		(if (and EnameShape PtStartFlex PtEndFlex Flex)
			(progn
				(setq LstShapeFlex (MultiLineToPline (LstEname->Ssget (GraphicsFelx (Flex01 EnameShape PtStartFlex PtEndFlex Flex))) Accuracy))
				(if (/= (ClockWeisEname EnameShape) (ClockWeisEname (car LstShapeFlex))) (RevLwpline (car LstShapeFlex)))
			)
		)
		LstShapeFlex
	)
	;
	(defun RepositionTriggerShape (EnameShape LstTriggerShape PtStartFlex PtEndFlex Flex TypeShape / PtCommonTrigger NewPointTrigger TypeTrigger Rtn)
	
		(if (and EnameShape (car LstTriggerShape) (cadr LstTriggerShape) PtStartFlex PtEndFlex Flex TypeShape)
			(if (setq PtCommonTrigger (GetCommonPointTrigger (car LstTriggerShape) (cadr LstTriggerShape)))
				(cond
					((and (= (cdr (assoc 0 (entget (car LstTriggerShape)))) "LINE") (= (cdr (assoc 0 (entget (cadr LstTriggerShape)))) "LINE"))
						(setq TypeTrigger 1)
					)	
					((and (= (cdr (assoc 0 (entget (car LstTriggerShape)))) "ARC") (= (cdr (assoc 0 (entget (cadr LstTriggerShape)))) "ARC"))
						(setq TypeTrigger 2)
					)	
				)
			)
		)
		(if TypeTrigger
			(setq NewPointTrigger (vlax-curve-getClosestPointTo (vlax-ename->vla-object EnameShape)
																(FlexPoint PtCommonTrigger PtStartFlex PtEndFlex Flex)))
		)
		(MakeManualTrigger EnameShape NewPointTrigger TypeTrigger TypeShape 1)
	)
	;
	(defun PutDataFlexShape (GrName IdName OldEnameShape NewEnameShape / JouShape TypShape)

		(CloneEname OldEnameShape NewEnameShape IdName)
		(setq JouShape    (GetJouShape OldEnameShape))
		(setq TypShape    (GetTypShape OldEnameShape))
		
		; Change Color NewEnameShape
						
		(cond
			((= TypShape "CE")
				(if (= JouShape "3") (vla-put-Color (vlax-ename->vla-object NewEnameShape) $ColorShapeOra))	
				(if (= JouShape "2") (vla-put-Color (vlax-ename->vla-object NewEnameShape) $ColorShapeAntiOra))
			)
			((= TypShape "CI")
				(if (= JouShape "3") (vla-put-Color (vlax-ename->vla-object NewEnameShape) $ColorHoleOra))
				(if (= JouShape "2") (vla-put-Color (vlax-ename->vla-object NewEnameShape) $ColorHoleAntiOra))
			)
		)

		(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) GrName) 'appenditems (list (vlax-ename->vla-object NewEnameShape)))
		(ChDescGroup GrName $RgpShape)
		
		;(if FlexTrigger
		;	(progn
		;		(CloneEname (car  Trigger) (car  FlexTrigger) IdName)
		;		(CloneEname (cadr Trigger) (cadr FlexTrigger) IdName)
		;		(vla-put-Color (vlax-ename->vla-object (car FlexTrigger))  $ColorEntra)
		;		(vla-put-Color (vlax-ename->vla-object (cadr FlexTrigger)) $ColorEsci)
		;
		;		(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) GrName) 
		;					'appenditems 
		;					(list (vlax-ename->vla-object (car FlexTrigger)) (vlax-ename->vla-object (cadr FlexTrigger))))
		;	)
		;)
	)
	;
	; Main +++++
	;
	(setq Acdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
	(vla-StartUndoMark Acdoc)
	(setq GrName (Random_Str 9))
	
	(foreach Ename (GetEnameShape&TriggerByGroup (car (Gnames EnameShape)))
	
		(setq TypeEntity (GetTypeShape Ename))
		;			1  External Shape
		;			2  Internal Shape
		;			3  Trigger In
		;			4  Trigger out

		(setq IdName (Random_Str 9))
		(cond
			((= TypeEntity 1)
				(setq LstShape    (FlexExternalShape Ename PtStartFlex PtEndFlex Flex))
				(PutDataFlexShape GrName IdName Ename (car LstShape))
				(RepositionTriggerShape (car LstShape) (GetEnameTriggerByEnameShape Ename) PtStartFlex PtEndFlex Flex TypeEntity)
			)
			((= TypeEntity 2)
				(setq LstShape 	  (FlexInternalShape Ename PtStartFlex PtEndFlex Flex))
				(PutDataFlexShape GrName IdName Ename (car LstShape))
				(RepositionTriggerShape (car LstShape) (GetEnameTriggerByEnameShape Ename) PtStartFlex PtEndFlex Flex TypeEntity)
			)
		)
	)
	(DeleteShape EnameShape)
	
	(vla-EndUndoMark Acdoc)
	(princ)
)
;
(defun FlexEntity (Ename PtStartFlex PtEndFlex Flex / Rtn Acdoc)

	(setq Acdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
	(vla-StartUndoMark Acdoc)
	(setq Rtn (Flex01 Ename PtStartFlex PtEndFlex Flex))
	(setq Rtn (GraphicsFelx Rtn))
	(vla-EndUndoMark Acdoc)
	Rtn
)
;
(defun Flex01 (EnameShape PtStartFlex PtEndFlex Flex / RotatePoint BuildCoordinate DefUcs DivArc FlexStraightLine FlexArc 
                                                       RemoveCollinear-p MergePointToArc MergePoint
                                                    
                                                       LstCo UcsName itm LgAxe RadiusFlex CenterFlex Num Rtn
                                                      
                                                       MAXLGSG
                                                       PRECI
                                                    
                                                       
                                                       )
    ;
    (defun RotatePoint (Pt Radius Flex / x y Fle Alfa Rtn)

        (if (and Pt Radius Flex)
            (progn
                (setq x (car Pt))
                (setq y (cadr Pt))

                (if (> Flex 0.0)
                    (setq Fle  (- Flex (- Radius (sqrt (- (* Radius Radius) (/ (* (* 2.0 (abs x)) (* (abs x) 2.0)) 4.0))))))
                    (setq Fle  (+ Flex (- Radius (sqrt (- (* Radius Radius) (/ (* (* 2.0 (abs x)) (* (abs x) 2.0)) 4.0))))))
                )
                (setq Alfa (asin (/ x Radius)))

                (if (>= Flex 0)
                    (setq Rtn (dca x Fle x (+ y Fle) (- 0.0 Alfa)))
                    (setq Rtn (dca x Fle x (+ y Fle) Alfa))
                )
            )
        )
    )
    ;
    (defun DefUcs (PtStartFlex PtEndFlex / MidPt PerpPt Rtn)
        (if (and PtStartFlex PtEndFlex)
            (progn
                (setq MidPt   (div (car PtStartFlex) (cadr PtStartFlex) (car PtEndFlex)   (cadr PtEndFlex) 1))
                (setq PerpPt  (Per (car PtStartFlex) (cadr PtStartFlex) (car (car MidPt)) (cadr (car MidPt)) 1.0))
                (setq Rtn     (DefPianoPt (car MidPt) PtEndFlex PerpPt))
            )
        )
        Rtn
    )
    ;
    (defun BuildCoordinate (EnameShape UcsName / Accuracy Shape LstCo Num itm P1 P2 DataArc Rtn)
        
        (setq Accuracy 0.1)
        
        (if (ExistEname EnameShape)
            (cond 
                ((= (cdr (assoc 0 (entget EnameShape))) "LWPOLYLINE")
                    (setq Shape (vlax-vla-object->ename (vla-copy (vlax-ename->vla-object EnameShape))))
                )
                ((= (cdr (assoc 0 (entget EnameShape))) "POLYLINE")
                    (setq Shape (Polyline2LwPolyline EnameShape nil))
                )
                ((= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
                    (setq Shape (Circle2LwPolyline EnameShape nil))
                )
                ((= (cdr (assoc 0 (entget EnameShape))) "ELLIPSE")
                    (setq Shape (Ellipse2LwPolyline EnameShape nil))
                )
            )
        )
        (if Shape
            (progn
                (setq LstCo (LM:lwvertices (entget Shape)))
				;(setq LstCo (lwvertices (entget Shape)))
                ;(if (= (vla-get-closed  (vlax-ename->vla-object Shape)) :vlax-true)
				(if (= (cdr (assoc 70 (entget Shape))) 1)
                    (if (not (equal (cdr (car (nth 0 LstCo))) (cdr (car (nth 0 (reverse LstCo)))) Accuracy))
                        (setq LstCo (append LstCo (list (car LstCo))))
                    )
                )
                (entdel Shape)

                (setq Num 0)
                
                (repeat (- (length LstCo) 1)
                    (if UcsName
                        (setq P1 (TransLPt (cdr (car (nth Num LstCo)))      UcsName)
                              P2 (TransLPt (cdr (car (nth (1+ Num) LstCo))) UcsName)
                        )
                        (setq P1 (cdr (car (nth Num LstCo)))
                              P2 (cdr (car (nth (1+ Num) LstCo)))
                        )
                    )
                    
                    (setq Rtn (append Rtn (list (list P1 P2 (cdr (cadddr (nth Num LstCo)))))))
                    (setq Num (1+ Num))
                )
            )
        )
        Rtn
    )
    ;
    (defun DivArc (DataArc / ModelSpace InfoArc Obj Rtn ActArrowArcDivision AngleArc Arrow)
    
        (if DataArc
            (progn
                (setq ModelSpace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
                (setq InfoArc    (LM:Bulge->Arc (car DataArc) (cadr DataArc) (caddr DataArc))) ; -> (<center> <start angle> <end angle> <radius>)
                
                (setq Obj        (vla-addArc ModelSpace (vlax-3d-point (nth 0 InfoArc)) 
                                                        (nth 3 InfoArc) 
                                                        (nth 1 InfoArc) (nth 2 InfoArc)))
				
				(setq AngleArc (vla-get-totalAngle Obj))
				(setq Arrow (* (nth 3 InfoArc) (- 1.0 (cos (/ AngleArc 2.0)))))
				
				(setq ActArrowArcDivision $ArrowArcDivision)
				
				(if (< Arrow $ArrowArcDivision)
					(setq $ArrowArcDivision (/ Arrow 2.0))
				)
				;(cond
				;	((<= (nth 3 InfoArc) 7.5)
				;		(setq $ArrowArcDivision 0.1)
				;	)
				;	((<= (nth 3 InfoArc) 12.5)
				;		(setq $ArrowArcDivision 0.1)
				;	)
				;	((<= (nth 3 InfoArc) 17.5)
				;		(setq $ArrowArcDivision 0.1)
				;	)
				;	((<= (nth 3 InfoArc) 22.5)
				;		(setq $ArrowArcDivision 0.1)
				;	)
				;)
				
                (if (setq Rtn (GetPtDivArc Obj))
                    (progn
						(setq $ArrowArcDivision ActArrowArcDivision)
                        (setq Rtn (append (list (vlax-get Obj 'StartPoint)) Rtn (list (vlax-get Obj 'EndPoint))))
                        (if (< (caddr DataArc) 0)
                            (setq Rtn (reverse Rtn))
                        )
                    )
					(setq $ArrowArcDivision ActArrowArcDivision)
                )
                (DeleteObject (list Obj))
            )
        )
        Rtn
    )
    ;
    (defun FlexStraightLine (DataStraighLine RadiusFlex CenterFlex Flex Precision MaxLengthSeg / NewPtIni NewPtFin NewRadiusFlex Ndiv PtDiv Rtn)
    
        (if (and DataStraighLine RadiusFlex CenterFlex Flex Precision MaxLengthSeg)
            (progn
                (setq P1 (car  DataStraighLine))
                (setq P2 (cadr DataStraighLine))

                (setq NewPtIni  (RotatePoint P1 RadiusFlex Flex))
                (setq NewPtFin  (RotatePoint P2 RadiusFlex Flex))

                (cond
                    ((equal (cadr P1) (cadr P2) Precision)                              ;   +++++++++++++++++   segmento orizzontale
                        (setq NewRadiusFlex (distance NewPtIni CenterFlex))
                        (if (LM:ListClockwise-p (list CenterFlex NewPtIni NewPtFin))
                            (setq NewRadiusFlex (- 0.0 NewRadiusFlex))
                        )
                        (setq Rtn (append Rtn (list (list NewPtIni NewPtFin NewRadiusFlex CenterFlex))))
                    )
                    ((equal (car P1) (car P2) Precision)                                ;   +++++++++++++++++   segmento verticale
                        (setq Rtn (append Rtn (list (list NewPtIni NewPtFin nil nil))))
                    )
                    (t                                                                  ;   +++++++++++++++++   segmento generico
                        (setq Ndiv  (fix (/ (distance P1 P2) MaxLengthSeg)))
                        (setq PtDiv (append (list P1) (Div (car P1) (cadr P1) (car P2) (cadr P2) Ndiv) (list P2)))
                        (setq Rtn   (append Rtn (MergePointToArc (mapcar '(lambda (x) (RotatePoint x RadiusFlex Flex)) PtDiv))))
                        ;(setq Rtn   (append Rtn (MergePoint (mapcar '(lambda (x) (RotatePoint x RadiusFlex Flex)) PtDiv))))
                    )
                )
            )
        )
        Rtn
    )
    ;
    (defun FlexArc (DataArc RadiusFlex CenterFlex Flex / itm LstCo)
    
        (if (and DataArc RadiusFlex CenterFlex Flex)
            (foreach itm (DivArc DataArc)
                (setq LstCo (append LstCo (list (RotatePoint itm RadiusFlex Flex))))
            )
        )
        (MergePointToArc LstCo)
        ;(MergePoint LstCo)
    )
    ;
    (defun RemoveCollinear-p (LstPt Accuracy / Loop Pos P1 P2 P3)
        (setq Loop T)
        (setq Pos 0)
        (if LstPt
            (while Loop
                (setq P1 (nth (+ Pos 0) LstPt))
                (setq P2 (nth (+ Pos 1) LstPt))
                (setq P3 (nth (+ Pos 2) LstPt))
                (if (and P1 P2 P3)
                    (progn
                        (if (LM:Collinear-p P1 P2 P3 Accuracy)
                            (progn
                                (setq LstPt (LM:RemoveNth (+ Pos 1) LstPt))
                                (setq LstPt (RemoveCollinear-p LstPt Accuracy))
                            )
                        )
                        (setq Pos (1+ Pos))
                    )
                    (setq Loop nil)
                )
            )
        )
        LstPt
    )
    ;
    (defun MergePointToArc (LstPt / ReBuildCoordinate
                                    MinDist AccuracyCollinear 
                                    Loop Pos P1 P2 P3 InfoCircle Center Radius TmpArc Px Rtn)


        ;
        (defun ReBuildCoordinate (LstPt / itm PtIni PtFin InfoCircle Center Radius Rtn)
            (foreach itm LstPt
                (cond 
                    ((> (length itm) 2)
                        (setq PtIni (car itm))
                        (setq PtFin (nth (- (length itm) 1) itm))
                        
                        (setq InfoCircle (LM:3pcircle Ptini (cadr itm) PtFin))
                        (setq Center     (car  InfoCircle))
                        (setq Radius     (cadr InfoCircle))
                        (if (LM:ListClockwise-p (append (list Center) itm))
                            (setq Radius (- 0.0 Radius))
                        )
                        (setq Rtn (append Rtn (list (list PtIni PtFin Radius Center))))                 
                    )
                    (t
                        (setq Rtn (append Rtn (list (list (car itm) (cadr itm) nil nil))))
                    )
                )
            )
            Rtn
        )
        ;
        ; Main ++++++
        ;
        (setq MinDist 1.0)
        (setq AccuracyCollinear 0.01)
        
        (setq LstPt (RemoveCollinear-p LstPt AccuracyCollinear))
        (if LstPt 
            (if (> (length LstPt) 2)
                (progn
                    (setq Pos 0)
                    (setq P1 (nth (+ Pos 0) LstPt))
                    (setq P2 (nth (+ Pos 1) LstPt))
                    (setq P3 (nth (+ Pos 2) LstPt))
                    (setq InfoCircle (LM:3pcircle P1 P2 P3))
                    (setq TmpArc (list P1 P2 P3))
                    (setq Pos (+ Pos 3))
                    (setq Loop T)

                    (while Loop

                        (if (setq Px (nth Pos LstPt))
                            (if (<= (abs (- (distance Px (car InfoCircle)) (cadr InfoCircle))) MinDist)
                                (progn
                                    (setq TmpArc (append TmpArc (list Px)))
                                    (setq InfoCircle (LM:3pcircle P1 P2 Px))
                                    (setq Pos (1+ Pos))
                                )
                                (progn
                                    (setq Rtn (append Rtn (list TmpArc)))
                                    (setq TmpArc nil)
                                    (setq Pos (- Pos 1))
                                    (setq P1 (nth (+ Pos 0) LstPt))
                                    (setq P2 (nth (+ Pos 1) LstPt))
                                    (setq P3 (nth (+ Pos 2) LstPt))
                                    (setq Pos (+ Pos 3))
                                    (cond
                                        ((and P1 P2 P3) 
                                            (setq InfoCircle (LM:3pcircle P1 P2 P3))
                                            (setq TmpArc (list P1 P2 P3))
                                        )
                                        ((and P1 P2)
                                            (setq TmpArc (list P1 P2))
                                        )
                                        ((P1)
                                            (setq TmpArc (list P1))
                                        )
                                        (T
                                            (setq Loop nil)
                                        )
                                    )
                                )
                            )
                            (progn
                                (setq Loop nil)
                                (if TmpArc (setq Rtn (append Rtn (list TmpArc))))
                            )
                        )
                    )
                )
                (setq Rtn (list LstPt))
            )
        )
        (ReBuildCoordinate Rtn)
    )
    ;
    (defun MergePoint (LstPt / AccuracyCollinear
                               Num Rtn)

        ;
        ;
        ; Main
        ;
        (setq AccuracyCollinear 0.01)
        (setq LstPt (RemoveCollinear-p LstPt AccuracyCollinear))

        (setq Num 0)
        (if LstPt
            (repeat (- (length LstPt) 1)
                (setq Rtn (append Rtn (list (list (nth Num LstPt) (nth (1+ Num) LstPt) nil nil))))
                (setq Num (1+ Num))
            )
        )
        Rtn
    )
    ;
    ; Main
    ;
    (if (and EnameShape PtStartFlex PtEndFlex Flex)
        (progn
            (setq MAXLGSG  50.0)
            (setq PRECI     0.00001)

            (setq UcsName (DefUcs PtStartFlex PtEndFlex))
            (setq LstCo   (BuildCoordinate EnameShape UcsName))
            (setq LgAxe   (distance PtStartFlex PtEndFlex))
            (setq RadiusFlex  (/ (+ (/ (* LgAxe LgAxe) 4.0) (* (abs Flex) (abs Flex))) (* 2.0 (abs Flex))))
            
            (if(>= Flex 0) 
                (setq CenterFlex (list 0.0 (- 0.0 (- RadiusFlex Flex))))
                (setq CenterFlex (list 0.0 (+ RadiusFlex Flex)))
            )
            (foreach itm LstCo

                (if (= (caddr itm) 0.0) 
                    (setq Rtn (append Rtn (FlexStraightLine itm RadiusFlex CenterFlex Flex PRECI MAXLGSG)))
                    (setq Rtn (append Rtn (FlexArc          itm RadiusFlex CenterFlex Flex)))
                )
            )
        )
    )
    
    (setq Num 0)
    (foreach itm Rtn
        (setq Rtn (LM:SubstNth (list (TransGPt (nth 0 itm) UcsName) 
                                     (TransGPt (nth 1 itm) UcsName)  
                                     (nth 2 itm) 
                                     (TransGPt (nth 3 itm) UcsName)) Num Rtn))
        (setq Num (1+ Num))
    )
    Rtn
)
;
(defun GraphicsFelx (LstCo / ModelSpace itm Obj Ps Pe Radius Pc SAng EAng Rtn)
                

    ;(((-834.775 -471.912) (834.775 -471.912) -2687.21 (0.0 -3026.18)) 
    ; ((834.775 -471.912)  (1165.22 471.912) nil nil) 
    ; ((1165.22 471.912)   (-1165.22 471.912) 3687.05 (0.0 -3026.18)) 
    ; ((-1165.22 471.912)  (-834.775 -471.912) nil nil))

    (setq ModelSpace (vla-get-modelspace(vla-get-activedocument (vlax-get-acad-object))))
    
    (foreach itm LstCo
        (if (nth 2 itm)
            (progn
                (setq Ps     (nth 0 itm))
                (setq Pe     (nth 1 itm))
                (setq Radius (nth 2 itm))
                (setq Pc     (nth 3 itm))
                (setq LstInt (LM:inters-circle-circle Ps (abs Radius) Pe (abs Radius)))
                
                (if (> (distance pc (car Lstint)) (distance pc (cadr Lstint)))
                    (setq Pc (cadr Lstint))
                    (setq Pc (car  Lstint))
                )
                
                (if (> Radius 0)
                    (progn
                        (setq SAng (angle Pc Ps))
                        (setq EAng (angle Pc Pe))
                    ) 
                    (progn
                        (setq SAng (angle Pc Pe))
                        (setq EAng (angle Pc Ps))
                    )
                )
                (setq Rtn (append Rtn (list (vlax-vla-object->ename (vla-addArc ModelSpace (vlax-3d-point Pc) (abs Radius) SAng EAng)))))
            )
            (setq Rtn (append Rtn (list (vlax-vla-object->ename (vla-AddLine modelSpace  (vlax-3d-point (nth 0 itm)) (vlax-3d-point (nth 1 itm))))))) 
        )
    )
	Rtn
)
;
(defun GraphicsFelx01 (LstCo / ModelSpace itm Obj Ps Pe Radius Pc SAng EAng Rtn)
                

    ;(((-834.775 -471.912) (834.775 -471.912) -2687.21 (0.0 -3026.18)) 
    ; ((834.775 -471.912)  (1165.22 471.912) nil nil) 
    ; ((1165.22 471.912)   (-1165.22 471.912) 3687.05 (0.0 -3026.18)) 
    ; ((-1165.22 471.912)  (-834.775 -471.912) nil nil))

    (setq ModelSpace (vla-get-modelspace(vla-get-activedocument (vlax-get-acad-object))))
    
    (foreach itm LstCo
		(setq Ps     (nth 0 itm))
        (setq Pe     (nth 1 itm))
        (vlax-vla-object->ename (vla-AddLine modelSpace  (vlax-3d-point Ps) (vlax-3d-point Pe))) 
    )
)
;

