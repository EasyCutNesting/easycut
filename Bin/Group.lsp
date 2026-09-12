;
; crea gruppi ad un gruppo di selezione ************************************************************************************
;
(defun PutGroupToSsel (SsgetSet NameGroup / i l)
	(if (and SsgetSet NameGroup)
		(if (> (sslength SsgetSet) 0)
			(progn
				(repeat (setq i (sslength SsgetSet))
					(setq l (cons (vlax-ename->vla-object (ssname SsgetSet (setq i (1- i)))) l))
				)
				(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) NameGroup) 'appenditems l)
			)
		)
	)
)
;
; assegna il gruppo ad una singola ename ***********************************************************************************
;
(defun PutGroupToEname (GroupName EnameToSet)

	(if (and GroupName EnameToSet)
		(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) GroupName) 'appenditems (list (vlax-ename->vla-object EnameToSet)))
	)
)
;
; restituisce la lista di gruppi in generale *******************************************************************************
;
(defun ListGroup->EnameCreate()
		(setq $ListGroupShape nil)
		(setq $ListGroupShape (dictsearch (namedobjdict) "acad_group"))
)
;
; cancella la lista di gruppi in generale **********************************************************************************
;
(defun ListGroup->EnameDelete()
		(setq $ListGroupShape nil)
)
;
; restituisce i nomi dei gruppi associati a questa entità ******************************************************************
;
(defun Gnames ( ename )
	(mapcar
		'(lambda (x) (vlax-get (vlax-ename->vla-object (cdr x)) 'Name))
		(vl-remove-if-not
			'(lambda (x)
				(and (eq 330 (car x))
					(member '(0 . "GROUP") (entget (cdr x)))
				)
			)
			(entget ename)
		)
	)
)
;
; cancella i gruppo dando il nome ******************************************************************************************
;
(defun DeleteGroupbyName (Name)
;   Arguments [Type]:
;   Name = Group name [STR]
   (or *activedoc*
       (setq *activedoc* (vla-get-activedocument (vlax-get-acad-object)))
   )
   (vl-catch-all-apply
   '(lambda ()
     (vla-delete
        (vla-item
        (vla-get-groups *activedoc*)
        Name
        )
     )
    )
   )
)
;
; restituisce le entità associate al gruppo ********************************************************************************
;
(defun Genames (gname / grpdict group key rtn)

    (setq grpdict (dictsearch (namedobjdict) "ACAD_GROUP"))
    (setq group (dictsearch (cdar grpdict) gname))
	(setq rtn nil)
    (if group
        (progn 
           (setq key (assoc 340 group))
           (setq rtn (member key group))

        )
    )
    rtn
)
;
; restituisce la descrizione del gruppo ************************************************************************************
;
(defun Gdescription (gname / group rtn grpdict)

    (setq grpdict (dictsearch (namedobjdict) "ACAD_GROUP"))
    (setq group   (dictsearch (cdar grpdict) gname))
	(setq rtn nil)
    (if group
           (setq rtn (cdr (assoc 300 group)))
    )
    rtn
)
;
; restituisce la lista dei nomi dei gruppi *********************************************************************************
;
(defun GroupList(/ outLst)
  (vl-load-com)
  (vlax-for x(vla-get-Groups(vla-get-ActiveDocument(vlax-get-acad-object)))
  (setq outLst(cons(vla-get-Name x)outLst)))
)
;
; cambia la descrizione del gruppo *****************************************************************************************
;
(defun ChDescGroup (group_name description / grpdict group)

      (setq grpdict     (dictsearch (namedobjdict) "ACAD_GROUP"))
	  (setq group       (dictsearch (cdar grpdict) group_name))

	  (if group
	      (entmod (subst (cons 300 description) (assoc 300 group) group))
	  )
	  
)
;
; cancella i gruppi senza associazione di entità ***************************************************************************
;
(defun PurgeAllGroupUnentity (/ itm)
    ;(setq list_group (GroupList))
	(foreach itm (GroupList)
		(if (not (Genames itm))
	       (DeleteGroupbyName itm)
		)
	)
)
;
; cambia il flag del gruppo da anonimo a normale ***************************************************************************
;
(defun AnonymousToNormalgroup (group_name / grpdict group)

      (setq grpdict     (dictsearch (namedobjdict) "ACAD_GROUP"))
	  (setq group       (dictsearch (cdar grpdict) group_name))
	  (if group
	      (entmod (subst (cons 70 0) (assoc 70 group) group))
	  )
)
; 
; cambia il nome del gruppo ************************************************************************************************
;
(defun ChangeNameGroup (newname oldname / grpdict group)

    (setq grpdict (dictsearch (namedobjdict) "ACAD_GROUP"))
    (entmod (subst (cons 3 newname) (cons 3 oldname) grpdict))

)
;
; restituisce la lista dei gruppi anonimi **********************************************************************************
;
(defun GetAnonymousGroup ( / GrpLst itm rtn)
	(setq GrpLst (GroupList))
	(setq rtn nil)
    (foreach itm GrpLst
	    (if (= (substr itm 1 1) "*")
		    (setq rtn (append rtn (list itm)))
		)
	)
	rtn
)
;
; UpGrade Drawing
;
(defun UpGradeGroup ( Verbose / Nel LstExternalShape Pos LstGroup
								itm GroupUnentity GroupEntity itm NumExternalShape GrName)
	;
	; Search Group ++++
	;
	(princ "\n")
	(setq LstGroup (GroupList))
	(setq Nel (length LstGroup))
	(StartProgressBar "SearchGroup:" Nel)
	(setq Pos 1)
	(princ (testo_a_sinistra "\r" 100))
	
	(foreach itm (GroupList)
		(UpDateProgressBar)
		(princ "\rSearchGroup:") (princ (strcat "[" (LM:rtos Pos 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)
		(setq Pos (1+ Pos))
		(if (not (Genames itm))
			(setq GroupUnentity (cons itm GroupUnentity))
			(setq GroupEntity   (cons itm GroupEntity))
		)
		
	)
	(ClearProgressBar)
	;
	; Deleted Group without entity ++++
	;
	(princ "\n")
	(setq Nel (length GroupUnentity))
	(StartProgressBar "GroupUnentity:" Nel)
	(setq Pos 1)
	(princ (testo_a_sinistra "\r" 100))
	
	(foreach itm GroupUnentity
		(UpDateProgressBar)
		(princ "\rGroupUnentity:") (princ (strcat "[" (LM:rtos Pos 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)
		(DeleteGroupbyName itm)
		(setq Pos (1+ Pos))
	)
	(ClearProgressBar)
	;
	; Assign name group  ++++
	;
	(princ "\n")
	(setq LstExternalShape (GetLstExternalShape))
	(setq Nel (length LstExternalShape))
	(StartProgressBar "AssignExternalShapeGroup:" Nel)
	(setq Pos 1)
	(princ (testo_a_sinistra "\r" 100))
	
	(setq NumExternalShape 0)
	(foreach itm LstExternalShape
		(UpDateProgressBar)
		(princ "\rAssignExternalShapeGroup:") (princ (strcat "[" (LM:rtos Pos 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)
		(setq Pos (1+ Pos))
		
		(if (not (Gnames itm))
			(progn
				(setq GrName (Random_Str 9))
				(AssignGroupNameShape itm GrName)
				(setq NumExternalShape (1+ NumExternalShape))
		   )
		)
	)
	(ClearProgressBar)
	
	(if Verbose
		(progn
			(princ "\n++ UpGradeGroup ++")
			(princ "\n Gruppi senza entita'         --> ") (princ (length GroupUnentity))	(if GroupUnentity (princ " eliminati"))
			(princ "\n Gruppi con entita'           --> ") (princ (length GroupEntity))
			(princ "\n Nuovi gruppi creati          --> ") (princ NumExternalShape)
		)
	)
	;(princ)
)
;
;
;
(defun UpGradeIdSheet ( Verbose / LstSheet Pos
								  Nel itm IdSheet LstIdSheet EnameSheet EnameBom LstSheet
								  NumIdChangeSheet NumIdChangeBom)

	
	(princ "\n")
	(setq LstSheet (LM:ss->ent (ssget "_X" (list (cons 67 0) (list -3 (list $RgpSheet))))))
	(setq Nel (length LstSheet))
	(StartProgressBar "SearchIdSheet:" Nel)
	(setq Pos 1)
	(princ (testo_a_sinistra "\r" 100))
	
	(foreach itm LstSheet
		(UpDateProgressBar)
		(princ "\rSearchIdSheet:") (princ (strcat "[" (LM:rtos Pos 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)
		(setq Pos (1+ Pos))
		(setq IdSheet (GetIdSheet itm))
		(if (not (assoc IdSheet LstIdSheet))
			(setq LstIdSheet (append (list (list IdSheet itm)) LstIdSheet))
			(setq LstIdSheet (subst  (append (assoc IdSheet LstIdSheet) (list itm)) (assoc IdSheet LstIdSheet) LstIdSheet))
		)
	)
	(ClearProgressBar)
	;
	;
	;
	(princ "\n")
	(setq Nel (length LstIdSheet))
	(StartProgressBar "IdSheet:" Nel)
	(setq NumIdChangeSheet 0)
	(princ (testo_a_sinistra "\r" 100))
	(setq LstSheet nil)
	
	(foreach itm  LstIdSheet
		(UpDateProgressBar)
		(princ "\rIdSheet") (princ (strcat "[" (LM:rtos (1+ NumIdChangeSheet) 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)
		(if (> (length (cdr itm)) 0)
			(foreach EnameSheet (cdr itm)
				(ChangeRecordSheet EnameSheet 2 (Random_Str 5))
				(setq LstSheet (cons EnameSheet LstSheet))
				(setq NumIdChangeSheet (1+ NumIdChangeSheet))
			)
		)
	)
	(ClearProgressBar)
	;
	;
	;
	(princ "\n")
	(setq Nel (length LstSheet))
	(StartProgressBar "IdBom:" Nel)
	(setq NumIdChangeBom 0)
	(princ (testo_a_sinistra "\r" 100))
	
	(foreach itm LstSheet
		(UpDateProgressBar)
		(princ "\rIdBom") (princ (strcat "[" (LM:rtos (1+ NumIdChangeBom) 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)
		(if (setq EnameBom (GetEnameBlockSheetByEnameSheet itm))
			(progn
				(setq IdSheet (GetIdSheet itm))
				(LM:vl-setattributevalue (vlax-ename->vla-object EnameBom) "ID_SHEET" IdSheet)
				(setq NumIdChangeBom (1+ NumIdChangeBom))
			)
		)
	)
	(ClearProgressBar)
	;
	(if Verbose
		(progn
			(princ "\n++ UpGradeIdSheet ++")
			(princ "\n Id lamiere sostituite        --> ") (princ NumIdChangeSheet)
			(princ "\n Id blocchi sostituiti        --> ") (princ NumIdChangeBom)
		)
	)
)
;
;
;
(defun UpGradeComplanarShape (Verbose / FileName LstShape Pos Nel itm LstData P10 Change StreamLog Info)

	
	
	; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(setq FileName (vl-filename-mktemp nil nil ".txt"))
	(if (setq StreamLog (open FileName "w"))
		(princ "\n+++++ Controllo entità complanari +++++\n" StreamLog)
		(alert (strcat "[UpGradeComplanarShape] Impossibile creare file di Log " StreamLog))
	)
	; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	(princ "\n")
	(setq LstShape (LM:ss->ent (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShape))))))
	(setq Nel (length LstShape))
	(StartProgressBar "SearchShape:" Nel)
	(setq Pos 1)
	(princ (testo_a_sinistra "\r" 100))

	
	(foreach itm LstShape
		(UpDateProgressBar)
		(princ "\rSearchShape") (princ (strcat "[" (LM:rtos Pos 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)
		(setq Pos (1+ Pos))
		(setq Change nil)
		
		(setq LstData (entget itm))
		(if (equal (cdr (assoc 210 LstData)) (list 0.0 0.0 1.0))
			(progn
				(cond 
					((= (cdr (assoc 0 (entget itm))) 	"LWPOLYLINE")
						(if (not (zerop (cdr (assoc 38 LstData))))
							(progn 
								(setq LstData (subst (cons 38 0.0) (assoc 38 LstData) LstData))
								(setq Change T)
							)
						)
					)
					((or (= (cdr (assoc 0 LstData))	"CIRCLE") (= (cdr (assoc 0 LstData)) "ELLIPSE"))
						 (setq P10 (cdr (assoc 10 LstData)))
						 (if (not (zerop (last (assoc 10 LstData))))
							(progn
								(setq LstData (subst (list 10 (car P10) (cadr P10) 0.0) (assoc 10 LstData) LstData))
								(setq Change T)
							)
						)
					)
					(t 
						(if Verbose
							(princ (strcat "[UpGradeComplanarShape] Entita' " (cdr (assoc 0 LstData)) " non riconsciuta"
										   " Handle Id " (cdr (assoc 5 LstData)) "\n"))
						)
						(if StreamLog
							(princ (strcat "[UpGradeComplanarShape] Entita' " (cdr (assoc 0 LstData)) " non riconsciuta"
										   " Handle Id " (cdr (assoc 5 LstData)) "\n") StreamLog)
						)
					)
				)
				(if Change
					(progn
						(entmod LstData)
						(entupd itm)
						(if Verbose
							(princ (strcat "[UpGradeComplanarShape] Entita' " (cdr (assoc 0 LstData)) " appiattita"
										   " Handle Id " (cdr (assoc 5 LstData)) "\n"))
						)
						(if StreamLog
							(progn
								(princ (strcat "[UpGradeComplanarShape] Entita' " (cdr (assoc 0 LstData)) " appiattita"
											   " Handle Id " (cdr (assoc 5 LstData)) "\n") StreamLog)
								(setq Info T)
							)
						)
					)
				)
			)
			(progn
				(if Verbose
					(princ (strcat "[UpGradeComplanarShape] Entita' " (cdr (assoc 0 LstData)) " la direzione non è nel piano globale "
								   " Handle Id " (cdr (assoc 5 LstData)) "\n"))
				)
				(if StreamLog
					(progn
						(princ (strcat "[UpGradeComplanarShape] Entita' " (cdr (assoc 0 LstData)) " la direzione non è nel piano globale "
									   " Handle Id " (cdr (assoc 5 LstData)) "\n") StreamLog)
						(setq Info T)
					)
				)
			)
		)
	)
	(if StreamLog
		(progn 
			(princ "\n+++++ Fine +++++\n" StreamLog)
			(close StreamLog)
			(if Info (EasyCutViewer FileName))
		)
	)

	(ClearProgressBar)
)
;
;
;
(defun UpGradeIdShape ( Verbose / AuditShapeBomBarCode
								  LstShape Nel Pos LstAssoc
								  itm IdShape OldIdShape OldNameBlock Ssel LstIdShape 
								  NumIdChangeShape NumIdChangeBom NumIdBarcode NumIdChangeTrigger
								  EnameShape EnameTrigger EnameBom
								  LstExternalShape LstInternalShape)


								  
	(defun AuditBomBarCode (/ GetLStIdBom GetLstIdBarCode GetLstIdShape AuditBom->BarCode AuditShape->Bom
							  LstIdBom LstIdBarCode LstIdShape Rtn)
	
		(defun GetLstIdBom (/ itm LstIdBom)
			(foreach itm (LM:ss->ent (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShapeTarget)))))
				(setq LstIdBom (append LstIdBom (list (LM:vl-getattributevalue (vlax-ename->vla-object itm) "IDSHAPE"))))
			)
			LstIdBom
		)
		;
		(defun GetLstIdBarCode (/ itm LstIdBarcode)
			(foreach itm (LM:ss->ent (ssget "_X" (list (cons 67 0) (cons 0  "INSERT"))))
				(if (wcmatch (vla-get-effectivename (vlax-ename->vla-object itm)) "BARCODE128_*")
					(setq LstIdBarCode (append LstIdBarCode (list (substr (vla-get-effectivename (vlax-ename->vla-object itm)) 12))))
				)
			)
			LstIdBarCode
		)
		;
		(defun GetLstIdShape (/ itm LstIdShape)
			(foreach itm (LM:ss->ent (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShape)))))
				(if (= (GetTypShape itm) "CE")
					(setq LstIdShape (append LstIdShape (list (GetIdShape itm))))
				)
			)
			LstIdShape
		)
		;
		(defun AuditBom->BarCode (LstIdBom LstIdBarCode / LstIdBom LstIdBarCode itm EnameBlockShape 
														  IdShape EnameBarCode OldNameBlock Rtn)
		
			; Rtn 1 LstIdBom and LstIdBarCode equal
			; Rtn 2 LstIdBom and LstIdBarCode not equal
			; Rtn 3 LstIdBom nil and LstIdBarCode true
			; Rtn 4 LstIdBom true and LstIdBarCode nil
			; Rtn 5 LstIdBom nil and LstIdBarCode nil
			
			(cond
				((and LstIdBom LstIdBarCode)
					(if (not (equal (vl-sort LstIdBom '>) (vl-sort LstIdBarcode '>)))
						(progn
							(foreach itm LstIdBom
								(setq EnameBlockShape  	(GetEnameBlockShapeById itm))
						
								(if (setq EnameBarCode (GetEnameBlockBarCode EnameBlockShape))
									(progn
										(setq OldNameBlock (GetNameBlock EnameBarCode))
										(LM:RenameBlockReference EnameBarCode (strcat "BARCODE128_" itm))
										(PurgeBlock OldNameBlock)
									)
								)
							)
							(if (equal (vl-sort (GetLstIdBarCode) '>) (vl-sort LstIdBom '>)) (setq Rtn 1) (setq Rtn 2))
						)
						(setq Rtn 1)
					)
				)
				((and (not LstIdBom) LstIdBarCode)
					(setq Rtn 3)
				)
				((and LstIdBom (not LstIdBarCode))
					(setq Rtn 4)
				)
				((and (not LstIdBom) (not LstIdBarCode))
					(setq Rtn 5)
				)
			)
			Rtn
		)
		;
		(defun AuditShape->Bom (LstIdShape LstIdBom / LstIdBom LstIdShape Rtn)

			; Rtn 1 LstIdBom and LstIdShape equal
			; Rtn 2 LstIdBom and LstIdShape not equal
			; Rtn 3 LstIdBom nil and LstIdShape true
			; Rtn 4 LstIdBom true and LstIdShape nil
			; Rtn 5 LstIdBom nil and LstIdShape nil
		
			(cond
				((and LstIdShape LstIdBom)
					(if (equal (vl-sort LstIdBom '>) (vl-sort LstIdShape '>))
						(setq Rtn 1)
						(setq Rtn 2)
					)
				)
				((and (not LstIdBom) LstIdShape)
					(setq Rtn 3)
				)
				((and LstIdBom (not LstIdShape))
					(setq Rtn 4)
				)
				((and (not LstIdBom) (not LstIdShape))
					(setq Rtn 5)
				)
			)
			Rtn
		)
		;
		; Main
		;
		(setq LstIdBom		(GetLStIdBom))
		(setq LstIdBarCode  (GetLstIdBarCode))
		;(setq LstIdShape    (GetLstIdShape))

		(setq Rtn (AuditBom->BarCode LstIdBom LstIdBarCode))
		;(cond	
		;	((= Rtn 1)
		;		(LM:popup "avvertimento" "Cartigli e BarCode congrui" (+ 1 48 4096))
		;	)
		;	((= Rtn 2)
		;		(LM:popup "avvertimento" "Cartigli e BarCode non congrui" (+ 1 48 4096))
		;	)
		;	((= Rtn 3)
		;		(LM:popup "avvertimento" "Cartigli non presenti BarCode presenti" (+ 1 48 4096))
		;	)
		;	((= Rtn 4)
		;		(LM:popup "avvertimento" "Cartigli presenti BarCode non presenti" (+ 1 48 4096))
		;	)
		;)
		;(setq Rtn (AuditShape->Bom LstIdShape LstIdBom))
		;(cond	
		;	((= Rtn 1)
		;		(LM:popup "avvertimento" "Cartigli e Contorni congrui" (+ 1 48 4096))
		;	)
		;	((= Rtn 2)
		;		(LM:popup "avvertimento" "Cartigli e Contorni non congrui" (+ 1 48 4096))
		;	)
		;	((= Rtn 3)
		;		(LM:popup "avvertimento" "Cartigli non presenti Contorni presenti" (+ 1 48 4096))
		;	)
		;	((= Rtn 4)
		;		(LM:popup "avvertimento" "Cartigli presenti Contorni non presenti" (+ 1 48 4096))
		;	)
		;)
	)
	;
	; Main
	;
	(princ "\n")
	(setq LstShape (LM:ss->ent (ssget "_X" (list (cons 67 0) (list -3 (list $RgpShape))))))
	(setq Nel (length LstShape))
	(StartProgressBar "SearchIdShape:" Nel)
	(setq Pos 1)
	(princ (testo_a_sinistra "\r" 100))
								  
	(foreach itm LstShape
		(UpDateProgressBar)
		(princ "\rSearchIdShape") (princ (strcat "[" (LM:rtos Pos 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)
		(setq Pos (1+ Pos))
		
		;(setq IdShape (GetIdShape itm))
		(setq IdShape (cdr (nth 3 (nth 1 (assoc -3 (entget itm (list "*")))))))
		
		(if (not (assoc IdShape LstIdShape))
			(setq LstIdShape (append (list (list IdShape itm)) LstIdShape))
			(setq LstIdShape (subst  (append (assoc IdShape LstIdShape) (list itm)) (assoc IdShape LstIdShape) LstIdShape))
		)
	)
	(ClearProgressBar)
	;
	;
	;
	(princ "\n")
	(setq Nel (length LstIdShape))
	(StartProgressBar "ChangeRecordShape:" Nel)
	(princ (testo_a_sinistra "\r" 100))
	(setq NumIdChangeShape 0)
	
	(foreach itm  LstIdShape
		(UpDateProgressBar)
		(princ "\rChangeRecordShape") (princ (strcat "[" (LM:rtos (1+ NumIdChangeShape) 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)

		(if (> (length (cdr itm)) 0)
			(foreach EnameShape (cdr itm)
				(ChangeRecordShape EnameShape 2 (Random_Str 9))
				(cond
					((= (GetTypShape EnameShape) "CE")
						(setq LstExternalShape (cons EnameShape LstExternalShape))
					)
					((= (GetTypShape EnameShape) "CI")
						(setq LstInternalShape (cons EnameShape LstInternalShape))
					)
				)
				(setq NumIdChangeShape (1+ NumIdChangeShape))
			)
		)
	)
	(ClearProgressBar)
	;
	;
	;
	(princ "\n")
	(setq LstAssoc (GetAssocEnameShapeWithEnameBom))
	(setq Nel (length LstAssoc))
	(StartProgressBar "ChangeIdShapeOnBom:" Nel)
	(princ (testo_a_sinistra "\r" 100))
	
	(setq NumIdChangeBom 0)
	(setq NumIdBarcode   0)
	(AuditBomBarCode)
	(foreach itm LstAssoc
		(UpDateProgressBar)
		(princ "\rChangeIdShapeOnBom") (princ (strcat "[" (LM:rtos (1+ NumIdChangeBom) 2 0)  "/"  (LM:rtos Nel 2 0) "] ")) (princ itm)

		(setq EnameBom (cadr itm))
		(setq IdShape (GetIdShape (car itm)))
		; ------------------------ change name Barcode ------------------------------------------------
		(setq OldIdShape 		(LM:vl-getattributevalue (vlax-ename->vla-object EnameBom) "IDSHAPE"))
		(if (setq Ssel (ssget "_X" (list (cons 67 0) (cons 0  "INSERT") (cons 2 (strcat "BARCODE128_" OldIdShape)))))
			(progn
				(setq OldNameBlock (GetNameBlock (car (LM:ss->ent Ssel))))
				(setq NumIdBarcode (1+ NumIdBarcode))
				(LM:RenameBlockReference (car (LM:ss->ent Ssel)) (strcat "BARCODE128_" IdShape))
				(PurgeBlock OldNameBlock)
			)
		)
		; ---------------------------------------------------------------------------------------------
		(LM:vl-setattributevalue (vlax-ename->vla-object EnameBom) "IDSHAPE" IdShape)
		(setq NumIdChangeBom (1+ NumIdChangeBom))
	)
	(ClearProgressBar)
	;
	;
	;
	(setq NumIdChangeTrigger 0)
	(foreach itm LstExternalShape
		(foreach EnameTrigger (GetContactEnameTriggerByDummyShape itm)
			(ChangeRecordTrigger EnameTrigger 1 (GetIdShape itm))
			(setq NumIdChangeTrigger (1+ NumIdChangeTrigger))
		)
	)
	;
	;
	;
	(foreach itm LstInternalShape
		(foreach EnameTrigger (GetContactEnameTriggerByDummyShape itm)
			(ChangeRecordTrigger EnameTrigger 1 (GetIdShape itm))
			(setq NumIdChangeTrigger (1+ NumIdChangeTrigger))
		)
	)
	
	(if Verbose
		(progn
			(princ "\n++ UpGradeIdShape ++")
			(princ "\n Id contorni sostituiti       --> ") (princ NumIdChangeShape)
			(princ "\n Id attacchi sostituiti       --> ") (princ NumIdChangeTrigger)
			(princ "\n Id cartigli sostituiti       --> ") (princ NumIdChangeBom)
			(princ "\n Id barcode sostituiti        --> ") (princ NumIdBarcode)
		)
	)
	;(princ)
)
;
;
;
