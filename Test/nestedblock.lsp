;(SetAttributeValueNestedBlock "2" "BlockSheet01" "THICKNESS_SHEET" "100")

;
;
;
;
;
;




;(((-1 . <Entity name: 708ae8b0>) (0 . "BLOCK") (330 . <Entity name: 708ae8a0>) (5 . "1FB") (100 . "AcDbEntity") (67 . 0) (8 . "0") (100 . "AcDbBlockBegin") (70 . 0) (10 0.0 0.0 0.0) (-2 . <Entity name: 708ae8d0>) (2 . "Test") (1 . "")) 
;((-1 . <Entity name: 708ae8d0>) (0 . "INSERT") (330 . <Entity name: 708ae8a0>) (5 . "1FD") (100 . "AcDbEntity") (67 . 0) (8 . "0") (100 . "AcDbBlockReference") (66 . 1) (2 . "BlockSheet01") (10 -5.56285 52.4497 0.0) (41 . 1.0) (42 . 1.0) (43 . 1.0) (50 . 0.0) (70 . 0) (71 . 0) (44 . 0.0) (45 . 0.0) (210 0.0 0.0 1.0)) 
;((-1 . <Entity name: 708ae8e0>) (0 . "ATTRIB") (330 . <Entity name: 708ae8d0>) (5 . "1FE") (100 . "AcDbEntity") (67 . 0) (8 . "0") (100 . "AcDbText") (10 227.223 -639.951 0.0) (40 . 40.0) (1 . "407719937") (50 . 0.0) (41 . 0.8) (51 . 0.0) (7 . "EasyCutStyle") (71 . 0) (72 . 0) (11 0.0 0.0 0.0) (210 0.0 0.0 1.0) (100 . "AcDbAttribute") (280 . 0) (2 . "DIMENSION_SHEET") (70 . 0) (73 . 0) (74 . 0) (280 . 1)) 
;((-1 . <Entity name: 708ae8f0>) (0 . "ATTRIB") (330 . <Entity name: 708ae8d0>) (5 . "1FF") (100 . "AcDbEntity") (67 . 0) (8 . "0") (100 . "AcDbText") (10 227.223 -719.951 0.0) (40 . 40.0) (1 . "01/12/2011") (50 . 0.0) (41 . 0.8) (51 . 0.0) (7 . "EasyCutStyle") (71 . 0) (72 . 0) (11 0.0 0.0 0.0) (210 0.0 0.0 1.0) (100 . "AcDbAttribute") (280 . 0) (2 . "THICKNESS_SHEET") (70 . 0) (73 . 0) (74 . 0) (280 . 1)) 
;((-1 . <Entity name: 708ae900>) (0 . "ATTRIB") (330 . <Entity name: 708ae8d0>) (5 . "200") (100 . "AcDbEntity") (67 . 0) (8 . "0") (100 . "AcDbText") (10 227.223 -799.951 0.0) (40 . 40.0) (1 . "FOR  REVIEW") (50 . 0.0) (41 . 0.8) (51 . 0.0) (7 . "EasyCutStyle") (71 . 0) (72 . 0) (11 0.0 0.0 0.0) (210 0.0 0.0 1.0) (100 . "AcDbAttribute") (280 . 0) (2 . "NAME_SHEET") (70 . 0) (73 . 0) (74 . 0) (280 . 1)) 
;((-1 . <Entity name: 708ae910>) (0 . "ATTRIB") (330 . <Entity name: 708ae8d0>) (5 . "201") (100 . "AcDbEntity") (67 . 0) (8 . "0") (100 . "AcDbText") (10 227.223 -879.951 0.0) (40 . 40.0) (1 . "MAL") (50 . 0.0) (41 . 0.8) (51 . 0.0) (7 . "EasyCutStyle") (71 . 0) (72 . 0) (11 0.0 0.0 0.0) (210 0.0 0.0 1.0) (100 . "AcDbAttribute") (280 . 0) (2 . "ID_SHEET") (70 . 0) (73 . 0) (74 . 0) (280 . 1)) 
;((-1 . <Entity name: 708ae920>) (0 . "ATTRIB") (330 . <Entity name: 708ae8d0>) (5 . "202") (100 . "AcDbEntity") (67 . 0) (8 . "0") (100 . "AcDbText") (10 227.223 -559.951 0.0) (40 . 40.0) (1 . "01/12/2011") (50 . 0.0) (41 . 0.8) (51 . 0.0) (7 . "EasyCutStyle") (71 . 0) (72 . 0) (11 0.0 0.0 0.0) (210 0.0 0.0 1.0) (100 . "AcDbAttribute") (280 . 0) (2 . "MATERIAL_SHEET") (70 . 0) (73 . 0) (74 . 0) (280 . 1)) 
;((-1 . <Entity name: 708ae930>) (0 . "SEQEND") (330 . <Entity name: 708ae8d0>) (5 . "203") (100 . "AcDbEntity") (67 . 0) (8 . "0") (-2 . <Entity name: 708ae8d0>)) 
;((-1 . <Entity name: 708ae940>) (0 . "INSERT") (330 . <Entity name: 708ae8a0>) (5 . "204") (100 . "AcDbEntity") (67 . 0) (8 . "0") (100 . "AcDbBlockReference") (2 . "RULE_92070") (10 -5.56285 52.4497 0.0) (41 . 1.0) (42 . 1.0) (43 . 1.0) (50 . 0.0) (70 . 0) (71 . 0) (44 . 0.0) (45 . 0.0) (210 0.0 0.0 1.0)))

(defun LM:AddObjectstoBlock (block ss / doc lst mat )
	(if (and block ss)
		(progn
			(setq doc (vla-get-ActiveDocument (vlax-get-acad-object))
 				  lst (LM:ss->vla ss)
				  mat (LM:Ref->Def block)
				  mat (vlax-tmatrix (append (mapcar 'append (car mat) (mapcar 'list (cadr mat))) '((0. 0. 0. 1.))))
			)
			(foreach obj lst (vla-transformby obj mat))
 
			(vla-CopyObjects doc (LM:SafearrayVariant vlax-vbobject lst)
				(vla-item (vla-get-Blocks doc) (cdr (assoc 2 (entget block))))
			)
			(foreach obj lst (vla-delete obj))
			(vla-regen doc acAllViewports)
		)
	)
)
;-------------------------------------------------------------;
(defun LM:RemovefromBlock ( doc ent )
  (vla-delete (vlax-ename->vla-object ent))
  (vla-regen doc acAllViewports)
  (princ)
)
;-------------------------------------------------------------;
(defun LM:SafearrayVariant ( datatype data )
  (vlax-make-variant
    (vlax-safearray-fill
      (vlax-make-safearray datatype (cons 0 (1- (length data)))) data
    )    
  )
)
;-------------------------------------------------------------;
(defun LM:Ref->Def ( e / _dxf a l n )
 
	;; Matrix x Vector  -  Vladimir Nesterovsky
	(defun mxv ( m v )
	  (mapcar '(lambda ( r ) (apply '+ (mapcar '* r v))) m)
	)
	 
	;; Matrix x Matrix  -  Vladimir Nesterovsky
	(defun mxm ( m q )
	  (mapcar (function (lambda ( r ) (mxv (trp q) r))) m)
	)
	 
	;; Matrix Transpose  -  Doug Wilson
	(defun trp ( m )
	  (apply 'mapcar (cons 'list m))
	) 
 
	(defun _dxf ( x l ) (cdr (assoc x l)))
	;
	; Main
	;
	(setq l (entget e) a (- (_dxf 50 l)) n (_dxf 210 l))
	(
		(lambda ( m )
		  (list m
			(mapcar '- (_dxf 10 (tblsearch "BLOCK" (_dxf 2 l)))
			  (mxv m
				(trans (_dxf 10 l) n 0)
			  )
			)
		  )
		)
		(mxm
		  (list
			(list (/ 1. (_dxf 41 l)) 0. 0.)
			(list 0. (/ 1. (_dxf 42 l)) 0.)
			(list 0. 0. (/ 1. (_dxf 43 l)))
		  )
		  (mxm
			(list
			  (list (cos a) (sin (- a)) 0.)
			  (list (sin a) (cos a)     0.)
			  (list    0.        0.     1.)
			)
			(mapcar '(lambda ( e ) (trans e n 0 t))
			 '(
				(1. 0. 0.)
				(0. 1. 0.)
				(0. 0. 1.)
			  )
			)
		  )
		)
	)
)
;-------------------------------------------------------------;

