;
;
(defun GetDimensionBySurfaceSheet (Surface LstData / Dec MinWidth MaxWidth MinLength MaxLength Step 
													_Width _Length NumberStepWidth NumberStepLength Qta Scrap Rtn)


	
	(setq Dec 4)
	(setq MinWidth 	(nth 0 LstData))
	(setq MaxWidth 	(nth 1 LstData))
	(setq MinLength	(nth 2 LstData))
	(setq MaxLength	(nth 3 LstData))
	(setq Step		(nth 4 LstData))

	(setq _Width  MinWidth)
	(setq _Length MinLength)
	
	(setq NumberStepWidth  (1+ (fix (/ (- MaxWidth  MinWidth)   Step))))
	(setq NumberStepLength (1+ (fix (/ (- MaxLength MinLength)  Step))))
	
	(StartProgressBar "Search Sheet:" (* NumberStepWidth (1+ NumberStepLength)))

	(repeat NumberStepWidth
			
		(repeat NumberStepLength
			(setq Qta (fix (LM:roundup (/ Surface (* (/ _Width 1000.0) (/ _Length 1000.0)))1)))
			(setq Scrap (- 1.0 (/ Surface (* Qta (/ _Width 1000.0) (/ _Length 1000.0)))))
			(setq Rtn (append Rtn (list (list Qta (GetReal_ (/ _Width 1000.0) Dec) (GetReal_ (/ _Length 1000.0) Dec) Scrap
										)
								  )
					  )
			)
			(setq _Length (+ _Length Step))
			(UpDateProgressBar)
		)
		(setq _Length MinLength)
		(setq _Width (+ _Width Step))
		(UpDateProgressBar)
	)
	(ClearProgressBar)
	Rtn
)
;
;
