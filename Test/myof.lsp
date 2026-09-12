(defun OffsetShape (EnameShape OfsT / Offset GetEnameOffsetExpansion GetEnameOffsetContraction
									  Clock LstOffset Rtn)

	
	(defun Offset (EnameShape OfsT Clock / Nc EPoly LstEnameOffset)

		(setq Nc OfsT)
		(if (and EnameShape OfsT Clock)
			(progn
				(if (= Clock 3)
					(setq Nc (- 0.0 Nc))
				)
				(setq EPoly (MakePolyline (DiscretizeShapeNoControl EnameShape)))
				(if (not (vl-catch-all-error-p (setq o (vl-catch-all-apply 'vla-offset (list (vlax-ename->vla-object EPoly) Nc)))))
					(setq LstEnameOffset (mapcar 'vlax-vla-object->ename (vlax-safearray->list (vlax-variant-value o))))
				)
				(entdel EPoly)
			)
		)
		LstEnameOffset
	)
	;
	(defun GetEnameOffsetExpansion (EnameShape LstEnameOffset / itm LstArea Rtn)
		(if (and EnameShape LstEnameOffset)
			(progn
				(foreach itm LstEnameOffset (setq LstArea (append LstArea (list (list (vla-get-area (vlax-ename->vla-object itm)) itm)))))
				(setq LstArea (vl-sort LstArea (function (lambda (e1 e2)  (> (car e1) (car e2))))))
				(if (> (car (car LstArea)) (vla-get-area (vlax-ename->vla-object EnameShape)))
					(progn
						(setq Rtn (cadr (car LstArea)))
						(foreach itm (cdr LstArea) (entdel (cadr itm)))
					)
					(foreach itm LstEnameOffset (entdel itm))
				)
			)
		)
		Rtn
	)
	;
	(defun GetEnameOffsetContraction (EnameShape LstEnameOffset / Rtn)
		(if (and EnameShape LstEnameOffset)
			(if (and (= (length LstEnameOffset) 1)
					 (< (vla-get-area (vlax-ename->vla-object (car LstEnameOffset))) (vla-get-area (vlax-ename->vla-object EnameShape)))
				)
				(setq Rtn (car LstEnameOffset))
				(foreach itm LstEnameOffset (entdel itm))
			)
		)
		Rtn
	)
	;
	; Main 
	;
	(setq Clock          (ClockWeisEname EnameShape))
	(setq LstEnameOffset (Offset EnameShape OfsT Clock))
	
	(if LstEnameOffset
		(if (> OfsT 0) ; Expand
			(setq Rtn (GetEnameOffsetExpansion   EnameShape LstEnameOffset))
			(setq Rtn (GetEnameOffsetContraction EnameShape LstEnameOffset))
		)
	)
	Rtn
)
