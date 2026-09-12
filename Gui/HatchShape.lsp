(defun HatchShapeSheet(EnameSheet / itm)
	(if EnameSheet
		(foreach itm (GetLstEnameOnSheetWithFilterSetup EnameSheet)
			(HatchShape itm)
		)
	)
)
;
;
;
(defun BatchHatchDummyShape (EnameExternalShape LstEnameInternalShape Color TypeHatch Transparency / Rtn ObjHatch IdGroup)

	(if EnameExternalShape
		(progn
			(setq ObjHatch (MakeHatchShape EnameExternalShape LstEnameInternalShape TypeHatch))
			(if ObjHatch
				(progn
					(setq Rtn (vlax-vla-object->ename ObjHatch))
					(PutGroupToEname "HATCHEASYCUT" Rtn)
					(if Color
						(vla-put-color ObjHatch Color)
						(vla-put-color ObjHatch (vla-get-Color (vlax-ename->vla-object EnameExternalShape)))
					)
					(if (/= Transparency 0)
						(if (vlax-write-enabled-p ObjHatch) 
							(if (type vla-put-entitytransparency)
								(vla-put-entitytransparency ObjHatch Transparency) ;min 0 Max 90
							)
						)
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
(defun DeletedHatchEasyCut ( / LstEname itm)
	(setq LstEname (Genames "HATCHEASYCUT"))
	(foreach itm LstEname
		(if (entget (cdr itm))
			(entdel (cdr itm))
		)
	)
)
;
;
;
(defun GetEnameHatchEasyCut ( / LstEname itm Rtn)
	(setq LstEname (Genames "HATCHEASYCUT"))
	(foreach itm LstEname
		(setq Rtn (append Rtn (list (cdr itm))))
	)
	Rtn
)
;
;
;
(defun HatchShape (EnameShape / Rtn DataShape ColorShape ObjHatch IdGroup Rtn)
	(if EnameShape
		(progn
			(setq Rtn (GetEnameInternalShapeByDummyEnameSelect EnameShape))
			(setq DataShape (GetDataShape EnameShape))
			(if DataShape
				(progn
					(setq ColorShape (set_color (nth 10 DataShape)))
					(setq ObjHatch (MakeHatchShape EnameShape Rtn "SOLID"))
					(if ObjHatch
						(progn
							(setq IdGroup (Gnames EnameShape))
							(PutGroupToEname "HATCHEASYCUT"  (vlax-vla-object->ename ObjHatch))
							(PutGroupToEname (nth 0 IdGroup) (vlax-vla-object->ename ObjHatch))
							(ChangeColor (vlax-vla-object->ename ObjHatch) (nth 0 ColorShape) (nth 1 ColorShape))
							(setq Rtn (vlax-vla-object->ename ObjHatch))
						)
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

