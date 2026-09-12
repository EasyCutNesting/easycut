(setq PtInsert '(12632.1 446.301 0.0))
(setq IdJob	"2022_10_30-14.39.48")
(setq LstDataOptimizedBar	'("Ld-Csp" ((2 (2355.0 1355.0 1205.0 1055.0) 10.0) 
										(4 (2255.0 1355.0 1255.0 1105.0) 10.0) 
										(3 (2205.0 1355.0 1305.0 1105.0) 10.0) 
										(1 (2205.0 2105.0 1655.0) 15.0) 
										(1 (2105.0 1705.0 1105.0 1055.0) 10.0) 
										(11 (2105.0 2005.0 1855.0) 15.0) 
										(2 (2105.0 1955.0 1905.0) 15.0) 
										(2 (2055.0 2055.0 1855.0) 15.0) 
										(2 (2055.0 1955.0 1955.0) 15.0) 
										(4 (1905.0 1705.0 1205.0 1155.0) 10.0) 
										(1 (1905.0 1655.0 1205.0 1205.0) 10.0) 
										(2 (1905.0 1905.0 1905.0) 265.0) 
										(1 (1905.0 1255.0 1255.0 1205.0) 360.0) 
										(1 (1905.0 1205.0) 2870.0)
										) 433)) 
(setq Id '((2355.0 "Mk01" 2) (2255.0 "Mk02" 4) (2205.0 "Mk03" 4) 
			(2105.0 "Mk04" 15) (2055.0 "Mk05" 6) (2005.0 "Mk06" 11) 
			(1955.0 "Mk07" 6) (1905.0 "Mk08" 15) (1855.0 "Mk09" 13) 
			(1705.0 "Mk10" 5) (1655.0 "Mk11" 2) (1355.0 "Mk12" 9) 
			(1305.0 "Mk13" 3) (1255.0 "Mk14" 6) (1205.0 "Mk15" 10) 
			(1155.0 "Mk16" 4) (1105.0 "Mk17" 8) (1055.0 "Mk18" 3))) 
(setq Ls 6000.0) 
(setq BarMargStart 10.0) 
(setq BarMargEnd 10.0) 
(setq ThiCut 5.0) 
(setq DimScale 26.6667)

;(TableNestingBar (getpoint) IdJob LstDataOptimizedBar Id Ls BarMargStart BarMargEnd ThiCut DimScale)

(defun TableNestingBar (PtInsert IdJob LstDataOptimizedBar Id Ls BarMargStart BarMargEnd ThiCut	DimScale / 
						GetNameByLength FilterBar
						HA4 MBorderV MBorderO InterRow InterRowPart InterPage Head HInfoBar LInfoBar HBar LBar HPart LPart StepX StepY DimStyleName
						TextStyleName HTextDim
						Idx Idy Bar InfoBar LstInfoPart Part Waste)

	(defun GetNameByLength (Lng AssocLengthName / PosLst LstChk Rtn1 Rtn2)

		(defun PosLst ( l e / n p r)
		 (setq n -1)
		 (while
		   (and
			 (setq p (vl-position e l))
			 (setq n (+ 1 n p)
				   r (cons n r)
				   l (cdr (member e l))
			 )
		   )
		 )
		 (reverse r)
		)
		;
		;
		;
		(if (and Lng AssocLengthName)
			(if (setq LstChk (assoc Lng AssocLengthName))
				(progn
					(setq Rtn1 (cadr LstChk))
					(if (= (- (caddr LstChk) 1) 0)
						(setq Rtn2 (LM:RemoveNth (car (PosLst AssocLengthName LstChk)) AssocLengthName))
						(setq Rtn2 (subst (list (car LstChk) (cadr LstChk) (- (caddr LstChk) 1)) LstChk AssocLengthName))
					)
					(list Rtn1 Rtn2)
				)
			)
		)
	)	
	;
	;
	;
	(defun FilterBar (LstLengthBar LstId / itm AssocPart TextPart LstId Rtn)
		(if (and LstLengthBar LstId)
			(progn
				(foreach itm LstLengthBar
					(setq AssocPart (GetNameByLength itm LstId))
					(setq TextPart 	(car  AssocPart))
					(setq LstId  	(cadr AssocPart))
					(if (not (assoc TextPart Rtn))
						(setq Rtn (append Rtn (list (list TextPart itm 1))))
						(setq Rtn (subst (list TextPart itm (1+ (caddr (assoc TextPart Rtn)))) (assoc TextPart Rtn) Rtn))
					)
				)
			)
		)
		(list Rtn LstId)
	)
	;
	; Main
	;
	(setq HA4 			(* 297.0 DimScale))
	(setq LA4 			(* 210.0 DimScale))
	(setq MBorderV 		(*   2.0 DimScale))
	(setq MBorderO 		(*   2.0 DimScale))
	(setq InterRow		(*   1.5 DimScale))
	(setq InterRowPart	(*   1.0 DimScale))
	(setq InterPage		(*  10.0 DimScale))
	(setq Head	 		(*  19.5 DimScale))
	(setq HInfoBar 		(*  12.0 DimScale))
	(setq LInfoBar 		(* 204.0 DimScale))
	(setq HBar	 		(*   6.0 DimScale))
	(setq LBar 		    (*  68.0 DimScale))
	(setq HPart 		(*   5.0 DimScale))
	(setq LPart 		(*  68.0 DimScale))
	(setq StepX	  		(*   0.0 DimScale))
	(setq StepY	  		(*   0.0 DimScale))

	(setq HTextDim  	3.0)
	(setq DimStyleName   "EasyCutDimOptimezeBars")
	(setq TextStyleName  "EasyCutStyleOptimezeBars")

	(if (not (tblsearch "DIMSTYLE" DimStyleName))
		(MakeDimStyleToEntmake DimStyleName DimScale HTextDim TextStyleName "0")
	)

	(setq Idx (nth 0 PtInsert))
	(setq Idy (nth 1 PtInsert))
	
	(setq PosX (+ Idx MBorderO StepX))
	(setq PosY (- IdY MBorderV Head StepY))
	(PrintHead PosX PosY IdJob DimScale)
	(PrintBom Idx Idy HA4 LA4)
	
	
	(foreach Bar (vl-sort (cadr LstDataOptimizedBar) (function (lambda (e1 e2)  (< (caddr e1) (caddr e2)))))

		; *******************************************
		(setq PosY (- PosY InterRow HInfoBar))
		(if (> (abs (- PosY IdY)) HA4)
			(progn
				(setq IdY (- IdY HA4 InterPage))
				(setq PosY  (- IdY StepY MBorderV HInfoBar)) 
				(PrintBom Idx Idy HA4 LA4)
			)
		)
		;
		; Bar -> (11 (2105.0 2005.0 1855.0) 15.0)
		;
		(setq Waste (- Ls (+ BarMargStart (apply '+ (cadr Bar)) (* (- (length (cadr Bar)) 1.0) ThiCut))))
		(setq InfoBar (list (car Bar) 
							Ls 
							BarMargStart 
							Waste 
							ThiCut 
							Waste
							(* (- 1.0 (/ Waste Ls)) 100.0)))		 
		(PrintInfoBar PosX PosY InfoBar HInfoBar LInfoBar DimScale)
		
		; *******************************************
		(setq PosY (- PosY InterRow HBar))
		(if (> (abs (- PosY IdY)) HA4)
			(progn
				(setq IdY (- IdY HA4 InterPage))
				(setq PosY  (- IdY StepY MBorderV HBar))
				(PrintBom Idx Idy HA4 LA4)				
			)
		)
		(PrintHeadBar PosX PosY HBar LBar DimScale)
		; *******************************************
		(setq LstInfoPart (FilterBar (cadr Bar) Id))
		(setq Id (cadr LstInfoPart))
		(foreach Part (car LstInfoPart)
			(setq PosY (- PosY InterRowPart HPart))
			(if (> (abs(- PosY IdY)) HA4)
				(progn
					(setq IdY (- IdY HA4 InterPage))
					(setq PosY (- IdY StepY MBorderV HPart))
					(PrintBom Idx Idy HA4 LA4)
				)
			)
			(PrintComposerBar PosX PosY Part HPart LPart DimScale)
		)
		; *******************************************
	)
)
;
;
;
(defun PrintHead (PosX PosY StrBarCode DimScale / ResizeBlock
												  XCodeBar YCodeBar XLogo YLogo MaxHBarCode MaxHLogo MaxWBarCode MaxWLogo
												  EnameBlockLogo EnameBlockBarcode PosLogo PosBarCode DimLogo DimBarCode HBarCode)

	

	(defun ResizeBlock (EnameBlock LMax WMax / ScaleX ScaleY BoxEname)
	
		(if (and EnameBlock LMax WMax)
			(progn
				(setq ScaleX 1.0)
				(setq ScaleY 1.0)

				(setq BoxEname	(BoundingBoxLstEname (list EnameBlock)))
				;(if (> (distance (car BoxEname) (cadr BoxEname)) LMax)
					(setq ScaleX (/ LMax (distance (car BoxEname) (cadr BoxEname))))
				;)
				;(if (> (distance (cadr BoxEname) (caddr BoxEname)) WMax)
					(setq ScaleY (/ WMax (distance (cadr BoxEname) (caddr BoxEname))))
				;)
				(min ScaleX ScaleY)
			)
		)
	)
	;
	; Main
	;
	(if (and PosX PosY StrBarCode DimScale)
		(progn
			(setq XCodeBar 		(*   5.0 DimScale))
			(setq YCodeBar 		(*  17.5 DimScale))
			(setq XLogo 		(* 140.0 DimScale))
			(setq YLogo 		(*  17.5 DimScale))
			(setq MaxHBarCode 	(*  15.0 DimScale))
			(setq MaxHLogo 	  	(*  15.0 DimScale))
			(setq MaxWBarCode 	(* 100.0 DimScale))
			(setq MaxWLogo 		(*  60.0 DimScale))
			(setq HBarCode		20.0)
			
			(setq EnameBlockLogo  (vlax-vla-object->ename (InsertBlock (strcat LibPathEasyCut$ FileBlockLogo$) (list 0.0 0.0) nil)))
			(vla-ScaleEntity (vlax-ename->vla-object EnameBlockLogo) (vlax-3d-point (list 0.0 0.0)) (ResizeBlock EnameBlockLogo MaxWLogo MaxHLogo))
			(setq PosLogo 		  (list (+ PosX XLogo) (+ PosY YLogo)))
			(setq DimLogo	  	  (BoundingBoxLstEname (list EnameBlockLogo)))
			(vla-move (vlax-ename->vla-object EnameBlockLogo)  (vlax-3d-point (nth 3 DimLogo)) (vlax-3d-point PosLogo))

			
			(BrCode128 StrBarCode 	(strcat "BARCODE128_" StrBarCode)  (list 0.0 0.0) HBarCode (* HBarCode 0.2))
			(setq EnameBlockBarcode	(entlast))
			(vla-ScaleEntity (vlax-ename->vla-object EnameBlockBarcode) (vlax-3d-point (list 0.0 0.0)) (ResizeBlock EnameBlockBarcode MaxWBarCode MaxHBarCode))
			(setq PosBarCode 	  	(list (+ PosX XCodeBar) (+ PosY YCodeBar)))
			(setq DimBarCode	  	(BoundingBoxLstEname (list EnameBlockBarcode)))
			(vla-move (vlax-ename->vla-object EnameBlockBarcode)  (vlax-3d-point (nth 3 DimBarCode)) (vlax-3d-point PosBarCode))
			(PurgeBlock 		  (strcat "BARCODE128_" StrBarCode))
		)
	)
)
;
;
;
(defun PrintComposerBar (PosX PosY InfoComposerBar HPart LPart DimScale / Tab1 Tab2 Tab3 Tab4 Tab5 XBorderMargin YBorderMargin 
																		  HTarget HValue ClrTarget ClrValue ClrBom Id Lg Qta) 
							


	(if (and PosX PosY InfoComposerBar HPart LPart DimScale)
		(progn
			(setq Tab1 			 (*  7.0 DimScale))
			(setq Tab2 			 (* 29.0 DimScale))
			(setq Tab3 			 (* 34.0 DimScale))
			(setq Tab4 			 (* 52.0 DimScale))
			(setq Tab5 			 (* 57.0 DimScale))
			(setq XBorderMargin  (*  2.0 DimScale))
			(setq YBorderMargin  (*  1.0 DimScale))
			(setq HTarget 		 (*  2.5 DimScale))
			(setq HValue  		 (*  3.0 DimScale))

			(setq ClrTarget 	 1  )	; Red
			(setq ClrValue  	 3  ) 	; Green
			(setq ClrBom 		 5  )   ; Blu
			; **************************************************
			(setq Id  (nth 0 InfoComposerBar))	; 	Id Part
			(setq Lg  (nth 1 InfoComposerBar))	;	Length Part
			(setq Qta (nth 2 InfoComposerBar))	;	quantity Part

			(XMakeText (list (+ PosX XBorderMargin) 		(+ PosY YBorderMargin)) "ID." 	HTarget 0.8 0.0 0 0 ClrTarget)
			(XMakeText (list (+ PosX XBorderMargin Tab2)	(+ PosY YBorderMargin)) "L."     HTarget 0.8 0.0 0 0 ClrTarget)
			(XMakeText (list (+ PosX XBorderMargin Tab4)	(+ PosY YBorderMargin)) "n."	HTarget 0.8 0.0 0 0 ClrTarget)

			(XMakeText (list (+ PosX XBorderMargin Tab1)	(+ PosY YBorderMargin)) Id				 HValue 0.8 0.0 0 0 ClrValue)
			(XMakeText (list (+ PosX XBorderMargin Tab3)	(+ PosY YBorderMargin)) (LM:rtos Lg  2 1) HValue 0.8 0.0 0 0 ClrValue)
			(XMakeText (list (+ PosX XBorderMargin Tab5)	(+ PosY YBorderMargin)) (LM:rtos Qta 2 0) HValue 0.8 0.0 0 0 ClrValue)
			
			(vla-put-Color (vlax-ename->vla-object (MakeRectangle (list PosX PosY) LPart HPart)) ClrBom)
		)
	)
)
;
;
;
(defun PrintHeadBar (PosX PosY HBar LBar DimScale / BorderMargin HTarget ClrTarget ClrBom)


	(if (and PosX PosY HBar LBar DimScale)
		(progn
			(setq BorderMargin 	(* 2.0 DimScale))
			(setq HTarget 		(* 2.5 DimScale))
			(setq ClrTarget 	2)	; Yellow
			(setq ClrBom 		5)  ; Blu
			
			(XMakeText (list (+ PosX BorderMargin) 	(+ PosY BorderMargin)) "COMPOSIZIONE BARRA SINGOLA" HTarget 0.8 0.0 0 0 ClrTarget)
			(vla-put-Color (vlax-ename->vla-object (MakeRectangle (list PosX PosY) LBar HBar)) ClrBom)
		)
	)
)
;
;
;
(defun PrintInfoBar (PosX PosY InfoBar HInfoBar LInfoBar DimScale / Tab1 Tab2 BorderMargin OffsetMargin YMidLine HTarget HValue InterLine ClrTarget ClrValue ClrBom 
																	Nbar Lbar Mgini Mgfin TkCut Waste Eff)

	(if (and PosX PosY InfoBar HInfoBar LInfoBar DimScale)
		(progn
			(setq Tab1 			(* 40.0 DimScale))
			(setq Tab2 			(* 21.0 DimScale))
			(setq BorderMargin 	(*  2.0 DimScale))
			(setq OffsetMargin 	(*  1.0 DimScale))
			(setq YMidLine 		(*  6.0 DimScale))
			(setq HTarget 		(*  2.5 DimScale))
			(setq HValue  		(*  3.0 DimScale))
			(setq InterLine  	(*  5.5 DimScale))
			(setq ClrTarget 	1)	; Red
			(setq ClrValue  	3)  ; Green
			(setq ClrBom 		5)  ; Blu
			; ****************************************************
			(setq Nbar 	(nth 0 InfoBar))	; 	Numero barre
			(setq Lbar 	(nth 1 InfoBar))	;	Lunghezza barra
			(setq Mgini (nth 2 InfoBar))	;	Margine iniziale
			(setq Mgfin (nth 3 InfoBar))	;	Margine finale
			(setq TkCut (nth 4 InfoBar))	;	Spessore di taglio
			(setq Waste (nth 5 InfoBar))	;	Sfrido
			(setq Eff 	(nth 6 InfoBar))	;	Efficienza
							
			(XMakeText (list (+ PosX BorderMargin) 				(+ PosY BorderMargin)) 				"SFRIDO" 		HTarget 0.8 0.0 0 0 ClrTarget)
			(XMakeText (list (+ PosX BorderMargin Tab1) 		(+ PosY BorderMargin)) 				"EFFICIENZA"    HTarget 0.8 0.0 0 0 ClrTarget)
			(XMakeText (list (+ PosX BorderMargin) 				(+ PosY BorderMargin InterLine)) 	"QTA. BARRE"    HTarget 0.8 0.0 0 0 ClrTarget)
			(XMakeText (list (+ PosX BorderMargin Tab1) 		(+ PosY BorderMargin InterLine)) 	"LUNGHEZZA"     HTarget 0.8 0.0 0 0 ClrTarget)
			(XMakeText (list (+ PosX BorderMargin (* Tab1 2.0))	(+ PosY BorderMargin InterLine))	"MARGINE INI."  HTarget 0.8 0.0 0 0 ClrTarget)
			(XMakeText (list (+ PosX BorderMargin (* Tab1 3.0))	(+ PosY BorderMargin InterLine)) 	"MARGINE FIN."  HTarget 0.8 0.0 0 0 ClrTarget)
			(XMakeText (list (+ PosX BorderMargin (* Tab1 4.0))	(+ PosY BorderMargin InterLine)) 	"SPES. TAGLIO"  HTarget 0.8 0.0 0 0 ClrTarget)
			
			(XMakeText (list (+ PosX BorderMargin Tab2) 					(+ PosY BorderMargin)) 			  (LM:rtos Waste 2 0)  HValue 0.8 0.0 0 0 ClrValue)
			(XMakeText (list (+ PosX BorderMargin (+ Tab1 Tab2))			(+ PosY BorderMargin))      	  (LM:rtos Eff   2 1)  HValue 0.8 0.0 0 0 ClrValue)
			(XMakeText (list (+ PosX BorderMargin Tab2) 					(+ PosY BorderMargin InterLine))  (LM:rtos Nbar  2 0)  HValue 0.8 0.0 0 0 ClrValue)
			(XMakeText (list (+ PosX BorderMargin (+ Tab1 Tab2))			(+ PosY BorderMargin InterLine))  (LM:rtos LBar  2 1)  HValue 0.8 0.0 0 0 ClrValue)
			(XMakeText (list (+ PosX BorderMargin (+ (* Tab1 2.0) Tab2))	(+ PosY BorderMargin InterLine))  (LM:rtos Mgini 2 1)  HValue 0.8 0.0 0 0 ClrValue)
			(XMakeText (list (+ PosX BorderMargin (+ (* Tab1 3.0) Tab2))	(+ PosY BorderMargin InterLine))  (LM:rtos Mgfin 2 1)  HValue 0.8 0.0 0 0 ClrValue)
			(XMakeText (list (+ PosX BorderMargin (+ (* Tab1 4.0) Tab2))	(+ PosY BorderMargin InterLine))  (LM:rtos TkCut 2 1)  HValue 0.8 0.0 0 0 ClrValue)
			
			(vla-put-Color (vlax-ename->vla-object (MakeRectangle (list PosX PosY) LInfoBar HInfoBar)) ClrBom)
			
		)
	)
)
;
;
;
(defun PrintBom (PosX PosY H W / ClrBom)
	(setq ClrBom 5)
	(if (and PosX PosY H W)
		(vla-put-Color (vlax-ename->vla-object (MakeRectangle (list PosX (- PosY H)) W H)) ClrBom)
	)
)