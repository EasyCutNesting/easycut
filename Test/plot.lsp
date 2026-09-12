(defun PrintFile(/ acadObject objDoc objPlot sFile sDwgPlotter objLayout err)

	(vl-load-com)
	(setq acadObject (vlax-get-acad-object))
	(setq objDoc (vla-get-activedocument acadobject))
	(setq objPlot (vla-get-plot objDoc))

	(setq sFile (Substr (vla-get-fullname objdoc) 1 (- (Strlen (vla-get-fullname objdoc)) 4)) )
  	(setq sFile (strcat sfile ".png") )
	
	(setq sDwgPlotter "PublishToWeb PNG.pc3")
	
	(setq objLayout (vla-get-activelayout objDoc))
	(vl-catch-all-apply 'vla-put-stylesheet (list objLayout "monochrome.ctb"))
	(vlax-put-property objLayout 'Plotrotation ac90degrees)
	(vlax-put-property objLayout 'PlotType acExtents)
	(vlax-put-property objLayout 'CenterPlot :vlax-true)
	(vlax-put-property objLayout 'StandardScale acVpScaleToFit)
	
	(setq p1 (getpoint "\nSelect Window Point No 1 (Lower Left): ")) 
	(setq p2 (getpoint p1 "\nSelect Window Point No 2 (Upper Right): ")) 
	
	(setq point1 (list (car p1) (cadr p1))) 
	(setq pPt1 (vlax-make-safearray vlax-vbDouble '(0 . 1))) 
	(setq pPt1sa (vlax-safearray-fill pPt1 point1)) 
	(setq pt1 	(vlax-make-variant 
					pPt1sa 
					(logior vlax-vbarray vlax-vbDouble) 
				) 
	)

	
	(setq point2 (list (car p2) (cadr p2))) 
	(setq pPt2 (vlax-make-safearray vlax-vbDouble '(0 . 1))) 
	(setq pPt2sa (vlax-safearray-fill pPt2 point2)) 
	(setq pt2 (vlax-make-variant 
       pPt2sa 
       (logior vlax-vbarray vlax-vbDouble) 
       ) 
	)	
	
	(command "regen")

	(vla-SetWindowToPlot objLayout pt1 pt2)
  	(setq err (vla-plottofile objPlot sFile sDwgPlotter))
)

(defun PlotSheet(EnameSheet)

		(if EnameSheet
			(progn

				(setq Ctb "monochrome.ctb")
				(setq Plotter "PublishToWeb JPG.pc3")
				(setq PaperSize "UserDefinedRaster (1200.00 x 1600.00Pixels)")
				
				(vla-getboundingbox (vlax-ename->vla-object EnameSheet) 'mshape 'xshape)
				(setq p1 (vlax-safearray->list mshape))
				(setq p2 (vlax-safearray->list xshape))
				
				
				(setq pPt1 (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (list (car p1) (cadr p1)))) 
				(setq pt1  (vlax-make-variant pPt1 (logior vlax-vbarray vlax-vbDouble)))
				(setq pPt2 (vlax-safearray-fill (vlax-make-safearray vlax-vbDouble '(0 . 1)) (list (car p2) (cadr p2)))) 
				(setq pt2  (vlax-make-variant pPt2 (logior vlax-vbarray vlax-vbDouble)))
				
				(setq DataSheet (GetDataSheetByEname EnameSheet))
				(setq FileName  (nth 0 DataSheet))
				
				
				(setq objDoc 	(vla-get-activedocument (vlax-get-acad-object)))
				(setq objPlot 	(vla-get-plot objDoc))
				(setq lay 		(vla-get-activelayout objDoc))
			
				(vla-put-ConfigName lay sDwgPlotter)		    ;set the plotter
				(vla-put-CanonicalMediaName lay PaperSize)		;set the paper size--->
				;(vla-put-PlotType lay "1")						;"0"=display "1"=extend "2"=limits
				(vla-put-CenterPlot lay :vlax-true)				;:vlax-true=center plot :vlax-false=no center plot
				;(vla-put-PaperUnits lay "1")					;set units to mm
				(vla-put-PlotWithLineweights lay :vlax-false)	;:vlax-true=turn on lineweights :vlax-false=turn off lineweights
				(vla-put-PlotWithPlotStyles lay :vlax-true)		;:vlax-true=turn on plot styles :vlax-flase=turn off plot styles
				(vla-put-StandardScale lay "0")					;fit to paper
				(vla-put-stylesheet lay Ctb)					;set  the CTB
				(vla-SetWindowToPlot lay pt1 pt2)
				(vla-put-PlotType lay acWindow)
				(vla-refreshplotdeviceinfo lay)
				(setq err (vla-plottofile objPlot FileName Plotter))
			)
		)

)		


