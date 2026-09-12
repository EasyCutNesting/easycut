(defun ZoomWindow01 (Pt1 Pt2 / acadObj)

	(setq acadObj (vlax-get-acad-object))
	(vla-ZoomWindow acadObj (vlax-3d-point Pt1) (vlax-3d-point Pt2))
	T
)
;
;
;
(defun ZoomPrevius01 ( / acadObj)
	(setq acadObj (vlax-get-acad-object))
	(vla-ZoomPrevious acadObj)
)
;
;
;
(defun ZoomSsel (Ssel CatchArea / MinMaxSsel MinCatch MaxCatch)

	(if (and Ssel CatchArea)
		(progn
			(setq MinMaxSsel (LM:SSBoundingBox Ssel))
			(setq MinCatch 	 (list (- (nth 0 (nth 0 MinMaxSsel)) CatchArea)
							 	   (- (nth 1 (nth 0 MinMaxSsel)) CatchArea)
							 )
			)
			(setq MaxCatch 	(list (+ (nth 0 (nth 2 MinMaxSsel)) CatchArea)
								  (+ (nth 1 (nth 2 MinMaxSsel)) CatchArea)
							)
			)
			(vla-ZoomWindow (vlax-get-acad-object) (vlax-3d-point MinCatch) (vlax-3d-point MaxCatch))
		)
	)
)
;
;
;
(defun ZoomEname (EnameEntity CatchArea / acadObj Pmin Pmax MinCatch MaxCatch)

	
	(if (and EnameEntity CatchArea)
		(progn
			(setq acadObj (vlax-get-acad-object))
			(vla-getboundingbox (vlax-ename->vla-object EnameEntity) 'mnl 'mxl)
			(setq Pmin (vlax-safearray->list mnl))
			(setq Pmax (vlax-safearray->list mxl))
			
			(setq MinCatch 	(list (- (nth 0 Pmin)  CatchArea)
							      (- (nth 1 Pmin)  CatchArea)
							)
			)
			(setq MaxCatch 	(list (+ (nth 0 Pmax)  CatchArea)
								  (+ (nth 1 Pmax)  CatchArea)
							)
			)
			(vla-ZoomWindow acadObj (vlax-3d-point MinCatch) (vlax-3d-point MaxCatch))
		)
	)
)
;
;
;
(defun VisibleEname (EnameEntity / VisibleArea acadObj Rtn)

	(defun VisibleArea (EnameEntity / CatchArea DimScreen acadObj Pmin Pmax MinCatch MaxCatch Rtn)
	
		(setq CatchArea 50.0)
		(setq DimScreen (VpCoords))
		(setq acadObj (vlax-get-acad-object))
		(vla-getboundingbox (vlax-ename->vla-object EnameEntity) 'mnl 'mxl)
		(setq Pmin (vlax-safearray->list mnl))
		(setq Pmax (vlax-safearray->list mxl))
	
		(setq MinCatch (list (- (nth 0 Pmin)  CatchArea)
							 (- (nth 1 Pmin)  CatchArea)
						)
		)
		(setq MaxCatch (list (+ (nth 0 Pmax)  CatchArea)
							 (+ (nth 1 Pmax)  CatchArea)
						)
		)
	
		(if (and (<= (nth 0 (nth 0 DimScreen)) (nth 0 MinCatch))
				 (<= (nth 1 (nth 0 DimScreen)) (nth 1 MinCatch))
				 (>= (nth 0 (nth 1 DimScreen)) (nth 0 MaxCatch))
				 (>= (nth 1 (nth 1 DimScreen)) (nth 1 MaxCatch))
			)
			(setq Rtn nil)
			(setq Rtn (list MinCatch MaxCatch))
		)
		Rtn
	)
	;
	; Main
	;
	(if EnameEntity
		(progn
			(setq Rtn (VisibleArea EnameEntity))
			(setq acadObj (vlax-get-acad-object))
			(if Rtn
				(vla-ZoomWindow acadObj (vlax-3d-point (nth 0 Rtn)) (vlax-3d-point (nth 1 Rtn)))
			)
		)
	)
	Rtn
)
;
;
;
(defun VisibleEnameWithCathArea (EnameEntity CatchArea / VisibleArea acadObj Rtn)

	(defun VisibleArea (EnameEntity CatchArea /  DimScreen acadObj Pmin Pmax MinCatch MaxCatch Rtn)
	
		(setq DimScreen (VpCoords))
		(setq acadObj (vlax-get-acad-object))
		(vla-getboundingbox (vlax-ename->vla-object EnameEntity) 'mnl 'mxl)
		(setq Pmin (vlax-safearray->list mnl))
		(setq Pmax (vlax-safearray->list mxl))
	
		(setq MinCatch (list (- (nth 0 Pmin)  CatchArea)
							 (- (nth 1 Pmin)  CatchArea)
						)
		)
		(setq MaxCatch (list (+ (nth 0 Pmax)  CatchArea)
							 (+ (nth 1 Pmax)  CatchArea)
						)
		)
	
		(if (and (<= (nth 0 (nth 0 DimScreen)) (nth 0 MinCatch))
				 (<= (nth 1 (nth 0 DimScreen)) (nth 1 MinCatch))
				 (>= (nth 0 (nth 1 DimScreen)) (nth 0 MaxCatch))
				 (>= (nth 1 (nth 1 DimScreen)) (nth 1 MaxCatch))
			)
			(setq Rtn nil)
			(setq Rtn (list MinCatch MaxCatch))
		)
		
		Rtn
	)
	;
	; Main
	;
	(if (and EnameEntity CatchArea)
		(progn
			(setq Rtn (VisibleArea EnameEntity CatchArea))
			(setq acadObj (vlax-get-acad-object))
			(if Rtn
				(vla-ZoomWindow acadObj (vlax-3d-point (nth 0 Rtn)) (vlax-3d-point (nth 1 Rtn)))
			)
		)
	)
	Rtn
)
;
;
;
(defun ZoomPrevius (ChechDim / acadObj)

	(if ChechDim
		(progn
			(setq acadObj (vlax-get-acad-object))
			(vla-ZoomPrevious acadObj)
		)
	)
)