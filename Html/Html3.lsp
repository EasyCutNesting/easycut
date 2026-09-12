;
(defun PrintArrayJava (LstVar StrNameVar FuzzVar Stream / conta itm)
			
	(if (and LstVar StrNameVar FuzzVar Stream)
		(progn
			;(princ 	(strcat "var " StrNameVar "=[")		Stream)
			(princ 	(strcat StrNameVar "=[")				Stream)
			(setq conta 0)
			(foreach itm LstVar
				(cond
					((= (type itm) 'INT)
						(if (= conta 0)
							(princ (strcat 		(LM:rtos itm 2 FuzzVar)) 	Stream)
							(princ (strcat ","  (LM:rtos itm 2 FuzzVar)) 	Stream)
						)
					)
					((= (type itm) 'REAL)
						(if (= conta 0)
							(princ (strcat 		(LM:rtos itm 2 FuzzVar)) 	Stream)
							(princ (strcat "," 	(LM:rtos itm 2 FuzzVar)) 	Stream)
						)
					)
					((= (type itm) 'STR)
						(if (= conta 0)
							(princ (strcat "\""  itm "\"") 	Stream)
							(princ (strcat ",\"" itm "\"") 	Stream)
						)
					)
					(t
						(if (= conta 0)
							(princ (strcat "\""  "-" "\"") 	Stream)
							(princ (strcat ",\"" "-" "\"") 	Stream)
						)
					)
				)	
				(setq conta (1+ conta))
			)
			(princ	"];\n" Stream)						
		)
	)
)
;
;
;
(defun EnameSheetToGraphicCanvas (EnameSheet CheckTrigger / Swap
															Color1 Color2 WidthWebShape HeightWebShape TopWeb LeftWeb 
															WidthPix HeightPix DataSheet LstEnameShape LstEnameExternalShape LstEnameInternalShape 
															FileSheet Stream LstGrpSequence LstEnameSequence
															LstCheckTrigger RefClick itm DataShape) 



	(setq Color1 "#DDEBF7")
	(setq Color2 "#BDD7EE")
	(setq WidthWebShape	 	910)
	(setq HeightWebShape	590)
	(setq TopWeb 			10)
	(setq LeftWeb 			20)
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
	; Main
	;
	(if EnameSheet
		(progn
			
			(setq WidthPix   840)
			(setq HeightPix  600)

			(setq LstEnameExternalShape 	(GetEnameShapeByEnameSheet EnameSheet "CE"))		; veloce
			(setq LstEnameInternalShape 	(GetEnameShapeByEnameSheet EnameSheet "CI"))		; veloce
			(setq DataSheet 				(GetDataSheetByEname EnameSheet))					; veloce
			
			;DataSheet
			;0 IdSheet 		1 NameSheet		2 Widthsheet 	3 HeightSheet	4 ThickSheet

			;(setq LstGrpSequence  	(GetSequenceSheet EnameSheet))						; veloce
			(setq LstGrpSequence  	(GetSequenceGroupOnSheet EnameSheet))
			(setq LstEnameSequence	(GetEnameShapeSequence (cdr LstGrpSequence)))
			; Aggiunto filtro setup +++++++
			;(setq LstEnameSequence  (FilterLstEnameSequenceByDataSelectWithFilterSetup EnameSheet LstEnameSequence))
			; +++++++++++++++++++++++++++++
			(setq LstCheckTrigger   (GetLstIdShapeWithEnameTriggerOnSheet EnameSheet))
			(setq FileSheet (strcat HtmlStorageEasyCut$ ECFolderSheet$  ECFileSheet$ "_" (nth 0 DataSheet) ".html"))
			;
			(setq Stream (open FileSheet "w"))
			(if Stream
				(progn
					
					;	Info Sheet ---------------------------------------------------------------
					;	<!-- Questo è un commento valido -->
					;	DataSheet "293451914" "jkj" "2500" "5000" "10" "12.5" "981.25" "S355j0"
					(princ (strcat "<!-- " 	FileSheet	  "|"	
										(nth 0 DataSheet) "|" 
										(nth 1 DataSheet) "|"
										(nth 2 DataSheet) "|"
										(nth 3 DataSheet) "|"
										(nth 4 DataSheet) "|"
										(nth 5 DataSheet) "|"
										(nth 6 DataSheet) "|"
										(nth 7 DataSheet) " -->\n") Stream)
										
					(princ "<!doctype html>\n" 																											Stream)
					(princ "<html>\n" 																													Stream)
					(princ "<head>\n" 																													Stream)
					(princ "<meta charset=\"utf-8\">\n" 																								Stream)
					(princ "<title> Info shape </title>\n" 																								Stream)
					(princ (strcat "<script type=\"text/javascript\" src=\"" TmpScrHtmlEasyCut$ "zoom.js\"></script>\n") 								Stream)
					(princ (strcat "<script type=\"text/javascript\" src=\"" TmpScrHtmlEasyCut$ "tools01.js\"></script>\n") 							Stream)
					(princ "<style>\n" 																													Stream)
					(princ ".wrapper	{width:1080px;margin-left:auto;font-family:Arial;float:left;}\n" 												Stream)
					(princ ".print 		{margin-top:5px}\n" 																							Stream)
					(princ ".layout    	{width:670px;margin-left:160px;margin-top:5px;font-size:15px;float:left;}\n" 									Stream)
					(princ ".closed    	{margin-left:940px;width:30px;margin-top:5px;font-size:15px;}\n" 												Stream)
					(princ ".button 	{background-color:red;}\n" 																						Stream)
					(princ ".infoshape 	{margin-top:10px;float:left;margin-left:25px;}\n" 																Stream)
					(princ ".flagview  	{border:red 1px solid;padding:5px;width:150px;margin-top:10px;float:left;}\n" 									Stream)
					(princ "canvas     	{margin-left:5px;margin-top:10px;border:red 1px solid;padding:10px;box-shadow: 10px 10px 5px #aaaaaa;float:left;}\n" Stream)
					(princ "td 			{font-family:Courier New;}\n" 																					Stream)					
					(princ "</style>\n" 																												Stream)
					(princ "<script>\n" 																												Stream)
					(princ "var WndInfoSequence;\n" 																									Stream)
					(princ "var FlagSequ;\n" 																											Stream)
					(princ "var FlagInfo;\n" 																											Stream)
					(princ "var FlagBolts;\n" 																											Stream)
					(if CheckTrigger
						(PrintDrawSheetFunction EnameSheet LstEnameExternalShape LstEnameInternalShape LstEnameSequence LstCheckTrigger Stream)
						(PrintDrawSheetFunction EnameSheet LstEnameExternalShape LstEnameInternalShape LstEnameSequence nil Stream)
					)
					(PrintCloseWindowSheetFunction Stream)
					
					(princ "</script>\n" 																												Stream)
					(princ "</head>\n" 																													Stream)
					(princ "	<body>\n" 																												Stream)
					(princ "		<div class=\"wrapper\" align=\"center\">\n" 																		Stream)
					(princ "			<div class=\"layout\"  align=\"left\">\n"																		Stream)
					(princ (strcat "				<b>Idr&nbsp;" 				(nth 0 DataSheet)
													"&nbsp;&nbsp;Name&nbsp;" 	(nth 1 DataSheet) 
													"&nbsp;&nbsp;Width&nbsp;" 	(nth 2 DataSheet) 
													"&nbsp;&nbsp;Height&nbsp;" 	(nth 3 DataSheet)
													"&nbsp;&nbsp;Thick&nbsp;" 	(nth 4 DataSheet) "</b>\n")												Stream)
					(princ "			</div>\n" 																										Stream)
					(princ "			<div class=\"closed\"  align=\"right\">\n"																		Stream)
					(princ "				<button class=\"button\" onclick=\"CloseWindow()\">X</button>\n"											Stream)
					(princ "			</div>\n"																										Stream)
					(princ "			<div class=\"flagview\" align=\"left\">\n"																		Stream)
					(princ "				<form>\n"																									Stream)
					(princ "					<input  type=\"checkbox\" onclick=\"if(this.checked){FlagSequ=1;draw()} else {FlagSequ=0;draw()}\">\n" 	Stream)
					(princ "					Sequenza\n"																								Stream)
					(princ "				</form>\n"																									Stream)
					(princ "				<form>\n"																									Stream)
					(princ "					<input  type=\"checkbox\" onclick=\"if(this.checked){FlagInfo=1;draw()} else {FlagInfo=0;draw()}\">\n" 	Stream)
					(princ "					Info Mark\n"																							Stream)
					(princ "				</form>\n"																									Stream)
					(princ "				<div style=\"overflow-y: scroll; height:518px; margin-top:10px;\">\n"										Stream)
					(princ "				<table width=\"100%\">\n"																					Stream)

					(setq conta 1)
					(setq LstEnameShape 	(CalculationQuantityShape LstEnameExternalShape))

					(foreach itm LstEnameShape

						(setq RefClick (strcat "\"openWindow('../" (vl-string-right-trim "\\" ECFolderShape$) "/" 
								ECFileShape$ "_" (GetIdShape (car itm)) ".html'," 
								(rtos WidthWebShape 2 0)	"," 
								(rtos HeightWebShape 2 0) 	"," 
								(rtos TopWeb 2 0) 			"," 
								(rtos LeftWeb 2 0) 			",'" (GetIdShape (car itm)) "')"))						

						(princ (strcat "					<tr bgcolor=\"" (Swap Color1 Color2 conta) "\">\n")													Stream)
						(princ (strcat "						<td width=\"10%\">" (rtos conta 2 0) "</td>\n")													Stream)
						(princ (strcat "						<td width=\"90%\"><a href=\"#\" onClick=" RefClick "\">" (GetNameShape (car itm)) "</td>\n")	Stream)
						(princ "					</tr>\n"																									Stream)
						(setq conta (1+ conta))
					)

					(princ "				</table>\n"																											Stream)
					(princ "				</div>\n"																											Stream)
					(princ "			</div>\n"																												Stream)
					(princ (strcat "			<canvas id=\"canvas\" width=\""(rtos WidthPix 2 0) "\" height=\""(rtos HeightPix 2 0)"\"></canvas>\n") 			Stream)
					(princ	"		</div>\n" 																													Stream)
					(princ	"   </body>\n" 																														Stream)
					(princ	" </html>\n" 																														Stream)
					(close Stream)
				)
			)
		)
	)
)
;
;
;
(defun PrintSequenceTableFunction (LstEnameSequence Stream / Progressivo Swap 
												       Width Height Surface Color1 Color2 conta itm DataShape TotCut
												       &LengthCutSq &LstIdSq &LstOrderSq &LstPhaseSq &LstMarkSq &LstDimensionSq ChoiseShape
												       &LstTkSq &LstSurfaceSq &LstWeightSq &LstTimeSq &LstTypeSq &LengthCutSq &LstColorSq &LstProgSq)

	(defun Progressivo (Intero Cifre / CifreIntero Zeri Rtn)
	
		(if (and Intero Cifre)
			(progn
				(setq CifreIntero (strlen (rtos Intero 2 0)))
				(setq Zeri (- Cifre CifreIntero))
				(setq Rtn "")
				(if (> Zeri 0)
					(repeat Zeri
						(setq Rtn (strcat Rtn "0"))
					)
				)
				(setq Rtn (strcat Rtn  (rtos Intero 2 0)))
			)
		)
		Rtn
	)
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
	(if (and LstEnameSequence Stream)
		(progn
			
			; Sequence Cut list ----------------------------------
			
			(setq &LengthCutSq 0.0)
			(setq Color1 "#EDEDED")
			(setq Color2 "#DBDBDB")
			(setq conta 0)
			
			
			;(princ "\n") (princ (length LstEnameSequence)) (getstring "")
			(foreach itm LstEnameSequence
				
				;(setq DataShape (GetDataShape itm))	
				
				;(if (or (and (= (GetTypShape itm) "CE") (= (substr ChoiseShape 1 1) "1"))
				;		 (and (= (GetTypShape itm) "CI") (= (substr ChoiseShape 2 1) "1"))
				;	 )
				;
				;(setq MSecStart (getvar "MILLISECS"))
				
				(setq EnameTrigger (GetEnameTriggerByIdShape (GetIdShape itm)))
								
				(if (and (nth 0 EnameTrigger) (nth 1 EnameTrigger))
					(progn
					
						; 	0	TypShape	1	IdShape		2	JouShape 
						;	3	NameShape	4	CutComp 	5	LenghtCut 
						;	6	Timing 		7	ComShape	8	PhaseShape 
						;	9	MatShape 	10	TkShape		11	DateShape
						
						
						
						(setq &LstIdSq			(append &LstIdSq 	(list (GetIdShape itm))))
						(setq &LstOrderSq		(append &LstOrderSq (list (GetComShape itm))))
						(setq &LstPhaseSq		(append &LstPhaseSq (list (GetPhaseShape itm))))
						(setq &LstMarkSq		(append &LstMarkSq  (list (GetNameShape itm))))
				
						;(princ "\n")
						;(princ &LstMarkSq)
						;(getstring "")
				
						(if (= (cdr (assoc 0 (entget itm))) "CIRCLE")
								(setq &LstDimensionSq (append &LstDimensionSq (list (strcat "D=" (rtos (vla-get-Diameter (vlax-ename->vla-object itm)) 2 1)))))
							(progn
								(vla-getboundingbox 	(vlax-ename->vla-object itm) 'mnl 'mxl)
								(setq Width   			(abs (- (nth 0 (vlax-safearray->list mxl)) (nth 0 (vlax-safearray->list mnl)))))
								(setq Height  			(abs (- (nth 1 (vlax-safearray->list mxl)) (nth 1 (vlax-safearray->list mnl)))))
								(setq &LstDimensionSq 	(append &LstDimensionSq (list (strcat (rtos Width 2 1) "*" (rtos Height 2 1)))))
							)
						)	
				
						(setq &LstTkSq			(append &LstTkSq  (list (GetTkShape itm))))
						(setq Surface 	   		(/ (vla-get-area (vlax-ename->vla-object itm)) 1000000.0))
						(setq &LstSurfaceSq		(append &LstSurfaceSq (list (rtos Surface 2 2))))
						(setq &LstWeightSq  	(append &LstWeightSq  (list (rtos (* (* 7.85 Surface) (atof (GetTkShape itm))) 2 2))))
						
						;(setq &LstTimeSq		(append &LstTimeSq  (list (nth 0 (GetTimingShape itm)))))
						(setq TotCut            (GetTimingCutOnlyShape itm))
						(setq TotCut			(+ (nth 0 TotCut) (nth 4 TotCut)))
						(setq &LstTimeSq		(append &LstTimeSq  (list (strcat (LM:rtos (fix TotCut) 2 0) " min " 
						                                                          (LM:rtos (* (- TotCut (fix TotCut)) 60.0) 2 0) " sec"))))
						
						
						
						(if (= (GetTypShape itm) "CI")	(setq TypeContShape "Internal"))
						(if (= (GetTypShape itm) "CE")	(setq TypeContShape "External"))
						(setq &LstTypeSq		(append &LstTypeSq (list TypeContShape)))
						(setq &LengthCutSq 		(+ &LengthCutSq (GetLengthEname itm)))
						(setq &LstColorSq		(append &LstColorSq (list (Swap Color1 Color2 Conta))))
						(setq &LstProgSq		(append &LstProgSq  (list (Progressivo (1+ conta) 3))))
						(setq conta (1+ conta))
						
						
					)
				)
				
				;(setq MSecEnd (getvar "MILLISECS"))
				;(princ "\nBenchMark  PrintSequenceTableFunction ") (princ (/ (- MSecEnd MSecStart) 1000.0))
			)
			;
			; Sequence List +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(princ 	"	function SequenceCutShapeTable() {\n" 								Stream)
			(princ 	"			// Info Cut Shape dinamic input Java ++++++++++++++++\n" 	Stream)
			; ---------------------------------------------------------------------------------------------------------
			(PrintArrayJava &LstProgSq 		"var ArrayLstProgSq_"      0 Stream) ;1
			(PrintArrayJava &LstIdSq 		"var ArrayLstIdSq_"        0 Stream) ;2
			(PrintArrayJava &LstOrderSq 	"var ArrayLstOrderSq_"     0 Stream) ;3
			(PrintArrayJava &LstPhaseSq 	"var ArrayLstPhaseSq_"     0 Stream) ;4
			(PrintArrayJava &LstMarkSq 		"var ArrayLstMarkSq_"      0 Stream) ;5
			(PrintArrayJava &LstDimensionSq "var ArrayLstDimensionSq_" 0 Stream) ;6
			(PrintArrayJava &LstTkSq 		"var ArrayLstTkSq_"        0 Stream) ;7
			(PrintArrayJava &LstSurfaceSq 	"var ArrayLstSurfaceSq_"   0 Stream) ;8
			(PrintArrayJava &LstWeightSq 	"var ArrayLstWeightSq_"    0 Stream) ;9
			(PrintArrayJava &LstTimeSq 		"var ArrayLstTimeSq_"      0 Stream) ;10
			(PrintArrayJava &LstTypeSq 		"var ArrayLstTypeSq_"      0 Stream) ;11
			(PrintArrayJava &LstColorSq 	"var ArrayLstColorSq_"     0 Stream) ;12
			; ---------------------------------------------------------------------------------------------------------
			(princ 	"			var lines = '<!doctype html>';\n"															Stream)
			(princ 	"			lines += '<!doctype html>';\n"																Stream)
			(princ 	"			lines += '<html><head>';\n"																	Stream)
			(princ 	"			lines += '<meta charset=\"appropriate charset here\">';\n"									Stream)
			(princ 	"			lines += '<title>Info Shape</title>';\n"													Stream)
			(princ 	"			lines += '<style>';\n"																		Stream)
			(princ 	"			lines += '.btn {color:black;transition:0.3s;}';\n"											Stream)
			(princ 	"			lines += '.btn:hover {background-color: #3e8e41;color: white;}';\n"							Stream)
			(princ 	"			lines += '.infoshape {font-size:15px;width:auto;height:auto;margin:10px;font-family:Arial;}';\n" Stream)
			(princ 	"			lines += '</style>';\n"																		Stream)
			(princ 	"			lines += '</head><body>';\n"																Stream)
			(princ 	"			lines += '<div class=\"infoshape\">';\n"													Stream)
			
			(princ "			lines += '<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"95%\">'\n"		Stream)
			(princ 	"			lines += '<tr height=\"25px\" align=\"center\">';\n"										Stream)
			(princ "			lines += '<td><b>Itm</b></td>'\n"															Stream)
			(princ "			lines += '<td><b>Id</b></td>'\n"															Stream)
			(princ "			lines += '<td><b>Order</b></td>'\n"															Stream)
			(princ "			lines += '<td><b>Phase</b></td>'\n"															Stream)
			(princ "			lines += '<td><b>Mark</b></td>'\n"															Stream)
			(princ "			lines += '<td><b>Dimension</b></td>'\n"														Stream)
			(princ "			lines += '<td><b>Thik.</b></td>'\n"															Stream)
			(princ "			lines += '<td><b>Area</b></td>'\n"															Stream)
			(princ "			lines += '<td><b>Weight</b></td>'\n"														Stream)
			(princ "			lines += '<td><b>Time Cut</b></td>'\n"														Stream)
			(princ "			lines += '<td><b>Shape</b></td>'\n"															Stream)
			(princ "			lines += '</tr>'\n"																			Stream)


			(princ 	"			var i;\n"																					Stream)
			(princ 	"			var ii;\n"																					Stream)
			(princ 	"			for (i = 0; i < ArrayLstProgSq_.length; i++) {\n"											Stream)
			(princ 	"				ii=i+1;\n" 																				Stream)
			(princ 	"				lines += '<tr height=\"25px\" align=\"center\" bgcolor=\"' + ArrayLstColorSq_[i] + '\">';\n"	Stream)
			(princ 	"				lines += '  <td class=\"btn\">' + ArrayLstProgSq_[i] + '</td>';\n"						Stream)
			(princ 	"				lines += '  <td class=\"btn\">' + ArrayLstIdSq_[i] + '</td>';\n"						Stream)
			(princ 	"				lines += '  <td class=\"btn\">' + ArrayLstOrderSq_[i] + '</td>';\n"						Stream)
			(princ 	"				lines += '  <td class=\"btn\">' + ArrayLstPhaseSq_[i] + '</td>';\n"						Stream)
			(princ 	"				lines += '  <td class=\"btn\">' + ArrayLstMarkSq_[i] + '</td>';\n"						Stream)
			(princ 	"				lines += '  <td class=\"btn\">' + ArrayLstDimensionSq_[i] + '</td>';\n"					Stream)
			(princ 	"				lines += '  <td class=\"btn\">' + ArrayLstTkSq_[i] + '</td>';\n"						Stream)
			(princ 	"				lines += '  <td class=\"btn\">' + ArrayLstSurfaceSq_[i] + '</td>';\n"					Stream)
			(princ 	"				lines += '  <td class=\"btn\">' + ArrayLstWeightSq_[i] + '</td>';\n"					Stream)
			(princ 	"				lines += '  <td class=\"btn\">' + ArrayLstTimeSq_[i] + '</td>';\n"						Stream)
			(princ 	"				lines += '  <td class=\"btn\">' + ArrayLstTypeSq_[i] + '</td>';\n"						Stream)
			(princ 	"				lines += '</tr>';\n"																	Stream)
			(princ 	"			}\n"																						Stream)
			(princ 	"			lines += '	</table>';\n"																	Stream)
			(princ 	"			lines += '</div>';\n"																		Stream)
			(princ 	"			lines += '</body></html>';\n"																Stream)
			(princ 	"			if (!WndInfoSequence){\n"																	Stream)
			(princ 	"				WndInfoSequence = window.open(\"\",\"\",\"resizable=yes,width=750,height=400,left=90,top=90,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"				WndInfoSequence.document.write(lines);\n"												Stream)
			(princ 	"				} else {\n"																				Stream)
			(princ 	"				if (WndInfoSequence.closed) {\n"														Stream)
			(princ 	"					WndInfoSequence = window.open(\"\",\"\",\"resizable=yes,width=750,height=400,left=90,top=90,menubar=no,toolbar=no,loacation=no\");\n" Stream)
			(princ 	"					WndInfoSequence.document.write(lines);\n"											Stream)
			(princ 	"				} else {\n"																				Stream)
			(princ 	"					WndInfoSequence.close();\n"															Stream)
			(princ 	"					WndInfoSequence = window.open(\"\",\"\",\"resizable=yes,width=750,height=400,left=90,top=90,menubar=no,toolbar=no,loacation=no\");\n"	Stream)
			(princ 	"					WndInfoSequence.document.write(lines);\n"											Stream)
			(princ 	"				}\n"																					Stream)
			(princ 	"			}\n"																						Stream)
			(princ 	" 	}\n"																								Stream)
		)
	)
)
;
;
;
(defun PrintDrawSheetFunction (EnameSheet LstEnameExternalShape LstEnameInternalShape 
							   LstEnameSequence LstCheckTrigger Stream / ScaleWidthPannedDisplay ScaleHeightPannedDisplay Margin
																		ColorBkgCanvas ColorBkgSheet ColorBkgExternalShape
																		ColorTextShape	TexPxShape StyleTextShape DataShape LstInfoShape
																		ColorErrorBkgExternalShape ColorErrorBkgInternalShape
																		ColorBkgInternalShape ColorSheet ColorExternalShape ColorInternalShape
																		fuzz itm itm1 conta Shape Num
																		LstCheckBoltShape LstCheckInternalShape LstCheckExternalShape
																		LstPrg LstEnameExtShape
																		Pmin Pmax Width Height Scale DDx DDy LstPointSheet UcsCanvas Pt LstPointSheetCanvas
																		LstPointShape LstPointTmp LstPointShapeCanvas 
																		LstPointInternalShapeCanvas LstPointBoltShapeCanvas
																		LstGravityCenterShapeCanvas)

	(setq ScaleWidthPannedDisplay 	140.0)
	(setq ScaleHeightPannedDisplay 	100.0)
	(setq Margin				 	10.0)
	
	(setq  ColorBkgCanvas "White")
	(setq  ColorBkgSheet "#E8E8E8")
		
	(setq  ColorBkgExternalShape "#CCCCCC")
	(setq  ColorBkgInternalShape "White")

	(setq  ColorErrorBkgExternalShape "Red")
	(setq  ColorErrorBkgInternalShape "Red")
		
	(setq  ColorSheet "Black")
	(setq  ColorExternalShape "Black")
	(setq  ColorInternalShape "Black")	
	
	(setq ColorTextShape	"Black")
	(setq TexPxShape		"1.5")
	(setq StyleTextShape 	"Verdana")

	(setq fuzz 3)
	
	;(princ "\nLstCheckTrigger 		") (princ LstCheckTrigger) (getstring "")
	
	;(if (and EnameSheet LstEnameShape Stream)
	(if	(and EnameSheet Stream)
		(progn
			(vla-getboundingbox (vlax-ename->vla-object EnameSheet) 'mnl 'mxl)
			(setq Pmin 			(vlax-safearray->list mnl))
			(setq Pmax 			(vlax-safearray->list mxl))
			(setq Width   		(abs (- (nth 0 Pmax) (nth 0 Pmin)))) 
			(setq Height  		(abs (- (nth 1 Pmax) (nth 1 Pmin))))
			(setq Scale 		(max (/ Width  (- ScaleWidthPannedDisplay  Margin))
									 (/ Height (- ScaleHeightPannedDisplay Margin))))
						
			(setq DDx (/ (- ScaleWidthPannedDisplay  (/ Width Scale)) 2.0))
			(setq DDy (/ (- ScaleHeightPannedDisplay (/ Height Scale)) 2.0))
			
			;(setq LstPointSheet (DiscretizeShape EnameSheet))
			(setq LstPointSheet (DiscretizeShapeNoControl EnameSheet))
			
			(setq UcsCanvas		(DefPiano 	(nth 0 Pmin) (nth 1 Pmax) 0.0
											(nth 0 Pmax) (nth 1 Pmax) 0.0
											(nth 0 Pmin) (nth 1 Pmin) 0.0))			

			;------------------------------------------------------------------------------------------------------------------------							

			(foreach itm LstPointSheet
				(setq Pt (transl (nth 0 itm) (nth 1 itm) 0.0 UcsCanvas))
				(setq LstPointSheetCanvas (append LstPointSheetCanvas
												(list (list (+ DDx (/ (nth 0 Pt) Scale))
															(+ DDy (/ (nth 1 Pt) Scale))))))
				
			)	

			;------------------------------------------------------------------------------------------------------------------------				

			(setq conta 1)
			(foreach itm LstEnameSequence
				;(if (and (= (GetTypShape itm) "CE") (= (CheckTrigger itm) 4))
				(if (and (= (GetTypShape itm) "CE") (= (CheckTriggerOnList itm LstCheckTrigger) 4) (member itm LstEnameExternalShape))
					(progn
						(setq LstEnameExtShape (append LstEnameExtShape (list itm)))
						(setq LstPrg (append LstPrg (list (rtos conta 2 0))))
						(setq conta (1+ conta))
					)
				)
			)
			(foreach itm LstEnameExternalShape
				;(if (not (member itm LstEnameSequence))
				(if (/= (CheckTriggerOnList itm LstCheckTrigger) 4)
					(progn
						(setq LstEnameExtShape (append LstEnameExtShape (list itm)))
						(setq LstPrg (append LstPrg (list "0")))
					)
				)
			)
			;(princ "\nLstEnameExternalShape  	") (princ LstEnameExternalShape) (getstring "")		  
			;(princ "\nLstEnameExtShape  		") (princ LstEnameExtShape) (getstring "")
			;(princ "\nLstEnameInternalShape     ") (princ LstEnameInternalShape) (getstring "")
			;(princ "\nLstPrg            ") (princ LstPrg)
			;------------------------------------------------------------------------------------------------------------------------				

			(setq Num 1)
			(princ "\n")
			(foreach itm LstEnameExtShape

				(princ "\rWrite Data external shape ") 
				(princ (strcat (LM:rtos Num 2 0) "/" (LM:rtos (length LstEnameExtShape) 2 0)))
				(princ " [") (princ itm) (princ "]")
				(setq Num (1+ Num))
				
				;(setq LstPointShape (DiscretizeShape itm))
				(setq LstPointShape (DiscretizeShapeNoControl itm))
				
				;(setq LstCheckExternalShape (append LstCheckExternalShape (list (CheckTrigger itm))))
				(setq LstCheckExternalShape (append LstCheckExternalShape (list (CheckTriggerOnList itm LstCheckTrigger))))
				
				(setq LstPointTmp nil)
				(foreach itm1 LstPointShape
					(setq Pt (transl (nth 0 itm1) (nth 1 itm1) 0.0 UcsCanvas))
					(setq LstPointTmp (append LstPointTmp (list (list (+ DDx (/ (nth 0 Pt) Scale))
																	  (+ DDy (/ (nth 1 Pt) Scale))))))
				)
				(setq LstPointShapeCanvas (append LstPointShapeCanvas (list LstPointTmp)))
				
				;(setq Pt (GetGravityCenter itm))
				(setq Pt (LM:PolyCentroid itm))
				
				(setq Pt (transl (nth 0 Pt) (nth 1 Pt) 0.0 UcsCanvas))
				(setq LstGravityCenterShapeCanvas (append LstGravityCenterShapeCanvas (list (list (+ DDx (/ (nth 0 Pt) Scale))
																								  (+ DDy (/ (nth 1 Pt) Scale))
																								  (+ DDy (/ (+ (nth 1 Pt) 20) Scale))))))
				;(setq DataShape (GetDataShape itm))
				
				; 	0	TypShape	1	IdShape		2	JouShape 
				;	3	NameShape	4	CutComp 	5	LenghtCut 
				;	6	Timing 		7	ComShape	8	PhaseShape 
				;	9	MatShape 	10	TkShape		11	DateShape		

				;(setq LstInfoShape (append LstInfoshape (list (nth 3 DataShape))))
				(setq LstInfoShape (append LstInfoshape (list (GetNameShape itm))))
				
			)

			;(princ "\nLstPointBoltShapeCanvas	") (princ LstPointBoltShapeCanvas) (getstring "")
			(setq Num 1)
			(princ "\n")
			(foreach itm LstEnameInternalShape

				(princ "\rWrite Data internal shape ") 
				(princ (strcat (LM:rtos Num 2 0) "/" (LM:rtos (length LstEnameInternalShape) 2 0)))
				(princ " [") (princ itm) (princ "]")
				(setq Num (1+ Num))

				(setq LstPointTmp nil)
				
				(cond
					((= (cdr (assoc 0 (entget itm))) "CIRCLE")
						(setq LstCheckBoltShape (append LstCheckBoltShape (list (CheckTriggerOnList itm LstCheckTrigger))))
						(setq Pt (vlax-safearray->list (vlax-variant-value (vla-get-Center (vlax-ename->vla-object itm)))))
						(setq Pt (transl (nth 0 Pt) (nth 1 Pt) 0.0 UcsCanvas))
						(setq LstPointTmp (append LstPointTmp	(list (list (+ DDx (/ (nth 0 Pt) Scale))
																									(+ DDy (/ (nth 1 Pt) Scale))
																									(/ (vla-get-Radius (vlax-ename->vla-object itm)) Scale)))))

						(setq LstPointBoltShapeCanvas (append LstPointBoltShapeCanvas (list LstPointTmp)))
					)
					(t
						;(setq LstPointShape (DiscretizeShape itm))
						(setq LstPointShape (DiscretizeShapeNoControl itm))
						(setq LstCheckInternalShape (append LstCheckInternalShape (list (CheckTriggerOnList itm LstCheckTrigger))))
						(foreach itm1 LstPointShape
							(setq Pt (transl (nth 0 itm1) (nth 1 itm1) 0.0 UcsCanvas))
							(setq LstPointTmp (append LstPointTmp (list (list (+ DDx (/ (nth 0 Pt) Scale))
																		      (+ DDy (/ (nth 1 Pt) Scale))))))
						)
						(setq LstPointInternalShapeCanvas (append LstPointInternalShapeCanvas (list LstPointTmp)))
					)
				)
			)
			;(princ "\nLstPointBoltShapeCanvas	") (princ LstPointBoltShapeCanvas) (getstring "")
			;(princ "\nLstPointInternalShapeCanvas	") (princ LstPointInternalShapeCanvas) (getstring "")

			;-------------------------------------------------------------------------------------------------
			
			(princ "	function draw() {\n"															Stream)
			(princ "\n"																					Stream)	
			(princ (strcat "		var ColorBkgCanvas= \""	ColorBkgCanvas	"\";\n")					Stream)
			(princ (strcat "		var ColorBkgSheet= \""	ColorBkgSheet	"\";\n")					Stream)
			
			(princ (strcat "		var ColorBkgExternalShape= \""	ColorBkgExternalShape	"\";\n")	Stream)
			(princ (strcat "		var ColorBkgInternalShape= \""	ColorBkgInternalShape	"\";\n")	Stream)
			(princ (strcat "		var ColorErrorBkgExternalShape= \""	ColorErrorBkgExternalShape	"\";\n")	Stream)
			(princ (strcat "		var ColorErrorBkgInternalShape= \""	ColorErrorBkgInternalShape	"\";\n")	Stream)
			
			
			(princ (strcat "		var ColorSheet= \""		ColorSheet	"\";\n")						Stream)
			(princ (strcat "		var ColorExternalShape= \""	ColorExternalShape	"\";\n")			Stream)
			(princ (strcat "		var ColorInternalShape= \""	ColorInternalShape	"\";\n")			Stream)
			(princ "\n"																					Stream)		
			(princ "		ctx.setTransform(1,0,0,1,0,0);\n"											Stream)
			(princ "		ctx.scale(widthCanvas/widthView, heightCanvas/heightView);\n"				Stream)
			(princ "		ctx.translate(-xleftView,-ytopView);\n"										Stream)
			(princ "		ctx.fillStyle = ColorBkgCanvas;\n"											Stream)
			(princ "		ctx.fillRect(xleftView,ytopView, widthView,heightView);\n"					Stream)
			(princ "		ctx.lineWidth = 1.0 / (widthCanvas/widthView);\n"							Stream)
			(princ "		// Sheet dinamic input Java ++++++++++++++++\n"	 							Stream)	


						
			;--------------------------------------------------------------------------------------------------

			(PrintArrayJava (mapcar 'car   LstPointSheetCanvas)  "		var ArrayXSheet_"  fuzz Stream)
			(PrintArrayJava (mapcar 'cadr  LstPointSheetCanvas)  "		var ArrayYSheet_"  fuzz Stream)
						
			;--------------------------------------------------------------------------------------------------

			(setq Shape 0)
			(foreach itm LstPointShapeCanvas
				(PrintArrayJava (mapcar 'car   itm)  (strcat "		var ArrayXShape" (LM:rtos Shape 2 0) "_")  fuzz Stream)
				(PrintArrayJava (mapcar 'cadr  itm)  (strcat "		var ArrayYShape" (LM:rtos Shape 2 0) "_")  fuzz Stream)
				(setq Shape (1+ Shape))
			)

			;-------------------------------------------------------------------------------------------------

			(setq Shape 0)
			(foreach itm LstPointBoltShapeCanvas
				(PrintArrayJava (mapcar 'car   itm) (strcat "		var ArrayXBolt" (LM:rtos Shape 2 0) "_")  fuzz Stream)
				(PrintArrayJava (mapcar 'cadr  itm) (strcat "		var ArrayYBolt" (LM:rtos Shape 2 0) "_")  fuzz Stream)
				(PrintArrayJava (mapcar 'caddr itm) (strcat "		var ArrayDBolt" (LM:rtos Shape 2 0) "_")  fuzz Stream)
				(setq Shape (1+ Shape))
			)
			
			;-------------------------------------------------------------------------------------------------

			(setq Shape 0)
			(foreach itm LstPointInternalShapeCanvas
				(PrintArrayJava (mapcar 'car   itm) (strcat "		var ArrayXIShape" (LM:rtos Shape 2 0) "_")  fuzz Stream)
				(PrintArrayJava (mapcar 'cadr  itm) (strcat "		var ArrayYIShape" (LM:rtos Shape 2 0) "_")  fuzz Stream)
				(setq Shape (1+ Shape))
			)

			(PrintArrayJava (mapcar 'car  LstGravityCenterShapeCanvas)  "		var ArrayXGC_"  fuzz Stream)
			(PrintArrayJava (mapcar 'cadr LstGravityCenterShapeCanvas)  "		var ArrayYGC_"  fuzz Stream)
			(PrintArrayJava (mapcar 'caddr LstGravityCenterShapeCanvas) "		var ArrayYIN_"  fuzz Stream)
			(PrintArrayJava LstInfoShape  "		var ArrayInfo_"  0 Stream)
			(PrintArrayJava LstPrg        "		var ArrayPrg_"   0 Stream)
			

			;
			;Sheet --------------------------------------------------------------------------------------------------
			;
			(princ	"		// -------------------------------------------------------------------------\n"	Stream)
			(princ	"		var i;\n"																	Stream)
			(princ	"		ctx.beginPath();\n"															Stream)
			(princ	"		ctx.strokeStyle=ColorSheet;\n"												Stream)
			(princ	"		for (i = 0; i < ArrayXSheet_.length; i++) { \n"								Stream)
			(princ	"			if (i==0) {\n"															Stream)
			(princ	"				ctx.moveTo(ArrayXSheet_[i],ArrayYSheet_[i]);\n"						Stream)
			(princ	"			} else {\n"																Stream)
			(princ	"				ctx.lineTo(ArrayXSheet_[i],ArrayYSheet_[i]);\n"						Stream)
			(princ	"			}\n"																	Stream)										
			(princ	"		}\n"																		Stream)
			(princ	"		ctx.closePath();\n"															Stream)
			(princ	"		ctx.fillStyle =ColorBkgSheet;\n"											Stream)
			(princ	"		ctx.fill();\n"																Stream)
			(princ	"		ctx.stroke();\n"															Stream)
			;
			;Shape External -----------------------------------------------------------------------------------------
			;
			(setq Shape 0)
			(foreach itm LstPointShapeCanvas
				(princ	"		// -------------------------------------------------------------------------\n"	Stream)
				(princ	"		var i;\n"																		Stream)
				(princ	"		ctx.strokeStyle=ColorExternalShape;\n"											Stream)
				
				
				(if (= (nth Shape LstCheckExternalShape) 4)
					(princ	"		ctx.fillStyle = ColorBkgExternalShape;\n"									Stream)
					(princ	"		ctx.fillStyle = ColorErrorBkgExternalShape;\n"								Stream)
				)
				
				
				(princ	"		ctx.beginPath();\n"																Stream)
				(princ	(strcat "		for (i = 0; i < ArrayXShape" (LM:rtos Shape 2 0) "_.length; i++) { \n")	Stream)
				(princ	"			if (i==0) {\n"																Stream)
				(princ	(strcat "				ctx.moveTo(ArrayXShape" (LM:rtos Shape 2 0) "_[i],"
														  "ArrayYShape" (LM:rtos Shape 2 0) "_[i]);\n")			Stream)
				(princ	"			} else {\n"																	Stream)
				(princ	(strcat "				ctx.lineTo(ArrayXShape" (LM:rtos Shape 2 0) "_[i],"
													      "ArrayYShape" (LM:rtos Shape 2 0) "_[i]);\n")			Stream)
				(princ	"			}\n"																		Stream)										
				(princ	"		}\n"																			Stream)
				(princ	"		ctx.closePath();\n"																Stream)
				
				
				(princ	"		ctx.fill();\n"																	Stream)
				(princ	"		ctx.stroke();\n"																Stream)
				(setq Shape (1+ Shape))
			)
			;
			;Shape Bolts ---------------------------------------------------------------------------------------------
			;
			(setq Shape 0)
			(foreach itm LstPointBoltShapeCanvas
				(princ	"		// -------------------------------------------------------------------------\n"		Stream)
				;(princ "		if (FlagBolts==1) {\n"															Stream)
				(princ	"		var i;\n" 																		Stream)
				(princ  "		var ColorBolts=ColorInternalShape;\n" 											Stream)
				
				(if (= (nth Shape LstCheckBoltShape) 4)
					(princ	"		ColorFillBolts = ColorBkgInternalShape;\n"									Stream)
					(princ	"		ColorFillBolts = ColorErrorBkgInternalShape;\n"								Stream)
				)

				;(princ  "		var ColorFillBolts=ColorBkgInternalShape;\n"									Stream)
				
				(princ	(strcat "			for (i = 0; i < ArrayXBolt" (LM:rtos Shape 2 0) "_.length; i++) {\n")	Stream)
				(princ	"				ctx.lineWidth = 1.0 / (widthCanvas/widthView);\n"							Stream)
				(princ	"				ctx.strokeStyle=ColorBolts;\n" 												Stream)
				(princ	"				ctx.beginPath();\n" 														Stream)
				(princ	(strcat "				ctx.arc(ArrayXBolt" (LM:rtos Shape 2 0) "_[i],"
													   "ArrayYBolt" (LM:rtos Shape 2 0) "_[i],"
													   "ArrayDBolt" (LM:rtos Shape 2 0) "_[i],"
													   "0.0,2*Math.PI);ctx.fillStyle=ColorFillBolts;\n")			Stream)
				(princ	"				ctx.fill();\n" 																Stream)
				(princ	"				ctx.stroke();\n" 															Stream)
				(princ	"			}\n" 																			Stream)
				;(princ	"		}\n" 																				Stream)
				(setq Shape (1+ Shape))
			)
			;
			;Shape Internal -----------------------------------------------------------------------------------------
			;
			(setq Shape 0)
			(foreach itm LstPointInternalShapeCanvas
				(princ	"		// -------------------------------------------------------------------------\n"	Stream)
				(princ	"		var i;\n"																		Stream)
				(princ	"		ctx.strokeStyle=ColorInternalShape;\n"											Stream)

				(if (= (nth Shape LstCheckInternalShape) 4)
					(princ	"		ctx.fillStyle = ColorBkgInternalShape;\n"									Stream)
					(princ	"		ctx.fillStyle = ColorErrorBkgInternalShape;\n"								Stream)
				)
				
				;(princ	"		ctx.fillStyle = ColorBkgInternalShape;\n"										Stream)

				(princ	"		ctx.beginPath();\n"																Stream)
				(princ	(strcat "		for (i = 0; i < ArrayXIShape" (LM:rtos Shape 2 0) "_.length; i++) { \n")Stream)
				(princ	"			if (i==0) {\n"																Stream)
				(princ	(strcat "				ctx.moveTo(ArrayXIShape" (LM:rtos Shape 2 0) "_[i],"
														  "ArrayYIShape" (LM:rtos Shape 2 0) "_[i]);\n")		Stream)
				(princ	"			} else {\n"																	Stream)
				(princ	(strcat "				ctx.lineTo(ArrayXIShape" (LM:rtos Shape 2 0) "_[i],"
													      "ArrayYIShape" (LM:rtos Shape 2 0) "_[i]);\n")		Stream)
				(princ	"			}\n"																		Stream)										
				(princ	"		}\n"																			Stream)
				(princ	"		ctx.closePath();\n"																Stream)
				(princ	"		ctx.fill();\n"																	Stream)
				(princ	"		ctx.stroke();\n"																Stream)
				(setq Shape (1+ Shape))
			)
			;		
			;--------------------------------------------------------------------------------------------------
			;
			(princ	"		// -------------------------------------------------------------------------\n"		Stream)
			(princ 	"		if (FlagSequ==1) {\n"																Stream)
			(princ	"			var ii;\n" 																		Stream)
			(princ	(strcat "			var Htext=" TexPxShape " * Fact/100;\n")								Stream)
			(princ	(strcat "			var StyleTextShape=Htext.toString() + \"px " StyleTextShape "\"\n;")	Stream)
			(princ	"			for (i = 0; i < ArrayXGC_.length; i++) {\n" 									Stream)
			(princ	"				ctx.font=StyleTextShape;\n" 												Stream)
			(princ	"				ctx.textAlign = \"center\";\n" 												Stream)
			(princ	"				ctx.textBaseline = \"middle\";\n" 											Stream)					
			(princ	"				ii=i+1;\n" 																	Stream)
			(princ	(strcat "				ctx.fillStyle=\"" ColorTextShape "\";\n")							Stream)
			;(princ	"				ctx.fillText(ii.toString(),ArrayXGC_[i],ArrayYGC_[i]);\n"					Stream)
			(princ	"				ctx.fillText(ArrayPrg_[i],ArrayXGC_[i],ArrayYGC_[i]);\n"					Stream)
			(princ	"			}\n"																			Stream)
			(princ	"		}\n"																				Stream)
			;
			;--------------------------------------------------------------------------------------------------
			;
			(princ	"		// -------------------------------------------------------------------------\n"		Stream)
			(princ 	"		if (FlagInfo==1) {\n"																Stream)
			(princ	"			var ii;\n" 																		Stream)
			(princ	(strcat "			var Htext=" TexPxShape " * Fact/100;\n")								Stream)
			(princ	(strcat "			var StyleTextShape=Htext.toString() + \"px " StyleTextShape "\"\n;")	Stream)
			(princ	"			for (i = 0; i < ArrayInfo_.length; i++) {\n" 									Stream)
			(princ	"				ctx.font=StyleTextShape;\n" 												Stream)
			(princ	"				ctx.textAlign = \"center\";\n" 												Stream)
			(princ	"				ctx.textBaseline = \"middle\";\n" 											Stream)					
			(princ	"				ii=i+1;\n" 																	Stream)
			(princ	(strcat "				ctx.fillStyle=\"" ColorTextShape "\";\n")							Stream)
			(princ	"				ctx.fillText(ArrayInfo_[i],ArrayXGC_[i],ArrayYIN_[i]);\n"					Stream)
			(princ	"			}\n"																			Stream)
			(princ	"		}\n"																				Stream)
			;--------------------------------------------------------------------------------------------------
			(princ	"	}\n" 																					Stream)
		)
	)

)
;
;
;
(defun PrintCloseWindowSheetFunction (Stream)
	(if Stream
		(progn
			(princ "	function CloseWindow() {\n"								Stream)
			(princ "		if (WndInfoSequence){WndInfoSequence.close();}\n"	Stream)
			(princ "		close();\n"											Stream)
			(princ "	}\n"													Stream)
		)
	)
)
