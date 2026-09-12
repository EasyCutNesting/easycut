(defun MakeStyle (FileFont NameStyle LstAttribute ActivateStyle / acadApp acadDoc styles objStyle HeigthStyle  WidthStyle  ObliqueAgleStyle)
 
	;LstAttribute
	;	0	height
	;	1	width
	;	2	obliqueangle
		
	(if (and FileFont NameStyle)
		(if (not (tblobjname "style" NameStyle))
			(progn
				(setq acadApp  (vlax-get-Acad-object)) 
				(setq acadDoc  (vla-get-ActiveDocument acadApp)) 
				(setq styles   (vla-get-textstyles acadDoc))
				(setq objStyle (vla-add styles NameStyle))
				(vla-put-fontfile objStyle FileFont)
				
				(if (null (nth 0 LstAttribute))
					(setq HeigthStyle 0)
					(setq HeigthStyle (nth 0 LstAttribute))
				)
				(if (null (nth 1 LstAttribute))
					(setq WidthStyle 1)
					(setq WidthStyle (nth 1 LstAttribute))
				)
				(if (null (nth 2 LstAttribute))
					(setq ObliqueAgleStyle 0.0)
					(setq ObliqueAgleStyle (nth 2 LstAttribute))
				)
				(vla-put-height       objStyle HeigthStyle)
				(vla-put-width        objStyle WidthStyle)
				(vla-put-obliqueangle objStyle (/ (* ObliqueAgleStyle PI) 180.0))
				
				(if (= ActivateStyle 1)
					(vla-put-activetextstyle acadDoc objStyle)
				)
			)
		)
	)
	
)
;
;
;
(MakeStyle (strcat FontPathEasyCut$  $FontBarCodeEasyCut) $StyleEasyCutBarCode (list nil nil nil) 0)
(MakeStyle (strcat FontPathEasyCut$  $FontDefaultEasyCut) $StyleEasyCut        (list 10 0.8 15) 1)
