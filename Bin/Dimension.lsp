;
(defun GuiDimensionTools1 ( / LogicTog
							  xx LstTypeDim LstCodeDim x y Td Dim ItmF ItmE ItmI SetTag BitMx
							  TypeDimFree TypeDimInternalShape TypeDimExternalShape)

	(setq DefaultMenuEasyCut$ GuiDimensionTools1)
	;
	(defun LogicTog (LstTog / SetModeTile
							  Rtn modetag2 modetag3)

		(defun SetModeTile (/ modetag1 modetag2 modetag3 modetag4 modetag5)
			
			(if (= (get_tile "tog1") "0")
				(progn
					(setq modetag2 1)
					(setq modetag3 1)
				)
				(if (= (get_tile "tog2") "0")
					(progn
						(setq modetag2    0)
						(setq modetag3    1)
					)
					(progn
						(setq modetag2    0)
						(setq modetag3    0)
					)
				)
			)
			
			(if (= (get_tile "tog4") "0")
				(setq modetag4 1)
				(setq modetag4 0)
			)
			
			(if (= (get_tile "tog5") "0")
				(setq modetag5 1)
				(setq modetag5 0)
			)

			(cond
				((and (= modetag4 1)
					  (= modetag5 1)
				)
					(mode_tile "image4" 1)
					(start_image "image4") (fill_image  0 0 (dimx_tile "image4") (dimy_tile "image4") 253) (end_image)	
					(start_image "image4") (slide_image 0 0 (dimx_tile "image4") (dimy_tile "image4") (strcat SetupPathEasyCut$ "DimXY.sld")) (end_image)				
				)
				((or  (= modetag4 0)
					  (= modetag5 0)
				)
					(mode_tile "image4" 0)
					(start_image "image4") (fill_image  0 0 (dimx_tile "image4") (dimy_tile "image4") 250) (end_image)
					(start_image "image4") (slide_image 0 0 (dimx_tile "image4") (dimy_tile "image4") (strcat SetupPathEasyCut$ "DimXY.sld")) (end_image)
				)
			)
			

			(mode_tile "tog2" modetag2) 
			(mode_tile "tog3" modetag3) 
			(mode_tile "TypeDimInternalShape" modetag4) 
			(mode_tile "TypeDimExternalShape" modetag5) 
			
			(list (list (get_tile "tog1") (get_tile "tog2") (get_tile "tog3") (get_tile "tog4") (get_tile "tog5")) 
				  (list 0 modetag2 modetag3 0 0)
			)
		)
		;
		;
		(if LstTog
			(progn
				(set_tile "tog1" (nth 0 (car LstTog)))
				(set_tile "tog2" (nth 1 (car LstTog)))
				(set_tile "tog3" (nth 2 (car LstTog)))
				(set_tile "tog4" (nth 3 (car LstTog)))
				(set_tile "tog5" (nth 4 (car LstTog)))
				
				(mode_tile "tog1" (nth 0 (cadr LstTog)))
				(mode_tile "tog2" (nth 1 (cadr LstTog)))
				(mode_tile "tog3" (nth 2 (cadr LstTog)))
				(mode_tile "tog4" (nth 3 (cadr LstTog)))
				(mode_tile "tog5" (nth 4 (cadr LstTog)))
			)
		)
		(SetModeTile)
	)
	;
	(if (getvar "ANNOMONITOR")
		(setvar "ANNOMONITOR" -2)
	)
	(if (not EasyCutTypeDimFree$) 
		(setq EasyCutTypeDimFree$ "0")
	)
	(if (not EasyCutTypeDimExternalShape$) 
		(setq EasyCutTypeDimExternalShape$ "0")
	)
	(if (not EasyCutTypeDimInternalShape$) 
		(setq EasyCutTypeDimInternalShape$ "0")
	)
	
	(if (not (findfile 	(strcat SetupPathEasyCut$ "DimLinear.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "DimLinear.sld") 
						(strcat SetupPathEasyCut$ "DimLinear.sld")))
						
	(if (not (findfile 	(strcat SetupPathEasyCut$ "DimAlign.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "DimAlign.sld") 
						(strcat SetupPathEasyCut$ "DimAlign.sld")))
						
	(if (not (findfile 	(strcat SetupPathEasyCut$ "DimMatrix.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "DimMatrix.sld") 
						(strcat SetupPathEasyCut$ "DimMatrix.sld")))
						
	(if (not (findfile 	(strcat SetupPathEasyCut$ "DimXY.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "DimXY.sld") 
						(strcat SetupPathEasyCut$ "DimXY.sld")))
						
	(if (not (findfile 	(strcat SetupPathEasyCut$ "DimRegapp.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "DimRegapp.sld") 
						(strcat SetupPathEasyCut$ "DimRegapp.sld")))
						
	(if (not (findfile 	(strcat SetupPathEasyCut$ "DimSplit.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "DimSplit.sld") 
						(strcat SetupPathEasyCut$ "DimSplit.sld")))

	(if (not (findfile 	(strcat SetupPathEasyCut$ "DimComplete.sld")))
		(vl-file-copy  	(strcat LibPathEasyCut$   "DimComplete.sld") 
						(strcat SetupPathEasyCut$ "DimComplete.sld")))

	(setq LstTypeDim  '("Lineare+Progressiva+Totale" 	;121
					    "Progressiva+Lineare+Totale"	;211
						"Lineare+Progressiva"			;120
						"Progressiva+Lineare"			;210
						"Lineare+Totale"				;101
						"Progressiva+Totale"			;201
						"Lineare"						;100
						"Progressiva"					;200
						"Totale"						;001
					)
	)
	(setq LstCodeDim  '("121"
					    "211"
						"120"
						"210"
						"101"
						"201"
						"100"
						"200"
						"001"
					)
	)
	
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	
	
	(if (IfOpenDcl)
		(new_dialog "DimensionToolsOpenDcl" xx "" (cond ( *DimensionTools1* ) ( '(-1 -1) )))
		(new_dialog "DimensionTools1" 		xx "" (cond ( *DimensionTools1* ) ( '(-1 -1) )))
	)
	(if (not EasyCutToggleDim$) (setq EasyCutToggleDim$ (list (list "1" "1" "1" "1" "1") (list 0 0 0 0 0))))
	(LogicTog EasyCutToggleDim$)

	
	(set_tile "DimStyle" (strcat "Dim Style => "(getvar "Dimstyle")))
	(setq x (dimx_tile "image1")) ;get image tile width
	(setq y (dimy_tile "image1")) ;get image tile heigth
	(start_image "image1")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "DimLinear.sld"))
	(end_image)			
	(start_image "image2")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "DimAlign.sld"))
	(end_image)
	(start_image "image3")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "DimMatrix.sld"))
	(end_image)
	(start_image "image4")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "DimXY.sld"))
	(end_image)
	;
	(start_list "TypeDimFree")
		(mapcar 'add_list LstTypeDim)
	(end_list)
	(set_tile "TypeDimFree" EasyCutTypeDimFree$)
	;
	(start_list "TypeDimExternalShape")
		(mapcar 'add_list LstTypeDim)
	(end_list)
	(set_tile "TypeDimExternalShape" EasyCutTypeDimExternalShape$)
	;
	(start_list "TypeDimInternalShape")
		(mapcar 'add_list LstTypeDim)
	(end_list)
	(set_tile "TypeDimInternalShape" EasyCutTypeDimInternalShape$)
	;
	(setq x (dimx_tile "image100")) ;get image tile width
	(setq y (dimy_tile "image100")) ;get image tile heigth
	(start_image "image100")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "DimRegapp.sld"))
	(end_image)
	(start_image "image101")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "DimSplit.sld"))
	(end_image)
	(start_image "image102")
		(slide_image 0 0 x y (strcat SetupPathEasyCut$ "DimComplete.sld"))
	(end_image)

	(action_tile "tog1" "(LogicTog nil)")
	(action_tile "tog2" "(LogicTog nil)")
	(action_tile "tog4" "(LogicTog nil)")
	(action_tile "tog5" "(LogicTog nil)")
	
	(action_tile "image1" (strcat "(setq Td \"1\")"
								  "(setq ItmF (atoi (get_tile \"TypeDimFree\")))"
								  "(setq Dim 1)"
								  "(setq EasyCutToggleDim$ (LogicTog nil))"
								  "(setq *DimensionTools1* (done_dialog)) (unload_dialog xx)"))
	(action_tile "image2" (strcat "(setq Td \"2\")"
								  "(setq ItmF (atoi (get_tile \"TypeDimFree\")))"
								  "(setq Dim 2)"
								  "(setq EasyCutToggleDim$ (LogicTog nil))"
								  "(setq *DimensionTools1* (done_dialog)) (unload_dialog xx)"))
	(action_tile "image3" (strcat "(setq Td \"1\")"
								  "(setq ItmF (atoi (get_tile \"TypeDimFree\")))"
								  "(setq Dim 3)"
								  "(setq EasyCutToggleDim$ (LogicTog nil))"
								  "(setq *DimensionTools1* (done_dialog)) (unload_dialog xx)"))
	(action_tile "image4" (strcat "(setq Td \"1\")"
								  "(setq ItmE (atoi (get_tile \"TypeDimExternalShape\")))"
								  "(setq ItmI (atoi (get_tile \"TypeDimInternalShape\")))"
								  "(setq Dim 4)"
								  "(setq EasyCutToggleDim$ (LogicTog nil))"
								  "(setq *DimensionTools1* (done_dialog)) (unload_dialog xx)"))
	(action_tile "image100" (strcat "(setq Td \"1\")"
								    "(setq Dim 100)"
									"(setq EasyCutToggleDim$ (LogicTog nil))"
								    "(setq *DimensionTools1* (done_dialog)) (unload_dialog xx)"))
	(action_tile "image101" (strcat "(setq Td \"1\")"
								    "(setq Dim 101)"
									"(setq EasyCutToggleDim$ (LogicTog nil))"
								    "(setq *DimensionTools1* (done_dialog)) (unload_dialog xx)"))
	(action_tile "image102" (strcat "(setq Td \"1\")"
								    "(setq Dim 102)"
									"(setq EasyCutToggleDim$ (LogicTog nil))"
								    "(setq *DimensionTools1* (done_dialog)) (unload_dialog xx)"))
	(if (IfOpenDcl)
		(progn
			(action_tile "accept" 	(strcat "(setq Td \"1\")"
											"(setq Dim 104)"
											"(setq *DimensionTools1* (done_dialog)) (unload_dialog xx)"))
		)
		(progn
			(action_tile "return" 	(strcat "(setq Td \"1\")"
											"(setq Dim 103)"
											"(setq *DimensionTools1* (done_dialog)) (unload_dialog xx)"))
			(action_tile "cancel" "(setq *DimensionTools1* (done_dialog)) (unload_dialog xx)")
		)
	)

	(start_dialog)
	
	(if Td 
		(cond 
			((or (= Dim 1) (= Dim 2))
				(setq TypeDimFree (strcat Td (nth ItmF LstCodeDim)))
				(setq EasyCutTypeDimFree$ (rtos ItmF 2 0))
				(Dimension (SelectObjectDimension 1) TypeDimFree)
			)
			((= Dim 3)
				(setq TypeDimFree (strcat Td (nth ItmF LstCodeDim)))
				(setq EasyCutTypeDimFree$ (rtos ItmF 2 0))
				(DimensionMatrix (SelectObjectDimension 2) TypeDimFree nil T)
			)
			((= Dim 4)
				(setq TypeDimInternalShape (strcat Td (nth ItmI LstCodeDim)))
				(setq EasyCutTypeDimInternalShape$ (rtos ItmI 2 0))
				(setq TypeDimExternalShape (strcat Td (nth ItmE LstCodeDim)))
				(setq EasyCutTypeDimExternalShape$ (rtos ItmE 2 0))
				
				(setq SetTag  (car EasyCutToggleDim$))
				
				(cond
					((= (nth 0 SetTag) "0") ; no matrix
						(setq BitMx nil) 
					)
					((= (nth 3 SetTag) "0") ; no matrix
						(setq BitMx nil) 
					)
					((or (and (= (nth 0 SetTag) "1") (= (nth 1 SetTag) "0") (= (nth 2 SetTag) "0"))
						 (and (= (nth 0 SetTag) "1") (= (nth 1 SetTag) "0") (= (nth 2 SetTag) "1")))
						 (setq BitMx "00")
					)
					((and (= (nth 0 SetTag) "1") (= (nth 1 SetTag) "1") (= (nth 2 SetTag) "0"))
						(setq BitMx "10")
					)
					((and (= (nth 0 SetTag) "1") (= (nth 1 SetTag) "1") (= (nth 2 SetTag) "1"))
						(setq BitMx "11")
					)
				)
				
				(if (or (= (nth 3 SetTag) "1") (= (nth 4 SetTag) "1"))
					(progn
						(if (= (nth 3 SetTag) "0") (setq TypeDimInternalShape "1000"))
						(if (= (nth 4 SetTag) "0") (setq TypeDimExternalShape "1000"))
						(ShapeDimension (SelectObjectDimension 3) TypeDimInternalShape TypeDimExternalShape BitMx)
					)
				)
			)
			((= Dim 100)
				(GuiUnionDim)
			)
			((= Dim 101)
				(GuiSplitDim)
			)
 			((= Dim 102)
				(GuiCompleteDim)
			)
 			((= Dim 103)
				(MainMenu)
			)
 			((= Dim 104)
				(setq DefaultMenuEasyCut$ MainMenu)
				T
			)
		)
	)
)
;
(defun SelectObjectDimension (TypeSelect / Ssel)
	(cond 
		((= TypeSelect 1)
			(ssget '((-4 . "<OR") (0 . "CIRCLE")  (0 . "LWPOLYLINE") (-4 . "OR>")))
		)
		((= TypeSelect 2)
			(ssget '((0 . "CIRCLE")))
		)
		((= TypeSelect 3)
			(if (setq Ssel (ssget "_+.:E:S" '((0 . "LWPOLYLINE"))))
				(ssname Ssel 0)
			)
		)
	)
)
;
(defun Dimension (Ssel TypeDim / *error* MaxMin TestDimLinear TestDimOrdinate
								 GPtDim InfoDim)
		
	;  1 = ucs corrente
	;  2 = ruotata (1° e 2° --> direzione)	
	;  | 0 nessuna quota
	;  v 1 quota continua (1° linea di quota)
	;	 2 quota ordinata (1° linea di quota)
	;	 | 0 nessuna quota
	;    v 1 quota continua (2° linea di quota)
	;      2 quota ordinata (2° linea di quota)
	;	   | 0 nessuna quaota
    ;	   v 1 quota totale continua
	;		 2 quota totale ordinata
	;		 |
	;	     v
	; "1 1 0 0"  ucs corrente	continua 
	; "1 2 0 0"  ucs corrente	ordinata 
	; "2 1 0 0"  ruotata		continua 
	; "2 2 0 0"  ruotata		ordinata 

	; "1 0 0 1"  ucs corrente   totale continua 
	; "2 0 0 1"  ruotata		totale continua
	; "1 0 0 2"  ucs corrente   totale ordinata 
	; "2 0 0 2"  ruotata		totale ordinata

	; "1 1 0 1"  ucs corrente	continua + totale 1 o 2 continua/ordinata
	; "1 2 0 1"  ucs corrente	ordinata + totale 1 o 2 continua/ordinata
	; "2 1 0 1"  ruotata		continua + totale 1 o 2 continua/ordinata
	; "2 2 0 1"  ruotata		ordinata + totale 1 o 2 continua/ordinata

	; "1 1 2 0"  ucs corrente	continua + ordinata
	; "1 2 1 0"  ucs corrente	ordinata + continua
	; "2 1 2 0"  ruotata		continua + ordianta 
	; "2 2 1 0"  ruotata		ordinata + continua 

	; "1 1 2 1"  ucs corrente	continua + ordinata + totale 1 o 2 continua/ordinata
	; "1 2 1 1"  ucs corrente	ordinata + continua + totale 1 o 2 continua/ordinata
	; "2 1 2 1"  ruotata		continua + ordianta + totale 1 o 2 continua/ordinata
	; "2 2 1 1"  ruotata		ordinata + continua + totale 1 o 2 continua/ordinata
	;
	;
	(defun *error* (msg)
		(RestoreUcs "SaveUcs")
		(DeleteUCS  "UcsWork")
	)
	;
	(defun MaxMin (GPointDimension / itm LPointDimension MinX MinY MaxX MaxY Rtn)
		
		(if GPointDimension
			(progn
				(foreach itm GPointDimension
					(setq LPointDimension (append LPointDimension (list (trans itm 0 1))))
				)
				(setq MinX (apply 'min (mapcar 'car  LPointDimension)))
				(setq MaxX (apply 'max (mapcar 'car  LPointDimension)))
				(setq MinY (apply 'min (mapcar 'cadr LPointDimension)))
				(setq MaxY (apply 'max (mapcar 'cadr LPointDimension)))		
				(setq Rtn (list MinX MinY MaxX MaxY))
			)
		)
		Rtn
	)
	;
	(defun TestDimLinear (GPointDimension / itm LPointDimension PosText ScaleDim GapDim HeightDim Correggi MinX MinY MaxX MaxY Rtn)
		(if GPointDimension
			(progn
				(foreach itm GPointDimension
					(setq LPointDimension (append LPointDimension (list (trans itm 0 1))))
				)
				(setq MinX (apply 'min (mapcar 'car  LPointDimension)))
				(setq MaxX (apply 'max (mapcar 'car  LPointDimension)))
				(setq MinY (apply 'min (mapcar 'cadr LPointDimension)))
				(setq MaxY (apply 'max (mapcar 'cadr LPointDimension)))

				(command "_dimlinear" (list MinX MinY) (list MaxX MaxY) pause)
				(setq PosText 	(trans (safearray-value (vlax-variant-value (vla-get-textposition  (vlax-ename->vla-object (entlast))))) 0 1))
				(setq ScaleDim	(vla-get-scalefactor (vlax-ename->vla-object (entlast))))
				(setq GapDim    (vla-get-textgap     (vlax-ename->vla-object (entlast))))
				(setq HeightDim (vla-get-textheight	 (vlax-ename->vla-object (entlast))))
				
			
				(setq Correggi  (* (+ (/ HeightDim 2.0) GapDim) ScaleDim))
				(entdel (entlast))
				
				(cond 
					((> (car PosText) MaxX)
						(setq Rtn (list 1 (trans (list (+ (car PosText) Correggi) (cadr PosText)) 1 0)))
					)
					((< (car PosText) MinX)
						(setq Rtn (list 2 (trans (list (+ (car PosText) Correggi) (cadr PosText)) 1 0)))
					)
					((> (cadr PosText) MaxY)
						(setq Rtn (list 3 (trans (list (car PosText) (- (cadr PosText) Correggi)) 1 0)))
					)
					((< (cadr PosText) MinY)
						(setq Rtn (list 4 (trans (list (car PosText) (- (cadr PosText) Correggi)) 1 0)))
					)
				)
			)
		)
		Rtn
	)
	;
	(defun TestDimOrdinate (GPointDimension / Predomina 
											  itm LPointDimension MinX MinY MaxX MaxY PosText ScaleDim GapDim BoxText LengthText Correggi OrtoSave Rtn)
		
		(defun Predomina (Ps Pt / x y Rtn)
			(setq x (abs (- (car  Ps) (car  Pt)))) 
			(setq y (abs (- (cadr Ps) (cadr Pt))))
			(if (> x y) 
				(setq Rtn (list (car Pt) (cadr Ps)))
				(setq Rtn (list (car Ps) (cadr Pt)))
			)
		)
		
		(if GPointDimension
			(progn
				(foreach itm GPointDimension
					(setq LPointDimension (append LPointDimension (list (trans itm 0 1))))
				)

				(setq OrtoSave (getvar "orthomode"))
				(setvar "orthomode" 1) 
				(setq MinX (apply 'min (mapcar 'car  LPointDimension)))
				(setq MaxX (apply 'max (mapcar 'car  LPointDimension)))
				(setq MinY (apply 'min (mapcar 'cadr LPointDimension)))
				(setq MaxY (apply 'max (mapcar 'cadr LPointDimension)))

				(command "_dimordinate" (list MinX MinY) pause)
				(setq PosText      (trans (safearray-value (vlax-variant-value (vla-get-textposition  (vlax-ename->vla-object (entlast))))) 0 1))
				(setq ScaleDim     (vla-get-scalefactor (vlax-ename->vla-object (entlast))))
				(setq GapDim       (vla-get-textgap     (vlax-ename->vla-object (entlast))))
				(setq LengthText   (GetTextLengthDim 	(entlast)))
				(setq PosText      (Predomina (list MinX MinY) PosText))
				(setq Correggi     (+ (/ LengthText 2.0) (* GapDim ScaleDim)))
				(entdel (entlast))
				
				(cond 
					((> (car PosText) MaxX)
						(setq Rtn (list 1 (trans (list (- (car PosText) Correggi) (cadr PosText)) 1 0)))
					)
					((< (car PosText) MinX)
						(setq Rtn (list 2 (trans (list (+ (car PosText) Correggi) (cadr PosText)) 1 0)))
					)
					((> (cadr PosText) MaxY)
						(setq Rtn (list 3 (trans (list (car PosText) (- (cadr PosText) Correggi)) 1 0)))
					)
					((< (cadr PosText) MinY)
						(setq Rtn (list 4 (trans (list (car PosText) (+ (cadr PosText) Correggi)) 1 0)))
					)
				)
				(setvar "orthomode" OrtoSave)
			)
		)
		Rtn
	)
	;
	;
	; Main
	;
	(if Ssel
		(progn
			(SaveUcs "SaveUcs")
			(setq GPtDim   (GetPointDimension Ssel))
			
			(if (= (substr TypeDim 1 1) "2") 							; allineato
				(progn
					(SetUcs2P (car  GPtDim) (cadr GPtDim) "UcsWork")
					(setq GPtDim   (GetPointDimension Ssel))
				)
			)
			
			(cond
				((= (substr TypeDim 2 1) "1")  							; continua
					(setq InfoDim  (TestDimLinear GPtDim))
				)
				((= (substr TypeDim 2 1) "2") 							; ordinata
					(setq InfoDim  (TestDimOrdinate GPtDim))
				)
				((= (substr TypeDim 4 1) "1")  							; continua totale
					(setq InfoDim  (TestDimLinear GPtDim))
				)
				((= (substr TypeDim 4 1) "2")  							; ordinata totale
					(setq InfoDim  (TestDimOrdinate GPtDim))
				)
			)
			(RestoreUcs "SaveUcs")
			(DeleteUCS  "UcsWork")
			
			(BatchDimension Ssel (car InfoDim) TypeDim (cadr InfoDim))
		)
	)
)
;
(defun BatchDimension (Ssel Sector TypeDim GPosDim / *error* MaxMin
													 LPosDim GPtDim LMxMy LPtDim LstDim Rtn)

	(defun *error* (msg)
		(RestoreUcs "SaveUcs")
		(DeleteUCS  "UcsWork")
	)
	;
	(defun MaxMin (GPointDimension / itm LPointDimension MinX MinY MaxX MaxY Rtn)
		
		(if GPointDimension
			(progn
				(foreach itm GPointDimension
					(setq LPointDimension (append LPointDimension (list (trans itm 0 1))))
				)
				(setq MinX (apply 'min (mapcar 'car  LPointDimension)))
				(setq MaxX (apply 'max (mapcar 'car  LPointDimension)))
				(setq MinY (apply 'min (mapcar 'cadr LPointDimension)))
				(setq MaxY (apply 'max (mapcar 'cadr LPointDimension)))		
				(setq Rtn (list MinX MinY MaxX MaxY))
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if (and Ssel Sector TypeDim GPosDim)
		(progn
			(SaveUcs "SaveUcs")
			(setq GPtDim   (GetPointDimension Ssel))
			
			(if (= (substr TypeDim 1 1) "2") 							; allineato
				(progn
					(SetUcs2P (car  GPtDim) (cadr GPtDim) "UcsWork")
					(setq GPtDim   (GetPointDimension Ssel))
				)
			)
			
			(setq LMxMy    (MaxMin GPtDim))
			(SetUcs2P      (trans (list (nth 0 LMxMy) (nth 1 LMxMy)) 1 0) (trans (list (nth 2 LMxMy) (nth 1 LMxMy)) 1 0) "UcsWork")
			(setq LPtDim   (RegappDimPoint Ssel Sector))
			(setq LPosDim  (trans GPosDim 0 1))

			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			(cond														; 1°
				((= (substr TypeDim 2 1) "1") 							; continua
					(setq LstDim (QuotaContinua LPtDim Sector LPosDim))
					(setq Rtn (append Rtn (cadr LstDim)))
				)
				((= (substr TypeDim 2 1) "2") 							; ordinata
					(setq LstDim (QuotaOrdinate LPtDim Sector LPosDim))
					(setq Rtn (append Rtn (cadr LstDim)))
				)
			)
			
			(if LstDim
				(setq LPosDim (NextPosDim (car (cadr LstDim)) (car LstDim) Sector LPosDim))
			)
			
			(cond														; 2°
				((= (substr TypeDim 3 1) "1") 							; continua
					(setq LstDim (QuotaContinua LPtDim Sector LPosDim))
					(setq Rtn (append Rtn (cadr LstDim)))
				)
				((= (substr TypeDim 3 1) "2") 							; ordinata
					(setq LstDim (QuotaOrdinate LPtDim Sector LPosDim))
					(setq Rtn (append Rtn (cadr LstDim)))
				)
			)
			
			(if LstDim
				(setq LPosDim (NextPosDim (car (cadr LstDim)) (car LstDim) Sector LPosDim))
			)

			(cond														; 3° totale
				((= (substr TypeDim 4 1) "1")  							; continua
					(setq LstDim (QuotaContinua (list (car LPtDim) (car (reverse LPtDim))) Sector LPosDim))
					(setq Rtn (append Rtn (cadr LstDim)))
				)
				((= (substr TypeDim 4 1) "2") 							; ordinata
					(setq LstDim (QuotaOrdinate (list (car LPtDim) (car (reverse LPtDim))) Sector LPosDim))
					(setq Rtn (append Rtn (cadr LstDim)))
				)
			)
			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			
			(RestoreUcs "SaveUcs")
			(DeleteUCS  "UcsWork")
		)
	)
	Rtn
)
;
(defun NextPosDim (EnameDim LstBox Sector LLastPoint / ScaleDim GapDim HeightDim StyleName DimensionLineSpacing Rtn)
	
	(if (and EnameDim LstBox Sector)
		(progn
			(setq ScaleDim	(vla-get-scalefactor (vlax-ename->vla-object EnameDim)))
			(setq GapDim    (vla-get-textgap     (vlax-ename->vla-object EnameDim)))
			(setq HeightDim (vla-get-textheight	 (vlax-ename->vla-object EnameDim)))
			(setq StyleName (vla-get-stylename   (vlax-ename->vla-object EnameDim)))
			(setq DimensionLineSpacing (cdr (assoc 43 (tblsearch "DIMSTYLE" StyleName))))
			(cond 
				((= Sector 1)
					(if (= (vlax-get-property (vlax-ename->vla-object EnameDim) 'ObjectName) "AcDbOrdinateDimension") 
						(setq Rtn (list (+ (car (cadr LstBox)) (* DimensionLineSpacing ScaleDim)) (cadr (cadr LstBox)))) 
						(setq Rtn (list (+ (car LLastPoint) (* DimensionLineSpacing ScaleDim)) (cadr LLastPoint)))
					)
				)
				((= Sector 2)
					(if (= (vlax-get-property (vlax-ename->vla-object EnameDim) 'ObjectName) "AcDbOrdinateDimension") 
						(setq Rtn (list (- (car (car LstBox))  (* DimensionLineSpacing ScaleDim)) (cadr (car LstBox)))) 
						(setq Rtn (list (- (car LLastPoint)  (* DimensionLineSpacing ScaleDim)) (cadr LLastPoint))) 
					)
				)
				((= Sector 3)
					(if (= (vlax-get-property (vlax-ename->vla-object EnameDim) 'ObjectName) "AcDbOrdinateDimension") 
						(setq Rtn (list (car (caddr LstBox)) (+ (cadr (caddr LstBox)) (* DimensionLineSpacing ScaleDim)))) 
						(setq Rtn (list (car LLastPoint) (+ (cadr LLastPoint) (* DimensionLineSpacing ScaleDim)))) 
					)
				)
				((= Sector 4)
					(if (= (vlax-get-property (vlax-ename->vla-object EnameDim) 'ObjectName) "AcDbOrdinateDimension") 
						(setq Rtn (list (car (car LstBox))   (- (cadr (car LstBox))   (* DimensionLineSpacing ScaleDim)))) 
						(setq Rtn (list (car LLastPoint) (- (cadr LLastPoint)  (* DimensionLineSpacing ScaleDim)))) 
					)
				)
			)
		)
	)
	Rtn
)
;
(defun GetPointDimension (Ssel / Num Obj Ename LstBox LstDim)

	(if Ssel
		(progn
			(setq Num 0)
			(repeat (sslength Ssel)
				(setq Ename (ssname Ssel Num))
				(setq Obj (vlax-ename->vla-object Ename))
				(cond
					((= (vlax-get-property Obj 'ObjectName) "AcDbPolyline")
						(setq LstBox (ucs-bbox Ename))
						(setq LstDim (append LstDim (list (trans (car  LstBox) 1 0))))
						(setq LstDim (append LstDim (list (trans (cadr LstBox) 1 0))))
					)
					((= (vlax-get-property Obj 'ObjectName) "AcDbCircle")
						(setq LstDim (append LstDim (list (vlax-safearray->list (vlax-variant-value (vla-get-center Obj))))))
					)
				)
				(setq Num (1+ Num))
			)
		)
	)
	LstDim
)
;
(defun RegappDimPoint (Ssel Sector / PointContactUcsBox FilterPoint
									  LstPointSelect Ename Obj PtBox Num1 Num2 Foo itm Sentinel PtChk1 PtChk2 MinP Rtn)

;
;					  3				
;				+-----------+
;				|			|
;			2	|  Sector	|	1
;				|			|
;				|			|
;				+-----------+
;					  4
;
	(setq Foo 0.25)
	(defun PointContactUcsBox (EnameBox / PtBox ModelSpace ObyLine1 ObyLine2 ObyLine3 ObyLine4 MinX MaxX MinY MaxY)
		(if EnameBox
			(progn
				(setq PtBox (ucs-bbox (vlax-ename->vla-object EnameBox)))
				(setq ModelSpace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))

				
				(setq ObyLine1 (vla-addline ModelSpace 	(vlax-3d-point (trans (list (car (car  PtBox)) (cadr (car  PtBox))) 1 0))
														(vlax-3d-point (trans (list (car (cadr PtBox)) (cadr (car  PtBox))) 1 0))))
				(setq ObyLine2 (vla-addline ModelSpace 	(vlax-3d-point (trans (list (car (cadr PtBox)) (cadr (car  PtBox))) 1 0))
														(vlax-3d-point (trans (list (car (cadr PtBox)) (cadr (cadr PtBox))) 1 0))))
				(setq ObyLine3 (vla-addline ModelSpace 	(vlax-3d-point (trans (list (car (cadr PtBox)) (cadr (cadr PtBox))) 1 0))
														(vlax-3d-point (trans (list (car (car  PtBox)) (cadr (cadr PtBox))) 1 0))))
				(setq ObyLine4 (vla-addline ModelSpace 	(vlax-3d-point (trans (list (car (car  PtBox)) (cadr (cadr PtBox))) 1 0))
														(vlax-3d-point (trans (list (car (car  PtBox)) (cadr (car  PtBox))) 1 0))))
														
				(foreach itm (PointOfConctat EnameBox (vlax-vla-object->ename ObyLine1))
					(setq MinY (append MinY (list (trans itm 0 1))))
				)
				(foreach itm (PointOfConctat EnameBox (vlax-vla-object->ename ObyLine2))
					(setq MaxX (append MaxX (list (trans itm 0 1))))
				)
				(foreach itm (PointOfConctat EnameBox (vlax-vla-object->ename ObyLine3))
					(setq MaxY (append MaxY (list (trans itm 0 1))))
				)
				(foreach itm (PointOfConctat EnameBox (vlax-vla-object->ename ObyLine4))
					(setq MinX (append MinX (list (trans itm 0 1))))
				)
				(vla-delete ObyLine1)
				(vla-delete ObyLine2)
				(vla-delete ObyLine3)
				(vla-delete ObyLine4)
				(list MinX MaxX MinY MaxY)
			)
		)
	)
	;
	(defun FilterPoint (LstPoint Sector / Rtn)
	
		(if (and LstPoint Sector)
			(progn
				(cond 
					((= Sector 1) (setq Rtn (car (vl-sort LstPoint (function (lambda (e1 e2)  (> (car   e1) (car   e2))))))))
					((= Sector 2) (setq Rtn (car (vl-sort LstPoint (function (lambda (e1 e2)  (< (car   e1) (car   e2))))))))
					((= Sector 3) (setq Rtn (car (vl-sort LstPoint (function (lambda (e1 e2)  (> (cadr  e1) (cadr  e2))))))))
					((= Sector 4) (setq Rtn (car (vl-sort LstPoint (function (lambda (e1 e2)  (< (cadr  e1) (cadr  e2))))))))
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if Ssel
		(progn
			(setq Num1 0)
			(repeat (sslength Ssel)
				(setq Ename (ssname Ssel Num1))
				(setq Obj (vlax-ename->vla-object Ename))
				(cond
					((= (vlax-get-property Obj 'ObjectName) "AcDbPolyline")
						(setq PtBox (PointContactUcsBox Ename))
						(setq LstPointBox nil)
						(cond
							((or (= Sector 3) (= Sector 4))
								(setq LstPointSelect (append LstPointSelect (list (FilterPoint (nth 0 PtBox) Sector))))
								(setq LstPointSelect (append LstPointSelect (list (FilterPoint (nth 1 PtBox) Sector))))
							)	
							((or (= Sector 1) (= Sector 2))
								(setq LstPointSelect (append LstPointSelect (list (FilterPoint (nth 2 PtBox) Sector))))
								(setq LstPointSelect (append LstPointSelect (list (FilterPoint (nth 3 PtBox) Sector))))
							)
						)
						
					)
					((= (vlax-get-property Obj 'ObjectName) "AcDbCircle")
						(setq LstPointSelect (append LstPointSelect (list (trans (vlax-safearray->list (vlax-variant-value (vla-get-center Obj))) 0 1))))
					)
				)
				(setq Num1 (1+ Num1))
			)
		)
	)
	; 
	;
	(setq Num1 0)
	(foreach itm LstPointSelect
		(setq Sentinel (append Sentinel (list nil)))
	)
	(if LstPointSelect
		(progn
			(cond
				((or (= Sector 3) (= Sector 4)) (setq LstPointSelect (vl-sort LstPointSelect (function (lambda (e1 e2)  (< (car  e1) (car  e2)))))))
				((or (= Sector 1) (= Sector 2)) (setq LstPointSelect (vl-sort LstPointSelect (function (lambda (e1 e2)  (< (cadr e1) (cadr e2)))))))
			)
			
			(repeat (length LstPointSelect)
				(if (not (nth Num1 Sentinel))
					(progn
						(setq Sentinel (LM:SubstNth T Num1 Sentinel))
						(setq PtChk1   (nth Num1 LstPointSelect))
						(cond
							((or (= Sector 3) (= Sector 4)) (setq MinP (cadr PtChk1)))
							((or (= Sector 1) (= Sector 2)) (setq MinP (car  PtChk1)))
						)
						(setq Num2 0)
						
						(repeat  (length LstPointSelect)
							(if (not (nth Num2 Sentinel))
								(progn
									(setq PtChk2 (nth Num2 LstPointSelect))
									(cond
										((or (= Sector 3) (= Sector 4))
											(if (equal (car PtChk1) (car PtChk2) Foo)
												(progn
													(setq Sentinel (LM:SubstNth T Num2 Sentinel))
													(cond 
														((= Sector 3)
															(if (< (cadr PtChk2) MinP)
																(setq MinP (cadr PtChk2))
															)
														)
														((= Sector 4)
															(if (> (cadr PtChk2) MinP)
																(setq MinP (cadr PtChk2))
															)
														)
													)
												)
											)
										)
										((or (= Sector 1) (= Sector 2))
											(if (equal (cadr PtChk1) (cadr PtChk2) Foo)
												(progn
													(setq Sentinel (LM:SubstNth T Num2 Sentinel))
													(cond 
														((= Sector 1)
															(if (< (car PtChk2) MinP)
																(setq MinP (car PtChk2))
															)
														)
														((= Sector 2)
															(if (> (car PtChk2) MinP)
																(setq MinP (car PtChk2))
															)
														)
													)
												)
											)
										)
									)
								)
							)
							(setq Num2 (1+ Num2))
						)
						(cond
							((or (= Sector 3) (= Sector 4)) (setq Rtn (append Rtn (list (list (car PtChk1) MinP)))))
							((or (= Sector 1) (= Sector 2)) (setq Rtn (append Rtn (list (list MinP (cadr PtChk1))))))
						)
					)
				)
				(setq Num1 (1+ Num1))
			)
		)
	)
	Rtn
)
;
(defun QuotaOrdinate (LstPointDim Sector PosDim / *error*
													P1 Osmode MaxMin Rtn)
													
	(defun *error* (msg)
		(setvar "OSMODE" Osmode)
	)
	;
	(if (and LstPointDim Sector PosDim)
		(progn
			;(setq ModelSpace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
			(setq Osmode  (getvar "OSMODE"))
			(setvar "OSMODE" 0)
			
			(cond 
				((or (= Sector 3) (= Sector 4))
					(foreach P1 LstPointDim
						(command "_dimordinate" P1 (list (car P1) (cadr PosDim)))
						(setq Rtn (append Rtn (list (entlast))))
						;(setq EnameDimension (vlax-vla-object->ename 
						;							(vla-adddimordinate  ModelSpace (vlax-3d-point (trans P1 1 0))
						;														    (vlax-3d-point (trans (list (car P1) (cadr PosDim)) 1 0)) :vlax-true))) 
						;(vlax-put-property (vlax-ename->vla-object EnameDimension) 'TextOverride (NumToDim (car P1) EnameDimension))
						
					)
				)
				((or (= Sector 1) (= Sector 2))
					(foreach P1 LstPointDim
						(command "_dimordinate" P1 (list (car PosDim) (cadr P1)))
						(setq Rtn (append Rtn (list (entlast))))
						;(setq EnameDimension (vlax-vla-object->ename 
						;							(vla-adddimordinate  ModelSpace (vlax-3d-point (trans P1 1 0)) 
						;															(vlax-3d-point (trans (list (car PosDim) (cadr P1)) 1 0)) :vlax-false)))
						;(vlax-put-property (vlax-ename->vla-object EnameDimension) 'TextOverride (NumToDim (cadr P1) EnameDimension))

					)
				)
			)
			
			(if Rtn (setq MaxMin (UcsBoundingBoxLstEname Rtn)))

			(setvar "OSMODE" Osmode)
		)
	)
	(list MaxMin Rtn)
)
;
(defun QuotaContinua (LstPointDim Sector PosDim / Xdirection AnglePlane Ang MargHText MargVText Num ModelSpace P1 P2 EnameDimension 
												  ObjDimension Dimension ScaleDim TextHeight 
												  BoxText pos_pre pos_att MaxMin Rtn)

	(if (and LstPointDim Sector PosDim)
		(progn
			(setq Xdirection (getvar "UCSXDIR"))
			(setq AnglePlane (angle '(0.0 0.0) Xdirection))
			(cond 
				((or (= Sector 3) (= Sector 4)) (setq Ang AnglePlane))
				((or (= Sector 1) (= Sector 2)) (setq Ang (+ (/ pi 2.0) AnglePlane)))
			)
			(setq MargHText 		   2.5)
			(setq MargVText 		   5.0)
			(setq Num     				 1)
			(setq pos_pre		   acAbove)
			
			(setq P1     (car LstPointDim))
			(setq ModelSpace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
			
			(foreach P2 (cdr LstPointDim)
				(setq EnameDimension (vlax-vla-object->ename (vla-adddimrotated  ModelSpace (vlax-3d-point (trans P1 1 0)) 
																							(vlax-3d-point (trans P2 1 0)) 
																							(vlax-3d-point (trans PosDim 1 0)) Ang)))
				(setq Rtn (append Rtn (list EnameDimension)))
				(setq ObjDimension (vlax-ename->vla-object EnameDimension))
				(setq Dimension    (vla-get-measurement    ObjDimension)) 
				(setq ScaleDim     (vla-get-scalefactor    ObjDimension))
				(setq TextHeight   (vla-get-textheight     ObjDimension))
				(setq LengthText   (+ (GetTextLengthDim EnameDimension) (* 2.0 MargHText ScaleDim)))
				
				(if (> LengthText Dimension)
					(if (= pos_pre acAbove)
						(if (null acUnder)
							(setq pos_att "\\X")
							(setq pos_att acUnder)
						)
						(setq pos_att 1)
					)
					(setq pos_att 1)
				)
				
				(ChangePosText EnameDimension pos_att)
				(setq P1 P2)
				(setq pos_pre pos_att)
				(setq Num (1+ Num))
			)
			
			(if Rtn (setq MaxMin (UcsBoundingBoxLstEname Rtn)))				
			
		)
	)
	(list MaxMin Rtn)
)
;
(defun GetTextLengthDim (EnameDimension / SampleText GetValueDimension GetCosDir MakeText
									 	  BoxText LengthText)

	(defun SampleText (EnameDimension / ObjDim DimStyle HeightText ScaleText Text ValueDimension BoxText WidthText)

		(setq ObjDim     (vlax-ename->vla-object EnameDimension))
		(setq DimStyle   (vla-get-textstyle   ObjDim))           
		(setq HeightText (vla-get-textheight  ObjDim))
		(setq ScaleText  (vla-get-scalefactor ObjDim))
		(setq WidthText  (cdr (assoc 41 (tblsearch "style" DimStyle))))
	 
		(setq ValueDimension (GetValueDimension EnameDimension))
		(setq Text (MakeText ValueDimension (* HeightText ScaleText) WidthText DimStyle (list 0 0)))
		(setq BoxText (textbox (entget Text)))
		(entdel Text)
		BoxText	
	)
	;
	(defun GetValueDimension (EnameDimension / EntData BlkEnt Str Pos)
		
		(setq EntData (entget EnameDimension))
		(setq BlkEnt (tblobjname "block" (cdr (assoc 2 EntData))))
		
		(while (setq BlkEnt (entnext BlkEnt))
			(if (= (cdr (assoc 0 (setq EntData (entget BlkEnt)))) "MTEXT")
				(progn
					(setq Str (cdr (assoc 1 EntData)))
					(if (setq Pos (vl-string-search ";" Str))
						(setq Str (substr Str (+ 2 Pos)))
					)
				)
			)
		)
		Str
	)
	;
	(defun GetCosDir (/ ucsx ucsy orig T11 T21 T31 T12 T22 T32 T13 T23 T33)

		(setq ucsx (getvar "UCSXDIR"))
		(setq ucsy (getvar "UCSYDIR"))
		(setq orig (getvar "UCSORG"))
	  
		(setq T11 (nth 0 ucsx)
			  T21 (nth 1 ucsx)
			  T31 (nth 2 ucsx)

			  T12 (nth 0 ucsy)
			  T22 (nth 1 ucsy)
			  T32 (nth 2 ucsy)

			  T13 (- (* T21 T32) (* T31 T22))
			  T23 (- (* T31 T12) (* T11 T32))
			  T33 (- (* T11 T22) (* T21 T12))
		)
		(list orig (list T11 T21 T31) (list T12 T22 T32) (list T13 T23 T33))
	)
	;
	(defun MakeText (testo htesto fatt_larg style pstart / cos_dir Rtn)
		(setq cos_dir (GetCosDir))
		(setq Rtn   (entmakex (list
								(cons 0   "TEXT")                              
								(cons 100 "AcDbEntity")
								(cons 100 "AcDbText")
								(cons 1   testo)
								(cons 7   style)
								(cons 10  (trans pstart 1 0))
								(cons 40  htesto)
								(cons 41  fatt_larg)
								(cons 210 (nth 3 cos_dir))
								(cons 11  (nth 1 cos_dir))
							)
					)
		)
		Rtn
	)	
	;
	; Main
	;
	(if EnameDimension
		(progn
			(setq BoxText      (SampleText EnameDimension))
			(setq LengthText   (abs (- (car (cadr BoxText)) (car (car BoxText)))))
		)
		LengthText
	)
)
;
(defun ChangePosText (EnameDimension Pos / obj)   

    (setq obj (vlax-ename->vla-object EnameDimension))
	(vla-put-TextOverride obj "" )
	
	(if (= Pos "\\X")
		(vla-put-TextOverride obj "\\X<>" )
		(vla-put-verticaltextposition obj Pos)
	)
)
;
;(defun LM:roundm ( n m )
;    (* m (atoi (rtos (/ n (float m)) 2 0)))
;)
;
;(defun NumToDim (Val EnameDim / Obj UnitsPrecision RoundDistance Suppress0 0Suppress Prefix Prefix Suffix TextDim)   
;
;	(if (and Val EnameDim)
;		(progn
;			(setq Obj         		(vlax-ename->vla-object   	EnameDim))
;			(setq UnitsPrecision    (vla-get-PrimaryUnitsPrecision 	Obj))
;			(setq RoundDistance     (vla-get-RoundDistance         	Obj))
;			(setq Suppress0  		(vla-get-SuppressTrailingZeros 	Obj))
;			(setq 0Suppress  		(vla-get-SuppressLeadingZeros  	Obj))
;			(setq Prefix			(vla-get-TextPrefix				Obj))
;			(setq Prefix			(vla-get-TextPrefix				Obj))
;			(setq Suffix			(vla-get-TextSuffix				Obj))
;			(setq TextDim 			(LM:rtos (LM:roundm Val RoundDistance) 2 UnitsPrecision))
;
;			(while (and (equal (substr TextDim 1 1) "0") (= 0Suppress ':vlax-true))
;				(setq TextDim (substr TextDim 2))
;			)
;			(while (and (equal (substr TextDim (strlen TextDim) 1) "0") (= Suppress0 ':vlax-true))
;				(setq TextDim (substr TextDim 1 (- (strlen TextDim) 1)))
;			)
;			(if (or (equal (substr TextDim (strlen TextDim) 1) ".") (equal (substr TextDim (strlen TextDim) 1) ","))
;				(setq TextDim (substr TextDim 1 (- (strlen TextDim) 1)))
;			)
;			(setq TextDim (strcat Prefix TextDim Suffix))
;			(if (equal TextDim "") (setq TextDim "0"))
;		)
;	)
;	TextDim
;)
;
(defun C:makeEntmake ( / a dwg path ent entl fn sset)

;; here's a thing that can make entmakes of almost anything pulled from a drawing:
;; correction by CAB 11/19/04 - did not remove douplicate codes
;; CAB added removal of 100 410 210
;; MP revised removal code

  (setq path (getvar "DWGPREFIX")
        dwg  (strcat path (vl-filename-base (getvar "DWGNAME")) ".lsp")
        fn   (open dwg "w")
        a    0
  )
  (cond
    (fn
     (cond ((setq sset (ssget))
            (repeat (sslength sset)
              (setq ent  (ssname sset a)
                    entl (entget ent  (list "*"))
                    entl (vl-remove-if
                            '(lambda (pair)
                                (member (car pair)
                                    ;'(-2 -1 5 102 300 330 331 350 360 100 210 410)
									'(-2 -1 5 102 300 330 331 350 360 210 410)
                                )
                             ) entL
                          )
              )
              (write-line (strcat "(entmake '" (vl-prin1-to-string entl) ")") fn)
              (setq a (1+ a))
            )
           )
     )
     (close fn)
	 (princ entl)
    )
  )
  (princ)
)
;
;
(defun GuiUnionDim ( / Ssel)

	(if (setq Ssel (ssget (DimFilter (list 0 1))))
		(UnionDim (LM:ss->ent Ssel))
	)
)
;
(defun UnionDim (ListEnameDim / FooRot FooDist EnameMaster ModelSpace EnameDimension)

	(setq FooRot  0.001)
	(setq FooDist 0.1)
	;
	(if ListEnameDim
		(progn
			(if (IfDimEqualName ListEnameDim (list "AcDbRotatedDimension" "AcDbAlignedDimension"))
				(if (setq Rotation (IfDimEqualRotation ListEnameDim FooRot))
					(if (setq PtDim (IfDimConsecutive ListEnameDim FooDist))
						(progn
							(setq EnameMaster    (car ListEnameDim))
							(setq ModelSpace     (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
							(setq EnameDimension (vlax-vla-object->ename (vla-adddimrotated  ModelSpace (vlax-3d-point (car PtDim)) 
																										(vlax-3d-point (cadr PtDim)) 
																										(vlax-3d-point (cdr (assoc 10 (entget EnameMaster)))) 
																										 Rotation)))
							(PutPropertyDim EnameMaster EnameDimension)
							(if EnameDimension (mapcar 'entdel ListEnameDim))
						)
					)
				)
			)
		)
	)
	EnameDimension
)
;
(defun GuiSplitDim ( / Ssel Pt LstPoint)

	(prompt "\nSeleziona quota..")
	(setq Ssel (ssget "_+.:E:S" (DimFilter (list 0 1))))
	(if Ssel
		(progn
			(setq Pt (getpoint "\nSeleziona punti.."))
			(while Pt
				(setq LstPoint (cons (trans Pt 1 0) LstPoint))
				(setq Pt (getpoint "\nSeleziona punti.."))
			)
			(if (and Ssel LstPoint) (SplitDim (ssname Ssel 0) LstPoint))
		)
	)
)
;
(defun SplitDim (EnameDimension LstPoint / SequencePointDimension
										   Rotation LstPointDim PosDim ModelSpace Num EnameDim)

	;
	(defun SequencePointDimension (EnameDimension LstPoint Rotation / P0 P1 P2 Ucs Pa Pb LstPt Zeta itm Rtn)
		
		(if (and EnameDimension LstPoint Rotation)
			(progn
				(setq P0  (list 0.0 0.0))
				(setq P1  (polar P0 Rotation 1.0))
				(setq P2  (per (car P1) (cadr P1) (car P0) (cadr P0) (- 0.0 1.0)))
				(setq Ucs (DefPiano (car P0) (cadr P0) 0.0 (car P1) (cadr P1) 0.0 (car P2) (cadr P2) 0.0))

				(setq Pa (cdr (assoc 13 (entget EnameDimension))))
				(setq Pb (cdr (assoc 14 (entget EnameDimension))))
					
				(setq LstPt (cons (transl (car Pa) (cadr Pa) (caddr Pa) Ucs) LstPt)) 
				(setq LstPt (cons (transl (car Pb) (cadr Pb) (caddr Pb) Ucs) LstPt))
				
				(foreach itm LstPoint
					(if (= (length itm) 2)
						(setq Zeta 0.0)
						(setq Zeta (caddr itm))
					)
					(setq LstPt (cons (transl (car itm) (cadr itm) Zeta Ucs) LstPt)) 
				)
				(setq LstPt (vl-sort LstPt (function (lambda (e1 e2)  (< (car e1) (car e2))))))
				(foreach itm LstPt
					(setq Rtn (cons (transg (car itm) (cadr itm) (caddr itm) Ucs) Rtn))
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if (and EnameDimension LstPoint)
		(progn
		
			(cond 
				((= (vlax-get-property (vlax-ename->vla-object EnameDimension) 'ObjectName) "AcDbRotatedDimension")
					(setq Rotation (cdr (assoc 50 (entget EnameDimension))))
				)
				((= (vlax-get-property (vlax-ename->vla-object EnameDimension) 'ObjectName) "AcDbAlignedDimension")
					(setq Rotation (angle (cdr (assoc 13 (entget EnameDimension))) (cdr (assoc 14 (entget EnameDimension)))))
				)
			)
			(setq LstPointDim (SequencePointDimension EnameDimension LstPoint Rotation))
			(setq PosDim (cdr (assoc 10 (entget EnameDimension))))
			(setq ModelSpace     (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
			(setq Num 0)
			(repeat (- (length LstPointDim) 1)
				(setq EnameDim (vlax-vla-object->ename (vla-adddimrotated  ModelSpace 	(vlax-3d-point (nth (+ Num 0) LstPointDim)) 
																						(vlax-3d-point (nth (+ Num 1) LstPointDim))
																						(vlax-3d-point PosDim)
																						Rotation)))
				(PutPropertyDim EnameMaster EnameDim)
				(setq Num (1+ Num))
			)
			(if EnameDim (entdel EnameDimension))
		)
	)
)
;
(defun GuiCompleteDim ( / Ssel)

	(if (setq Ssel (ssget (DimFilter (list 0 1))))
		(CompleteDim (LM:ss->ent Ssel))
	)
)
;
(defun CompleteDim (ListEnameDim / SequencePointDimension 
								   FooRot Rotation LstPointDim PosDim ModelSpace Num)

	;
	(defun SequencePointDimension (ListEnameDim Rotation / P0 P1 P2 Ucs Pa Pb LstPt itm Rtn)
		
		(if (and ListEnameDim Rotation)
			(progn
				(setq P0  (list 0.0 0.0))
				(setq P1  (polar P0 Rotation 1.0))
				(setq P2  (per (car P1) (cadr P1) (car P0) (cadr P0) (- 0.0 1.0)))
				(setq Ucs (DefPiano (car P0) (cadr P0) 0.0 (car P1) (cadr P1) 0.0 (car P2) (cadr P2) 0.0))

				(foreach itm ListEnameDim
					(setq Pa (cdr (assoc 13 (entget itm))))
					(setq Pb (cdr (assoc 14 (entget itm))))
					
					(setq LstPt (cons (transl (car Pa) (cadr Pa) (caddr Pa) Ucs) LstPt)) 
					(setq LstPt (cons (transl (car Pb) (cadr Pb) (caddr Pb) Ucs) LstPt))
				)
				
				(setq LstPt (vl-sort LstPt (function (lambda (e1 e2)  (< (car e1) (car e2))))))

				(foreach itm LstPt
					(setq Rtn (cons (transg (car itm) (cadr itm) (caddr itm) Ucs) Rtn))
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq FooRot  0.001)

	(if ListEnameDim
		(progn
			(if (IfDimEqualName ListEnameDim (list "AcDbRotatedDimension" "AcDbAlignedDimension"))
				(if (setq Rotation (IfDimEqualRotation ListEnameDim FooRot))
					(progn
						(setq LstPointDim (SequencePointDimension ListEnameDim Rotation))
						(setq PosDim (cdr (assoc 10 (entget (car ListEnameDim)))))
						(setq ModelSpace     (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
						(setq Num 0)
						(repeat (- (length LstPointDim) 1)
							(setq EnameDim (vlax-vla-object->ename (vla-adddimrotated  ModelSpace 	(vlax-3d-point (nth (+ Num 0) LstPointDim)) 
																									(vlax-3d-point (nth (+ Num 1) LstPointDim))
																									(vlax-3d-point PosDim)
																									Rotation)))
							(PutPropertyDim EnameMaster EnameDim)
							(setq Num (1+ Num))
						)
						(if EnameDim (mapcar 'entdel ListEnameDim))
					)
				)
			)
		)
	)
)
;
(defun PutPropertyDim (GetEnameDim PutEnameDim / ObjGet ObjPut)

	(if (and GetEnameDim PutEnameDim)
		(progn
			(setq ObjGet (vlax-ename->vla-object GetEnameDim))
			(setq ObjPut (vlax-ename->vla-object PutEnameDim))
			(vla-put-stylename							ObjPut (vla-get-stylename							ObjGet))
			(vla-put-verticaltextposition 				ObjPut (vla-get-altrounddistance 					ObjGet))
			(vla-put-altrounddistance					ObjPut (vla-get-altrounddistance 					ObjGet))
			(vla-put-altsubunitsfactor					ObjPut (vla-get-altsubunitsfactor 					ObjGet))
			(vla-put-altsubunitssuffix					ObjPut (vla-get-altsubunitssuffix 					ObjGet))
			(vla-put-altsuppressleadingzeros			ObjPut (vla-get-altsuppressleadingzeros 			ObjGet))
			(vla-put-altsuppresstrailingzeros			ObjPut (vla-get-altsuppresstrailingzeros 			ObjGet))
			(vla-put-altsuppresszerofeet				ObjPut (vla-get-altsuppresszerofeet 				ObjGet))
			(vla-put-altsuppresszeroinches				ObjPut (vla-get-altsuppresszeroinches 				ObjGet))
			(vla-put-alttextprefix						ObjPut (vla-get-alttextprefix 						ObjGet))
			(vla-put-alttextsuffix						ObjPut (vla-get-alttextsuffix 						ObjGet))
			(vla-put-alttoleranceprecision				ObjPut (vla-get-alttoleranceprecision				ObjGet))
			(vla-put-alttolerancesuppressleadingzeros	ObjPut (vla-get-alttolerancesuppressleadingzeros	ObjGet))
			(vla-put-alttolerancesuppresstrailingzeros	ObjPut (vla-get-alttolerancesuppresstrailingzeros	ObjGet))
			(vla-put-alttolerancesuppresszerofeet		ObjPut (vla-get-alttolerancesuppresszerofeet		ObjGet))
			(vla-put-alttolerancesuppresszeroinches		ObjPut (vla-get-alttolerancesuppresszeroinches		ObjGet))
			(vla-put-altunits							ObjPut (vla-get-altunits							ObjGet))
			(vla-put-altunitsformat						ObjPut (vla-get-altunitsformat						ObjGet))
			(vla-put-altunitsprecision					ObjPut (vla-get-altunitsprecision					ObjGet))
			(vla-put-altunitsscale						ObjPut (vla-get-altunitsscale						ObjGet))
			(vla-put-arrowhead1block					ObjPut (vla-get-arrowhead1block						ObjGet))
			(vla-put-arrowhead1type						ObjPut (vla-get-arrowhead1type						ObjGet))
			(vla-put-arrowhead2block					ObjPut (vla-get-arrowhead2block						ObjGet))
			(vla-put-arrowhead2type						ObjPut (vla-get-arrowhead2type						ObjGet))
			(vla-put-arrowheadsize						ObjPut (vla-get-arrowheadsize						ObjGet))
			(vla-put-decimalseparator					ObjPut (vla-get-decimalseparator					ObjGet))
			(vla-put-dimconstrform						ObjPut (vla-get-dimconstrform						ObjGet))
			(vla-put-dimconstrreference					ObjPut (vla-get-dimconstrreference					ObjGet))
			(vla-put-dimensionlinecolor					ObjPut (vla-get-dimensionlinecolor					ObjGet))
			(vla-put-dimensionlineextend				ObjPut (vla-get-dimensionlineextend					ObjGet))
			(vla-put-dimensionlinetype					ObjPut (vla-get-dimensionlinetype					ObjGet))
			(vla-put-dimensionlineweight				ObjPut (vla-get-dimensionlineweight					ObjGet))
			(vla-put-dimline1suppress					ObjPut (vla-get-dimline1suppress					ObjGet))
			(vla-put-dimline2suppress					ObjPut (vla-get-dimline2suppress					ObjGet))
			(vla-put-dimlineinside						ObjPut (vla-get-dimlineinside						ObjGet))
			(vla-put-dimtxtdirection					ObjPut (vla-get-dimtxtdirection						ObjGet))
			(vla-put-entitytransparency					ObjPut (vla-get-entitytransparency					ObjGet))
			(vla-put-extensionlinecolor					ObjPut (vla-get-extensionlinecolor					ObjGet))
			(vla-put-extensionlineextend				ObjPut (vla-get-extensionlineextend					ObjGet))
			(vla-put-extensionlineoffset				ObjPut (vla-get-extensionlineoffset					ObjGet))
			(vla-put-extensionlineweight				ObjPut (vla-get-extensionlineweight					ObjGet))
			(vla-put-extline1linetype					ObjPut (vla-get-extline1linetype					ObjGet))
			(vla-put-extline1suppress					ObjPut (vla-get-extline1suppress					ObjGet))
			(vla-put-extline2linetype					ObjPut (vla-get-extline2linetype					ObjGet))
			(vla-put-extline2suppress					ObjPut (vla-get-extline2suppress					ObjGet))
			(vla-put-extlinefixedlen					ObjPut (vla-get-extlinefixedlen						ObjGet))
			(vla-put-extlinefixedlensuppress			ObjPut (vla-get-extlinefixedlensuppress				ObjGet))
			(vla-put-fit								ObjPut (vla-get-fit									ObjGet))
			(vla-put-forcelineinside					ObjPut (vla-get-forcelineinside						ObjGet))
			(vla-put-fractionformat						ObjPut (vla-get-fractionformat						ObjGet))
			(vla-put-horizontaltextposition				ObjPut (vla-get-horizontaltextposition				ObjGet))
			(vla-put-layer								ObjPut (vla-get-layer								ObjGet))
			(vla-put-linearscalefactor					ObjPut (vla-get-linearscalefactor					ObjGet))
			(vla-put-linetype							ObjPut (vla-get-linetype							ObjGet))
			(vla-put-linetypescale						ObjPut (vla-get-linetypescale						ObjGet))
			(vla-put-lineweight							ObjPut (vla-get-lineweight							ObjGet))
			(vla-put-material							ObjPut (vla-get-material							ObjGet))
			(vla-put-primaryunitsprecision				ObjPut (vla-get-primaryunitsprecision				ObjGet))
			(vla-put-rounddistance						ObjPut (vla-get-rounddistance						ObjGet))
			(vla-put-scalefactor						ObjPut (vla-get-scalefactor							ObjGet))
			(vla-put-subunitsfactor						ObjPut (vla-get-subunitsfactor						ObjGet))
			(vla-put-subunitssuffix						ObjPut (vla-get-subunitssuffix						ObjGet))
			(vla-put-suppressleadingzeros				ObjPut (vla-get-suppressleadingzeros				ObjGet))
			(vla-put-suppresstrailingzeros				ObjPut (vla-get-suppresstrailingzeros				ObjGet))
			(vla-put-suppresszerofeet					ObjPut (vla-get-suppresszerofeet					ObjGet))
			(vla-put-suppresszeroinches					ObjPut (vla-get-suppresszeroinches					ObjGet))
			(vla-put-textcolor							ObjPut (vla-get-textcolor							ObjGet))
			(vla-put-textfill							ObjPut (vla-get-textfill							ObjGet))
			(vla-put-textfillcolor						ObjPut (vla-get-textfillcolor						ObjGet))
			(vla-put-textgap							ObjPut (vla-get-textgap								ObjGet))
			(vla-put-textheight							ObjPut (vla-get-textheight							ObjGet))
			(vla-put-textinside							ObjPut (vla-get-textinside							ObjGet))
			(vla-put-textinsidealign					ObjPut (vla-get-textinsidealign						ObjGet))
			(vla-put-textmovement						ObjPut (vla-get-textmovement						ObjGet))
			(vla-put-textoutsidealign					ObjPut (vla-get-textoutsidealign					ObjGet))
			(vla-put-textprefix							ObjPut (vla-get-textprefix							ObjGet))
			(vla-put-textrotation						ObjPut (vla-get-textrotation						ObjGet))
			(vla-put-textstyle							ObjPut (vla-get-textstyle							ObjGet))
			(vla-put-textsuffix							ObjPut (vla-get-textsuffix							ObjGet))
			(vla-put-tolerancedisplay					ObjPut (vla-get-tolerancedisplay					ObjGet))
			(vla-put-toleranceheightscale				ObjPut (vla-get-toleranceheightscale				ObjGet))
			(vla-put-tolerancejustification				ObjPut (vla-get-tolerancejustification				ObjGet))
			(vla-put-tolerancelowerlimit				ObjPut (vla-get-tolerancelowerlimit					ObjGet))
			(vla-put-toleranceprecision					ObjPut (vla-get-toleranceprecision					ObjGet))
			(vla-put-tolerancesuppressleadingzeros		ObjPut (vla-get-tolerancesuppressleadingzeros		ObjGet))
			(vla-put-tolerancesuppresstrailingzeros		ObjPut (vla-get-tolerancesuppresstrailingzeros		ObjGet))
			(vla-put-tolerancesuppresszerofeet			ObjPut (vla-get-tolerancesuppresszerofeet			ObjGet))
			(vla-put-tolerancesuppresszeroinches		ObjPut (vla-get-tolerancesuppresszeroinches			ObjGet))
			(vla-put-toleranceupperlimit				ObjPut (vla-get-toleranceupperlimit					ObjGet))
			(vla-put-unitsformat						ObjPut (vla-get-unitsformat							ObjGet))
			(vla-put-verticaltextposition				ObjPut (vla-get-verticaltextposition				ObjGet))
			(vla-put-visible							ObjPut (vla-get-visible								ObjGet))
			;	textoverride = ""
			;   rotation = 5.42968
			;	plotstylename = "ByLayer"
			;	dimconstrdesc = eccezione
			;	dimconstrexpression = eccezione
			;	dimconstrname = eccezione
			;	dimconstrvalue = eccezione
		)
	)
)
;
(defun IfDimEqualName (ListEnameDim LstName / itm Rtn)
	;
	; LstName = "AcDbAlignedDimension"
	;		    "AcDbRotatedDimension"
	;
	(if ListEnameDim
		(progn
			(setq Rtn T)
			(foreach itm ListEnameDim
				(if (not (member  (vlax-get-property (vlax-ename->vla-object itm) 'ObjectName) LstName))
					(setq Rtn nil)
				)
			)
		)
	)
	Rtn
)
;
(defun IfDimEqualRotation (ListEnameDim Foo / Rotation Ang+Pi 
											  itm Chk Rtn)
	;
	(defun GetRotateDimension (EnameDimension / Rtn)
		(if EnameDimension
			(progn
				(cond 
					((= (vlax-get-property (vlax-ename->vla-object EnameDimension) 'ObjectName) "AcDbRotatedDimension")
						(setq Rtn (cdr (assoc 50 (entget EnameDimension))))
					)
					((= (vlax-get-property (vlax-ename->vla-object EnameDimension) 'ObjectName) "AcDbAlignedDimension")
						(setq Rtn (angle (cdr (assoc 13 (entget EnameDimension))) (cdr (assoc 14 (entget EnameDimension)))))
					)
				)
			)
		)
		Rtn
	)
	;
	(defun Ang+Pi (Rad / Rtn)
		(if Rad
			(progn
				(setq Rtn (+ Rad Pi))
				(if (> Rtn (* 2.0 Pi)) (setq Rtn (- Rad Pi)))
			)
		)
		Rtn
	)
	;
	(if (and ListEnameDim Foo)
		(progn
			(setq Rtn (GetRotateDimension (car ListEnameDim)))
			
			(foreach itm (cdr ListEnameDim)
				(if (not (or (equal (Ang+Pi (GetRotateDimension itm)) Rtn Foo)
							 (equal (GetRotateDimension itm) Rtn Foo)
						 )
					)
					(setq Rtn nil)
				)
			)
		)
	)
	Rtn
)
;
(defun IfDimConsecutive (ListEnameDim Foo / P0 P1 P2 Ucs itm Pa Pb LstPt Num Rtn)
	;
	(if (and ListEnameDim Foo)
		(progn
			(setq Rtn T)
			(setq P0  (list 0.0 0.0))
			(setq P1  (polar P0 (cdr (assoc 50 (entget (car ListEnameDim)))) 1.0))
			(setq P2  (per (car P1) (cadr P1) (car P0) (cadr P0) (- 0.0 1.0)))
			(setq Ucs (DefPiano (car P0) (cadr P0) 0.0 (car P1) (cadr P1) 0.0 (car P2) (cadr P2) 0.0))
			
			(foreach itm ListEnameDim
				(setq Pa (cdr (assoc 13 (entget itm))))
				(setq Pb (cdr (assoc 14 (entget itm))))
				
				(setq LstPt (cons (transl (car Pa) (cadr Pa) (caddr Pa) Ucs) LstPt)) 
				(setq LstPt (cons (transl (car Pb) (cadr Pb) (caddr Pb) Ucs) LstPt)) 
			)
			
			(setq LstPt (vl-sort LstPt (function (lambda (e1 e2)  (< (car e1) (car e2))))))

			(setq Num 1)
			(repeat (/ (- (length LstPt) 2) 2)
				(if (not (equal (car (nth (+ Num 0) LstPt)) (car (nth (+ Num 1) LstPt)) Foo))
						(setq Rtn nil)
				)
				(setq Num (+ Num 2))
			)
			(if Rtn
				(setq Rtn (list (transg (car (car LstPt)) (cadr (car LstPt)) (caddr (car LstPt)) Ucs)
								(transg (car (car (reverse LstPt))) (cadr (car (reverse LstPt))) (caddr (car (reverse LstPt))) Ucs)
						  )
				)
			)
		)
	)
	Rtn
)

;
(defun PurgeCollinearPointPoligon (LstPoint / ChkCollinearList RemoveCollinearPointList
											  Rtn)
	;
	(defun ChkCollinearList (LstPoint / Rtn Loop Num)

		(if (> (length LstPoint) 2)
			(progn
				(setq LstPoint (append LstPoint (list (nth 0 LstPoint))))
				(setq Num 0)
				(setq Loop T)
				(while Loop
					(if (LM:Collinear-p (nth (+ Num 0) LstPoint) (nth (+ Num 1) LstPoint) (nth (+ Num 2) LstPoint) 1e-8)
						(setq Loop nil
							  Rtn  T
						)
					)
					(setq Num (1+ Num))
					(if (= Num (- (length LstPoint) 2))
						(setq Loop nil)
					)
				)
			)
		)
		Rtn
	)
	;
	(defun RemoveCollinearPointList (LstPoint / Loop Num LstPoint Rtn)

		(setq Loop T)
		(setq Num 0)
		(setq LstPoint (append LstPoint (list (nth 0 LstPoint))))
		
		(while Loop
			(if (LM:Collinear-p (nth (+ Num 0) LstPoint) (nth (+ Num 1) LstPoint) (nth (+ Num 2) LstPoint) 1e-8)
				(setq Rtn (LM:RemoveNth (+ Num 1) LstPoint)
					  Loop nil
				)
			)
			(setq Num (+ Num 1))
			(if (= Num (- (length LstPoint) 2)) 
				(setq Loop nil)
			)
		)
		(setq Rtn (LM:RemoveNth (- (length Rtn) 1) Rtn))
		Rtn
	)
	;
	(if LstPoint
		(progn
			;(LM:ListCollinear-p LstPoint)
			(setq Rtn LstPoint)
			(while (ChkCollinearList Rtn)
				(setq Rtn (RemoveCollinearPointList Rtn))
			)
		)
	)
	Rtn
)
;
(defun BatchDimensionXY (Ssel SectorX SectorY TypeDim GPosDimX GPosDimY / MaxMin
																		  OffsetDim LstMaxMin PosDimX PosDimY GPtDim Rtn)
;
;			  3				
;		+-----------+
;		|			|
;	2	|  Sector	|	1
;		|			|
;		|			|
;		+-----------+
;			  4
;

	(if (and Ssel SectorX SectorY TypeDim GPosDimX GPosDimY)
		(progn
			(setq Rtn 				(BatchDimension Ssel SectorX TypeDim GPosDimX))
			(setq Rtn (append Rtn 	(BatchDimension Ssel SectorY TypeDim GPosDimY)))
		)
	)
	Rtn
)
;
(defun DimensionXY (Ssel TypeDim LstEnameExtraSizie Inter / *error*
															LstDimension SectorX SectorY LstDim TypeDim OffsetDim GPosXY msgLstDim Loop gr code data)

	(defun *error* (msg)
		(if LstDim (DeleteEntity LstDim))
	)
	;
	; Main
	;
	(if (and Ssel TypeDim)
		(progn
			(setq LstDimension (GetPointDimension Ssel))
			(if LstDimension
				(progn
					(setq SectorX 3)
					(setq SectorY 1)
					(setq LstDim nil)
					(setq OffsetDim (* (* (getvar "DIMDLI") (getvar "DIMSCALE")) 2.0))
					
					(setq Box 		(UcsBoundingBoxLstEname (append (LM:ss->ent Ssel) LstEnameExtraSizie)))
					(setq GPosXY  	(GetGlobalPosDim (TransLstPointTo Box 0) OffsetDim nil))
					(setq LstDim 	(BatchDimensionXY Ssel SectorX SectorY TypeDim (nth (- SectorX 1) GPosXY) (nth (- SectorY 1) GPosXY)))

					(setq msgLstDim (list "\r[Tab]cambia orientamento [+/-]sposta quota "))
					(if (and LstDim Inter) 
						(progn
							(setq Loop T)
							(princ (car msgLstDim))
						)
					)
					(while Loop
						(setq gr (grread t 15 2) code (car gr) data (cadr gr))
			
						(cond 
							((and (= code 2) (= data 9)) ; [tab]	
								(cond
									((= SectorX 3) (setq SectorX 4))
									((= SectorX 4) (setq SectorX 3))
								)
								(cond 
									((= SectorY 1) (setq SectorY 2))
									((= SectorY 2) (setq SectorY 1))
								)
								(if LstDim    (DeleteEntity LstDim)) 
								(setq Box 	  (UcsBoundingBoxLstEname (append (LM:ss->ent Ssel) LstEnameExtraSizie)))
								(setq GPosXY  (GetGlobalPosDim (TransLstPointTo Box 0) OffsetDim nil))
								(setq LstDim  (BatchDimensionXY Ssel SectorX SectorY TypeDim (nth (- SectorX 1) GPosXY) (nth (- SectorY 1) GPosXY)))
							)
							
							((and (= code 2) (= data 43)) ; [+]
								
								(setq OffsetDim (+ OffsetDim (* (getvar "DIMDLI") (getvar "DIMSCALE"))))
								(if LstDim      (DeleteEntity LstDim))
								(setq Box 	    (UcsBoundingBoxLstEname (append (LM:ss->ent Ssel) LstEnameExtraSizie)))
								(setq GPosXY    (GetGlobalPosDim (TransLstPointTo Box 0) OffsetDim nil))
								(setq LstDim    (BatchDimensionXY Ssel SectorX SectorY TypeDim (nth (- SectorX 1) GPosXY) (nth (- SectorY 1) GPosXY)))
							)
							
							((and (= code 2) (= data 45)) ; [-]

								(setq OffsetDim (- OffsetDim (* (getvar "DIMDLI") (getvar "DIMSCALE"))))
								(if LstDim      (DeleteEntity LstDim))
								(setq Box 	    (UcsBoundingBoxLstEname (append (LM:ss->ent Ssel) LstEnameExtraSizie)))
								(setq GPosXY    (GetGlobalPosDim (TransLstPointTo Box 0) OffsetDim nil))
								(setq LstDim    (BatchDimensionXY Ssel SectorX SectorY TypeDim (nth (- SectorX 1) GPosXY) (nth (- SectorY 1) GPosXY)))
							)
							
							((and (= code 2) (= data 13)) ; [enter]
								(setq Loop nil)
							)
							(t
								nil
							)
						)
					)
				)
			)
		)
	)
	LstDim
)
;
(defun DimensionMatrix (Ssel TypeDim LstEnameExtraSizie Inter / *error*
																Box Num LstDimension LstHull EnamePoligon 
																SectorX SectorY TypeDim OffsetDim GPosXY LstDim msgLstDim Loop gr code data)

	(defun *error* (msg)
		(if EnamePoligon
			(if (entget EnamePoligon)
				(entdel EnamePoligon)
			)
		)
		(if LstDim (DeleteEntity LstDim))
		(RestoreUcs "GuiDimensionMatrix")
		(DeleteUCS  "GuiDimensionMatrixUcsWork")
	)
	;
	; Main
	;
	(if (and Ssel TypeDim)
		(progn
			(setq LstDimension (GetPointDimension Ssel))
			(if LstDimension
				(progn
					(setq LstHull (LM:ConvexHull LstDimension))
					(setq LstHull (PurgeCollinearPointPoligon LstHull))
					; check ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					;(setq EnamePoligon (MakePolyline LstHull T))
					; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					(setq Num 1)
					(setq SectorX 3)
					(setq SectorY 1)
					(setq LstDim nil)
					(SaveUcs "GuiDimensionMatrix")
					(SetUcs2P (nth 0 LstHull) (nth 1 LstHull) "GuiDimensionMatrixUcsWork")

					(setq OffsetDim (* (* (getvar "DIMDLI") (getvar "DIMSCALE")) 2.0))

					(setq Box 		(UcsBoundingBoxLstEname (append (LM:ss->ent Ssel) LstEnameExtraSizie)))
					(setq GPosXY  	(GetGlobalPosDim (TransLstPointTo Box 0) OffsetDim nil))
					(setq LstDim 	(BatchDimensionXY Ssel SectorX SectorY TypeDim (nth (- SectorX 1) GPosXY) (nth (- SectorY 1) GPosXY)))
					
					(setq msgLstDim (list "\r[Tab]cambia orientamento [+/-]sposta quota "))
					(if (and LstDim Inter)
						(progn
							(setq Loop T)
							(princ (car msgLstDim))
						)
					)
					
					(while Loop
						(setq gr (grread t 15 2) code (car gr) data (cadr gr))
			
						(cond 
							((and (= code 2) (= data 9)) ; [tab]
								(if (> (length LstHull) 2)
									(if (< Num (- (length LstHull) 1))
										(progn
											(SetUcs2P (nth (+ Num 0) LstHull) (nth (+ Num 1) LstHull) "GuiDimensionMatrixUcsWork")
											(setq Num (1+ Num))
										)
										(progn
											(SetUcs2P (nth Num LstHull) (nth 0 LstHull) "GuiDimensionMatrixUcsWork")
											(setq Num 0)
										)
									)
								)
								(cond
									((= SectorX 3) (setq SectorX 4))
									((= SectorX 4) (setq SectorX 3))
								)
								(cond 
									((= SectorY 1) (setq SectorY 2))
									((= SectorY 2) (setq SectorY 1))
								)
								(if LstDim    (DeleteEntity LstDim))
								(setq Box 	  (UcsBoundingBoxLstEname (append (LM:ss->ent Ssel) LstEnameExtraSizie)))
								(setq GPosXY  (GetGlobalPosDim (TransLstPointTo Box 0) OffsetDim nil))
								(setq LstDim  (BatchDimensionXY Ssel SectorX SectorY TypeDim (nth (- SectorX 1) GPosXY) (nth (- SectorY 1) GPosXY)))
							)
							
							((and (= code 2) (= data 43)) ; [+]
								
								(setq OffsetDim (+ OffsetDim (* (getvar "DIMDLI") (getvar "DIMSCALE"))))
								(if LstDim 	    (DeleteEntity LstDim))
								(setq Box 	  	(UcsBoundingBoxLstEname (append (LM:ss->ent Ssel) LstEnameExtraSizie)))
								(setq GPosXY  	(GetGlobalPosDim (TransLstPointTo Box 0) OffsetDim nil))
								(setq LstDim    (BatchDimensionXY Ssel SectorX SectorY TypeDim (nth (- SectorX 1) GPosXY) (nth (- SectorY 1) GPosXY)))
							)
							
							((and (= code 2) (= data 45)) ; [-]

								(setq OffsetDim (- OffsetDim (* (getvar "DIMDLI") (getvar "DIMSCALE"))))
								(if LstDim 	    (DeleteEntity LstDim))
								(setq Box 	  	(UcsBoundingBoxLstEname (append (LM:ss->ent Ssel) LstEnameExtraSizie)))
								(setq GPosXY  	(GetGlobalPosDim (TransLstPointTo Box 0) OffsetDim nil))
								(setq LstDim    (BatchDimensionXY Ssel SectorX SectorY TypeDim (nth (- SectorX 1) GPosXY) (nth (- SectorY 1) GPosXY)))
							)
							
							((and (= code 2) (= data 13)) ; [enter]
								(setq Loop nil)
								;(if EnamePoligon
								;	(if (entget EnamePoligon)
								;		(entdel EnamePoligon)
								;	)
								;)
							)
							(t
								nil
							)
						)
					)
					(RestoreUcs "GuiDimensionMatrix")
					(DeleteUCS  "GuiDimensionMatrixUcsWork")
				)
			)
        )
    )
)
;
;(defun LM:Collinear-p ( p1 p2 p3 )
;	; Returns T if p1,p2,p3 are collinear
;   (
;        (lambda ( a b c )
;            (or
;                (equal (+ a b) c 1e-8)
;                (equal (+ b c) a 1e-8)
;                (equal (+ c a) b 1e-8)
;            )
;        )
;        (distance p1 p2) (distance p2 p3) (distance p1 p3)
;    )
;)
;
;
;(defun LM:ConvexHull ( lst / RotatePt ch p0 Preci Ang PtR)
;
;	(defun RotatePt (P0 Ang LstPt / itm Rtn)
;		(if (and P0 Ang LstPt)
;			(foreach itm LstPt
;				(setq Rtn (append Rtn (list (list (+ (car  P0) (* (distance P0 itm) (cos (+ (angle P0 itm) Ang))))
;												  (+ (cadr P0) (* (distance P0 itm) (sin (+ (angle P0 itm) Ang))))
;											))))
;			)
;		)
;		Rtn
;	)
;		
;	(setq Preci 1e-8)
;	(setq Ang 0.12211221)
;	(setq PtR '(0.0 0.0))
;	
;   (cond
;        (   (< (length lst) 4) 
;			lst
;		)
;        (   (setq lst (RotatePt PtR Ang lst))
;			(setq p0 (car lst))
;            (foreach p1 (cdr lst)
;                (if (or (< (cadr p1) (cadr p0))
;                        (and (equal (cadr p1) (cadr p0) Preci) (< (car p1) (car p0)))
;                    )
;                    (setq p0 p1)
;                )
;            )
;            (setq lst
;                (vl-sort lst
;                    (function
;                        (lambda ( a b / c d )
;                            (if (equal (setq c (angle p0 a)) (setq d (angle p0 b)) Preci)
;                                (< (distance p0 a) (distance p0 b))
;                                (< c d)
;                            )
;                        )
;                    )
;                )
;            )
;            (setq ch (list (caddr lst) (cadr lst) (car lst)))
;            (foreach pt (cdddr lst)
;                (setq ch (cons pt ch))
;                (while (and (caddr ch) (LM:Clockwise-p (caddr ch) (cadr ch) pt))
;                    (setq ch (cons pt (cddr ch)))
;                )
;            )
;            (RotatePt PtR (* -1.0 Ang) ch)
;        )
;    )
;)
;
;(defun LM:Clockwise-p ( p1 p2 p3 / Preci)
;
;	(setq Preci 1e-8)
;    (<  (-  (* (- (car  p2) (car  p1)) (- (cadr p3) (cadr p1)))
;            (* (- (cadr p2) (cadr p1)) (- (car  p3) (car  p1)))
;        )
;        Preci
;    )
;)
;
(defun DimFilter ( typ  / bit-combinations itm Filter)

	; typ = (0)   dimension rotate
	; typ = (1)   dimension allign
	; typ = (6)   ordinate
	; typ = (0 1) dimension rotate+allign
	; typ = (0 6) dimension rotate+ordinate
	; ecc .......

	(defun bit-combinations ( l / foo bar )
		(defun foo ( l r )
			(if (and l (< 1 r))
				(append (mapcar '(lambda ( x ) (+ (car l) x)) (foo (cdr l) (1- r))) (foo (cdr l) r))
				l
			)
		)
		(defun bar ( l r )
			(if (< 0 r) (append (bar l (1- r)) (foo l r)))
		)
		(cons 0 (bar l (length l)))
	)
	;
	; Main
	;
	(foreach itm typ
		(setq Filter (append Filter (mapcar '(lambda ( x ) (cons 70 (+ itm x))) (bit-combinations '(32 64 128)))))
	)
    (append
       '((0 . "*DIMENSION") (-4 . "<OR"))
        ;(mapcar '(lambda ( x ) (cons 70 (+ typ x))) (bit-combinations '(32 64 128)))
		Filter
       '((-4 . "OR>"))
    )
)

;
(defun DimensionShape (EnameShape TypeDim LstEnameExtraSizie Inter / *error* LogicSector
																	 Box OffsetDim GLstPosDim LstSector itm Rtn LstDim msgLstDim Loop gr code data)
	
	(defun *error* (msg)
		(if LstDim (DeleteEntity LstDim))
	)
	;
	(defun LogicSector (EnameShape / DefaultSector Preci GPtDim LstSector)
		
		(setq DefaultSector (list 2 4))
		(if EnameShape
			(progn
				(setq Preci 0.25)
				(setq GPtDim (RegappDimPointShape EnameShape (list 1 2 3 4) Preci))
				
				(if (> (length (nth 0 GPtDim)) 2) (setq LstSector (cons 1 LstSector)))
				(if (> (length (nth 1 GPtDim)) 2) (setq LstSector (cons 2 LstSector)))
				(if (> (length (nth 2 GPtDim)) 2) (setq LstSector (cons 3 LstSector)))
				(if (> (length (nth 3 GPtDim)) 2) (setq LstSector (cons 4 LstSector)))
				
				(if (not LstSector) 
					(setq LstSector DefaultSector)
					(cond 
						((and (not (member 1 LstSector)) (not (member 2 LstSector)))
							(setq LstSector (cons 2 LstSector))
						)
						((and (not (member 3 LstSector)) (not (member 4 LstSector)))
							(setq LstSector (cons 4 LstSector))
						)
					)
				)
			)
		)
		LstSector
	)
	;
	; Main
	;
	(if (and EnameShape TypeDim)
		(progn
		
			(if LstEnameExtraSizie
				(setq Box (UcsBoundingBoxLstEname (cons EnameShape LstEnameExtraSizie)))
				(setq Box (UcsBoundingBoxLstEname (list EnameShape)))
			)
			(setq OffsetDim   (* (* (getvar "DIMDLI") (getvar "DIMSCALE")) 2.0))
			(setq GLstPosDim  (GetGlobalPosDim (TransLstPointTo Box 0) OffsetDim nil))
			(setq LstSector   (LogicSector EnameShape))
			
			(foreach itm LstSector
				(setq Rtn (BatchDimensionShape EnameShape itm TypeDim (nth (- itm 1) GLstPosDim)))
				(if Rtn (setq LstDim (append LstDim Rtn)))
			)
			
			(setq msgLstDim (list "\r[+/-]sposta quota "))
			(if (and Rtn Inter)
				(progn
					(setq Loop T)
					(princ (car msgLstDim))
				)
			)
			(while Loop
				(setq gr (grread t 15 2) code (car gr) data (cadr gr))

				(cond 
					
					((and (= code 2) (= data 43)) ; [+]
						
						(setq OffsetDim   (+ OffsetDim (* (getvar "DIMDLI") (getvar "DIMSCALE"))))
						(if LstDim        (DeleteEntity LstDim))
						(setq GLstPosDim  (GetGlobalPosDim (TransLstPointTo Box 0) OffsetDim nil))
						(setq LstDim      nil)
						(foreach itm LstSector
							(setq Rtn (BatchDimensionShape EnameShape itm TypeDim (nth (- itm 1) GLstPosDim)))
							(if Rtn (setq LstDim (append LstDim Rtn)))
						)
					)
					
					((and (= code 2) (= data 45)) ; [-]

						(setq OffsetDim  (- OffsetDim (* (getvar "DIMDLI") (getvar "DIMSCALE"))))
						(if LstDim       (DeleteEntity LstDim))
						(setq GLstPosDim (GetGlobalPosDim (TransLstPointTo Box 0) OffsetDim nil))
						(setq LstDim      nil)
						(foreach itm LstSector
							(setq Rtn (BatchDimensionShape EnameShape itm TypeDim (nth (- itm 1) GLstPosDim)))
							(if Rtn (setq LstDim (append LstDim Rtn)))
						)
					)
					
					((and (= code 2) (= data 13)) ; [enter]
						(setq Loop nil)
					)
					(t
						nil
					)
				)
						
			)
			
		)
	)
)
;
(defun GetGlobalPosDim (GLstPoint OffsetDim LstEnameExtraSizie / MaxMin
																 LstMaxMin Rtn)

	(defun MaxMin (GPointDimension / itm LPointDimension MinX MinY MaxX MaxY Rtn)
		
		(if GPointDimension
			(progn
				(foreach itm GPointDimension
					(setq LPointDimension (append LPointDimension (list (trans itm 0 1))))
				)
				(setq MinX (apply 'min (mapcar 'car  LPointDimension)))
				(setq MaxX (apply 'max (mapcar 'car  LPointDimension)))
				(setq MinY (apply 'min (mapcar 'cadr LPointDimension)))
				(setq MaxY (apply 'max (mapcar 'cadr LPointDimension)))		
				(setq Rtn (list MinX MinY MaxX MaxY))
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if (and GLstPoint OffsetDim)
		(progn
		
			(if LstEnameExtraSizie
				(progn 
					(setq Box       (UcsBoundingBoxLstEname LstEnameExtraSizie))
					(setq GLstPoint (append GLstPoint (TransLstPointTo Box 0)))
				)
			)
		
			(setq LstMaxMin (MaxMin GLstPoint))
			(setq Rtn (list 
						(trans (list (+ (nth 2 LstMaxMin) OffsetDim) (nth 1 LstMaxMin)) 				1 0) ;Sector 1
						(trans (list (- (nth 0 LstMaxMin) OffsetDim) (nth 1 LstMaxMin)) 				1 0) ;Sector 2
						(trans (list (nth 0 LstMaxMin) 				 (+ (nth 3 LstMaxMin) OffsetDim)) 	1 0) ;Sector 3
						(trans (list (nth 0 LstMaxMin) 				 (- (nth 1 LstMaxMin) OffsetDim)) 	1 0) ;Sector 4
					)
			)
			
		)
	)
	Rtn
)
;
(defun RegappDimPointShape (EnameShape LstSector Preci / FilterPointShape PurgeNearPoint
														 itm Rtn)

	(defun FilterPointShape (EnameShape Sector Preci / ModelSpace Box LengthShape HeightShape itm P1 P2 EnameLine Pint Rtn)
	
		(if (and EnameShape Sector Preci)
			(progn
				(setq ModelSpace 	(vla-get-modelspace(vla-get-activedocument(vlax-get-acad-object))))
				(setq Box 		 	(ucs-bbox	EnameShape))
				(setq LengthShape	(- (car  (cadr Box)) (car  (car Box))))
				(setq HeightShape	(- (cadr (cadr Box)) (cadr (car Box))))
				
				(foreach itm (GetCoordinateDummyEname EnameShape)
				
					(if (= (length itm) 2) (setq itm (list (car itm) (cadr itm) 0.0)))
					
					(setq P1 (trans itm 0 1)) 
					
					(cond
						((= Sector 1)
							(setq P2 (list (+ (car P1) (* LengthShape 2.0)) (cadr P1)))
						)
						((= Sector 2)
							(setq P2 (list (- (car P1) (* LengthShape 2.0)) (cadr P1)))
						)
						((= Sector 3)
							(setq P2 (list (car P1) (+ (cadr P1) (* HeightShape 2.0))))
						)
						((= Sector 4)
							(setq P2 (list (car P1) (- (cadr P1) (* HeightShape 2.0))))
						)
					)
					(setq EnameLine (vlax-vla-object->ename (vla-addline ModelSpace (vlax-3d-point (trans P1 1 0)) (vlax-3d-point (trans P2 1 0)))))
					(setq Pint      (MainVla-IntersectWith EnameShape EnameLine))
					(entdel EnameLine)
					(if (= (length Pint) 1)
						(setq Rtn (append Pint Rtn))
					)
				)
				(setq Rtn (PurgeNearPoint (LM:UniqueFuzz Rtn Preci) Sector Preci))
			)
		)
		Rtn
	)
	;
	(defun PurgeNearPoint (LPtDim Sector Preci / Num Chk)
	
		(cond 
			((or (= Sector 1) (= Sector 2))
				(setq LPtDim (vl-sort LPtDim (function (lambda (e1 e2)  (< (cadr e1) (cadr e2))))))
			)
			((or (= Sector 3) (= Sector 4))
				(setq LPtDim (vl-sort LPtDim (function (lambda (e1 e2)  (< (car e1) (car e2))))))
			)
		)
	
		(if (> (length LPtDim) 2) 
			(setq Loop T) 
			(setq Loop nil)
		)
		(setq Num 0)

		(while Loop
			(cond 
				((or (= Sector 1) (= Sector 2))
					(setq Chk (equal (cadr (nth Num LPtDim)) (cadr (nth (1+ Num) LPtDim)) Preci))
				)
				((or (= Sector 3) (= Sector 4))
					(setq Chk (equal (car (nth Num LPtDim)) (car (nth (1+ Num) LPtDim)) Preci))
				)
			)
			(if Chk 
				(progn
					(setq LPtDim (LM:RemoveNth (1+ Num) LPtDim))
					(setq Num 0)
				)
				(setq Num (1+ Num))
			)
			(if (or (= Num (- (length LPtDim) 1)) (= (length LPtDim) 2)) (setq Loop nil))
		)
		LPtDim
	)
	;
	; Main 
	;
	(if (and EnameShape LstSector Preci)
		(progn
			(setq Rtn (list nil nil nil nil))
			(foreach itm LstSector
				(setq LstPointSector (FilterPointShape EnameShape itm Preci))
				(cond 
					((= itm 1)
						(setq Rtn (LM:SubstNth LstPointSector 0 Rtn))
					)
					((= itm 2)
						(setq Rtn (LM:SubstNth LstPointSector 1 Rtn))
					)
					((= itm 3)
						(setq Rtn (LM:SubstNth LstPointSector 2 Rtn))
					)
					((= itm 4)
						(setq Rtn (LM:SubstNth LstPointSector 3 Rtn))
					)
				)
			)
		)
	)
	Rtn
)
;
(defun BatchDimensionShape (EnameShape Sector TypeDim GPosDim / *error* 
																Preci GPtDim itm LPtDim Box LPosDim LstDim Rtn)

	(defun *error* (msg)
		(RestoreUcs "SaveUcs")
		(DeleteUCS  "UcsWork")
	)
	;
	; Main
	;
	(setq Preci 0.25)
	(if (and EnameShape LstSector TypeDim GPosDim)
		(progn
			(SaveUcs "SaveUcs")
			(setq GPtDim   (nth (- Sector 1) (RegappDimPointShape EnameShape (list Sector) Preci)))
			(setq Box      (ucs-bbox EnameShape))
			(SetUcs2P      (trans (car Box) 1 0) (trans (list (+ (car (car Box)) 1.0) (cadr (car Box))) 1 0) "UcsWork")
			
			(setq LPosDim  (trans GPosDim 0 1))
			(foreach itm GPtDim
				(setq LPtDim (cons (trans itm 0 1) LPtDim))
			)
			
			(cond 
				((or (= Sector 1) (= Sector 2))
					(setq LPtDim (vl-sort LPtDim (function (lambda (e1 e2)  (< (cadr e1) (cadr e2))))))
				)
				((or (= Sector 3) (= Sector 4))
					(setq LPtDim (vl-sort LPtDim (function (lambda (e1 e2)  (< (car e1) (car e2))))))
				)
			)
				

			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			
			(cond														; 1°
				((= (substr TypeDim 2 1) "1") 							; continua
					(setq LstDim (QuotaContinua LPtDim Sector LPosDim))
					(setq Rtn (append Rtn (cadr LstDim)))
				)
				((= (substr TypeDim 2 1) "2") 							; ordinata
					(setq LstDim (QuotaOrdinate LPtDim Sector LPosDim))
					(setq Rtn (append Rtn (cadr LstDim)))
				)
			)
			
			(if LstDim
				(setq LPosDim (NextPosDim (car (cadr LstDim)) (car LstDim) Sector LPosDim))
			)
			
			(cond														; 2°
				((= (substr TypeDim 3 1) "1") 							; continua
					(setq LstDim (QuotaContinua LPtDim Sector LPosDim))
					(setq Rtn (append Rtn (cadr LstDim)))
				)
				((= (substr TypeDim 3 1) "2") 							; ordinata
					(setq LstDim (QuotaOrdinate LPtDim Sector LPosDim))
					(setq Rtn (append Rtn (cadr LstDim)))
				)
			)
			
			(if LstDim
				(setq LPosDim (NextPosDim (car (cadr LstDim)) (car LstDim) Sector LPosDim))
			)

			(cond														; 3° totale
				((= (substr TypeDim 4 1) "1")  							; continua
					(if (> (length LPtDim) 2)
						(progn
							(setq LstDim (QuotaContinua (list (car LPtDim) (car (reverse LPtDim))) Sector LPosDim))
							(setq Rtn (append Rtn (cadr LstDim)))
						)
					)
				)
				((= (substr TypeDim 4 1) "2") 							; ordinata
					(setq LstDim (QuotaOrdinate (list (car LPtDim) (car (reverse LPtDim))) Sector LPosDim))
					(setq Rtn (append Rtn (cadr LstDim)))
				)
			)
			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			
			(RestoreUcs "SaveUcs")
			(DeleteUCS  "UcsWork")
		)
	)
	Rtn
)
;
(defun ShapeDimension (EnameShape TypeDimInternal TypeDimExternal BitMx)
	
	(if (and EnameShape TypeDimInternal TypeDimExternal)
		(progn
			(if BitMx 
				(CompleteShapeDimensionMx EnameShape TypeDimInternal TypeDimExternal BitMx)
				(CompleteShapeDimensionXY EnameShape TypeDimInternal TypeDimExternal)
			)
		)
	)
)
;
(defun CompleteShapeDimensionXY (EnameShape TypeDimInternal TypeDimExternal / LstEnameInternal Ssel 
																			  LstDim)

	(if (and EnameShape TypeDimInternal TypeDimExternal)
		(progn
			(setq LstEnameInternal 		(GetEnameInternalShapeByDummyEnameSelect EnameShape))
			(setq Ssel     				(LstEname->Ssget (cons EnameShape LstEnameInternal)))
			(setq LstDim 				(DimensionXY Ssel TypeDimInternal nil nil))
			(setq LstDim 				(DimensionShape EnameShape TypeDimExternal LstDim nil))
		)
	)
)
;
(defun CompleteShapeDimensionMx (EnameShape TypeDimInternal TypeDimExternal BitMx / Preci SectorX SectorY RecordDim itm itm1 LstCircle LstPt 
																					SselM OffsetDim GPosXY LstPtDimMxX LstPtDimMxY LstDim)

	(setq Preci 0.1)
	(setq SectorX 3)
	(setq SectorY 2)
	
	(if (and EnameShape TypeDimInternal TypeDimExternal BitMx)
		(progn
			(foreach itm (GetEnameInternalShapeByDummyEnameSelect EnameShape)
				(if (= (vlax-get-property (vlax-ename->vla-object itm) 'ObjectName) "AcDbCircle")
					(progn
						(setq LstCircle (append LstCircle (list itm)))
						(setq LstPt     (append LstPt     (list (cdr (assoc 10 (entget itm))))))
					)
				)
			)
			(setq LstPt (LM:UniqueFuzz LstPt Preci)) 
			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++  00 10 11
			(if (= BitMx "00") (progn (setq SplitMx nil) (setq OptimizeMx nil)))
			(if (= BitMx "10") (progn (setq SplitMx T)   (setq OptimizeMx nil)))
			(if (= BitMx "11") (progn (setq SplitMx T)   (setq OptimizeMx T)))
			(setq RecordDim (GetMatrix LstPt SplitMx OptimizeMx Preci T))
			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			(foreach itm (car RecordDim)

				; ---> Ucs 	   (car  itm)
				; ---> LstPt   (cadr itm)
				
				(setq OffsetDim (* (* (getvar "DIMDLI") (getvar "DIMSCALE")) 3.0))
				(setq SselM   (AssocPointToEname (cadr itm) LstCircle Preci))
				(SaveUcs "GuiDimensionMatrix")
				
				(cond
					((MyUcsAlignToUcs (car itm))
						(if LstDim 				(setq OffsetDim (* (* (getvar "DIMDLI") (getvar "DIMSCALE")) 1.25)))
						(setq GPosXY 			(GetGlobalPosDim (GetPointDimension (ssadd EnameShape SselM)) OffsetDim LstDim))
						(setq TypeDimInternal 	(ReplaceNthChar 4 "0" TypeDimInternal))
					)
					(t
						(SetUcs2P 				(list 0.0 0.0 0.0) (nth 1 (car itm)) "GuiDimensionMatrixUcsWork")
						(setq GPosXY  			(GetGlobalPosDim (cadr itm) OffsetDim nil))
						(setq TypeDimInternal 	"1100")
						;
						(setq LstPtDimMxX 		(PointDimMxSector EnameShape itm 4))
						(setq LstPtDimMxY 		(PointDimMxSector EnameShape itm 1))
					)
				)
				
			
				(setq LstDim (append (BatchDimensionXY SselM SectorX SectorY TypeDimInternal (nth (- SectorX 1) GPosXY) (nth (- SectorY 1) GPosXY)) LstDim))
				
				(RestoreUcs "GuiDimensionMatrix")
				(DeleteUCS  "GuiDimensionMatrixUcsWork")
			)
			
			(setq LstDim (append (DimensionShape EnameShape TypeDimExternal LstDim nil) LstDim))
		)
	)
	LstDim
)
;
(defun AssocPointToEname (LstPt LstEname Preci / Rtn itm itm1)

	(setq Rtn (ssadd)) 
	(foreach itm LstEname
		(if (= (vlax-get-property (vlax-ename->vla-object itm) 'ObjectName) "AcDbCircle")
			(foreach itm1 LstPt
				(if (equal itm1 (vlax-safearray->list (vlax-variant-value (vla-get-center (vlax-ename->vla-object itm)))) Preci)
					(ssadd itm Rtn)
				)
			)
		)
	)
	Rtn
)
;
(defun test (/ LstPt Ssel Num Preci)

	(setq Preci 0.1)
	(setq Ssel (ssget))
	(if Ssel
		(progn
			(setq Num 0)
			(repeat (sslength Ssel)
				(setq LstPt (append LstPt (list (cdr (assoc 10 (entget (ssname Ssel Num)))))))
				(setq Num (1+ Num))
			)
		)
	)
	
	(PointDimMxXY (getent) (car (GetMatrix (LM:UniqueFuzz LstPt Preci) T T Preci T)))
	(princ)
)
;
(defun GetMatrix (LstPt SplitMx OptimizeMx Preci Verbose / Rtnx itm itm1 RecordMx)
		;
		; Find Matrix +++++++++++++++++++++++++++++++++++++++++++
		(setq Rtnx (FindMatrix LstPt Preci))
		(setq RecordMx Rtnx)
		(if Verbose
			(progn
				(foreach itm (car RecordMx)
					(princ "\n Ucs Mf --> ") (princ (car  itm))
					(princ "\n Pt  Mf --> ") (princ (cadr itm))
				)
				(foreach itm (cadr RecordMx)
					(princ "\n Pt nMf --> ") (princ itm)
				)
				(princ "\n")
			)
		)
		;
		; Split Matrix  ++++++++++++++++++++++++++++++++++++++++++
		(if (and SplitMx (not (null (car (car Rtnx)))))
			(progn
				(setq RecordMx nil)
				(foreach itm (car Rtnx)
					(foreach itm1 (SplitMatrix (car itm) (cadr itm) Preci)
							(setq RecordMx (append RecordMx (list (list (car itm) itm1))))
					)
				)
				(setq RecordMx (append (list RecordMx) (list (cadr Rtnx))))
				
				(if Verbose
					(progn
						(foreach itm (car RecordMx)
							(princ "\n Ucs Ms --> ") (princ (car  itm))
							(princ "\n Pt  Ms --> ") (princ (cadr itm))
						)
						(foreach itm (cadr RecordMx)
							(princ "\n Pt nMs --> ") (princ itm)
						)
						(princ "\n")
					)
				)
			)
		)
		;
		; Optimize Matrix ++++++++++++++++++++++++++++++++++++++++
		(if (and OptimizeMx (not (null (car (car Rtnx)))))
			(progn
				(setq RecordMx (OptimizeMatrix (car RecordMx) Preci))
				(setq RecordMx (append (list RecordMx) (list (cadr Rtnx))))
				
				(if Verbose
					(progn
						(foreach itm (car RecordMx)
							(princ "\n Ucs Mo --> ") (princ (car  itm))
							(princ "\n Pt  Mo --> ") (princ (cadr itm))
						)
						(foreach itm (cadr RecordMx)
							(princ "\n Pt nMo --> ") (princ itm)
						)
						(princ "\n")
					)
				)
			)
		)
		;
		RecordMx
)
;
(defun FindMatrix (LstPt Preci / FindGroup FindSet
						         Loop FSet Rtn1 Rtn2)
	;
	;
	;(defun FindGroup (LstPt Preci / Rtn LstSort Num LsX LsY LstOut)
	;	;
	;	;(setq Preci 0.1)
	;	(setq Rtn 0)
	;	(if LstPt
	;		(progn
	;			(setq Num 0)
	;			(setq LstSort (vl-sort LstPt (function (lambda (e1 e2)  (< (cadr e1) (cadr e2))))))
	;			(repeat (- (length LstSort) 1)
	;				(if (equal (cadr (nth Num LstSort)) (cadr (nth (1+ Num) LstSort)) Preci)
	;					(progn
	;						(setq Rtn (1+ Rtn))
	;						(setq LstOut (cons (nth Num LstSort)      LstOut))
	;						(setq LstOut (cons (nth (1+ Num) LstSort) LstOut))
	;					)
	;				)
	;				(setq Num (1+ Num))
	;			)
	;		)
	;	)
	;	(if (> Rtn 0) (list Rtn (LM:UniqueFuzz LstOut Preci)))
	;)
	(defun FindGroup (LstPt Preci / LstCombine Rtn itm LstOut)
		;
		(setq LstCombine (CombineList LstPt 2))
		(setq Rtn 0)
		(foreach itm LstCombine
			(if (or (equal (car  (car itm)) (car  (cadr itm)) Preci)
					(equal (cadr (car itm)) (cadr (cadr itm)) Preci)
				)
				(progn
					(setq Rtn (1+ Rtn))
					(setq LstOut (cons (car  itm) LstOut))
					(setq LstOut (cons (cadr itm) LstOut))
				)
			)	
		)
		(if (> Rtn 0) (list Rtn (LM:UniqueFuzz LstOut Preci)))
	)
	;
	(defun FindSet (LstPt Preci / MinMatrix MaxGrp itm Ucs UcsM LstL Rtn LstM)
	
		(setq MinMatrix 2)
		(if LstPt
			(cond
				((>= (length LstPt) 2)
					(setq MaxGrp 0)
					(foreach itm (CombineList LstPt 2)
					
						(setq Ucs      (DefPiano2P (car (car itm)) (cadr (car itm)) 0.0 (car (cadr itm)) (cadr (cadr itm)) 0.0))
						(setq LstL     (MTransLstPointTo LstPt 1 Ucs))
						(setq Rtn      (FindGroup LstL Preci))
						
						(cond 
							((and (equal (getvar "UCSXDIR") (nth 1 Ucs) 0.01)
								  (equal (getvar "UCSYDIR") (nth 2 Ucs) 0.01)
								  (= (car Rtn) MaxGrp))
								  
								(setq MaxGrp (car  Rtn))
								(setq LstM   (MTransLstPointTo (cadr Rtn) 0 Ucs))
								(setq LstM   (LM:UniqueFuzz LstM Preci))
								(setq UcsM   Ucs)
								;(princ (strcat "\n W--> " (rtos MaxGrp 2 0)))
								;(princ "\nUcs W       ---> ") (princ UcsM)
								;(princ "\nList Matrix W -> ") (princ LstM) (princ "\n")
							)
							((> (car Rtn) MaxGrp)
							 
								(setq MaxGrp (car  Rtn))
								(setq LstM   (MTransLstPointTo (cadr Rtn) 0 Ucs))
								(setq LstM   (LM:UniqueFuzz LstM Preci))
								(setq UcsM   Ucs)
								;(princ (strcat "\n ---> " (rtos MaxGrp 2 0)))
								;(princ "\nUcs         ---> ") (princ UcsM)
								;(princ "\nList Matrix ---> ") (princ LstM) (princ "\n")
							 
							)
						)
					)
					
					(if LstM
						(progn
							(foreach itm LstM
								(setq LstPt (LM:RemoveOnceF itm LstPt Preci))
							)
							(setq Rtn (list (list UcsM LstM) LstPt))
						)
					)
					
				)
				((= (length LstPt) 1)
					(setq Rtn (list nil LstPt))
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq Loop T)
	(while Loop
		(setq FSet (FindSet LstPt Preci))
		(cond
			((null (cadr Fset))
				(setq Loop nil)
				(setq Rtn1 (append Rtn1 (list (car Fset))))
			)
			((equal LstPt (cadr Fset))
				(setq Loop nil)
				(setq Rtn2 (cadr Fset))
			)
			(t
				(setq LstPt (cadr Fset))
				(setq Rtn1 (append Rtn1 (list (car Fset))))
			)
		)
	)
	
	(if (null (car Rtn1)) (setq Rtn1 nil))
	(if (null Rtn2)       (setq Rtn2 nil))
	
	(list Rtn1 Rtn2)
)
;
(defun SplitMatrix (Ucs LstPtMatrix Preci / FencePoint FindGroup
										    itm LstAssoc Rtn)
	
	;
	(defun FencePoint (PtCk LstPt Ucs Preci / LPtChk itm Litm Rtn)

		(if (and PtCk LstPt Ucs Preci)
			(progn
				(setq LPtChk (transl (car PtCk) (cadr PtCk) 0.0 Ucs))
				(foreach itm LstPt
					(setq Litm  (transl (car itm) (cadr itm) 0.0 Ucs))
					;(princ "\n controllo ") (princ LPtChk) (princ " ") (princ Litm)
					(if (or (equal (car  LPtChk) (car  Litm) Preci)
							(equal (cadr LPtChk) (cadr Litm) Preci)			
						)
						(progn
							(setq Rtn (cons itm Rtn))
							;(princ " ----> Ok")
						)
						;(princ " ----> No")
					)
				)
			)
		)
		Rtn
	)
	;
	(defun FindGroup (Lst / Mmember
							LstCombi Loop Num itm Rtn)
		
		(defun Mmember (Lst1 Lst2 / Loop Num Rtn)
			
			(setq Loop T)
			(setq Num 0)
			(while Loop
				(if (member (nth Num Lst1) Lst2)
					(progn
						(setq Loop nil)
						(setq Rtn (LM:UniqueFuzz (LM:ListUnion Lst1 Lst2) Preci))
					)
				)
				(setq Num (1+ Num))
				(if (= Num (length Lst1))
					(setq Loop nil)
				)
			)
			Rtn
		)
		;
		;
		;
		(if (setq LstCombi (CombineList Lst 2))
			(setq Loop T)
			(setq Loop nil)
		)
		(setq Num  0)
		(while Loop
			(if (setq itm (nth Num LstCombi))
				(progn
					(if (setq Rtn (Mmember (car itm) (cadr itm)))
						(progn
							(setq Lst      (LM:RemoveOnce (car  itm) Lst))
							(setq Lst      (LM:RemoveOnce (cadr itm) Lst))
							(setq Lst      (append Lst (list Rtn)))
							(if (setq LstCombi (CombineList Lst 2))
								(setq Num 0)
								(setq Loop nil)
							)
						)
						(setq Num (1+ Num))
					)
				)
				(setq Loop nil)
			)
		)
		Lst
	)
	;
 	(if (and Ucs LstPtMatrix)
		(progn
			(foreach itm LstPtMatrix
				;(princ "\n-->") (princ itm)
				(setq LstAssoc (cons (FencePoint itm LstPtMatrix Ucs Preci) LstAssoc))
				;(princ "\n++>") (princ LstAssoc)
			)
			;(princ "\n")
			(setq Rtn (FindGroup LstAssoc))
		)
	)
	Rtn
)
;
(defun OptimizeMatrix (LstMatrix Preci / LstCombi Loop Num itm En1 En2)

	(if (setq LstCombi (CombineList LstMatrix 2))
		(setq Loop T)
		(setq Loop nil)
	)
		
	(setq Num  0)
	(while Loop
		(if (setq itm (nth Num LstCombi))
			(progn
			
				(setq En1 (MakePolyline (PurgeCollinearPointPoligon (LM:ConvexHull (cadr (car  itm)))) T))
				(setq En2 (MakePolyline (PurgeCollinearPointPoligon (LM:ConvexHull (cadr (cadr itm)))) T))
				
				(if (and (ChkAlignUcs (car (car itm)) (car (cadr itm)))
					     (MainVla-IntersectWith En1 En2)
					)
					(progn
						(setq LstMatrix      (LM:RemoveOnce (car  itm) LstMatrix))
						(setq LstMatrix      (LM:RemoveOnce (cadr itm) LstMatrix))
						(setq LstMatrix      (append LstMatrix (list (list (car (car itm))
																		   (append (cadr (car  itm)) (cadr (cadr itm)))))))
						
						(if (setq LstCombi (CombineList LstMatrix 2))
							(setq Num 0)
							(setq Loop nil)
						)
					)
					(setq Num (1+ Num))
				)
				(if (entget En1) (entdel En1))
				(if (entget En2) (entdel En2))
			)
			(setq Loop nil)
		)
	)
	LstMatrix
)
;
(defun PointDimMxSector (EnameShape LstMatrix Sector / Preci Ucs GPointMatrix LstPt Rtn LPointMatrix MinX MaxX MinY MaxY Ename LstPt Rtn)

	(setq Preci 0.1)
	(setq Ucs          (car  LstMatrix))
	(setq GPointMatrix (cadr LstMatrix))
	
	(setq LstPt 	   (RegappDimPointShape EnameShape (list Sector) Preci))
	(setq Rtn	   	   (nth (- Sector 1) LstPt))
	
	(setq LPointMatrix (MTransLstPointTo GPointMatrix 1 Ucs))
	(setq MinX (apply 'min (mapcar 'car  LPointMatrix)))
	(setq MaxX (apply 'max (mapcar 'car  LPointMatrix)))
	(setq MinY (apply 'min (mapcar 'cadr LPointMatrix)))
	(setq MaxY (apply 'max (mapcar 'cadr LPointMatrix)))
	(setq Ename (MakePolyline (list (transg MinX MinY 0.0 Ucs)
									(transg MaxX MinY 0.0 Ucs)
									(transg MaxX MaxY 0.0 Ucs)
									(transg MinX MaxY 0.0 Ucs)) T))
									
	(setq LstPt (RegappDimPointShape Ename (list Sector) Preci))
	(if (entget Ename) (entdel Ename))
	(setq Rtn   (append Rtn (nth (- Sector 1) LstPt)))
)
;
