;
;
(defun PolyMergeArc (/ EnamePolyLine LstXdata NewEnamePolyline)

	(prompt "\Selezionare la PolyLinea ")
	(if (setq EnamePolyLine (getent))
		(progn
			(setq LstXdata (assoc -3 (entget EnamePolyLine (list "*"))))
	
			(if EnamePolyLine
				(if (or (= (cdr (assoc 0 (entget EnamePolyLine))) "LWPOLYLINE") (= (cdr (assoc 0 (entget EnamePolyLine))) "POLYLINE"))
					(if (not (setq NewEnamePolyline (PolyLineMergeToArc EnamePolyLine)))
						(progn
							(LM:popup "Errore" "Polylinea non creata" (+ 1 16 4096))
							(command "_undo" "1")
							(exit)
						)
					)
				)
			)
			
			(if (not (equal EnamePolyLine NewEnamePolyLine)) (InheritXdataShape NewEnamePolyline LstXdata))
		)
	)
)
;
;
;
(defun PolyLineMergeToArc (EnamePolyLine /	LM:startundo LM:endundo LM:acdoc
											LstEname LstArc itm LstEname DataCircle DataInfoShape)

	(defun LM:startundo ( doc )
		(LM:endundo doc)
		(vla-startundomark doc)
	)
	(defun LM:endundo ( doc )
		(while (= 8 (logand 8 (getvar 'undoctl)))
			(vla-endundomark doc)
		)
	)
	(defun LM:acdoc nil
		(cond ( acdoc ) ((setq acdoc (vla-get-activedocument (vlax-get-acad-object)))))
	)
	
	(LM:startundo (LM:acdoc))
	
	(if (entget EnamePolyLine)
		(if (or (= (cdr (assoc 0 (entget EnamePolyLine))) "LWPOLYLINE") (= (cdr (assoc 0 (entget EnamePolyLine))) "POLYLINE"))
			(cond
				((setq DataCircle (IsLwPolylineDummyCircle EnamePolyLine $Seg2Arc_AcuracyCenterArc))
					(entdel EnamePolyLine)
					(setq Rtn (CircleLwpolyline (car DataCircle) (cadr DataCircle)))
				)
				((IsRegularPolygon EnamePolyLine)
					(setq Rtn EnamePolyLine)
				)
				(t
					(setq LstEname (mapcar 'vlax-vla-object->ename (LwPolyToSegment EnamePolyLine nil)))
					(setq LstArc (LineToArc LstEname))
				
					(foreach itm LstEname
						(if (entget itm) (setq LstEname (append LstEname (list itm))))
					)
					(foreach itm LstArc
						(setq LstEname (append LstEname (list itm)))
					)
					(entdel EnamePolyLine)
					(setq Rtn (Line&ArcToPline (LstEname->Ssget LstEname) T))
				)
			)
		)
	)
	(LM:endundo (LM:acdoc))
	Rtn
)
;
;
;
(defun InheritXdataShape (EnameShape LstXData)

	; (-3 ("PIATTO" 
	;		(1002 . "{") 
	;		(1000 . "CE") 
	;		(1000 . "284240108") 
	;		(1000 . "2") 			percorrenza --> update
	;		(1000 . "1001") 
	;		(1000 . "1") 
	;		(1000 . "C707A") 
	;		(1000 . "80") 
	;		(1000 . "S355J0W") 
	;		(1000 . "5") 
	;		(1000 . "23/10/2020") 
	;		(1000 . "31") 
	;		(1002 . "}")))

	(if (and EnameShape LstXData)
		(progn
			(DetatchInfoEname EnameShape)
			(entmod (append (entget EnameShape) (list LstXdata)))
			(entupd EnameShape)
			
			(if (/= (atoi (cdr (nth 4 (nth 1 LstXdata)))) (ClockWeisEname EnameShape))
				(RevLwpline EnameShape)
			)
			
			;(ChangeRecordShape EnameShape 3  (ClockWeisEname EnameShape))
			
			(ChangeRecordShape EnameShape 10 (Today))
			(setq GrName (Random_Str 9))
			(AssignGroupNameShape EnameShape GrName)
			(EnameShape->UpdateBlockInfoShape EnameShape)
			
		)
	)
)
;
;
;
; (LineToArc (LM:ss->ent (ssget)))
; (setq LstEname (LM:ss->ent (ssget)))
; (CheckConcatenateSegments (LM:ss->ent (ssget)))
(defun LineToArc (LstEname / GetCenter FilterSegments MemberWithFuzz GetDataCenter SortDataCenter GetChainSegments CheckDataCenter
							 MSecStart Fuzz LstChk DataCenter Itm Itm1 Itm2 Vertex P1 P2 P3 EnamePoly EnameArc Rtn)


	(setq Fuzz 2.5) ; accuracy center radius
	
	(defun GetCenter (Ename1 Ename2 / Pa Pb Pc Pd MidA MidB PpeA PpeB Rtn)
	
		(if (and Ename1 Ename2)
			(setq Pa (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint (vlax-ename->vla-object Ename1))))
				  Pb (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint   (vlax-ename->vla-object Ename1))))
				  Pc (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint (vlax-ename->vla-object Ename2))))
				  Pd (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint   (vlax-ename->vla-object Ename2))))
				  MidA (car (div (car Pa) (cadr Pa) (car Pb) (cadr Pb) 1))
				  MidB (car (div (car Pc) (cadr Pc) (car Pd) (cadr Pd) 1))
				  PpeA (per (car Pa) (cadr Pa) (car MidA) (cadr MidA) 1.0)
				  PpeB (per (car Pc) (cadr Pc) (car MidB) (cadr Midb) 1.0)
				  Rtn  (inters MidA PpeA MidB PpeB nil)
			)
		)
		Rtn
	)
	;
	;
	(defun FilterSegments (LstEname / Itm LstData Rtn)
	
		(foreach Itm LstEname
			(if (setq LstData (entget Itm))
				(if (= (cdr (assoc 0 LstData)) "LINE")
					(if (<= (vla-get-Length (vlax-ename->vla-object Itm)) $Seg2Arc_MaxLgSeg2Arc)
						(setq Rtn (append Rtn (list Itm)))
					)
				)
			)
		)
		Rtn
	)
	;
	;
	(defun MemberWithFuzz ( expr lst fuzz / x )
		(while (and (setq x (car (car lst))) (not (equal expr x fuzz)))
			(setq lst (cdr lst))
		)
		lst
	)
	;
	;
	(defun GetDataCenter (LstEname Fuzz / LstChk LstCombine Itm Itm1 Center Data Rtn Pt LstE LstTmp)
	
		(setq LstCombine (CombineList LstEname 2))
		(foreach Itm LstCombine
			(if (setq Center (GetCenter (car Itm) (cadr Itm)))
				(if (setq Data (MemberWithFuzz Center Rtn Fuzz))
					(progn
						(setq Pt   (car (car Data)))
						(setq LstE (cadr (car Data)))
						(if (not (member (car  Itm) LstE)) (setq LstE (append LstE (list (car  Itm)))))
						(if (not (member (cadr Itm) LstE)) (setq LstE (append LstE (list (cadr Itm)))))
						(setq Rtn (subst (list Pt LstE) (car Data)  Rtn))
					)
					(setq Rtn (append Rtn (list (list Center (list (car Itm) (cadr itm))))))
				)
			)
		)
		(setq Data nil)
		(foreach Itm Rtn
			(setq LstTmp nil)
			(foreach Itm1 (cadr Itm)
				(setq LstTmp (cons Itm1 LstTmp))
			)
			(setq Data (append Data (list LstTmp)))
		)
		Data
	)
	;
	;
	(defun SortDataCenter (LstEname / LstTmp Itm Itm1 Rtn)

		(foreach Itm LstEname
			(if (= (Type Itm) 'LIST)
				(progn
					(setq LstTmp nil)
					(foreach Itm1 Itm
						(if (entget Itm1) (setq LstTmp (cons Itm1 LstTmp)))
					)
					(if LstTmp (setq Rtn (cons LstTmp Rtn)))
				)
			)
		)
		(setq Rtn (vl-sort Rtn (function (lambda (e1 e2)  (> (length e1) (length e2))))))
	)
	;
	;
	(defun GetChainSegments (LstEname / GetLstConcatenation 
											  LstWork LstChain itm Rtn)
		
		(defun GetLstConcatenation (LstEname / fz s1 en s2 l1 l2 v vl fl)
		
			(setq fz 1e-8)
			(if (setq s1 (LstEname->Ssget LstEname))
				(progn
					(setq en (car LstEname)
						  s2 (ssadd)
						  l1 (list (vlax-curve-getstartpoint en) (vlax-curve-getendpoint en))
					)
					(repeat (setq in (sslength s1))
						(setq en (ssname s1 (setq in (1- in)))
							  vl (cons (list (vlax-curve-getstartpoint en) (vlax-curve-getendpoint en) en) vl)
						)
					)
					(while
						(progn
							(foreach v vl
								(if (vl-some '(lambda ( p ) (or (equal (car v) p fz) (equal (cadr v) p fz))) l1)
									(setq s2 (ssadd (caddr v) s2)
										  l1 (vl-list* (car v) (cadr v) l1)
										  fl t
									)
									(setq l2 (cons v l2))
								)
							)
							fl
						)
						(setq vl l2 l2 nil fl nil)
					)
				)
			)
			(LM:ss->ent s2)
		)
		;
		;
		;
		(setq LstWork LstEname)
		(while (setq LstChain (GetLstConcatenation LstWork))
			(foreach itm LstChain (setq LstWork (vl-remove itm LstWork)))
			(setq Rtn (cons LstChain Rtn))
		)
		Rtn
	)
	;
	;
	(defun CheckDataCenter (LstEname / Itm Rtn)
		(foreach Itm LstEname
			(if (entget Itm)
				(setq Rtn (cons Itm Rtn))
			)
		)
		Rtn
	)
	;
	; Main 
	;
	;(length (GetDataCenter (car (GetChainSegments (FilterSegments (LM:ss->ent (ssget))))) Fuzz))
	(foreach Itm (GetChainSegments (FilterSegments LstEname))
	
		; +++++++++++++++++++++++++++++++++++++++
		;(setq MSecStart (getvar "MILLISECS"))
		(setq DataCenter (SortDataCenter (GetDataCenter Itm Fuzz)))
		;(princ " Timing  DataCenter ") (princ (/ (- (getvar "MILLISECS") MSecStart) 1000.0)) (princ "\n")
		; +++++++++++++++++++++++++++++++++++++++

		(foreach Itm1 DataCenter
		
			(foreach Itm2 (GetChainSegments (CheckDataCenter Itm1))
			
				(if (>= (length Itm2) $Seg2Arc_MinQtySeg2Arc)
					(progn
						(setq EnamePoly (Line&ArcToPline (LstEname->Ssget Itm2) T))
		
						(if (> (cdr (assoc 90 (entget EnamePoly))) 2)
							(progn
								(setq Vertex (vlax-get (vlax-ename->vla-object EnamePoly) 'coordinates))
								(setq P1 (vlax-curve-getStartPoint EnamePoly))
								(setq P2 (list  (nth (+ (* (/ (/ (length Vertex) 2) 2) 2) 0) Vertex)
												(nth (+ (* (/ (/ (length Vertex) 2) 2) 2) 1) Vertex)
												0.0))
								(setq P3 (vlax-curve-getEndPoint EnamePoly))
								(if (setq EnameArc (MakeArc3Pt P1 P2 P3)) (setq Rtn (append Rtn (list EnameArc))))
							)
						)
						(entdel EnamePoly)
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
(defun ArxOut (EnamePolyLine / LstLine+Arc FileOut Stram Itm Obj Ps Pe)

	(setq LstLine+Arc (mapcar 'vlax-vla-object->ename (LwPolyToSegment EnamePolyLine nil)))
	(setq FileOut	  "C:\\EasyCut\\Test\\ArxInput.log")
	(setq Stream   	  (open FileOut "w"))
	
	(foreach Itm (LM:ss->ent (FilterEntitySelectionByName (LstEname->Ssget LstLine+Arc) (list "LINE")))
		
		(setq Obj (vlax-ename->vla-object Itm))
		(setq Ps  (vlax-safearray->list (vlax-variant-value (vla-get-StartPoint Obj))))
		(setq Pe  (vlax-safearray->list (vlax-variant-value (vla-get-EndPoint   Obj))))		
		
		(princ (strcat 	(rtos (car  Ps) 2 12) " "
						(rtos (cadr Ps) 2 12) " "
						(rtos (car  Pe) 2 12) " "
						(rtos (cadr Pe) 2 12) " "
						(vla-get-Handle Obj)
						"\n"
				)
				Stream
		)
	)
	(close Stream)
)

