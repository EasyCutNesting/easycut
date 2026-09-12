;(setq PtInsert '(12632.1 446.301 0.0))
;(setq IdJob	"2022_10_30-14.39.48")
;(setq LstDataOptimizedBar	'("Ld-Csp" ((2 (2355.0 1355.0 1205.0 1055.0) 10.0) 
;										(4 (2255.0 1355.0 1255.0 1105.0) 10.0) 
;										(3 (2205.0 1355.0 1305.0 1105.0) 10.0) 
;										(1 (2205.0 2105.0 1655.0) 15.0) 
;										(1 (2105.0 1705.0 1105.0 1055.0) 10.0) 
;										(11 (2105.0 2005.0 1855.0) 15.0) 
;										(2 (2105.0 1955.0 1905.0) 15.0) 
;										(2 (2055.0 2055.0 1855.0) 15.0) 
;										(2 (2055.0 1955.0 1955.0) 15.0) 
;										(4 (1905.0 1705.0 1205.0 1155.0) 10.0) 
;										(1 (1905.0 1655.0 1205.0 1205.0) 10.0) 
;										(2 (1905.0 1905.0 1905.0) 265.0) 
;										(1 (1905.0 1255.0 1255.0 1205.0) 360.0) 
;										(1 (1905.0 1205.0) 2870.0)
;										) 433)) 
;(setq Id '((2355.0 "Mk01" 2) (2255.0 "Mk02" 4) (2205.0 "Mk03" 4) 
;			(2105.0 "Mk04" 15) (2055.0 "Mk05" 6) (2005.0 "Mk06" 11) 
;			(1955.0 "Mk07" 6) (1905.0 "Mk08" 15) (1855.0 "Mk09" 13) 
;			(1705.0 "Mk10" 5) (1655.0 "Mk11" 2) (1355.0 "Mk12" 9) 
;			(1305.0 "Mk13" 3) (1255.0 "Mk14" 6) (1205.0 "Mk15" 10) 
;			(1155.0 "Mk16" 4) (1105.0 "Mk17" 8) (1055.0 "Mk18" 3))) 
;(setq Ls 6000.0) 
;(setq BarMargStart 10.0) 
;(setq BarMargEnd 10.0) 
;(setq ThiCut 5.0) 
;(setq DimScale 26.6667)

;(TableNestingBar (getpoint) IdJob LstDataOptimizedBar Id Ls BarMargStart BarMargEnd ThiCut DimScale)

(defun TableNestingBar (PtInsert IdJob LstDataOptimizedBar Id Ls ProfileBar BarMargStart ThiCut DimScale / 
						GetNameByLength FilterBar MakeHead MakeComposerBar MakeHeadBar MakeInfoBar MakeBom
						HA4 MBorderV MBorderO InterRow InterRowPart InterPage Head HInfoBar LInfoBar HBar LBar HPart LPart StepX StepY
						BarCode TextStyleName HTextDim PosX PosY Page HTextPage
						Idx Idy Bar InfoBar LstInfoPart Part TotalThiCut BarMargEnd Waste)

	(defun GetNameByLength (Lng AssocLengthName / PosLst LstChk SplitName Rtn1 Rtn2)

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
					;(setq Rtn1 (cadr LstChk))
					(setq SplitName (splitxt (cadr LstChk) " "))
					(cond
						;
						;$RappPart     0          1                2                   3               		4    		5   
						; 			"Marca" "Fase  Marca" "Commessa  Marca" "Commessa  Fase  Marca" "Marca Profilo" "Nessuna"
						;
						;"Order" "Phase" "Mark" "Profile"
						;   0       1      2        3 
						;
						((= $RappPart "0")
							(setq Rtn1 (nth 2 SplitName))
						)
						((= $RappPart "1")
							(setq Rtn1 (strcat (nth 1 SplitName) " " (nth 2 SplitName)))
						)
						((= $RappPart "2")
							(setq Rtn1 (strcat (nth 0 SplitName) " " (nth 2 SplitName)))
						)
						((= $RappPart "3")
							(setq Rtn1 (strcat (nth 0 SplitName) " " (nth 1 SplitName) " " (nth 2 SplitName)))
						)
						((= $RappPart "4")
							(setq Rtn1 (strcat (nth 2 SplitName) " " (nth 3 SplitName)))
						)
						((= $RappPart "5")
							(setq Rtn1 "-")
						)
					)
					
					
					
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
	;
	(defun MakeHead (PosX PosY StrBarCode DimScale / ResizeBlock
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
	(defun MakeComposerBar (PosX PosY InfoComposerBar HPart LPart DimScale / Tab1 Tab2 Tab3 Tab4 Tab5 XBorderMargin YBorderMargin 
																			 HTarget HValue ClrTarget ClrValue ClrBom Id Lg Qta Tk) 
								


		(if (and PosX PosY InfoComposerBar HPart LPart DimScale)
			(progn
				(setq Tab1 			 (*  7.0 DimScale))
				(setq Tab2 			 (* 91.0 DimScale))
				(setq Tab3 			 (* 96.0 DimScale))
				(setq Tab4 			 (* 115.0 DimScale))
				(setq Tab5 			 (* 120.0 DimScale))
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
				(setq Tk  (nth 3 InfoComposerBar))	;	thikness Part

				(XMakeText (list (+ PosX XBorderMargin) 		(+ PosY YBorderMargin)) "ID." 	HTarget 0.8 0.0 0 0 ClrTarget)
				(XMakeText (list (+ PosX XBorderMargin Tab2)	(+ PosY YBorderMargin)) "L."    HTarget 0.8 0.0 0 0 ClrTarget)
				(XMakeText (list (+ PosX XBorderMargin Tab4)	(+ PosY YBorderMargin)) "n."	HTarget 0.8 0.0 0 0 ClrTarget)

				(XMakeText (list (+ PosX XBorderMargin Tab1)	(+ PosY YBorderMargin)) Id				 		 HValue 0.8 0.0 0 0 ClrValue)
				(XMakeText (list (+ PosX XBorderMargin Tab3)	(+ PosY YBorderMargin)) (LM:rtos (- Lg Tk) 2 1)  HValue 0.8 0.0 0 0 ClrValue)
				(XMakeText (list (+ PosX XBorderMargin Tab5)	(+ PosY YBorderMargin)) (LM:rtos Qta 2 0) 		 HValue 0.8 0.0 0 0 ClrValue)
				
				(vla-put-Color (vlax-ename->vla-object (MakeRectangle (list PosX PosY) LPart HPart)) ClrBom)
			)
		)
	)
	;
	;
	(defun MakeHeadBar (PosX PosY HBar LBar CodeBar DimScale / BorderMargin HTarget ClrTarget ClrBom
															   EnameBlockBarcode Box PosBarCode DimBarCode) 	

		(if (and PosX PosY HBar LBar CodeBar DimScale)
			(progn
				(setq BorderMargin 	(* 2.0 DimScale))
				(setq HTarget 		(* 2.5 DimScale))
				(setq ClrTarget 	2)	; Yellow
				(setq ClrBom 		5)  ; Blu
				
				(XMakeText (list (+ PosX BorderMargin) 	(+ PosY BorderMargin)) 
							(strcat "COMPOSIZIONE BARRA SINGOLA " CodeBar) HTarget 0.8 0.0 0 0 ClrTarget)
				(vla-put-Color (vlax-ename->vla-object (MakeRectangle (list PosX PosY) LBar HBar)) ClrBom)
				
			)
		)
	)
	;
	;
	(defun MakeInfoBar (PosX PosY InfoBar HInfoBar LInfoBar  DimScale / ResizeBlock PrincToString
																		Tab1 Tab2 BorderMargin OffsetMargin YMidLine HTarget HValue InterLine ClrTarget ClrValue ClrBom 
																		Nbar Lbar Profile Mgini Mgfin TkCut Waste Eff CodeBar
																		HBarCode MaxHBarCode MaxWBarCode XCodeBar YCodeBar
																		EnameBlockBarcode PosBarCode DimBarCode)

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
		(defun PrincToString (Val / Rtn)
		
			(if Val
				(cond
					((= (type Val) 'STR)
						(setq Rtn Val)
					)
					((= (type Val) 'INT)
						(setq Rtn (vl-princ-to-string Val))
					)
					((= (type Val) 'REAL)
						(if (= (- Val (fix Val)) 0)
							(setq Rtn (LM:rtos Val 2 0))
							(setq Rtn (vl-princ-to-string Val))
						)
					)
				)
			)
		)

		;
		; Main
		;
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
				(setq HBarCode	 12.0)
				(setq MaxHBarCode 	(*  12.0 DimScale))
				(setq MaxWBarCode 	(*  60.0 DimScale))
				(setq XCodeBar 		(*  70.0 DimScale))
				;(setq YCodeBar 		(*   4.0 DimScale))

				; ****************************************************
				(setq Nbar 	  (nth 0 InfoBar))	; 	Numero barre
				(setq Lbar 	  (nth 1 InfoBar))	;	Lunghezza barra
				(setq Profile (PrincToString (nth 2 InfoBar)))	;	Profilo barra
				(setq Mgini   (nth 3 InfoBar))	;	Margine iniziale
				(setq Mgfin   (nth 4 InfoBar))	;	Margine finale
				(setq TkCut   (nth 5 InfoBar))	;	Spessore di taglio
				(setq Waste   (nth 6 InfoBar))	;	Sfrido
				(setq Eff 	  (nth 7 InfoBar))	;	Efficienza
				(setq CodeBar (nth 8 InfoBar))	;	Codice barra
				
								
				(XMakeText (list (+ PosX BorderMargin) 				(+ PosY BorderMargin)) 				"SFRIDO" 		HTarget 0.8 0.0 0 0 ClrTarget)
				(XMakeText (list (+ PosX BorderMargin Tab1) 		(+ PosY BorderMargin)) 				"EFFICIENZA"    HTarget 0.8 0.0 0 0 ClrTarget)
				(XMakeText (list (+ PosX BorderMargin (* Tab1 2.0))	(+ PosY BorderMargin))				"PROFiLO"  		HTarget 0.8 0.0 0 0 ClrTarget)
				(XMakeText (list (+ PosX BorderMargin) 				(+ PosY BorderMargin InterLine)) 	"QTA. BARRE"    HTarget 0.8 0.0 0 0 ClrTarget)
				(XMakeText (list (+ PosX BorderMargin Tab1) 		(+ PosY BorderMargin InterLine)) 	"LUNGHEZZA"     HTarget 0.8 0.0 0 0 ClrTarget)
				(XMakeText (list (+ PosX BorderMargin (* Tab1 2.0))	(+ PosY BorderMargin InterLine))	"MARGINE INI."  HTarget 0.8 0.0 0 0 ClrTarget)
				(XMakeText (list (+ PosX BorderMargin (* Tab1 3.0))	(+ PosY BorderMargin InterLine)) 	"MARGINE FIN."  HTarget 0.8 0.0 0 0 ClrTarget)
				(XMakeText (list (+ PosX BorderMargin (* Tab1 4.0))	(+ PosY BorderMargin InterLine)) 	"SPES. TAGLIO"  HTarget 0.8 0.0 0 0 ClrTarget)
				
				(XMakeText (list (+ PosX BorderMargin Tab2) 					(+ PosY BorderMargin)) 			  (LM:rtos Waste 2 1)  HValue 0.8 0.0 0 0 ClrValue)
				(XMakeText (list (+ PosX BorderMargin (+ Tab1 Tab2))			(+ PosY BorderMargin))      	  (strcat (LM:rtos Eff   2 2) "%")  HValue 0.8 0.0 0 0 ClrValue)
				(XMakeText (list (+ PosX BorderMargin (+ (* Tab1 2.0) Tab2))	(+ PosY BorderMargin))  		   Profile  HValue 0.8 0.0 0 0 ClrValue)
				(XMakeText (list (+ PosX BorderMargin Tab2) 					(+ PosY BorderMargin InterLine))  (LM:rtos Nbar  2 0)  HValue 0.8 0.0 0 0 ClrValue)
				(XMakeText (list (+ PosX BorderMargin (+ Tab1 Tab2))			(+ PosY BorderMargin InterLine))  (LM:rtos LBar  2 1)  HValue 0.8 0.0 0 0 ClrValue)
				(XMakeText (list (+ PosX BorderMargin (+ (* Tab1 2.0) Tab2))	(+ PosY BorderMargin InterLine))  (LM:rtos Mgini 2 1)  HValue 0.8 0.0 0 0 ClrValue)
				(XMakeText (list (+ PosX BorderMargin (+ (* Tab1 3.0) Tab2))	(+ PosY BorderMargin InterLine))  (LM:rtos Mgfin 2 1)  HValue 0.8 0.0 0 0 ClrValue)
				(XMakeText (list (+ PosX BorderMargin (+ (* Tab1 4.0) Tab2))	(+ PosY BorderMargin InterLine))  (LM:rtos TkCut 2 1)  HValue 0.8 0.0 0 0 ClrValue)
				
				(BrCode128 CodeBar 		(strcat "BARCODE128_" CodeBar)  (list 0.0 0.0) HBarCode (* HBarCode 0.2))
				(setq EnameBlockBarcode	(entlast))
				(vla-ScaleEntity 	    (vlax-ename->vla-object EnameBlockBarcode) (vlax-3d-point (list 0.0 0.0)) (ResizeBlock EnameBlockBarcode MaxWBarCode MaxHBarCode))
				(setq PosBarCode 	  	(list (+ PosX BorderMargin XCodeBar) (+ PosY BorderMargin InterLine InterLine)))
				(setq DimBarCode	  	(BoundingBoxLstEname (list EnameBlockBarcode)))
				(vla-move 				(vlax-ename->vla-object EnameBlockBarcode)  (vlax-3d-point (nth 0 DimBarCode)) (vlax-3d-point PosBarCode))
				(PurgeBlock 		   	(strcat "BARCODE128_" CodeBar))
				(vla-put-Color (vlax-ename->vla-object (MakeRectangle (list PosX PosY) LInfoBar HInfoBar)) ClrBom)
			)
		)
	)
	;
	;
	(defun MakeBom (PosX PosY H W TextPage HTextPage / ClrBom Point)
		(setq ClrBom 5)
		(if (and PosX PosY H W Page HTextPage)
			(progn
				(vla-put-Color (vlax-ename->vla-object (MakeRectangle (list PosX (- PosY H)) W H)) ClrBom)
				(setq Point (list (- (+ PosX W) (* HTextPage 2.0)) (+ (- PosY H) (* HTextPage 0.5))))
				(entmakex (list (cons 000 "TEXT")
								(cons 100 "AcDbEntity")
								(cons 100 "AcDbText")
								(cons 010 Point)	
								(cons 040 HTextPage)
								(cons 001 TextPage)  
								(cons 050 0)  
								(cons 041 1)  
								(cons 051 0.0)  
								(cons 007 $StyleEasyCut)
								(cons 071 0)  
								;(cons 072 Position1) ; 
								(cons 011 (list (+ (nth 0 Point) 1) (nth 1 Point)))	
								;(cons 073 Position2)
						  )
				)
				
			)
		)
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
	(setq HInfoBar 		(*  26.0 DimScale))
	(setq LInfoBar 		(* 204.0 DimScale))
	(setq HBar	 		(*   6.0 DimScale))
	(setq LBar 		    (*  70.0 DimScale))
	(setq HPart 		(*   5.0 DimScale))
	(setq LPart 		(* 130.0 DimScale))
	(setq StepX	  		(*   0.0 DimScale))
	(setq StepY	  		(*   0.0 DimScale))
	(setq Page			1)
	(setq HTextPage		(* 2.7 DimScale))

	(setq HTextDim  	3.0)
	(setq TextStyleName  "EasyCutStyleOptimezeBars")

	(setq Idx (nth 0 PtInsert))
	(setq Idy (nth 1 PtInsert))
	
	(setq PosX (+ Idx MBorderO StepX))
	(setq PosY (- IdY MBorderV Head StepY))
	(MakeHead PosX PosY IdJob DimScale)
	(MakeBom Idx Idy HA4 LA4 (LM:rtos Page 2 0) HTextPage)
	
	(setq NumBar 1)
	(foreach Bar (vl-sort (cadr LstDataOptimizedBar) (function (lambda (e1 e2)  (< (caddr e1) (caddr e2)))))

		(setq BarCode (strcat (LM:rtos Ls 2 0) "_" (LM:rtos NumBar 2 0)))
		(setq NumBar (1+ NumBar))
		
		; *******************************************
		(setq PosY (- PosY InterRow HInfoBar))
		(if (> (abs (- PosY IdY)) HA4)
			(progn
				(setq IdY (- IdY HA4 InterPage))
				(setq PosY  (- IdY StepY MBorderV HInfoBar)) 
				(setq Page (1+ Page))
				(MakeBom Idx Idy HA4 LA4 (LM:rtos Page 2 0) HTextPage)
			)
		)
		;
		; Bar -> (11 (2105.0 2005.0 1855.0) 15.0)
		;
		(setq TotalThiCut 0.0) (repeat (- (length (cadr Bar)) 1) (setq TotalThiCut (+ TotalThiCut ThiCut)))
		(setq BarMargEnd (- Ls (- (+ BarMargStart (apply '+ (cadr Bar))) ThiCut)))
		(setq Waste 	  (+ BarMargStart BarMargEnd TotalThiCut))
		(setq InfoBar (list (car Bar) 
							Ls
							ProfileBar
							BarMargStart 
							BarMargEnd 
							ThiCut 
							Waste
							(* (- 1.0 (/ Waste Ls)) 100.0)
							BarCode))
		
		(MakeInfoBar PosX PosY InfoBar HInfoBar LInfoBar DimScale)
		
		; *******************************************
		
		(setq PosY (- PosY InterRow HBar))
		(if (> (abs (- PosY IdY)) HA4)
			(progn
				(setq IdY (- IdY HA4 InterPage))
				(setq PosY  (- IdY StepY MBorderV HBar))
				(setq Page (1+ Page))
				(MakeBom Idx Idy HA4 LA4 (LM:rtos Page 2 0) HTextPage)				
			)
		)
		(MakeHeadBar PosX PosY HBar LBar BarCode DimScale)
		
		; *******************************************
		(setq LstInfoPart (FilterBar (cadr Bar) Id))
		(setq Id (cadr LstInfoPart))
		(foreach Part (car LstInfoPart)
			(setq PosY (- PosY InterRowPart HPart))
			(if (> (abs(- PosY IdY)) HA4)
				(progn
					(setq IdY (- IdY HA4 InterPage))
					(setq PosY (- IdY StepY MBorderV HPart))
					(setq Page (1+ Page))
					(MakeBom Idx Idy HA4 LA4 (LM:rtos Page 2 0) HTextPage)
				)
			)
			(MakeComposerBar PosX PosY (append Part (list ThiCut)) HPart LPart DimScale)
		)
		; *******************************************
	)
)
;
;
;
