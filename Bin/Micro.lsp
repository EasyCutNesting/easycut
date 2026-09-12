;
; Specifica un punto nel contorno oppure [Serie micro]
; Specifica un punto nel contorno oppure [Micro singola]
;
; Specifica un punto nel contorno oppure [cancella Tutte micro]
; Seleziona il contorno oppure [cancella Singola micro]
;
(defun ChangeShapeLwPolyline (EnameShape CoordShape / ListEname Pos itm itm1)

	;( ((10 x y) (40 . 0.0) (41 . 0.0) (42 . 1))
	;  ((10 x y) (40 . 0.0) (41 . 0.0) (42 . 1))
	;)
	
	(if (and EnameShape CoordShape)
		(progn
			(setq ListEname (entget EnameShape (list "*")))
			(setq Pos (- (length ListEname) (length (member (assoc 10 ListEname) ListEname))))
			(setq ListEname (vl-remove-if
									'(lambda (pair)
										(member (car pair)
											'(10 40 41 42)
										)
									) ListEname))
			(setq ListEname (subst (cons 90 (length CoordShape)) (assoc 90 ListEname) ListEname))
			
			(foreach itm CoordShape
				(foreach itm1 itm
					(setq ListEname (LM:insertnth itm1 Pos ListEname))
					(setq Pos (1+ Pos))
				)
			)
	
			(entmod ListEname)
			(entupd EnameShape)
		)
	)
)
;
(defun RebuildLwCircle (EnameShape / DataCicrcle Center Radius)
	(if EnameShape
		(if (setq DataCicrcle (IsLwPolylineCircle EnameShape))
			(progn
				(setq Center (car DataCicrcle))
				(setq Radius (cadr DataCicrcle))
				(ChangeShapeLwPolyline EnameShape	(list   
														(list (cons 10 (list (- (car Center) Radius) (cadr Center))) '(40 . 0.0) '(41 . 0.0) '(42 . 1))
														(list (cons 10 (list (+ (car Center) Radius) (cadr Center))) '(40 . 0.0) '(41 . 0.0) '(42 . 1))
													)					
				)
				T
			)
		)
	)
)
;
(defun SwitchShape2Micro (EnameShape / Rtn)
				
	(if EnameShape
		(progn
			(cond
				((= (cdr (assoc 0 (entget EnameShape))) "CIRCLE")
					(setq Rtn (Circle2LwPolyline EnameShape nil))
				)
				((= (cdr (assoc 0 (entget EnameShape))) "ELLIPSE")
					(setq Rtn (Ellipse2LwPolyline EnameShape nil))
				)
			)
			(if Rtn
				(progn
					(CloneEname EnameShape Rtn (GetIdShape EnameShape))
					(if (setq GrName (Gnames EnameShape))
						(vlax-invoke (vla-add (vla-get-groups (vla-get-activedocument (vlax-get-acad-object))) (car GrName)) 
									'appenditems 
									(list (vlax-ename->vla-object Rtn))
						)
					)
					(entdel EnameShape)
				)
				(setq Rtn EnameShape)
			)
		)
	)
	Rtn
)
;
(defun GuiMakeMicro (/  *error*
						SaveOsmode LstMsg Loop PosMsg Res)

	(defun *error* (msg)
		(setvar 'osmode SaveOsmode)
	)
	;
	; Main
	;
	(setq SaveOsmode (getvar 'osmode))
	(setq LstMsg (list  "\nSpecifica un punto nel contorno oppure [Serie micro]   <Cancel> :"
						"\nSpecifica un punto nel contorno oppure [Micro singola] <Cancel> :"
						"\n*Invalid option keyword*"))
						
	(setq Loop T)
	(setq PosMsg 0)

	(while Loop
	
		(setvar 'osmode 561)	; Endpoint / Midpoint / Quadrant / Nearest
		(initget 128)
		(setq Res (getpoint (nth PosMsG LstMsg)))
 		(cond
			((= (type Res) 'List)
				(cond 
					((= PosMsg 0) (MakeMicro01 	 	(trans Res 1 0)) (setvar 'osmode SaveOsmode))
					((= PosMsg 1) (MakeArrayMicro01 (trans Res 1 0)) (setvar 'osmode SaveOsmode))
				)
			)
			((= (type Res) 'Str)
				(cond 
					((wcmatch (strcase Res) (strcase (strcat (substr "Micro" 1 (strlen Res)) "*"))) (setq PosMsg 0))
					((wcmatch (strcase Res) (strcase (strcat (substr "Serie" 1 (strlen Res)) "*"))) (setq PosMsg 1))
					(t 
						(princ (nth 2 LstMsg))
					)
				)
			)
			(t
				(setq Loop nil)
			)
		)
	)
)
;
(defun GuiRemoveMicro (/ *error*
						 SaveOsmode	LstMsg Loop PosMsg Res)

	(defun *error* (msg)
		(setvar 'osmode SaveOsmode)
	)
	;
	; Main
	;
	(setq SaveOsmode (getvar 'osmode))
	(setq LstMsg (list "\nSpecifica un punto nel contorno oppure [cancella Tutte micro] <Cancel>:"
					   "\nSeleziona il contorno oppure [cancella Singola micro] <Cancel>:        "
 					   "\n*Invalid option keyword*"))
						
	(setq Loop T)
	(setq PosMsg 0)

	(while Loop
	
		(setvar 'osmode 561)	; Endpoint / Midpoint / Quadrant / Nearest
		
		(if (= PosMsg 0)
			(progn
				(initget 128)
				(setq Res (getpoint (nth PosMsG LstMsg)))
			)
			(progn
				(initget 128 "Singola")
				(setq Res (entsel (nth PosMsG LstMsg)))
			)
		)
 		(cond
			((= (type Res) 'List)
				(cond 
					((= PosMsg 0) (RemoveMicro01 	(trans Res 1 0)) (setvar 'osmode SaveOsmode))
					((= PosMsg 1) (RemoveAllMicro01 (car Res)) 		 (setvar 'osmode SaveOsmode))
				)
			)
			
			((= (type Res) 'Str)
				(cond 
					((wcmatch (strcase Res) (strcase (strcat (substr "Singola" 1 (strlen Res)) "*"))) (setq PosMsg 0))
					((wcmatch (strcase Res) (strcase (strcat (substr "Tutte" 1   (strlen Res)) "*"))) (setq PosMsg 1))
					(t 
						(princ (nth 2 LstMsg))
					)
				)
			)
			(t
				(setq Loop nil)
			)
		)
	)
)
;
(defun MakeMicro01 (PtMicro / MyEntsel
							   SaveOsmode PtMicro EnameShape)

	(defun MyEntsel (PtPoint / Aperture LstEname)
	
		(setq Aperture 0.5)
		(setq LstEname (LM:ss->ent (ssget "_C" (list (- (car  PtPoint) (/ Aperture 2.0))
										 			 (- (cadr PtPoint) (/ Aperture 2.0)))
											   (list (+ (car  PtPoint) (/ Aperture 2.0))
													 (+ (cadr PtPoint) (/ Aperture 2.0)))
											   (list (cons 67 0) (list -3 (list $RgpShape)))
								    )))
		(if (= (length LstEname) 1)
			(car LstEname)
			nil
		)
	)
	;
	; Main
	;
	(if (and PtMicro (setq EnameShape (MyEntsel PtMicro)))
		(progn
			;(if (= (cdr (assoc 0 (entget EnameShape))) "LWPOLYLINE") (SimpleLwPolyLine EnameShape))
			(setq EnameShape (SwitchShape2Micro EnameShape))
			(MakeMicro EnameShape PtMicro)
		)
	)
)
;
(defun MakeArrayMicro01 (PtMicro / MyEntsel LoadDataMicro GetDataMicro GetTextBox SwapRadioButton DclMicro
									DclKey SaveOsmode EnameShape PtMicro xx Rtn)


	(defun MyEntsel (PtPoint / Aperture LstEname)
	
		(setq Aperture 0.5)
		(setq LstEname (LM:ss->ent (ssget "_C" (list (- (car  PtPoint) (/ Aperture 2.0))
										 			 (- (cadr PtPoint) (/ Aperture 2.0)))
											   (list (+ (car  PtPoint) (/ Aperture 2.0))
													 (+ (cadr PtPoint) (/ Aperture 2.0)))
											   (list (cons 67 0) (list -3 (list $RgpShape)))
								    )))
		(if (= (length LstEname) 1)
			(car LstEname)
			nil
		)
	)
	;
	(defun LoadDataMicro (EnameShape)

		(if (not NumberMicro)		(setq NumberMicro 2))
		(if (not DistanceMicro)		(setq DistanceMicro 0.0))
		(if (not FixNumberMicro)
			(progn
				(setq FixNumberMicro "1")
				(setq FixDistanceMicro "0")
			)
		)
		
		(set_tile "NumberMicro"    		(LM:Rtos NumberMicro 2 0))
		(set_tile "DistanceMicro"  		(LM:Rtos DistanceMicro 2 2))
		(set_tile "FixNumberMicro" 		FixNumberMicro)
		(set_tile "FixDistanceMicro" 	FixDistanceMicro)
	)
	;
	(defun GetDataMicro (EnameShape / Nm Dm LgPolyLine Rtn)
	
		(setq Nm  				(GetTextBox "NumberMicro"))
		(setq Dm  				(GetTextBox "DistanceMicro"))
		(setq FixNumberMicro 	(get_tile "FixNumberMicro" 	))
		(setq FixDistanceMicro 	(get_tile "FixDistanceMicro"))
		(setq LgPolyLine   		(vla-get-length (vlax-ename->vla-object EnameShape)))
		
		(cond 
			((= FixNumberMicro "1")
				(cond
					((= Nm "")  	 (LM:popup "Errore" "[ ArrayMicro ] Definire Numero Micro" 				(+ 0 16 4096)))
					((= Nm "0") 	 (LM:popup "Errore" "[ ArrayMicro ] Numero Micro > 0" 	   				(+ 0 16 4096)))
					((< (atoi Nm) 0) (LM:popup "Errore" "[ ArrayMicro ] Numero Micro > 0" 					(+ 0 16 4096)))
					((= (atoi Nm) 0) (LM:popup "Errore" "[ ArrayMicro ] Numero Micro richiesto un numero"	(+ 0 16 4096)))
					(t 
						(setq NumberMicro (atoi Nm))
						(setq Rtn (list NumberMicro nil))
					)
				)
			)
			((= FixDistanceMicro "1")
				(cond
					((= Dm "")  	 (LM:popup "Errore" "[ ArrayMicro ] Definire distanza Micro" 			(+ 0 16 4096)))
					((= Dm "0") 	 (LM:popup "Errore" "[ ArrayMicro ] Distanza Micro > 0" 	 			(+ 0 16 4096)))
					((< (atof Dm) 0) (LM:popup "Errore" "[ ArrayMicro ] Distanza Micro > 0" 	 			(+ 0 16 4096)))
					((= (atof Dm) 0) (LM:popup "Errore" "[ ArrayMicro ] Distanza Micro richiesto un numero"	(+ 0 16 4096)))
					(t 
						(if (> (atof Dm) LgPolyLine)
							(LM:popup "Errore" (strcat "[ ArrayMicro ] Distanza Micro maggiore perimetro contorno\n"
														Dm " > " (LM:Rtos LgPolyLine 2 2)) 
												(+ 0 16 4096))
							(progn
								(setq DistanceMicro (atof Dm))
								(setq Rtn (list nil DistanceMicro))
							)
						)
					)
				)
			)
		)
		Rtn
	)
	;
	(defun GetTextBox (KeyBox)
		(vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile KeyBox)))
	)
	;
	(defun SwapRadioButton ()
		(if	(= (get_tile "FixNumberMicro") "1")
			(progn
				(mode_tile "DistanceMicro" 1)
				(mode_tile "NumberMicro"   0)
			)
		)
		(if (= (get_tile "FixDistanceMicro") "1")
			(progn
				(mode_tile "DistanceMicro" 0)
				(mode_tile "NumberMicro"   1)
			)
		)
	)
	;
	(defun DclMicro (/ dcl des x)
		
		(setq dcl (vl-filename-mktemp nil nil ".dcl"))
		(setq des (open dcl "w"))
		(foreach x
			'(	"ArrayMicro:dialog  {"
				"   label=\"Micro Serie\";"
				"		:row {"
				"			:radio_button {key = \"FixNumberMicro\";label = \"&Numero Micro\";}"
				"			:edit_box {	key = \"NumberMicro\";"
				"						edit_width = 10;"
				"						allow_accept = true;"
				"					}"
				"		}"
				"		:row {"
				"			:radio_button {key = \"FixDistanceMicro\"; label = \"&Distanza Micro\";}"
				"			:edit_box { key = \"DistanceMicro\";"
				"						edit_width = 10;"
				"						allow_accept = true;"
				"			}"
				"		}"
				"		ok_cancel;" 
				"}"					
			)
			(write-line x des)
		)
		(setq des (close des))
		dcl
	)	
	;
	;Main 
	;
	(if (and PtMicro (setq EnameShape (MyEntsel PtMicro)))
		(progn
			(if (= (cdr (assoc 0 (entget EnameShape))) "LWPOLYLINE") (SimpleLwPolyLine EnameShape nil))
			(setq EnameShape (SwitchShape2Micro EnameShape))
			(setq DclKey (DclMicro))
			(setq xx (load_dialog DclKey))
			(new_dialog "ArrayMicro" xx "" (cond ( *ArrayMicro* ) ( '(-1 -1) )))
			(LoadDataMicro EnameShape)
			(SwapRadioButton)
			(action_tile "FixNumberMicro" 		"(set_tile \"FixDistanceMicro\" \"0\") (SwapRadioButton)")
			(action_tile "FixDistanceMicro" 	"(set_tile \"FixNumberMicro\" \"0\")   (SwapRadioButton)")
			(action_tile "accept"   			"(if (setq Rtn (GetDataMicro EnameShape)) (progn (done_dialog) (unload_dialog xx) (vl-file-delete DclKey)))")
			(action_tile "cancel"   			"(setq Rtn nil  *ArrayMicro* (done_dialog)) (unload_dialog xx) (vl-file-delete DclKey)")
			(start_dialog)
				
			(if Rtn
				(progn
					(RemoveAllMicro  EnameShape)
					(MakeArrayMicro  EnameShape PtMicro (car Rtn) (cadr Rtn))
				)
			)
		)
	)
)
;
(defun RemoveMicro01 (PtMicro / MyEntsel
								EnameShape)
	;
	(defun MyEntsel (PtPoint / Aperture LstEname)
	
		(setq Aperture 0.5)
		(setq LstEname (LM:ss->ent (ssget "_C" (list (- (car  PtPoint) (/ Aperture 2.0))
										 			 (- (cadr PtPoint) (/ Aperture 2.0)))
											   (list (+ (car  PtPoint) (/ Aperture 2.0))
													 (+ (cadr PtPoint) (/ Aperture 2.0)))
											   (list (cons 67 0) (list -3 (list $RgpShape)))
								    )))
		(if (= (length LstEname) 1)
			(car LstEname)
			nil
		)
	)
	;
	;Main
	;
	(if (and PtMicro (setq EnameShape (MyEntsel PtMicro)))
			(RemoveMicro EnameShape PtMicro)
	)
)
;
(defun RemoveAllMicro01 (EnameShape)
	
	(if (and EnameShape (CheckIfEasyCutShape EnameShape))
			(RemoveAllMicro EnameShape)
	)
)
;
(defun GuiLwPolySimple (/ Select)
	(while (setq Select (entsel "\nSeleziona la polylinea"))
		(if (= (cdr (assoc 0 (entget (car Select)))) "LWPOLYLINE")
			(SimpleLwPolyLine (car Select) T)
			(LM:popup "Errore" "Non e' una polilinea" (+ 0 16 4096))
		)
	)
)
;
(defun GuiMakeVertexPolyLine (/ *error* MyEntsel SaveOsmode LstMsg Loop PosMsg PtAdd)


	(defun *error* (msg)
		(setvar 'osmode SaveOsmode)
	)
	;
	(defun MyEntsel (PtPoint / Aperture LstEname)
	
		(setq Aperture 0.5)
		(setq LstEname (LM:ss->ent (ssget "_C" (list (- (car  PtPoint) (/ Aperture 2.0))
										 			 (- (cadr PtPoint) (/ Aperture 2.0)))
											   (list (+ (car  PtPoint) (/ Aperture 2.0))
													 (+ (cadr PtPoint) (/ Aperture 2.0)))
											   (list (cons 0 "LWPOLYLINE") (cons 67 0))
											   ;(list (cons 67 0) (list -3 (list $RgpShape)))
								    )))
		(if (= (length LstEname) 1)
			(car LstEname)
			nil
		)
	)
	;
	; Main
	;
	(setq SaveOsmode (getvar 'osmode))
	(setq LstMsg (list "\nAggiungi punto polylinea <Cancel>:"
 					   "\n*Invalid option keyword*"))
						
	(setq Loop T)
	(setq PosMsg 0)
	(setvar 'osmode 561)	; Endpoint / Midpoint / Quadrant / Nearest

	(while Loop
		(setq PtAdd (getpoint (nth PosMsG LstMsg)))
		(if (setq EnameShape (MyEntsel PtAdd))
			(if (not (PointIsVertexLwPolyline EnameShape PtAdd))
				(AddVertextLwPolyline EnameShape PtAdd)
			)
		)
	)
	(setvar 'osmode SaveOsmode)
)
;
(defun GraphicsMicro (EnameShape WdMicro / PrgMicro ObjShape itm)

	
	(if (and EnameShape WdMicro)
		(if (setq PrgMicro (FindMicro EnameShape))
			(progn
				(setq ObjShape 	(vlax-ename->vla-object EnameShape))
				(foreach itm PrgMicro
					(vla-setwidth ObjShape (atoi (rtos (vlax-curve-getParamAtDist ObjShape (cadr itm)))) WdMicro WdMicro)
				)
			)
		)
	)
)
;
(defun GraphicsMicroatDist (EnameShape PtMicro StartDist EndDist WdMicro WdMicroOnPoint / SearchDist
																						  LstDist itm)

	(defun SearchDist (LstDist StartDist EndDist / L1 L2 itm Accuracy)

		(setq Accuracy 0.01)
		(if (<= StartDist EndDist)
			(if (and (setq L1 (MemberWithAccuracy StartDist LstDist Accuracy))
					 (setq L2 (MemberWithAccuracy EndDist   LstDist Accuracy))
				)
				(progn
					(foreach itm L2
						(setq L1 (LM:RemoveOnceF itm L1 Accuracy))
					)
					(append L1 (list EndDist))
				)
			)
			(if (and (setq L1 (MemberWithAccuracy EndDist   LstDist Accuracy))
					 (setq L2 (MemberWithAccuracy StartDist LstDist Accuracy))
				)
				(progn
					(foreach itm L1
						(setq LstDist (LM:RemoveOnceF itm LstDist Accuracy))
					)
					(append L2 LstDist (list EndDist))
				)
			)
		)
	)
	;
	;
	(if (and EnameShape PtMicro StartDist EndDist WdMicro WdMicroOnPoint) 
		(progn
			(setq LstDist 	(mapcar '(lambda (x) (vlax-curve-getDistAtPoint (vlax-ename->vla-object EnameShape) x ))
								(mapcar '(lambda (x) (TransEcsToWcs x EnameShape))
									(mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) (entget EnameShape)))
								)
							)
			)
			(foreach itm (reverse (cdr (reverse (SearchDist LstDist StartDist EndDist))))
				(vla-setwidth (vlax-ename->vla-object EnameShape)
						(atoi (rtos (vlax-curve-getParamAtDist (vlax-ename->vla-object EnameShape) itm)))
						WdMicro WdMicro
				)
			)
			(if (PointIsVertexLwPolyline EnameShape PtMicro)
				(vla-setwidth (vlax-ename->vla-object EnameShape)
					(atoi (rtos (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) PtMicro)))
					WdMicroOnPoint WdMicro
				)
			)
		)
	)
)
;
(defun FindMicro (EnameShape / Pos Accuracy ObjShape LstCoord StartWidth EndWidth Rtn RtnVertex)

	(if EnameShape
		(progn
			(setq Accuracy 0.01)
			(setq ObjShape 	(vlax-ename->vla-object EnameShape))
			(setq LstCoord 	(mapcar '(lambda (x) (TransEcsToWcs x EnameShape))
								(mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) (entget EnameShape)))
							)
			)
			(setq Pos 0)
			(repeat (length LstCoord)
			
				(vla-GetWidth ObjShape Pos 'StartWidth 'EndWidth)

				(cond
					((equal StartWidth $WdMicro Accuracy)
						(setq Rtn (cons Pos Rtn))
						(if (nth (1+ Pos) LstCoord)
							(setq Rtn (cons (1+ Pos) Rtn))
							(setq Rtn (cons 0 Rtn))
						)
					)
					((equal StartWidth $WdMicroAtPoint Accuracy)
						(setq RtnVertex (cons Pos RtnVertex))
						(if (nth (1+ Pos) LstCoord)
							(setq Rtn (cons (1+ Pos) Rtn))
							(setq Rtn (cons 0 Rtn))
						)
					)
				)
				(setq Pos (1+ Pos))
			)
			(setq RtnVertex (LM:Unique RtnVertex))
			(setq Rtn (LM:Unique Rtn))
			(foreach itm RtnVertex
				(setq Rtn (LM:RemoveOnce itm Rtn))
			)
		)
	)
	(list RtnVertex Rtn)
)
;
(defun FindMicroAtPoint (EnameShape PtMicro / Accuracy itm Pos Pos+ Pos- Loop RtnVertex Rtn)
		
		
	(setq Accuracy 0.01)
	(if (and EnameShape PtMicro)
		(progn
			;(setq Pos (FindNthValToList (mapcar '(lambda (x) (TransEcsToWcs x EnameShape))
			;								(mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) (entget EnameShape)))
			;							) 
			;							(Pt->3dPt PtMicro) Accuracy))
			
			(setq Pos (atoi (rtos (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (trans PtMicro 1 0)))))
			(setq LstCoord  (mapcar '(lambda (x) (TransEcsToWcs x EnameShape))
								(mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) (entget EnameShape)))
							))

			
			(setq Pos+ Pos)
			(if (= Pos 0)
				(setq Pos- (- (length LstCoord) 1))
				(setq Pos- (1- Pos))
			)
			
			(setq Loop T)
			(while Loop
				(vla-GetWidth (vlax-ename->vla-object EnameShape) Pos+ 'StartWidth 'EndWidth)
				(cond
					((equal StartWidth $WdMicro Accuracy)
						(setq Rtn (cons Pos+ Rtn))
						(if (nth (1+ Pos+) LstCoord)
							(setq Rtn (cons (1+ Pos+) Rtn))
							(setq Rtn (cons 0 Rtn))
						)
					)
					((equal StartWidth $WdMicroAtPoint Accuracy)
						(setq RtnVertex (cons Pos+ RtnVertex))
						(if (nth (1+ Pos+) LstCoord)
							(setq Rtn (cons (1+ Pos+) Rtn))
							(setq Rtn (cons 0 Rtn))
						)
					)
					(t
						(setq Loop nil)
					)
				)
				(if Loop 
					(if (nth (1+ Pos+) LstCoord)
						(setq Pos+ (1+ Pos+))
						(setq Pos+ 0)
					)
				)
			)
			
			(setq Loop T)
			(while Loop
				(vla-GetWidth (vlax-ename->vla-object EnameShape) Pos- 'StartWidth 'EndWidth)
				(cond
					((equal StartWidth $WdMicro Accuracy)
						(setq Rtn (cons Pos- Rtn))
						(if (nth (1+ Pos-) LstCoord)
							(setq Rtn (cons (1+ Pos-) Rtn))
							(setq Rtn (cons 0 Rtn))
						)
					)
					((equal StartWidth $WdMicroAtPoint Accuracy)
						(setq RtnVertex (cons Pos- RtnVertex))
						(if (nth (1+ Pos-) LstCoord)
							(setq Rtn (cons (1+ Pos-) Rtn))
							(setq Rtn (cons 0 Rtn))
						)
					)
					(t
						(setq Loop nil)
					)
				)
				(if Loop 
					(if (= Pos- 0)
						(setq Pos- (- (length LstCoord) 1))
						(setq Pos- (1- Pos-))
					)
				)
			)
		)
	)
	(setq RtnVertex (LM:Unique RtnVertex))
	(setq Rtn (LM:Unique Rtn))
	(foreach itm RtnVertex
		(setq Rtn (LM:RemoveOnce itm Rtn))
	)
	(list RtnVertex Rtn)		
)
;
(defun RemoveMicro (EnameShape PtMicro / Acdoc LstCoord LstDataMicro itm)
	
	(if (and EnameShape PtMicro)
		(progn
			(setq Acdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
			(vla-StartUndoMark Acdoc)
				(setq LstCoord  (mapcar '(lambda (x) (TransEcsToWcs x EnameShape))
									(mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) (entget EnameShape)))
								))
				;(setq LstDataMicro (FindMicroAtPoint EnameShape (trans (osnap PtMicro "_end") 1 0)))
				(setq LstDataMicro (FindMicroAtPoint EnameShape PtMicro))
				(foreach itm (car LstDataMicro)
					(vla-setwidth (vlax-ename->vla-object EnameShape) itm 0.0 0.0)
				)
				(foreach itm (cadr LstDataMicro)
					(vla-setwidth (vlax-ename->vla-object EnameShape) itm 0.0 0.0)
				)
				(foreach itm (cadr LstDataMicro)
					(RemoveVertexLwPolyline EnameShape (nth itm LstCoord))
				)
				
				(setq LstDataMicro (FindMicro EnameShape))
				(if (and (null (car LstDataMicro)) (null (cadr LstDataMicro)))
					(if (IsLwPolylineCircle EnameShape)
						(RebuildLwCircle EnameShape)
					)
				)
				
				
			(vla-EndUndoMark Acdoc)
		)
	)
)
;
(defun RemoveAllMicro (EnameShape / Acdoc LstCoord LstDataMicro itm)

	(if EnameShape
		(progn
			(setq Acdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
			(vla-StartUndoMark Acdoc)
				(setq LstCoord  (mapcar '(lambda (x) (TransEcsToWcs x EnameShape))
									(mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) (entget EnameShape)))
								))
				(setq LstDataMicro (FindMicro EnameShape))
				(foreach itm (car LstDataMicro)
					(vla-setwidth (vlax-ename->vla-object EnameShape) itm 0.0 0.0)
				)
				(foreach itm (cadr LstDataMicro)
					(vla-setwidth (vlax-ename->vla-object EnameShape) itm 0.0 0.0)
				)
				(foreach itm (cadr LstDataMicro)
					(RemoveVertexLwPolyline EnameShape (nth itm LstCoord))
				)
				(if (IsLwPolylineCircle EnameShape)
					(RebuildLwCircle EnameShape)
				)
			(vla-EndUndoMark Acdoc)
		)
	)
)
;
(defun PointIsVertexLwPolyline (EnameShape Pt / Accuracy)
	
	;
	(setq Accuracy 0.01)
	(if (and EnameShape Pt)
		(MemberWithAccuracy (Pt->3dPt Pt) (mapcar '(lambda (x) (TransEcsToWcs x EnameShape))
											(mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) (entget EnameShape)))
										   ) Accuracy
		)
	)
)
;
(defun ReconditionProg (LgPolyLine Prog)

	(if (and LgPolyLine Prog)
		(cond
			((> Prog 0.0)
				(- Prog (* LgPolyLine (fix (/ Prog LgPolyLine))))
			)
			(T
				(+ Prog (* LgPolyLine (+ 1.0 (fix (/ (abs Prog) LgPolyLine)))))
			)
		)
	)
)
;
(defun MakeMicro (EnameShape PtMicro / Acdoc Prg LgPolyLine LstPrg)
	
	(setq Acdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
	(vla-StartUndoMark Acdoc)
		(setq Prg 		    (vlax-curve-getDistAtPoint (vlax-ename->vla-object EnameShape) PtMicro))
		(setq LgPolyLine    (vla-get-length (vlax-ename->vla-object EnameShape)))
		(setq LstPrg (list	(ReconditionProg LgPolyLine (- Prg (/ $LgMicro 2.0)))
							(ReconditionProg LgPolyLine (+ Prg (/ $LgMicro 2.0)))))

		(mapcar  '(lambda (x) (AddVertextLwPolyline EnameShape x))
				(mapcar '(lambda (x) (vlax-curve-getPointAtDist (vlax-ename->vla-object EnameShape) x))
								LstPrg
				)
		)
		(GraphicsMicroatDist EnameShape PtMicro (car LstPrg) (cadr LstPrg) $WdMicro $WdMicroatPoint)
	(vla-EndUndoMark Acdoc)
)
;
(defun MakeArrayMicro (EnameShape PtStart NumMicro StepMicro / Acdoc LgPolyLine NumberMicro PtMicro Prg LstPrg)

	(setq Acdoc (vla-get-ActiveDocument (vlax-get-acad-object)))
	(vla-StartUndoMark Acdoc)

	(if (and EnameShape PtStart)
		(progn
			(setq LgPolyLine   	(vla-get-length (vlax-ename->vla-object EnameShape)))
			(setq Prg 			(vlax-curve-getDistAtPoint (vlax-ename->vla-object EnameShape) PtStart))
			(setq PtMicro  		PtStart)
			(cond
				(NumMicro
					(setq StepMicro	(/ LgPolyLine NumMicro))
					
				)
				(StepMicro
					(if (>= (setq NumMicro (fix (/ LgPolyLine StepMicro))) 1)
						(setq NumMicro (1+ NumMicro))
					)
				)
				(t 
					(setq NumMicro 0)
				)
			)

			(repeat NumMicro
				(setq LstPrg (list	(ReconditionProg LgPolyLine (- Prg (/ $LgMicro 2.0)))
									(ReconditionProg LgPolyLine (+ Prg (/ $LgMicro 2.0)))
							))
							
				(mapcar  '(lambda (x) (AddVertextLwPolyline EnameShape x))
						(mapcar '(lambda (x) (vlax-curve-getPointAtDist (vlax-ename->vla-object EnameShape) x))
								LstPrg
						)
				)
				(GraphicsMicroatDist EnameShape PtMicro (car LstPrg) (cadr LstPrg) $WdMicro $WdMicroatPoint)
				(setq Prg (+ Prg StepMicro)) 
				(setq PtMicro (vlax-curve-getPointAtDist (vlax-ename->vla-object EnameShape) 
									(ReconditionProg LgPolyLine Prg)))
			)
		)
	)
	(vla-EndUndoMark Acdoc)
)
;
(defun RemoveVertexLwPolyline (EnameShape PtRemove / BuildListShape RemoveVertexToList
													 LstCoord)

	(defun BuildListShape (EnameShape / LstCo Pos Center Rtn)
	
		(if EnameShape
			(progn
				(setq LstCo (LM:LwVertices (entget EnameShape))) 
				;((10 -1000.0     0.0 0.0) (40 . 0.0) (41 . 0.0) (42 . 0.414214)) 
				;((10     0.0 -1000.0 0.0) (40 . 0.0) (41 . 0.0) (42 . 0.414214)) 
				;((10  1000.0     0.0 0.0) (40 . 0.0) (41 . 0.0) (42 . 0.414214)) 
				;((10     0.0  1000.0 0.0) (40 . 0.0) (41 . 0.0) (42 . 0.414214))		

				(setq Pos 0)
				(repeat (- (length LstCo) 1)
					(if (/= (cdr (assoc 42 (nth Pos LstCo))) 0)
						(setq Center (LM:bulgecentre (cdr (car (nth Pos LstCo))) (cdr (car (nth (+ Pos 1) LstCo))) (cdr (assoc 42 (nth Pos LstCo)))))
						(setq Center nil)
					)
					(setq Rtn (append Rtn (list (append (nth Pos LstCo) (list Center)))))
					(setq Pos (1+ Pos))
				)

				;(if (= (vla-get-closed (vlax-ename->vla-object EnameShape)) :vlax-true)
				(if (or (= (cdr (assoc 70 (entget EnameShape))) 1)
						(= (cdr (assoc 70 (entget EnameShape))) 129))
					(progn
						(if (/= (cdr (assoc 42 (car (reverse LstCo)))) 0)
							(setq Center (LM:bulgecentre (cdr (car (car (reverse LstCo)))) (cdr (car (car LstCo))) (cdr (assoc 42 (car (reverse LstCo))))))
							(setq Center nil)
						)
						(setq Rtn (append Rtn (list (append (car (reverse LstCo)) (list Center)) )))
					)
					(setq Rtn (append Rtn (list (append (car (reverse LstCo)) (list nil)) )))
				)
			)
		)
		Rtn
	)
	;
	(defun RemoveVertexToList (EnameShape LstCoord PtRemove / LstPos Bulge NewItm Rtn)
	
		;(	((10 3756.63 577.968 0.0) (40 . 0.0) (41 . 0.0) (42 . -0.273043) (3975.8 782.56 0.0)) 
		;	((10 3690.74 875.499 0.0) (40 . 0.0) (41 . 0.0) (42 . -0.243861) (3975.8 782.56 0.0)) 
		;	((10 3887.52 1069.09 0.0) (40 . 0.0) (41 . 0.0) (42 . 0.597495)  (3813.07 1310.74 0.0)) 
		;	((10 3973.72 1506.0 0.0)  (40 . 0.0) (41 . 0.0) (42 . 0.0) nil)
		;)
		
		(defun GetNthPos (EnameShape PtRemove / Rtn Pos Nv)
		
			(setq Nv  (fix (/ (length (vlax-get (vlax-ename->vla-object EnameShape) 'coordinates)) 2.0)))
			;(setq Pos (fix (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (trans PtRemove 1 0))))
			(setq Pos (atoi (rtos (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (trans PtRemove 1 0)))))

			(if (> Nv 2)
				(cond 
					((= Pos 0)
						;(if (= (vla-get-closed  (vlax-ename->vla-object EnameShape)) :vlax-true)
						(if (or (= (cdr (assoc 70 (entget EnameShape))) 1)
								(= (cdr (assoc 70 (entget EnameShape))) 129))
								(setq Rtn (list (1- Nv) Pos (1+ Pos)))
								(setq Rtn nil)
						)
					)
					((= Pos (1- Nv))
						;(if (= (vla-get-closed  (vlax-ename->vla-object EnameShape)) :vlax-true)
						(if (or (= (cdr (assoc 70 (entget EnameShape))) 1)
								(= (cdr (assoc 70 (entget EnameShape))) 129))
							(setq Rtn (list (- Pos 1) Pos 0))
							(setq Rtn nil)
						)
					)
					(t
						(setq Rtn (list (1- Pos) Pos (1+ Pos)))
					)
				)
			)
			Rtn
		)
		;
		(defun IsRemovable (LstCoord PtRemove / LstPos Rtn Accuracy Center1 Center2)
		
			(setq Accuracy $OverlappAcuracyCollinear)
			(if (and LstCoord PtRemove)
				(if (setq LstPos (GetNthPos EnameShape PtRemove))
					(progn
						(setq Center1 (car (reverse (nth (car LstPos) LstCoord))))
						(setq Center2 (car (reverse (nth (cadr LstPos) LstCoord))))
						(cond
							((and (null Center1) (null Center2))			; Check StraightLine
								(if (LM:Collinear-p (cdr (assoc 10 (nth (car LstPos) LstCoord))) 
													(cdr (assoc 10 (nth (cadr LstPos) LstCoord)))
													(cdr (assoc 10 (nth (caddr LstPos) LstCoord))) Accuracy)
									(setq Rtn (append LstPos (list 2)))
								)
							)
							((equal Center1 Center2 Accuracy) 				; Check Arc
								(setq Rtn (append LstPos (list 1)))						
							)
						)
					)
				)
			)
			Rtn
		)
		;
		;
		(if (and EnameShape LstCoord PtRemove)
			(if (setq LstPos (IsRemovable LstCoord PtRemove))
				(cond	
					((= (nth 3 LstPos) 1) 
						(setq Bulge    (LM:3p->bulge (cdr (assoc 10 (nth (car LstPos) LstCoord)))
													 (cdr (assoc 10 (nth (cadr LstPos) LstCoord)))
													 (cdr (assoc 10 (nth (caddr LstPos) LstCoord)))))
						(setq NewItm   (list (nth 0 (nth (car LstPos) LstCoord))
											 (nth 1 (nth (car LstPos) LstCoord))	
											 (nth 2 (nth (car LstPos) LstCoord))	
											 (cons 42 Bulge) 
											 (nth 4 (nth (car LstPos) LstCoord))))
											 
						(setq Rtn (LM:SubstNth NewItm (car LstPos) LstCoord))
						(setq Rtn (LM:RemoveNth (cadr LstPos) Rtn))
					)
					((= (nth 3 LstPos) 2)
						(setq Rtn (LM:RemoveNth (cadr LstPos) LstCoord))
					)
				)
			)
		)
		Rtn
	)
	;
	; Main
	;
	(setq LstCoord (BuildListShape EnameShape))
	(if (setq LstCoord (RemoveVertexToList EnameShape LstCoord PtRemove))
		(progn
			;(	((10 3756.63 577.968 0.0) (40 . 0.0) (41 . 0.0) (42 . -0.273043) (3975.8 782.56 0.0)) 
			;	((10 3887.52 1069.09 0.0) (40 . 0.0) (41 . 0.0) (42 . -0.553777) (3813.07 1310.74 0.0)) 
			;	((10 3973.72 1506.0 0.0)  (40 . 0.0) (41 . 0.0) (42 . 0.0) nil)
			;)
			(setq LstCoord 	(mapcar '(lambda (x) (LM:RemoveNth 4 x)) LstCoord))
			(ChangeShapeLwPolyline EnameShape LstCoord)
		)
		;(ReBuildListShape EnameShape LstCoord)
		nil
	)
)
;
(defun AddVertextLwPolyline (EnameShape PtAdd / BuildListShape AddVertexToList
												LstCoord)

	(defun BuildListShape (EnameShape / LstCo Pos Center Rtn)
	
		(if EnameShape
			(progn
				(setq LstCo (LM:LwVertices (entget EnameShape))) 
				;((10 -1000.0     0.0 0.0) (40 . 0.0) (41 . 0.0) (42 . 0.414214)) 
				;((10     0.0 -1000.0 0.0) (40 . 0.0) (41 . 0.0) (42 . 0.414214)) 
				;((10  1000.0     0.0 0.0) (40 . 0.0) (41 . 0.0) (42 . 0.414214)) 
				;((10     0.0  1000.0 0.0) (40 . 0.0) (41 . 0.0) (42 . 0.414214))		

				(setq Pos 0)
				(repeat (- (length LstCo) 1)
					(if (/= (cdr (assoc 42 (nth Pos LstCo))) 0)
						(setq Center (LM:bulgecentre (cdr (car (nth Pos LstCo))) (cdr (car (nth (+ Pos 1) LstCo))) (cdr (assoc 42 (nth Pos LstCo)))))
						(setq Center nil)
					)
					(setq Rtn (append Rtn (list (append (nth Pos LstCo) (list Center)))))
					(setq Pos (1+ Pos))
				)
				;(if (= (vla-get-closed (vlax-ename->vla-object EnameShape)) :vlax-true)
				(if (or (= (cdr (assoc 70 (entget EnameShape))) 1)
						(= (cdr (assoc 70 (entget EnameShape))) 129))
					(progn
						(if (/= (cdr (assoc 42 (car (reverse LstCo)))) 0)
							(setq Center (LM:bulgecentre (cdr (car (car (reverse LstCo)))) (cdr (car (car LstCo))) (cdr (assoc 42 (car (reverse LstCo))))))
							(setq Center nil)
						)
						(setq Rtn (append Rtn (list (append (car (reverse LstCo)) (list Center)) )))
					)
					(setq Rtn (append Rtn (list (append (car (reverse LstCo)) (list nil)) )))
				)
			)
		)
		Rtn
	)
	;
	(defun AddVertexToList (EnameShape LstCoord PtAdd / GetDataAdd
														LstPos ChtItm NewItm Rtn)
	
		;(	((10 3756.63 577.968 0.0) (40 . 0.0) (41 . 0.0) (42 . -0.273043) (3975.8 782.56 0.0)) 
		;	((10 3690.74 875.499 0.0) (40 . 0.0) (41 . 0.0) (42 . -0.243861) (3975.8 782.56 0.0)) 
		;	((10 3887.52 1069.09 0.0) (40 . 0.0) (41 . 0.0) (42 . 0.597495)  (3813.07 1310.74 0.0)) 
		;	((10 3973.72 1506.0 0.0)  (40 . 0.0) (41 . 0.0) (42 . 0.0) nil)
		;)
		
		(defun GetDataAdd (EnameShape PtAdd / Accuracy Coord Nv Pos Bulge StartEcs EndEcs PtAddEcs ObjShape Center BulgePos BulgeAdd 
											  D12 D23 PtOnD12 PtOnD23 Rtn)
		
		
			(if (and EnameShape PtAdd)
				(progn
					(setq Accuracy 0.01)
					(setq Coord 	(vlax-get (vlax-ename->vla-object EnameShape) 'coordinates))
					(setq Nv   	 	(fix (/ (length Coord) 2.0)))
					;(setq Pos   	(fix (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (trans PtAdd 1 0))))
					(setq Pos   	(atoi (rtos (vlax-curve-getParamAtPoint (vlax-ename->vla-object EnameShape) (trans PtAdd 1 0)))))
					(setq StartEcs  (list (nth (+ (* 2 Pos) 0) Coord) (nth (+ (* 2 Pos) 1) Coord)))
					(if (= (- Nv 1) Pos)
						(setq EndEcs (list (nth 0 Coord) (nth 1 Coord)))
						(setq EndEcs (list (nth (+ (* 2 (+ Pos 1)) 0) Coord) (nth (+ (* 2 (+ Pos 1)) 1) Coord)))
					)

					(setq PtAddEcs (TransWcsToEcs PtAdd EnameShape))
					(setq ObjShape (vlax-ename->vla-object EnameShape))
					(if (and (not (MyEqualPoint StartEcs PtAddEcs Accuracy)) (not (MyEqualPoint EndEcs PtAddEcs Accuracy)))
						(if (/= (setq Bulge (vla-getbulge (vlax-ename->vla-object EnameShape) Pos)) 0.0)
							(progn
							
								(setq D12 (/ (+ (vlax-curve-getDistAtPoint ObjShape (TransEcsToWcs StartEcs EnameShape))
											    (vlax-curve-getDistAtPoint ObjShape (Trans PtAdd 1 0))) 2.0))
												
								(if (= (vlax-curve-getDistAtPoint ObjShape (TransEcsToWcs EndEcs EnameShape)) 0.0)
									(setq D23 (/ (+ (vlax-curve-getDistAtPoint ObjShape (Trans PtAdd 1 0)) 
													(vla-get-length ObjShape)) 2.0))
									(setq D23 (/ (+ (vlax-curve-getDistAtPoint ObjShape (Trans PtAdd 1 0)) 
													(vlax-curve-getDistAtPoint ObjShape (TransEcsToWcs EndEcs EnameShape))) 2.0))
								)

							
								(setq PtOnD12 (TransWcsToEcs (vlax-curve-getPointAtDist ObjShape D12) EnameShape))
								(setq PtOnD23 (TransWcsToEcs (vlax-curve-getPointAtDist ObjShape D23) EnameShape))
							
								(setq BulgePos (LM:3p->bulge StartEcs PtOnD12 PtAddEcs))
								(setq BulgeAdd (LM:3p->bulge PtAddEcs PtOnD23 EndEcs))
								(setq Rtn (list Pos BulgePos BulgeAdd))
							)
							(setq Rtn (list Pos 0.0 0.0))
						)
					)
				)
			)
			Rtn
		)
		;
		; Main
		;
		(if (setq LstPos (GetDataAdd EnameShape PtAdd))
			(progn
				(setq PtAddEcs (trans (trans PtAdd 1 0) 0 (cdr (assoc 210 (entget EnameShape)))))
				
				(setq ChtItm (list (nth 0 (nth (car LstPos) LstCoord))
								   (nth 1 (nth (car LstPos) LstCoord))
								   (nth 2 (nth (car LstPos) LstCoord))
								   (cons 42 (cadr LstPos))
								   (nth 4 (nth (car LstPos) LstCoord))))
				(setq NewItm 	(list (cons 10 (list (nth 0 PtAddEcs) (nth 1 PtAddEcs)))
									  (nth 1 (nth (car LstPos) LstCoord))
									  (nth 2 (nth (car LstPos) LstCoord))
									  (cons 42 (caddr LstPos))
									  (nth 4 (nth (car LstPos) LstCoord))))
				
				(setq LstCoord (LM:SubstNth ChtItm  (car LstPos) LstCoord))
				(setq LstCoord (LM:InsertNth ChtItm (car LstPos) LstCoord))
				(setq Rtn (LM:SubstNth NewItm (1+ (car LstPos)) LstCoord))
			)
		)
		Rtn
	)
	;

	;
	; Main
	;
	(setq LstCoord (BuildListShape EnameShape))
	(if (setq LstCoord (AddVertexToList EnameShape LstCoord PtAdd))
		(progn
			;(	((10 3756.63 577.968 0.0) (40 . 0.0) (41 . 0.0) (42 . -0.273043) (3975.8 782.56 0.0)) 
			;	((10 3887.52 1069.09 0.0) (40 . 0.0) (41 . 0.0) (42 . -0.553777) (3813.07 1310.74 0.0)) 
			;	((10 3973.72 1506.0 0.0)  (40 . 0.0) (41 . 0.0) (42 . 0.0) nil)
			;)
			(setq LstCoord 	(mapcar '(lambda (x) (LM:RemoveNth 4 x)) LstCoord))
			(ChangeShapeLwPolyline EnameShape LstCoord)
		)
		nil
	)
)
;
(defun SimpleLwPolyLine (EnameShape Verbose / itm Pos Nv VertexRemove)
	(if EnameShape
		(cond
			((IsLwPolylineCircle EnameShape)
				(RebuildLwCircle EnameShape)
			)
			(t
				(setq Nv (cdr (assoc 90 (entget EnameShape))))
				(foreach itm (mapcar '(lambda (x) (TransEcsToWcs x EnameShape))
								(mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) (entget EnameShape))))
						;(terpri) (princ itm)
						(RemoveVertexLwPolyline EnameShape itm)
				)
				(setq VertexRemove (- Nv (cdr (assoc 90 (entget EnameShape)))))
				
				(setq Pos 0)
				(repeat  (length (mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) (entget EnameShape))))
					(vla-setwidth (vlax-ename->vla-object EnameShape) Pos 0.0 0.0)
					(setq Pos (1+ Pos))
				)
				(if Verbose 
					(cond
						((= VertexRemove 1) (alert (strcat "Rimosso " (rtos VertexRemove 2 0) " vertice")))
						((> VertexRemove 0) (alert (strcat "Rimosso " (rtos VertexRemove 2 0) " vertici")))
					)
				)
			)
		)
	)
)
;
(defun c:Example_getWidth()

    (setq acadObj (vlax-get-acad-object))
    (setq doc (vla-get-ActiveDocument acadObj))
    
    (vla-GetEntity (vla-get-Utility doc) 'returnObj 'basePnt "123456 : ")
        
    (if (/= returnObj nil)
        (progn
          (if (= (vla-get-ObjectName returnObj) "AcDbPolyline")
            (progn
                  (setq retCoord (vlax-variant-value (vla-get-Coordinates returnObj)))
         
                  (setq segment 0
                        i (vlax-safearray-get-l-bound retCoord 1)        
                        j (vlax-safearray-get-u-bound retCoord 1)        
                        nbr_of_vertices (+ (/ (- j i) 2) 1))            
         
                  (if (= (vla-get-Closed returnObj) :vlax-true)
                      (setq nbr_of_segments nbr_of_vertices)
                      (setq nbr_of_segments (1- nbr_of_vertices))
                  )
     
                  (while (>= nbr_of_segments 0)
				  
                      (vla-GetWidth returnObj segment 'StartWidth 'EndWidth)
 
                      (setq message_string (strcat " "
                                                   (rtos (vlax-safearray-get-element retCoord i) 2) ","
                                                   (rtos (vlax-safearray-get-element retCoord (1+ i)) 2)
                                                   " " (rtos StartWidth 2) 
                                                   " " (rtos EndWidth 2)))
                        (alert message_string)
 
                        ;;; Prepare to obtain width of next segment, if any
                        (setq i (+ i 2))
                        (setq segment (1+ segment))
                        (setq nbr_of_segments (1- nbr_of_segments))
                  )
            )
            (alert "")
            )
       )
       (alert "")
    )
)