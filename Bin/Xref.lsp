; https://lispbox.wordpress.com/2016/05/01/remove-any-unloaded-unreferenced-xrefsimagespdfsdgns-and-dwfs-in-a-one-click/

(defun DetachImage (nomefile / Status dict data)

	(setq Status (CheckStatusImageReferenced nomefile))
	
	(cond	
	
		((> (nth 0 Status) 0)
		
			; elimino l'immagine presente nel disegno
			
			(setq dict (namedobjdict)
			      data (entget dict)
			      dict (cdr (assoc -1 data))
		    )
			(dictremove dict (nth 1 Status))
			(entdel (nth 2 Status))
			
		)
	)
)

(defun AttachImage (nomefile insertionPoint scalefactor rotAngle / acadObj doc modelSpace raster)

	(DetachImage nomefile)
	
	(setq acadObj (vlax-get-acad-object)
	      doc (vla-get-ActiveDocument acadObj)
	      modelSpace (vla-get-ModelSpace doc)
	)
	(if (/= (findfile nomefile) nil)
			(setq raster (vla-AddRaster modelSpace 
							(findfile nomefile)
							(vlax-3d-point insertionPoint)
							scalefactor rotAngle)
			)			
	)
	raster
)


(defun CheckStatusImageReferenced (namefile / dict data name i tData imName)

	; Return
	; 0 il file non è presente nel disegno
	; 1 l'immagine è collegata e visibile
	; 2 l'immagine è collegata ma non caricata
	; 3 l'immagine è collegata ma ha perso il path
	
	(defun isDefReferenced ( aEname / cnt data )
		(setq cnt 0)
		(foreach i (entget aEname)
			(if (and 
					(equal (car i) 330)
					(setq data (entget (cdr i)))
					(= (cdr (assoc 0 data)) "IMAGEDEF_REACTOR"))
					(foreach j data
						(if (and (equal (car j) 330) (entget (cdr j)))
							(setq cnt (+ cnt 1))
						)
					)
			)
		)
		(> cnt 0)
	)	
	
	(setq rtn (list 0 nil nil))
	(setq dict (namedobjdict))
	(setq data (entget dict))
	(setq name "ACAD_IMAGE_DICT")
	(if (setq data (dictsearch dict name))
		(foreach i data
			(cond
				((and imName (equal (car i) 350))
			
					(setq tData (entget (cdr i)))
					(if (= (strcase (cdr (assoc 1 tData))) (strcase namefile))
							
						(cond
							((and (isDefReferenced (cdr i)) (equal (cdr (assoc 280 tData)) 1))
								(setq rtn (list 1 imName (cdr i))) ;(alert "immagine collegata e visibile")
							)
							((and (isDefReferenced (cdr i)) (equal (cdr (assoc 280 tData)) 0))
								(setq rtn (list 2 imName (cdr i))) ;(alert "immagine collegata ma non caricata")
							)
							((and (not (isDefReferenced (cdr i))) (equal (cdr (assoc 280 tData)) 1))
								(setq rtn (list 3 imName (cdr i))) ;(alert "immagine collegata ma non referenziata")
							)
						)
					)
				)
				((equal (car i) 3) (setq imName (cdr i)))
				(t (setq imName nil))
			)
		)
	)
	rtn
)


(defun RemoveXrefDetach ()

; 	Detach any unloaded (unreferenced) XREFs

	(vlax-for BIND_xrefname (vla-get-blocks (vla-get-ActiveDocument (vlax-get-Acad-object)))
		(if (= (vla-get-isxref BIND_xrefname) ':vlax-true)
			(progn
				(setq BIND_cont (entget (vlax-vla-object->ename BIND_xrefname))
					  BIND_cont (tblsearch "BLOCK" (cdr (assoc 2 BIND_cont)))
				)
				(if (or (= (cdr (assoc 70 BIND_cont)) 4) (= (cdr (assoc 70 BIND_cont)) 12))
					(vla-Detach BIND_xrefname)
				)
			)
		)
	)
)
;
;
(defun RemoveImageDetach ( / isDefReferenced dict data name tData lst imName )

;	Remove image definition of unreferenced and unloaded definitions.

	(defun isDefReferenced ( aEname / cnt data )
		(setq cnt 0)
		(foreach i (entget aEname)
			(if (and 
					(equal (car i) 330)
					(setq data (entget (cdr i)))
					(= (cdr (assoc 0 data)) "IMAGEDEF_REACTOR"))
					(foreach j data
						(if (and (equal (car j) 330) (entget (cdr j)))
							(setq cnt (+ cnt 1))
						)
					)
			)
		)
		(> cnt 0)
	)
;-------------------------------------------------------
	(setq dict (namedobjdict))
	(setq data (entget dict))
	(setq name "ACAD_IMAGE_DICT")
	(if (setq data (dictsearch dict name))
		(foreach i data
			(cond
				((and imName (equal (car i) 350))
					;check to see if unreferenced or unload
					(setq tData (entget (cdr i)))
					(if (or (equal (cdr (assoc 280 tData)) 0) (not (isDefReferenced (cdr i))))
						(setq lst (cons (cons imName (cdr i)) lst))
					)
				)
				((equal (car i) 3) (setq imName (cdr i)))
					(t (setq imName nil))
			)
		)
	)
	
	(princ lst)
	(if lst
		(progn
			(setq dict (cdr (assoc -1 data)))
			(foreach i lst
				(dictremove dict (car i))
				(entdel (cdr i))
			)
			(prompt (strcat "\n Removed " (itoa (length lst)) " image definition(s)."))
		)
	)
	(princ)
)
;
;
(defun c:RemovePdfDetach ( / isDefReferenced dict data name tData lst imName )

	; Remove pdf definition of unreferenced and unloaded definitions.
	
	(defun isDefReferenced ( aEname / cnt data )
		(setq cnt 0)
		(foreach i (entget aEname)
			(if
				(and
					(equal (car i) 330)
					(setq data (entget (cdr i)))
					(= (cdr (assoc 0 data)) "IMAGEDEF_REACTOR")
				)
				(foreach j data
					(if (and (equal (car j) 330) (entget (cdr j)))
						(setq cnt (+ cnt 1))
					)
				)
			)
		)
		(> cnt 0)
	)
;-------------------------------------------------------
	(setq dict (namedobjdict))
	(setq data (entget dict))
	(setq name "ACAD_PDFDEFINITIONS")
	(if (setq data (dictsearch dict name))
		(foreach i data
			(cond
				((and imName (equal (car i) 350))
					;check to see if unreferenced or unload
					(setq tData (entget (cdr i)))
					(if (or (equal (cdr (assoc 280 tData)) 0) (not (isDefReferenced (cdr i))))
						(setq lst (cons (cons imName (cdr i)) lst))
					)
				)
				((equal (car i) 3) (setq imName (cdr i)))
					(t (setq imName nil))
			)
		)
	)
	(if lst
		(progn
			(setq dict (cdr (assoc -1 data)))
			(foreach i lst
				(dictremove dict (car i))
				(entdel (cdr i))
			)
			(prompt (strcat "\n Removed " (itoa (length lst)) " pdf definition(s)."))
		)
	)
	(princ)
)
;
;
(defun RemoveDgnDetach ( / isDefReferenced dict data name tData lst imName )

	; Remove dgn definition of unreferenced and unloaded definitions.
	
		(defun isDefReferenced ( aEname / cnt data )
			(setq cnt 0)
			(foreach i (entget aEname)
				(if
					(and
						(equal (car i) 330)
						(setq data (entget (cdr i)))
						(= (cdr (assoc 0 data)) "IMAGEDEF_REACTOR")
					)
					(foreach j data
						(if (and (equal (car j) 330) (entget (cdr j)))
							(setq cnt (+ cnt 1))
						)
					)
				)
			)
			(> cnt 0)
		)
;-------------------------------------------------------
	(setq dict (namedobjdict))
	(setq data (entget dict))
	(setq name "ACAD_DGNDEFINITIONS")
	(if (setq data (dictsearch dict name))
		(foreach i data
			(cond
				((and imName (equal (car i) 350))
					;check to see if unreferenced or unload
					(setq tData (entget (cdr i)))
					(if (or (equal (cdr (assoc 280 tData)) 0) (not (isDefReferenced (cdr i))))
						(setq lst (cons (cons imName (cdr i)) lst))
					)
				)
				((equal (car i) 3) (setq imName (cdr i)))
					(t (setq imName nil))
			)
		)
	)
	(if lst
		(progn
			(setq dict (cdr (assoc -1 data)))
			(foreach i lst
				(dictremove dict (car i))
				(entdel (cdr i))
			)
			(prompt (strcat "\n Removed " (itoa (length lst)) " dgn definition(s)."))
		)
	)
	(princ)
)
;
;
;
(defun RemoveDwfDetach ( / isDefReferenced dict data name tData lst imName )

	; Remove dwf definition of unreferenced and unloaded definitions.
	
	(defun isDefReferenced ( aEname / cnt data )
		(setq cnt 0)
		(foreach i (entget aEname)
			(if
				(and
					(equal (car i) 330)
					(setq data (entget (cdr i)))
					(= (cdr (assoc 0 data)) "IMAGEDEF_REACTOR")
				)
				(foreach j data
					(if (and (equal (car j) 330) (entget (cdr j)))
						(setq cnt (+ cnt 1))
					)
				)
			)
		)
		(> cnt 0)
	)
	;-------------------------------------------------------
	(setq dict (namedobjdict))
	(setq data (entget dict))
	(setq name "ACAD_DWFDEFINITIONS")
	(if (setq data (dictsearch dict name))
		(foreach i data
			(cond
				((and imName (equal (car i) 350))
					;check to see if unreferenced or unload
					(setq tData (entget (cdr i)))
					(if (or (equal (cdr (assoc 280 tData)) 0) (not (isDefReferenced (cdr i))))
						(setq lst (cons (cons imName (cdr i)) lst))
					)
				)
				((equal (car i) 3) (setq imName (cdr i)))
					(t (setq imName nil))
			)
		)
	)
	(if lst
		(progn
			(setq dict (cdr (assoc -1 data)))
			(foreach i lst
				(dictremove dict (car i))
				(entdel (cdr i))
			)
			(prompt (strcat "\n Removed " (itoa (length lst)) " dwf definition(s)."))
		)
	)
(princ)
)

