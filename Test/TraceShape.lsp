(defun GetTrace (/ TraceShape TraceRect MakeTrace DeleteTrace DiagToRect *error*
					Loop LstPt ObLine Gr Code Data msgLst P1 P2 KeyMode ViewCtr NewViewCtr) 

	
	(defun *error* (msg)
		(redraw)
		(DeleteTrace)
		(princ)
    )
	;
	(defun TraceShape (LstPt / Num )
		(setq Num 0)
		(if LstPt
			(progn 
				(redraw)
				(repeat (- (length LstPt) 1)
					(grdraw (nth Num LstPt) (nth (1+ Num) LstPt) 3 1)
					(setq Num (1+ Num))
				)
				(grdraw (nth 0 LstPt) (nth (- (length LstPt) 1) LstPt) 3 1)
			)
		)
	)
	;
	(defun TraceRect (P1 P2)
		(if (and P1 P2)
			(progn 
				(redraw)
				(grdraw P1 (list (car P2) (cadr P1)) 3 1)
				(grdraw P1 (list (car P1) (cadr P2)) 3 1)
				(grdraw P2 (list (car P2) (cadr P1)) 3 1)
				(grdraw P2 (list (car P1) (cadr P2)) 3 1)
			)
		)
	)
	;
	(defun MakeTrace (P1 P2)
		(if (and P1 P2)
			(progn
				(DeleteTrace)
				(entmakex (list (cons 0 "LINE")
								(cons 100 "AcDbEntity")
								(cons 67 0)
								(cons 8 $LayerDinamicInfoEasyCut)
								(cons 62 1)
								(cons 100 "AcDbLine")
								(cons 10 (trans P1 1 0)) (cons 11 (trans P2 1 0)) (cons 210 (list 0.0 0.0 1.0)))
				)
			)
		)
	)
	;
	(defun DeleteTrace (/ itm)
		(foreach itm (LM:ss->ent (ssget "_X" (list (cons 8  $LayerDinamicInfoEasyCut))))
			(if (entget itm) (entdel itm))
		)
	)
	;
	(defun DiagToRect (P1 P2)
		(if (and P1 P2)
			(list P1 
				 (list (car P2) (cadr P1))
				  P2
				 (list (car P1) (cadr P2))
			)
		)
	)
	;
	; Main
	;
    (setq Loop T)

	(setq msgLst (list 	"\rRectangle[Tab] Point[click] Breack[Esc]              "
						"\rShape[Tab] Point[click] End Select[Enter] Breack[Esc]"))
	(princ (nth 0 msgLst))
	(setq KeyMode 0)
	(setq ViewCtr (getvar "viewctr"))
	
    (while Loop

		;(setq Gr (grread 't 15 1) Code (car Gr) data (cadr Gr))
		(setq Gr (grread T) Code (car Gr) Data (cadr Gr))
		
		(cond

		
			((and (= Code 5) (listp Data))            	; Mouse rolling
				(setq NewViewCtr (getvar "viewctr"))	
				(cond
					((= (equal NewViewCtr ViewCtr) T)   ; Only Rooling
						(cond 
							((= KeyMode 0)	; rectangle
								(TraceRect P1 Data)
							)
							((= KeyMode 1)	; shape
								(if LstPt (MakeTrace (car (reverse LstPt)) Data))
							)
						)
					)
					(t									; Rooling+Zoom
						(cond 
							((= KeyMode 0)	; rectangle
								(TraceRect P1 Data)
							)
							((= KeyMode 1)	; shape
								(if LstPt (TraceShape LstPt))
							)
						)
					)
				)
				(setq ViewCtr NewViewCtr)
			)
			((and (= Code 3) (listp Data))			; Left click mouse			
				(cond
					((= KeyMode 0)	; rectangle
						(if P1
							(progn
								(setq P2 Data)
								(setq Loop nil)
							)
							(setq P1 Data)
						)
					)
					((= KeyMode 1)	; shape
						(setq LstPt (append LstPt (list Data)))
						(TraceShape LstPt)
					)
				)
			)
			((and (= Code 2) (= Data 9))				; KeyTab
				(cond 
					((= KeyMode 0)	; switch to rectangle from shape
						(setq Keymode 1)
						(setq LstPt nil)
						(redraw)
						(princ (nth 1 msgLst))
					)
					((= KeyMode 1)	; switch to shape from rectangle
						(setq Keymode 0)
						(setq P1 nil)
						(setq P2 nil)
						(redraw)
						(DeleteTrace)
						(princ (nth 0 msgLst))
					)
				)
			)
			((and (= Code 2) (= Data 13)) 				; Enter
				(DeleteTrace)
				(setq Loop nil)
			)
		)
		;(princ "Code ") (princ Code) (princ " Data ") (princ Data) (terpri)
    )
	; Return data +++++++++++++++++++++++
	(cond
		((= KeyMode 0)
			(DiagToRect P1 P2)
		)
		((and (= KeyMode 1) (> (length LstPt) 2))
			LstPt
		)
		(t
			nil
		)
	)
)