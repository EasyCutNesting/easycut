(defun Region2Polyline (EnameRegion Flag / :Region2Polyline $RtnGlobal)
	;
	(defun :Region2Polyline (EnameRegion Flag / Norm LstExpl itm)
		(if EnameRegion
			(progn
				;(setq Norm 		(vlax-get 	 (vlax-ename->vla-object EnameRegion) 'Normal))
				(setq LstExpl 	    (mapcar '(lambda (x) (vlax-vla-object->ename x))
														 (vlax-invoke (vlax-ename->vla-object EnameRegion) 'Explode)))
				(cond 
					( (vl-every '(lambda (x) (or (= (vla-get-ObjectName (vlax-ename->vla-object x)) "AcDbLine") 
												 (= (vla-get-ObjectName (vlax-ename->vla-object x)) "AcDbArc"))) LstExpl)
					  (setq $RtnGlobal (append $RtnGlobal (LineAndArc2LwPolyline LstExpl Flag)))
					  (if Flag (entdel EnameRegion))
					)
					(t 
						(foreach itm LstExpl
							(cond 
								((= (vla-get-ObjectName (vlax-ename->vla-object itm)) "AcDbRegion")
									(:Region2Polyline itm Flag)
								)
								((= (vla-get-ObjectName (vlax-ename->vla-object itm)) "AcDbCircle")
									(setq Rtn (Circle2LwPolyline itm Flag))
								)
								((= (vla-get-ObjectName (vlax-ename->vla-object itm)) "AcDbEllipse")
									(setq Rtn (Ellipse2LwPolyline itm Flag))
								)
							)
						)
					)
				)
			)
		)
	)
	;
	; Main ++++++++++++++
	;
	(setq $RtnGlobal nil)
	(if EnameRegion
		(:Region2Polyline EnameRegion Flag)
	)
	(if Flag (DeleteEntity (list EnameRegion)))
	(mapcar '(lambda (x) (vlax-vla-object->ename x)) $RtnGlobal)
)
