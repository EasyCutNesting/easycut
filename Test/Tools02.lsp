(defun PutCodeSheet (EnameSheet Code / Surface Ratio)
	
	(if (and EnameSheet Code)
		(if (= (strlen (rtos Code 2 0)) 7)
			(progn
				(setq Surface (vla-get-area (vlax-ename->vla-object EnameSheet)))
				(setq Ratio (/ (+ (fix Surface) (/ Code 10000000.0)) Surface))
				(vla-ScaleEntity (vlax-ename->vla-object EnameSheet) (vlax-3d-point 0.0 0.0) (sqrt Ratio))
				(princ (LM:rtos (vla-get-area (vlax-ename->vla-object EnameSheet)) 2 7))
				(setq Rtn (cadr (LM:str->lst (LM:rtos (vla-get-area (vlax-ename->vla-object EnameSheet)) 2 7) ".")))
			)
		)
	)
	Rtn
)

(defun GetCodeSheet (EnameSheet)
	(if EnameSheet
		(cadr (LM:str->lst (LM:rtos (vla-get-area (vlax-ename->vla-object EnameSheet)) 2 7) "."))
	)
)




















(defun c:asdxf ( / c_doc) 
  (setq c_doc (vla-get-activedocument (vlax-get-acad-object)))
  (vla-saveas c_doc (vlax-get-property c_doc 'fullname) ac2007_dxf)
  (princ "Drawing saved in 2007_dxf Format")
);end_defun

;
;
;
(defun CompleteMoveEasyCut (SSel / itm EnameTrigger Rtn)

	(foreach itm (LM:ss->ent SSel)
		(if (CheckIfEasyCutShape itm)
			(progn
				(setq EnameTrigger (GetEnameTriggerByEnameShape itm))
				(if (car EnameTrigger)	(setq Rtn (append Rtn (list (car  EnameTrigger))))) 
				(if (cadr EnameTrigger)	(setq Rtn (append Rtn (list (cadr EnameTrigger)))))
			)
		)
		(setq Rtn (append Rtn (list itm)))
	)
	(princ "\nSelezionato ") (princ (sslength (LstEname->Ssget Rtn))) (princ "\n")
	(LstEname->Ssget Rtn)
)
;
;
;
(defun UpDateMoveEasyCut (Ssel / itm EnameTrigger)

	(foreach itm (LM:ss->ent SSel)
		(if (CheckIfEasyCutShape itm)
			(progn
				(setq EnameTrigger (GetEnameTriggerByEnameShape itm))
				(UpDateMove itm (car EnameTrigger) (cadr EnameTrigger))
			)
		)
	)
)
;
;
;
(defun UpDateMove (EnameMove TriggerOn TriggerOff / AttachTrigger 
													TyShape itm)

	;DetatchInfoEname
	;DetatchGroupToEname

	(defun AttachTrigger (EnameShape EnameTriggerA EnameTriggerB / RgpTiggerA RgpTiggerB IdShape IdGroup)
	
		(if (= (GetTypeShape EnameTriggerA) 3) ; entra
			(setq RgpTiggerA $RgpTiggerOn)
		)
		(if (= (GetTypeShape EnameTriggerA) 4) ; esci
			(setq RgpTiggerA $RgpTiggerOff)
		)
		(if (= (GetTypeShape EnameTriggerB) 3) ; entra
			(setq RgpTiggerB $RgpTiggerOn)
		)
		(if (= (GetTypeShape EnameTriggerB) 4) ; esci
			(setq RgpTiggerB $RgpTiggerOff)
		)
	
		(setq IdShape (GetIdShape EnameShape)
			  IdGroup (car (gnames EnameShape))
		)
		
		(setq xd_list (list '(1002 . "}"))
			  xd_list (cons (cons 1000 "*") 	xd_list)
			  xd_list (cons (cons 1000 IdShape) xd_list)
			  xd_list (cons '(1002 . "{") 		xd_list)
			  xd_list (cons RgpTiggerA			xd_list)
			  xd_list (list -3 					xd_list)
			  nuova_entita (append (entget EnameTriggerA) (list xd_list))
		)
		(entmod nuova_entita)
		(entupd EnameTriggerA)				
		(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list (vlax-ename->vla-object EnameTriggerA)))
	
		(setq xd_list (list '(1002 . "}"))
			  xd_list (cons (cons 1000 "*") 	xd_list)
			  xd_list (cons (cons 1000 IdShape) xd_list)
			  xd_list (cons '(1002 . "{") 		xd_list)
			  xd_list (cons RgpTiggerB			xd_list)
			  xd_list (list -3 					xd_list)
			  nuova_entita (append (entget EnameTriggerB) (list xd_list))
		)
		(entmod nuova_entita)
		(entupd EnameTriggerB)				
		(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) IdGroup) 'appenditems (list (vlax-ename->vla-object EnameTriggerB)))
	)
	;
	; Main
	;
	(setq TyShape (GetTypShape EnameMove))
	(cond
		((= TyShape "CI")
			(if (member EnameMove (mapcar 'cdr (Genames (car (Gnames EnameMove)))))
				(foreach itm (vl-remove EnameMove (mapcar 'cdr (Genames (car (Gnames EnameMove)))))
					(cond
						((= (GetTypShape itm) "CE")
							(if (not (PoligonInsidePoligon itm EnameMove))
								(progn
									(DetatchInfoEname EnameMove)
									(DetatchGroupToEname EnameMove)
									(vla-put-color (vlax-ename->vla-object EnameMove) 7)
									(SetShape itm)
									(if (and TriggerOn TriggerOff)
										(progn
											(entdel TriggerOn)
											(entdel TriggerOff)
										)
									)
								)
							)	
						)
						((= (car (GetDataShape itm)) "CI")
							(if (PoligonInsidePoligon itm EnameMove)
								(LM:popup "Errore" "Stai mettendo un contorno dentro un contorno interno \n controlla !" (+ 0 16 4096))
							)
						)
					)
				)
			)
		)
		((= TyShape "CE")
			(foreach itm (mapcar 'cdr (Genames (car (Gnames EnameMove))))
				(if (= (car (GetDataShape itm)) "CI")
					(if (not (PoligonInsidePoligon itm EnameMove))
						(progn
							(DetatchInfoEname itm)
							(DetatchGroupToEname itm)
							(vla-put-color (vlax-ename->vla-object itm) 7)
							(if (and TriggerOn TriggerOff)
								(progn
									(entdel TriggerOn)
									(entdel TriggerOff)
								)
							)
						)
					)	
				)
			)
			(SetShape EnameMove)
		)
	)	
)
