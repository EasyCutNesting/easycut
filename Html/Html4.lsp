(defun ManagerReportSheet()
	
	(princ "\nCreate Html Report") (CreateHtmlReportCut)
	(princ "\nCreate Html Sheet")  (CreateHtmlSheetCut)
	(princ "\nCreate Html Shape")  (CreateHtmlShapeCut)
	(princ "\nCreate Html Tree")   (CreateHtmlTree)
	(if (findfile (strcat HtmlStorageEasyCut$ ECFileTree$ ".html")) 
		(DefaultBrowser (strcat HtmlStorageEasyCut$ ECFileTree$ ".html"))
	)
) 
;
;
;
(defun CreateHtmlTree (/ FileTree Stream)

		(setq FileTree (strcat HtmlStorageEasyCut$ ECFileTree$ ".html"))
		(setq Stream (open FileTree "w"))
		
		(princ "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//IT\" \"http://www.w3.org/TR/html4/frameset.dtd\">\n" Stream)
		(princ "<html>\n" Stream)
		(princ "<head>\n" Stream)
		(princ " <meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\">\n" Stream)
		(princ " <title>Manager Easy Cut</title>\n" Stream)
		(princ "</head>\n" Stream)
		(princ "<frameset cols=\"35%,35%,30%\">\n" Stream)
		(princ (strcat "	<frame src=\"" (vl-string-right-trim "\\" ECFolderReport$) "/"  ECFileReport$ ".html\">\n")  Stream)
		(princ (strcat "	<frame src=\"" (vl-string-right-trim "\\" ECFolderSheet$)  "/"  ECFileSheet$ ".html\">\n") Stream)
		(princ (strcat "	<frame src=\"" (vl-string-right-trim "\\" ECFolderShape$)  "/"  ECFileShape$ ".html\">\n") Stream)
		(princ "</frameset>\n" Stream)
		(princ "</html>\n" Stream)

		(close Stream)
)
;
;
;
(defun CheckFileSheetHtml (FileSheet / Stream Line Rtn)
	(if FileSheet
		(if (setq Stream (open FileSheet "r"))
			(if (setq Line (read-line Stream))
				; <!-- Sheet 09/12/2018|17:51|104625902|kkk|2500|2500|10|6.25|490.63|SSSS -->
				(if (= (substr Line 1 10 ) "<!-- Sheet")
					(if (setq Line (read-line Stream))
						; <!-- Shape C872|300|178-365|123456789|10|S355J0|1|667.5x290|15.2|15.2 -->
						(if (= (substr Line 1 10 ) "<!-- Shape")
							(setq Rtn T)
						)
					)
				)
			)
		)
	)
	(close Stream)
	Rtn
)
;
;
;
(defun CheckFileShapeCut (FileShape / Stream Line Rtn)
	(if FileShape
		(if (setq Stream (open FileShape "r"))
			(if (setq Line (read-line Stream))
				; <!-- Shape CE|406204838|2|178-364|1|1100|C872|300|S355J0|4|07/12/2018 -->
				(if (= (substr Line 1 10) "<!-- Shape")
					(setq Rtn T)
				)
			)
		)
	)
	(close Stream)
	Rtn
)
;
;
;
(defun CreateHtmlReportCut (/ Swap Color1 Color2 LstFileReport itm Stream Line
							  LstSplit LstDataSheet LstTimeSheet LstIdSheet LstNameSheet LstDimensionSheet 
							  LstThknessSheet LstSurfaceSheet LstWeightSheet LstMatSheet 	
							  FileReport RefClick WidthWeb HeightWeb TopWeb LeftWeb)



	(defun Swap (DatoA DatoB Indice / Rtn)
	
		(if (> (- (/ Indice 2.0) (fix (/ Indice 2.0))) 0)
			(setq Rtn DatoB)
			(setq Rtn DatoA)
		)
	)
	;
	;
	;
	(setq Color1 "#EDEDED")
	(setq Color2 "#DBDBDB")
	(setq WidthWeb	 	840)
	(setq HeightWeb 	500)
	(setq TopWeb 		10)
	(setq LeftWeb 		20)
	
	(setq LstFileReport (vl-directory-files (strcat HtmlStorageEasyCut$  ECFolderReport$) (strcat ECFileReport$ "_*.html") 1))
	(foreach itm LstFileReport
		(if (CheckFileSheetHtml (strcat HtmlStorageEasyCut$ ECFolderReport$ itm))
			(progn
				(setq Stream (open (strcat HtmlStorageEasyCut$ ECFolderReport$ itm) "r"))
				(setq Line (read-line Stream))	; <!-- Sheet 09/12/2018|17:51|104625902|kkk|2500|2500|10|6.25|490.63|SSSS -->
				(close Stream)
				;
				(setq Line (substr Line 12 (strlen Line)))
				(setq Line (substr line 1 (- (strlen Line) 4))) 
				(setq LstSplit (splitxt Line "|"))
				(setq LstDataSheet 			(append LstDataSheet 		(list (nth 0 LstSplit))))
				(setq LstTimeSheet 			(append LstTimeSheet 		(list (nth 1 LstSplit))))
				(setq LstIdSheet 			(append LstIdSheet 			(list (nth 2 LstSplit))))
				(setq LstNameSheet 			(append LstNameSheet 		(list (nth 3 LstSplit))))
				(setq LstDimensionSheet 	(append LstDimensionSheet 	(list (strcat (nth 4 LstSplit) "x" (nth 5 LstSplit)))))
				(setq LstThknessSheet 		(append LstThknessSheet 	(list (nth 6 LstSplit))))
				(setq LstSurfaceSheet 		(append LstSurfaceSheet 	(list (nth 7 LstSplit))))
				(setq LstWeightSheet 		(append LstWeightSheet 		(list (nth 8 LstSplit))))
				(setq LstMatSheet 			(append LstMatSheet 		(list (nth 9 LstSplit))))
			)
			(setq LstFileReport (vl-remove itm LstFileReport))
		)
	)
	;(princ "\n") (princ LstDataSheet)
	;(princ "\n") (princ LstTimeSheet)
	;(princ "\n") (princ LstIdSheet)
	;(princ "\n") (princ LstNameSheet)
	;(princ "\n") (princ LstDimensionSheet)
	;(princ "\n") (princ LstThknessSheet)
	;(princ "\n") (princ LstSurfaceSheet)
	;(princ "\n") (princ LstWeightSheet)
	;(princ "\n") (princ LstMatSheet)

	(setq FileReport (strcat HtmlStorageEasyCut$ ECFolderReport$ ECFileReport$ ".html"))
	(setq Stream (open FileReport "w"))
	(princ "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"	Stream)
	(princ "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n"																		Stream)
	(princ "<head>\n"																												Stream)
	(princ "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n"										Stream)
	(princ "<title>Untitled Document</title>\n"																						Stream)
	(princ "<style type=\"text/css\">	\n"																							Stream)		
	(princ "ul, #myUL {list-style-type:none;}\n" 																					Stream)
	(princ "#myUL {font-family:Arial;font-size:15px;margin:0;padding:0;}\n" 														Stream)
	(princ ".caret {font-family:Courier New;cursor:pointer;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;}\n" Stream)
	(princ ".caret::before {content:\"\\25B6\";color:black;display:inline-block;margin-right:6px;}\n" 								Stream)
	(princ ".caret-down::before {-ms-transform:rotate(90deg);-webkit-transform:rotate(90deg);transform:rotate(90deg);}\n" 			Stream)
	(princ ".nested {display:none;}\n" 																								Stream)
	(princ ".active {display:block;}\n" 																							Stream)
	(princ "</style>\n" 																											Stream)
	(princ (strcat "<script type=\"text/javascript\" src=\"" TmpScrHtmlEasyCut$ "tools01.js\"></script>\n")							Stream)			
	(princ "</head>\n"																												Stream)
	(princ "<body>\n" 																												Stream)
	(princ "	<ul id=\"myUL\">\n" 																								Stream)
	(princ "		<li><span class=\"caret\">Report Cut</span>\n" 																	Stream)
	(princ "			<ul class=\"nested\">\n" 																					Stream)
	
	(if LstIdSheet
		(progn
			(setq conta 0)
			(foreach itm LstFileReport	
				(setq RefClick (strcat "\"openWindow('" ECFileReport$ "_" (nth conta LstIdSheet) ".html'," 
								(rtos WidthWeb 2 0)		"," 
								(rtos HeightWeb 2 0) 	"," 
								(rtos TopWeb 2 0) 		"," 
								(rtos LeftWeb 2 0) 		",'" (nth conta LstIdSheet) "')"))
				
				(princ (strcat "				<li><span class=\"caret\" style=\"line-height:200%\">Report &nbsp;" 
												(nth conta LstIdSheet) "&nbsp;" (nth conta LstDataSheet) "&nbsp;" (nth conta LstTimeSheet) 
												"</span>\n") 																					Stream)
				(princ  (strcat "			<span><a href=\"#\" onClick=" RefClick "\">" (nth conta LstIdSheet) "</a></span>\n")				Stream)
				(princ 	"				<ul class=\"nested\" style=\"line-height:150%\">\n" 													Stream)
				(princ 	(strcat "					<table width=\"250px\"><tr bgcolor=\"" (Swap Color1 Color2 2)
						"\"><td width=\"50%\">Dimensione</td><td width=\"50%\">" (nth conta LstDimensionSheet) 	"&nbsp;[mm]</td></tr></table>\n") Stream)
				(princ 	(strcat "					<table width=\"250px\"><tr bgcolor=\"" (Swap Color1 Color2 3)
						"\"><td width=\"50%\">Spessore</td><td width=\"50%\">"	 (nth conta LstThknessSheet)	"&nbsp;[mm]</td></tr></table>\n") Stream)
				(princ 	(strcat "					<table width=\"250px\"><tr bgcolor=\"" (Swap Color1 Color2 4)
						"\"><td width=\"50%\">Suprficie</td><td width=\"50%\">"	 (nth conta LstSurfaceSheet)	"&nbsp;[mq]</td></tr></table>\n") Stream)
				(princ 	(strcat "					<table width=\"250px\"><tr bgcolor=\"" (Swap Color1 Color2 5)
					"\"><td width=\"50%\">Peso</td><td width=\"50%\">"			 (nth conta LstWeightSheet) 	"&nbsp;[kg]</td></tr></table>\n") Stream)
				(princ 	(strcat "					<table width=\"250px\"><tr bgcolor=\"" (Swap Color1 Color2 6)
					"\"><td width=\"50%\">Materiale</td><td width=\"50%\">"		 (nth conta LstMatSheet)		"</td></tr></table>\n") 		Stream)
				(princ 	"				</ul>\n" 																								Stream)
				(princ 	"				</li>\n" 																								Stream)
				(setq conta (1+ conta))
			)
		)
	)
	(princ "			</ul>\n" 																										Stream)
	(princ "		</li>\n" 																											Stream)
	(princ "	</ul>\n" 																												Stream)
	(princ "<script>\n" 																												Stream)
	(princ "var toggler = document.getElementsByClassName(\"caret\");\n" 																Stream)
	(princ "var i;\n" 																													Stream)
	;(princ "//https://www.w3schools.com/howto/howto_js_treeview.asp\n" 																	Stream)
	(princ "for (i = 0; i < toggler.length; i++) {\n" 																					Stream)
	(princ "  toggler[i].addEventListener(\"click\", function() {\n" 																	Stream)
	(princ "    this.parentElement.querySelector(\".nested\").classList.toggle(\"active\");\n" 											Stream)
	(princ "    this.classList.toggle(\"caret-down\");\n" 																				Stream)
	(princ "  });\n" 																													Stream)
	(princ "}\n" 																														Stream)
	(princ "</script>\n"																												Stream)
	(princ "</body>\n" 																													Stream)
	(princ "</html>\n" 																													Stream)
	(close Stream)
)
;
;
;
(defun CreateHtmlSheetCut (/ Swap Color1 Color2 WidthWeb HeightWeb TopWeb LeftWeb WidthWebSheet HeightWebSheet
							 FileReport Stream StreamR LstFileReport itm Line LstSplit
							 DataSheet TimeSheet IdSheet NameSheet DimensionSheet ThiknessSheet
				             SurfaceSheet WeightSheet MatSheet LstOrderShape LstPhaseShape
							 LstMarkShape LstIdShape LstThiknessShape LstMatShape LstQuantityShape
							 LstDimensionShape LstWeightShape LstTotWeightShape conta RefClick)


	(defun Swap (DatoA DatoB Indice / Rtn)
	
		(if (> (- (/ Indice 2.0) (fix (/ Indice 2.0))) 0)
			(setq Rtn DatoB)
			(setq Rtn DatoA)
		)
	)
	;
	; Main
	;
	(setq Color1 "#EDEDED")
	(setq Color2 "#DBDBDB")
	(setq WidthWeb	 	910)
	(setq HeightWeb 	590)
	(setq WidthWebSheet	 1100)
	(setq HeightWebSheet 720)
	(setq TopWeb 		10)
	(setq LeftWeb 		20)
	
	(setq FileReport (strcat HtmlStorageEasyCut$ ECFolderSheet$ ECFileSheet$ ".html"))
	(setq Stream (open FileReport "w"))
	(princ "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"	Stream)
	(princ "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n"																		Stream)
	(princ "<head>\n"																												Stream)
	(princ "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n"										Stream)
	(princ "<title>Untitled Document</title>\n"																						Stream)
	(princ "<style type=\"text/css\">	\n"																							Stream)		
	(princ "ul, #myUL {list-style-type:none;}\n" 																					Stream)
	(princ "#myUL {font-family:Arial;font-size:15px;margin:0;padding:0;}\n" 														Stream)
	(princ ".caret {font-family:Courier New;cursor:pointer;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;}\n" Stream)
	(princ ".caret::before {content:\"\\25B6\";color:black;display:inline-block;margin-right:6px;}\n" 								Stream)
	(princ ".caret-down::before {-ms-transform:rotate(90deg);-webkit-transform:rotate(90deg);transform:rotate(90deg);}\n" 			Stream)
	(princ ".nested {display:none;}\n" 																								Stream)
	(princ ".active {display:block;}\n" 																							Stream)
	(princ "</style>\n" 																											Stream)
	(princ (strcat "<script type=\"text/javascript\" src=\"" TmpScrHtmlEasyCut$ "tools01.js\"></script>\n")							Stream)				
	(princ "</head>\n"																												Stream)
	(princ "<body>\n" 																												Stream)
	(princ "	<ul id=\"myUL\">\n" 																								Stream)
	(princ "		<li><span class=\"caret\">Sheet List</span>\n" 																	Stream)
	(princ "		<ul class=\"nested\">\n" 																						Stream)
	
	(setq LstFileReport (vl-directory-files (strcat HtmlStorageEasyCut$  ECFolderReport$) (strcat ECFileReport$ "_*.html") 1))

	(foreach itm LstFileReport
		(if (CheckFileSheetHtml (strcat HtmlStorageEasyCut$ ECFolderReport$ itm))			
			(progn
				(setq StreamR (open (strcat HtmlStorageEasyCut$ ECFolderReport$ itm) "r"))
				(setq Line (read-line StreamR)) ; <!-- Sheet 09/12/2018|17:51|104625902|kkk|2500|2500|10|6.25|490.63|SSSS -->
				(setq Line (substr Line 12 (- (strlen Line) 4)))
				;(setq Line (substr Line 1 (- (strlen Line) 4))) 

				(setq LstSplit (splitxt Line "|"))
				(setq DataSheet 		(nth 0 LstSplit))
				(setq TimeSheet 		(nth 1 LstSplit))
				(setq IdSheet 			(nth 2 LstSplit))
				(setq NameSheet 		(nth 3 LstSplit))
				(setq DimensionSheet 	(strcat (nth 4 LstSplit) "x" (nth 5 LstSplit)))
				(setq ThiknessSheet 	(nth 6 LstSplit))
				(setq SurfaceSheet 		(nth 7 LstSplit))
				(setq WeightSheet 		(nth 8 LstSplit))
				(setq MatSheet 			(nth 9 LstSplit))
				
				(setq Line (read-line StreamR)) ;<!-- Shape C872|300|178-365|123456789|10|S355J0|1|667.5x290|15.2|15.2 -->
				(setq LstOrderShape		nil)
				(setq LstPhaseShape		nil)
				(setq LstMarkShape		nil)
				(setq LstIdShape		nil)
				(setq LstThiknessShape	nil)
				(setq LstMatShape		nil)
				(setq LstQuantityShape	nil)
				(setq LstDimensionShape	nil)
				(setq LstWeightShape	nil)
				(setq LstTotWeightShape	nil)

				(while (= (substr Line 1 10) "<!-- Shape")
					(setq Line (substr line 12 (- (strlen Line) 4))) 
					;(setq Line (substr line 1 (- (strlen Line) 4))) 

					(setq LstSplit 				(splitxt line "|"))
					(setq LstOrderShape 		(append LstOrderShape 		(list (nth 0 LstSplit))))
					(setq LstPhaseShape 		(append LstPhaseShape 		(list (nth 1 LstSplit))))
					(setq LstMarkShape 			(append LstMarkShape		(list (nth 2 LstSplit))))
					(setq LstIdShape 			(append LstIdShape			(list (nth 3 LstSplit))))
					(setq LstThiknessShape 		(append LstThiknessShape 	(list (nth 4 LstSplit))))
					(setq LstMatShape 			(append LstMatShape 		(list (nth 5 LstSplit))))
					(setq LstQuantityShape 		(append LstQuantityShape 	(list (nth 6 LstSplit))))
					(setq LstDimensionShape 	(append LstDimensionShape 	(list (nth 7 LstSplit))))
					(setq LstWeightShape 		(append LstWeightShape 		(list (nth 8 LstSplit))))
					(setq LstTotWeightShape 	(append LstTotWeightShape 	(list (nth 9 LstSplit))))
					(setq Line (read-line StreamR))
				)
				(close StreamR)
				
				(setq RefClick (strcat "\"openWindow('" ECFileSheet$ "_" IdSheet ".html'," 
									(rtos WidthWebSheet 2 0)		"," 
									(rtos HeightWebSheet 2 0) 	"," 
									(rtos TopWeb 2 0) 		"," 
									(rtos LeftWeb 2 0) 		",'" IdSheet "')"))
							
				(princ (strcat "			<li><span class=\"caret\" style=\"line-height:200%\">Sheet &nbsp;" 
													IdSheet "&nbsp;" DataSheet "&nbsp;" TimeSheet 
													"</span>\n")																				Stream)
				(princ (strcat "			<span><a href=\"#\" onClick=" RefClick "\">" IdSheet "</a></span>\n")								Stream)
				(princ "			<ul class=\"nested\">\n" 																					Stream)
				(setq conta 0)
		
				;(princ "\n")
				;(princ LstMarkShape)
				;(getstring " ")
		
				(foreach itm LstMarkShape
				
					(setq RefClick (strcat "\"openWindow('../" (vl-string-right-trim "\\" ECFolderShape$) "/" 
																ECFileShape$ "_" (nth conta LstIdShape) ".html'," 
									(rtos WidthWeb 2 0)		"," 
									(rtos HeightWeb 2 0) 	"," 
									(rtos TopWeb 2 0) 		"," 
									(rtos LeftWeb 2 0) 		",'" (nth conta LstIdShape) "')"))
				

					(princ (strcat "				<li><span class=\"caret\" style=\"line-height:200%\">Contorno &nbsp;" 
														(nth conta LstOrderShape) "&nbsp;" (nth conta LstPhaseShape) "&nbsp;" (nth conta LstMarkShape) 
														"</span>\n")																				Stream)
					(princ "				<ul class=\"nested\">\n" 																				Stream)

				
					(princ 	"					<table width=\"250px\">\n" 																			Stream)
					(princ 	(strcat "						<tr bgcolor=\"" (Swap Color1 Color2 1) "\">\n")											Stream)
					(princ 	"							<td width=\"50%\">Shape &nbsp;id</td>\n" 													Stream)
					(princ 	(strcat "							<td width=\"50%\"><a href=\"#\" onClick=" RefClick "\">" (nth conta LstIdShape) "</td>\n") 	Stream)
					(princ 	"						</tr>\n" 																						Stream)
					(princ 	"					</table>\n" 																						Stream)
				

					(princ 	(strcat "					<table width=\"250px\"><tr bgcolor=\"" (Swap Color1 Color2 2)
														"\"><td width=\"50%\">Spessore</td><td width=\"50%\">"    	 (nth conta LstThiknessShape)
														"&nbsp;[mm]</td></tr></table>\n")															Stream)
					(princ 	(strcat	"					<table width=\"250px\"><tr bgcolor=\"" (Swap Color1 Color2 3)
														"\"><td width=\"50%\">Materiale</td><td width=\"50%\">"     (nth conta LstMatShape)
														"</td></tr></table>\n") 																	Stream)
					(princ 	(strcat	"					<table width=\"250px\"><tr bgcolor=\"" (Swap Color1 Color2 4)
														"\"><td width=\"50%\">Quantita</td><td width=\"50%\">" 		(nth conta LstQuantityShape)
														"</td></tr></table>\n") 																	Stream)
					(princ 	(strcat	"					<table width=\"250px\"><tr bgcolor=\"" (Swap Color1 Color2 5)
														"\"><td width=\"50%\">Dimensione</td><td width=\"50%\">" 	(nth conta LstDimensionShape)
														"&nbsp;[mm]</td></tr></table>\n")															Stream)
					(princ 	(strcat	"					<table width=\"250px\"><tr bgcolor=\"" (Swap Color1 Color2 6)
														"\"><td width=\"50%\">Peso</td><td width=\"50%\">"         	(nth conta LstWeightShape)
														"&nbsp;[kg]</td></tr></table>\n")															Stream)
					(princ 	(strcat	"					<table width=\"250px\"><tr bgcolor=\"" (Swap Color1 Color2 7)
														"\"><td width=\"50%\">Peso totale</td><td width=\"50%\">"	(nth conta LstTotWeightShape)
														"&nbsp;[kg]</td></tr></table>\n")															Stream)
					(princ 	"			</ul>\n" 																									Stream)
					(princ 	"			</li>\n" 																									Stream) 
					(setq conta (1+ conta))
				)
				(princ 	"		</ul>\n" 																											Stream)
				(princ 	"		</li>\n" 																											Stream)
			)
		)
	)
	(princ 	"	</ul>\n" 																													Stream)
	(princ 	"	</ul>\n" 																													Stream)
	(princ "<script>\n" 																													Stream)
	(princ "var toggler = document.getElementsByClassName(\"caret\");\n" 																	Stream)
	(princ "var i;\n" 																														Stream)
	;(princ "//https://www.w3schools.com/howto/howto_js_treeview.asp\n" 																		Stream)
	(princ "for (i = 0; i < toggler.length; i++) {\n" 																						Stream)
	(princ "  toggler[i].addEventListener(\"click\", function() {\n" 																		Stream)
	(princ "    this.parentElement.querySelector(\".nested\").classList.toggle(\"active\");\n" 												Stream)
	(princ "    this.classList.toggle(\"caret-down\");\n" 																					Stream)
	(princ "  });\n" 																														Stream)
	(princ "}\n" 																															Stream)
	(princ "</script>\n"																													Stream)
	(princ "</body>\n" 																														Stream)
	(princ "</html>\n" 																														Stream)
	(close Stream)
)
;
;
;
(defun CreateHtmlShapeCut (/ Swap GetLstPhaseShape GetLstNameShape GetLstInfoShape   
							 Color1 Color2 WidthWeb HeightWeb TopWeb LeftWeb 
							 FileReport Stream Line
							 LstSplit TypShape IdShape JouShape NameShape CutShape LenghtCutShape 
							 OrderShape PhaseShape MatShape ThikShape DateShape
							 LstOrderShape LstTmp LstPhaseShape VarDinamicNameShape VarDinamicInfoShape
							 LstVarDinamicNameShape LstVarDinamicInfoShape
							 VarNameShape VarInfoShape Order Phase Name Info RefClick)

							 

	(defun Swap (DatoA DatoB Indice / Rtn)
	
		(if (> (- (/ Indice 2.0) (fix (/ Indice 2.0))) 0)
			(setq Rtn DatoB)
			(setq Rtn DatoA)
		)
	)

	(defun GetLstPhaseShape (OrderShape DbLstPhaseShape)
		(if (and OrderShape DbLstPhaseShape)
			(if (assoc OrderShape DbLstPhaseShape)
				(cadr (assoc OrderShape DbLstPhaseShape))
			)
		)
	)

	(defun GetLstNameShape  (OrderShape PhaseShape)
		(if (and OrderShape PhaseShape)
			(vl-symbol-value (read (strcat VarNameShape "_" OrderShape "_" PhaseShape)))
		)
	)

	(defun GetLstInfoShape  (OrderShape PhaseShape NameShape)
		(if (and OrderShape PhaseShape NameShape)
			 (cadr (assoc NameShape (vl-symbol-value (read (strcat VarInfoShape "_" OrderShape "_" PhaseShape)))))
		)
	)
	;
	;
	;
	(setq Color1 "#EDEDED")
	(setq Color2 "#DBDBDB")
	(setq WidthWeb	 	910)
	(setq HeightWeb 	590)
	(setq TopWeb 		10)
	(setq LeftWeb 		20)
	(setq VarNameShape	"DbLstNameShape")
	(setq VarInfoShape	"DbLstInfoShape")
	
	(setq LstFileReport (vl-directory-files (strcat HtmlStorageEasyCut$  ECFolderShape$) (strcat ECFileShape$ "_*.html") 1))

	(foreach itm LstFileReport
		(if (CheckFileShapeCut (strcat HtmlStorageEasyCut$ ECFolderShape$ itm))
			(progn
				(setq Stream (open (strcat HtmlStorageEasyCut$ ECFolderShape$ itm) "r"))
				(setq Line (read-line Stream)) ;<!-- Shape CE|406204838|2|178-364|1|1100|C872|300|S355J0|4|07/12/2018 -->
				(close Stream)

				(setq Line (substr Line 12 (- (strlen Line) 4)))
				;(setq Line (substr Line 1 (- (strlen Line) 4)))
				
				(setq LstSplit 		(splitxt line "|"))
				(setq TypShape			(nth 0 LstSplit))
				(setq IdShape 			(nth 1 LstSplit))
				(setq JouShape 			(nth 2 LstSplit))
				(setq NameShape 		(nth 3 LstSplit))
				(setq CutShape 			(nth 4 LstSplit))
				(setq LenghtCutShape 	(nth 5 LstSplit))
				(setq OrderShape 		(nth 6 LstSplit))
				(setq PhaseShape 		(nth 7 LstSplit))
				(setq MatShape 			(nth 8 LstSplit))
				(setq ThikShape 		(nth 9 LstSplit))
				(setq DateShape 		(nth 10 LstSplit))

				; aggiornamento lista commesse ++++++++++++++++++
				
				(if (not (member OrderShape LstOrderShape))
						(setq LstOrderShape (append LstOrderShape (list OrderShape)))
				)
				
				; aggiornamento lista fase ++++++++++++++++++++++
				
				(if (assoc OrderShape LstPhaseShape)
					(if (not (member PhaseShape (cadr (assoc OrderShape LstPhaseShape))))
						(progn
							(setq LstTmp (append (cadr (assoc OrderShape LstPhaseShape)) (list PhaseShape)))
							(setq LstTmp (list OrderShape LstTmp))
							(setq LstPhaseShape (subst LstTmp (assoc OrderShape LstPhaseShape) LstPhaseShape))
						)
					)
					(setq LstPhaseShape (append LstPhaseShape (list (list OrderShape (list PhaseShape)))))
				)
				
				; aggiornamento lista dinamica nome marca +++++++++++++
				
				(setq VarDinamicNameShape (strcat VarNameShape "_" OrderShape "_" PhaseShape))
				(if (not (member VarDinamicNameShape LstVarDinamicNameShape))
					(setq LstVarDinamicNameShape (append LstVarDinamicNameShape (list VarDinamicNameShape)))
				)
				(if (not (boundp (read VarDinamicNameShape)))
					(set (read VarDinamicNameShape) (list NameShape))
					(progn
						(if (not (member NameShape (vl-symbol-value (read VarDinamicNameShape))))
							(progn
								(setq LstTmp (append (vl-symbol-value (read VarDinamicNameShape)) (list NameShape)))
								(set (read VarDinamicNameShape) LstTmp)
								
							)
						)
					)
				)
				;(getstring "<>")
				;(princ VarDinamicNameShape)
				;(getstring "<>")
				
				; aggiornamento lista dinamica info marca ++++++++
				
				(setq VarDinamicInfoShape (strcat VarInfoShape "_" OrderShape "_" PhaseShape))
				(if (not (member VarDinamicinfoShape LstVarDinamicinfoShape))
					(setq LstVarDinamicInfoShape (append LstVarDinamicInfoShape (list VarDinamicInfoShape)))
				)
				(if (not (boundp (read VarDinamicInfoShape)))
					(set (read VarDinamicInfoShape) (list (list NameShape 
														  (list TypShape IdShape JouShape CutShape LenghtCutShape MatShape ThikShape DateShape))))
					(progn
						(if (not (member NameShape (vl-symbol-value (read VarDinamicInfoShape))))
							(progn
								(setq LstTmp (append (vl-symbol-value (read VarDinamicInfoShape)) 
													(list (list NameShape 
														  (list TypShape IdShape JouShape CutShape LenghtCutShape MatShape ThikShape DateShape)))))
								(set (read VarDinamicInfoShape) LstTmp)
								
							)
						)

					)
				)
			)
		)
	)
	;
	; Ordinamento ++++++++++++
	;
	; Commessa
	(setq LstOrderShape (vl-sort LstOrderShape '<))
	; Fase
	(foreach itm LstPhaseShape
		(setq LstPhaseShape (subst (list (car itm) (vl-sort (cadr itm) '<)) itm LstPhaseShape))
	)
	; Marca
	(foreach itm LstVarDinamicNameShape
		(set (read itm) (vl-sort (vl-symbol-value (read itm)) '<))
	)
	;
	;(princ "\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
	;(princ "\nLstOrderShape ") (princ LstOrderShape)
	;(foreach Order LstOrderShape
	;	(princ "\nOrder ") (princ Order)
	;	(setq LstPhase (GetLstPhaseShape Order LstPhaseShape))
	;	(foreach Phase LstPhase
	;		(princ "\nPhase ") (princ Phase)
	;		(setq LstNameShape (GetLstNameShape Order Phase))
	;		(princ "\nLstNameShape ") (princ LstNameShape)
	;		(foreach Name LstNameShape
	;			(princ "\n") (princ (GetLstInfoShape Order Phase Name))
	;		)
	;	)
	;)
	;(princ "\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
	;
	;
	;
	(setq FileReport (strcat HtmlStorageEasyCut$ ECFolderShape$ ECFileShape$ ".html"))
	(setq Stream (open FileReport "w"))
	(princ "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"	Stream)
	(princ "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n"																		Stream)
	(princ "<head>\n"																												Stream)
	(princ "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n"										Stream)
	(princ "<title>Untitled Document</title>\n"																						Stream)
	(princ "<style type=\"text/css\">	\n"																							Stream)		
	(princ "ul, #myUL {list-style-type:none;}\n" 																					Stream)
	(princ "#myUL {font-family:Arial;font-size:15px;margin:0;padding:0;}\n" 														Stream)
	(princ ".caret {font-family:Courier New;cursor:pointer;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;}\n" Stream)
	(princ ".caret::before {content:\"\\25B6\";color:black;display:inline-block;margin-right:6px;}\n" 								Stream)
	(princ ".caret-down::before {-ms-transform:rotate(90deg);-webkit-transform:rotate(90deg);transform:rotate(90deg);}\n" 			Stream)
	(princ ".nested {display:none;}\n" 																								Stream)
	(princ ".active {display:block;}\n" 																							Stream)
	(princ "</style>\n" 																											Stream)
	(princ (strcat "<script type=\"text/javascript\" src=\"" TmpScrHtmlEasyCut$ "tools01.js\"></script>\n")							Stream)				
	(princ "</head>\n"																												Stream)
	(princ "<body>\n" 																												Stream)
	(princ "	<ul id=\"myUL\">\n" 																								Stream)
	(princ "		<li><span class=\"caret\">Shape List</span>\n" 																	Stream)
	(princ "		<ul class=\"nested\">\n" 																						Stream)
	
	(foreach Order LstOrderShape
	
		(princ (strcat "			<li><span class=\"caret\" style=\"line-height:200%\">" Order "</span>\n")						Stream)
		(princ "			<ul class=\"nested\">\n" 																				Stream)
		
		(foreach Phase (GetLstPhaseShape Order LstPhaseShape)	
			(princ (strcat "			<li><span class=\"caret\" style=\"line-height:200%\">" Phase "</span>\n")					Stream)
			(princ "			<ul class=\"nested\">\n" 																			Stream)
				
			(setq conta 1)
			(foreach Name (GetLstNameShape Order Phase)
			
				(setq Info (GetLstInfoShape Order Phase Name))
				;(CE 350450587 2 1 1850 S355J0 10 08/12/2018)
				
				(setq RefClick (strcat "\"openWindow('" ECFileShape$ "_" (nth 1 Info) ".html'," 
							(rtos WidthWeb 2 0)		"," 
							(rtos HeightWeb 2 0) 	"," 
							(rtos TopWeb 2 0) 		"," 
							(rtos LeftWeb 2 0) 		",'" (nth 1 Info) "')"))

				;(princ (strcat "			<li><span class=\"caret\" style=\"line-height:200%\">" Name "</span>\n")				Stream)
				(princ "			<li>\n"																							Stream)
				(princ  (strcat "			<span><a href=\"#\" onClick=" RefClick "\">" Name "</a></span>\n")						Stream)				
				(princ 	"			</li>\n" 																						Stream) 
				
			)
			(princ 	"			</ul>\n" 																							Stream)
			(princ 	"			</li>\n" 																							Stream) 
		)
		(princ 	"			</ul>\n" 																								Stream)
		(princ 	"			</li>\n" 																								Stream) 
	)
	(princ "	  </ul>\n"																											Stream)
	(princ "	  </li>\n" 																											Stream)
	(princ "	  </ul>\n"																											Stream)

	(princ "<script>\n" 																											Stream)
	(princ "var toggler = document.getElementsByClassName(\"caret\");\n" 															Stream)
	(princ "var i;\n" 																												Stream)
	;(princ "//https://www.w3schools.com/howto/howto_js_treeview.asp\n" 																Stream)
	(princ "for (i = 0; i < toggler.length; i++) {\n" 																				Stream)
	(princ "  toggler[i].addEventListener(\"click\", function() {\n" 																Stream)
	(princ "    this.parentElement.querySelector(\".nested\").classList.toggle(\"active\");\n" 										Stream)
	(princ "    this.classList.toggle(\"caret-down\");\n" 																			Stream)
	(princ "  });\n" 																												Stream)
	(princ "}\n" 																													Stream)
	(princ "</script>\n"																											Stream)
	(princ "</body>\n" 																												Stream)
	(princ "</html>\n" 																												Stream)
	(close Stream)
	;
	; Reset Var
	;
	(foreach itm LstVarDinamicNameShape
		(set (read itm) nil)
	)
	(foreach itm LstVarDinamicInfoShape
		(set (read itm) nil)
	)
)
;
;
;
(defun UpdatePreviewShapeHtml (/ Swap GetLstPhaseShape GetLstNameShape GetLstInfoShape
								VarNameShape VarInfoShape LstFileReport itm Stream Line LstSplit
								TypShape IdShape JouShape NameShape CutShape LenghtCutShape
								OrderShape PhaseShape MatShape ThikShape DateShape LstTmp LstPhaseShape
								VarDinamicNameShape LstVarDinamicNameShape VarDinamicInfoShape LstVarDinamicinfoShape
								LstOrderShape FileReport Order Phase Name Info RefClick conta Num SplitMk MkShape)

	(defun Swap (DatoA DatoB Indice / Rtn)
	
		(if (> (- (/ Indice 2.0) (fix (/ Indice 2.0))) 0)
			(setq Rtn DatoB)
			(setq Rtn DatoA)
		)
	)
	;
	;
	(defun GetLstPhaseShape (OrderShape DbLstPhaseShape)
		(if (and OrderShape DbLstPhaseShape)
			(if (assoc OrderShape DbLstPhaseShape)
				(cadr (assoc OrderShape DbLstPhaseShape))
			)
		)
	)
	;
	;
	(defun GetLstNameShape (OrderShape PhaseShape)
		(if (and OrderShape PhaseShape)
			(vl-symbol-value (read (strcat VarNameShape "_" OrderShape "_" PhaseShape)))
		)
	)
	;
	;
	(defun GetLstInfoShape (OrderShape PhaseShape NameShape)
		(if (and OrderShape PhaseShape NameShape)
			 (cadr (assoc NameShape (vl-symbol-value (read (strcat VarInfoShape "_" OrderShape "_" PhaseShape)))))
		)
	)
	;
	;
	;
	(setq VarNameShape	"DbLstNameShape")
	(setq VarInfoShape	"DbLstInfoShape")
	
	(setq LstFileReport (vl-directory-files (strcat HtmlStorageEasyCut$  ECFolderShapePreview$) (strcat ECFileShape$ "_*.html") 1))

	(if LstFileReport
		(progn
			(foreach itm LstFileReport
				(if (CheckFileShapeCut (strcat HtmlStorageEasyCut$ ECFolderShapePreview$ itm))
					(progn
						(setq Stream (open (strcat HtmlStorageEasyCut$ ECFolderShapePreview$ itm) "r"))
						(setq Line (read-line Stream)) ; <!-- Shape CE|406204838|2|178-364|1|1100|C872|300|S355J0|4|07/12/2018 -->
						(close Stream)
						(setq Line (substr Line 12 (- (strlen Line) 4))) 
						;(setq Line (substr Line 1 (- (strlen Line) 4))) 
						(setq LstSplit 		(splitxt line "|"))
						(setq TypShape			(nth 0 LstSplit))
						(setq IdShape 			(nth 1 LstSplit))
						(setq JouShape 			(nth 2 LstSplit))
						(setq NameShape 		(nth 3 LstSplit)) 	(setq NameShape (strcat IdShape "_" NameShape))
						(setq CutShape 			(nth 4 LstSplit))
						(setq LenghtCutShape 	(nth 5 LstSplit))
						(setq OrderShape 		(nth 6 LstSplit))
						(setq PhaseShape 		(nth 7 LstSplit))
						(setq MatShape 			(nth 8 LstSplit))
						(setq ThikShape 		(nth 9 LstSplit))
						(setq DateShape 		(nth 10 LstSplit))

						; aggiornamento lista commesse ++++++++++++++++++
						
						(if (not (member OrderShape LstOrderShape))
								(setq LstOrderShape (append LstOrderShape (list OrderShape)))
						)
						
						; aggiornamento lista fase ++++++++++++++++++++++
						
						(if (assoc OrderShape LstPhaseShape)
							(if (not (member PhaseShape (cadr (assoc OrderShape LstPhaseShape))))
								(progn
									(setq LstTmp (append (cadr (assoc OrderShape LstPhaseShape)) (list PhaseShape)))
									(setq LstTmp (list OrderShape LstTmp))
									(setq LstPhaseShape (subst LstTmp (assoc OrderShape LstPhaseShape) LstPhaseShape))
								)
							)
							(setq LstPhaseShape (append LstPhaseShape (list (list OrderShape (list PhaseShape)))))
						)

						; aggiornamento lista dinamica nome marca +++++++++++++
						
						(setq VarDinamicNameShape (strcat VarNameShape "_" OrderShape "_" PhaseShape))
						(if (not (member VarDinamicNameShape LstVarDinamicNameShape))
							(setq LstVarDinamicNameShape (append LstVarDinamicNameShape (list VarDinamicNameShape)))
						)
						(if (not (boundp (read VarDinamicNameShape)))
							(set (read VarDinamicNameShape) (list NameShape))
							(progn
								(if (not (member NameShape (vl-symbol-value (read VarDinamicNameShape))))
									(progn
										(setq LstTmp (append (vl-symbol-value (read VarDinamicNameShape)) (list NameShape)))
										(set (read VarDinamicNameShape) LstTmp)
										
									)
								)
							)
						)
						
						; aggiornamento lista dinamica info marca ++++++++
						
						(setq VarDinamicInfoShape (strcat VarInfoShape "_" OrderShape "_" PhaseShape))
						(if (not (member VarDinamicinfoShape LstVarDinamicinfoShape))
							(setq LstVarDinamicInfoShape (append LstVarDinamicInfoShape (list VarDinamicInfoShape)))
						)
						(if (not (boundp (read VarDinamicInfoShape)))
							(set (read VarDinamicInfoShape) (list (list NameShape 
																  (list TypShape IdShape JouShape CutShape LenghtCutShape MatShape ThikShape DateShape))))
							(progn
								(if (not (member NameShape (vl-symbol-value (read VarDinamicInfoShape))))
									(progn
										(setq LstTmp (append (vl-symbol-value (read VarDinamicInfoShape)) 
															(list (list NameShape 
																  (list TypShape IdShape JouShape CutShape LenghtCutShape MatShape ThikShape DateShape)))))
										(set (read VarDinamicInfoShape) LstTmp)
										
									)
								)

							)
						)
					)
				)
			)
			;
			; Ordinamento ++++++++++++
			;
			; Commessa
			(setq LstOrderShape (vl-sort LstOrderShape '<))
			; Fase
			(foreach itm LstPhaseShape
				(setq LstPhaseShape (subst (list (car itm) (vl-sort (cadr itm) '<)) itm LstPhaseShape))
			)
			;(princ "\n********")
			;(princ LstPhaseShape)
			;(princ "\n********")
			; Marca
			(foreach itm LstVarDinamicNameShape
				(set (read itm) (vl-sort (vl-symbol-value (read itm)) '<))
			)
			;
			;
			;
			(setq FileReport (strcat HtmlStorageEasyCut$ ECFolderShapePreview$ ECFileShape$ ".html"))
			(setq Stream (open FileReport "w"))
			(princ "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"	Stream)
			(princ "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n"																		Stream)
			(princ "<head>\n"																												Stream)
			(princ "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n"										Stream)
			(princ "<title>Untitled Document</title>\n"																						Stream)
			(princ "<style type=\"text/css\">	\n"																							Stream)		
			(princ "ul, #myUL {list-style-type:none;}\n" 																					Stream)
			(princ "#myUL {font-family:Arial;font-size:15px;margin:0;padding:0;}\n" 														Stream)
			(princ "#myUL li a{padding: 3px 0; display: block; text-transform: uppercase;}\n" 												Stream)
			(princ "#myUL .caret1{color: red;   font-weight: bold;}\n"				 														Stream)
			(princ "#myUL .caret2{color: blue;  font-weight: bold;}\n" 																		Stream)
			(princ "#myUL .caret3{color: green; font-weight: bold;}\n" 																		Stream)		
			(princ ".caret {font-family:Arial;cursor:pointer;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;}\n" Stream)
			(princ ".caret::before {content:\"\\25B6\";color:black;display:inline-block;margin-right:6px;}\n" 								Stream)
			(princ ".caret-down::before {-ms-transform:rotate(90deg);-webkit-transform:rotate(90deg);transform:rotate(90deg);}\n" 			Stream)
			(princ ".nested {display:none;}\n" 																								Stream)
			(princ ".active {display:block;}\n" 																							Stream)
			(princ ".flagview  	{border:red 1px solid;padding:5px;width:270px;height:518px;margin-top:60px;float:left;overflow: auto;}\n" 	Stream)
			(princ ".preview  	{float:left;}\n" 																							Stream)
			(princ "a 			{text-decoration: none; font-family:Arial;color: black;}\n" 												Stream)
			(princ "</style>\n" 																											Stream)
			(princ "</head>\n"																												Stream)
			(princ "<body>\n" 																												Stream)
			(princ "<div class=\"flagview\" align=\"left\">\n"																				Stream)	
			(princ "	  <ul id=\"myUL\">\n" 																								Stream)
			(princ "		  <li><span class=\"caret caret1\">Shape List</span>\n" 														Stream)
			(princ "		  <ul class=\"nested\">\n" 																						Stream)
			
			(foreach Order LstOrderShape

				;(princ (strcat "\n Order " Order))
			
				(princ (strcat "			<li><span class=\"caret caret2\" style=\"line-height:200%\">" Order "</span>\n")				Stream)
				(princ "			<ul class=\"nested\">\n" 																				Stream)
				
				;(foreach Phase (GetLstPhaseShape OrderShape LstPhaseShape)	
				(foreach Phase (GetLstPhaseShape Order LstPhaseShape)
				
					;(princ (strcat "\n Phase " Phase))
					
					(princ (strcat "			<li><span class=\"caret caret3\" style=\"line-height:200%\">" Phase "</span>\n")			Stream)
					(princ "			<ul class=\"nested\">\n" 																			Stream)
						
					(setq conta 1)
					(foreach Name (GetLstNameShape Order Phase)
					
						;(princ (strcat "\n Name " Name))
						
						(setq Info (GetLstInfoShape Order Phase Name))
						;(CE 350450587 2 1 1850 S355J0 10 08/12/2018)
						
						; +++++++++++++++++++++++++++++++++++++++++++
						(setq Num 1)
						(setq SplitMk (splitxt Name "_"))
						(setq MkShape "")
						(if (> (length SplitMk) 1)
							(repeat (- (length SplitMk) 1)
								(if (= MkShape "")
									(setq MkShape (strcat MkShape (nth Num SplitMk)))
									(setq MkShape (strcat MkShape "_" (nth Num SplitMk)))
								)
								(setq Num (1+ Num))
							)
							(setq MkShape (nth 1 SplitMk))
						)
						; +++++++++++++++++++++++++++++++++++++++++++
						
						;(setq RefClick (strcat "<a href=\"" ECFileShape$ "_" (nth 1 Info) ".html\" target=\"canvas\">" Name "</a>"))
						;(setq RefClick (strcat "<a href=\"" ECFileShape$ "_" (nth 1 Info) ".html\" target=\"canvas\">" (nth 1 (splitxt Name "_")) "</a>"))
						(setq RefClick (strcat "<a href=\"" ECFileShape$ "_" (nth 1 Info) ".html\" target=\"canvas\">" MkShape "</a>"))
						(if (= conta 1) (setq StartName (strcat  ECFileShape$ "_" (nth 1 Info) ".html")))

						;<a href="..\01ShapePreview\Shape_023087507.html" target="canvas">178-350</a>
						(princ "			<li>\n"																							Stream)
						(princ  (strcat "			<span>" RefClick "</span>\n")															Stream)				
						(princ 	"			</li>\n" 																						Stream) 
						
					)
					(princ 	"			</ul>\n" 																							Stream)
					(princ 	"			</li>\n" 																							Stream) 
				)
				(princ 	"			</ul>\n" 																								Stream)
				(princ 	"			</li>\n" 																								Stream) 
			)
			(princ "	  </ul>\n"																											Stream)
			(princ "	  </li>\n" 																											Stream)
			(princ "	  </ul>\n"																											Stream)
			(princ "	  </div>\n"																											Stream)
			(princ "	  <div class=\"preview\" align=\"left\">\n"																			Stream)
			(princ 		  (strcat "<iframe name=\"canvas\" src=\"" StartName    "\"\n")														Stream)
			(princ "			  height=\"590\" width=\"910\" frameborder=\"0\">\n"														Stream)
			(princ "	  </iframe>\n"																										Stream)
			(princ "      </div>\n"																											Stream)

			(princ "<script>\n" 																											Stream)
			(princ "var toggler = document.getElementsByClassName(\"caret\");\n" 															Stream)
			(princ "var i;\n" 																												Stream)
			;(princ "//https://www.w3schools.com/howto/howto_js_treeview.asp\n" 																Stream)
			(princ "for (i = 0; i < toggler.length; i++) {\n" 																				Stream)
			(princ "  toggler[i].addEventListener(\"click\", function() {\n" 																Stream)
			(princ "    this.parentElement.querySelector(\".nested\").classList.toggle(\"active\");\n" 										Stream)
			(princ "    this.classList.toggle(\"caret-down\");\n" 																			Stream)
			(princ "  });\n" 																												Stream)
			(princ "}\n" 																													Stream)
			(princ "</script>\n"																											Stream)
			(princ "</body>\n" 																												Stream)
			(princ "</html>\n" 																												Stream)
			(close Stream)
			;
			; Reset Var
			;
			(foreach itm LstVarDinamicNameShape
				(set (read itm) nil)
			)
			(foreach itm LstVarDinamicInfoShape
				(set (read itm) nil)
			)
		)
	)
	FileReport
)
;
;
;
(defun ViewHtmlPage01 (FileIn  Title Sep / FileOut LstRow)

		
		(setq FileOut 	(strcat HtmlStorageEasyCut$ ECFolderShapePreview$ "list.html"))
		(vl-file-delete  FileOut)
		(setq LstRow 	(ReadFileNesting FileIn Sep))
		(HtmlPage01 FileOut LstRow Title)
		(if (findfile FileOut)
			(DefaultBrowser FileOut)
		)
		
)
;
;
;
(defun HtmlPage01 (FileOut LstRow Title / WriteHead WriteBody Stream)

	(defun WriteHead (Stream)
		(if Stream
			(progn
				(princ "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n" Stream)
				(princ "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n" 												Stream)
				(princ "<head>\n" 																						Stream)
				(princ "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n" 				Stream)
				(princ "<title>Untitled Document</title>\n" 															Stream)
				(princ "<style type=\"text/css\">\n" 																	Stream)
				(princ ".wrapper{width:100%;margin-left:auto;margin-right:auto;font-family:Arial;}\n" 					Stream)
				(princ ".print {width:100%;height:25px;}\n" 															Stream)
				(princ ".title {font-size:20px;width:100%;height:25px;}\n" 												Stream)
				(princ ".sequence {margin-top:30px;font-size:20px;width:100%;height:25px;}\n" 							Stream)
				(princ ".infosequencelist {margin-top: 5px;width: 100%;}\n" 											Stream)
				(princ ".td {font-size: 9pt;}\n" 																		Stream)
				(princ "@page {size: 210mm 297mm; margin: 5mm;}\n" 														Stream)
				(princ "tr {page-break-inside: avoid;}\n" 																Stream)
				(princ "</style>\n" 																					Stream)
				(princ (strcat "<script type=\"text/javascript\" src=\"" TmpScrHtmlEasyCut$ "tools01.js\"></script>\n")	Stream)
				(princ "</head>\n" 																						Stream)
			)
		)
	)
	;
	;
	;
	(defun WriteBody (Title LstRow Stream / Color1 Color2 itm itm1 TitleHtml TitleSplit conta)
		
		(setq Color1 "#DBDBDB")
		(setq Color2 "#EDEDED")
	
		(if (and Title LstRow Stream)
			(progn
				(setq TitleHtml "")
				(setq TitleSplit (Splitxt Title " "))
				(foreach itm TitleSplit
					(setq TitleHtml (strcat TitleHtml itm "  &nbsp;"))
				)
				(setq TitleHtml (strcat TitleHtml (Today) "  &nbsp;"))
				(setq TitleHtml (strcat TitleHtml (Time)  "  &nbsp;"))
				(princ "<body>" Stream)
				(princ "	<div class=\"wrapper\" align=\"center\">\n" 										Stream)
				(princ "		<div class=\"print\" align=\"left\">\n" 										Stream)
				(princ "			<button onclick=\"myFunction()\">Stampa</button>\n" 						Stream)
				(princ "		</div>\n" 																		Stream)
				(princ "		<div class=\"title\">\n" 														Stream)
				(princ (strcat "			<b>" TitleHtml "</b>\n") 											Stream)
				(princ "		</div>\n" 																		Stream)
				(princ "		<div class=\"infosequencelist\">\n" 											Stream)
				(princ "			<table border=\"1\" cellpadding=\"0\" cellspacing=\"0\" width=\"95%\">\n" 	Stream)
				
				(setq conta 1)
				
				(foreach itm LstRow
					
					(if (= conta 1)
						(princ (strcat "				<tr height=\"30px\" align=\"center\" bgcolor=\"" Color1 "\">\n") 	Stream)
						(princ (strcat "				<tr height=\"30px\" align=\"center\" bgcolor=\"" Color2 "\">\n") 	Stream)
					)
					
					
					(if (= conta 1)
						(foreach itm1 itm
							(princ (strcat "					<td><b>" itm1 "</b></td>\n") 						Stream)
						)
						(foreach itm1 itm
							(princ (strcat "					<td>" itm1 "</td>\n") 								Stream)
						)
					)

					(setq conta (1+ conta))
					(princ "				</tr>\n" 																Stream)
				)
				(princ "			</table>\n" 																	Stream)
				(princ "		</div>\n" 																			Stream)
				(princ "	</div>\n" 																				Stream)
				(princ "</body>\n" 																					Stream)
				(princ "</html>\n" 																					Stream)	
			)
		)
	)
	;
	; Main ++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(if (and FileOut Title LstRow)
		(progn
			(setq Stream (open FileOut "w"))
			(if Stream
				(progn
					(WriteHead Stream)
					(WriteBody Title LstRow Stream)
					(Close Stream)
				)
			)
		)
	)
)