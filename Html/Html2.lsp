;
;
(defun EnameShapeToGraphicCanvas (EnameShape FileShape / LgCut WidthPix HeightPix Stream)


	(if EnameShape
		(progn
			
			(setq WidthPix   700)
			(setq HeightPix  500)
			;(setq DataShape (GetDataShape EnameShape))
			;--------------------------------------------------------------						
			; 	0	TypShape	1	IdShape		2	JouShape 
			;	3	NameShape	4	CutComp 	5	LenghtCut 
			;	6	Timing 		7	ComShape	8	PhaseShape 
			;	9	MatShape 	10	TkShape		11	DateShape
			;--------------------------------------------------------------	

			
			(setq Stream (open FileShape "w"))
			(if Stream
				(progn
					;
					;	Info Shape ---------------------------------------------------------------
					;	<!-- Questo è un commento valido -->
					;	
					(setq LgCut (GetLengthShape EnameShape))
					(setq LgCut (LM:rtos (+ (nth 1 LgCut) (nth 2 LgCut) (nth 3 LgCut)) 2 2))
					(princ (strcat "<!-- Shape " 	(GetTypShape 	EnameShape) "|"   	;0
													(GetIdShape 	EnameShape) "|"     ;1
													(GetJouShape 	EnameShape) "|"    	;2
													(GetNameShape 	EnameShape) "|"   	;3
													(GetCutShape 	EnameShape) "|"    	;4
													;(GetLengthShape EnameShape)"|"   	;5
													LgCut						"|"		;5
													(GetComShape 	EnameShape) "|"    	;7
													(GetPhaseShape 	EnameShape) "|"   	;8
													(GetMatShape 	EnameShape) "|"   	;9
													(GetTkShape 	EnameShape) "|"  	;10
													(GetDateShape 	EnameShape) " -->\n") Stream)    ;11
					
					(princ "<!doctype html>\n" 																						Stream)
					(princ "<html>\n" 																								Stream)
					(princ "<head>\n" 																								Stream)
					(princ "<meta charset=\"utf-8\">\n" 																			Stream)
					(princ "<title> Info shape </title>\n" 																			Stream)
					(princ (strcat "<script type=\"text/javascript\" src=\"" TmpScrHtmlEasyCut$ "zoom.js\"></script>\n")			Stream)
					(princ "<style>\n" 																								Stream)
					(princ ".wrapper	{width:900px;margin-left:auto;font-family:Arial;float:left;}\n" 							Stream)
					(princ ".print 		{margin-top:5px}\n" 																		Stream)
					(princ ".layout    	{width:670px;margin-left:160px;margin-top:5px;font-size:15px;float:left;}\n" 				Stream)
					(princ ".closed    	{margin-left:830px;width:30px;margin-top:5px;font-size:15px;}\n" 							Stream)
					(princ ".button 	{background-color:red;}\n" 																	Stream)
								
					(princ ".infoshape 	{margin-top:10px;float:left;margin-left:25px;}\n" 											Stream)
					(princ ".flagview  	{border:red 1px solid;padding:5px;width:150px;margin-top:10px;float:left;}\n" 				Stream)
					(princ "canvas     	{margin-left:5px;margin-top:10px;border:red 1px solid;padding:10px;box-shadow: 10px 10px 5px #aaaaaa;float:left;}\n" Stream)
					
					(princ "</style>\n" 																							Stream)
					(princ "<script>\n" 																							Stream)
					(princ "var WndInfo;\n" 																						Stream)
					(princ "var WndShape;\n" 																						Stream)
					(princ "var WndBolts;\n" 																						Stream)
					(princ "var FlagShape;\n" 																						Stream)
					(princ "var FlagBolts;\n" 																						Stream)
					
					(PrintInfoShapeTableFunction 				EnameShape Stream)
					(PrintCoordinateExternalShapeTableFunction 	EnameShape Stream)
					(PrintCoordinateInternalShapeTableFunction  EnameShape Stream)
					(PrintCoordinateBoltsShapeTableFunction 	EnameShape Stream)
					(PrintCloseWindowShapeFunction 				Stream)
					(PrintDrawShapeFunction 					EnameShape Stream)
					
					(princ "</script>\n" 																									Stream)
					(princ "</head>\n" 																										Stream)
					(princ "	<body>\n" 																									Stream)
					(princ "		<div class=\"wrapper\" align=\"center\">\n" 															Stream)
					(princ "			<div class=\"layout\"  align=\"left\">\n"															Stream)
					(princ (strcat "				<b>Order&nbsp;" 				(GetComShape 	EnameShape) 
													"&nbsp;&nbsp;Phase&nbsp;" 		(GetPhaseShape 	EnameShape) 
													"&nbsp;&nbsp;Mk&nbsp;" 			(GetNameShape 	EnameShape) "</b>\n")					Stream)
					(princ "			</div>\n" 																							Stream)
					(princ "			<div class=\"closed\"  align=\"right\">\n"															Stream)
					(princ "				<button class=\"button\" onclick=\"CloseWindow()\">X</button>\n"								Stream)
					(princ "			</div>\n"																							Stream)
					(princ "			<div class=\"flagview\">\n"																			Stream)
					(princ "				<form align=\"left\">\n"																		Stream)
					(princ "					<input  type=\"checkbox\" onclick=\"if(this.checked){FlagShape=1;draw()} else {FlagShape=0;draw()}\">\n" Stream)
					(princ "					Indice controrno\n"																			Stream)
					(princ "				</form>\n"																						Stream)
					(princ "				<form align=\"left\">\n"																		Stream)
					(princ "					<input type=\"checkbox\" onclick=\"if(this.checked){FlagBolts=1;draw()} else {FlagBolts=0;draw()}\">\n"	Stream)
					(princ "					Indice bulloni\n"																			Stream)
					(princ "				</form>\n"																						Stream)
					(princ "				<div class=\"print\" align=\"right\">\n"														Stream)
					(princ "					<button onclick=\"InfoShapeTable()\" style=\"width:100px\">Info</button>\n"					Stream)
					(princ "				</div>\n"																						Stream)
					(princ "				<div class=\"print\" align=\"right\">\n"														Stream)
					(princ "					<button onclick=\"CoordinateExternalShapeTable()\" style=\"width:100px\">Out Shape</button>\n"	Stream)
					(princ "				</div>\n"																						Stream)
					(princ "				<div class=\"print\" align=\"right\">\n"														Stream)
					(princ "					<button onclick=\"CoordinateInternalShapeTable()\" style=\"width:100px\">In Shape</button>\n"	Stream)
					(princ "				</div>\n"																						Stream)
					(princ "				<div class=\"print\" align=\"right\">\n"														Stream)
					(princ "					<button onclick=\"CoordinateBoltsTable()\" style=\"width:100px\">Bolts</button>\n"			Stream)
					(princ "				</div>\n"																						Stream)
					(princ "			</div>\n"																							Stream)
					(princ (strcat "			<canvas id=\"canvas\" width=\""(rtos WidthPix  2 0) "\" height=\""(rtos HeightPix 2 0)"\"></canvas>\n") Stream)
					(princ	"		</div>\n" 																								Stream)
					(princ	"   </body>\n" 																									Stream)
					(princ	" </html>\n" 																									Stream)
					
					(close Stream)
				)
			)
		)
	)
)
;
;
;
(defun PrintDrawShapeFunction (EnameShape Stream /  PosIndexTextShape
													ScaleWidthPannedDisplay ScaleHeightPannedDisplay Margin ColorExternalShape
													ColorFillExternalShape ColorBolts ColorFillBoltsShape
													ColorInternalShape ColorFillInternalShape Shape
													ColorBkgCanvas ColorTextBolts ColorTextShape TexPxBolts TexPxShape StyleTextBolts
													StyleTextShape fuzz itm itm1 PtC Pt conta LstPointTmp
													Pmin Pmax Width Height Scale DDx DDy LstPointShape UcsCanvas PointIndexShape PointIndexInternalShape
													LstPointNoDiscretizeShapeCanva LstPointExternalShapeCanvas LstEnameInternalShape
													LstPointBoltsShapeCanvas LstPointInternalShapeCanvas LstPointNoDiscretizeShapeCanvas
													LstPointNoDiscretizeInternalShapeCanvas)

	(setq ScaleWidthPannedDisplay 	140.0)
	(setq ScaleHeightPannedDisplay 	100.0)
	(setq Margin				 	10.0)
	(setq ColorExternalShape 		"Black")
	(setq ColorFillExternalShape 	"#d8dfcb")
	
	(setq ColorBolts 				"Black")
	(setq ColorFillBoltsShape 		"White")

	(setq ColorInternalShape 		"Black")
	(setq ColorFillInternalShape	"White")
	
	(setq ColorBkgCanvas	 		"White")
	(setq ColorTextBolts			"Black")
	(setq ColorTextShape			"Black")
	
	(setq TexPxBolts				"2")
	(setq TexPxShape				"2")
	(setq StyleTextBolts 			"Verdana")
	(setq StyleTextShape 			"Verdana")
	(setq fuzz 3)
	;
	;
	;
	(defun PosIndexTextShape (EnameShape / Margin Pmin Pmax Width Height maxdim conta LstPoint p1 p2 p3 pa pb pc pd Rtn)
		
		(if (and EnameShape)
			(progn
				(setq conta 0)
				(setq LstPoint 		(LM:lwvertices (entget EnameShape))) ;(cdr (nth 0 (nth 1 aa)))
				(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
				(setq Pmin 			(vlax-safearray->list mnl))
				(setq Pmax 			(vlax-safearray->list mxl))
				(setq Width   		(abs (- (nth 0 Pmax) (nth 0 Pmin)))) 
				(setq Height  		(abs (- (nth 1 Pmax) (nth 1 Pmin))))
				(setq maxdim 		(max Width Height))
				
				(cond 
					((and (> maxdim 0) 		(<= maxdim 100)) 		(setq Margin 5))
					((and (> maxdim 100) 	(<= maxdim 500)) 		(setq Margin 15))
					((and (> maxdim 500) 	(<= maxdim 1000)) 		(setq Margin 15))
					((and (> maxdim 500) 	(<= maxdim 1000)) 		(setq Margin 15))
					((and (> maxdim 1000) 	(<= maxdim 2000)) 		(setq Margin 25))
					((and (> maxdim 2000) 	(<= maxdim 5000)) 		(setq Margin 50))
					((and (> maxdim 5000) 	(<= maxdim 7000)) 		(setq Margin 80))
					((and (> maxdim 7000) 	(<= maxdim 10000)) 		(setq Margin 100))
					(t 												(setq Margin 200))
				)
				
			
				(repeat (length LstPoint)
					(cond
						((= conta 0)
							
							(setq p1 (cdr (nth 0  (nth (- (length LstPoint) 1) LstPoint))))
							(setq p2 (cdr (nth 0  (nth 0 LstPoint))))
							(setq p3 (cdr (nth 0  (nth (1+ conta) LstPoint))))
						)
						((< conta (- (length LstPoint) 1))
							
							(setq p1 (cdr (nth 0  (nth (1- conta) LstPoint))))
							(setq p2 (cdr (nth 0  (nth conta LstPoint))))
							(setq p3 (cdr (nth 0  (nth (1+ conta) LstPoint))))
						)
						((= conta (- (length LstPoint) 1))
							
							(setq p1 (cdr (nth 0  (nth (1- conta) LstPoint))))
							(setq p2 (cdr (nth 0  (nth conta LstPoint))))
							(setq p3 (cdr (nth 0  (nth 0 LstPoint))))
						)
					)
					(setq conta (1+ conta))
										
					(setq pa (prol (nth 0 p1) (nth 1 p1) (nth 0 p2) (nth 1 p2) -1000.0))
					(setq pb (prol (nth 0 p3) (nth 1 p3) (nth 0 p2) (nth 1 p2) -1000.0))
					(setq pc (nth 0 (div  (nth 0 pa) (nth 1 pa) (nth 0 pb) (nth 1 pb) 1)))
					
					(setq pd (prol (nth 0 pc) (nth 1 pc) (nth 0 p2) (nth 1 p2) 1.0))
					(if (LM:PointInside-p pd EnameShape nil)
						(setq pd (prol (nth 0 pc) (nth 1 pc) (nth 0 p2) (nth 1 p2) -1.0))
					)
					(setq pd (prol (nth 0 pd) (nth 1 pd) (nth 0 p2) (nth 1 p2) (* -1.0 Margin)))
					(setq Rtn (append Rtn (list pd)))
				)
			)
		)
		Rtn
	)
	;
	;
	;
	(if (and EnameShape Stream)
		(progn

			(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
			(setq Pmin 			(vlax-safearray->list mnl))
			(setq Pmax 			(vlax-safearray->list mxl))
			(setq Width   		(abs (- (nth 0 Pmax) (nth 0 Pmin)))) 
			(setq Height  		(abs (- (nth 1 Pmax) (nth 1 Pmin))))
			(setq Scale 		(max (/ Width  (- ScaleWidthPannedDisplay  Margin))
									 (/ Height (- ScaleHeightPannedDisplay Margin))))
						
			(setq DDx (/ (- ScaleWidthPannedDisplay  (/ Width Scale)) 2.0))
			(setq DDy (/ (- ScaleHeightPannedDisplay (/ Height Scale)) 2.0))
			
			;(setq LstPointShape (DiscretizeShape EnameShape))
			(setq LstPointShape (DiscretizeShapeNoControl EnameShape))
			(setq UcsCanvas		(DefPiano 	(nth 0 Pmin) (nth 1 Pmax) 0.0
											(nth 0 Pmax) (nth 1 Pmax) 0.0
											(nth 0 Pmin) (nth 1 Pmin) 0.0))
			

			(setq PointIndexShape 	(PosIndexTextShape EnameShape))
			
			;------------------------------------------------------------------------------------------------------------------------	
			
			(foreach itm PointIndexShape
				(setq PtC (transl (nth 0 itm) (nth 1 itm) 0.0 UcsCanvas))
				(setq LstPointNoDiscretizeShapeCanvas (append LstPointNoDiscretizeShapeCanvas
																	(list (list (+ DDx (/ (nth 0 PtC) Scale))
																				(+ DDy (/ (nth 1 PtC) Scale))))))
			)
			
			;------------------------------------------------------------------------------------------------------------------------						

			(foreach itm LstPointShape
				(setq Pt (transl (nth 0 itm) (nth 1 itm) 0.0 UcsCanvas))
				(setq LstPointExternalShapeCanvas (append LstPointExternalShapeCanvas (list (list (+ DDx (/ (nth 0 Pt) Scale)) 
																								  (+ DDy (/ (nth 1 Pt) Scale))))))
			)

			;------------------------------------------------------------------------------------------------------------------------						

			(setq LstEnameInternalShape (GetEnameInternalShapeByDummyEnameSelect EnameShape))
			(foreach itm LstEnameInternalShape
				(setq LstPointTmp nil)
				(cond
					((= (cdr (assoc 0 (entget itm))) "CIRCLE")
						(setq Pt (vlax-safearray->list (vlax-variant-value (vla-get-Center (vlax-ename->vla-object itm)))))
						(setq PtC (transl (nth 0 Pt) (nth 1 Pt) 0.0 UcsCanvas))
						(setq LstPointBoltsShapeCanvas (append LstPointBoltsShapeCanvas 
																	(list (list (+ DDx (/ (nth 0 PtC) Scale))
																				(+ DDy (/ (nth 1 PtC) Scale))
																				(/ (vla-get-Radius (vlax-ename->vla-object itm)) Scale)))))
					)
					(t
					
						;(setq LstPointShape (DiscretizeShape itm))
						(setq LstPointShape (DiscretizeShapeNoControl itm))
						(foreach itm1 LstPointShape
							(setq Pt (transl (nth 0 itm1) (nth 1 itm1) 0.0 UcsCanvas))
							(setq LstPointTmp (append LstPointTmp (list (list (+ DDx (/ (nth 0 Pt) Scale))
																		      (+ DDy (/ (nth 1 Pt) Scale))))))
						)
						(setq LstPointInternalShapeCanvas (append LstPointInternalShapeCanvas (list LstPointTmp)))ù
						(setq PointIndexInternalShape 	  (append PointIndexInternalShape (PosIndexTextShape itm)))

					)
				)
			)
			(foreach itm PointIndexInternalShape
				(setq Pt (transl (nth 0 itm) (nth 1 itm) 0.0 UcsCanvas))
				(setq LstPointNoDiscretizeInternalShapeCanvas 
							(append LstPointNoDiscretizeInternalShapeCanvas (list (list (+ DDx (/ (nth 0 Pt) Scale)) 
																						(+ DDy (/ (nth 1 Pt) Scale))))))
			)

			(princ "	function draw() {\n" 																						Stream)
			;
			; Graphics External Shape +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(princ 	"		// Shape input Java ++++++++++++++++;\n"																Stream)
			(princ (strcat "		var ColorBkgCanvas= \""     	ColorBkgCanvas "\";\n")											Stream)

			(princ (strcat "		var ColorExternalShape= \""     ColorExternalShape "\";\n")										Stream)
			(princ (strcat "		var ColorFillExternalShape= \"" ColorFillExternalShape "\";\n")									Stream)

			(princ (strcat "		var ColorInternalShape= \""     ColorInternalShape "\";\n")										Stream)
			(princ (strcat "		var ColorFillInternalShape= \"" ColorFillInternalShape "\";\n")									Stream)

			(princ "		ctx.setTransform(1,0,0,1,0,0);\n" 																		Stream)
			(princ "		ctx.scale(widthCanvas/widthView, heightCanvas/heightView);\n" 											Stream)
			(princ "		ctx.translate(-xleftView,-ytopView);\n" 																Stream)
			(princ "		ctx.fillStyle = ColorBkgCanvas;\n" 																		Stream)
			(princ "		ctx.fillRect(xleftView,ytopView, widthView,heightView);\n" 												Stream)
			(princ "		ctx.lineWidth = 1.0 / (widthCanvas/widthView);\n" 														Stream)
			(princ "		ctx.strokeStyle=ColorExternalShape; ctx.beginPath();\n"	 												Stream)
			(princ "		// Shape dinamic input Java ++++++++++++++++\n"	 														Stream)					
				
			(PrintArrayJava (mapcar 'car  LstPointExternalShapeCanvas)  "		var ArrayX_"  fuzz Stream)
			(PrintArrayJava (mapcar 'cadr LstPointExternalShapeCanvas)  "		var ArrayY_"  fuzz Stream)

			(princ	"		var i;\n"																								Stream)
			(princ	"		for (i = 0; i < ArrayX_.length; i++) { \n"																Stream)
			(princ	"			if (i==0) {\n"																						Stream)
			(princ	"				ctx.moveTo(ArrayX_[i],ArrayY_[i]);\n"															Stream)
			(princ	"			} else {\n"																							Stream)
			(princ	"				ctx.lineTo(ArrayX_[i],ArrayY_[i]);\n"															Stream)
			(princ	"			}\n"																								Stream)										
			(princ	"		}\n"																									Stream)
			(princ	"		ctx.closePath();\n"																						Stream)
			(princ	"		ctx.fillStyle =ColorFillExternalShape;\n"																Stream)
			(princ	"		ctx.fill();\n"																							Stream)
			(princ	"		ctx.stroke();\n"																						Stream)
			;
			; Graphics Bolts +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(if LstPointBoltsShapeCanvas
				(progn
					(princ 	"		// Bolts input Java ++++++++++++++++;\n"															Stream)
					(PrintArrayJava (mapcar 'car   LstPointBoltsShapeCanvas)  "		var ArrayX_"  fuzz Stream)
					(PrintArrayJava (mapcar 'cadr  LstPointBoltsShapeCanvas)  "		var ArrayY_"  fuzz Stream)
					(PrintArrayJava (mapcar 'caddr LstPointBoltsShapeCanvas)  "		var ArrayD_"  fuzz Stream)

					(princ (strcat "		var ColorBolts=\"" ColorBolts "\";\n") 															Stream)
					(princ (strcat "		var ColorFillBolts=\"" ColorFillBoltsShape "\";\n")												Stream)
					(princ	"		var i;\n" 																								Stream)
					(princ	"		for (i = 0; i < ArrayX_.length; i++) {\n" 																Stream)
					(princ	"			ctx.lineWidth = 1.0 / (widthCanvas/widthView);\n" 													Stream)
					(princ	"			ctx.strokeStyle=ColorBolts;\n" 																		Stream)
					(princ	"			ctx.beginPath();\n" 																				Stream)
					(princ	"			ctx.arc(ArrayX_[i],ArrayY_[i],ArrayD_[i],0.0,2*Math.PI);ctx.fillStyle=ColorFillBolts;\n"			Stream)
					(princ	"			ctx.fill();\n" 																						Stream)
					(princ	"			ctx.stroke();\n" 																					Stream)
					(princ	"		}\n" 																									Stream)
					(princ 	"		// Index Bolts input Java ++++++++++++++++;\n"															Stream)
					(princ 	"		if (FlagBolts==1) {\n"																					Stream)
					(princ	"			var ii;\n" 																							Stream)
					(princ	(strcat "			var Htext=" TexPxBolts " * Fact/100;\n")													Stream)
					(princ	(strcat "			var StyleTextBolts=Htext.toString() + \"px " StyleTextBolts "\";\n")						Stream)
					(princ	"			for (i = 0; i < ArrayX_.length; i++) {\n" 															Stream)
					(princ	"				ctx.font=StyleTextBolts;\n" 																	Stream)
					(princ	"				ctx.textAlign = \"left\";\n" 																	Stream)
					(princ	"				ctx.textBaseline = \"alphabetic\";\n" 															Stream)					
					(princ	"				ii=i+1;\n" 																						Stream)
					(princ	(strcat "				ctx.fillStyle=\"" ColorTextBolts "\";\n")												Stream)
					(princ	"				ctx.fillText(\"B\" + ii.toString(),ArrayX_[i]+ArrayD_[i],ArrayY_[i]-ArrayD_[i]);\n"				Stream)
					(princ	"			}\n"																								Stream)
					(princ	"		}\n"																									Stream)
				)
			)
			;
			; Graphics internal Shape +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(setq Shape 0)
			(foreach itm LstPointInternalShapeCanvas
				(princ 	"		// Internal Shape input Java ++++++++++++++++;\n"									Stream)
				(PrintArrayJava (mapcar 'car   itm) (strcat "		var ArrayXIShape" (LM:rtos Shape 2 0) "_")  fuzz Stream)
				(PrintArrayJava (mapcar 'cadr  itm) (strcat "		var ArrayYIShape" (LM:rtos Shape 2 0) "_")  fuzz Stream)

				(princ	"		var i;\n"																			Stream)
				(princ	"		ctx.strokeStyle=ColorInternalShape;\n"												Stream)
				(princ	"		ctx.fillStyle = ColorFillInternalShape;\n"											Stream)
				(princ	"		ctx.beginPath();\n"																	Stream)
				(princ	(strcat "		for (i = 0; i < ArrayXIShape" (LM:rtos Shape 2 0) "_.length; i++) { \n")	Stream)
				(princ	"			if (i==0) {\n"																	Stream)
				(princ	(strcat "				ctx.moveTo(ArrayXIShape" (LM:rtos Shape 2 0) "_[i],"
														  "ArrayYIShape" (LM:rtos Shape 2 0) "_[i]);\n")			Stream)
				(princ	"			} else {\n"																		Stream)
				(princ	(strcat "				ctx.lineTo(ArrayXIShape" (LM:rtos Shape 2 0) "_[i],"
													      "ArrayYIShape" (LM:rtos Shape 2 0) "_[i]);\n")			Stream)
				(princ	"			}\n"																			Stream)										
				(princ	"		}\n"																				Stream)
				(princ	"		ctx.closePath();\n"																	Stream)
				(princ	"		ctx.fill();\n"																		Stream)
				(princ	"		ctx.stroke();\n"																	Stream)
				(setq Shape (1+ Shape))
			)
			;
			; Graphics Index external Shape +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(princ 	"		// Index Shape input Java ++++++++++++++++;\n"															Stream)
			(PrintArrayJava (mapcar 'car   LstPointNoDiscretizeShapeCanvas)  "		var ArrayX_"  fuzz Stream)
			(PrintArrayJava (mapcar 'cadr  LstPointNoDiscretizeShapeCanvas)  "		var ArrayY_"  fuzz Stream)

			(princ 	"		if (FlagShape==1) {\n"																					Stream)
			(princ	"			var i;\n" 																							Stream)
			(princ	"			var ii;\n" 																							Stream)
			(princ	(strcat "			var Htext=" TexPxShape " * Fact/100;\n")													Stream)
			(princ	(strcat "			var StyleTextShape=Htext.toString() + \"px " StyleTextShape "\";\n")						Stream)
			(princ	"			for (i = 0; i < ArrayX_.length; i++) {\n" 															Stream)
			(princ	"				ctx.font=StyleTextShape;\n" 																	Stream)
			(princ	"				ii=i+1;\n" 																						Stream)
			(princ	(strcat "				ctx.fillStyle=\"" ColorTextShape "\";\n")												Stream)
			(princ	"				ctx.textAlign = \"center\";\n"																	Stream)					
			(princ	"				ctx.textBaseline = \"middle\";\n"																Stream)
			(princ	"				ctx.fillText(\"C\" + ii.toString(),ArrayX_[i],ArrayY_[i]);\n"									Stream)
			(princ	"			}\n"																								Stream)
			(princ	"		}\n"																									Stream)
			;
			; Graphics Index internal Shape +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(if LstPointNoDiscretizeInternalShapeCanvas
				(progn
					(princ 	"		// Index Internal Shape input Java ++++++++++++++++;\n"											Stream)
					(PrintArrayJava (mapcar 'car   LstPointNoDiscretizeInternalShapeCanvas)  "		var ArrayX_"  fuzz Stream)
					(PrintArrayJava (mapcar 'cadr  LstPointNoDiscretizeInternalShapeCanvas)  "		var ArrayY_"  fuzz Stream)

					(princ 	"		if (FlagShape==1) {\n"																			Stream)
					(princ	"			var i;\n" 																					Stream)
					(princ	"			var ii;\n" 																					Stream)
					(princ	(strcat "			var Htext=" TexPxShape " * Fact/100;\n")											Stream)
					(princ	(strcat "			var StyleTextShape=Htext.toString() + \"px " StyleTextShape "\";\n")				Stream)
					(princ	"			for (i = 0; i < ArrayX_.length; i++) {\n" 													Stream)
					(princ	"				ctx.font=StyleTextShape;\n" 															Stream)
					(princ	"				ii=i+1;\n" 																				Stream)
					(princ	(strcat "				ctx.fillStyle=\"" ColorTextShape "\";\n")										Stream)
					(princ	"				ctx.textAlign = \"center\";\n"															Stream)					
					(princ	"				ctx.textBaseline = \"middle\";\n"														Stream)
					(princ	"				ctx.fillText(\"I\" + ii.toString(),ArrayX_[i],ArrayY_[i]);\n"							Stream)
					(princ	"			}\n"																						Stream)
					(princ	"		}\n"																							Stream)
				)
			)
			(princ	"	}\n" 																								Stream)
		)
	)
)
;
;
;
(defun PrintCloseWindowShapeFunction (Stream)
	(if Stream
		(progn
			(princ "	function CloseWindow() {\n"						Stream)
			(princ "		if (WndInfo)	{WndInfo.close();}\n"		Stream)
			(princ "		if (WndShape)	{WndShape.close();}\n"		Stream)
			(princ "		if (WndBolts)	{WndBolts.close();}\n"		Stream)
			(princ "		close();\n"									Stream)
			(princ "	}\n"											Stream)
		)
	)
)
;
;
;
(defun PrintCoordinateBoltsShapeTableFunction (EnameShape Stream / Swap Color1 Color2 fuzztable Pmin Pmax UcsLocal LstEnameInternalShape 
																	itm Pt PtL LstColor LstPointInternalShapeLocal conta)

	(setq Color1 "#EDEDED")
	(setq Color2 "#DBDBDB")
	(setq fuzztable 2)
	;
	;
	;
	(defun Swap (DatoA DatoB Indice / Rtn)
	
		(if (> (- (/ Indice 2.0) (fix (/ Indice 2.0))) 0)
			(setq Rtn DatoB)
			(setq Rtn DatoA)
		)
	)
	;
	;
	;
	(if (and EnameShape Stream)
		(progn
			(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
			(setq Pmin 			(vlax-safearray->list mnl))
			(setq Pmax 			(vlax-safearray->list mxl))
			(setq UcsLocal		(DefPiano 	(nth 0 Pmin) (nth 1 Pmin) 0.0
											(nth 0 Pmax) (nth 1 Pmin) 0.0
											(nth 0 Pmin) (nth 1 Pmax) 0.0))

			(setq LstEnameInternalShape (GetEnameInternalShapeByDummyEnameSelect EnameShape))
			(setq conta 0)
			(foreach itm LstEnameInternalShape
				(cond
					((= (cdr (assoc 0 (entget itm))) "CIRCLE")
						(setq Pt (vlax-safearray->list (vlax-variant-value (vla-get-Center (vlax-ename->vla-object itm)))))
						(setq PtL (transl (nth 0 Pt) (nth 1 Pt) 0.0 UcsLocal))
						(setq LstPointInternalShapeLocal (append LstPointInternalShapeLocal
															(list (list (LM:rtos (nth 0 PtL) 2 fuzztable)
																		(LM:rtos (nth 1 PtL) 2 fuzztable)
																		(LM:rtos (vla-get-Diameter (vlax-ename->vla-object itm)) 2 fuzztable)))))
					)
					(t
						nil
					)
				)
				(setq LstColor 	(append LstColor (list (Swap Color1 Color2 Conta))))
				(setq conta (1+ conta))
			)
			
			(princ 	"	function CoordinateBoltsTable() {\n" 																Stream)
			(princ 	"		// Info Coordinate Bolts dinamic input Java ++++++++++++++++\n" 							Stream)
			(PrintArrayJava (mapcar 'car   LstPointInternalShapeLocal)  "		var ArrayX_"  0 Stream)
			(PrintArrayJava (mapcar 'cadr  LstPointInternalShapeLocal)  "		var ArrayY_"  0 Stream)
			(PrintArrayJava (mapcar 'caddr LstPointInternalShapeLocal)  "		var ArrayD_"  0 Stream)
			(PrintArrayJava LstColor  "		var ArrayC_"  fuzztable Stream)

			(princ 	"		var lines = '<!doctype html>';\n"															Stream)
			(princ 	"		lines += '<!doctype html>';\n"																Stream)
			(princ 	"		lines += '<html><head>';\n"																	Stream)
			(princ 	"		lines += '<meta charset=\"appropriate charset here\">';\n"									Stream)
			(princ 	"		lines += '<title>Info Shape</title>';\n"													Stream)
			(princ "		lines += '<button onclick=\"window.print()\">Stampa</button>';\n"							Stream)
			(princ 	"		lines += '</br>';\n"																		Stream)
			(princ 	"		lines += '</br>';\n"																		Stream)
			(princ 	"		lines += '<style>';\n"																		Stream)
			(princ 	"		lines += '.btn {color:black;transition:0.3s;}';\n"											Stream)
			(princ 	"		lines += '.btn:hover {background-color: #3e8e41;color: white;}';\n"							Stream)
			(princ 	"		lines += '.infoshape {font-size:15px;width:auto;height:auto;margin:10px;font-family:Arial;}';\n" Stream)
			(princ 	"		lines += '</style>';\n"																		Stream)
			(princ 	"		lines += '</head><body>';\n"																Stream)
			(princ 	"		lines += '<div class=\"infoshape\">';\n"													Stream)
			(princ 	"		lines += '<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">';\n"		Stream)
			(princ 	"		lines += '<tr height=\"25px\" align=\"center\">';\n"										Stream)
			(princ 	"		lines += '  <td width=\"19%\">Itm</td>';\n"													Stream)
			(princ 	"		lines += '  <td width=\"27%\">[X]</td>';\n"													Stream)
			(princ 	"		lines += '  <td width=\"27%\">[Y]</td>';\n"													Stream)
			(princ 	"		lines += '  <td width=\"27%\">[D]</td>';\n"													Stream)
			(princ 	"		lines += '</tr>';\n"																		Stream)
			(princ 	"		var i;\n"																					Stream)
			(princ 	"		var ii;\n"																					Stream)
			(princ 	"		for (i = 0; i < ArrayX_.length; i++) {\n"													Stream)
			(princ 	"			ii=i+1;\n" 																				Stream)
			(princ 	"			lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"' + ArrayC_[i] + '\">';\n"		Stream)
			(princ 	"			lines += '  <td width=\"19%\" class=\"btn\">' + 'B' + ii.toString() + '</td>';\n"		Stream)
			(princ 	"			lines += '  <td width=\"27%\" class=\"btn\">' + ArrayX_[i] + '</td>';\n"				Stream)
			(princ 	"			lines += '  <td width=\"27%\" class=\"btn\">' + ArrayY_[i] + '</td>';\n"				Stream)
			(princ 	"			lines += '  <td width=\"27%\" class=\"btn\">' + ArrayD_[i] + '</td>';\n"				Stream)
			(princ 	"			lines += '</tr>';\n"																	Stream)
			(princ 	"		}\n"																						Stream)
			(princ 	"		lines += '	</table>';\n"																	Stream)
			(princ 	"		lines += '</div>';\n"																		Stream)
			(princ 	"		lines += '</body></html>';\n"																Stream)
			(princ 	"		if (!WndBolts){\n"																			Stream)
			(princ 	"			WndBolts = window.open(\"\",\"\",\"resizable=yes,width=350,height=500,left=90,top=90,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"			WndBolts.document.write(lines);\n"														Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"			if (WndBolts.closed) {\n"																Stream)
			(princ 	"				WndBolts = window.open(\"\",\"\",\"resizable=yes,width=350,height=500,left=90,top=90,menubar=no,toolbar=no,loacation=no\");\n" Stream)
			(princ 	"				WndBolts.document.write(lines);\n"													Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"				WndBolts.close();\n"																Stream)
			(princ 	"				WndBolts = window.open(\"\",\"\",\"resizable=yes,width=350,height=500,left=90,top=90,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"				WndBolts.document.write(lines);\n"													Stream)
			(princ 	"			}\n"																					Stream)
			(princ 	"		}\n"																						Stream)
			(princ 	" 	}\n"																								Stream)
		)
	)
)
;
;
;
(defun PrintInfoShapeTableFunction (EnameShape Stream /	Swap Color1 Color2 fuzztable LstInfoShape LstColor DataShape 
														Pmin Pmax Width Height Weight JouShape CompShape itm conta)

	(setq Color1 "#EDEDED")
	(setq Color2 "#DBDBDB")
	(setq fuzztable 2)
	;
	;
	;
	(defun Swap (DatoA DatoB Indice / Rtn)
	
		(if (> (- (/ Indice 2.0) (fix (/ Indice 2.0))) 0)
			(setq Rtn DatoB)
			(setq Rtn DatoA)
		)
	)
	;
	;
	;
	
	(if (and EnameShape Stream)
		(progn
		
			(setq DataShape (GetDataShape EnameShape))
			;--------------------------------------------------------------						
			; 	0	TypShape	1	IdShape		2	JouShape 
			;	3	NameShape	4	CutComp 	5	LenghtCut 
			;	6	Timing 		7	ComShape	8	PhaseShape 
			;	9	MatShape 	10	TkShape		11	DateShape
			;--------------------------------------------------------------	
			(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
			(setq Pmin 			(vlax-safearray->list mnl))
			(setq Pmax 			(vlax-safearray->list mxl))
			(setq Width   		(abs (- (nth 0 Pmax) (nth 0 Pmin)))) 
			(setq Height  		(abs (- (nth 1 Pmax) (nth 1 Pmin))))
			(setq Weight		(rtos (* (/ (vla-get-area   (vlax-ename->vla-object Enameshape)) 1000000.0) (atof (nth 10 DataShape)) 7.85) 2 2))
		
			
			(cond 	((= (nth 2	DataShape) "2") (setq JouShape "Antioraria"))
					((= (nth 2	DataShape) "3")	(setq JouShape "Oraria")))
			(cond 	((= (nth 4	DataShape) "0")	(setq CompShape "Nessuna"))
					((= (nth 4	DataShape) "1")	(setq CompShape "Automatica"))
					((= (nth 4	DataShape) "2") (setq CompShape "Destra"))
					((= (nth 4	DataShape) "3")	(setq CompShape "Sinistra")))
			
			(setq LstInfoShape 	(list	(cons "Commessa"				(nth 7 DataShape))
										(cons "Fase"					(nth 8 DataShape))
										(cons "Marca"					(nth 3 DataShape))
										(cons "Spessore"				(nth 10 DataShape))
										(cons "Altezza"					(LM:rtos Height 2 1))
										(cons "Larghezza"				(LM:rtos Width 2 1))
										(cons "Perimetro"				(nth 5 DataShape))
										(cons "Matriale"				(nth 9 DataShape))
										(cons "Peso"					Weight)
										(cons "Tipo contorno" 			"Esterno")
										(cons "Percorrenza" 			JouShape)
										(cons "Compensazione"			CompShape)
										(cons "Tempo Taglio Esterno"	(nth 1 (nth 6 DataShape)))
										(cons "Tempo Taglio Interno"	(nth 2 (nth 6 DataShape)))
										(cons "Tempo Taglio Attacchi"	(nth 3 (nth 6 DataShape)))
										(cons "Tempo Taglio Totale"		(nth 4 (nth 6 DataShape)))
										(cons "Velocità taglio mm/min"	(LM:rtos (setq SpeedCut (GetSpeedCutByThickness (nth 10 DataShape))) 2 2))
										(cons "Ultima modifica"			(nth 11 DataShape))))
			(setq conta 0)
			(foreach itm LstInfoShape
				(setq LstColor 	(append LstColor (list (Swap Color1 Color2 Conta))))
				(setq conta (1+ conta))			
			)
										
			(princ 	"	function InfoShapeTable() {\n" 																	Stream)
			(princ 	"		// Info Shape dinamic input Java ++++++++++++++++\n" 										Stream)
			(PrintArrayJava (mapcar 'car  LstInfoShape)  "		var Array1_"  0 Stream)
			(PrintArrayJava (mapcar 'cdr  LstInfoShape)  "		var Array2_"  0 Stream)
			(PrintArrayJava LstColor  "		var Array3_"  0 Stream)

			(princ 	"		var lines = '<!doctype html>';\n"															Stream)
			(princ 	"		lines += '<!doctype html>';\n"																Stream)
			(princ 	"		lines += '<html><head>';\n"																	Stream)
			(princ 	"		lines += '<meta charset=\"appropriate charset here\">';\n"									Stream)
			(princ 	"		lines += '<title>Info Shape</title>';\n"													Stream)
			(princ 	"		lines += '<style>';\n"																		Stream)
			(princ 	"		lines += '.btn {color:black;transition:0.3s;}';\n"											Stream)
			(princ 	"		lines += '.btn:hover {background-color: #3e8e41;color: white;}';\n"							Stream)
			(princ 	"		lines += '.infoshape {font-size:15px;width:auto;height:auto;margin:10px;font-family:Arial;}';\n" Stream)
			(princ 	"		lines += '</style>';\n"																		Stream)
			(princ 	"		lines += '</head><body>';\n"																Stream)
			(princ 	"		lines += '<div class=\"infoshape\">';\n"													Stream)
			(princ  "		lines += '<button onclick=\"window.print()\">Stampa</button>';\n"							Stream)
			(princ 	"		lines += '</br>';\n"																		Stream)
			(princ 	"		lines += '</br>';\n"																		Stream)
			(princ 	"		lines += '	<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">';\n"	Stream)
			(princ 	"		var i;\n"																					Stream)
			(princ 	"		for (i = 0; i < Array1_.length; i++) {\n"													Stream)
			(princ 	"			lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"'+ Array3_[i] + '\">';\n"		Stream)
			(princ 	"			lines += '  <td width=\"50%\" class=\"btn\">' + Array1_[i] + '</td>';\n"				Stream)
			(princ 	"			lines += '  <td width=\"50%\" class=\"btn\">' + Array2_[i] + '</td>';\n"				Stream)
			(princ 	"			lines += '</tr>';\n"																	Stream)
			(princ 	"		}\n"																						Stream)
			(princ 	"		lines += '	</table>';\n"																	Stream)
			(princ 	"		lines += '</div>';\n"																		Stream)
			(princ 	"		lines += '</body></html>';\n"																Stream)
			(princ 	"		if (!WndInfo){\n"																			Stream)
			(princ 	"			WndInfo = window.open(\"\",\"\",\"resizable=yes,width=350,height=500,left=10,top=10,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"			WndInfo.document.write(lines);\n"														Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"			if (WndInfo.closed) {\n"																Stream)
			(princ 	"				WndInfo = window.open(\"\",\"\",\"resizable=yes,width=350,height=500,left=10,top=10,menubar=no,toolbar=no,loacation=no\");\n" Stream)
			(princ 	"				WndInfo.document.write(lines);\n"													Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"				WndInfo.close();\n"																	Stream)
			(princ 	"				WndInfo = window.open(\"\",\"\",\"resizable=yes,width=350,height=500,left=10,top=10,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"				WndInfo.document.write(lines);\n"													Stream)
			(princ 	"			}\n"																					Stream)
			(princ 	"		}\n"																						Stream)
			(princ 	" 	}\n"																								Stream)
		)
	)
)
;
;
;
(defun PrintCoordinateExternalShapeTableFunction (EnameShape Stream / 	Swap LstShape Pmin Pmax UcsLocal conta TypShape itm LstColor Var
																		PtStart PtEnd LgSeg PtCenter Radius Color1 Color2 fuzztable)
	
	;(("SEG." "(START X Y)" "(END X Y)" "WIDTH 1" "WIDTH 2" "LENGTH" "(CENTRE X Y)" "RADIUS") 
	;("1" (22920.0 25043.1) (23272.0 25043.1) 0.0 0.0 352.0 (nil nil) 0.0) 
	;("2" (23272.0 25043.1) (23272.0 25311.6) 0.0 0.0 268.5 (nil nil) 0.0) 
	;("3" (23272.0 25311.6) (23215.5 25551.6) 0.0 0.0 246.561 (nil nil) 0.0) 
	;("4" (23215.5 25551.6) (23214.0 25551.1) 0.0 0.0 1.58114 (nil nil) 0.0) 
    ;("5" (23214.0 25551.1) (23178.5 25580.6) 0.0 0.0 52.6637 (23208.5 25580.6) 30.0) 
	;("6" (23178.5 25580.6) (23013.5 25580.6) 0.0 0.0 165.0 (nil nil) 0.0) 
	;("7" (23013.5 25580.6) (22980.5 25551.1) 0.0 0.0 49.7815 (22983.5 25581.0) 30.0) 
	;("8" (22980.5 25551.1) (22976.5 25551.6) 0.0 0.0 4.03654 (22981.3 25573.6) 22.5) 
	;("9" (22976.5 25551.6) (22920.0 25311.6) 0.0 0.0 246.561 (nil nil) 0.0) 
	;("10" (22920.0 25311.6) (22920.0 25043.1) 0.0 0.0 268.5 (nil nil) 0.0))


	;(("SEG." "(START X Y)" "(END X Y)" "WIDTH 1" "WIDTH 2" "LENGTH") 
	;("1" (23606.5 25146.6) (24035.5 25146.6) 0.0 0.0 429.0) 
	;("2" (24035.5 25146.6) (24050.5 25161.6) 0.0 0.0 21.2132)
	;("3" (24050.5 25161.6) (24050.5 25476.1) 0.0 0.0 314.5) 
	;("4" (24050.5 25476.1) (24036.0 25492.1) 0.0 0.0 21.5928) 
	;("5" (24036.0 25492.1) (23485.0 25530.6) 0.0 0.0 552.343) 
	;("6" (23485.0 25530.6) (23471.5 25339.1) 0.0 0.0 191.975) 
	;("7" (23471.5 25339.1) (23606.5 25146.6) 0.0 0.0 235.12))

	(setq Color1 "#EDEDED")
	(setq Color2 "#DBDBDB")
	(setq fuzztable 2)
	;
	;
	;
	(defun Swap (DatoA DatoB Indice / Rtn)
	
		(if (> (- (/ Indice 2.0) (fix (/ Indice 2.0))) 0)
			(setq Rtn DatoB)
			(setq Rtn DatoA)
		)
	)
	;
	;
	;
	(if (and EnameShape Stream)
		(progn
			
			(setq LstShape (LM:InfoExpertPoly EnameShape))
			(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
			(setq Pmin 			(vlax-safearray->list mnl))
			(setq Pmax 			(vlax-safearray->list mxl))
			(setq UcsLocal		(DefPiano 	(nth 0 Pmin) (nth 1 Pmin) 0.0
											(nth 0 Pmax) (nth 1 Pmin) 0.0
											(nth 0 Pmin) (nth 1 Pmax) 0.0))

			(setq TypShape (length (nth 0 LstShape)))
			
			(setq conta 0)
			(foreach itm (cdr LstShape)
			
				(setq Var 		(transl (nth 0 (nth 1 itm)) (nth 1 (nth 1 itm)) 0.0 UcsLocal))
				(setq PtStart 	(append PtStart (list (list (LM:rtos (nth 0 var) 2 fuzztable) (LM:rtos  (nth 1 var) 2 fuzztable)))))
				
				(setq Var 		(transl (nth 0 (nth 2 itm)) (nth 1 (nth 2 itm)) 0.0 UcsLocal))
				(setq PtEnd   	(append PtEnd   (list (list (LM:rtos (nth 0 var) 2 fuzztable) (LM:rtos  (nth 1 var) 2 fuzztable)))))
				
				(setq LgSeg		(append LgSeg	(list (LM:rtos (nth 5 itm) 2 fuzztable))))
				(setq LstColor 	(append LstColor (list (Swap Color1 Color2 Conta))))
				(setq conta (1+ conta))
				
				(if (= TypShape 8) ; contorno con raccordi
					(progn
						(if (nth 6 itm)
							(progn
								(setq Var 		(transl (nth 0 (nth 6 itm)) (nth 1 (nth 6 itm)) 0.0 UcsLocal))
								(setq PtCenter 	(append PtCenter (list (list (LM:rtos (nth 0 var) 2 fuzztable) (LM:rtos  (nth 1 var) 2 fuzztable)))))
							)
							(setq PtCenter 	(append PtCenter (list (list nil nil))))
						)
					)
				)
				(if (= TypShape 8) ; contorno con raccordi
					(setq Radius 	(append Radius (list (LM:rtos (nth 7 itm) 2 fuzztable))))
				)
			)
			
			;(princ PtStart) (terpri)
			;(princ PtEnd) (terpri)
			;(princ LgSeg) (terpri)
			;(princ PtCenter) (terpri)
			;(princ Radius) (terpri)
			;(getstring "")
			
			(princ 	"	function CoordinateExternalShapeTable() {\n" 													Stream)
			(princ 	"		// Info Coordinate Shape dinamic input Java ++++++++++++++++\n" 							Stream)
			
			; ---------------------------------------------------------------------------------
			(PrintArrayJava (mapcar 'car PtStart)  "		var ArrayXS_"  0 Stream)
			(PrintArrayJava (mapcar 'cadr PtStart) "		var ArrayYS_"  0 Stream)
			(PrintArrayJava (mapcar 'car PtEnd)    "		var ArrayXE_"  0 Stream)
			(PrintArrayJava (mapcar 'cadr PtEnd)   "		var ArrayYE_"  0 Stream)
			(PrintArrayJava LgSeg   			   "		var ArrayLS_"  0 Stream)
			(PrintArrayJava LstColor   			   "		var ArrayCO_"  0 Stream)
			; ---------------------------------------------------------------------------------
			
			(if (= TypShape 8) ; contorno con raccordi
				(progn
					(PrintArrayJava (mapcar 'car PtCenter)    "		var ArrayXC_"  0 Stream)
					(PrintArrayJava (mapcar 'cadr PtCenter)   "		var ArrayYC_"  0 Stream)
					(PrintArrayJava Radius    "		var ArrayRA_"  0 Stream)
				)
			)
		
			(princ 	"		var lines = '<!doctype html>';\n"															Stream)
			(princ 	"		lines += '<!doctype html>';\n"																Stream)
			(princ 	"		lines += '<html><head>';\n"																	Stream)
			(princ 	"		lines += '<meta charset=\"appropriate charset here\">';\n"									Stream)
			(princ 	"		lines += '<title>Info Shape</title>';\n"													Stream)
			(princ 	"		lines += '<style>';\n"																		Stream)
			(princ 	"		lines += '.btn {color:black;transition:0.3s;}';\n"											Stream)
			(princ 	"		lines += '.btn:hover {background-color: #3e8e41;color: white;}';\n"							Stream)
			(princ 	"		lines += '.infoshape {font-size:15px;width:auto;height:auto;margin:10px;font-family:Arial;}';\n" Stream)
			(princ 	"		lines += '</style>';\n"																		Stream)
			(princ 	"		lines += '</head><body>';\n"																Stream)
			(princ 	"		lines += '<div class=\"infoshape\">';\n"													Stream)
			(princ "		lines += '<button onclick=\"window.print()\">Stampa</button>';\n"							Stream)
			(princ 	"		lines += '</br>';\n"																		Stream)
			(princ 	"		lines += '</br>';\n"																		Stream)
			(princ 	"		lines += '<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">';\n"		Stream)

			(cond
				((= TypShape 8)
				
					;	ArrayXS_	ArrayYS_	ArrayXE_	ArrayYE_	ArrayLS_	ArrayXC_	ArrayYC_	ArrayRA_	ArrayCO_
					
					(princ 	"		lines += '<tr height=\"25px\" align=\"center\">';\n"										Stream)
					(princ 	"		lines += '  <td width=\"4%\">Itm</td>';\n"													Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Xstart]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Ystart]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Xend]</td>';\n"												Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Yend]</td>';\n"												Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Lg Seg]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Xcenter]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Ycenter]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Radius]</td>';\n"											Stream)
					(princ 	"		lines += '</tr>';\n"																		Stream)
					(princ 	"		var i;\n"																					Stream)
					(princ 	"		var ii;\n"																					Stream)
					(princ 	"		for (i = 0; i < ArrayXS_.length; i++) {\n"													Stream)
					(princ 	"			ii=i+1;\n" 																				Stream)
					(princ 	"			lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"' + ArrayCO_[i] + '\">';\n"	Stream)
					(princ 	"			lines += '  <td width=\"4%\" class=\"btn\">' + 'C' + ii.toString() + '</td>';\n"		Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayXS_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayYS_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayXE_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayYE_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayLS_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayXC_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayYC_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayRA_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '</tr>';\n"																	Stream)
					(princ 	"		}\n"																						Stream)
				)
				((= TypShape 6)
				
					;	ArrayXS_	ArrayYS_	ArrayXE_	ArrayYE_	ArrayLS_	ArrayCO_
					
					(princ 	"		lines += '<tr height=\"25px\" align=\"center\">';\n"										Stream)
					(princ 	"		lines += '  <td width=\"4%\">Itm</td>';\n"													Stream)
					(princ 	"		lines += '  <td width=\"19.2%\">[Xstart]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"19.2%\">[Ystart]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"19.2%\">[Xend]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"19.2%\">[Yend]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"19.2%\">[Lg Seg]</td>';\n"											Stream)
					(princ 	"		lines += '</tr>';\n"																		Stream)
					(princ 	"		var i;\n"																					Stream)
					(princ 	"		var ii;\n"																					Stream)
					(princ 	"		for (i = 0; i < ArrayXS_.length; i++) {\n"													Stream)
					(princ 	"			ii=i+1;\n" 																				Stream)
					(princ 	"			lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"' + ArrayCO_[i] + '\">';\n"	Stream)
					(princ 	"			lines += '  <td width=\"4%\" class=\"btn\">' + 'C' + ii.toString() + '</td>';\n"		Stream)
					(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayXS_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayYS_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayYE_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayYE_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayLS_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '</tr>';\n"																	Stream)
					(princ 	"		}\n"																						Stream)
				)
			)
			(princ 	"		lines += '</table>';\n"																		Stream)
			(princ 	"		lines += '</div>';\n"																		Stream)
			(princ 	"		lines += '</body></html>';\n"																Stream)
			(princ 	"		if (!WndShape){\n"																			Stream)
			(princ 	"			WndShape = window.open(\"\",\"\",\"resizable=yes,width=750,height=500,left=50,top=50,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"			WndShape.document.write(lines);\n"														Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"			if (WndShape.closed) {\n"																Stream)
			(princ 	"				WndShape = window.open(\"\",\"\",\"resizable=yes,width=750,height=500,left=50,top=50,menubar=no,toolbar=no,loacation=no\");\n" Stream)
			(princ 	"				WndShape.document.write(lines);\n"													Stream)
			(princ 	"			} else {\n"																				Stream);
			(princ 	"				WndShape.close();\n"																Stream)
			(princ 	"				WndShape = window.open(\"\",\"\",\"resizable=yes,width=750,height=500,left=50,top=50,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"				WndShape.document.write(lines);\n"													Stream)
			(princ 	"			}\n"																					Stream)
			(princ 	"		}\n"																						Stream)
			(princ 	" 	}\n"																							Stream)
		)
	)
)
;
;
;
(defun PrintCoordinateInternalShapeTableFunction (EnameShape Stream / 	Swap LstShape Pmin Pmax UcsLocal conta TypShape itm LstColor Var
																		PtStart PtEnd LgSeg PtCenter Radius Color1 Color2 fuzztable
																		Num Ent)
	
	;(("SEG." "(START X Y)" "(END X Y)" "WIDTH 1" "WIDTH 2" "LENGTH" "(CENTRE X Y)" "RADIUS") 
	;("1" (22920.0 25043.1) (23272.0 25043.1) 0.0 0.0 352.0 (nil nil) 0.0) 
	;("2" (23272.0 25043.1) (23272.0 25311.6) 0.0 0.0 268.5 (nil nil) 0.0) 
	;("3" (23272.0 25311.6) (23215.5 25551.6) 0.0 0.0 246.561 (nil nil) 0.0) 
	;("4" (23215.5 25551.6) (23214.0 25551.1) 0.0 0.0 1.58114 (nil nil) 0.0) 
    ;("5" (23214.0 25551.1) (23178.5 25580.6) 0.0 0.0 52.6637 (23208.5 25580.6) 30.0) 
	;("6" (23178.5 25580.6) (23013.5 25580.6) 0.0 0.0 165.0 (nil nil) 0.0) 
	;("7" (23013.5 25580.6) (22980.5 25551.1) 0.0 0.0 49.7815 (22983.5 25581.0) 30.0) 
	;("8" (22980.5 25551.1) (22976.5 25551.6) 0.0 0.0 4.03654 (22981.3 25573.6) 22.5) 
	;("9" (22976.5 25551.6) (22920.0 25311.6) 0.0 0.0 246.561 (nil nil) 0.0) 
	;("10" (22920.0 25311.6) (22920.0 25043.1) 0.0 0.0 268.5 (nil nil) 0.0))


	;(("SEG." "(START X Y)" "(END X Y)" "WIDTH 1" "WIDTH 2" "LENGTH") 
	;("1" (23606.5 25146.6) (24035.5 25146.6) 0.0 0.0 429.0) 
	;("2" (24035.5 25146.6) (24050.5 25161.6) 0.0 0.0 21.2132)
	;("3" (24050.5 25161.6) (24050.5 25476.1) 0.0 0.0 314.5) 
	;("4" (24050.5 25476.1) (24036.0 25492.1) 0.0 0.0 21.5928) 
	;("5" (24036.0 25492.1) (23485.0 25530.6) 0.0 0.0 552.343) 
	;("6" (23485.0 25530.6) (23471.5 25339.1) 0.0 0.0 191.975) 
	;("7" (23471.5 25339.1) (23606.5 25146.6) 0.0 0.0 235.12))

	(setq Color1 "#EDEDED")
	(setq Color2 "#DBDBDB")
	(setq fuzztable 2)
	;
	;
	;
	(defun Swap (DatoA DatoB Indice / Rtn)
	
		(if (> (- (/ Indice 2.0) (fix (/ Indice 2.0))) 0)
			(setq Rtn DatoB)
			(setq Rtn DatoA)
		)
	)
	;
	;
	;
	(setq Num 0)
	(if (and EnameShape Stream)
		(progn
			(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
			(setq Pmin 			(vlax-safearray->list mnl))
			(setq Pmax 			(vlax-safearray->list mxl))
			(setq UcsLocal		(DefPiano 	(nth 0 Pmin) (nth 1 Pmin) 0.0 (nth 0 Pmax) (nth 1 Pmin) 0.0 (nth 0 Pmin) (nth 1 Pmax) 0.0))

			(foreach Ent (GetEnameInternalShapeByDummyEnameSelect EnameShape)
				(if (/= (cdr (assoc 0 (entget Ent))) "CIRCLE")
					(progn
						(setq LstShape (LM:InfoExpertPoly Ent))
						(setq TypShape (length (nth 0 LstShape)))
						(setq conta 	0)
						(setq PtStart 	nil)
						(setq PtEnd 	nil)
						(setq LgSeg 	nil)
						(setq LstColor 	nil)
						(setq PtCenter 	nil)
						(setq Radius 	nil)
						
						(foreach itm (cdr LstShape)
			
							(setq Var 		(transl (nth 0  (nth 1 itm)) (nth 1 (nth 1 itm)) 0.0 UcsLocal))
							(setq PtStart 	(append PtStart (list (list (LM:rtos (nth 0 var) 2 fuzztable) (LM:rtos  (nth 1 var) 2 fuzztable)))))
				
							(setq Var 		(transl (nth 0  (nth 2 itm)) (nth 1 (nth 2 itm)) 0.0 UcsLocal))
							(setq PtEnd   	(append PtEnd   (list (list (LM:rtos (nth 0 var) 2 fuzztable) (LM:rtos  (nth 1 var) 2 fuzztable)))))
				
							(setq LgSeg		(append LgSeg	 (list (LM:rtos (nth 5 itm) 2 fuzztable))))
							(setq LstColor 	(append LstColor (list (Swap Color1 Color2 Conta))))
							(setq conta (1+ conta))
				
							(if (= TypShape 8) ; contorno con raccordi
								(progn
									(if (nth 6 itm)
										(progn
											(setq Var 		(transl (nth 0 (nth 6 itm)) (nth 1 (nth 6 itm)) 0.0 UcsLocal))
											(setq PtCenter 	(append PtCenter (list (list (LM:rtos (nth 0 var) 2 fuzztable) (LM:rtos  (nth 1 var) 2 fuzztable)))))
										)
										(setq PtCenter 	(append PtCenter (list (list nil nil))))
									)
								)
							)
							(if (= TypShape 8) ; contorno con raccordi
								(setq Radius 	(append Radius (list (LM:rtos (nth 7 itm) 2 fuzztable))))
							)
						)
					
						(if (= Num 0)
							(progn
								(princ 	"	function CoordinateInternalShapeTable() {\n" 															Stream)
								(princ 	"		// Info Coordinate Shape dinamic input Java ++++++++++++++++\n" 									Stream)
								(princ 	"		var lines = '<!doctype html>';\n"																	Stream)
								(princ 	"		var i;\n"																							Stream)
								(princ 	"		var ii = 0;\n"																						Stream)
								(princ 	"		lines += '<!doctype html>';\n"																		Stream)
								(princ 	"		lines += '<html><head>';\n"																			Stream)
								(princ 	"		lines += '<meta charset=\"appropriate charset here\">';\n"											Stream)
								(princ 	"		lines += '<title>Info Shape</title>';\n"															Stream)
								(princ 	"		lines += '<style>';\n"																				Stream)
								(princ 	"		lines += '.btn {color:black;transition:0.3s;}';\n"													Stream)
								(princ 	"		lines += '.btn:hover {background-color: #3e8e41;color: white;}';\n"									Stream)
								(princ 	"		lines += '.infoshape {font-size:15px;width:auto;height:auto;margin:10px;font-family:Arial;}';\n" 	Stream)
								(princ 	"		lines += '</style>';\n"																				Stream)
								(princ 	"		lines += '</head><body>';\n"																		Stream)
								(princ 	"		lines += '<div class=\"infoshape\">';\n"															Stream)
								(princ  "		lines += '<button onclick=\"window.print()\">Stampa</button>';\n"									Stream)
								(princ 	"		lines += '</br>';\n"																				Stream)
								(princ 	"		lines += '</br>';\n"																				Stream)
								(setq Num (1+ Num))
							)
						)
			
						; ---------------------------------------------------------------------------------
						(PrintArrayJava (mapcar 'car PtStart)  "		var ArrayXS_"  0 Stream)
						(PrintArrayJava (mapcar 'cadr PtStart) "		var ArrayYS_"  0 Stream)
						(PrintArrayJava (mapcar 'car PtEnd)    "		var ArrayXE_"  0 Stream)
						(PrintArrayJava (mapcar 'cadr PtEnd)   "		var ArrayYE_"  0 Stream)
						(PrintArrayJava LgSeg   			   "		var ArrayLS_"  0 Stream)
						(PrintArrayJava LstColor   			   "		var ArrayCO_"  0 Stream)
						; ---------------------------------------------------------------------------------
						
						(if (= TypShape 8) ; contorno con raccordi
							(progn
								(PrintArrayJava (mapcar 'car PtCenter)    "			var ArrayXC_"  0 Stream)
								(PrintArrayJava (mapcar 'cadr PtCenter)   "			var ArrayYC_"  0 Stream)
								(PrintArrayJava Radius    "			var ArrayRA_"  0 Stream)
							)
						)
		
						(cond
							((= TypShape 8)
				
								;	ArrayXS_	ArrayYS_	ArrayXE_	ArrayYE_	ArrayLS_	ArrayXC_	ArrayYC_	ArrayRA_	ArrayCO_
					
								(princ 	"		lines += '<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">';\n"		Stream)
								(princ 	"		lines += '<tr height=\"25px\" align=\"center\">';\n"										Stream)
								(princ 	"		lines += '  <td width=\"4%\">Itm</td>';\n"													Stream)
								(princ 	"		lines += '  <td width=\"12%\">[Xstart]</td>';\n"											Stream)
								(princ 	"		lines += '  <td width=\"12%\">[Ystart]</td>';\n"											Stream)
								(princ 	"		lines += '  <td width=\"12%\">[Xend]</td>';\n"												Stream)
								(princ 	"		lines += '  <td width=\"12%\">[Yend]</td>';\n"												Stream)
								(princ 	"		lines += '  <td width=\"12%\">[Lg Seg]</td>';\n"											Stream)
								(princ 	"		lines += '  <td width=\"12%\">[Xcenter]</td>';\n"											Stream)
								(princ 	"		lines += '  <td width=\"12%\">[Ycenter]</td>';\n"											Stream)
								(princ 	"		lines += '  <td width=\"12%\">[Radius]</td>';\n"											Stream)
								(princ 	"		lines += '</tr>';\n"																		Stream)
								(princ 	"		for (i = 0; i < ArrayXS_.length; i++) {\n"													Stream)
								(princ 	"			ii=ii+1;\n"																				Stream)
								(princ 	"			lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"' + ArrayCO_[i] + '\">';\n"	Stream)
								(princ 	"			lines += '  <td width=\"4%\" class=\"btn\">' + 'I' + ii.toString() + '</td>';\n"		Stream)
								(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayXS_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayYS_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayXE_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayYE_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayLS_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayXC_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayYC_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayRA_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '</tr>';\n"																	Stream)
								(princ 	"		}\n"																						Stream)
								(princ 	"		lines += '</table>';\n"																		Stream)
								(princ 	"		lines += '</br>';\n"																		Stream)
							)
							
							((= TypShape 6)
				
								;	ArrayXS_	ArrayYS_	ArrayXE_	ArrayYE_	ArrayLS_	ArrayCO_
					
								(princ 	"		lines += '<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">';\n"		Stream)
								(princ 	"		lines += '<tr height=\"25px\" align=\"center\">';\n"										Stream)
								(princ 	"		lines += '  <td width=\"4%\">Itm</td>';\n"													Stream)
								(princ 	"		lines += '  <td width=\"19.2%\">[Xstart]</td>';\n"											Stream)
								(princ 	"		lines += '  <td width=\"19.2%\">[Ystart]</td>';\n"											Stream)
								(princ 	"		lines += '  <td width=\"19.2%\">[Xend]</td>';\n"											Stream)
								(princ 	"		lines += '  <td width=\"19.2%\">[Yend]</td>';\n"											Stream)
								(princ 	"		lines += '  <td width=\"19.2%\">[Lg Seg]</td>';\n"											Stream)
								(princ 	"		lines += '</tr>';\n"																		Stream)
								(princ 	"		for (i = 0; i < ArrayXS_.length; i++) {\n"													Stream)
								(princ 	"			ii=ii+1;\n" 																			Stream)
								(princ 	"			lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"' + ArrayCO_[i] + '\">';\n"	Stream)
								(princ 	"			lines += '  <td width=\"4%\" class=\"btn\">' + 'I' + ii.toString() + '</td>';\n"		Stream)
								(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayXS_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayYS_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayYE_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayYE_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayLS_[i] + '</td>';\n"				Stream)
								(princ 	"			lines += '</tr>';\n"																	Stream)
								(princ 	"		}\n"																						Stream)
								(princ 	"		lines += '</table>';\n"																		Stream)
								(princ 	"		lines += '</br>';\n"																		Stream)
							)
						)
					)
				)
			)
			(if (> Num 0)
				(progn
					(princ 	"		lines += '</div>';\n"																		Stream)
					(princ 	"		lines += '</body></html>';\n"																Stream)
					(princ 	"		if (!WndShape){\n"																			Stream)
					(princ 	"			WndShape = window.open(\"\",\"\",\"resizable=yes,width=750,height=500,left=50,top=50,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
					(princ 	"			WndShape.document.write(lines);\n"														Stream)
					(princ 	"			} else {\n"																				Stream)
					(princ 	"			if (WndShape.closed) {\n"																Stream)
					(princ 	"				WndShape = window.open(\"\",\"\",\"resizable=yes,width=750,height=500,left=50,top=50,menubar=no,toolbar=no,loacation=no\");\n" Stream)
					(princ 	"				WndShape.document.write(lines);\n"													Stream)
					(princ 	"			} else {\n"																				Stream);
					(princ 	"				WndShape.close();\n"																Stream)
					(princ 	"				WndShape = window.open(\"\",\"\",\"resizable=yes,width=750,height=500,left=50,top=50,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
					(princ 	"				WndShape.document.write(lines);\n"													Stream)
					(princ 	"			}\n"																					Stream)
					(princ 	"		}\n"																						Stream)
					(princ 	" 	}\n"																							Stream)
				)
			)
		)
	)
)
;
; DSTV to HTML +++++++++++++++++++++++++++++++++++++++++++++++++
;
(defun PrintCoordinateExternalShapeTableDstvFunction (LstShape Stream / Swap DataArco 
																Xmax Xmin Ymax Ymin UcsLocal conta TypShape itm LstColor Var
																PtStart PtEnd LgSeg PtCenter Radius Color1 Color2 fuzztable)
	
	;(763.5 0.0 0.0) 		(963.5 0.0 0.0) 	(1183.5 500.0 0.0) 		(1183.5 1040.0 0.0) 
	;(983.5 1540.0 0.0) 	(743.5 1540.0 0.0) 	(565.0 1077.5 -100.0) 
	;(501.5 1030.0 0.0) 	(0.0 910.0 0.0) 	(0.0 630.0 0.0) 
	;(515.0 507.0 -100.0) 	(564.0 478.5 0.0) 	(763.5 0.0 0.0))


	(setq Color1 "#EDEDED")
	(setq Color2 "#DBDBDB")
	(setq fuzztable 2)
	;
	;
	;
	(defun Swap (DatoA DatoB Indice / Rtn)
	
		(if (> (- (/ Indice 2.0) (fix (/ Indice 2.0))) 0)
			(setq Rtn DatoB)
			(setq Rtn DatoA)
		)
	)
	;
	;
	;
	(defun DataArco (p1 p2 ra / corda freccia residuo px pout alfa_ini alfa_fin out alfa_interno fs)
		
		(setq corda (distance p1 p2))
		
		(if (> (abs (- (/ corda 2.0) (abs ra))) 1e-10)
			(progn
				(setq freccia (- (abs ra) (sqrt (- (* ra ra)  (/ (* corda corda) 4.0)))))
				(setq residuo (- (abs ra) freccia))
				(setq px (nth 0 (div (nth 0 p1) (nth 1 p1)
									 (nth 0 p2) (nth 1 p2)
									 1
								)
						)
				)
				(if (> ra 0)
					(setq pout (per (nth 0 p1) (nth 1 p1)
									(nth 0 px) (nth 1 px)
									residuo
								)
					)
					(setq pout (per (nth 0 p1) (nth 1 p1)
									(nth 0 px) (nth 1 px)
									(* residuo -1.0)
								)
					)
				)
			)
			(progn
				(setq pout (nth 0 (div (nth 0 p1) (nth 1 p1)
									   (nth 0 p2) (nth 1 p2)
										1
								  )
						   )
						   freccia (abs ra)
				)
			)
		)      
		(if (> ra 0)
			(progn
				(setq alfa_ini (angle pout p1))
				(setq alfa_fin (angle pout p2))
			)
			(progn
				(setq alfa_ini (angle pout p2))
				(setq alfa_fin (angle pout p1))
			)
		)
		(setq fs (/ freccia (/ corda 2.0)))
		(if (< ra 0)
			(setq fs (* fs -1.0))
		)
		(list (list (nth 0 pout) (nth 1 pout)) alfa_ini alfa_fin ra	fs)
	)
	;
	;
	;
	(defun DeltaAng (AngIni AngFin / Rtn)
		(if (and AngIni AngFin)
			(progn
				(setq Rtn (- AngFin AngIni))
				(cond
					((= Rtn 0)
						(setq Rtn 0.0)
					)
					((< Rtn 0)
						(setq Rtn (+ (* Pi 2.0) Rtn))
					)
				)
			)
		)
		Rtn
	)
	;
	; MAIN
	;
	(if (and LstShape Stream)
		(progn
						
			;(setq LstShape (LM:InfoExpertPoly EnameShape))
			;(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
			;(setq Pmin 			(vlax-safearray->list mnl))
			;(setq Pmax 			(vlax-safearray->list mxl))
			
			(setq LstPointShape (car (DiscretizeDstvShape LstShape)))
			
			(setq Xmin 		(apply 'min (mapcar 'car LstPointShape)))
			(setq Xmax 		(apply 'max (mapcar 'car LstPointShape)))
			(setq Ymin 		(apply 'min (mapcar 'cadr LstPointShape)))
			(setq Ymax 		(apply 'max (mapcar 'cadr LstPointShape)))
			
			;(setq UcsLocal		(DefPiano 	(nth 0 Pmin) (nth 1 Pmin) 0.0
			;								(nth 0 Pmax) (nth 1 Pmin) 0.0
			;								(nth 0 Pmin) (nth 1 Pmax) 0.0))
											
			(setq UcsLocal		(DefPiano 	Xmin Ymin 0.0
											Xmax Ymin 0.0
											Xmin Ymax 0.0))
											
			
			
			(setq conta 0)
			(setq TypShape 1)
			
			(repeat (- (length LstShape) 1)
			
				(setq p1 (nth (+ conta 0) LstShape))
				(setq p2 (nth (+ conta 1) LstShape))
				
				
				(setq Var 		(transl (nth 0 p1) (nth 1 p1) 0.0 UcsLocal))
				(setq PtStart 	(append PtStart (list (list (LM:rtos (nth 0 var) 2 fuzztable) (LM:rtos  (nth 1 var) 2 fuzztable)))))
				
				(setq Var 		(transl (nth 0 p2) (nth 1 p2) 0.0 UcsLocal))
				(setq PtEnd   	(append PtEnd   (list (list (LM:rtos (nth 0 var) 2 fuzztable) (LM:rtos  (nth 1 var) 2 fuzztable)))))
				
				
				(if (/= (nth 2 p1) 0)
					(progn
						(setq TypShape 2)
						(setq InfoArco (DataArco (list (nth 0 p1) (nth 1 p1))
												 (list (nth 0 p2) (nth 1 p2))
												 (nth 2 p1)))
						;(PtCen alfa_ini alfa_fin ra fs)
						
						;(setq LgSeg (append LgSeg	(list (LM:rtos      (* (abs (nth 2 p1)) (- (nth 2 InfoArco) (nth 1 InfoArco))) 2 fuzztable))))
						(setq LgSeg	(append LgSeg 	(list (LM:rtos (abs (* (nth 2 p1) (DeltaAng (nth 1 InfoArco) (nth 2 InfoArco)))) 2 fuzztable))))
						
						(setq PtCenter 	(append PtCenter (list (list (LM:rtos (nth 0 (nth 0 InfoArco )) 2 fuzztable) 
																	 (LM:rtos (nth 1 (nth 0 InfoArco )) 2 fuzztable)
																))))
						(setq Radius 	(append Radius (list (LM:rtos (abs (nth 2 p1)) 2 fuzztable))))
					)
					(progn
						(setq LgSeg		(append LgSeg	(list (LM:rtos (distance (list (nth 0 p1) (nth 1 p1)) (list (nth 0 p2) (nth 1 p2))) 2 fuzztable))))
						(setq PtCenter 	(append PtCenter (list (list "-" "-"))))
						(setq Radius 	(append Radius (list "-")))
					)
				)

				(setq LstColor 	(append LstColor (list (Swap Color1 Color2 Conta))))
				(setq conta (1+ conta))
			)
			;(princ PtStart) (terpri)
			;(princ PtEnd) (terpri)
			;(princ LgSeg) (terpri)
			;(princ PtCenter) (terpri)
			;(princ Radius) (terpri)
			;(getstring "")
			
			(princ 	"	function CoordinateExternalShapeTable() {\n" 													Stream)
			(princ 	"		// Info Coordinate Shape dinamic input Java ++++++++++++++++\n" 							Stream)
			
			; ---------------------------------------------------------------------------------
			(PrintArrayJava (mapcar 'car PtStart)  "		var ArrayXS_"  0 Stream)
			(PrintArrayJava (mapcar 'cadr PtStart) "		var ArrayYS_"  0 Stream)
			(PrintArrayJava (mapcar 'car PtEnd)    "		var ArrayXE_"  0 Stream)
			(PrintArrayJava (mapcar 'cadr PtEnd)   "		var ArrayYE_"  0 Stream)
			(PrintArrayJava LgSeg   			   "		var ArrayLS_"  0 Stream)
			(PrintArrayJava LstColor   			   "		var ArrayCO_"  0 Stream)
			; ---------------------------------------------------------------------------------
			(if (= TypShape 2) ; contorno con raccordi
				(progn
					(PrintArrayJava (mapcar 'car PtCenter)    "			var ArrayXC_"  0 Stream)
					(PrintArrayJava (mapcar 'cadr PtCenter)   "			var ArrayYC_"  0 Stream)
					(PrintArrayJava Radius    "			var ArrayRA_"  0 Stream)
				)
			)
		
			(princ 	"		var lines = '<!doctype html>';\n"															Stream)
			(princ 	"		lines += '<!doctype html>';\n"																Stream)
			(princ 	"		lines += '<html><head>';\n"																	Stream)
			(princ 	"		lines += '<meta charset=\"appropriate charset here\">';\n"									Stream)
			(princ 	"		lines += '<title>Info Shape</title>';\n"													Stream)
			(princ 	"		lines += '<style>';\n"																		Stream)
			(princ 	"		lines += '.btn {color:black;transition:0.3s;}';\n"											Stream)
			(princ 	"		lines += '.btn:hover {background-color: #3e8e41;color: white;}';\n"							Stream)
			(princ 	"		lines += '.infoshape {font-size:15px;width:auto;height:auto;margin:10px;font-family:Arial;}';\n" Stream)
			(princ 	"		lines += '</style>';\n"																		Stream)
			(princ 	"		lines += '</head><body>';\n"																Stream)
			(princ 	"		lines += '<div class=\"infoshape\">';\n"													Stream)
			(princ  "		lines += '<button onclick=\"window.print()\">Stampa</button>';\n"							Stream)
			(princ 	"		lines += '</br>';\n"																		Stream)
			(princ 	"		lines += '</br>';\n"																		Stream)
			(princ 	"		lines += '	<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">';\n"	Stream)

			(cond
				((= TypShape 2)
				
					;	ArrayXS_	ArrayYS_	ArrayXE_	ArrayYE_	ArrayLS_	ArrayXC_	ArrayYC_	ArrayRA_	ArrayCO_
					
					(princ 	"		lines += '<tr height=\"25px\" align=\"center\">';\n"										Stream)
					(princ 	"		lines += '  <td width=\"4%\">Itm</td>';\n"													Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Xstart]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Ystart]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Xend]</td>';\n"												Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Yend]</td>';\n"												Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Lg Seg]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Xcenter]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Ycenter]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"12%\">[Radius]</td>';\n"											Stream)
					(princ 	"		lines += '</tr>';\n"																		Stream)
					(princ 	"		var i;\n"																					Stream)
					(princ 	"		var ii;\n"																					Stream)
				
				
					(princ 	"		for (i = 0; i < ArrayXS_.length; i++) {\n"													Stream)
					(princ 	"			ii=i+1;\n" 																				Stream)
					(princ 	"			lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"' + ArrayCO_[i] + '\">';\n"	Stream)
					(princ 	"			lines += '  <td width=\"4%\" class=\"btn\">' + 'C' + ii.toString() + '</td>';\n"		Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayXS_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayYS_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayXE_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayYE_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayLS_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayXC_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayYC_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayRA_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '</tr>';\n"																	Stream)
					(princ 	"		}\n"																						Stream)
					(princ 	"		lines += '	</table>';\n"																	Stream)
					(princ 	"		lines += '</div>';\n"																		Stream)
					(princ 	"		lines += '</body></html>';\n"																Stream)
				)
				((= TypShape 1)
				
					;	ArrayXS_	ArrayYS_	ArrayXE_	ArrayYE_	ArrayLS_	ArrayCO_
					
					(princ 	"		lines += '<tr height=\"25px\" align=\"center\">';\n"										Stream)
					(princ 	"		lines += '  <td width=\"4%\">Itm</td>';\n"													Stream)
					(princ 	"		lines += '  <td width=\"19.2%\">[Xstart]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"19.2%\">[Ystart]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"19.2%\">[Xend]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"19.2%\">[Yend]</td>';\n"											Stream)
					(princ 	"		lines += '  <td width=\"19.2%\">[Lg Seg]</td>';\n"											Stream)
					(princ 	"		lines += '</tr>';\n"																		Stream)
					(princ 	"		var i;\n"																					Stream)
					(princ 	"		var ii;\n"																					Stream)
					(princ 	"		for (i = 0; i < ArrayXS_.length; i++) {\n"													Stream)
					(princ 	"			ii=i+1;\n" 																				Stream)
					(princ 	"			lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"' + ArrayCO_[i] + '\">';\n"	Stream)
					(princ 	"			lines += '  <td width=\"4%\" class=\"btn\">' + 'C' + ii.toString() + '</td>';\n"		Stream)
					(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayXS_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayYS_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayYE_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayYE_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayLS_[i] + '</td>';\n"				Stream)
					(princ 	"			lines += '</tr>';\n"																	Stream)
					(princ 	"		}\n"																						Stream)
					(princ 	"		lines += '	</table>';\n"																	Stream)
					(princ 	"		lines += '</div>';\n"																		Stream)
					(princ 	"		lines += '</body></html>';\n"																Stream)
				)
			)

			(princ 	"		if (!WndShape){\n"																			Stream)
			(princ 	"			WndShape = window.open(\"\",\"\",\"resizable=yes,width=750,height=500,left=50,top=50,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"			WndShape.document.write(lines);\n"														Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"			if (WndShape.closed) {\n"																Stream)
			(princ 	"				WndShape = window.open(\"\",\"\",\"resizable=yes,width=750,height=500,left=50,top=50,menubar=no,toolbar=no,loacation=no\");\n" Stream)
			(princ 	"				WndShape.document.write(lines);\n"													Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"				WndShape.close();\n"																Stream)
			(princ 	"				WndShape = window.open(\"\",\"\",\"resizable=yes,width=750,height=500,left=50,top=50,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"				WndShape.document.write(lines);\n"													Stream)
			(princ 	"			}\n"																					Stream)
			(princ 	"		}\n"																						Stream)
			(princ 	" 	}\n"																								Stream)
		)
	)
)
;
;
;
(defun PrintCoordinateInternalShapeTableDstvFunction (LstShape LstInShape Stream / 	Swap DataArco 
																					Xmax Xmin Ymax Ymin UcsLocal conta TypShape itm LstColor Var
																					PtStart PtEnd LgSeg PtCenter Radius Color1 Color2 fuzztable Num)
	
	;(763.5 0.0 0.0) 		(963.5 0.0 0.0) 	(1183.5 500.0 0.0) 		(1183.5 1040.0 0.0) 
	;(983.5 1540.0 0.0) 	(743.5 1540.0 0.0) 	(565.0 1077.5 -100.0) 
	;(501.5 1030.0 0.0) 	(0.0 910.0 0.0) 	(0.0 630.0 0.0) 
	;(515.0 507.0 -100.0) 	(564.0 478.5 0.0) 	(763.5 0.0 0.0))


	(setq Color1 "#EDEDED")
	(setq Color2 "#DBDBDB")
	(setq fuzztable 2)
	;
	;
	;
	(defun Swap (DatoA DatoB Indice / Rtn)
	
		(if (> (- (/ Indice 2.0) (fix (/ Indice 2.0))) 0)
			(setq Rtn DatoB)
			(setq Rtn DatoA)
		)
	)
	;
	;
	;
	(defun DataArco (p1 p2 ra / corda freccia residuo px pout alfa_ini alfa_fin out alfa_interno fs)
		
		(setq p1co p1 p2co p2 raco ra)

		(setq corda (distance p1 p2))
		(if (> (abs (- (/ corda 2.0) (abs ra))) 1e-02)
			(progn
				(setq freccia (- (abs ra) (sqrt (- (* ra ra)  (/ (* corda corda) 4.0)))))
				(setq residuo (- (abs ra) freccia))
				(setq px (nth 0 (div (nth 0 p1) (nth 1 p1)
									 (nth 0 p2) (nth 1 p2)
									 1
								)
						)
				)
				(if (> ra 0)
					(setq pout (per (nth 0 p1) (nth 1 p1)
									(nth 0 px) (nth 1 px)
									residuo
								)
					)
					(setq pout (per (nth 0 p1) (nth 1 p1)
									(nth 0 px) (nth 1 px)
									(* residuo -1.0)
								)
					)
				)
			)
			(progn
				(setq pout (nth 0 (div (nth 0 p1) (nth 1 p1)
									   (nth 0 p2) (nth 1 p2)
										1
								  )
						   )
						   freccia (abs ra)
				)
			)
		)      
		(if (> ra 0)
			(progn
				(setq alfa_ini (angle pout p1))
				(setq alfa_fin (angle pout p2))
			)
			(progn
				(setq alfa_ini (angle pout p2))
				(setq alfa_fin (angle pout p1))
			)
		)
		(setq fs (/ freccia (/ corda 2.0)))
		(if (< ra 0)
			(setq fs (* fs -1.0))
		)
		(list (list (nth 0 pout) (nth 1 pout)) alfa_ini alfa_fin ra	fs)
	)
	;
	;
	;
	(defun DeltaAng (AngIni AngFin / Rtn)
		(if (and AngIni AngFin)
			(progn
				(setq Rtn (- AngFin AngIni))
				(cond
					((= Rtn 0)
						(setq Rtn 0.0)
					)
					((< Rtn 0)
						(setq Rtn (+ (* Pi 2.0) Rtn))
					)
				)
			)
		)
		Rtn
	)
	;
	; MAIN
	;
	(setq Num 0)
	(if (and LstShape LstInShape Stream)
		(progn
						
			(setq LstPointShape (car (DiscretizeDstvShape LstShape)))
			
			(setq Xmin 		(apply 'min (mapcar 'car LstPointShape)))
			(setq Xmax 		(apply 'max (mapcar 'car LstPointShape)))
			(setq Ymin 		(apply 'min (mapcar 'cadr LstPointShape)))
			(setq Ymax 		(apply 'max (mapcar 'cadr LstPointShape)))
														
			(setq UcsLocal		(DefPiano 	Xmin Ymin 0.0
											Xmax Ymin 0.0
											Xmin Ymax 0.0))
			(foreach itm  LstInShape							
				
				(setq conta 0)
				(setq TypShape 1)
				(setq PtStart 	nil)
				(setq PtEnd 	nil)
				(setq LgSeg 	nil)
				(setq LstColor 	nil)
				(setq PtCenter 	nil)
				(setq Radius 	nil)
			
				(repeat (- (length itm) 1)
			
					(setq p1 (nth (+ conta 0) itm))
					(setq p2 (nth (+ conta 1) itm))
				
					(setq Var 		(transl (nth 0 p1) (nth 1 p1) 0.0 UcsLocal))
					(setq PtStart 	(append PtStart (list (list (LM:rtos (nth 0 var) 2 fuzztable) (LM:rtos  (nth 1 var) 2 fuzztable)))))
				
					(setq Var 		(transl (nth 0 p2) (nth 1 p2) 0.0 UcsLocal))
					(setq PtEnd   	(append PtEnd   (list (list (LM:rtos (nth 0 var) 2 fuzztable) (LM:rtos  (nth 1 var) 2 fuzztable)))))
				
				
					(if (/= (nth 2 p1) 0)
						(progn
							(setq TypShape 2)
							(setq InfoArco (DataArco (list (nth 0 p1) (nth 1 p1))
													 (list (nth 0 p2) (nth 1 p2))
													 (nth 2 p1)))
						
							(setq LgSeg	(append LgSeg 	(list (LM:rtos (abs (* (nth 2 p1) (DeltaAng (nth 1 InfoArco) (nth 2 InfoArco)))) 2 fuzztable))))
						
							(setq PtCenter 	(append PtCenter (list (list (LM:rtos (nth 0 (nth 0 InfoArco )) 2 fuzztable) 
																		 (LM:rtos (nth 1 (nth 0 InfoArco )) 2 fuzztable)
																	))))
							(setq Radius 	(append Radius (list (LM:rtos (abs (nth 2 p1)) 2 fuzztable))))
						)
						(progn
							(setq LgSeg		(append LgSeg	(list (LM:rtos (distance (list (nth 0 p1) (nth 1 p1)) (list (nth 0 p2) (nth 1 p2))) 2 fuzztable))))
							(setq PtCenter 	(append PtCenter (list (list "-" "-"))))
							(setq Radius 	(append Radius (list "-")))
						)
					)

					(setq LstColor 	(append LstColor (list (Swap Color1 Color2 Conta))))
					(setq conta (1+ conta))
				)
				
				(if (= Num 0)
					(progn
						(princ 	"	function CoordinateInternalShapeTable() {\n" 															Stream)
						(princ 	"		// Info Coordinate Shape dinamic input Java ++++++++++++++++\n" 									Stream)
						(princ 	"		var lines = '<!doctype html>';\n"																	Stream)
						(princ 	"		var i;\n"																							Stream)
						(princ 	"		var ii = 0;\n"																						Stream)
						(princ 	"		lines += '<!doctype html>';\n"																		Stream)
						(princ 	"		lines += '<html><head>';\n"																			Stream)
						(princ 	"		lines += '<meta charset=\"appropriate charset here\">';\n"											Stream)
						(princ 	"		lines += '<title>Info Shape</title>';\n"															Stream)
						(princ 	"		lines += '<style>';\n"																				Stream)
						(princ 	"		lines += '.btn {color:black;transition:0.3s;}';\n"													Stream)
						(princ 	"		lines += '.btn:hover {background-color: #3e8e41;color: white;}';\n"									Stream)
						(princ 	"		lines += '.infoshape {font-size:15px;width:auto;height:auto;margin:10px;font-family:Arial;}';\n" 	Stream)
						(princ 	"		lines += '</style>';\n"																				Stream)
						(princ 	"		lines += '</head><body>';\n"																		Stream)
						(princ 	"		lines += '<div class=\"infoshape\">';\n"															Stream)
						(princ  "		lines += '<button onclick=\"window.print()\">Stampa</button>';\n"									Stream)
						(princ 	"		lines += '</br>';\n"																				Stream)
						(princ 	"		lines += '</br>';\n"																				Stream)
						(setq Num (1+ Num))
					)
				)
			
				; ---------------------------------------------------------------------------------
				(PrintArrayJava (mapcar 'car PtStart)  "		var ArrayXS_"  0 Stream)
				(PrintArrayJava (mapcar 'cadr PtStart) "		var ArrayYS_"  0 Stream)
				(PrintArrayJava (mapcar 'car PtEnd)    "		var ArrayXE_"  0 Stream)
				(PrintArrayJava (mapcar 'cadr PtEnd)   "		var ArrayYE_"  0 Stream)
				(PrintArrayJava LgSeg   			   "		var ArrayLS_"  0 Stream)
				(PrintArrayJava LstColor   			   "		var ArrayCO_"  0 Stream)
				; ---------------------------------------------------------------------------------

				(if (= TypShape 2) ; contorno con raccordi
					(progn
						(PrintArrayJava (mapcar 'car PtCenter)    "		var ArrayXC_"  0 Stream)
						(PrintArrayJava (mapcar 'cadr PtCenter)   "		var ArrayYC_"  0 Stream)
						(PrintArrayJava Radius    "		var ArrayRA_"  0 Stream)
					)
				)
				
				(cond
					((= TypShape 2)
			
						;	ArrayXS_	ArrayYS_	ArrayXE_	ArrayYE_	ArrayLS_	ArrayXC_	ArrayYC_	ArrayRA_	ArrayCO_
				
						(princ 	"		lines += '<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">';\n"		Stream)
						(princ 	"		lines += '<tr height=\"25px\" align=\"center\">';\n"										Stream)
						(princ 	"		lines += '  <td width=\"4%\">Itm</td>';\n"													Stream)
						(princ 	"		lines += '  <td width=\"12%\">[Xstart]</td>';\n"											Stream)
						(princ 	"		lines += '  <td width=\"12%\">[Ystart]</td>';\n"											Stream)
						(princ 	"		lines += '  <td width=\"12%\">[Xend]</td>';\n"												Stream)
						(princ 	"		lines += '  <td width=\"12%\">[Yend]</td>';\n"												Stream)
						(princ 	"		lines += '  <td width=\"12%\">[Lg Seg]</td>';\n"											Stream)
						(princ 	"		lines += '  <td width=\"12%\">[Xcenter]</td>';\n"											Stream)
						(princ 	"		lines += '  <td width=\"12%\">[Ycenter]</td>';\n"											Stream)
						(princ 	"		lines += '  <td width=\"12%\">[Radius]</td>';\n"											Stream)
						(princ 	"		lines += '</tr>';\n"																		Stream)
						(princ 	"		for (i = 0; i < ArrayXS_.length; i++) {\n"													Stream)
						(princ 	"			ii=ii+1;\n"																				Stream)
						(princ 	"			lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"' + ArrayCO_[i] + '\">';\n"	Stream)
						(princ 	"			lines += '  <td width=\"4%\" class=\"btn\">' + 'I' + ii.toString() + '</td>';\n"		Stream)
						(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayXS_[i] + '</td>';\n"				Stream)
						(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayYS_[i] + '</td>';\n"				Stream)
						(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayXE_[i] + '</td>';\n"				Stream)
						(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayYE_[i] + '</td>';\n"				Stream)
						(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayLS_[i] + '</td>';\n"				Stream)
						(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayXC_[i] + '</td>';\n"				Stream)
						(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayYC_[i] + '</td>';\n"				Stream)
						(princ 	"			lines += '  <td width=\"12%\" class=\"btn\">' + ArrayRA_[i] + '</td>';\n"				Stream)
						(princ 	"		}\n"																						Stream)
						(princ 	"		lines += '</table>';\n"																		Stream)
						(princ 	"		lines += '</br>';\n"																		Stream)
					)
					((= TypShape 1)
			
						;	ArrayXS_	ArrayYS_	ArrayXE_	ArrayYE_	ArrayLS_	ArrayCO_
				
						(princ 	"		lines += '<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">';\n"		Stream)
						(princ 	"		lines += '<tr height=\"25px\" align=\"center\">';\n"										Stream)
						(princ 	"		lines += '  <td width=\"4%\">Itm</td>';\n"													Stream)
						(princ 	"		lines += '  <td width=\"19.2%\">[Xstart]</td>';\n"											Stream)
						(princ 	"		lines += '  <td width=\"19.2%\">[Ystart]</td>';\n"											Stream)
						(princ 	"		lines += '  <td width=\"19.2%\">[Xend]</td>';\n"											Stream)
						(princ 	"		lines += '  <td width=\"19.2%\">[Yend]</td>';\n"											Stream)
						(princ 	"		lines += '  <td width=\"19.2%\">[Lg Seg]</td>';\n"											Stream)
						(princ 	"		lines += '</tr>';\n"																		Stream)
						(princ 	"		for (i = 0; i < ArrayXS_.length; i++) {\n"													Stream)
						(princ 	"			ii=ii+1;\n" 																			Stream)
						(princ 	"			lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"' + ArrayCO_[i] + '\">';\n"	Stream)
						(princ 	"			lines += '  <td width=\"4%\" class=\"btn\">' + 'I' + ii.toString() + '</td>';\n"		Stream)
						(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayXS_[i] + '</td>';\n"				Stream)
						(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayYS_[i] + '</td>';\n"				Stream)
						(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayYE_[i] + '</td>';\n"				Stream)
						(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayYE_[i] + '</td>';\n"				Stream)
						(princ 	"			lines += '  <td width=\"19.2%\" class=\"btn\">' + ArrayLS_[i] + '</td>';\n"				Stream)
						(princ 	"			lines += '</tr>';\n"																	Stream)
						(princ 	"		}\n"																						Stream)
						(princ 	"		lines += '	</table>';\n"																	Stream)
						(princ 	"		lines += '</br>';\n"																		Stream)
					)
				)
			)
			(princ 	"		if (!WndShape){\n"																			Stream)
			(princ 	"			WndShape = window.open(\"\",\"\",\"resizable=yes,width=750,height=500,left=50,top=50,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"			WndShape.document.write(lines);\n"														Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"			if (WndShape.closed) {\n"																Stream)
			(princ 	"				WndShape = window.open(\"\",\"\",\"resizable=yes,width=750,height=500,left=50,top=50,menubar=no,toolbar=no,loacation=no\");\n" Stream)
			(princ 	"				WndShape.document.write(lines);\n"													Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"				WndShape.close();\n"																Stream)
			(princ 	"				WndShape = window.open(\"\",\"\",\"resizable=yes,width=750,height=500,left=50,top=50,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"				WndShape.document.write(lines);\n"													Stream)
			(princ 	"			}\n"																					Stream)
			(princ 	"		}\n"																						Stream)
			(princ 	" 	}\n"																							Stream)
		)
	)
)
;
;
;
(defun PrintInfoShapeTableDstvFunction (LstHead Stream /	Swap Color1 Color2 fuzztable LstInfoShape LstColor DataShape 
															Xmin Ymin Xmax Ymax Width Height Weight JouShape CompShape itm conta)

	(setq Color1 "#EDEDED")
	(setq Color2 "#DBDBDB")
	(setq fuzztable 2)
	;
	;
	;
	(defun Swap (DatoA DatoB Indice / Rtn)
	
		(if (> (- (/ Indice 2.0) (fix (/ Indice 2.0))) 0)
			(setq Rtn DatoB)
			(setq Rtn DatoA)
		)
	)
	;
	;
	;
	;(nth 0  LstHead) ->  IdOrder          	"C8722
	;(nth 1  LstHead) ->  IdDrawing         "171-110"
	;(nth 2  LstHead) ->  IdPhase        	"100"
	;(nth 3  LstHead) ->  IdIdentification 	"011124"
	;(nth 4  LstHead) ->  IdQuality        	"S355J2"
	;(nth 5  LstHead) ->  IdQuantity        "1"
	;(nth 6  LstHead) ->  IdProfile         "PL1540*15"
	;(nth 7  LstHead) ->  IdCode            "B"
	;(nth 8  LstHead) ->  IdLength          "1183.50
	;(nth 9  LstHead) ->  IdHeigth          "1540.00"
	;(nth 10 LstHead) ->  IdThicknes        "15.00"
	;(nth 11 LstHead) ->  IdWeightmt        "64.25"
	;(nth 12 LstHead) ->  IdSurface         "1.13"
	;(nth 13 LstHead) ->  IdName	        "PIATTO"
	;(nth 14 LstHead) ->  JouShape          "0" "2" "3"
	;(nth 15 LstHead) ->  TypeShape	        "CE" "CI"
	;(nth 16 LstHead) ->  CutShape          "0" "1" "2" "3"
	;(nth 17 LstHead) ->  PerimeterShape    "123.5"
	;(nth 18 LstHead) ->  Weight   			"12.5"
	;(nth 19 LstHead) ->  DateShape     	"01/12/2019"

	(if (and LstHead Stream)
		(progn
		
			(setq DataShape LstHead)
			
			(cond 	((= (nth 14	DataShape) "2") (setq JouShape "Antioraria"))
					((= (nth 14	DataShape) "3")	(setq JouShape "Oraria")))
			(cond 	((= (nth 16	DataShape) "0")	(setq CompShape "Nessuna"))
					((= (nth 16	DataShape) "1")	(setq CompShape "Automatica"))
					((= (nth 16	DataShape) "2") (setq CompShape "Destra"))
					((= (nth 16	DataShape) "3")	(setq CompShape "Sinistra")))
			
			(setq LstInfoShape 	(list	(cons "Commessa"				(nth 0 DataShape)) 	;
										(cons "Fase"					(nth 2 DataShape))	;
										(cons "Marca"					(nth 3 DataShape))	;
										(cons "Spessore"				(nth 10 DataShape))	;
										(cons "Altezza"					(nth 9 DataShape))	;
										(cons "Larghezza"				(nth 8 DataShape))	;
										(cons "Perimetro"				(nth 17 DataShape))	;
										(cons "Matriale"				(nth 4 DataShape))	;
										(cons "Peso"					(nth 18 DataShape))	;
										(cons "Tipo contorno" 			"Esterno")
										(cons "Percorrenza" 			JouShape)
										(cons "Compensazione"			CompShape)
										(cons "Tempo Taglio Esterno"	"???")
										(cons "Tempo Taglio Interno"	"???")
										(cons "Tempo Taglio Attacchi"	"???")
										(cons "Tempo Taglio Totale"		"???")
										(cons "Velocità taglio mm/min"	(LM:rtos (setq SpeedCut (GetSpeedCutByThickness (nth 10 DataShape))) 2 2))
										(cons "Ultima modifica"			(nth 19 DataShape))))
			(setq conta 0)
			(foreach itm LstInfoShape
				(setq LstColor 	(append LstColor (list (Swap Color1 Color2 Conta))))
				(setq conta (1+ conta))			
			)
										
			(princ 	"	function InfoShapeTable() {\n" 																	Stream)
			(princ 	"		// Info Shape dinamic input Java ++++++++++++++++\n" 										Stream)
			(PrintArrayJava (mapcar 'car  LstInfoShape)  "		var Array1_"  0 Stream)
			(PrintArrayJava (mapcar 'cdr  LstInfoShape)  "		var Array2_"  0 Stream)
			(PrintArrayJava LstColor  "		var Array3_"  0 Stream)

			(princ 	"		var lines = '<!doctype html>';\n"															Stream)
			(princ 	"		lines += '<!doctype html>';\n"																Stream)
			(princ 	"		lines += '<html><head>';\n"																	Stream)
			(princ 	"		lines += '<meta charset=\"appropriate charset here\">';\n"									Stream)
			(princ 	"		lines += '<title>Info Shape</title>';\n"													Stream)
			(princ 	"		lines += '<style>';\n"																		Stream)
			(princ 	"		lines += '.btn {color:black;transition:0.3s;}';\n"											Stream)
			(princ 	"		lines += '.btn:hover {background-color: #3e8e41;color: white;}';\n"							Stream)
			(princ 	"		lines += '.infoshape {font-size:15px;width:auto;height:auto;margin:10px;font-family:Arial;}';\n" Stream)
			(princ 	"		lines += '</style>';\n"																		Stream)
			(princ 	"		lines += '</head><body>';\n"																Stream)
			(princ 	"		lines += '<div class=\"infoshape\">';\n"													Stream)
			(princ  "		lines += '<button onclick=\"window.print()\">Stampa</button>';\n"							Stream)
			(princ 	"		lines += '</br>';\n"																		Stream)
			(princ 	"		lines += '</br>';\n"																		Stream)
			(princ 	"		lines += '	<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">';\n"	Stream)
			(princ 	"		var i;\n"																					Stream)
			(princ 	"		for (i = 0; i < Array1_.length; i++) {\n"													Stream)
			(princ 	"			lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"'+ Array3_[i] + '\">';\n"		Stream)
			(princ 	"			lines += '  <td width=\"50%\" class=\"btn\">' + Array1_[i] + '</td>';\n"				Stream)
			(princ 	"			lines += '  <td width=\"50%\" class=\"btn\">' + Array2_[i] + '</td>';\n"				Stream)
			(princ 	"			lines += '</tr>';\n"																	Stream)
			(princ 	"		}\n"																						Stream)
			(princ 	"		lines += '	</table>';\n"																	Stream)
			(princ 	"		lines += '</div>';\n"																		Stream)
			(princ 	"		lines += '</body></html>';\n"																Stream)
			(princ 	"		if (!WndInfo){\n"																			Stream)
			(princ 	"			WndInfo = window.open(\"\",\"\",\"resizable=yes,width=350,height=500,left=10,top=10,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"			WndInfo.document.write(lines);\n"														Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"			if (WndInfo.closed) {\n"																Stream)
			(princ 	"				WndInfo = window.open(\"\",\"\",\"resizable=yes,width=350,height=500,left=10,top=10,menubar=no,toolbar=no,loacation=no\");\n" Stream)
			(princ 	"				WndInfo.document.write(lines);\n"													Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"				WndInfo.close();\n"																	Stream)
			(princ 	"				WndInfo = window.open(\"\",\"\",\"resizable=yes,width=350,height=500,left=10,top=10,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"				WndInfo.document.write(lines);\n"													Stream)
			(princ 	"			}\n"																					Stream)
			(princ 	"		}\n"																						Stream)
			(princ 	" 	}\n"																								Stream)
		)
	)
)
;
;
;
(defun PrintCoordinateBoltsShapeTableDstvFunction (LstShape LstHole Stream / Swap Color1 Color2 fuzztable Xmin Xmax Ymin Ymax UcsLocal LstEnameInternalShape 
																			  itm Pt PtL LstColor LstPointInternalShapeLocal conta)

	(setq Color1 "#EDEDED")
	(setq Color2 "#DBDBDB")
	(setq fuzztable 2)
	;
	;
	;
	(defun Swap (DatoA DatoB Indice / Rtn)
	
		(if (> (- (/ Indice 2.0) (fix (/ Indice 2.0))) 0)
			(setq Rtn DatoB)
			(setq Rtn DatoA)
		)
	)
	;
	;
	;
	(if (and LstShape Stream)
		(progn
			;(vla-getboundingbox (vlax-ename->vla-object EnameShape) 'mnl 'mxl)
			;(setq Pmin 			(vlax-safearray->list mnl))
			;(setq Pmax 			(vlax-safearray->list mxl))
			
			(setq LstPointShape (car (DiscretizeDstvShape LstShape)))
			
			(setq Xmin 		(apply 'min (mapcar 'car LstPointShape)))
			(setq Xmax 		(apply 'max (mapcar 'car LstPointShape)))
			(setq Ymin 		(apply 'min (mapcar 'cadr LstPointShape)))
			(setq Ymax 		(apply 'max (mapcar 'cadr LstPointShape)))
			
			;(setq UcsLocal		(DefPiano 	(nth 0 Pmin) (nth 1 Pmin) 0.0
			;								(nth 0 Pmax) (nth 1 Pmin) 0.0
			;								(nth 0 Pmin) (nth 1 Pmax) 0.0))

			(setq UcsLocal		(DefPiano 	Xmin Ymin 0.0
											Xmax Ymin 0.0
											Xmin Ymax 0.0))			
			
			(setq conta 0)
			(foreach itm LstHole
				(setq PtL (transl (nth 0 itm) (nth 1 itm) 0.0 UcsLocal))
				(setq LstPointInternalShapeLocal (append LstPointInternalShapeLocal
															(list (list (LM:rtos (nth 0 PtL) 2 fuzztable)
																		(LM:rtos (nth 1 PtL) 2 fuzztable)
																		(LM:rtos (nth 2 itm) 2 fuzztable)))))
				(setq LstColor 	(append LstColor (list (Swap Color1 Color2 Conta))))
				(setq conta (1+ conta))
			)
			
			
			(princ 	"	function CoordinateBoltsTable() {\n" 															Stream)
			(princ 	"		// Info Coordinate Bolts dinamic input Java ++++++++++++++++\n" 							Stream)
			(PrintArrayJava (mapcar 'car   LstPointInternalShapeLocal)  "		var ArrayX_"  0 Stream)
			(PrintArrayJava (mapcar 'cadr  LstPointInternalShapeLocal)  "		var ArrayY_"  0 Stream)
			(PrintArrayJava (mapcar 'caddr LstPointInternalShapeLocal)  "		var ArrayD_"  0 Stream)
			(PrintArrayJava LstColor  "		var ArrayC_"  fuzztable Stream)

			(princ 	"		var lines = '<!doctype html>';\n"															Stream)
			(princ 	"		lines += '<!doctype html>';\n"																Stream)
			(princ 	"		lines += '<html><head>';\n"																	Stream)
			(princ 	"		lines += '<meta charset=\"appropriate charset here\">';\n"									Stream)
			(princ 	"		lines += '<title>Info Shape</title>';\n"													Stream)
			(princ 	"		lines += '<style>';\n"																		Stream)
			(princ 	"		lines += '.btn {color:black;transition:0.3s;}';\n"											Stream)
			(princ 	"		lines += '.btn:hover {background-color: #3e8e41;color: white;}';\n"							Stream)
			(princ 	"		lines += '.infoshape {font-size:15px;width:auto;height:auto;margin:10px;font-family:Arial;}';\n" Stream)
			(princ 	"		lines += '</style>';\n"																		Stream)
			(princ 	"		lines += '</head><body>';\n"																Stream)
			(princ 	"		lines += '<div class=\"infoshape\">';\n"													Stream)
			(princ  "		lines += '<button onclick=\"window.print()\">Stampa</button>';\n"							Stream)
			(princ 	"		lines += '</br>';\n"																		Stream)
			(princ 	"		lines += '</br>';\n"																		Stream)
			(princ 	"		lines += '<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">';\n"		Stream)
			(princ 	"		lines += '<tr height=\"25px\" align=\"center\">';\n"										Stream)
			(princ 	"		lines += '  <td width=\"19%\">Itm</td>';\n"													Stream)
			(princ 	"		lines += '  <td width=\"27%\">[X]</td>';\n"													Stream)
			(princ 	"		lines += '  <td width=\"27%\">[Y]</td>';\n"													Stream)
			(princ 	"		lines += '  <td width=\"27%\">[D]</td>';\n"													Stream)
			(princ 	"		lines += '</tr>';\n"																		Stream)
			(princ 	"		var i;\n"																					Stream)
			(princ 	"		var ii;\n"																					Stream)
			(princ 	"		for (i = 0; i < ArrayX_.length; i++) {\n"													Stream)
			(princ 	"			ii=i+1;\n" 																				Stream)
			(princ 	"			lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"' + ArrayC_[i] + '\">';\n"		Stream)
			(princ 	"			lines += '  <td width=\"19%\" class=\"btn\">' + 'B' + ii.toString() + '</td>';\n"		Stream)
			(princ 	"			lines += '  <td width=\"27%\" class=\"btn\">' + ArrayX_[i] + '</td>';\n"				Stream)
			(princ 	"			lines += '  <td width=\"27%\" class=\"btn\">' + ArrayY_[i] + '</td>';\n"				Stream)
			(princ 	"			lines += '  <td width=\"27%\" class=\"btn\">' + ArrayD_[i] + '</td>';\n"				Stream)
			(princ 	"			lines += '</tr>';\n"																	Stream)
			(princ 	"		}\n"																						Stream)
			(princ 	"		lines += '	</table>';\n"																	Stream)
			(princ 	"		lines += '</div>';\n"																		Stream)
			(princ 	"		lines += '</body></html>';\n"																Stream)
			(princ 	"		if (!WndBolts){\n"																			Stream)
			(princ 	"			WndBolts = window.open(\"\",\"\",\"resizable=yes,width=350,height=500,left=90,top=90,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"			WndBolts.document.write(lines);\n"														Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"			if (WndBolts.closed) {\n"																Stream)
			(princ 	"				WndBolts = window.open(\"\",\"\",\"resizable=yes,width=350,height=500,left=90,top=90,menubar=no,toolbar=no,loacation=no\");\n" Stream)
			(princ 	"				WndBolts.document.write(lines);\n"													Stream)
			(princ 	"			} else {\n"																				Stream)
			(princ 	"				WndBolts.close();\n"																Stream)
			(princ 	"				WndBolts = window.open(\"\",\"\",\"resizable=yes,width=350,height=500,left=90,top=90,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"				WndBolts.document.write(lines);\n"													Stream)
			(princ 	"			}\n"																					Stream)
			(princ 	"		}\n"																						Stream)
			(princ 	" 	}\n"																								Stream)
		)
	)
)
;
;
;
(defun PrintDrawShapeDstvFunction (LstHead LstShape LstHole LstInShape Stream /  	PosIndexTextShape
																		ScaleWidthPannedDisplay ScaleHeightPannedDisplay Margin ColorExternalShape
																		 ColorFillExternalShape ColorBolts ColorFillBoltsShape ColorBkgCanvas
																		 ColorTextBolts ColorTextShape TexPxBolts TexPxShape StyleTextBolts
																		 StyleTextShape fuzz itm itm1 Pt conta
																		 Width Height Xmin Xmax Ymin Ymax Scale DDx DDy LstPointShape UcsCanvas PointIndexShape
																		 LstPointNoDiscretizeShapeCanva LstPointExternalShapeCanvas LstEnameInternalShape
																		 LstPointHoleShapeCanvas LstPointNoDiscretizeShapeCanvas
																		 LstPtTmp LstPointInternalShapeCanvas ColorInternalShape ColorFillInternalShape
																		 LstPointNoDiscretizeInternalShapeCanvas)

	(setq ScaleWidthPannedDisplay 	140.0)
	(setq ScaleHeightPannedDisplay 	100.0)
	(setq Margin				 	10.0)
	
	(setq ColorExternalShape 		"Black")
	(setq ColorFillExternalShape 	"#d8dfcb")
	
	(setq ColorBolts 				"Black")
	(setq ColorFillBoltsShape 		"White")
	
	(setq ColorInternalShape 		"Black")
	(setq ColorFillInternalShape	"White")
	
	(setq ColorBkgCanvas	 		"White")
	(setq ColorTextBolts			"Black")
	(setq ColorTextShape			"Black")
	(setq TexPxBolts				"2")
	(setq TexPxShape				"2")
	(setq StyleTextBolts 			"Verdana")
	(setq StyleTextShape 			"Verdana")
	(setq fuzz 3)


	;(nth 0  LstHead) ->  IdOrder          	"C8722
	;(nth 1  LstHead) ->  IdDrawing         "171-110"
	;(nth 2  LstHead) ->  IdPhase        	"100"
	;(nth 3  LstHead) ->  IdIdentification 	"011124"
	;(nth 4  LstHead) ->  IdQuality        	"S355J2"
	;(nth 5  LstHead) ->  IdQuantity        "1"
	;(nth 6  LstHead) ->  IdProfile         "PL1540*15"
	;(nth 7  LstHead) ->  IdCode            "B"
	;(nth 8  LstHead) ->  IdLength          "1183.50
	;(nth 9  LstHead) ->  IdHeigth          "1540.00"
	;(nth 10 LstHead) ->  IdThicknes        "15.00"
	;(nth 11 LstHead) ->  IdWeightmt        "64.25"
	;(nth 12 LstHead) ->  IdSurface         "1.13"
	;(nth 13 LstHead) ->  IdName	        "PIATTO"
	;(nth 14 LstHead) ->  JouShape          "0" "2" "3"
	;(nth 15 LstHead) ->  TypeShape	        "CE" "CI"
	;(nth 16 LstHead) ->  CutShape          "0" "1" "2" "3"
	;(nth 17 LstHead) ->  PerimeterShape    "123.5"
	;(nth 18 LstHead) ->  Weight   			"12.5"
	;(nth 19 LstHead) ->  DateShape     	"01/12/2019"

	;
	;
	;
	(defun PosIndexTextShape (LstHead LstPoint / Margin Width Height maxdim conta LstPoint p1 p2 p3 pa pb pc pd Rtn)
		
		(if (and LstHead LstPoint)
			(progn
				
				(if (equal 	(list	(car (nth 0 LstPoint)) 							(cadr (nth 0 LstPoint)))
							(list 	(car (nth (- (length LstPoint) 1) LstPoint)) 	(cadr (nth (- (length LstPoint) 1) LstPoint)))
					0.1)
					(setq LstPoint (LM:RemoveNth  (- (length LstPoint) 1) LstPoint ))
				)
				
				(setq conta 0)
				(setq Width   		(atof (nth 8 LstHead)))
				(setq Height  		(atof (nth 9 LstHead)))
				(setq maxdim 		(max Width Height))
				
				(cond 
					((and (> maxdim 0) 		(<= maxdim 100)) 		(setq Margin 2))
					((and (> maxdim 100) 	(<= maxdim 500)) 		(setq Margin 5))
					((and (> maxdim 500) 	(<= maxdim 1000)) 		(setq Margin 10))
					((and (> maxdim 500) 	(<= maxdim 1000)) 		(setq Margin 15))
					((and (> maxdim 1000) 	(<= maxdim 2000)) 		(setq Margin 25))
					((and (> maxdim 2000) 	(<= maxdim 5000)) 		(setq Margin 50))
					((and (> maxdim 5000) 	(<= maxdim 7000)) 		(setq Margin 80))
					((and (> maxdim 7000) 	(<= maxdim 10000)) 		(setq Margin 100))
					(t 												(setq Margin 200))
				)
				
			
				(repeat (length LstPoint)
					(cond
						((= conta 0)
							
							(setq p1 (nth (- (length LstPoint) 1) LstPoint))
							(setq p2 (nth 0 LstPoint))
							(setq p3 (nth (1+ conta) LstPoint))
						)
						((< conta (- (length LstPoint) 1))
							
							(setq p1 (nth (1- conta) LstPoint))
							(setq p2 (nth conta LstPoint))
							(setq p3 (nth (1+ conta) LstPoint))
						)
						((= conta (- (length LstPoint) 1))
							
							(setq p1 (nth (1- conta) LstPoint))
							(setq p2 (nth conta LstPoint))
							(setq p3 (nth 0 LstPoint))
						)
					)
					(setq conta (1+ conta))
										
					(setq pa (prol (nth 0 p1) (nth 1 p1) (nth 0 p2) (nth 1 p2) -1000.0))
					(setq pb (prol (nth 0 p3) (nth 1 p3) (nth 0 p2) (nth 1 p2) -1000.0))
					(setq pc (nth 0 (div  (nth 0 pa) (nth 1 pa) (nth 0 pb) (nth 1 pb) 1)))
					
					(setq pd (prol (nth 0 pc) (nth 1 pc) (nth 0 p2) (nth 1 p2) 1.0))
					;(if (LM:PointInside-p pd EnameShape nil)
					;	(setq pd (prol (nth 0 pc) (nth 1 pc) (nth 0 p2) (nth 1 p2) -1.0))
					;)
					(setq pd (prol (nth 0 pd) (nth 1 pd) (nth 0 p2) (nth 1 p2) (* -1.0 Margin)))
					(setq Rtn (append Rtn (list pd)))
				)
			)
		)
		Rtn
	)
	;
	;
	;
	(if (and LstHead LstShape Stream)
		(progn

			(setq LstPointShape (car (DiscretizeDstvShape LstShape)))
			;(getstring "")
			;(princ LstPointShape)
			;(getstring "")
			(setq Xmin 		(apply 'min (mapcar 'car LstPointShape)))
			(setq Xmax 		(apply 'max (mapcar 'car LstPointShape)))
			(setq Ymin 		(apply 'min (mapcar 'cadr LstPointShape)))
			(setq Ymax 		(apply 'max (mapcar 'cadr LstPointShape)))
			(setq Width		(abs (- Xmax Xmin))) 
			(setq Height  	(abs (- Ymax Ymin)))
			
			(setq Scale 		(max (/ Width  (- ScaleWidthPannedDisplay  Margin))
									 (/ Height (- ScaleHeightPannedDisplay Margin))))
						
			(setq DDx (/ (- ScaleWidthPannedDisplay  (/ Width Scale)) 2.0))
			(setq DDy (/ (- ScaleHeightPannedDisplay (/ Height Scale)) 2.0))
			
			;(setq UcsCanvas		(DefPiano 	(nth 0 Pmin) (nth 1 Pmax) 0.0
			;								(nth 0 Pmax) (nth 1 Pmax) 0.0
			;								(nth 0 Pmin) (nth 1 Pmin) 0.0))
			(setq UcsCanvas		(DefPiano 	Xmin Ymax 0.0
											Xmax Ymax 0.0
											Xmin Ymin 0.0))
			

			(setq PointIndexShape 	(PosIndexTextShape LstHead LstShape))
			;------------------------------------------------------------------------------------------------------------------------							
			(foreach itm PointIndexShape
				(setq Pt (transl (nth 0 itm) (nth 1 itm) 0.0 UcsCanvas))
				(setq LstPointNoDiscretizeShapeCanvas (append LstPointNoDiscretizeShapeCanvas
																	(list (list (+ DDx (/ (nth 0 Pt) Scale))
																				(+ DDy (/ (nth 1 Pt) Scale))))))
			)
			;------------------------------------------------------------------------------------------------------------------------						
			(foreach itm LstPointShape
				(setq Pt (transl (nth 0 itm) (nth 1 itm) 0.0 UcsCanvas))
				(setq LstPointExternalShapeCanvas (append LstPointExternalShapeCanvas (list (list (+ DDx (/ (nth 0 Pt) Scale)) 
																								  (+ DDy (/ (nth 1 Pt) Scale))))))
			)
			;------------------------------------------------------------------------------------------------------------------------	
			(foreach itm LstInShape
				(setq LstPtTmp nil)
				(foreach itm1  (car (DiscretizeDstvShape itm))
					(setq Pt (transl (nth 0 itm1) (nth 1 itm1) 0.0 UcsCanvas))
					(setq LstPtTmp (append LstPtTmp (list	(list 	(+ DDx (/ (nth 0 Pt) Scale))
																	(+ DDy (/ (nth 1 Pt) Scale))))))
																	
				)
				(setq LstPointInternalShapeCanvas (append LstPointInternalShapeCanvas (list LstPtTmp)))
			)
			;------------------------------------------------------------------------------------------------------------------------						
			(foreach itm LstInShape
				(foreach itm1 (PosIndexTextShape LstHead itm)
					(setq Pt (transl (nth 0 itm1) (nth 1 itm1) 0.0 UcsCanvas))
					(setq LstPointNoDiscretizeInternalShapeCanvas 
							(append LstPointNoDiscretizeInternalShapeCanvas (list (list (+ DDx (/ (nth 0 Pt) Scale)) 
																						(+ DDy (/ (nth 1 Pt) Scale))))))
				)
			)
			;------------------------------------------------------------------------------------------------------------------------						
			(foreach itm LstHole
				(setq Pt (transl (nth 0 itm) (nth 1 itm) 0.0 UcsCanvas))
				(setq LstPointHoleShapeCanvas (append LstPointHoleShapeCanvas (list	(list 	(+ DDx (/ (nth 0 Pt) Scale))
																							(+ DDy (/ (nth 1 Pt) Scale))
																							(/ (/ (nth 2 itm) 2.0) Scale)))))
			)
			;------------------------------------------------------------------------------------------------------------------------						
			(princ "	function draw() {\n" 																						Stream)
			(princ (strcat "		var ColorBkgCanvas= \""     	ColorBkgCanvas "\";\n")											Stream)
			(princ (strcat "		var ColorExternalShape= \""     ColorExternalShape "\";\n")										Stream)
			(princ (strcat "		var ColorFillExternalShape= \"" ColorFillExternalShape "\";\n")									Stream)
			(princ (strcat "		var ColorInternalShape= \""     ColorInternalShape "\";\n")										Stream)
			(princ (strcat "		var ColorFillInternalShape= \"" ColorFillInternalShape "\";\n")									Stream)
			
			(princ "		ctx.setTransform(1,0,0,1,0,0);\n" 																		Stream)
			(princ "		ctx.scale(widthCanvas/widthView, heightCanvas/heightView);\n" 											Stream)
			(princ "		ctx.translate(-xleftView,-ytopView);\n" 																Stream)
			(princ "		ctx.fillStyle = ColorBkgCanvas;\n" 																		Stream)
			(princ "		ctx.fillRect(xleftView,ytopView, widthView,heightView);\n" 												Stream)
			(princ "		ctx.lineWidth = 1.0 / (widthCanvas/widthView);\n" 														Stream)
			(princ "		ctx.strokeStyle=ColorExternalShape; ctx.beginPath();\n"	 												Stream)
			(princ "		// Shape dinamic input Java ++++++++++++++++\n"	 														Stream)					
			;
			; Graphics Shape +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(PrintArrayJava (mapcar 'car  LstPointExternalShapeCanvas)  "		var ArrayX_"  fuzz Stream)
			(PrintArrayJava (mapcar 'cadr LstPointExternalShapeCanvas)  "		var ArrayY_"  fuzz Stream)

			(princ	"		var i;\n"																								Stream)
			(princ	"		for (i = 0; i < ArrayX_.length; i++) { \n"																Stream)
			(princ	"			if (i==0) {\n"																						Stream)
			(princ	"				ctx.moveTo(ArrayX_[i],ArrayY_[i]);\n"															Stream)
			(princ	"			} else {\n"																							Stream)
			(princ	"				ctx.lineTo(ArrayX_[i],ArrayY_[i]);\n"															Stream)
			(princ	"			}\n"																								Stream)										
			(princ	"		}\n"																									Stream)
			(princ	"		ctx.closePath();\n"																						Stream)
			(princ	"		ctx.fillStyle =ColorFillExternalShape;\n"																Stream)
			(princ	"		ctx.fill();\n"																							Stream)
			(princ	"		ctx.stroke();\n"																						Stream)
			;
			; Graphics Bolts +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(if LstPointHoleShapeCanvas
				(progn
					(PrintArrayJava (mapcar 'car   LstPointHoleShapeCanvas)  "		var ArrayX_"  fuzz Stream)
					(PrintArrayJava (mapcar 'cadr  LstPointHoleShapeCanvas)  "		var ArrayY_"  fuzz Stream)
					(PrintArrayJava (mapcar 'caddr LstPointHoleShapeCanvas)  "		var ArrayD_"  fuzz Stream)

					(princ (strcat "		var ColorBolts=\"" ColorBolts "\";\n") 															Stream)
					(princ (strcat "		var ColorFillBolts=\"" ColorFillBoltsShape "\";\n")												Stream)
					(princ	"		var i;\n" 																								Stream)
					(princ	"		for (i = 0; i < ArrayX_.length; i++) {\n" 																Stream)
					(princ	"			ctx.lineWidth = 1.0 / (widthCanvas/widthView);\n" 													Stream)
					(princ	"			ctx.strokeStyle=ColorBolts;\n" 																		Stream)
					(princ	"			ctx.beginPath();\n" 																				Stream)
					(princ	"			ctx.arc(ArrayX_[i],ArrayY_[i],ArrayD_[i],0.0,2*Math.PI);ctx.fillStyle=ColorFillBolts;\n"			Stream)
					(princ	"			ctx.fill();\n" 																						Stream)
					(princ	"			ctx.stroke();\n" 																					Stream)
					(princ	"		}\n" 																									Stream)
					(princ 	"		// Index Bolts input Java ++++++++++++++++;\n"															Stream)
					(princ 	"		if (FlagBolts==1) {\n"																					Stream)
					(princ	"			var ii;\n" 																							Stream)
					(princ	(strcat "			var Htext=" TexPxBolts " * Fact/100;\n")													Stream)
					(princ	(strcat "			var StyleTextBolts=Htext.toString() + \"px " StyleTextBolts "\";\n")						Stream)
					(princ	"			for (i = 0; i < ArrayX_.length; i++) {\n" 															Stream)
					(princ	"				ctx.font=StyleTextBolts;\n" 																	Stream)
					(princ	"				ctx.textAlign = \"left\";\n" 																	Stream)
					(princ	"				ctx.textBaseline = \"alphabetic\";\n" 															Stream)					
					(princ	"				ii=i+1;\n" 																						Stream)
					(princ	(strcat "				ctx.fillStyle=\"" ColorTextBolts "\";\n")												Stream)
					(princ	"				ctx.fillText(\"B\" + ii.toString(),ArrayX_[i]+ArrayD_[i],ArrayY_[i]-ArrayD_[i]);\n"				Stream)
					(princ	"			}\n"																								Stream)
					(princ	"		}\n"																									Stream)
				)
			)
			;
			; Graphics Internal Shape ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(setq Shape 0)
			(foreach itm LstPointInternalShapeCanvas
				(princ 	"		// Internal Shape input Java ++++++++++++++++;\n"									Stream)
				(PrintArrayJava (mapcar 'car   itm) (strcat "		var ArrayXIShape" (LM:rtos Shape 2 0) "_")  fuzz Stream)
				(PrintArrayJava (mapcar 'cadr  itm) (strcat "		var ArrayYIShape" (LM:rtos Shape 2 0) "_")  fuzz Stream)

				(princ	"		var i;\n"																			Stream)
				(princ	"		ctx.strokeStyle=ColorInternalShape;\n"												Stream)
				(princ	"		ctx.fillStyle = ColorFillInternalShape;\n"											Stream)
				(princ	"		ctx.beginPath();\n"																	Stream)
				(princ	(strcat "		for (i = 0; i < ArrayXIShape" (LM:rtos Shape 2 0) "_.length; i++) { \n")	Stream)
				(princ	"			if (i==0) {\n"																	Stream)
				(princ	(strcat "				ctx.moveTo(ArrayXIShape" (LM:rtos Shape 2 0) "_[i],"
														  "ArrayYIShape" (LM:rtos Shape 2 0) "_[i]);\n")			Stream)
				(princ	"			} else {\n"																		Stream)
				(princ	(strcat "				ctx.lineTo(ArrayXIShape" (LM:rtos Shape 2 0) "_[i],"
													      "ArrayYIShape" (LM:rtos Shape 2 0) "_[i]);\n")			Stream)
				(princ	"			}\n"																			Stream)										
				(princ	"		}\n"																				Stream)
				(princ	"		ctx.closePath();\n"																	Stream)
				(princ	"		ctx.fill();\n"																		Stream)
				(princ	"		ctx.stroke();\n"																	Stream)
				(setq Shape (1+ Shape))
			)
			;
			; Index Shape +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(setq conta 0)	
			(princ 	"		// Index Shape input Java ++++++++++++++++;\n"															Stream)
			(PrintArrayJava (mapcar 'car   LstPointNoDiscretizeShapeCanvas)  "		var ArrayX_"  fuzz Stream)
			(PrintArrayJava (mapcar 'cadr  LstPointNoDiscretizeShapeCanvas)  "		var ArrayY_"  fuzz Stream)

			(princ 	"		if (FlagShape==1) {\n"																					Stream)
			(princ	"			var i;\n" 																							Stream)
			(princ	"			var ii;\n" 																							Stream)
			(princ	(strcat "			var Htext=" TexPxShape " * Fact/100;\n")													Stream)
			(princ	(strcat "			var StyleTextShape=Htext.toString() + \"px " StyleTextShape "\";\n")						Stream)
			(princ	"			for (i = 0; i < ArrayX_.length; i++) {\n" 															Stream)
			(princ	"				ctx.font=StyleTextShape;\n" 																	Stream)
			(princ	"				ii=i+1;\n" 																						Stream)
			(princ	(strcat "				ctx.fillStyle=\"" ColorTextShape "\";\n")												Stream)
			(princ	"				ctx.textAlign = \"center\";\n"																	Stream)					
			(princ	"				ctx.textBaseline = \"middle\";\n"																Stream)
			(princ	"				ctx.fillText(\"C\" + ii.toString(),ArrayX_[i],ArrayY_[i]);\n"									Stream)
			(princ	"			}\n"																								Stream)
			(princ	"		}\n"																									Stream)
			;
			; Graphics Index internal Shape +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(if LstPointNoDiscretizeInternalShapeCanvas
				(progn
					(princ 	"		// Index Internal Shape input Java ++++++++++++++++;\n"													Stream)
					(PrintArrayJava (mapcar 'car   LstPointNoDiscretizeInternalShapeCanvas)  "		var ArrayX_"  fuzz Stream)
					(PrintArrayJava (mapcar 'cadr  LstPointNoDiscretizeInternalShapeCanvas)  "		var ArrayY_"  fuzz Stream)

					(princ 	"		if (FlagShape==1) {\n"																					Stream)
					(princ	"			var i;\n" 																							Stream)
					(princ	"			var ii;\n" 																							Stream)
					(princ	(strcat "			var Htext=" TexPxShape " * Fact/100;\n")													Stream)
					(princ	(strcat "			var StyleTextShape=Htext.toString() + \"px " StyleTextShape "\";\n")						Stream)
					(princ	"			for (i = 0; i < ArrayX_.length; i++) {\n" 															Stream)
					(princ	"				ctx.font=StyleTextShape;\n" 																	Stream)
					(princ	"				ii=i+1;\n" 																						Stream)
					(princ	(strcat "				ctx.fillStyle=\"" ColorTextShape "\";\n")												Stream)
					(princ	"				ctx.textAlign = \"center\";\n"																	Stream)					
					(princ	"				ctx.textBaseline = \"middle\";\n"																Stream)
					(princ	"				ctx.fillText(\"I\" + ii.toString(),ArrayX_[i],ArrayY_[i]);\n"									Stream)
					(princ	"			}\n"																								Stream)
					(princ	"		}\n"																									Stream)
				)
			)
			(princ	"	}\n" 																										Stream)
		)
	)
)
;
;
;
(defun PrintDrawEnameFunction (LstEname Stream / 	ScaleWidthPannedDisplay ScaleHeightPannedDisplay Margin
													ColorExternalShape ColorFillExternalShape ColorBolts
													ColorFillBoltsShape ColorBkgCanvas ColorTextBolts
													ColorTextShape TexPxBolts TexPxShape StyleTextBolts
													StyleTextShape fuzz MaxMin Pmin Pmax Width Height Scale
													DDx DDy UcsCanvas itm0 itm1 Pt LstPointCanvas Num)

	(setq ScaleWidthPannedDisplay 	140.0)
	(setq ScaleHeightPannedDisplay 	100.0)
	(setq Margin				 	10.0)
	(setq ColorExternalShape 		"Black")
	(setq ColorFillExternalShape 	"#d8dfcb")
	(setq ColorBolts 				"Black")
	(setq ColorFillBoltsShape 		"White")
	(setq ColorBkgCanvas	 		"White")
	(setq ColorTextBolts			"Black")
	(setq ColorTextShape			"Black")
	(setq TexPxBolts				"2")
	(setq TexPxShape				"2")
	(setq StyleTextBolts 			"Verdana")
	(setq StyleTextShape 			"Verdana")
	(setq fuzz 3)
	;
	;
	;
	(if (and LstEname Stream)
		(progn
			(setq MaxMin (LM:SSBoundingBox (LstEname->Ssget LstEname)))
			(setq Pmin 	 (nth 0 MaxMin))
			(setq Pmax 	 (nth 2 MaxMin))
			(setq Width  (abs (- (nth 0 Pmax) (nth 0 Pmin)))) 
			(setq Height (abs (- (nth 1 Pmax) (nth 1 Pmin))))
			(setq Scale  (max (/ Width  (- ScaleWidthPannedDisplay  Margin))
						      (/ Height (- ScaleHeightPannedDisplay Margin))))
						
			(setq DDx (/ (- ScaleWidthPannedDisplay  (/ Width Scale)) 2.0))
			(setq DDy (/ (- ScaleHeightPannedDisplay (/ Height Scale)) 2.0))
			
					
			(setq UcsCanvas		(DefPiano 	(nth 0 Pmin) (nth 1 Pmax) 0.0
											(nth 0 Pmax) (nth 1 Pmax) 0.0
											(nth 0 Pmin) (nth 1 Pmin) 0.0))
			
			;------------------------------------------------------------------------------------------------------------------------							

			(princ "	function draw() {\n" 																						Stream)
			(princ (strcat "		var ColorBkgCanvas= \""     	ColorBkgCanvas "\";\n")											Stream)
			(princ (strcat "		var ColorExternalShape= \""     ColorExternalShape "\";\n")										Stream)
			(princ (strcat "		var ColorFillExternalShape= \"" ColorFillExternalShape "\";\n")									Stream)
			(princ "		ctx.setTransform(1,0,0,1,0,0);\n" 																		Stream)
			(princ "		ctx.scale(widthCanvas/widthView, heightCanvas/heightView);\n" 											Stream)
			(princ "		ctx.translate(-xleftView,-ytopView);\n" 																Stream)
			(princ "		ctx.fillStyle = ColorBkgCanvas;\n" 																		Stream)
			(princ "		ctx.fillRect(xleftView,ytopView, widthView,heightView);\n" 												Stream)
			(princ "		ctx.lineWidth = 1.0 / (widthCanvas/widthView);\n" 														Stream)
			(princ "		ctx.strokeStyle=ColorExternalShape;\n"					 												Stream)
			(princ "		// Shape dinamic input Java ++++++++++++++++\n"	 														Stream)					
				
			(setq  Num 0)	
			(foreach itm0 LstEname
			
				(setq LstPointCanvas NIL)
				(foreach itm1 (LM:ent->pts itm0 50)
				
					(setq Pt (transl (nth 0 itm1) (nth 1 itm1) 0.0 UcsCanvas))
					(setq LstPointCanvas (append LstPointCanvas (list (list (+ DDx (/ (nth 0 Pt) Scale)) 
														   				    (+ DDy (/ (nth 1 Pt) Scale))))))
				)
				
				(cond
					((= "CIRCLE"  (cdr (assoc 0 (entget itm0)))) 
						(setq LstPointCanvas (append LstPointCanvas (list (car LstPointCanvas))))
					)
					((= "ELLIPSE" (cdr (assoc 0 (entget itm0))))
						(setq LstPointCanvas (append LstPointCanvas (list (car LstPointCanvas))))
					)
					((= "LWPOLYLINE" (cdr (assoc 0 (entget itm0))))
						(if (IsClosed itm0 T)
							(setq LstPointCanvas (append LstPointCanvas (list (car LstPointCanvas))))
						)
					)
				)
				
				(if LstPointCanvas
					(progn
						(PrintArrayJava (mapcar 'car  LstPointCanvas)  (strcat "var ArrayX_" (LM:rtos Num 2 0) "_")  fuzz Stream)
						(PrintArrayJava (mapcar 'cadr LstPointCanvas)  (strcat "var ArrayY_" (LM:rtos Num 2 0) "_")  fuzz Stream)
						(princ "		ctx.beginPath();\n"										 											Stream)
						(princ	"		var i;\n"																							Stream)
						(princ	(strcat "		for (i = 0; i < ArrayX_" (LM:rtos Num 2 0) "_.length - 1; i++)\n")							Stream)
						(princ	"		{\n"																								Stream)
						(princ	(strcat "				ctx.moveTo(ArrayX_" (LM:rtos Num 2 0) "_[i],ArrayY_" (LM:rtos Num 2 0) "_[i]);\n")		Stream)
						(princ	(strcat "				ctx.lineTo(ArrayX_" (LM:rtos Num 2 0) "_[i+1],ArrayY_" (LM:rtos Num 2 0) "_[i+1]);\n")	Stream)
						(princ	"		}\n"																								Stream)										
						(princ	"		ctx.stroke();\n"																					Stream)
					)
				)
				(setq Num (1+ Num))
			)
			(princ	"	}\n"																										Stream)
		)
	)
)
;
;
;
(defun DstvToGraphicCanvas (FileDstv FileShape / GetIdShapebyFileName 
												 WidthPix HeightPix Stream fuzztable LstDataDstv LstHead LstShape LstHole
												 LstDiscrete Clock PerimeterShape conta IdShape TypShape CutShape LstInShape)

	(defun GetIdShapebyFileName (FileName / Split File Rtn)
		(if FileName
			(progn
				(cond 
					((> (length (splitxt FileName "\\")) 1)
						(setq Split (splitxt FileName "\\"))
						(setq File (nth (- (length Split) 1) Split))
					)
					((> (length (splitxt FileName "/")) 1)
						(setq Split (splitxt FileName "/"))
						(setq File (nth (- (length Split) 1) Split))
					)
					(t
						(setq file nil)
					)
				)
				(if file
					(progn
						(setq Split (splitxt File "."))
						(setq Split (splitxt (nth 0 Split) "_"))
						(setq Rtn (nth 1 Split))
					)
				)
			)
		)
		Rtn
	)
	;
	;
	;
	(if (and FileDstv FileShape)
		(progn
			
			(setq WidthPix   700)
			(setq HeightPix  500)
			(setq fuzztable 2)
			
			(setq StreamLog$ (open (vl-filename-mktemp) "w"))
			(setq LstDataDstv (DstvReadFile FileDstv T))   ;	(LstHead LstAkShape LstHole LstStamp LstIkShapeTotal)
			(close StreamLog$)
			
			(setq LstHead  		(nth 0 LstDataDstv))
			(setq LstShape 		(nth 1 LstDataDstv))
			(setq LstHole  		(nth 2 LstDataDstv))
			(setq LstInShape  	(nth 4 LstDataDstv))

			;(nth 0  LstHead) ->  IdOrder          	"C8722
			;(nth 1  LstHead) ->  IdDrawing         "171-110"
			;(nth 2  LstHead) ->  IdPhase        	"100"
			;(nth 3  LstHead) ->  IdIdentification 	"011124"
			;(nth 4  LstHead) ->  IdQuality        	"S355J2"
			;(nth 5  LstHead) ->  IdQuantity        "1"
			;(nth 6  LstHead) ->  IdProfile         "PL1540*15"
			;(nth 7  LstHead) ->  IdCode            "B"
			;(nth 8  LstHead) ->  IdLength          "1183.50
			;(nth 9  LstHead) ->  IdHeigth          "1540.00"
			;(nth 10 LstHead) ->  IdThicknes        "15.00"
			;(nth 11 LstHead) ->  IdWeightmt        "64.25"
			;(nth 12 LstHead) ->  IdSurface         "1.13"
			;(nth 13 LstHead) ->  IdName	        "PIATTO"
			;(nth 14 LstHead) ->  JouShape          "0" "2" "3"
			;(nth 15 LstHead) ->  TypeShape	        "CE" "CI"
			;(nth 16 LstHead) ->  CutShape          "0" "1" "2" "3"
			;(nth 17 LstHead) ->  PerimeterShape    "123.5"
			;(nth 18 LstHead) ->  Weight   			"12.5"
			;(nth 19 LstHead) ->  DateShape     	"01/12/2019"

			(setq Stream (open FileShape "w"))
			(if Stream
				(progn
					;
					;	Info Shape ---------------------------------------------------------------
					;	<!-- Questo è un commento valido -->
					;	
					(princ (strcat "<!-- Shape " 	(nth 15 LstHead) "|"   					;0 TypeShape 			"CE" "CI"
													(GetIdShapebyFileName FileShape) "|"    ;1 IdShape 				"01234567"
													(nth 14 LstHead) "|"   					;2 JouShape 			"0" "2" "3"
													(nth 3  LstHead) "|"  					;3 IdIdentification 	"011124"
													(nth 16 LstHead) "|"   					;4 CutShape          	"0" "1" "2" "3"
													(nth 8  LstHead) "|"   					;5 IdLength          	"1183.50
													(nth 0  LstHead) "|"   					;7 IdOrder          	"C8722
													(nth 2  LstHead) "|"   					;8 IdPhase        		"100"
													(nth 4  LstHead) "|"   					;9 IdQuality        	"S355J2"
													(nth 10 LstHead) "|"  					;10 IdThicknes        	"15.00"
													(nth 19 LstHead) " -->\n" 				;DateShape     			"01/12/2019"
													) Stream)
					
					
					(princ "<!doctype html>\n" 																						Stream)
					(princ "<html>\n" 																								Stream)
					(princ "<head>\n" 																								Stream)
					(princ "<meta charset=\"utf-8\">\n" 																			Stream)
					(princ "<title> Info shape </title>\n" 																			Stream)
					(princ (strcat "<script type=\"text/javascript\" src=\"" TmpScrHtmlEasyCut$ "zoom.js\"></script>\n")			Stream)
					(princ "<style>\n" 																								Stream)
					
					(princ ".wrapper	{width:900px;margin-left:auto;font-family:Arial;float:left;}\n" 							Stream)
					(princ ".print 		{margin-top:5px}\n" 																		Stream)

					(princ ".layout    	{width:670px;margin-left:160px;margin-top:5px;font-size:15px;float:left;}\n" 				Stream)
					(princ ".closed    	{margin-left:830px;width:30px;margin-top:5px;font-size:15px;}\n" 							Stream)
					(princ ".button 	{background-color:red;}\n" 																	Stream)
								
					(princ ".infoshape 	{margin-top:10px;float:left;margin-left:25px;}\n" 											Stream)
					(princ ".flagview  	{border:red 1px solid;padding:5px;width:150px;margin-top:10px;float:left;}\n" 				Stream)
					(princ "canvas     	{margin-left:5px;margin-top:10px;border:red 1px solid;padding:10px;box-shadow: 10px 10px 5px #aaaaaa;float:left;}\n" Stream)
					
					(princ "</style>\n" 																							Stream)
					(princ "<script>\n" 																							Stream)
					(princ "var WndInfo;\n" 																						Stream)
					(princ "var WndShape;\n" 																						Stream)
					(princ "var WndBolts;\n" 																						Stream)
					(princ "var FlagShape;\n" 																						Stream)
					(princ "var FlagBolts;\n" 																						Stream)
					

					(PrintInfoShapeTableDstvFunction 					LstHead Stream)
					(PrintCoordinateExternalShapeTableDstvFunction 		LstShape Stream)
					(PrintCoordinateInternalShapeTableDstvFunction 		LstShape LstInShape Stream)
					(PrintCoordinateBoltsShapeTableDstvFunction 		LstShape LstHole Stream)
					(PrintCloseWindowShapeFunction 						Stream)
					(PrintDrawShapeDstvFunction 						LstHead LstShape LstHole LstInShape Stream)
					
					(princ "</script>\n" 																									Stream)
					(princ "</head>\n" 																										Stream)
					(princ "	<body>\n" 																									Stream)
					(princ "		<div class=\"wrapper\" align=\"center\">\n" 															Stream)
					(princ "			<div class=\"layout\"  align=\"left\">\n"															Stream)
					(princ (strcat "				<b>" FileDstv "</b>\n")			 														Stream)
					(princ "			</div>\n" 																							Stream)
					(princ "			<div class=\"layout\"  align=\"left\">\n"															Stream)
					(princ (strcat "				<b>Order&nbsp;" 				(nth 0  LstHead) 
													"&nbsp;&nbsp;Phase&nbsp;" 		(nth 2  LstHead) 
													"&nbsp;&nbsp;Mk&nbsp;" 			(nth 3  LstHead)  "</b>\n")							 	Stream)
					(princ "			</div>\n" 																							Stream)
					(princ "			<div class=\"closed\"  align=\"right\">\n"															Stream)
					(princ "				<button class=\"button\" onclick=\"CloseWindow()\">X</button>\n"								Stream)
					(princ "			</div>\n"																							Stream)
					(princ "			<div class=\"flagview\">\n"																			Stream)
					(princ "				<form align=\"left\">\n"																		Stream)
					(princ "					<input  type=\"checkbox\" onclick=\"if(this.checked){FlagShape=1;draw()} else {FlagShape=0;draw()}\">\n" Stream)
					(princ "					Indice controrno\n"																			Stream)
					(princ "				</form>\n"																						Stream)
					(princ "				<form align=\"left\">\n"																		Stream)
					(princ "					<input type=\"checkbox\" onclick=\"if(this.checked){FlagBolts=1;draw()} else {FlagBolts=0;draw()}\">\n"	Stream)
					(princ "					Indice bulloni\n"																			Stream)
					(princ "				</form>\n"																						Stream)
					(princ "				<div class=\"print\" align=\"right\">\n"														Stream)
					(princ "					<button onclick=\"InfoShapeTable()\" style=\"width:100px\">Info</button>\n"					Stream)
					(princ "				</div>\n"																						Stream)
					(princ "				<div class=\"print\" align=\"right\">\n"														Stream)
					(princ "					<button onclick=\"CoordinateExternalShapeTable()\" style=\"width:100px\">Out Shape</button>\n"			Stream)
					(princ "				</div>\n"																						Stream)
					(princ "				<div class=\"print\" align=\"right\">\n"														Stream)
					(princ "					<button onclick=\"CoordinateInternalShapeTable()\" style=\"width:100px\">In Shape</button>\n"			Stream)
					(princ "				</div>\n"																						Stream)
					(princ "				<div class=\"print\" align=\"right\">\n"														Stream)
					(princ "					<button onclick=\"CoordinateBoltsTable()\" style=\"width:100px\">Bolts</button>\n"			Stream)
					(princ "				</div>\n"																						Stream)
					(princ "			</div>\n"																							Stream)
					(princ (strcat "			<canvas id=\"canvas\" width=\""(rtos WidthPix  2 0) "\" height=\""(rtos HeightPix 2 0)"\"></canvas>\n") Stream)
					(princ	"		</div>\n" 																								Stream)
					(princ	"   </body>\n" 																									Stream)
					(princ	" </html>\n" 																									Stream)
					
					(close Stream)
				)
			)
		)
	)
)
;
;
;
(defun EnameToGraphicCanvas (LstEname LstDataCsv OutFile / LstHead WidthPix HeightPix Stream)

	;(nth 0 LstDataCsv)	; Id Shape
	;(nth 1 LstDataCsv)	; File Name
	;(nth 2 LstDataCsv)	; Order
	;(nth 3 LstDataCsv)	; Phase
	;(nth 4 LstDataCsv)	; Mark
	;(nth 5 LstDataCsv)	; Quantity
	;(nth 6 LstDataCsv)	; Thickness
	;(nth 7 LstDataCsv)	; Material


	(if (and LstEname LstDataCsv OutFile)
		(progn
			
			(setq WidthPix   700)
			(setq HeightPix  500)
			
			;(nth 0  LstHead) ->  IdOrder          	"C8722
			;(nth 1  LstHead) ->  IdDrawing         "171-110"
			;(nth 2  LstHead) ->  IdPhase        	"100"
			;(nth 3  LstHead) ->  IdIdentification 	"011124"
			;(nth 4  LstHead) ->  IdQuality        	"S355J2"
			;(nth 5  LstHead) ->  IdQuantity        "1"
			;(nth 6  LstHead) ->  IdProfile         "PL1540*15"
			;(nth 7  LstHead) ->  IdCode            "B"
			;(nth 8  LstHead) ->  IdLength          "1183.50
			;(nth 9  LstHead) ->  IdHeigth          "1540.00"
			;(nth 10 LstHead) ->  IdThicknes        "15.00"
			;(nth 11 LstHead) ->  IdWeightmt        "64.25"
			;(nth 12 LstHead) ->  IdSurface         "1.13"
			;(nth 13 LstHead) ->  IdName	        "PIATTO"
			;(nth 14 LstHead) ->  JouShape          "0" "2" "3"
			;(nth 15 LstHead) ->  TypeShape	        "CE" "CI"
			;(nth 16 LstHead) ->  CutShape          "0" "1" "2" "3"
			;(nth 17 LstHead) ->  PerimeterShape    "123.5"
			;(nth 18 LstHead) ->  Weight   			"12.5"
			;(nth 19 LstHead) ->  DateShape     	"01/12/2019"
			
			(setq LstHead 	(list 	(nth 2 LstDataCsv)	; 0
									"?"					; 1
									(nth 3 LstDataCsv)	; 2
									(nth 4 LstDataCsv)	; 3
									(nth 7 LstDataCsv)	; 4
									(nth 5 LstDataCsv)	; 5
									"?"					; 6
									"B"					; 7
									"?"					; 8
									"?"					; 9
									(nth 6 LstDataCsv)	; 10
									"?"					; 11
									"?"					; 12
									"?"					; 13
									"?"					; 14
									"?"					; 15
									"?"					; 16
									"?"					; 17
									"?"					; 18
									(today)				; 19
							)
			)
			
			(setq Stream (open OutFile "w"))
			(if Stream
				(progn
					;<!-- Shape CE|406204838|2|178-364|1|1100|C872|300|S355J0|4|07/12/2018 -->
					(princ (strcat "<!-- Shape " 	(nth 15 LstHead) 	"|"   		;0 TypeShape 			"CE" "CI"
													(nth 0 LstDataCsv) 	"|"   		;1 IdShape 				"01234567"
													(nth 14 LstHead) 	"|"   		;2 JouShape 			"0" "2" "3"
													(nth 3  LstHead) 	"|"  		;3 IdIdentification 	"011124"
													(nth 16 LstHead) 	"|"   		;4 CutShape          	"0" "1" "2" "3"
													(nth 8  LstHead) 	"|"   		;5 IdLength          	"1183.50
													(nth 0  LstHead) 	"|"   		;7 IdOrder          	"C8722
													(nth 2  LstHead) 	"|"   		;8 IdPhase        		"100"
													(nth 4  LstHead) 	"|"   		;9 IdQuality        	"S355J2"
													(nth 10 LstHead) 	"|"  		;10 IdThicknes        	"15.00"
													(nth 19 LstHead) 	" -->\n" 	;DateShape     			"01/12/2019"
													) Stream)
					
					(princ "<!doctype html>\n" 																						Stream)
					(princ "<html>\n" 																								Stream)
					(princ "<head>\n" 																								Stream)
					(princ "<meta charset=\"utf-8\">\n" 																			Stream)
					(princ "<title> Info shape </title>\n" 																			Stream)
					(princ (strcat "<script type=\"text/javascript\" src=\"" TmpScrHtmlEasyCut$ "zoom.js\"></script>\n")			Stream)
					(princ "<style>\n" 																								Stream)
					(princ ".wrapper	{width:900px;margin-left:auto;font-family:Arial;float:left;}\n" 							Stream)
					(princ ".layout    	{width:670px;margin-left:5px;margin-top:5px;font-size:15px;float:left;}\n" 					Stream)
					(princ ".closed    	{margin-left:750px;width:30px;margin-top:5px;font-size:15px;}\n" 							Stream)
					(princ ".button 	{background-color:red;}\n" 																	Stream)
					(princ ".infoshape 	{margin-top:10px;float:left;margin-left:25px;}\n" 											Stream)
					(princ ".flagview  	{border:red 1px solid;width:100px;margin-top:10px;margin-left:10px;float:left;}\n" 			Stream)
					(princ "canvas     	{margin-left:5px;margin-top:10px;border:red 1px solid;padding:10px;box-shadow: 10px 10px 5px #aaaaaa;float:left;}\n" Stream)
					
					(princ "</style>\n" 																							Stream)
					(princ "<script>\n" 																							Stream)
					(princ "var WndInfo;\n" 																						Stream)
					(princ "var WndShape;\n" 																						Stream)
					(princ "var WndBolts;\n" 																						Stream)
					(princ "var FlagShape;\n" 																						Stream)
					(princ "var FlagBolts;\n" 																						Stream)
					(PrintInfoShapeTableDstvFunction	LstHead Stream)
					(PrintCloseWindowShapeFunction 				Stream)
					(PrintDrawEnameFunction LstEname 			Stream)
					
					(princ "</script>\n" 																									Stream)
					(princ "</head>\n" 																										Stream)
					(princ "	<body>\n" 																									Stream)
					(princ "		<div class=\"wrapper\" align=\"center\">\n" 															Stream)

					(princ "			<div class=\"layout\"  align=\"left\">\n"															Stream)
					(princ (strcat "				<b>" (nth 1 LstDataCsv) "</b>\n")														Stream)
					(princ "			</div>\n" 																							Stream)

					(princ "			<div class=\"layout\"  align=\"left\">\n"															Stream)
					(princ (strcat "				<b>Order&nbsp;" 						(nth 0  LstHead) 
													"&nbsp;&nbsp;&nbsp;Phase&nbsp;" 		(nth 2  LstHead) 
													"&nbsp;&nbsp;&nbsp;Mk&nbsp;" 			(nth 3  LstHead) "</b>\n")						Stream)
					(princ "			</div>\n" 																							Stream)

					(princ "			<div class=\"closed\"  align=\"right\">\n"															Stream)
					(princ "				<button class=\"button\" onclick=\"CloseWindow()\">X</button>\n"								Stream)
					(princ "			</div>\n"																							Stream)

					(princ (strcat "			<canvas id=\"canvas\" width=\""(rtos WidthPix  2 0) "\" height=\""(rtos HeightPix 2 0)"\"></canvas>\n") Stream)
					(princ "			<div class=\"flagview\">\n"																			Stream)
					(princ "				<div class=\"print\" align=\"right\">\n"														Stream)
					(princ "					<button onclick=\"InfoShapeTable()\" style=\"width:100px\">Info</button>\n"					Stream)
					(princ "				</div>\n"																						Stream)
					(princ "			</div>\n"																							Stream)
					(princ	"		</div>\n" 																								Stream)
					(princ	"   </body>\n" 																									Stream)
					(princ	" </html>\n" 																									Stream)
					
					(close Stream)
				)
			)
		)
	)
)
;
;
;