(defun ArrayShapeCreate (EnameShape Direction NCopyX NcopyY / Offset_Shape acadObj Pmin Pmax StepX StepY Ename itm
												              xc yc Loop conta IdGroup LstEname Sselect GrpName)
;
;               2       1
;                \     /
;			      \   /
;					+
;                 /   \
;				 /     \
;               3       4
;
;
	
	(if EnameShape
		(progn
			;(setq Offset_Shape (OffsetShape EnameShape (/ $MargineAccosto 2.0)))
			(setq Offset_Shape (GeneralOffset EnameShape (/ $MargineAccosto 2.0)))
			(if Offset_Shape
				(progn
					(setq acadObj (vlax-get-acad-object))
					(vla-getboundingbox (vlax-ename->vla-object Offset_Shape) 'mnl 'mxl)
					(entdel Offset_Shape)
					(setq Pmin (vlax-safearray->list mnl))
					(setq Pmax (vlax-safearray->list mxl))
					(setq StepX (abs (- (nth 0 Pmax) (nth 0 Pmin))))
					(setq StepY (abs (- (nth 1 Pmax) (nth 1 Pmin))))
					(cond 
						((= Direction 1)
							(setq StepX (* StepX  1.0))
							(setq StepY (* StepY  1.0))
						)
						((= Direction 2)
							(setq StepX (* StepX -1.0))
							(setq StepY (* StepY  1.0))
						)
						((= Direction 3)
							(setq StepX (* StepX -1.0))
							(setq StepY (* StepY -1.0))
						)
						((= Direction 4)
							(setq StepX (* StepX  1.0))
							(setq StepY (* StepY -1.0))
						)
					)
					
					(setq xc 0)
					(setq yc 0)
					(setq Loop (* NCopyX NcopyY))
					(setq conta 0)
					
					(setq Sselect (SelectShape EnameShape))
									
					(repeat Loop
						
						(if (> xc (- NCopyX 1))
							(progn
								(setq xc 0)
								(setq yc (1+ yc))
							)
						)
							
						(setq DistX (* xc StepX))
						(setq DistY (* yc StepY))
						
						(if (> conta 0)
							(progn
								(setq Clone$ nil)
								(command "_Copy" Sselect "" (list 0.0 0.0) (list DistX DistY))
								
								; check overlapping
								(setq Ename (GetEnameShapeByDummyEnameSelect (nth 0 EasyCutLstEnameCopy$)))
								(if (CheckOverlappingShape Ename)
									(foreach itm EasyCutLstEnameCopy$
										(entdel itm)
									)
									(progn
										(setq GrpName  (Gnames (nth 0 EasyCutLstEnameCopy$)))
										(CloneShapeByGroupName (nth 0 GrpName))
									)
								)
								
							)
						)
						(setq xc (1+ xc))
						(setq conta (1+ conta))
					)
				)
			)
		)
	)
)
;
;
;
(defun ArrayShape()

	(setq EnameSelect (car (entsel)))
	(if EnameSelect
		(progn
			(setq EnameShape (GetEnameShapeByDummyEnameSelect EnameSelect))
			(setq DataArray  (GuiArrayShape))	
			(if (and EnameShape DataArray)
				(ArrayShapeCreate EnameShape (atoi (nth 0 DataArray)) (atoi (nth 1 DataArray)) (atoi (nth 2 DataArray)))
			)
		)
	)
)
;
;
;
(defun GuiArrayShape ( / LoadGuiArrayShape GetGuiArraySetup xx TypeArray)

	(setq 	DefaultNc "3"
			DefaultNr "4"
	)
	;
	;
	;
	(defun RemoveSpaces ( str )
		(if str
			(if (wcmatch str "* *")
				(RemoveSpaces (vl-string-subst "" " " str)) str
			)
		)
	)
	;
	;
	;
	(defun LoadGuiArrayShape ( / conta start_sld_thum NumberColumn NumberRow)

		; load image
		(setq conta 1)
		(repeat 4
			(setq start_sld_thum (strcat GuiPathEasyCut$ "Schema" (rtos conta 2 0) ".sld"))
			(if (= conta 1) (setq x_x 3))
			(if (= conta 2) (setq x_x 3))
			(if (= conta 3) (setq x_x 3))
			(if (= conta 4) (setq x_x 3))
			(setq y_y 0)
			(setq 	x (dimx_tile (strcat "schema" (rtos conta 2 0)))
					y (dimy_tile (strcat "schema" (rtos conta 2 0)))
			)
			(start_image (strcat "schema" (rtos conta 2 0)))
			(fill_image x_x y_y x y -2)
			(slide_image x_x y_y x y start_sld_thum)
			(end_image)
			(setq conta (1+ conta))
		)
		
		(setq NumberColumn (vl-registry-read EasyCutRegistryPath$ "ArrayColumn"))
		(setq NumberRow    (vl-registry-read EasyCutRegistryPath$ "ArrayRow"))

		(if NumberColumn
			(if (/= NumberColumn "")
				(set_tile "NumberColumn" NumberColumn)
				(set_tile "NumberColumn" DefaultNc)
			)
			(set_tile "NumberColumn" DefaultNc)
		)
		(if NumberRow
			(if (/= NumberRow "")
				(set_tile "NumberRow" NumberRow)
				(set_tile "NumberRow" DefaultNr)
			)
			(set_tile "NumberRow" DefaultNr)
		)
	)
	;
	;
	;
	(defun GetGuiArraySetup (Schema / Nc Nr)
	
		(setq Nc (RemoveSpaces (get_tile "NumberColumn")))
		(setq Nr (RemoveSpaces (get_tile "NumberRow")))
		
		(if (and (/= Nc "") (/= Nr "") 
				 (not (zerop (atoi Nc))) (not (zerop (atoi Nr)))				 
			)
			(progn
				(vl-registry-write EasyCutRegistryPath$ "ArrayColumn" Nc)
				(vl-registry-write EasyCutRegistryPath$ "ArrayRow"    Nr)
				(list Schema Nc Nr)
			)
		)
	)
	;
	;
	;
	(setq xx (load_dialog (strcat GuiPathEasyCut$ "Tools.dcl")))
	(new_dialog "ArrayCopy" xx "" (cond ( *ArrayCopy* ) ( '(-1 -1) )))				
		(LoadGuiArrayShape)
		
		
		(action_tile "schema1"	 (strcat "(setq TypeArray (GetGuiArraySetup \"1\") *ArrayCopy* (done_dialog)) (unload_dialog xx)"))
		(action_tile "schema2"	 (strcat "(setq TypeArray (GetGuiArraySetup \"2\") *ArrayCopy* (done_dialog)) (unload_dialog xx)"))
		(action_tile "schema3"	 (strcat "(setq TypeArray (GetGuiArraySetup \"3\") *ArrayCopy* (done_dialog)) (unload_dialog xx)"))
		(action_tile "schema4"	 (strcat "(setq TypeArray (GetGuiArraySetup \"4\") *ArrayCopy* (done_dialog)) (unload_dialog xx)"))
		(action_tile "cancel"    (strcat "(setq *ArrayCopy* (done_dialog)) (unload_dialog xx)"))
	(start_dialog)
	TypeArray				
	
)
;
;
;
