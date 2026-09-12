;
;
;
(defun ReportSheet (/ Ssel TypeSequence CheckTrigger EnameSheet NameReport ChoiseShape FileSheet FileShape LstEnameShape itm DataShape)
	
		
		(prompt "\nSelezionare la lamiera..")
		(setq Ssel (ssget "_+.:E:S" (list (list -3 (list (strcat $RgpSheet "," $RgpSheetTarget))))))
		(if Ssel	
			(progn
				(setq EnameSheet (GetEnameSheetByDummyEname (ssname Ssel 0)))
				(if (setq TypeSequence (GetTypeSequnce EnameSheet))
					(progn
						(UpDateCutSequence EnameSheet (atoi TypeSequence) nil)
						(setq CheckTrigger T)
					)
					(UpDateCutSequence EnameSheet $Sequence nil)
				)
				;(SequenceCut EnameSheet)
				(setq FileSheet (PlotSheet EnameSheet))
				(if FileSheet (while (not (findfile FileSheet))))	

				(princ (strcat "\nCreate Report Sheet " FileSheet "\n"))
				(if (setq LstEnameShape 	(CalculationQuantityShape (GetEnameShapeByEnameSheet EnameSheet "CE")))
					(progn
						(setq NameReport (GenerateHtmlReportSheetTipeA EnameSheet CheckTrigger FileSheet))
						(foreach itm LstEnameShape
							(setq FileShape (strcat HtmlStorageEasyCut$ ECFolderShape$ ECFileShape$ "_" (GetIdShape (car itm)) ".html"))
							(princ (strcat "\nCreate Graphics Shape " FileShape))
					
							; 	0	TypShape	1	IdShape		2	JouShape 
							;	3	NameShape	4	CutComp 	5	LenghtCut 
							;	6	Timing 		7	ComShape	8	PhaseShape 
							;	9	MatShape 	10	TkShape		11	DateShape	
							
							(EnameShapeToGraphicCanvas (car itm) FileShape)
						)
						(princ "\nCreate Graphics Sheet\n")
						(EnameSheetToGraphicCanvas EnameSheet CheckTrigger)
					)
					(LM:popup "Avvertimento" "Nessun contorno presente nella lamiera" (+ 1 48 4096))
				)
				
				(if (not TypeSequence) (RemoveSequenceGroupOnSheet EnameSheet))
				
				(if NameReport
					(DefaultBrowser NameReport)
				)
			)
		)
)
;
;
;
;(defun _ping (address / TestPing)
;
;	(defun TestPing (address / out ws)
;		(if (setq ws (vlax-get-or-create-object "WScript.Shell"))
;			(progn 
;				(setq out (vlax-invoke ws 'run (strcat "ping.exe -n 1 " address) 0 :vlax-true))
;				(and ws (vlax-release-object ws))
;				(zerop out)
;			)
;		)
;	)
;	
;	(if (not (TestPing address))
;		(setq HtmlScriptEasyCut$ (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Html\\Script\\"))
;	)
;	
;	(zerop 0)
;)
;(_ping "easycutnesting.it")
;
;
;
;
(defun GenerateHtmlReportSheetTipeA (EnameSheet CheckTrigger FilePlot / 
													Swap Num
													DataSheet DataCut LstEnameShape NameReport itm itm1 PathShape DataShape Dim Width Height Surface
													LstGrpSequence LstEnameSequence LstCheckTrigger Stream Color1 Color2 conta IdRnd
													LstFoundSearch Mark
													&LstOrder &LstPhase &LstMk &LstMat &LstId &LstTk &LstQta &LstDimension &LstWeight
													&LstTotWeight &LstBarCode
													&LstIdSq &LstOrderSq &LstPhaseSq &LstMarkSq &LstDimensionSq &LstTkSq &LstSurfaceSq
													&LstWeightSq &LstTimeSq &LstTypeSq &LengthCutSq 
													&Date &Time &JobNumber &SheetOrder &SheetId &SheetDim &SheetMat &SheetWidth &SheetHeight
													&SheetThikness &SheetSurface &SheetWeight &SheetSpeedCut &ShapeTotLgCut	&ShapeTimingCut	
													&ShapeSurface &ShapeWeight &SheetSurface &SheetScrapsSurface &SheetScrapsWeigth	
													&SheetScrapsPercent &SheetImmage &LstInfoImage 
													WidthWebSheet HeightWebSheet WidthWebShape HeightWebShape TopWeb LeftWeb EnameTrigger TotCut TotQta TotWgt)	
	(setq Color1 "#DDEBF7")
	(setq Color2 "#BDD7EE")
	(setq WidthWebSheet	 	1100)
	(setq HeightWebSheet 	720)
	(setq WidthWebShape	 	910)
	(setq HeightWebShape	590)
	(setq TopWeb 		10)
	(setq LeftWeb 		20)
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
	; Main +++++
	;
	(if (and EnameSheet FilePlot) ; (and EnameSheet ChoiseShape)
		(progn
			(setq DataSheet 		(GetDataSheetByEname EnameSheet)) 	; DataSheet "293451914" "jkj" "2500" "5000" "10" "12.5" "981.25" "S355j0"
			(setq LstFoundSearch 	(FindShapeOnSheet (list EnameSheet) "<>" "<>" "<>"))
			(setq DataCut 			(car (GetInfoCutSheetFound LstFoundSearch)))
			(foreach Mark 			(cdr (car LstFoundSearch))
				(setq LstEnameShape (append LstEnameShape (list (cons (cadr Mark) (- (length Mark) 1))))) 
			)
			(setq NameReport 		(strcat HtmlStorageEasyCut$ ECFolderReport$ ECFileReport$ "_" (nth 0 DataSheet) ".html"))
			(if CheckTrigger
				(progn
					(setq LstGrpSequence  	(GetSequenceGroupOnSheet EnameSheet))
					(setq LstEnameSequence	(GetEnameShapeSequence (cdr LstGrpSequence)))
					; +++++++++++++++++++++++++++++
					(setq LstCheckTrigger   (GetLstIdShapeWithEnameTriggerOnSheet EnameSheet))
				)
			)
			;
			; Cut list -----------------------------------------
			;
			(princ "\n Cut List")
			(foreach itm LstEnameShape
				(princ (strcat "\r" (vl-princ-to-string (car itm)) " Qta " (rtos (cdr itm) 2 0)))
		
				(setq &LstOrder 	(append &LstOrder 	(list (GetComShape   (car itm)))))				; 7
				(setq &LstPhase 	(append &LstPhase 	(list (GetPhaseShape (car itm)))))				; 8
				(setq &LstMk 		(append &LstMk 		(list (GetNameShape  (car itm)))))				; 3
				(setq &LstMat 		(append &LstMat 	(list (GetMatShape   (car itm)))))				; 9
				(setq &LstId 		(append &LstId 		(list (GetIdShape    (car itm)))))				; 1
				(setq &LstTk 		(append &LstTk 		(list (GetTkShape    (car itm)))))				; 10
				(setq &LstQta 		(append &LstQta		(list (rtos (cdr itm) 2 0))))
				(setq Dim 	 		(GetDimensionDummy  (car itm)))
				(setq Surface 	   	(/ (vla-get-area (vlax-ename->vla-object (car itm))) 1000000.0))
				(setq &LstDimension (append &LstDimension 	(list (strcat (rtos (car Dim) 2 1) "x" (rtos (cadr Dim) 2 1)))))
				(setq &LstWeight  	(append &LstWeight 		(list (rtos (* (* 7.85 Surface) (atof (GetTkShape (car itm)))) 2 1))))
				(setq &LstTotWeight (append &LstTotWeight 	(list (rtos (* (* (* 7.85 Surface) (atof (GetTkShape (car itm)))) (cdr itm)) 2 1))))
				(setq &LstBarCode 	(append &LstBarCode (list (GetBarCode (car itm)))))
			)
			;
			; Sequence Cut list ----------------------------------
			;
			(princ "\n Sequence List")
			(setq &LengthCutSq 0.0)
			(setq Num 1)
			
			(foreach itm LstEnameSequence
				
				(princ "\r ") (princ (strcat "["(LM:rtos Num 2 0) "/" (LM:rtos (length LstEnameSequence) 2 0) "] ")) (princ itm)
				(setq Num (1+ Num))
		
				(if (= (CheckTriggerOnList itm LstCheckTrigger) 4)
					(progn

						(setq &LstIdSq			(append &LstIdSq 	(list (GetIdShape    itm))))
						(setq &LstOrderSq		(append &LstOrderSq (list (GetComShape   itm))))
						(setq &LstPhaseSq		(append &LstPhaseSq (list (GetPhaseShape itm))))
						(setq &LstMarkSq		(append &LstMarkSq  (list (GetNameShape  itm))))
						
						(if (= (cdr (assoc 0 (entget itm))) "CIRCLE")
								(setq &LstDimensionSq (append &LstDimensionSq (list (strcat (chr 248) (rtos (vla-get-Diameter (vlax-ename->vla-object itm)) 2 1)))))
							(progn
								(vla-getboundingbox 	(vlax-ename->vla-object itm) 'mnl 'mxl)
								(setq Width   			(abs (- (nth 0 (vlax-safearray->list mxl)) (nth 0 (vlax-safearray->list mnl)))))
								(setq Height  			(abs (- (nth 1 (vlax-safearray->list mxl)) (nth 1 (vlax-safearray->list mnl)))))
								(setq &LstDimensionSq 	(append &LstDimensionSq (list (strcat (rtos Width 2 1) "x" (rtos Height 2 1)))))
							)
						)	
				
						(setq &LstTkSq					(append &LstTkSq  (list (GetTkShape itm))))
						(setq Surface 	   				(/ (vla-get-area (vlax-ename->vla-object itm)) 1000000.0))
						(setq &LstSurfaceSq				(append &LstSurfaceSq (list (rtos Surface 2 1))))
						(setq &LstWeightSq  			(append &LstWeightSq  (list (rtos (* (* 7.85 Surface) (atof (GetTkShape itm))) 2 1))))
						
						(setq TotCut                    (GetTimingCutOnlyShape itm))
						(setq TotCut					(+ (nth 0 TotCut) (nth 4 TotCut)))
						(setq &LstTimeSq				(append &LstTimeSq  (list (strcat (LM:rtos (fix TotCut) 2 0) " min " 
						                                                                  (LM:rtos (* (- TotCut (fix TotCut)) 60.0) 2 0) " sec"))))
					    						
						(if (= (GetTypShape itm) "CI")	(setq TypeContShape "Internal"))
						(if (= (GetTypShape itm) "CE")	(setq TypeContShape "External"))
						(setq &LstTypeSq				(append &LstTypeSq (list TypeContShape)))
						(setq &LengthCutSq 				(+ &LengthCutSq (GetLengthEname itm)))
					)
				)
			)
			(princ "\n Print report")
			(setq Stream (open NameReport "w")) 
			(if Stream
				(progn
					; Get Data Sheet -----------------------------
					(setq &Date 				(Today))
					(setq &Time 				(Time))
					(setq &JobNumber 			(strcat "J_" (nth 0 DataSheet)))
					(setq &SheetOrder 			(nth 1 DataSheet))
					(setq &SheetId 				(nth 0 DataSheet))
					(setq &SheetDim 			(strcat (LM:rtos (atoi (nth 2 DataSheet)) 2 0) "*" (LM:rtos (atoi (nth 3 DataSheet)) 2 0) "*" (nth 4 DataSheet)))
					(setq &SheetMat 			(nth 7 DataSheet))
					(setq &SheetWidth 			(nth 2 DataSheet))
					(setq &SheetHeight 			(nth 3 DataSheet))
					(setq &SheetThikness		(nth 4 DataSheet))
					(setq &SheetSurface 		(nth 5 DataSheet))
					(setq &SheetWeight 			(nth 6 DataSheet))
					(setq &SheetSpeedCut		(LM:rtos (GetSpeedCutByThickness (nth 4 DataSheet)) 2 1))
					(setq &ShapeTotLgCut		(nth 1 DataCut))
					(setq &ShapeTimingCut		(MinSec (/ (atof &ShapeTotLgCut) (GetSpeedCutByThickness (nth 4 DataSheet)))))
					(setq &ShapeSurface			(nth 7 DataCut))
					(setq &ShapeWeight			(rtos (* (atof (nth 7 DataCut)) (atof (nth 4 DataSheet)) 7.85) 2 1))
					(setq &SheetScrapsSurface	(LM:rtos (- (atof (nth 8 DataCut)) (atof (nth 7 DataCut))) 2 1))
					(setq &SheetScrapsWeigth	(LM:rtos (* (- (atof (nth 8 DataCut)) (atof (nth 7 DataCut)))  (atof (nth 4 DataSheet)) 7.85) 2 1))
					(setq &SheetScrapsPercent   (LM:rtos (- 100.0 (* (/ (atof (nth 7 DataCut)) (atof (nth 8 DataCut))) 100.0)) 2 1))
					; --------------------------------------------
					(setq &SheetImmage 			FilePlot)
					(setq &LstInfoImage 		(GetInfoImage &SheetImmage))
					
					;
					;		OUTPUT HTML REPORT
					;
					;	<!-- Questo è un commento valido -->
					;	DataSheet "293451914" "jkj" "2500" "5000" "10" "12.5" "981.25" "S355j0"
					(princ (strcat "<!-- Sheet "
									&Date 			  "|"
									&Time 			  "|"
									(nth 0 DataSheet) "|" 
									(nth 1 DataSheet) "|"
									(nth 2 DataSheet) "|"
									(nth 3 DataSheet) "|"
									(nth 4 DataSheet) "|"
									(nth 5 DataSheet) "|"
									(nth 6 DataSheet) "|"
									(nth 7 DataSheet) " -->\n") Stream)
					
					(setq conta 0)
					(foreach itm LstEnameShape
						(princ  (strcat "<!-- Shape "
								(nth conta &LstOrder)		"|"
								(nth conta &LstPhase)		"|"
								(nth conta &LstMk)			"|"
								(nth conta &LstId)			"|"
								(nth conta &LstTk)			"|"
								(nth conta &LstMat)			"|"
								(nth conta &LstQta)			"|"
								(nth conta &LstDimension)	"|"
								(nth conta &LstWeight) 		"|"
								(nth conta &LstTotWeight) " -->\n") Stream)
						(setq conta (1+ conta))
					)
					(princ "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n" Stream)
					(princ "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n" 																Stream)
					(princ "<head>\n" 																										Stream)
					(princ "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n" 								Stream)
					(princ (strcat "<link rel=\"stylesheet\" type=\"text/css\" href=\"" TmpScrHtmlEasyCut$ "normalize.css\" />\n")			Stream)
					(princ "<title>Untitled Document</title>\n" 																			Stream)
					(princ "<style type=\"text/css\">\n"																					Stream)
					(princ ".wrapper          {width:100%;margin-left:auto;margin-right:auto;font-family:Arial;}\n"							Stream)
					(princ ".print            {font-size:12px; float: left;}\n"																Stream)
					(princ ".title            {font-size:18px}\n"																			Stream)
					(princ ".infosheet        {margin-top:5px;width:100%;}\n"																Stream)
					(princ ".layout           {margin-top:30px;font-size:20px;width:100%;height:25px;}\n"									Stream)
					(princ ".catlist          {margin-top:100px;font-size:20px;width:100%;height:25px;}\n"									Stream)
					(princ ".sequence         {margin-top:30px;font-size:20px;width:100%;height:25px;}\n"									Stream)
					(princ ".img1             {margin-top:20px;padding-top:100px;width:100%;height:700px;}\n"								Stream)
					(princ ".img2             {margin-top: 20px;width:100%;height:800px;}\n"												Stream)
					(princ ".infocatlist      {margin-top:5px;}\n"																			Stream)
					(princ ".infosequencelist {margin-top: 5px;width: 100%;}\n"																Stream)
					(princ ".td               {font-size: 9pt;}\n"																			Stream)
					(princ ".barcode          {margin-top: 5px;}\n"																			Stream)
					(princ "@page             {size: 210mm 297mm; margin: 5mm;}\n"															Stream)
					(princ "tr                {page-break-inside: avoid;}\n"																Stream)
					(princ ".header		      {}\n"																							Stream)
					(princ ".logo	          {float: right; height: 45px;}\n"																Stream)
					(princ ".logo img	      {height: 45px; display: inline-block;}\n"														Stream)
					(princ ".clearfix:after   {visibility: hidden; display: block; font-size: 0; content: \" \"; clear: both; height: 0;}\n" Stream)
					(princ "* html .clearfix  {zoom: 1;} /* IE6 */\n"																		Stream)
					(princ "*:first-child+html .clearfix {zoom: 1;} /* IE7 */\n"															Stream)
					(princ "</style>\n"																										Stream)
					(princ (strcat "<script type=\"text/javascript\" src=\"" TmpScrHtmlEasyCut$ "jquery-1.3.2.min.js\"></script>\n")		Stream)
					(princ (strcat "<script type=\"text/javascript\" src=\"" TmpScrHtmlEasyCut$ "jquery-barcode-2.0.2.min.js\"></script>\n")Stream)				
					(princ (strcat "<script type=\"text/javascript\" src=\"" TmpScrHtmlEasyCut$ "tools01.js\"></script>\n")					Stream)				
					(princ "</head>\n" 																										Stream)
					(princ "<body>\n" 																										Stream)
					(princ "	<div class=\"wrapper\" align=\"center\">\n"																	Stream)
					(princ "		<div class=\"header clearfix\">\n"																		Stream)
					(princ "			<div class=\"print\" align=\"left\">\n"																Stream)
					(princ (strcat "	   " (Today) " " (Time) "\n")																		Stream)
					(princ "			<br> <br> \n"																						Stream)
					(princ "			<button onclick=\"myFunction()\">Stampa</button>\n"													Stream)
					(princ "			</div>\n"																							Stream)
					(princ "			<div class=\"logo\">\n"																				Stream)
					(princ (strcat "			<img src=\"file:///"   LibPathEasyCut$ "Logo.jpg\" alt=\"logo\">\n")						Stream)
					(princ "			</div>\n"																							Stream)
					(princ "		</div>\n"																								Stream)
					(princ "		<div class=\"title\">\n" 																				Stream)
					(princ (strcat "			<b>Job &nbsp;" &JobNumber " </b>\n") 														Stream)
					(princ "		</div>\n" 																								Stream)		
					(princ "		<div class=\"infosheet\">\n"																			Stream)
					(princ "			<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"95%\">\n"							Stream)
					(princ "				<tr height=\"30px\" align=\"center\" bgcolor=\"#D8D8D8\">\n"									Stream)
					(princ (strcat "					<td width=\"25%\">Order " &SheetOrder "</td>\n")									Stream)
					(princ (strcat "					<td width=\"25%\">Id "    &SheetId "</td>\n")										Stream)
					(princ (strcat "					<td width=\"25%\">Sheet " &SheetDim " mm</td>\n")									Stream)
					(princ "				</tr>\n"																						Stream)
					(princ "				<tr height=\"30px\" align=\"center\" bgcolor=\"#C0C0C0\">\n"									Stream)
					(princ (strcat "					<td width=\"25%\">Mat "   &SheetMat "</td>\n")										Stream)
					(princ (strcat "					<td>Weigth sheet "        &SheetWeight  " kg</td>\n")								Stream)
					(princ (strcat "					<td>Weight shape "        &ShapeWeight  " kg</td>\n")								Stream)
					(princ "				</tr>\n"																						Stream)
					(princ "				<tr height=\"30px\" align=\"center\" bgcolor=\"#D8D8D8\">\n"									Stream)
					(princ (strcat "					<td>Sheet Area "          &SheetSurface " mq</td>\n")								Stream)
					(princ (strcat "					<td>Shape Area "          &ShapeSurface " mq</td>\n")								Stream)
					(princ (strcat "					<td>Scraps "              &SheetScrapsPercent " %</td>\n")							Stream)
					(princ "				</tr>\n"																						Stream)
					(princ "				<tr height=\"30px\" align=\"center\" bgcolor=\"#C0C0C0\">\n"									Stream)
					(princ (strcat "					<td>Scraps "              &SheetScrapsWeigth  " kg</td>\n")							Stream)
					(princ (strcat "					<td>Speed "               &SheetSpeedCut " mm/min</td>\n")							Stream)
					(princ (strcat "					<td>Timing cut "          &ShapeTimingCut "</td>\n")								Stream)
					(princ "				</tr>\n"																						Stream)
					(princ "			</table>\n"																							Stream)
					(princ "		</div>\n"																								Stream)
					(princ "		<br>\n"																									Stream)
					(princ "		<div class=\"title\">\n"																				Stream)
					(princ "			<b>Layout</b>\n"																					Stream)
					(princ "		</div>\n"																								Stream)
					
					(setq RefClick (strcat "\"openWindow('../" (vl-string-right-trim "\\" ECFolderSheet$) "/" 
												ECFileSheet$ "_" (nth 0 DataSheet) ".html'," 
									(rtos WidthWebSheet 2 0)		"," 
									(rtos HeightWebSheet 2 0) 	"," 
									(rtos TopWeb 2 0) 		"," 
									(rtos LeftWeb 2 0) 		",'" (nth 0 DataSheet) "_')"))
								
					(if (< (nth 0 (nth 0 &LstInfoImage)) (nth 1 (nth 0 &LstInfoImage)))
						(progn
							(princ "		<div class=\"img2\" align=\"center\">\n"												Stream)
							(princ (strcat "			<img src=\"" &SheetImmage "\" alt=\"\" style=\"width:600px;height:800px;\"\n"
										   "				 onClick=" RefClick "\">\n")											Stream)
							(princ "		</div>\n"																				Stream)
						)
						(progn
							(princ "		<div class=\"img1\" align=\"center\">\n"												Stream)
							(princ (strcat "			<img src=\"" &SheetImmage "\" alt=\"\" style=\"width:800px;height:600px;transform:rotate(90deg);\"\n"
							               "				 onClick=" RefClick "\">\n")											Stream)
							(princ "		</div>\n"																				Stream)
						)
					)
					;
					; Cut List +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					;
					(princ "		<br>\n"																								Stream)
					(princ "		<div class=\"title\">\n"																			Stream)
					(princ "			<b>Shape &nbsp; List</b>\n"																		Stream)
					(princ "		</div>\n"																							Stream)
					(princ "		<div class=\"infocatlist\">\n"																		Stream)
					(princ "			<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"95%\">\n"						Stream)
					(princ (strcat "				<tr height=\"30px\" align=\"center\" bgcolor= \"" (Swap Color1 Color2 1) "\">\n")	Stream)
					(princ "					<td><b>Itm</b></td>\n"																	Stream)
					(princ "					<td><b>Order</b></td>\n"																Stream)
					(princ "					<td><b>Phase</b></td>\n"																Stream)
					(princ "					<td><b>Mark</b></td>\n"																	Stream)
					(princ "					<td><b>Dimension</b></td>\n"															Stream)
					(princ "					<td><b>Thik.</b></td>\n"																Stream)
					(princ "					<td><b>Qta</b></td>\n"																	Stream)
					(princ "					<td><b>Tot Weight</b></td>\n"															Stream)
					(princ "					<td><b>BarCode</b></td>\n"																Stream)
					(princ "				</tr>\n"																					Stream)
					(setq conta 0)
					(setq TotQta 0)
					(setq TotWgt 0.0)
					(foreach itm LstEnameShape
						(princ (strcat "				<tr height=\"30px\" align=\"center\" bgcolor= \"" (Swap Color1 Color2 Conta) "\">\n")	Stream)
						(princ (strcat "					<td>" (NumToProg (1+ conta) 3) "</td>\n")											Stream)
						(princ (strcat "					<td>" (nth conta &LstOrder) "</td>\n")												Stream)
						(princ (strcat "					<td>" (nth conta &LstPhase) "</td>\n")												Stream)
						;----------------------------------------------------------------------------------------------------------
						(setq RefClick (strcat "\"openWindow('../" (vl-string-right-trim "\\" ECFolderShape$) "/" 
												ECFileShape$ "_" (nth conta &LstId) ".html'," 
												(rtos WidthWebShape 2 0)		"," 
												(rtos HeightWebShape 2 0) 	"," 
												(rtos TopWeb 2 0) 		"," 
												(rtos LeftWeb 2 0) 		",'" (nth conta &LstId) "')"))						
						
						(princ (strcat "					<td><a href=\"#\" onClick=" RefClick "\">" (nth conta &LstMk) "</a></td>\n")		Stream)
						;----------------------------------------------------------------------------------------------------------
						(princ (strcat "					<td>" (nth conta &LstDimension) "</td>\n")											Stream)
						(princ (strcat "					<td>" (nth conta &LstTk) "</td>\n")													Stream)
						(princ (strcat "					<td>" (nth conta &LstQta) "</td>\n")												Stream)
						(princ (strcat "					<td>" (nth conta &LstTotWeight) "</td>\n")											Stream)
						(setq IdRnd (Random_Str 9))
						(princ (strcat "					<td style=\"background-color:#ffffff\" align=\"center\">\n")						Stream)
						(princ (strcat "						<div id=\"" IdRnd "\" class=\"barcode\">\n")									Stream)
						(princ (strcat "							<script type=text/javascript>\n")											Stream)
						(princ (strcat "								generateBarcode(\"" IdRnd "\", \"" 
																						(nth conta &LstBarCode) 
																							"\", \"code128\", \"css\");\n")						Stream)
						(princ (strcat "							</script>\n")																Stream)
						(princ (strcat "						</div>\n")																		Stream)
						(princ (strcat "					</td>\n")																			Stream)
						(princ (strcat "				</tr>\n")																				Stream)
						(setq TotQta (+ TotQta (atoi (nth conta &LstQta))))
						(setq TotWgt (+ TotWgt (atof (nth conta &LstTotWeight))))
						(setq conta (1+ conta))
					)
					(princ (strcat "				<tr height=\"40px\" align=\"center\" bgcolor= \"" 
														(Swap Color1 Color2 conta) "\">\n")									Stream)
					(princ (strcat "					<td>"  "</td>\n")													Stream)
					(princ (strcat "					<td>"  "</td>\n")													Stream)
					(princ (strcat "					<td>"  "</td>\n")													Stream)
					(princ (strcat "					<td>"  "</td>\n")													Stream)
					(princ (strcat "					<td>"  "</td>\n")													Stream)
					(princ (strcat "					<td>" "Tot" "</td>\n")												Stream)
					(princ (strcat "					<td>" (LM:rtos TotQta 2 0) "</td>\n")								Stream)
					(princ (strcat "					<td>" (LM:rtos TotWgt 2 1) "</td>\n")								Stream)
					(princ (strcat "					<td>"  "</td>\n")													Stream)
					(princ (strcat "				</tr>\n")																Stream)
					(princ "			</table>\n"																			Stream)
					(princ "		</div>\n"																				Stream)		
					(princ "		<br>\n"																					Stream)
					(princ "		<div class=\"title\">\n"																Stream)
					(princ "			<b>Sequence</b>\n"																	Stream)
					(princ "		</div>\n"																				Stream)
					;
					; Sequence List +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					;
					(setq Color1 "#EDEDED")
					(setq Color2 "#DBDBDB")

					(princ "		<div class=\"infosequencelist\">\n"																			Stream)
					(princ "			<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"95%\">\n"								Stream)
					(princ (strcat "				<tr height=\"30px\" align=\"center\" bgcolor= \"" (Swap Color1 Color2 1) "\">\n")			Stream)
					(princ "					<td><b>Itm</b></td>\n"																			Stream)
					(princ "					<td><b>Id</b></td>\n"																			Stream)
					(princ "					<td><b>Order</b></td>\n"																		Stream)
					(princ "					<td><b>Phase</b></td>\n"																		Stream)
					(princ "					<td><b>Mark</b></td>\n"																			Stream)
					(princ "					<td><b>Dimension</b></td>\n"																	Stream)
					(princ "					<td><b>Thik.</b></td>\n"																		Stream)
					(princ "					<td><b>Area</b></td>\n"																			Stream)
					(princ "					<td><b>Weight</b></td>\n"																		Stream)
					(princ "					<td><b>Time Cut</b></td>\n"																		Stream)
					(princ "					<td><b>Shape</b></td>\n"																		Stream)
					(princ "				</tr>\n"																							Stream)
					(setq conta 0)
					(foreach itm &LstIdSq
						(princ (strcat "				<tr height=\"30px\" align=\"center\" bgcolor=\"" (Swap Color1 Color2 Conta) "\">\n")	Stream)
						(princ (strcat "					<td>" (NumToProg (1+ conta) 3) "</td>\n")											Stream)
						(princ (strcat "					<td>" (nth conta &LstIdSq) "</td>\n")												Stream)
						(princ (strcat "					<td>" (nth conta &LstOrderSq) "</td>\n")											Stream)
						(princ (strcat "					<td>" (nth conta &LstPhaseSq) "</td>\n")											Stream)
						(princ (strcat "					<td>" (nth conta &LstMarkSq) "</td>\n")												Stream)
						(princ (strcat "					<td>" (nth conta &LstDimensionSq) "</td>\n")										Stream)
						(princ (strcat "					<td>" (nth conta &LstTkSq) "</td>\n")												Stream)
						(princ (strcat "					<td>" (nth conta &LstSurfaceSq) "</td>\n")											Stream)
						(princ (strcat "					<td>" (nth conta &LstWeightSq) "</td>\n")											Stream)
						(princ (strcat "					<td>" (nth conta &LstTimeSq) "</td>\n")												Stream)
						(princ (strcat "					<td>" (nth conta &LstTypeSq) "</td>\n")												Stream)
						(princ (strcat "				</tr>\n")																				Stream)				
						(setq conta (1+ conta))
					)
					(princ "			</table>\n"		Stream)
					(princ "		</div>\n"			Stream)
					(princ "	</div>\n"				Stream)
					(princ "</body>\n"					Stream)
					(princ "</html>\n"					Stream)		
					(close Stream)
				)
				(alert (strcat "ERRORE generazione Report " NameReport))
			)
		)
	)
	NameReport
)
;
;
;
(defun Canvas-AddLine (Stream P1 P2 Color Width / fuzz)
	
		; ctx.lineWidth = 1.5; ctx.strokeStyle="blue"; ctx.beginPath(); ctx.moveTo(120,20); ctx.lineTo(20,100);  ctx.stroke();
		(setq fuzz 1)
		(if (and Stream P1 P2 Color Width)
			(progn
				(princ (strcat "ctx.lineWidth = " (rtos Width 2 fuzz) "; ") Stream)
				(princ (strcat "ctx.strokeStyle=\"" Color "\"; ") Stream)
				(princ "ctx.beginPath(); " Stream)
				(princ (strcat "ctx.moveTo(" (rtos (nth 0 P1) 2 fuzz) "," (rtos (nth 1 P1) 2 fuzz) "); ") Stream)
				(princ (strcat "ctx.lineTo(" (rtos (nth 0 P2) 2 fuzz) "," (rtos (nth 1 P2) 2 fuzz) "); ") Stream)
				(princ "ctx.stroke();\n" Stream)
			)
		)
)
;
;
;
(defun Canvas-AddPolyLine (Stream LstPoint Color Width / fuzz conta Pt)
	
		; ctx.lineWidth = 1.5; ctx.strokeStyle="blue"; ctx.beginPath(); ctx.moveTo(120,20); ctx.lineTo(20,100); ctx.stroke();
		(setq fuzz 1)
		(if (and Stream LstPoint Color Width)
			(progn
			
				(setq conta 0)
				(setq Pt (nth conta LstPoint))
				(setq conta (1+ conta))
				(princ (strcat "ctx.lineWidth = " (rtos Width 2 fuzz) "; ") Stream)
				(princ (strcat "ctx.strokeStyle=\"" Color "\"; ") Stream)
				(princ "ctx.beginPath(); " Stream)
				(princ (strcat "ctx.moveTo(" (rtos (nth 0 Pt) 2 fuzz) "," (rtos (nth 1 Pt) 2 fuzz) ");\n") Stream)
				
				(repeat (- (length LstPoint) 1)
					(setq Pt (nth conta LstPoint))
					(princ (strcat "ctx.lineTo(" (rtos (nth 0 Pt) 2 fuzz) "," (rtos (nth 1 Pt) 2 fuzz) ");\n") Stream)
					(setq conta (1+ conta))
				)
				(princ "ctx.closePath();\n" 				Stream)
				(princ "ctx.fillStyle = \"#d8dfcb\";\n" 	Stream)
				(princ "ctx.fill();\n" 						Stream)
				(princ "ctx.stroke();\n" 					Stream)
			)
		)
)
;
;
;
(defun Canvas-AddArc (Stream Pc Radius AngIni AngFin Color Width / fuzz)
	
		;ctx.lineWidth = 1.5; ctx.strokeStyle="red"; ctx.beginPath(); ctx.arc(100,200,50,0,2*Math.PI);  ctx.stroke();
		
		(setq fuzz 1)
		(if (and Stream Pc Radius AngIni AngFin Color Width)
			(progn
				(princ (strcat "ctx.lineWidth = " (rtos Width 2 fuzz) "; ") Stream)
				(princ (strcat "ctx.strokeStyle=\"" Color "\"; ") Stream)
				(princ "ctx.beginPath(); " Stream)
				(princ (strcat "ctx.arc(" (rtos (nth 0 Pc) 2 fuzz)","(rtos (nth 1 Pc) 2 fuzz) "," 
										  (rtos Radius 2 fuzz) "," 
										  (rtos AngIni 2 fuzz) "," 
										  (rtos AngFin 2 fuzz) "); ") Stream)
				(princ "ctx.stroke();\n" Stream)
			)
		)
)
;
;
;
(defun Canvas-AddCircle (Stream Pc Diam Color Width / fuzz)
	
		;ctx.lineWidth = 1.5; ctx.strokeStyle="red" ctx.beginPath(); ctx.arc(100,200,50,0,2*Math.PI); ctx.stroke();
		(setq fuzz 1)
		(if (and Stream Pc Diam Color)
			(progn
				(princ (strcat "ctx.lineWidth = " (rtos Width 2 fuzz) "; ") Stream)
				(princ (strcat "ctx.strokeStyle=\"" Color "\"; ") 			Stream)
				(princ "ctx.beginPath(); " Stream)
				(princ (strcat "ctx.arc(" (rtos (nth 0 Pc) 2 fuzz)","(rtos (nth 1 Pc) 2 fuzz) "," 
										  (rtos Diam 2 fuzz) "," 
										  (rtos 0.0 2 fuzz) "," 
										  "2*Math.PI \"); ") 				Stream)
				(princ "ctx.fillStyle = \"#000000\"; " 						Stream)
				(princ "ctx.fill(); " 										Stream)
				(princ "ctx.stroke();\n" 									Stream)
			)
		)
)
;
;
;
(defun Canvas-AddText (Stream Ps Text Color Font Width / fuzz)
	
		;ctx.font = '20pt Calibri'; ctx.lineWidth = 1; ctx.strokeStyle = 'blue'; ctx.strokeText('Hello World!', x, y);
		(setq fuzz 1)
		(if (and Stream Ps Text Color Width)
			(progn
			
				(princ (strcat "ctx.strokeStyle = \" " Color "\"; ") Stream)
				(princ (strcat "ctx.font = \"" Font "\"; ") Stream)
				(princ (strcat "ctx.lineWidth =" Width "; ") Stream)
				(princ (strcat "ctx.strokeText(\"" Text "\"," (rtos (nth 0 Ps) 2 fuzz) "," (rtos (nth 1 Ps) 2 fuzz) ");\n") Stream)
				(princ "ctx.stroke();\n" Stream)
				
			)
		)
)
;
;
;
(defun PlotSheet (EnameSheet / Ctb Plotter VarBkgp DataSheet FileName Stream itm EnameBlock LstEname Ssel p1 p2 dx dy PaperSize
								ObjDoc ObjPlot Lay Rtn)


		(if EnameSheet
			(progn

				(setq Ctb $HtmlCtbEasyCut)					; es	"monochrome.ctb"
				(setq Plotter $HtmlPlotterEasyCut)			; es	"PublishToWeb JPG.pc3"
				;(setq PaperSize $HtmlPaperSizeEasyCut)		; es	"UserDefinedRaster (1200.00 x 1600.00Pixels)"
				

				
				(setq VarBkgp (getvar "BACKGROUNDPLOT"))
				(setvar "BACKGROUNDPLOT" 0)
				
				(setq DataSheet (GetDataSheetByEname EnameSheet))
				(setq FileName  (strcat ECFileSheet$ "_" (nth 0 DataSheet)))
				(setq Stream (vl-directory-files (strcat HtmlStorageEasyCut$ ECFolderReport$) (strcat FileName "*")))
				
				(foreach itm Stream
					(vl-file-delete (strcat HtmlStorageEasyCut$ ECFolderReport$ itm))
				)
				
				;(setq EnameRule  (GetEnameRuleByEnameSheet EnameSheet))
				(setq EnameBlock (GetEnameBlockSheetById (GetIdSheet EnameSheet)))
				
				;(if EnameRule  (setq LstEname (append LstEname (list EnameRule))))
				(if EnameBlock (setq LstEname (append LstEname (list EnameBlock))))
				(if EnameSheet (setq LstEname (append LstEname (list EnameSheet))))
				
				(setq Ssel (LstEname->Ssget LstEname))
				(setq p1   (nth 0 (LM:SSBoundingBox Ssel)))
				(setq p2   (nth 2 (LM:SSBoundingBox Ssel)))
				
				

				; set point plot window +++++++++
				;(setq p1 (vlax-safearray->list mshape))
				;(setq p2 (vlax-safearray->list xshape))
				(setq dx (abs (- (nth 0 p2) (nth 0 p1))))
				(setq dy (abs (- (nth 1 p2) (nth 1 p1))))
				
				(if (< dx dy)
					(setq PaperSize "UserDefinedRaster (1200.00 x 1600.00Pixels)")
					(setq PaperSize "UserDefinedRaster (1600.00 x 1200.00Pixels)")
				)				
			
				(setq p1 (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (list (car p1) (cadr p1)))) 
				(setq p1 (vlax-make-variant p1 (logior vlax-vbarray vlax-vbDouble)))
				
				(setq p2 (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (list (car p2) (cadr p2)))) 
				(setq p2 (vlax-make-variant p2 (logior vlax-vbarray vlax-vbDouble)))
				

				(setq ObjDoc 	(vla-get-activedocument (vlax-get-acad-object)))
				(setq ObjPlot 	(vla-get-plot ObjDoc))
				(setq Lay 		(vla-get-activelayout ObjDoc))
			
				;(vla-put-PaperUnits         Lay "1")			;	set units to mm
				;(vla-put-PlotType           Lay "1")			;	"0"=display "1"=extend "2"=limits
				(vla-put-ConfigName          Lay Plotter)	    ;	set the plotter
				(vla-put-CanonicalMediaName  Lay PaperSize)		;	set the paper size
				(vla-put-CenterPlot          Lay :vlax-true)	;	:vlax-true=center plot :vlax-false=no center plot
				(vla-put-PlotWithLineweights Lay :vlax-false)	;	:vlax-true=turn on lineweights :vlax-false=turn off lineweights
				(vla-put-PlotWithPlotStyles  Lay :vlax-true)	;	:vlax-true=turn on plot styles :vlax-flase=turn off plot styles
				(vla-put-StandardScale       Lay "0")			;	fit to paper
				(vla-put-stylesheet          Lay Ctb)			;	set  the CTB
				(vla-SetWindowToPlot         Lay p1 p2)
				(vla-put-PlotType            Lay acWindow)
				
				(if (< dx dy)
					(vla-put-PlotRotation Lay ac0degrees)
					(vla-put-PlotRotation Lay ac0degrees)
				)				
				;(vla-put-PlotRotation ACADLayout ac0degrees)
				;(vla-put-PlotRotation ACADLayout ac180degrees)
				(vla-refreshplotdeviceinfo   Lay)
				
				(setq Rtn (vla-plottofile ObjPlot (strcat HtmlStorageEasyCut$ ECFolderReport$ FileName) Plotter))
				
				
				(if (= Rtn :vlax-true)
					(setq Rtn (strcat HtmlStorageEasyCut$ ECFolderReport$ (nth 0 (vl-directory-files (strcat HtmlStorageEasyCut$ ECFolderReport$) (strcat FileName ".*")))))
					(setq Rtn nil)
				)
				
				(setvar "BACKGROUNDPLOT" VarBkgp)
			)
		)
		Rtn
)		
;
;
;
(defun GetInfoImage (FileNameImage / ObjectImage EnameImage Rtn)
	
	;((-1 . <Nome entità: 1c6bf80cc00>)
	;(0 . "IMAGE")
	;(330 . <Nome entità: 1c6b8ada9f0>)
	;(5 . "EA8")
	;(100 . "AcDbEntity")
	;(67 . 0)
	;(410 . "Model")
	;(8 . "0")
	;(100 . "AcDbRasterImage")
	;(90 . 0)
	;(10 0.0 0.0 0.0)
	;(11 0.0370833 0.0 0.0)
	;(12 -3.83485e-15 0.0370833 0.0)
	;(13 1200.0 1600.0 0.0)
	;(340 . <Nome entità: 1c6bf80cc10>)
	;(70 . 7)
	;(280 . 0)
	;(281 . 50)
	;(282 . 50)
	;(283 . 0)
	;(290 . 0)
	;(360 . <Nome entità: 1c6bf80cc20>)
	;(71 . 1)
	;(91 . 2)
	;(14 -0.5 -0.5 0.0)
	;(14 1199.5 1599.5 0.0))	
	
	(if FileNameImage
		(if (findfile FileNameImage)
			(progn
				(setq	ObjectImage	(vlax-invoke
									(vlax-get (vla-get-ActiveLayout(vla-get-activedocument (vlax-get-acad-object))) 'Block)
									'AddRaster
									FileNameImage	
									'(0.0 0.0 0.0)
									44.5			;<-width
									0.0
								)
				)
				(if ObjectImage
					(progn
						(setq EnameImage (vlax-vla-object->ename ObjectImage))
						;(vla-put-name inimage "MyInsertedPicture") ;<-- Name 
						;(vla-update inimage)
						(setq Rtn (cdr (assoc 13 (entget EnameImage))))
						(vl-cmdf "_.-image" "_detach" (vla-get-name ObjectImage))
					)
				)
			)
		)
	)
	(list Rtn)
)
;
;
; (setq ad (vla-get-activedocument (vlax-get-acad-object)))
(defun GetCanonicalMediaNames (ad)
  (vla-RefreshPlotDeviceInfo
    (vla-get-activelayout ad))
  (vlax-safearray->list
    (vlax-variant-value
      (vla-GetCanonicalMediaNames
        (vla-item (vla-get-layouts ad) "Model"))))
)
;
;
;
(defun GetLocaleMediaNames (ad / mn mnl)
  (setq la (vla-item (vla-get-layouts ad) "Model"))
  (foreach mn (GetCanonicalMediaNames ad)
    (setq mnl (cons (vla-GetLocaleMediaName la mn) mnl))
  )
  (reverse mnl)
)
;
;
;
(defun GetPlotDevices (ad LstFilter / itm itm1 Rtn)

	(vla-RefreshPlotDeviceInfo (vla-get-activelayout ad))
	(setq LstDevice (vlax-safearray->list (vlax-variant-value (vla-getplotdevicenames (vla-item (vla-get-layouts ad) "Model")))))
	
	(if (= LstFilter "*")
		(setq Rtn LstDevice)
		(foreach itm LstDevice
			(foreach itm1 LstFilter
				(if (vl-string-search (strcase itm1) (strcase itm))
					(setq Rtn (append Rtn (list itm)))
				)
			)
		)
	)
	Rtn
)
;
;
; Plot Device in active Layout
(defun GetActivePlotDevice (ad)
  (vla-get-ConfigName
    (vla-get-ActiveLayout ad))
)
;
;
;
(defun GetPlotStyleTableNames (ad LstFilter / LstStyle Rtn itm itm1)
  
	(vla-RefreshPlotDeviceInfo (vla-get-activelayout ad))
	(setq LstStyle (vlax-safearray->list (vlax-variant-value (vla-getplotstyletablenames (vla-item (vla-get-layouts ad) "Model")))))
	
	(if (= LstFilter "*")
		(setq Rtn LstStyle)
		(foreach itm LstStyle
			(foreach itm1 LstFilter
				(if (vl-string-search (strcase itm1) (strcase itm))
					(setq Rtn (append Rtn (list itm)))
				)
			)
		)
	)
	Rtn  
  
)
;
;
;
(defun ListAllMediaNames(ad / al cn pd apmn)
  (setq al (vla-get-activelayout  ad))
  (setq cn (vla-get-configname al))
  (foreach pd (GetPlotDevices ad)
    (if (/= pd "None")
      (progn
        (vla-put-configname al pd)
        (setq apmn (cons pd apmn))
        (setq apmn (cons (GetCanonicalMediaNames ad) apmn))
      )
    )
  )
  (if (/= cn "None") (vla-put-configname al cn))
  (reverse apmn)
)
;
;
; (ListAllLocalMediaNames (vla-get-activedocument (vlax-get-acad-object)))
(defun ListAllLocalMediaNames(ad / al cn pd apmn)
  (setq al (vla-get-activelayout ad))
  (setq cn (vla-get-configname al))
  (foreach pd (GetPlotDevices ad)
    (if (/= pd "None")
      (progn
        (vla-put-configname al pd)
        (setq apmn (cons pd apmn))
        (setq apmn (cons (GetLocaleMediaNames ad) apmn))
      )
    )
  )
  (if (/= cn "None") (vla-put-configname al cn))
  (reverse apmn)
)
;
;
; (GetCanonicalMediaNamesOfConfigname ad "Acrobat PDFWriter")
(defun GetCanonicalMediaNamesOfConfigname(ad cn LstFilter / oldcn al cmn itm itm1 Rtn)

	(setq al (vla-get-ActiveLayout ad))
	(setq oldcn (vla-get-configname al))
	(vla-put-configname al cn)
	(vla-RefreshPlotDeviceInfo al)
	(setq cmn (GetCanonicalMediaNames ad))
	(if (/= oldcn "None") (vla-put-configname al oldcn))
  
	(if (= LstFilter "*")
		(setq Rtn cmn)
		(foreach itm cmn
			(foreach itm1 LstFilter
				(if (vl-string-search (strcase itm1) (strcase itm))	
					(setq Rtn (append Rtn (list itm)))
				)
			)
		)
	)
	Rtn
)
;
;
; (GetLocalMediaNamesOfConfigname ad "Acrobat PDFWriter")
(defun GetLocalMediaNamesOfConfigname(ad cn / oldcn al cmn)
  (setq al (vla-get-ActiveLayout ad))
  (setq oldcn (vla-get-configname al))
  (vla-put-configname al cn)
  (vla-RefreshPlotDeviceInfo al)
  (setq cmn (GetLocaleMediaNames ad))
  (if (/= oldcn "None") (vla-put-configname al oldcn))
  cmn
)
;
;
;

