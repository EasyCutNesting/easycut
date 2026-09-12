;
(defun LeaderCoo (/ *error* Loop Pt)
	
	(defun *error* (msg)
		(princ)
	)
	;
	(setq Loop T)
	(RestoreUcs	UcsActEasyCut$)
	(while Loop
		(initget 128)
		(setq Pt (getpoint "\nPunto Coordinata [O]ption "))
		(cond 
			((null Pt)
				(setq Loop nil)
			)
			((listp Pt)
				(PutCoordinate Pt)
			)
			((or (= Pt "O") (= Pt "o"))
				(SetupLeader)
			)
			(t
				(princ "\n[O or o or pick point]")
			)
		)
	)
	(princ)
)
;
;
;
(defun SetupLeader (/ LoadCfgLeadr GetCfgLeadr
					  xx CfgLeader)
	;
	(defun LoadCfgLeadr (LstCfgLeader / KeyDcl Num itm)

		(setq KeyDcl (list "Ucs" "X" "Y" "Z" "Rotation" "Frame" "Mask" "PrX" "PrY" "PrZ" "Preci" "FactX" "FactY" "FactZ" "ColorText" "ColorLeader"
						   "HeightText" "WidthText" "ScaleText" "TypeArrow" "DimArrow"))
		(setq Num 0)
		(foreach itm  LstCfgLeader
			(set_tile (nth Num KeyDcl) itm)
			(setq Num (1+ Num))
		)
	)
	;
	(defun SetCfgLeadr (Dialog / KeyDcl itm Rtn DataRegistry)

		(setq KeyDcl (list "Ucs" "X" "Y" "Z" "Rotation" "Frame" "Mask" "PrX" "PrY" "PrZ" "Preci" "FactX" "FactY" "FactZ" "ColorText" "ColorLeader"
						   "HeightText" "WidthText" "ScaleText" "TypeArrow" "SizeArrow"))
						   
		(setq DataRegistry "")
		(foreach itm KeyDcl
			(setq Rtn (append Rtn (list (get_tile itm))))
			(setq DataRegistry (strcat DataRegistry (get_tile itm) "|"))
		)
		(if (CkeckDataDcl Rtn)
			(progn
				(vl-registry-write EasyCutRegistryPath$ "Leader" DataRegistry)
				(setq *LeaderDialog* (done_dialog)) 
				(unload_dialog Dialog)
			)
			(alert "Dati incompleti o errati")
		)
	)
	;
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
	(new_dialog "LeaderDialog" xx "" (cond ( *LeaderDialog* ) ( '(-1 -1) )))
		(setq CfgLeader (ReadSetupLeader))
		(LoadCfgLeadr CfgLeader)
		(action_tile "accept" "(SetCfgLeadr xx)")
		(action_tile "cancel" "(setq *LeaderDialog* (done_dialog)) (unload_dialog xx)")
		(start_dialog)
)
;
;
;
(defun ReadSetupLeader (/ Rtn itm LeaderSetup SplitLeaderSetup)

	(setq LeaderSetup (vl-registry-read EasyCutRegistryPath$ "Leader"))
	
	(if (or (not LeaderSetup) (= LeaderSetup ""))
		(setq Rtn (list	"1"									;Ucs
						"1"									;FlagX
						"1"									;FlagY
						"1"									;FlagZ
						"1"									;Rotation
						"0"									;Frame
						"1"									;Mask
						"[X]="								;PrefX
						"[Y]="								;PrefY
						"[Z]="								;PrefZ
						"2" 								;Preci
						"1.0" 								;FacX
						"1.0" 								;FacY
						"1.0" 								;FacZ
						"5" 								;AciColorText
						"1" 								;AciColorLeader
						"3.5"								;HeightText
						"0.8" 								;WidthText
						"1" 								;ScaleText
						"1" 								;TypeArrow
						"4" 								;SizeArrow
					)
		)
		(progn
			(setq SplitLeaderSetup (splitxt LeaderSetup "|"))
			(foreach itm SplitLeaderSetup
				(setq Rtn (append Rtn (list itm)))
			)
		)
	)
	Rtn
)
;
;
;
(defun PutCoordinate (Pt / 	CfgLeader 
							Ucs FlagX FlagY	FlagZ RotationText FormatText MaskText PrefX PrefY PrefZ
							Preci FacX FacY FacZ AciColorText AciColorLeader HeightText
							WidthText ScaleText TypeArrow SizeArrow 
							Ptext TextLeader)

	(setq CfgLeader (ReadSetupLeader))

	(setq Ucs				(nth 0  CfgLeader))
	(setq FlagX				(nth 1  CfgLeader))
	(setq FlagY				(nth 2  CfgLeader))
	(setq FlagZ				(nth 3  CfgLeader))
	(setq RotationText		(nth 4  CfgLeader))
	(setq FrameText			(nth 5  CfgLeader))
	(setq MaskText			(nth 6  CfgLeader))
	(setq PrefX				(nth 7  CfgLeader))
	(setq PrefY				(nth 8  CfgLeader))
	(setq PrefZ				(nth 9  CfgLeader))
	(setq Preci	   			(atoi (nth 10 CfgLeader)))
	(setq FacX  			(atof (nth 11 CfgLeader)))
	(setq FacY  			(atof (nth 12 CfgLeader)))
	(setq FacZ  			(atof (nth 13 CfgLeader)))
	(setq AciColorText 		(atoi (nth 14 CfgLeader)))
	(setq AciColorLeader	(atoi (nth 15 CfgLeader)))
	(setq HeightText 		(atof (nth 16 CfgLeader)))
	(setq WidthText 		(atof (nth 17 CfgLeader)))
	(setq ScaleText			(atof (nth 18 CfgLeader)))
	(setq TypeArrow 		(- (atoi (nth 19 CfgLeader)) 1))
	(setq SizeArrow			(atof (nth 20 CfgLeader)))

	
	(if Pt
		(progn
			(cond
				((= Ucs "1")
					(setq Ptext (trans Pt 1 0))
				)	
				((= Ucs "0")
					(setq Ptext Pt)
				)
			)
			(if (= FlagX "1")
				(setq TextLeader (append TextLeader (list (strcat PrefX (LM:Rtos (* (car Ptext) FacX) 2 Preci)))))
			)
			(if (= FlagY "1")
				(setq TextLeader (append TextLeader (list (strcat PrefY	(LM:Rtos (* (cadr Ptext) FacY) 2 Preci)))))
			)
			(if (= FlagZ "1")
				(setq TextLeader (append TextLeader (list (strcat PrefZ (LM:Rtos (* (caddr Ptext) FacY) 2 Preci)))))
			)
			(DinamicTextLeader TextLeader Pt (list AciColorText AciColorLeader 
													HeightText   WidthText
													ScaleText    TypeArrow    
													SizeArrow    RotationText 
													FrameText	 MaskText))
		)
	)
)
;
;
;
(defun DinamicTextLeader (LstText Anchor LstCfgLeader / *error*
														 MakeTextDefault FormatText Reset MakeLader DirectionLeader DeleteObject
													     AciColorLeader
														 Loop gr code Pt Text EnameText Tstring BoxMtext Wstring LeaderObj CoColor
														 FlagX FlagY FlagZ PrefX PrefY PrefZ Preci FacX FacY FacZ)
	;
	(defun *error* (msg)
		(setvar "CECOLOR" CoColor)
		(DeleteObject LeaderObj)
		(RestoreUcs	UcsActEasyCut$)
		(princ)
	)
	;
	(defun MakeTextDefault (Text PtText LstCfgLeader / MakeDxfList
													   AciColorText AciColorLeader HeightText WidthText ScaleText
													   TypeArrow SizeArrow RotationText FrameText MaskText 
										 			   Rtn)
	
		;
		(defun MakeDxfList (Text Pt Htext Giustificato Rotation)
		
			(if (and Text Pt Htext Giustificato Rotation)
				(list	(cons 0 "MTEXT")                              
						(cons 100 "AcDbEntity")
						(cons 100 "AcDbMText")
						;(cons 8   $LayerDinamicInfoEasyCut)
						(cons 1  Text)
						(cons 10 Pt)
						(cons 40 HText)
						(cons 50 0.0)
						(cons 62 71)
						(cons 71 Giustificato)
						(cons 90 3)
						;(cons 90 19)
						(cons 63 9)
						(cons 421 13158600)
						(cons 441 9434636)
						(cons 210 (list 0.0 0.0 1.0))
						(cons 11 (list 1.0 0.0 0.0))
						;(list -3 (list $InfoMtextDefault '(1002 . "{") '(1002 . "}")))
				)
			)
		)
		;
		(if (and Text PtText LstCfgLeader)
			(progn
				(setq 	AciColorText 	(nth 0  LstCfgLeader)
						AciColorLeader 	(nth 1  LstCfgLeader)
						HeightText 		(nth 2  LstCfgLeader)
						WidthText 		(nth 3  LstCfgLeader)
						ScaleText		(nth 4  LstCfgLeader)
						TypeArrow		(nth 5  LstCfgLeader)
						SizeArrow		(nth 6  LstCfgLeader)
						RotationText 	(nth 7  LstCfgLeader)
						FrameText 		(nth 8  LstCfgLeader)
						MaskText 		(nth 9  LstCfgLeader)
				)
				(setq Rtn (entmakex (MakeDxfList Text PtText (* HeightText ScaleText) 7 RotationText)))
			)
		)
		Rtn
	)
	;
	(defun FormatText (LstText LstCfgLeader / Num AciColorText AciColorLeader HeightText WidthText ScaleText
											  TypeArrow SizeArrow RotationText FrameText MaskText Rtn)
	
		(if LstText
			(progn
				(setq 	AciColorText 	(nth 0 LstCfgLeader)
						AciColorLeader 	(nth 1 LstCfgLeader)
						HeightText 		(nth 2 LstCfgLeader)
						WidthText 		(nth 3 LstCfgLeader)
						ScaleText		(nth 4 LstCfgLeader)
						TypeArrow		(nth 5 LstCfgLeader)
						SizeArrow		(nth 6 LstCfgLeader)
						RotationText 	(nth 7 LstCfgLeader)
						FrameText 		(nth 8 LstCfgLeader)
						MaskText 		(nth 9 LstCfgLeader)
				)
				(setq Num 0)
				(setq Rtn (strcat "{\\Fromans|c0;\\W" (rtos WidthText 2 1) ";"))
				(foreach itm LstText
					(setq Rtn (strcat Rtn "\\C" (rtos AciColorText 2 0) ";" itm))
					(if (/= (1+ Num) (length LstText)) 
						(setq Rtn (strcat Rtn "\n"))
						(setq Rtn (strcat Rtn "}"))
					)
					(setq Num (1+ Num))
				)
			)
		)
		Rtn
	)
	;
	(defun MakeLader (Text LstCfgLeader LstPointLeader / AciColorText AciColorLeader HeightText	WidthText ScaleText 
														 TypeArrow SizeArrow RotationText FrameText MaskText 
														 LeaderObj ModelSpace PtArray Num itm)

		(if (and Text LstCfgLeader LstPointLeader)
			(progn
				(setq 	AciColorText 	(nth 0 LstCfgLeader)
						AciColorLeader 	(nth 1 LstCfgLeader)
						HeightText 		(nth 2 LstCfgLeader)
						WidthText 		(nth 3 LstCfgLeader)
						ScaleText		(nth 4 LstCfgLeader)
						TypeArrow		(nth 5 LstCfgLeader)
						SizeArrow		(nth 6 LstCfgLeader)
						RotationText 	(nth 7 LstCfgLeader)
						FrameText 		(nth 8  LstCfgLeader)
						MaskText 		(nth 9 LstCfgLeader)
				)
				(setq ModelSpace (vla-get-ModelSpace (vla-get-activedocument (vlax-get-acad-object))))

				(setq PtArray (vlax-make-safearray vlax-vbDouble (cons 1 (* 3 (length LstPointLeader)))))
				(setq Num 0)
				(foreach itm LstPointLeader
					(setq itm (trans itm 1 0))
					(vlax-safearray-put-element PtArray (+ (* Num 3) 1) (car   itm))
					(vlax-safearray-put-element PtArray (+ (* Num 3) 2) (cadr  itm))
					(vlax-safearray-put-element PtArray (+ (* Num 3) 3) (caddr itm))
					(setq Num (1+ Num))
				)
				(setq LeaderObj (vla-AddMLeader ModelSpace PtArray 0))
				(vlax-put-property LeaderObj 'ScaleFactor 				ScaleText)
				(vlax-put-property LeaderObj 'TextString  					 Text)
				(vlax-put-property LeaderObj 'TextLeftAttachmentType  			7)
				(vlax-put-property LeaderObj 'TextRightAttachmentType 			7)
				(vlax-put-property LeaderObj 'DoglegLength 						1)
				(vlax-put-property LeaderObj 'TextHeight  			   HeightText)
				(vlax-put-property LeaderObj 'LandingGap   						0)
				(vlax-put-property LeaderObj 'TextJustify  						1)
				(vlax-put-property LeaderObj 'ArrowheadType				TypeArrow)
				(vlax-put-property LeaderObj 'ArrowheadSize				SizeArrow)
				(vlax-put-property LeaderObj 'LandingGap						1)
				(if (= RotationText "0")
					(vlax-put-property LeaderObj 'TextRotation	(/ (* 90.0 pi) 180.0))
				)
				(if (= FrameText "1")
					(vlax-put-property LeaderObj 'TextFrameDisplay			   -1)
				)
				(if (= MaskText "1")
					(vlax-put-property LeaderObj 'TextBackgroundFill		   -1)
				)
			)
		)
		LeaderObj
	)
	;
	(defun DirectionLeader (Anchor PtInstant LgTxt LstCfgLeader / AciColorText AciColorLeader HeightText WidthText ScaleText 
																  TypeArrow SizeArrow RotationText 
																  FrameText MaskText Rtn)

		(setq 	AciColorText 	(nth 0 LstCfgLeader)
				AciColorLeader 	(nth 1 LstCfgLeader)
				HeightText 		(nth 2 LstCfgLeader)
				WidthText 		(nth 3 LstCfgLeader)
				ScaleText		(nth 4 LstCfgLeader)
				TypeArrow		(nth 5 LstCfgLeader)
				SizeArrow		(nth 6 LstCfgLeader)
				RotationText 	(nth 7 LstCfgLeader)
				FrameText 		(nth 8 LstCfgLeader)
				MaskText 		(nth 9 LstCfgLeader)
		)
		(if (and Anchor PtInstant LgTxt RotationText)
			(cond
				((= RotationText "1")
					(if (>= (car PtInstant) (car Anchor))
						(setq Rtn (list (+ (car PtInstant)       (* 1 ScaleText)) (cadr PtInstant)))
						(setq Rtn (list (- (car PtInstant) LgTxt (* 4 ScaleText)) (cadr PtInstant)))
					)
				)
				((= RotationText "0")
					(if (>= (cadr PtInstant) (cadr Anchor))
						(setq Rtn (list (car PtInstant)  (+ (cadr PtInstant)       (* 1 ScaleText))))
						(setq Rtn (list (car PtInstant)  (- (cadr PtInstant) LgTxt (* 4 ScaleText))))
					)
				)
			)
		)
		Rtn
	)
	;
	(defun DeleteObject (Obj)
		(if Obj	
			(if (vlax-vla-object->ename LeaderObj)
				(if (entget (vlax-vla-object->ename LeaderObj)) (vla-delete LeaderObj))
			)
		)
	)
	;
	; Main
	;
	(if (and LstText Anchor LstCfgLeader)
		(progn
			(setq AciColorLeader  (nth 1 LstCfgLeader)
				  Loop T
			)
			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			(setq Text 		(FormatText LstText LstCfgLeader))
			(setq EnameText (MakeTextDefault Text '(0 0) LstCfgLeader))
			(setq Tstring   (vlax-get-property (vlax-ename->vla-object EnameText) 'TextString ))
			(setq BoxMtext  (BoundingBoxLstEname (list EnameText)))
			(setq Wstring   (abs (- (car (car BoxMtext)) (car (cadr BoxMtext))))) 
			(entdel EnameText)
			; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

			(setq CoColor (getvar "CECOLOR"))
			(setvar "CECOLOR" (rtos AciColorLeader 2 0))
			(while Loop
				(setq gr (grread t 15 0) code (car gr) Pt (cadr gr))

				(if (listp Pt)
					(progn
						(DeleteObject LeaderObj)
						(setq Pt (LM:OrthoPoint Anchor Pt))
						(setq LeaderObj (MakeLader Tstring LstCfgLeader (list Anchor Pt (DirectionLeader Anchor Pt Wstring LstCfgLeader))))
					)
				)
				
				(cond
					((and (= code 3) (listp Pt))            ; Left click mouse
						(setq Loop nil)
					)
					((or (= Pt 79) (= Pt 111)) 				; opzione (tasto o/O)
					
						(DeleteObject LeaderObj)
						(SetupLeader)
						(PutCoordinate Anchor)
						(setq Loop nil)
					)
				)
			)
			(setvar "CECOLOR" CoColor)
		)
	)
)
;
;
;
(defun GuiStyleDimension (/ UpdateDimStyleName GetDimStyle
							xx dcl Stream x LstDimStyle)

	;DimAnnotative
	;DimStyleName
	;DimScale
	;DimHtext
	;DimStyleText
	;
	(defun UpdateDimStyleName ()
		 
		(if (= (get_tile "DimAnnotative") "0")
			(progn
				(mode_tile "DimScale" 0)
				(if (/= (get_tile "DimScale") "") (set_tile "DimStyleName" (strcat "Scale_" (get_tile "DimScale"))))
				;(mode_tile "DimStyleName" 0)
			)
			(progn	
				(mode_tile "DimScale" 1)
				(if (/= (get_tile "DimScale") "") (set_tile "DimStyleName" (strcat "Annotative_" (get_tile "DimScale"))))
				;(mode_tile "DimStyleName" 1)
			)
		)
	)
	;
	(defun GetDimStyle (/ DimScale DimStyleText DimHText DimStyleName DimAnnotative Rtn)

		(setq DimScale      (get_tile "DimScale"))
		(setq DimStyleText  (get_tile "DimStyleText"))
		(setq DimHText  	(get_tile "DimHText"))
		(setq DimStyleName  (get_tile "DimStyleName"))
		(setq DimAnnotative (get_tile "DimAnnotative"))
			 
		
		(if (not (CkeckDataDcl (list DimScale DimStyleText DimHText DimStyleName)))
			(alert "dati incompleti")
			(progn
				(setq *DimensionDialog* (done_dialog))
                (unload_dialog xx)
				(setq Rtn (list DimStyleName (atof DimScale) (atof DimHtext) DimStyleText DimAnnotative))
			)
		)
		Rtn
	)
	;
	; Main
	;
	(if (findfile (strcat GuiPathEasyCut$ "geocut.dcl"))
		(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
		(progn
			(setq dcl (vl-filename-mktemp nil nil ".dcl"))
			(setq Stream (open dcl "w"))
			(foreach x
				'(	"DimensionDialog:dialog {"
					"label=\"Dimensioni\";"
					"	:boxed_radio_column {"
					"		:row {"
					"			: toggle {key = \"DimAnnotative\"; label = \"       Annotativa [on/off]\"; 	  value = 0;}"
					"		}"
					"	}"
					"	:boxed_radio_column { label=\"Set Dimension\";" 
					"		:row {"
					"				:text     { width=15; fixed_width = true; value=\"Scala testo\";}"
					"				:edit_box { key=\"DimScale\";     edit_width=15; fixed_width = true;}"
					"		}"
					"		:row {" 
					"				:text     { width=15; fixed_width = true; value=\"Style testo\";}"
					"				:edit_box { key=\"DimStyleText\"; edit_width=15; fixed_width = true;}"
					"		}"
					"		:row {" 
					"				:text     { width=15; fixed_width = true; value=\"Altezza testo\";}"
					"				:edit_box { key=\"DimHText\";     edit_width=15; fixed_width = true;}"
					"		}"
					"		:row {"
					"				:text     { width=15; fixed_width = true; value=\"Style dimensione\";}"
					"				:edit_box { key=\"DimStyleName\";     edit_width=15; fixed_width = true;}"
					"		}"
					"	}"
					"	ok_cancel;"
					"}"
				)
				(write-line x Stream)
			)
			(close Stream)
			(setq xx (load_dialog dcl))
		)
	)
	
	(new_dialog "DimensionDialog" xx "" (cond ( *DimensionDialog* ) ( '(-1 -1) )))
 
	;(mode_tile "DimStyleName" 1)

	(set_tile "DimAnnotative" "0")
	(set_tile "DimScale" 	 "1")
 	(set_tile "DimStyleText" (strcat $StyleEasyCut "Dim"))
 	(set_tile "DimHText" 	 "3")
 	(UpdateDimStyleName)

	(action_tile "DimScale" 		"(UpdateDimStyleName)")
	(action_tile "DimStyleText" 	"(UpdateDimStyleName)")
	(action_tile "DimHText" 		"(UpdateDimStyleName)")
 	(action_tile "DimAnnotative"	"(UpdateDimStyleName)")

    (action_tile "accept"    "(setq LstDimStyle (GetDimStyle))")
    (action_tile "cancel"     (strcat "(setq *DimensionDialog* 	(done_dialog))"
                                      "(unload_dialog xx)"
                              ))
    (start_dialog)
	(if LstDimStyle
		(MakeDimStyleToEntmake (nth 0 LstDimStyle) (nth 1 LstDimStyle) (nth 2 LstDimStyle ) (nth 3 LstDimStyle) (nth 4 LstDimStyle))
	)
)
;
;
;
(defun c:CreateDesktopShortcut ( / wshShell desktopFldr myDocsFldr shrtObj)
	(if (= wshLibImport nil)
		(progn
			(vlax-import-type-library
					:tlb-filename "c:\\windows\\system32\\wshom.ocx"
					:methods-prefix "wshm-"
					:properties-prefix "wshp-"
					:constants-prefix "wshk-"
			)
			(setq wshLibImport T)
		)
	)
	(setq wshShell (vlax-create-object "WScript.Shell")) 
	(setq desktopFldr (wshm-Item (wshp-get-SpecialFolders wshShell) "Desktop"))
	(setq myDocsFldr  (wshm-Item (wshp-get-SpecialFolders wshShell) "MyDocuments"))
	(setq shrtObj	  (wshm-CreateShortcut wshShell (strcat desktopFldr "\\My AutoCAD.lnk")))
	(wshp-put-TargetPath shrtObj (strcat "\"" (vla-get-FullName (vlax-get-acad-object)) "\""))
	(wshp-put-Arguments shrtObj "/w \"3D Modeling\"")
	(wshp-put-Description shrtObj "Custom AutoCAD Desktop Shortcut")
	(wshp-put-WindowStyle shrtObj wshk-WshNormalFocus)
	(wshp-put-HotKey shrtObj "Ctrl+Alt+A")
	(wshp-put-WorkingDirectory shrtObj myDocsFldr)
	(wshp-put-IconLocation shrtObj (strcat (vla-get-FullName (vlax-get-acad-object)) ", 0"))
	(wshm-save shrtObj)
	(vlax-release-object wshShell)
	(princ)
)
