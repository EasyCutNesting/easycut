;
;
;
(defun ReactorEasyCutCommandStart (Reactor Command / EnameShape EnameSheet Ssel)

	;(alert (strcat "Start Command " (car Command)))
	;(princ "\nSTART ingresso -------------->  ")(princ (car Command)) (princ "\n")
	
	
	(defun ExitCommand ()
		(if (setq *wsh* (cond (*wsh*) ((vlax-create-object "WScript.Shell"))))
			(vl-catch-all-apply 'vlax-invoke (list *wsh* 'sendkeys "{ESC}"))
		)
	)
	;
	;
	;
	(cond
		((or (= (car Command) "COPY") (= (car Command) "PASTECLIP"))
			(Open_Block_Entity)
		)
	)
	
	(if EnameDoubleClickGetInfo$
		(cond
			;((= (CheckIfEasyCutShapeMemeber EnameDoubleClickGetInfo$) T)
			((CheckIfEasyCutShapeMemeber EnameDoubleClickGetInfo$)
				(TcEasyCut EnameDoubleClickGetInfo$)
				(setq EnameDoubleClickGetInfo$ nil)
				(ExitCommand)
			)
			;((= (CheckIfEasyCutSheetMember EnameDoubleClickGetInfo$) T)
			((CheckIfEasyCutSheetMember EnameDoubleClickGetInfo$)
				(TcEasyCut EnameDoubleClickGetInfo$)
				(setq EnameDoubleClickGetInfo$ nil)
				(ExitCommand)
			)
			((/= (cdr (assoc 0 (entget EnameDoubleClickGetInfo$))) "INSERT")
				(setq Ssel (ssadd))
				(ssadd EnameDoubleClickGetInfo$ Ssel)
				(sssetfirst nil Ssel)
				(setq EnameDoubleClickGetInfo$ nil)
			)
		)
	)

	;(princ "\nSTART uscita -------------->  ")(princ (car Command)) (princ "\n")
)
;
;
;
(defun ReactorEasyCutCommandEnd (Reactor Command / LstEnameCopy LstEnamePolicy EnameBom GetMyObject EnameShape
												   itm)
	;
	;(alert (strcat "End Command " (car Command)))
	;(princ "\nEND ---------------->  ")(princ (car Command)) (princ "\n")
	;
	(cond
		((or (= (car Command) "COPY") (= (car Command) "PASTECLIP"))
			(setq LstEnameCopy   (close_Block_Entity))
			(setq LstEnamePolicy (PolicyEntity LstEnameCopy))
			
			; 0	(CheckIfEasyCutSheetMember)		$RgpSheet / $RgpSheetTarget
			; 1 (CheckIfEasyCutShapeMemeber)	$RgpShape / $RgpTiggerOn / $RgpTiggerOff
			; 2 (CheckIfBlockSheet)				$RgpSheetTarget
			; 3 (CheckIfBlockShape)				$RgpShapeTarget+NameBlockShape$ / BlockLogo / BlockBarCode
			; 4 (CheckIfEasyCutRule)			$RgpRule ---> nil (non esiste più)
			; 5	(altro)
			
			(if  (nth 0 LstEnamePolicy)		; if sheet member
				(CompleteEnameCopySheet (nth 0 LstEnamePolicy))
			)
			(if  (nth 3 LstEnamePolicy)     ; if shape block
				(DeleteEntity (nth 3 LstEnamePolicy))  
			)
			(if (nth 1 LstEnamePolicy)      ; if shape member
				(cond
					((= Clone$ T)   
						(ActionCopyMemberShape (nth 1 LstEnamePolicy)) ; list Ename to copy
						(setq Clone$ T)
					)
					((= Clone$ nil) 
						(setq EasyCutLstEnameCopy$ (nth 1 LstEnamePolicy))
						(setq Clone$ T)
					)
				)
			)
		)
		((= (car Command) "GRIP_STRETCH")
			(setq GetMyObject (cadr (ssgetfirst)))
			(setq LstEnamePolicy (PolicyEntity (list (ssname GetMyObject 0))))
			
			(if (nth 0 LstEnamePolicy)
				(if (setq EnameBom (GetEnameBlockSheetByEnameSheet (nth 0 (nth 0 LstEnamePolicy))))
					(UpdateFormSheet (nth 0 (nth 0 LstEnamePolicy)))
					(LogoSheet (nth 0 (nth 0 LstEnamePolicy)) (PrintRuleSheet (nth 0 (nth 0 LstEnamePolicy))))
				)
			)
			(if (nth 1 LstEnamePolicy)
				(foreach itm (ActionMoveMemberShape (nth 1 LstEnamePolicy) 100)
					(EnameShape->UpdateBlockInfoShape itm)
				)
			)
			
			(sssetfirst nil nil)
		)
		((= (car Command) "STRETCH")
			(setq GetMyObject (ssget "_P"))
			(if GetMyObject
				(progn
					(setq LstEnamePolicy (PolicyEntity (list (ssname GetMyObject 0))))
					
					(if (nth 0 LstEnamePolicy)
						(if (CheckIfEasyCutSheet (nth 0 (nth 0 LstEnamePolicy)))
							(UpdateFormSheet (nth 0 (nth 0 LstEnamePolicy)))
							(UpdateFormSheet (GetEnameSheetById (car (GetInfoBlockSheet (nth 0 (nth 0 LstEnamePolicy))))))
						)
					)
					
					(if (nth 1 LstEnamePolicy)
						(foreach itm (ActionMoveMemberShape (nth 1 LstEnamePolicy) 100)
							(EnameShape->UpdateBlockInfoShape itm)
						)
					)
				)
			)
			(sssetfirst nil nil)
		)
		((= (car Command) "MOVE")
			(setq GetMyObject (ssget "_P"))
			(if GetMyObject
				(progn
					(setq LstEnamePolicy (PolicyEntity (LM:ss->ent GetMyObject)))
					
					(if (nth 0 LstEnamePolicy)
						(CompleteEnameMoveSheet (nth 0 LstEnamePolicy))
					)
					(if (nth 1 LstEnamePolicy)
						(ActionMoveMemberShape (nth 1 LstEnamePolicy) 100)
					)
				)
			)
			(sssetfirst nil nil)
		)
		((= (car Command) "ROTATE")
			(setq GetMyObject (ssget "_P"))
			(if GetMyObject
				(progn
					(setq LstEnamePolicy (PolicyEntity (LM:ss->ent GetMyObject)))

					(if (nth 0 LstEnamePolicy)
						(foreach itm (nth 0 LstEnamePolicy)
							(if (CheckIfEasyCutSheet itm)
								(UpdateFormSheet itm)
								(UpdateFormSheet (GetEnameSheetById (car (GetInfoBlockSheet itm))))
							)
						)
					)
					(if (nth 1 LstEnamePolicy)
						(ActionMoveMemberShape (nth 1 LstEnamePolicy) 100)
					)
				)
			)
			(sssetfirst nil nil)
		)
	)
	(setq EntryInfoShape$ nil)
	;(princ "\nEND ---------------->  ")(princ (car Command)) (princ "\n")
)
;
;
;
(defun ReactorEasyCutCommandCancel (Reactor Command / LstEnameCopy LstEnamePolicy GetMyObject) 

	;(alert (strcat "Cancel Command " (car Command)))
	;(princ "\nCANCEL ---------------->  ")(princ (car Command)) (princ "\n")
	(cond
	
		((= (car Command) "COPY")
			(setq LstEnameCopy (close_Block_Entity))
			(setq LstEnamePolicy (PolicyEntity LstEnameCopy))
			(DeleteEntity (nth 0 LstEnamePolicy))	; sheet member (sheet block rule)
			(DeleteEntity (nth 3 LstEnamePolicy))	; shape block
			(cond
				((= Clone$ T)   (ActionCopyMemberShape (nth 1 LstEnamePolicy)))
				((= Clone$ nil) (setq EasyCutLstEnameCopy$ (nth 1 LstEnamePolicy)))
			)
			(setq Clone$ T)
		)
		(t 
			(if $DeleteEntityCommandCancel
				(progn
					(setq GetMyObject (ssget "_P"))
					(if GetMyObject (DeleteSsel GetMyObject))
					(setq $DeleteEntityCommandCancel nil)
				)
			)
			;nil
		)
	)
	(sssetfirst nil nil)
	;(princ "\nCANCEL ---------------->  ")(princ (car Command)) (princ "\n")
)
;
;
;
(defun ReactorEasyCutDoubleClickGetInfo (Reactor Point / Point ACadDoc Ssets Flag NewSset)

		(setq EnameDoubleClickGetInfo$ nil)
		
		(setq Point 	(car Point))
		(setq ACadDoc 	(vla-get-activedocument(vlax-get-acad-object)))
		(setq Ssets 	(vla-get-selectionsets ACadDoc))
	
		(if (vl-catch-all-error-p (vl-catch-all-apply 'vla-item (list Ssets "$Set")))
			(setq NewSset (vla-add Ssets "$Set"))
			(progn
				(vla-delete (vla-item Ssets "$Set"))
				(setq NewSset (vla-add Ssets "$Set"))
			)
		)
		
		(vla-selectAtPoint NewSset (vlax-3D-point Point))
		
		(if (/= (vla-get-count NewSset) 0)
			(setq EnameDoubleClickGetInfo$ (vlax-vla-object->ename (vla-item NewSset 0)))
			(setq EnameDoubleClickGetInfo$ nil)
		)

)
;
;
;
(defun ReactorEasyCutObjectSelect  (own rea )

	;(princ "\nSELECT ---------------->  ")
	
	(setq SsgetSelect$ (cadr (ssgetfirst)))
	;(cond
	;	((= $command$ "MOVE")
	;		(sssetfirst nil (commad "_Select"))
	;	)
	;	(t
	;		(setq SsgetSelect$ (cadr (ssgetfirst)))
	;	)
	;)
;	;(ssgetfirst)
;	(alert "selezione")
)
;
;
;
(defun StartReactors (Verbose)
	(vlr-remove-all)
	(Add_Reactor "vlr-command-reactor"       
						"EasyCut-command-reactor"       
								(strcat "(list (cons :vlr-commandwillstart  'ReactorEasyCutCommandStart)
								               (cons :vlr-commandended      'ReactorEasyCutCommandEnd)
											   (cons :vlr-commandCancelled  'ReactorEasyCutCommandCancel))") Verbose)
	(Add_Reactor "vlr-mouse-reactor"		 
						"EasyCut-mouse-reactor"		 
								(strcat "(list (cons :vlr-beginDoubleClick  'ReactorEasyCutDoubleClickGetInfo))") Verbose)
	(Add_Reactor "vlr-miscellaneous-reactor" 
						"EasyCut-miscellaneous-reactor" 
								(strcat "(list (cons :vlr-pickfirstModified 'ReactorEasyCutObjectSelect))") Verbose)
	(if Verbose
		(progn
			(princ "\n") (princ (vlr-reactors)) (princ "\n")
		)
	)
)

;
;
;
(defun Add_Reactor (Reactor App CallBack Verbose / LstReactor Reaname Status Itm1 Itm2 Appn)

	;
	;	   Reactor				App										CallBack
	;
	; vlr-sysvar-reactor "Structura-sysvar-reactor" "(list (cons :vlr-sysvarchanged 'Structura_Change_Sysvar))"
	;
	; es (Add_Reactor "vlr-sysvar-reactor"  "Structura-sysvar-reactor" "(list (cons :vlr-sysvarchanged 'Structura_Change_Sysvar))")
	; es (Add_Reactor "vlr-command-reactor" "Structura-command-reactor" (strcat "(list (cons :vlr-commandwillstart 'Structura_Command_Start)"
	;																				  "(cons :vlr-commandended     'Structura_Command_End))"))
	;
	;
	(setq LstReactor (vlr-reactors))
	(setq Reaname (read (strcat ":" Reactor)))
	(setq Status 0)
	(if LstReactor
		(progn
			(foreach Itm1 LstReactor
				(if (= (car Itm1) (eval Reaname))
					(progn
						(setq Status 1)
						(foreach Itm2 (cdr Itm1)
							(if (= (vlr-data Itm2) App)
								(progn
									(setq Appn (vlr-data Itm2))
									(setq Status 2)
								)
							)
						)
					)
				)
			)
		)
	)
	(if Verbose (princ (strcat "\n Status reactor " (Lm:rtos Status 2 0) " ")))
	(cond
		((= Status 0)
			(eval (read (strcat "(" Reactor " " (chr 34) App (chr 34) " " CallBack ")")))
			(if Verbose (princ (eval (read (strcat "(" Reactor " " (chr 34) App (chr 34) " " CallBack ")")))))
		)
		((= Status 1)
			(vlr-add (eval (read (strcat "(" Reactor " " (chr 34) App (chr 34) " " CallBack ")"))))
			(if Verbose (princ (eval (read (strcat "(" Reactor " " (chr 34) App (chr 34) " " CallBack ")")))))
		)
		((= Status 2)
			(if Verbose (progn (princ "Reattore con Applicazione gia' presente ->  ") (princ Appn)))
		)
	)
	
)
;
;
;
(defun SendKeys (keys / ws) 
  (setq ws (vlax-create-object "WScript.Shell")) 
  (vlax-invoke-method ws 'sendkeys keys) 
  (vlax-release-object ws) 
  (princ) 
)
;
;
;
(defun PolicyEntity (LstEname / Rtn1 Rtn2 Rtn3 Rtn4 Rtn5 Rtn6)

	(foreach Ename LstEname
		(cond
			((CheckIfPaperSpace Ename)
				(setq Rtn6 (append Rtn6 (list Ename)))
			)
			((CheckIfEasyCutSheetMember Ename)
				(setq Rtn1 (append Rtn1 (list Ename)))
			)
			((CheckIfEasyCutShapeMemeber Ename)
				(setq Rtn2 (append Rtn2 (list Ename)))
			)
			((CheckIfBlockSheet Ename)
				(setq Rtn3 (append Rtn3 (list Ename)))
			)
			((CheckIfBlockShape Ename)
				(setq Rtn4 (append Rtn4 (list Ename)))
			)
			;((CheckIfEasyCutRule Ename)
			;	(setq Rtn5 (append Rtn5 (list Ename)))
			;)
			((CheckIfBlockLogo Ename)
				(setq Rtn4 (append Rtn4 (list Ename)))
			)
			((CheckIfBlockBarCode Ename)
				(setq Rtn4 (append Rtn4 (list Ename)))
			)
			(t
				(setq Rtn6 (append Rtn6 (list Ename)))
			)
		)
	)
	(list Rtn1 Rtn2 Rtn3 Rtn4 Rtn5 Rtn6)
)
;
; Action
;
(defun ActionMoveMemberShape (LstMemeberShape MaxElement / ListDifference CntTrg01 CntTrg02 PutColorShape ShapeInsideTo
																	LstTrg LstShSl LstShapeDetatch
																	itm itm1 Grp LstGrp LstShape
																	EnSh
																	DimScreen ChechZoom LstPt Rtn)

	;
	(defun ListDifference ( l1 l2 ) 
		( vl-remove-if  ' ( lambda  ( x )  ( member x l2 )) l1 ) 
	)
	;
	(defun CntTrg01  (EnameTrigger LstEname / Accuracy Loop Pos P1 P2 Rtn)
	
		(setq Accuracy 0.05)
		(setq Loop T)
		(setq Pos 0)
		(setq P1 (vlax-get (vlax-ename->vla-object EnameTrigger)  'Startpoint))
		(setq P2 (vlax-get (vlax-ename->vla-object EnameTrigger)  'Endpoint))
		(setq LstEname (vl-remove-if  (function (lambda (x) (= (vla-get-Color (vlax-ename->vla-object x)) $ColorDetatch))) LstEname))
		
		(while Loop
			(if (or (<= (distance (vlax-curve-getClosestPointTo 
									(vlax-ename->vla-object (nth Pos LstEname))  P1) P1) Accuracy)
					(<= (distance (vlax-curve-getClosestPointTo 
									(vlax-ename->vla-object (nth Pos LstEname))  P2) P2) Accuracy)
				)
				(progn
					(setq Loop T)
					(setq Rtn T)
				)
			)
			(setq Pos (1+ Pos))
			(if (= Pos (length LstEname)) 
				(setq Loop nil)
			)
		)
		Rtn
	)
	;
	(defun CntTrg02 (EnameTrigger / P1 P2 Ssel Aperture Rtn)
 
		(setq Aperture 0.1)
		(if EnameTrigger
			(progn
				(setq P1 (vlax-get (vlax-ename->vla-object EnameTrigger) 'Startpoint))
				(setq P2 (vlax-get (vlax-ename->vla-object EnameTrigger) 'Endpoint))
				(if (setq Ssel (ssget "_C" (list (- (car P1) Aperture) (- (cadr P1) Aperture)) 
										   (list (+ (car P1) Aperture) (+ (cadr P1) Aperture)) 
										   (list (list -3 (list $RgpShape)))))
					(setq Rtn (ssname Ssel 0))
					(if (setq Ssel (ssget "_C" (list (- (car P2) Aperture) (- (cadr P2) Aperture)) 
											   (list (+ (car P2) Aperture) (+ (cadr P2) Aperture)) 
											   (list (list -3 (list $RgpShape)))))
						(setq Rtn (ssname Ssel 0))
					)
				)
			)
		)
		Rtn
	)	
	;
	(defun PutColorShape (EnameShape / Journey)
		(cond 
			((= (GetTypeShape EnameShape) 1)
				(setq Journey (ClockWeisEname  EnameShape))
				(if (= Journey 3) (vla-put-Color (vlax-ename->vla-object EnameShape) $ColorShapeOra))	
				(if (= Journey 2) (vla-put-Color (vlax-ename->vla-object EnameShape) $ColorShapeAntiOra))
			)
			((= (GetTypeShape EnameShape) 2)
				(if (= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
					(setq Journey 2)
					(setq Journey (ClockWeisEname  EnameShape))
				)
				(if (= Journey 3) (vla-put-Color (vlax-ename->vla-object EnameShape) $ColorHoleOra))
				(if (= Journey 2) (vla-put-Color (vlax-ename->vla-object EnameShape) $ColorHoleAntiOra))
			)
		)
	)
	;
	(defun ShapeInsideTo (EnameShape / Pos ScreenControl DimScreen Pmid ChkZoom Filter LstEn Loop Rtn)
		(if EnameShape
			(progn
				(setq Pos 0)
				(setq ScreenControl 2000.0)
				(setq DimScreen (VpCoords))
				(setq Pmid (MidPoint (car DimScreen) (cadr DimScreen)))
				(if (< (distance (car DimScreen) (cadr  DimScreen)) ScreenControl)
					(progn
						(setq DimScreen (list (list (- (car Pmid) (/ ScreenControl 2.)) (- (cadr Pmid) (/ ScreenControl 2.)))
											  (list (+ (car Pmid) (/ ScreenControl 2.)) (+ (cadr Pmid) (/ ScreenControl 2.)))))
						(setq ChkZoom (ZoomWindow01 (car DimScreen) (cadr DimScreen)))
					)
				)
				
				(if (= (vlax-get-property (vlax-ename->vla-object EnameShape) 'ObjectName) "AcDbCircle")
					(setq Filter (list 
									'(-4 . "<OR")
										'(-4 . "<AND") '(0 . "LWPOLYLINE") '(70 . 1) '(-4 . "AND>")
										'(-4 . "<AND") '(0 . "CIRCLE") '(-4 . ">=") (cons 40 (vlax-get (vlax-ename->vla-object EnameShape) 'radius)) '(-4 . "AND>")
									'(-4 . "OR>")
									(list -3 (list $RgpShape))))
					(setq Filter (list 
									'(-4 . "<OR")
										'(-4 . "<AND") '(0 . "LWPOLYLINE") '(70 . 1) '(-4 . "AND>")
										'(0 . "CIRCLE")
									'(-4 . "OR>")
									(list -3 (list $RgpShape))))
				)
					
				(if (setq LstEn (vl-remove EnameShape   (LM:ss->ent (ssget "_C" (car DimScreen) (cadr DimScreen) Filter))))
					(setq Loop T)
				)
				(while Loop
					(if (PoligonInsidePoligon02 (nth Pos LstEn) EnameShape)
						(progn
							(setq Rtn (nth Pos LstEn))
							(setq Loop nil)
						)
						(progn
							(setq Pos (1+ Pos))
							(if (= Pos (length LstEn)) (setq Loop  nil))
						)
					)
				)
				(ZoomPrevius ChkZoom)
			)
		)
		
		Rtn
	)
	;
	;(princ "\Hello")
	;
	(setq DimScreen (VpCoords))
	(foreach itm LstMemeberShape
		(if (setq Grp (car (Gnames itm)))
			(if (not (member Grp LstGrp)) (setq LstGrp (append LstGrp (list Grp))))ù
		)
		(if (= (vla-get-Color (vlax-ename->vla-object itm)) $ColorDetatch)
			(if (= (GetTypeShape itm) 2)
					(setq LstShSl (append LstShSl (list itm)))
			)
		)
	)
	;
	;(princ "\n<1>")
	;(princ "\n") (princ LstGrp)
	;(princ "\n<1>")
	;
	(foreach itm LstGrp
		(princ "\n--> Controllo contorno dentro / fuori")
		(setq LstShape (GetShapeByGroup itm))
		(setq Rtn (append Rtn (list (car LstShape))))
		(setq LstPt (DiscretizeShapeNoControl (car LstShape)))
		
		(setq ChechZoom (VisibleEname (car LstShape)))
			(setq LstShapeDetatch (LM:ss->ent (ssget "_CP" LstPt (list (cons 62 $ColorDetatch) (list -3 (list $RgpShape))))))

		(foreach itm1 (cdr LstShape)
			(if (not (PoligonInsidePoligon02 (car LstShape) itm1))
				(progn 
					(DetatchGroupToEname itm1)
					(vla-put-Color (vlax-ename->vla-object itm1) $ColorDetatch)
				)
			)
		)
		(princ "\n--> Controllo contatto attacchi")
		(foreach itm1 (GetListEnameTriggerByIdGroup itm)
			(if (not (CntTrg01 itm1 LstShape))
				(progn 
					(DetatchGroupToEname itm1)
					(vla-put-Color (vlax-ename->vla-object itm1) $ColorDetatch)
				)
			)
		)
		(princ "\n--> Controllo contorni interni staccati dentro contorni esterni")
		(foreach itm1 LstShapeDetatch
			(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) itm) 'appenditems (list (vlax-ename->vla-object itm1)))
			(PutColorShape itm1)
		)
		;
		; Update Bom +++++++++++++++++++++++++++++++++++++++++++++++
		;
		;(ZoomPrevius ChkZoom)
	)
	
	(if LstShSl (princ "\n--> Controllo contorni interni staccati"))
	(foreach itm LstShSl
		(if (setq EnameMain (ShapeInsideTo itm))
			(if (setq Grp (car (Gnames EnameMain)))
				(progn
					(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) Grp) 'appenditems (list (vlax-ename->vla-object itm)))
					(PutColorShape itm)
				)
			)
		)
	)

	
	(if (setq LstTrg (LM:ss->ent (ssget "_X" (list (cons 62 $ColorDetatch) (list -3 (list (strcat $RgpTiggerOn "," (strcat $RgpTiggerOff))))))))
		(princ "\n--> Controllo attacchi staccati")
	)
	(foreach itm LstTrg
		(if (setq EnSh (CntTrg02 itm))
			(if (setq Grp (car (Gnames EnSh)))
				(progn
					(ChangeRecordTrigger itm 1 (GetIdShape EnSh))
					(cond 
						((= (GetTypeShape itm) 3) 		; attacco entra
							(vla-put-Color (vlax-ename->vla-object itm) $ColorEntra)
						)
						((= (GetTypeShape itm) 4) 		; attacco esci
							(vla-put-Color (vlax-ename->vla-object itm) $ColorEsci)
						)
					)
					(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) Grp) 'appenditems (list (vlax-ename->vla-object itm)))
				)
			)
		)
	)
	(ZoomWindow01 (car DimScreen) (cadr DimScreen))
	Rtn
)
;ChangeIdAfterCopy
;
;
(defun ActionCopyMemberShape (LstEname / Ename LstTrigger NameShape CutShape OrderShape PhaseShape MatShape TkShape QtaShape LstGrp LstWork itm GrName Ename)

	
	(if LstEname
		(progn
		
			; eseguo la verifica solo su elementi di EasyCut-command-reactor
			; raggruppo i contorni con gli attacchi
			
			(foreach Ename LstEname
				(if (CheckIfEasyCutShape Ename)
					(progn
						(setq LstTrigger (GetEnameTriggerByEnameShape Ename))
						(cond
							((and (member (car LstTrigger) LstEname) (member (cadr LstTrigger) LstEname))
								(setq LstWork (append LstWork (list (list Ename (car LstTrigger) (cadr LstTrigger)))))
							)
							((and (not (member (car LstTrigger) LstEname)) (not (member (cadr LstTrigger) LstEname)))
								(setq LstWork (append LstWork (list (list Ename nil nil))))
							)
						)
					)
				)
				; elimino gli attacchi senza gruppo
				(if (CheckIfEasyCutTrigger Ename)
					(if (not (gnames Ename)) (entdel Ename))
				)
			)
			
			(foreach Ename LstWork
				(if (= (GetTypShape (car Ename)) "CE")
					(progn
						(setq NameShape  (GetNameShape	(car Ename)))
						(setq CutShape   (GetCutShape	(car Ename)))
						(setq OrderShape (GetComShape	(car Ename)))
						(setq PhaseShape (GetPhaseShape	(car Ename)))
						(setq MatShape   (GetMatShape 	(car Ename)))
						(setq TkShape    (GetTkShape	(car Ename)))
						(setq QtaShape   (GetQtaShape	(car Ename)))
				
						(AssignNameShape (car Ename) (list	NameShape 		;nome piatto
															CutShape 		;compensazione taglio
															OrderShape 		;nome commessa
															PhaseShape 		;nome fase
															MatShape 		;nome qualita
															TkShape 		;spessore
															(Today)     	;ultima modifica
															QtaShape)) 		;quantita
					)
				)
			)
			; riassegno idtrigger
			(foreach Ename LstWork
				(setq IdShape (GetIdShape (car Ename)))
				(if (cadr  Ename) (ChangeRecordTrigger (cadr  Ename) 1 IdShape))
				(if (caddr Ename) (ChangeRecordTrigger (caddr Ename) 1 IdShape))
			)
			; raqgruppo i contorni senza gruppo
			(foreach Ename LstWork
				(setq LstGrp    (gnames (car Ename)))
				
				(if (not LstGrp)
					(progn
						(DetatchGroupToEname (car Ename))
						;(DetatchInfoEname (car Ename))
						(vla-put-Color (vlax-ename->vla-object (car Ename)) $ColorDetatch)
					)
				)
			)
		)
	)
)
;
;
;


