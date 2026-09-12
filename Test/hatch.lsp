(defun c:test( / EnameShape)
	(setq EnameShape (ssname (ssget) 0))
	(HatchShape EnameShape)
)

(defun HatchShape (EnameShape)
	(if EnameShape
		(progn
			(setq Rtn (GetEnameShape&TriggerByContour EnameShape))
			(if (nth 0 Rtn)
				(MakeHatchShape (nth 0 (nth 0 Rtn)) (cdr (nth 0 Rtn)) "SOLID")
			)
		)
	)
)


(defun MakeHatchShape (EnameShape LstEnameInternalShape TypeHatch / acdoc acspc hobj obj1 obj2 obj3)

    ;; Example by Lee Mac 2011  -  www.lee-mac.com

    (setq acdoc (vla-get-activedocument  (vlax-get-acad-object))
          acspc (vlax-get-property acdoc (if (= 1 (getvar 'CVPORT)) 'paperspace 'modelspace))
    )

    ;; Create some test shapes to demonstrate the idea:

    ;(setq obj1
    ;    (vla-addlightweightpolyline acspc
    ;        (vlax-make-variant
    ;            (vlax-safearray-fill (vlax-make-safearray vlax-vbdouble '(0 . 7))
    ;                '(0.0 0.0 3.0 0.0 3.0 1.0 0.0 1.0)
    ;            )
    ;        )
    ;    )
    ;)
    ;(vla-put-closed obj1 :vlax-true)
	
	
	

    ;(setq obj2 (vla-addcircle acspc (vlax-3D-point '(0.5 0.5 0.0)) 0.25))
    ;(setq obj3 (vla-addcircle acspc (vlax-3D-point '(1.5 0.5 0.0)) 0.25))

    ;; Add the Hatch Object:
	
	(setq obj1 (vlax-ename->vla-object EnameShape))
    (setq hobj (vla-addhatch acspc achatchpatterntypepredefined TypeHatch :vlax-true achatchobject))

    ;; The Hatch Object is currently volatile, the next step is important:

    (vla-appendouterloop hobj
        (vlax-make-variant
            (vlax-safearray-fill
                (vlax-make-safearray vlax-vbobject '(0 . 0))
                (list obj1)
            )
        )
    )

    ;; Create the Circular void:

	(foreach itm LstEnameInternalShape
		(vla-appendinnerloop hobj
			(vlax-make-variant
				(vlax-safearray-fill
					(vlax-make-safearray vlax-vbobject '(0 . 0))
					(list (vlax-ename->vla-object itm))
				)
			)
		)
	)
    ;(vla-appendinnerloop hobj
    ;    (vlax-make-variant
    ;        (vlax-safearray-fill
    ;            (vlax-make-safearray vlax-vbobject '(0 . 0))
    ;            (list obj3)
    ;        )
    ;    )
    ;)

    (vla-put-patternscale hobj 0.05)

    ;; Finished manipulation of the Hatch boundary, time to evaluate:

    (vla-evaluate hobj)
    ;(princ)
)
(defun ZoomEname (Ename / DimScreen acadObj Pmin Pmax WidthShape HeightShape MinCatch MaxCatch ChechDim)

	(if Ename
		(progn
			(setq DimScreen (VpCoords))
			(setq acadObj (vlax-get-acad-object))
			(vla-getboundingbox (vlax-ename->vla-object Ename) 'mnl 'mxl)
			(setq Pmin (vlax-safearray->list mnl))
			(setq Pmax (vlax-safearray->list mxl))
			(setq WidthShape   (abs (- (nth 0 pmax) (nth 0 pmin))))
			(setq HeightShape  (abs (- (nth 1 pmax) (nth 1 pmin))))	
			(setq MinCatch (list (- (nth 0 Pmin) WidthShape 100)
							 	 (- (nth 1 Pmin) HeightShape 100)
							)
			)
			(setq MaxCatch (list (+ (nth 0 Pmax) WidthShape 100)
							     (+ (nth 1 Pmax) HeightShape 100)
						   )
			)
			
			(if (and (<= (nth 0 (nth 0 DimScreen)) (nth 0 MinCatch))
					 (<= (nth 1 (nth 0 DimScreen)) (nth 1 MinCatch))
				)
				(setq ChechDim T)
				(setq ChechDim nil)
			)
			(if (and (>= (nth 0 (nth 1 DimScreen)) (nth 0 MaxCatch))
					 (>= (nth 1 (nth 1 DimScreen)) (nth 1 MaxCatch))
				)
				(setq ChechDim T)
				(setq ChechDim nil)
			)
			
			(if (null ChechDim)
				(vla-ZoomWindow acadObj (vlax-3d-point MinCatch) (vlax-3d-point MaxCatch))
			)
		)
	)
	ChechDim
)
(defun ZoomPrevius (ChechDim / DimScreen acadObj Pmin Pmax WidthShape HeightShape MinCatch MaxCatch ChechDim)

	(if (null ChechDim)
		(progn
			(setq acadObj (vlax-get-acad-object))
			(vla-ZoomPrevious acadObj)
		)
	)
)