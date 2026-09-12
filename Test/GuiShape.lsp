;
(defun GuiFindShape (/ 	SwapModeTile UpdateBoxShape FindShape EmptyBox Choise
						$LstEname$ xx GoFindReport GoToOutput NameReport NameLayout)

	(defun SwapModeTile (Target Status)
		(if (= Status "1") (mode_tile Target 0) (mode_tile Target 1))
	)
	;
	(defun UpdateBoxShape (/ Mark Ename Num Prog ObjBlock
							 PrgShape IdShape OrderShape PhaseShape NameShape QtaShape ThikShape DimShape LengthShape Widthshape MatShape Rtn)
	
		(if $LstEname$
			(progn
				(setq Prog 0)
				(foreach Mark $LstEname$
					(setq Num 0)
					(foreach Ename (cdr Mark)
						(setq ObjBlock (vlax-ename->vla-object Ename))
						(setq Prog (1+ Prog))
						(setq Num  (1+ Num))
						; "Itm\tId\tCommessa\tFase\tMarca\tQuantita\tSpessore\tLunghezza\tLarghezza\tQualita'"
						(setq PrgShape 	  (rtos Prog 2 0))
						
						(setq IdShape     (LM:vl-getattributevalue ObjBlock "IDSHAPE")) 		; id shape
						(setq OrderShape  (LM:vl-getattributevalue ObjBlock "ORDERSHAPE")) 		; nome commessa
						(setq PhaseShape  (LM:vl-getattributevalue ObjBlock "PHASESHAPE"))		; nome fase
						(setq NameShape   (LM:vl-getattributevalue ObjBlock "MKSHAPE"))			; nome pezzo
						(setq QtaShape    (LM:vl-getattributevalue ObjBlock "QTASHAPE"))		; quantità
						(setq ThikShape   (LM:vl-getattributevalue ObjBlock "TKSHAPE"))			; spessore
						(setq LengthShape (LM:vl-getattributevalue ObjBlock "LENGTHSHAPE"))		; lunghezza
						(setq Widthshape  (LM:vl-getattributevalue ObjBlock "HEIGHTSHAPE"))		; larghezza
						(setq MatShape    (LM:vl-getattributevalue ObjBlock "MATSHAPE"))		; materiale
						
						(setq Rtn	  	  (append Rtn (list (strcat PrgShape	"\t" 
																	IdShape		"\t"
																	OrderShape	"\t"
																	PhaseShape	"\t"
																	NameShape	"\t"
																	QtaShape	"\t"
																	ThikShape	"\t"
																	LengthShape	"\t"
																	Widthshape	"\t"
																	MatShape))))
					)
					(setq Rtn (append Rtn (list (strcat "\t\t\t\t           Tot\t" (rtos Num 2 0) "\t\t\t\t"))))
					(setq Rtn (append Rtn (list (strcat "\t\t\t\t\t\t\t\t\t"))))
				)
				(start_list "box_info")
					(mapcar 'add_list Rtn)
				(end_list)
			)
			(LM:popup "avvertimento" "ricerca vuota" (+ 0 64 4096))
		)
	)
	;
	(defun FindShape (/ Go OrderShape PhaseShape MarkShape Mark EnameBlock IdShape EnameShape LstCheck)
	
		(start_list "box_info") (end_list)

		(ClearProgressBarDcl "$progbarsearch$")
		(ClearProgressBarDcl "$progbarshadow$")
		
		(setq Go T)
		(setq $LstEname$ nil)
		(if (= (get_tile "ActiveFilterOrder") "1") (setq OrderShape (get_tile "OrderFilter")) (setq OrderShape "<>")) 
		(if (= (get_tile "ActiveFilterPhase") "1") (setq PhaseShape (get_tile "PhaseFilter")) (setq PhaseShape "<>")) 
		(if (= (get_tile "ActiveFilterMark")  "1") (setq MarkShape  (get_tile "MarkFilter"))  (setq MarkShape  "<>")) 
		
		(if (= OrderShape "") (progn (setq Go nil) (alert "Valore errato ricerca Commessa")))
		(if (= PhaseShape "") (progn (setq Go nil) (alert "Valore errato ricerca Fase")))
		(if (= MarkShape "")  (progn (setq Go nil) (alert "Valore errato ricerca Marca")))
		
		(if Go (setq $LstEname$ (FindEnameBomShape OrderShape PhaseShape MarkShape)))
		; ------------------------------------------------------------------------------
		(StartProgressBarDcl "$progbarshadow$" (length $LstEname$))
		(StartProgressBar    "Shadow"          (length $LstEname$))
		(setq LstCheck (GetLstIdAndEnameShape))
		(foreach Mark $LstEname$
			(UpDateProgressBar)
			(UpDateProgressBarDcl "$progbarshadow$")
			(foreach EnameBlock (cdr Mark)
				(setq EnameShape (cadr (assoc (LM:vl-getattributevalue (vlax-ename->vla-object EnameBlock) "IDSHAPE") LstCheck)))
				(BatchHatchDummyShape EnameShape (GetEnameInternalShapeByDummyEnameSelect EnameShape) 1 "SOLID" 30)
			)
		)
		(ClearProgressBar)
		; ------------------------------------------------------------------------------
	)
	;
	(defun EmptyBox ()
		(start_list "box_info") (end_list)
	)
	;
	(defun Choise ()
		(setq $OrderFilter$       (get_tile "OrderFilter"))
		(setq $PhaseFilter$       (get_tile "PhaseFilter"))
		(setq $MarkFilter$        (get_tile "MarkFilter"))
		(setq $ActiveFilterOrder$ (get_tile "ActiveFilterOrder"))
		(setq $ActiveFilterPhase$ (get_tile "ActiveFilterPhase"))
		(setq $ActiveFilterMark$  (get_tile "ActiveFilterMark"))
		(setq *SearchShape* 	  (done_dialog))
		(unload_dialog xx)
	)	
	;
	; Main
	;
	(setq $LstEname$ nil)
	(DeletedHatchEasyCut)
	(GoToModelLayout)
	
	(if (not $ActiveFilterOrder$) (setq $ActiveFilterOrder$ "0"))
	(if (not $ActiveFilterPhase$) (setq $ActiveFilterPhase$ "0"))
	(if (not $ActiveFilterMark$)  (setq $ActiveFilterMark$ 	"0"))
	(if (not $OrderFilter$)		  (setq $OrderFilter$ 		"<>"))			
    (if (not $PhaseFilter$)	 	  (setq $PhaseFilter$ 		"<>"))			
 	(if (not $MarkFilter$)		  (setq $MarkFilter$ 		"<>"))

	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "SearchShape" xx "" (cond ( *SearchShape* ) ( '(-1 -1) )))
	
	(set_tile  "ActiveFilterOrder"		    $ActiveFilterOrder$)			
	(set_tile  "ActiveFilterPhase"		    $ActiveFilterPhase$)			
	(set_tile  "ActiveFilterMark"			$ActiveFilterMark$)	
	
	(set_tile  "OrderFilter"				$OrderFilter$)			
	(set_tile  "PhaseFilter"				$PhaseFilter$)			
	(set_tile  "MarkFilter"					$MarkFilter$)
	
	(set_tile "box_info_title" "0")
	
	(SwapModeTile "OrderFilter" (get_tile "ActiveFilterOrder"))
	(SwapModeTile "PhaseFilter" (get_tile "ActiveFilterPhase"))
	(SwapModeTile "MarkFilter"  (get_tile "ActiveFilterMark"))

	(action_tile "ActiveFilterOrder" 	"(SwapModeTile \"OrderFilter\" (get_tile \"ActiveFilterOrder\"))")
	(action_tile "ActiveFilterPhase"	"(SwapModeTile \"PhaseFilter\" (get_tile \"ActiveFilterPhase\"))")
	(action_tile "ActiveFilterMark"		"(SwapModeTile \"MarkFilter\"  (get_tile \"ActiveFilterMark\") )")
	
	(action_tile "search"				"(EmptyBox) (FindShape) (UpdateBoxShape)")
	(action_tile "output"               "(Choise) (setq GoToOutput T)")
	(action_tile "report"               "(Choise) (setq GoFindReport T)")
	(action_tile "cancel"   			"(setq *SearchShape* (done_dialog)) (unload_dialog xx)")
												
	(start_dialog)
	(princ)

	(if GoToOutput 
		(progn
			(setq NameLayout "FoundShape")
			(if (not $LstEname$)
				(LM:popup "avvertimento" "ricerca vuota" (+ 0 64 4096))
				(OutputSearch03 $LstEname$ NameLayout)
			)
		)
	)

	
	(if GoFindReport
		(if (not $LstEname$)
			(LM:popup "avvertimento" "ricerca vuota" (+ 0 64 4096))
			(if (setq NameReport (ReportFoundShape $LstEname$))
				(DefaultBrowser NameReport)
			)
		)
	)


)
