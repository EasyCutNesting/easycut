;
;
;
(defun LM:roundup ( n m )
    ((lambda ( r ) (cond ((equal 0.0 r 1e-8) n) ((< n 0) (- n r)) ((+ n (- m r))))) (rem n m))
)
;
;
;
(defun LM:roundm ( n m )
    (* m (atoi (rtos (/ n (float m)) 2 0)))
)
;
;
;
(defun LM:ss->ent ( ss / i l )
	(if ss
		(repeat (setq i (sslength ss))
			(if (entget (ssname ss (setq i (1- i))))
				(setq l (cons (ssname ss i) l))
			)
		)
	)
	l
)
;
;
;
(defun LM:ss->vla ( ss / i l )
  (if ss
    (repeat (setq i (sslength ss))
      (setq l (cons (vlax-ename->vla-object (ssname ss (setq i (1- i)))) l))
    )
  )
)
;
;
;
(defun LM:rtos ( real units prec / dimzin result )

	;; rtos wrapper  -  Lee Mac
	;; A wrapper for the rtos function to negate the effect of DIMZIN
	
    (setq dimzin (getvar 'dimzin))
    (setvar 'dimzin 0)
    (setq result (vl-catch-all-apply 'rtos (list real units prec)))
    (setvar 'dimzin dimzin)
    (if (not (vl-catch-all-error-p result))
        result
    )
)
;
;
;
(defun LM:outline ( sel / LM:ssboundingbox
						  app are box cmd dis enl ent lst obj rtn tmp )

	(defun LM:ssboundingbox ( s / a b i m n o )
		(repeat (setq i (sslength s))
			(if
				(and
					(setq o (vlax-ename->vla-object (ssname s (setq i (1- i)))))
					(vlax-method-applicable-p o 'getboundingbox)
					(not (vl-catch-all-error-p (vl-catch-all-apply 'vla-getboundingbox (list o 'a 'b))))
				)
				(setq m (cons (vlax-safearray->list a) m)
					  n (cons (vlax-safearray->list b) n)
				)
			)
		)
		(if (and m n)
			(mapcar '(lambda ( a b ) (apply 'mapcar (cons a b))) '(min max) (list m n))
		)
	)


    (if (setq box (LM:ssboundingbox sel))
        (progn
            (setq app (vlax-get-acad-object)
                  dis (/ (apply 'distance box) 20.0)
                  lst (mapcar '(lambda ( a o ) (mapcar o a (list dis dis))) box '(- +))
                  are (apply '* (apply 'mapcar (cons '- (reverse lst))))
                  dis (* dis 1.5)
                  ent
                (entmakex
                    (append
                       '(   (000 . "LWPOLYLINE")
                            (100 . "AcDbEntity")
                            (100 . "AcDbPolyline")
                            (090 . 4)
                            (070 . 1)
                        )
                        (mapcar '(lambda ( x ) (cons 10 (mapcar '(lambda ( y ) ((eval y) lst)) x)))
                           '(   (caar   cadar)
                                (caadr  cadar)
                                (caadr cadadr)
                                (caar  cadadr)
                            )
                        )
                    )
                )
            )
            (apply 'vlax-invoke
                (vl-list* app 'zoomwindow
                    (mapcar '(lambda ( a o ) (mapcar o a (list dis dis 0.0))) box '(- +))
                )
            )
            (setq cmd (getvar 'cmdecho)
                  enl (entlast)
                  rtn (ssadd)
            )
            (while (setq tmp (entnext enl)) (setq enl tmp))
            (setvar 'cmdecho 0)
            (command
                "_.-boundary" "_a" "_b" "_n" sel ent "" "_i" "_y" "_o" "_p" "" "_non"
                (trans (mapcar '- (car box) (list (/ dis 3.0) (/ dis 3.0))) 0 1) ""
            )
            (while (< 0 (getvar 'cmdactive)) (command ""))
            (entdel ent)
            (while (setq enl (entnext enl))
                (if (and (vlax-property-available-p (setq obj (vlax-ename->vla-object enl)) 'area)
                         (equal (vla-get-area obj) are 1e-4)
                    )
                    (entdel enl)
                    (ssadd  enl rtn)
                )
            )
            (vla-zoomprevious app)
            (setvar 'cmdecho cmd)
            rtn
        )
    )
)
;
;
;
(defun LM:SSBoundingBox ( ss / bb )
  ;;(vl-load-com)
  ;; © Lee Mac 2010
  
  (
    (lambda ( i / e ll ur )
      (while (setq e (ssname ss (setq i (1+ i))))
        (vla-getBoundingBox (vlax-ename->vla-object e) 'll 'ur)

        (setq bb (cons (vlax-safearray->list ur)
                       (cons (vlax-safearray->list ll) bb))
        )
      )
    )
    -1
  )
  (
    (lambda ( data )
      (mapcar
        (function
          (lambda ( funcs )
            (mapcar
              (function
                (lambda ( func ) ((eval func) data))
              )
              funcs
            )
          )
        )
       '((caar cadar) (caadr cadar) (caadr cadadr) (caar cadadr))
      )
    )
    (mapcar
      (function
        (lambda ( operation )
          (apply (function mapcar) (cons operation bb))
        )
      )
     '(min max)
    )
  )
)
;
;
;
(defun LM:ListUnion ( l1 l2 )
  ( (lambda ( f ) (f (append l1 l2)))
    (lambda ( l ) (if l (cons (car l) (f (vl-remove (car l) (cdr l))))))
  )
)
;
;
;
(defun LM:Unique ( l )
    (if l (cons (car l) (LM:Unique (vl-remove (car l) (cdr l)))))
)
;
;
;
(defun LM:UniqueFuzz ( l f )
		(if l
			(cons (car l)
				(LM:UniqueFuzz
					(vl-remove-if
						(function (lambda ( x ) (equal x (car l) f)))
						(cdr l)
					)
					f
				)
			)
		)
)
;
;
;
(defun LM:CountItems ( l / c l r x )
    (while l
        (setq x (car l)
              c (length l)
              l (vl-remove x (cdr l))
              r (cons (list x (- c (length l))) r)
        )
    )
    (reverse r)
)
;
;
;
(defun LM:flatten ( l )
	;(LM:flatten '(0 (1 (2 . 3) (4 (5 (6 7) (8 (9)) 0)))))
	;Return (0 1 2 3 4 5 6 7 8 9 0)
    (if (atom l)
        (list l)
        (append (LM:flatten (car l)) (if (cdr l) (LM:flatten (cdr l))))
    )
)
;
;
;
(defun LM:flatten-nils ( l )
	;(LM:flatten-nils '(0 (1 (2 . 3) ( ) (4 (5 (6 nil 7) (8 (9)) 0)))))
	;(0 1 2 3 4 5 6 7 8 9 0)
    (if l
        (if (atom l)
            (list l)
            (append (LM:flatten-nils (car l)) (LM:flatten-nils (cdr l)))
        )
    )
)
;
;
;
(defun LM:RemoveOnce ( x l / f )
	; (LM:RemoveOnce (list 3 4) (list 3 4 (list 3 4) 5 3 6)) ---> (3 4 5 3 6)
    (setq f equal)
    (vl-remove-if '(lambda ( a ) (if (f a x) (setq f (lambda ( a b ) nil)))) l)
)
;
;
;
(defun LM:RemoveOnceF ( x l f)
	(if l
		(if (equal x (car l) f)
			(cdr l)
			(cons (car l) (LM:RemoveOnceF x (cdr l) f))
		)
	)
)
;
;
;
(defun LM:RemoveNth ( n l / i )
		;(LM:RemoveNth 3 '("A" "B" "C" "D" "E" "F")) ---> ("A" "B" "C" "E" "F")
		(setq i -1)
		(vl-remove-if '(lambda ( x ) (= (setq i (1+ i)) n)) l)
)
;
;
;
(defun LM:InsertNth ( x n l / i )
    (setq i -1)
    (apply 'append (mapcar '(lambda ( a ) (if (= n (setq i (1+ i))) (list x a) (list a))) l))
)
;
;
;
(defun LM:SubstNth ( a n l / i )
		(setq i -1)
		(mapcar '(lambda ( x ) (if (= (setq i (1+ i)) n) a x)) l)
)
;
;
;
(defun LM:SubLst ( lst idx len )
	;; Sublst  -  Lee Mac
	;; The list analog of the substr function
	;; lst - [lst] List from which sublist is to be returned
	;; idx - [int] Zero-based index at which to start the sublist
	;; len - [int] Length of the sublist or nil to return all items following idx
	(cond
		(   (null lst) nil)
		(   (< 0  idx) (LM:sublst (cdr lst) (1- idx) len))
		(   (null len) lst)
		(   (< 0  len) (cons (car lst) (LM:sublst (cdr lst) idx (1- len))))
	)
)	
;
;
;
(defun LM:StringSubst ( new old str / inc len )
    (setq len (strlen new)
          inc 0
    )
    (while (setq inc (vl-string-search old str inc))
        (setq str (vl-string-subst new old str inc)
              inc (+ inc len)
        )
    )
    str
)
;
;
;
(defun LM:str->lst ( str del / pos )
	(if (setq pos (vl-string-search del str))
		(cons (substr str 1 pos) (LM:str->lst (substr str (+ pos 1 (strlen del))) del))
		(list str)
	)
)
;
;
;
(defun LM:lst->str ( lst del / str )
    (setq str (car lst))
    (foreach itm (cdr lst) (setq str (strcat str del itm)))
    str
)
;
;
;
(defun LM:readcsv ( csv / des lst sep str )
;; Read CSV  -  Lee Mac
;; Parses a CSV file into a matrix list of cell values.
;; csv - [str] filename of CSV file to read
    (if (setq des (open csv "r"))
        (progn
            (setq sep (cond ((vl-registry-read "HKEY_CURRENT_USER\\Control Panel\\International" "sList")) (",")))
            (while (setq str (read-line des))
                (setq lst (cons (LM:csv->lst str sep 0) lst))
            )
            (close des)
        )
    )
    (reverse lst)
)
;
;
;
(defun LM:csv->lst ( str sep pos / s )
    (cond
        (   (not (setq pos (vl-string-search sep str pos)))
            (if (wcmatch str "\"*\"")
                (list (LM:csv-replacequotes (substr str 2 (- (strlen str) 2))))
                (list str)
            )
        )
        (   (or (wcmatch (setq s (substr str 1 pos)) "\"*[~\"]")
                (and (wcmatch s "~*[~\"]*") (= 1 (logand 1 pos)))
            )
            (LM:csv->lst str sep (+ pos 2))
        )
        (   (wcmatch s "\"*\"")
            (cons
                (LM:csv-replacequotes (substr str 2 (- pos 2)))
                (LM:csv->lst (substr str (+ pos 2)) sep 0)
            )
        )
        (   (cons s (LM:csv->lst (substr str (+ pos 2)) sep 0)))
    )
)
;
;
;
(defun LM:csv-replacequotes ( str / pos )
    (setq pos 0)
    (while (setq pos (vl-string-search  "\"\"" str pos))
        (setq str (vl-string-subst "\"" "\"\"" str pos)
              pos (1+ pos)
        )
    )
    str
)
;
;
;
(defun LM:directoryfiles ( dir typ sub )
	;; Directory Files  -  Lee Mac
	;; Retrieves all files of a specified filetype residing in a directory (and subdirectories)
	;; dir - [str] Root directory for which to return filenames
	;; typ - [str] Optional filetype filter (DOS pattern)
	;; sub - [bol] If T, subdirectories of the root directory are included
	;; Returns: [lst] List of files matching the filetype criteria, else nil if none are found
    (setq dir (vl-string-right-trim "\\" (vl-string-translate "/" "\\" dir)))
    (append (mapcar '(lambda ( x ) (strcat dir "\\" x)) (vl-directory-files dir typ 1))
        (if sub
            (apply 'append
                (mapcar
                   '(lambda ( x )
                        (if (not (wcmatch x "`.,`.`."))
                            (LM:directoryfiles (strcat dir "\\" x) typ sub)
                        )
                    )
                    (vl-directory-files dir nil -1)
                )
            )
        )
    )
)
;
;
;
(defun LM:setdynpropvalue ( EnameBlock prp val )
	;; Set Dynamic Block Property Value  -  Lee Mac
	;; Modifies the value of a Dynamic Block property (if present)
	;; EnameBlock 	- [vla] VLA Dynamic Block Reference
	;; prp 			- [str] Dynamic Block property name (case-insensitive)
	;; val 			- [any] New value for property
	;; Returns: [any] New value if successful, else nil
   (setq prp (strcase prp))
    (vl-some
       '(lambda ( x )
            (if (= prp (strcase (vla-get-propertyname x)))
                (progn
                    (vla-put-value x (vlax-make-variant val (vlax-variant-type (vla-get-value x))))
                    (cond (val) (t))
                )
            )
        )
        (vlax-invoke (vlax-ename->vla-object EnameBlock) 'getdynamicblockproperties)
    )
)
;
;
;
(defun LM:vl-setattributevalue ( blk tag val )
    (setq tag (strcase tag))
    (vl-some
       '(lambda ( att )
            (if (= tag (strcase (vla-get-tagstring att)))
                (progn (vla-put-textstring att val) val)
            )
        )
        (vlax-invoke blk 'getattributes)
    )
)
;
;
;
(defun LM:vl-getattributevalue ( blk tag )
    (setq tag (strcase tag))
    (vl-some '(lambda ( att ) (if (= tag (strcase (vla-get-tagstring att))) (vla-get-textstring att))) (vlax-invoke blk 'getattributes))
)
;
;
;
(defun LM:getanonymousreferences ( blk / ano def lst rec ref )
	;; Get Anonymous References  -  Lee Mac
	;; Returns the names of all anonymous references of a block.
	;; blk - [str] Block name/wildcard pattern for which to return anon. references
    (setq blk (strcase blk))
    (while (setq def (tblnext "block" (null def)))
        (if
            (and (= 1 (logand 1 (cdr (assoc 70 def))))
                (setq rec
                    (entget
                        (cdr
                            (assoc 330
                                (entget
                                    (tblobjname "block"
                                        (setq ano (cdr (assoc 2 def)))
                                    )
                                )
                            )
                        )
                    )
                )
            )
            (while
                (and
                    (not (member ano lst))
                    (setq ref (assoc 331 rec))
                )
                (if
                    (and
                        (entget (cdr ref))
                        (wcmatch (strcase (LM:al-effectivename (cdr ref))) blk)
                    )
                    (setq lst (cons ano lst))
                )
                (setq rec (cdr (member (assoc 331 rec) rec)))
            )
        )
    )
    (reverse lst)
)
;
;
;                      
(defun LM:al-effectivename ( ent / blk rep )
	;; Effective Block Name  -  Lee Mac
	;; ent - [ent] Block Reference entity
   (if (wcmatch (setq blk (cdr (assoc 2 (entget ent)))) "`**")
        (if
            (and
                (setq rep
                    (cdadr
                        (assoc -3
                            (entget
                                (cdr
                                    (assoc 330
                                        (entget
                                            (tblobjname "block" blk)
                                        )
                                    )
                                )
                               '("acdbblockrepbtag")
                            )
                        )
                    )
                )
                (setq rep (handent (cdr (assoc 1005 rep))))
            )
            (setq blk (cdr (assoc 2 (entget rep))))
        )
    )
    blk
)
;
;
;
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
			;(vla-regen doc acAllViewports)
		)
	)
)
;
;
;
(defun LM:RenameBlockReference (EnameBlock NewName / *error* abc app dbc dbx def doc dxf old prp src tmp vrs )
 
    (defun *error* ( msg )
        (if (and (= 'vla-object (type dbx)) (not (vlax-object-released-p dbx)))
            (vlax-release-object dbx)
        )
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )
    
	(setq src EnameBlock)
	(setq dxf (entget src))
	
	
    (if (= 'ename (type src))
        (progn
            (setq app (vlax-get-acad-object)
                  doc (vla-get-activedocument app)
                  src (vlax-ename->vla-object src)
                  old (vlax-get-property src (if (vlax-property-available-p src 'effectivename) 'effectivename 'name))
                  tmp 0
            )
            (setq dbx
                (vl-catch-all-apply 'vla-getinterfaceobject
                    (list app
                        (if (< (setq vrs (atoi (getvar 'acadver))) 16)
                            "objectdbx.axdbdocument"
                            (strcat "objectdbx.axdbdocument." (itoa vrs))
                        )
                    )
                )
            )
            (if (or (null dbx) (vl-catch-all-error-p dbx))
                (princ "\nUnable to interface with ObjectDBX.")
                (progn
                    (setq abc (vla-get-blocks doc)
                          dbc (vla-get-blocks dbx)
                    )
                    (vlax-invoke doc 'copyobjects (list (vla-item abc old)) dbc)
                    (if (wcmatch old "`**")
                        (vla-put-name (vla-item dbc (1- (vla-get-count dbc))) NewName)
                        (vla-put-name (vla-item dbc old) NewName)
                    )
                    (vlax-invoke dbx 'copyobjects (list (vla-item dbc NewName)) abc)
                    (vlax-release-object dbx)
                    (if
                        (and
                            (vlax-property-available-p src 'isdynamicblock)
                            (= :vlax-true (vla-get-isdynamicblock src))
                        )
                        (progn
                            (setq prp (mapcar 'vla-get-value (vlax-invoke src 'getdynamicblockproperties)))
                            (vla-put-name src NewName)
                            (mapcar
                               '(lambda ( a b )
                                    (if (/= "ORIGIN" (strcase (vla-get-propertyname a)))
                                        (vla-put-value a b)
                                    )
                                )
                                (vlax-invoke src 'getdynamicblockproperties) prp
                            )
                        )
                        (vla-put-name src NewName)
                    )
                    (if (= :vlax-true (vla-get-isxref (setq def (vla-item (vla-get-blocks doc) NewName))))
                        (vla-reload def)
                    )
                )
            )
        )
    )
)
;
;
;
(defun LM:deleteblocks (lst / 	LM:acdoc LM:catchapply LM:blockname
								doc blc lck )

	(defun LM:acdoc nil
		(cond ( acdoc ) ((setq acdoc (vla-get-activedocument (vlax-get-acad-object)))))
	)
	;
	(defun LM:catchapply ( fnc prm / rtn )
		(if (not (vl-catch-all-error-p (setq rtn (vl-catch-all-apply fnc prm))))
			(cond ( rtn ) ( t ))
		)
	)
	;
	(defun LM:blockname ( obj )
		(if (vlax-property-available-p obj 'effectivename)
			(defun LM:blockname ( obj ) (vla-get-effectivename obj))
			(defun LM:blockname ( obj ) (vla-get-name obj))
		)
		(LM:blockname obj)
	)
	;
	; MAIN
	;
	(setq doc (LM:acdoc))
    (setq blc (vla-get-blocks doc))
    (if (setq lst (mapcar 'strcase (vl-remove-if-not '(lambda ( blk ) (LM:catchapply 'vla-item (list blc blk))) lst)))
        (progn
            (vlax-for lay (vla-get-layers doc)
                (if (= :vlax-true (vla-get-lock lay))
                    (progn
                        (setq lck (cons lay lck))
                        (vla-put-lock lay :vlax-false)
                    )
                )
            )
            (vlax-for def blc
                (vlax-for obj def
                    (if (and (= "AcDbBlockReference" (vla-get-objectname obj))
                             (member (strcase (LM:blockname obj)) lst)
                        )
                        (vl-catch-all-apply 'vla-delete (list obj))
                    )
                )
            )
            (setq lst (vl-remove-if-not '(lambda ( blk ) (LM:catchapply 'vla-delete (list (vla-item blc blk)))) lst))
            (foreach lay lck (vla-put-lock lay :vlax-true))
            lst
        )
    )
)
;
;
;
(defun LM:RemovefromBlock ( doc ent )
  (vla-delete (vlax-ename->vla-object ent))
  (vla-regen doc acAllViewports)
  (princ)
)
;
;
;
(defun LM:SafearrayVariant ( datatype data )
  (vlax-make-variant
    (vlax-safearray-fill
      (vlax-make-safearray datatype (cons 0 (1- (length data)))) data
    )    
  )
)
;
;
;
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
;
;
;
(defun LM:arc->bulge ( c a1 a2 r )
    (list
        (polar c a1 r)
        (   (lambda ( a ) (/ (sin a) (cos a)))
            (/ (rem (+ pi pi (- a2 a1)) (+ pi pi)) 4.0)
        )
        (polar c a2 r)
    )
)
;
;
;
(defun LM:3p->bulge ( pt1 pt2 pt3 )
    ((lambda ( a ) (/ (sin a) (cos a))) (/ (+ (- pi (angle pt2 pt1)) (angle pt2 pt3)) 2))
)
;
;
;
(defun LM:bulgecentre ( p1 p2 b )
	;; Bulge Centre  -  Lee Mac
	;; p1 - start vertex
	;; p2 - end vertex
	;; b  - bulge
	;; Returns the centre of the arc described by the given bulge and vertices
    (polar p1
        (+ (angle p1 p2) (- (/ pi 2) (* 2 (atan b))))
        (/ (* (distance p1 p2) (1+ (* b b))) 4 b)
    )
)
;
;
;
(defun LM:bulgeradius ( p1 p2 b )
	;; Bulge Radius  -  Lee Mac
	;; p1 - start vertex
	;; p2 - end vertex
	;; b  - bulge
	;; Returns the radius of the arc described by the given bulge and vertices
    (/ (* (distance p1 p2) (1+ (* b b))) 4 (abs b))
)
;
;
;
(defun LM:Bulge->Arc ( p1 p2 b / c r )
    (setq r (/ (* (distance p1 p2) (1+ (* b b))) 4 b)
          c (polar p1 (+ (angle p1 p2) (- (/ pi 2) (* 2 (atan b)))) r)
    )
    (if (minusp b)
        (list c (angle c p2) (angle c p1) (abs r))
        (list c (angle c p1) (angle c p2) (abs r))
    )
)
;
;
;
(defun LM:ListClockwise-p ( lst )
		(minusp
			(apply '+
				(mapcar
					(function
						(lambda ( a b )
							(- (* (car b) (cadr a)) (* (car a) (cadr b)))
						)
					)
					lst (cons (last lst) lst)
				)
			)
		)
)
;
;
;
(defun LM:3pcircle ( pt1 pt2 pt3 / cen md1 md2 vc1 vc2 )
	;; 3-Point Circle  -  Lee Mac
	;; Returns the center (UCS) and radius of the circle defined by three supplied points (UCS).
	(if (setq md1 (mapcar '(lambda ( a b ) (/ (+ a b) 2.0)) pt1 pt2)
			  md2 (mapcar '(lambda ( a b ) (/ (+ a b) 2.0)) pt2 pt3)
			  vc1 (mapcar '- pt2 pt1)
			  vc2 (mapcar '- pt3 pt2)
			  cen (inters md1 (mapcar '+ md1 (list (- (cadr vc1)) (car vc1) 0))
						  md2 (mapcar '+ md2 (list (- (cadr vc2)) (car vc2) 0))
						  nil
				  )
		)
		(list cen (distance cen pt1))
	)
)
;
;
;
(defun LM:Collinear-p ( p1 p2 p3 Accuracy)
	(
		(lambda ( a b c )
			(or
				(equal (+ a b) c Accuracy)
				(equal (+ b c) a Accuracy)
				(equal (+ c a) b Accuracy)
			)
		)
		(distance p1 p2) (distance p2 p3) (distance p1 p3)
	)
)
;
;
;
(defun LM:ListCollinear-p ( lst Accuracy / Pos LstCom P1 P2 Rtn Loop )
	
    ;(or (null (cddr lst))
    ;    (and (LM:Collinear-p (car lst) (cadr lst) (caddr lst) Accuracy)
    ;         (LM:ListCollinear-p (cdr lst) Accuracy)
    ;    )
    ;)
	
	
	(setq Pos 0)
	(if (setq LstCom (CombineList lst 2))
		(setq Loop T)
	)
	(while Loop
		(if (> (distance (car (nth Pos LstCom)) (cadr (nth Pos LstCom))) 0.0)
			(progn
				(setq Loop nil)
				(setq P1 (car  (nth Pos LstCom)))
				(setq P2 (cadr (nth Pos LstCom)))
			)
			(setq Pos (1+ Pos))
		)
		(if (= Pos (length lst)) (setq Loop nil))
	)
		
	(if (and P1 p2)
		(progn
			(setq Pos 0)
			(setq Rtn T)
			(setq Loop T)
			(while Loop
				(if (not (LM:Collinear-p P1 P2 (nth Pos lst) Accuracy))
					(progn
						(setq Loop nil)
						(setq Rtn nil)
					)
				)
				(setq Pos (1+ Pos))
				(if (> (1+ Pos) (length lst)) (setq Loop nil))
			)
		)
	)
	Rtn
)
;
;
;
(defun LM:Clockwise-p ( p1 p2 p3 / Preci)

	(setq Preci 1e-8)
    (<  (-  (* (- (car  p2) (car  p1)) (- (cadr p3) (cadr p1)))
            (* (- (cadr p2) (cadr p1)) (- (car  p3) (car  p1)))
        )
        Preci
    )
)
;
;
;
;(defun LM:ListCollinear-p ( lst / vxv vx1)
;
;	(defun vxv ( u v )
;		(apply '+ (mapcar '* u v))
;	)
;	(defun vx1 ( v )
;		(   (lambda ( n ) (if (equal 0.0 n 1e-10) nil (mapcar '/ v (list n n n))))
;			(distance '(0.0 0.0 0.0) v)
;		)
;	)
;	; Returns T if all points in a list are collinear
;    (or (null (caddr lst))
;        (and
;           (equal 1.0
;                (abs
;                    (vxv
;                        (vx1 (mapcar '- (car lst) (cadr  lst)))
;                        (vx1 (mapcar '- (car lst) (caddr lst)))
;                    )
;                )
;                1e-8
;            )
;            (LM:ListCollinear-p (cdr lst))
;        )
;    )
;)
;
;
;
(defun LM:ent->pts ( ent acc / der di1 di2 enx inc lst par rad )

    (setq enx (entget ent))
    (cond
        (   (= "POINT" (cdr (assoc 0 enx)))
            (list (cdr (assoc 10 enx)))
        )
        (   (= "LINE" (cdr (assoc 0 enx)))
            (list (cdr (assoc 10 enx)) (cdr (assoc 11 enx)))
        )
        (   (wcmatch (cdr (assoc 0 enx)) "ARC,CIRCLE")
            (setq di1 0.0
                  di2 (vlax-curve-getdistatparam ent (vlax-curve-getendparam ent))
                  inc (/ di2 (1+ (fix (* acc (/ di2 (cdr (assoc 40 enx)) (+ pi pi))))))
                  di2 (- di2 1e-8)
            )
            (while (< di1 di2)
                (setq lst (cons (vlax-curve-getpointatdist ent di1) lst)
                      di1 (+ di1 inc)
                )
            )
            (reverse (if (vlax-curve-isclosed ent) lst (cons (vlax-curve-getendpoint ent) lst)))
        )
        (   (and (wcmatch (cdr (assoc 0 enx)) "*POLYLINE") (zerop (logand 80 (cdr (assoc 70 enx)))))
            (setq par 0)
            (repeat (fix (+ 1.0 1e-8 (vlax-curve-getendparam ent)))
                (cond
                    (   (not (setq der (vlax-curve-getsecondderiv ent par))))
                    (   (equal der '(0.0 0.0 0.0) 1e-8)
                        (setq lst (cons (vlax-curve-getpointatparam ent par) lst))
                    )
                    (   (setq rad (distance '(0.0 0.0) (vlax-curve-getfirstderiv ent par))
                              di1 (vlax-curve-getdistatparam ent par)
                              di2 (vlax-curve-getdistatparam ent (1+ par))
                        )
                        (setq inc (/ (- di2 di1) (1+ (fix (* acc (/ (- di2 di1) rad (+ pi pi))))))
                              di2 (- di2 1e-8)
                        )
                        (while (< di1 di2)
                            (setq lst (cons (vlax-curve-getpointatdist ent di1) lst)
                                  di1 (+ di1 inc)
                            )
                        )
                    )
                )
                (setq par (1+ par))
            )
            (setq lst (cons (vlax-curve-getendpoint ent) lst))
            (while
                (and (cdr lst)
                     (or (equal (car lst) (last lst) 1e-8)
                         (equal (car lst) (cadr lst) 1e-8)
                     )
                )
                (setq lst (cdr lst))
            )
            (reverse lst)
        )
        (   (= "ELLIPSE" (cdr (assoc 0 enx)))
            (setq di1 (vlax-curve-getdistatparam ent (vlax-curve-getstartparam ent))
                  di2 (vlax-curve-getdistatparam ent (vlax-curve-getendparam   ent))
                  di2 (- di2 1e-8)
            )
            (while (< di1 di2)
                (setq lst (cons (vlax-curve-getpointatdist ent di1) lst)
                      rad (distance '(0.0 0.0) (vlax-curve-getfirstderiv ent (vlax-curve-getparamatdist ent di1)))
                      di1 (+ di1 (/ di2 (1+ (fix (* acc (/ di2 rad (+ pi pi)))))))
                )
            )
            (reverse (if (vlax-curve-isclosed ent) lst (cons (vlax-curve-getendpoint ent) lst)))
        )
        (   (= "SPLINE" (cdr (assoc 0 enx)))
            (setq di1 (vlax-curve-getdistatparam ent (vlax-curve-getstartparam ent))
                  di2 (vlax-curve-getdistatparam ent (vlax-curve-getendparam   ent))
                  inc (/ di2 acc)
                  di2 (- di2 1e-8)
            )
            (while (< di1 di2)
                (setq lst (cons (vlax-curve-getpointatdist ent di1) lst)
                      der (/ (distance '(0.0 0.0) (vlax-curve-getsecondderiv ent (vlax-curve-getparamatdist ent di1))) inc)
                      di1 (+ di1 (if (equal 0.0 der 1e-10) inc (max (/ 1.0 der (* acc inc)) inc)))
                )
            )
            (reverse (if (vlax-curve-isclosed ent) lst (cons (vlax-curve-getendpoint ent) lst)))
        )
    )
)
;
;
;
(defun LM:PointInside-p ( PtWcs obj Shape / lst ray Rtn xrandom yrandom dividerandom)

			(if (= (type obj) 'ENAME)
				(setq obj (vlax-ename->vla-object obj))
			)
			
			(setq xrandom 	   (atof (Random_Str 9)))
			(setq yrandom 	   (+ (atof (Random_Str 9)) xrandom))
			(setq dividerandom (+ (atof (Random_Str 9)) yrandom))
			
			;(terpri)
			;(princ (/ xrandom dividerandom)) 
			;(terpri)
			;(princ (/ yrandom dividerandom))
		
			(if (= (length PtWcs) 2) (setq PtWcs (list (nth 0 PtWcs) (nth 1 PtWcs) 0.0)))
			
		
			(cond
				((equal (vlax-curve-getclosestpointto obj PtWcs) PtWcs 1e-10)
				;((equal (vlax-curve-getclosestpointto obj PtWcs) PtWcs 1e-6)
					(if Shape
						(setq Rtn T)
						(setq Rtn nil)
					)
				)
				((vlax-method-applicable-p obj 'intersectwith)
					(setq lst (vlax-invoke
									(setq ray
											(vla-addray
												(vla-objectidtoobject (vla-get-document obj) (vla-get-ownerid obj))
												(vlax-3D-point PtWcs)
												(vlax-3D-point (mapcar '+ PtWcs (list (/ xrandom dividerandom) (/ yrandom dividerandom) 0.0)))
												;(vlax-3D-point (mapcar '+ PtWcs (getvar "UCSXDIR")))
											)
									)
									'intersectwith obj acextendnone
								)
					)
					(vla-delete ray)
					(setq Rtn (= 1 (logand 1 (length lst))))
				)
			)
			
	Rtn
)
;
;
;
(defun LM:PolyCentroid ( e / l )

    ;(foreach x (setq e (entget e))
    ;    (if (= 10 (car x)) (setq l (cons (cdr x) l)))
    ;)
	
	(foreach x (LM:ent->pts e 50)
		(setq l (append l (list (list (car x) (cadr x)))))
	)
	(setq e (entget e))
	
    (
        (lambda ( a )
            (if (not (equal 0.0 a 1e-8))
                (trans
                    (mapcar '/
                        (apply 'mapcar
                            (cons '+
                                (mapcar
                                    (function
                                        (lambda ( a b )
                                            (
                                                (lambda ( m )
                                                    (mapcar
                                                        (function
                                                            (lambda ( c d ) (* (+ c d) m))
                                                        )
                                                        a b
                                                    )
                                                )
                                                (- (* (car a) (cadr b)) (* (car b) (cadr a)))
                                            )
                                        )
                                    )
                                    l (cons (last l) l)
                                )
                            )
                        )
                        (list a a)
                    )
                    (cdr (assoc 210 e)) 0
                )
            )
        )
        (* 3.0
            (apply '+
                (mapcar
                    (function
                        (lambda ( a b )
                            (- (* (car a) (cadr b)) (* (car b) (cadr a)))
                        )
                    )
                    l (cons (last l) l)
                )
            )
        )
    )
)
;
;
;
(defun LM:lwvertices (e / itm Rtn)

	(if (setq e (member (assoc 10 e) e))
		(cons
			(list
				(assoc 10 e)
				(assoc 40 e)
				(assoc 41 e)
				(assoc 42 e)
			)
			(LM:lwvertices (cdr e))
		)
	)
)
;
;
;
(defun LM:InfoExpertPoly (EnameShape / seg enx lst p q b)

	(if EnameShape
		(progn
			(setq seg 0)
            (setq enx (entget EnameShape))
            (setq lst (LM:lwvertices enx))
            (setq lst
                (cons
                    (append '("SEG." "(START X Y)" "(END X Y)" "WIDTH 1" "WIDTH 2" "LENGTH")
                        (if (setq flg (vl-some '(lambda ( x ) (not (zerop (cdr (assoc 42 x))))) lst))
                           '("(CENTRE X Y)" "RADIUS")
                        )
                    )
                    (mapcar
                        (function
                            (lambda ( l1 l2 / b p q )
                                (setq p (cdr (assoc 10 l1))
                                      q (cdr (assoc 10 l2))
                                      b (cdr (assoc 42 l1))
                                )
                                (append
                                    (list (itoa (setq seg (1+ seg))))
                                    ;(mapcar 'rtos p) 
                                    ;(mapcar 'rtos q)
									(list p)
									(list q)
                                    (list
                                        ;(rtos (cdr (assoc 40 l1)))
                                        ;(rtos (cdr (assoc 41 l1)))
										(cdr (assoc 40 l1))
										(cdr (assoc 41 l1))
                                    )
                                    (if (zerop b)
                                        ;(cons (rtos (distance p q)) (if flg '("" "" "")))
										(cons (distance p q) (if flg (list nil nil)))
                                        (append
                                            ;(list (rtos (abs (* (LM:bulgeradius p q b) (atan b) 4))))
											(list (abs (* (LM:bulgeradius p q b) (atan b) 4)))
                                            ;(mapcar 'rtos (LM:bulgecentre p q b))
											(list  (LM:bulgecentre p q b))
                                            ;(list (rtos (LM:bulgeradius p q b)))
											(list (LM:bulgeradius p q b))
                                        )
                                    )
                                )
                            )
                        )
                        lst
                        (if (= 1 (logand 1 (cdr (assoc 70 enx))))
                            (append (cdr lst) (list (car lst)))
                            (cdr lst)
                        )
                    )
                )
			)
        )
	)
)
;
;
;
(defun LM:Dec->Base ( n b )
    (if (< n b)
        (chr (+ n (if (< n 10) 48 55)))
        (strcat (LM:Dec->Base (/ n b) b) (LM:Dec->Base (rem n b) b))
    )
)
;
;
;
(defun LM:ReadBinaryStream ( file / adostream result )
    (if
        (and
            (setq file (findfile file))
            (setq adostream (vlax-create-object "ADODB.Stream"))
        )
        (progn
            (setq result
                (vl-catch-all-apply
                    (function
                        (lambda nil
                            (vlax-put-property  adostream 'type 1)
                            (vlax-invoke-method adostream 'open nil nil nil nil nil)
                            (vlax-invoke-method adostream 'loadfromfile file)
                            (vlax-put-property  adostream 'position 0)
                            (setq result (vlax-invoke-method adostream 'read -1))
                            (vlax-invoke-method adostream 'close)
                            result
                        )
                    )
                )
            )
            (vlax-release-object adostream)
            (if (not (vl-catch-all-error-p result))
                (vlax-safearray->list (vlax-variant-value result))
            )
        )
    )
)
;
;
;
(defun LM:OrthoPoint ( base point )
    (if (zerop (getvar 'ORTHOMODE))
        point
        (apply 'polar
            (cons base
                (
                    (lambda ( n / a x z )
                        (setq x (- (car   (trans point 0 n)) (car   (trans base 0 n)))
                              z (- (caddr (trans point 0 n)) (caddr (trans base 0 n)))
                              a (angle '(0. 0. 0.) n)
                        )
                        (if (< (abs z) (abs x))
                            (list (+ a (/ pi 2.)) x)
                            (list a z)
                        )
                    )
                    (trans (getvar 'UCSXDIR) 0 1)
                )
            )
        )
    )
)
;
;
;
(defun LM:PolyOutline ( ent / _vertices lst )

	;;------------------=={ LWPolyline Outline }==----------------;;
	;;                                                            ;;
	;;  Creates an LWPolyline surrounding the boundary of an      ;;
	;;  LWPolyline with varying widths. Currently restricted to   ;;
	;;  LWPolyline vertices with zero bulge.                      ;;
	;;------------------------------------------------------------;;
	;;  Author: Lee Mac, Copyright © 2011 - www.lee-mac.com       ;;
	;;------------------------------------------------------------;;
	;;  Arguments:                                                ;;
	;;  ent - Entity name of LWPolyline                           ;;
	;;------------------------------------------------------------;;
	;;  Returns:  List of Entity name(s) of outline LWPolyline(s) ;;
	;;------------------------------------------------------------;; 

    (defun _vertices ( e )
        (if (setq e (member (assoc 10 e) e))
            (cons
                (list
                    (cdr (assoc 10 e))
                    (cdr (assoc 40 e))
                    (cdr (assoc 41 e))
                )
                (_vertices (cdr e))
            )
        )
    )
 
    (setq
        ent (entget ent)
        lst (_vertices ent)
        lst (apply 'mapcar
                (cons
                    (function
                        (lambda ( a b )
                            (
                                (lambda ( c )
                                    (mapcar
                                        (function
                                            (lambda ( d )
                                                (mapcar
                                                    (function
                                                        (lambda ( e f )
                                                            (mapcar 'd (car e)
                                                                (mapcar
                                                                    (function
                                                                        (lambda ( g ) (* g (/ f 2.0)))
                                                                    )
                                                                    c
                                                                )
                                                            )
                                                        )
                                                    )
                                                    (list a b) (cdr a)
                                                )
                                            )
                                        )
                                        (list + -)
                                    )
                                )
                                (
                                    (lambda ( v / n )
                                        (setq v (list (- (cadr v)) (car v) 0.0)
                                              n (distance '(0. 0.) v)
                                        )
                                        (if (equal 0.0 n 1e-14)
                                            (list  0.0 0.0 0.0)
                                            (mapcar '/ v (list n n n))
                                        )
                                    )
                                    (mapcar '- (car a) (car b))
                                )
                            )
                        )
                    )
                    (if (= 1 (logand 1 (cdr (assoc 70 ent))))
                        (list
                            (cons (last lst) lst)
                            (append lst (list (car lst)))
                        )
                        (list lst (cdr lst))
                    )
                )
            )
        lst (
                (lambda ( a )
                    (if (zerop (logand 1 (cdr (assoc 70 ent))))
                        (append
                            (list (mapcar 'car  (car  lst)))
                            a
                            (list (mapcar 'cadr (last lst)))
                        )
                        a
                    )
                )
                (apply 'append
                    (mapcar
                        (function
                            (lambda ( a b / c )
                                (if
                                    (setq c
                                        (apply 'append
                                            (mapcar
                                                (function
                                                    (lambda ( d e / f )
                                                        (if (setq f (inters (car d) (cadr d) (car e) (cadr e) nil))
                                                            (list f)
                                                        )
                                                    )
                                                )
                                                a b
                                            )
                                        )
                                    )
                                    (list c)
                                )
                            )
                        )
                        lst (cdr lst)
                    )
                )
            )
    )
    (mapcar
        (function
            (lambda ( a )
                (entmakex
                    (append
                        (subst (cons 43 0.0) (assoc 43 ent)
                            (subst (cons 70 (logior 1 (cdr (assoc 70 ent)))) (assoc 70 ent)
                                (subst (cons 90 (length a)) (assoc 90 ent)
                                    (reverse (member (assoc 39 ent) (reverse ent)))
                                )
                            )
                        )
                        (mapcar '(lambda ( p ) (cons 10 p)) a) (list (assoc 210 ent))
                    )
                )
            )
        )
        (
            (lambda ( a b )
                (if (zerop (logand 1 (cdr (assoc 70 ent))))
                    (list
                        (append
                            (if (equal (car a) (last b) 1e-8)
                                (setq a (cdr a))
                                a
                            )
                            (if (equal (car b) (last a) 1e-8)
                                (setq b (cdr b))
                                b
                            )
                        )
                    )
                    (list a b)
                )
            )
            (mapcar 'car lst) (reverse (mapcar 'cadr lst))
        )
    )
)
;
;
;
(defun LM:burst (SsgetList nst / *error* Rtn)

    (defun *error* ( msg )
        (LM:endundo (LM:acdoc))
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )
    

	(Open_Block_Entity)
	(LM:burstsel SsgetList nst)
	(setq Rtn (Close_Block_Entity))

	Rtn
)
;
;
;
(defun LM:burstsel ( sel nst / idx )
    (if (= 'pickset (type sel))
        (repeat (setq idx (sslength sel))
            (LM:burstobject (vlax-ename->vla-object (ssname sel (setq idx (1- idx)))) nst)
        )
    )
)
;
;
;
(defun LM:burstobject ( obj nst / cmd col ent err lay lin lst qaf tmp )
    (if
        (and
            (= "AcDbBlockReference" (vla-get-objectname obj))
            (not (vlax-property-available-p obj 'path))
            (vlax-write-enabled-p  obj)
            (or (and (LM:usblock-p obj)
                     (not (vl-catch-all-error-p (setq err (vl-catch-all-apply 'vlax-invoke (list obj 'explode)))))
                     (setq lst err)
                )
                (progn
                    (setq tmp (vla-copy obj)
                          ent (LM:entlast)
                          cmd (getvar 'cmdecho)
                          qaf (getvar 'qaflags)
                    )
                    (setvar 'cmdecho 0)
                    (setvar 'qaflags 0)
                    (vl-cmdf "_.explode" (vlax-vla-object->ename tmp))
                    (setvar 'qaflags qaf)
                    (setvar 'cmdecho cmd)
                    (while (setq ent (entnext ent))
                        (setq lst (cons (vlax-ename->vla-object ent) lst))
                    )
                    lst
                )
            )
        )
        (progn
            (setq lay (vla-get-layer    obj)
                  col (vla-get-color    obj)
                  lin (vla-get-linetype obj)
            )
            (foreach att (vlax-invoke obj 'getattributes)
                (if (vlax-write-enabled-p att)
                    (progn
                        (if (= "0" (vla-get-layer att))
                            (vla-put-layer att lay)
                        )
                        (if (= acbyblock (vla-get-color att))
                            (vla-put-color att col)
                        )
                        (if (= "byblock" (strcase (vla-get-linetype att) t))
                            (vla-put-linetype att lin)
                        )
                    )
                )
                (if
                    (and
                        (= :vlax-false (vla-get-invisible att))
                        (= :vlax-true  (vla-get-visible   att))
                    )
                    (   (if (and (vlax-property-available-p att 'mtextattribute) (= :vlax-true (vla-get-mtextattribute att)))
                            LM:burst:matt2mtext 
                            LM:burst:att2text
                        )
                        (entget (vlax-vla-object->ename att))
                    )
                )
            )
            (foreach new lst
                (cond
                    (   (not (vlax-write-enabled-p new)))
                    (   (= :vlax-false (vla-get-visible new))
                        (vla-delete new)
                    )
                    (   t
                        (if (= "0" (vla-get-layer new))
                            (vla-put-layer new lay)
                        )
                        (if (= acbyblock (vla-get-color new))
                            (vla-put-color new col)
                        )
                        (if (= "byblock" (strcase (vla-get-linetype new) t))
                            (vla-put-linetype new lin)
                        )
                        (if (= "AcDbAttributeDefinition" (vla-get-objectname new))
                            (progn
                                (if
                                    (and
                                        (= :vlax-true  (vla-get-constant  new))
                                        (= :vlax-false (vla-get-invisible new))
                                    )
                                    (   (if (and (vlax-property-available-p new 'mtextattribute) (= :vlax-true (vla-get-mtextattribute new)))
                                            LM:burst:matt2mtext 
                                            LM:burst:att2text
                                        )
                                        (entget (vlax-vla-object->ename new))
                                    )
                                )
                                (vla-delete new)
                            )
                            (if nst (LM:burstobject new nst))
                        )
                    )
                )
            )
            (vla-delete obj)
        )
    )
)
;
;
;
(defun LM:burst:removepairs ( itm lst )
    (vl-remove-if '(lambda ( x ) (member (car x) itm)) lst)
)
;
;
;
(defun LM:burst:remove1stpairs ( itm lst )
    (vl-remove-if '(lambda ( x ) (if (member (car x) itm) (progn (setq itm (vl-remove (car x) itm)) t))) lst)
)
;
;
;
(defun LM:burst:att2text ( enx )
    (entmakex
        (append '((0 . "TEXT"))
            (LM:burst:removepairs '(000 002 003 070 074 100 280 440)
                (subst (cons 73 (cdr (assoc 74 enx))) (assoc 74 enx) enx)
            )
        )
    )
)
;
;
;
(defun LM:burst:matt2mtext ( enx )
    (entmakex
        (append '((0 . "MTEXT") (100 . "AcDbEntity") (100 . "AcDbMText"))
            (LM:burst:remove1stpairs
                (if (= "ATTDEF" (cdr (assoc 0 enx)))
                   '(001 003 007 010 040 041 050 071 072 073 210)
                   '(001 007 010 040 041 050 071 072 073 210)
                )
                (LM:burst:removepairs '(000 002 011 042 043 051 070 074 100 101 102 280 330 360 440) enx)
            )
            (list (assoc 011 (reverse enx)))
        )
    )
)
;
;
;
(defun LM:usblock-p ( obj / s )
    (if (vlax-property-available-p obj 'xeffectivescalefactor)
        (setq s "effectivescalefactor")
        (setq s "scalefactor")
    )
    (eval
        (list 'defun 'LM:usblock-p '( obj )
            (list 'and
                (list 'equal
                    (list 'abs (list 'vlax-get-property 'obj (strcat "x" s)))
                    (list 'abs (list 'vlax-get-property 'obj (strcat "y" s)))
                    1e-8
                )
                (list 'equal
                    (list 'abs (list 'vlax-get-property 'obj (strcat "x" s)))
                    (list 'abs (list 'vlax-get-property 'obj (strcat "z" s)))
                    1e-8
                )
            )
        )
    )
    (LM:usblock-p obj)
)
;
;
;
(defun LM:entlast ( / ent tmp )
    (setq ent (entlast))
    (while (setq tmp (entnext ent)) (setq ent tmp))
    ent
)
;
;
;
(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)
;
;
;
(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)
;
;
;
(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)
;
;
;
;;--------------------=={ LISP Styler }==---------------------;;
;;                                                            ;;
;;  A generic styling engine allowing the user to add         ;;
;;  specified styling tags to various code elements of        ;;
;;  a LISP file.                                              ;;
;;                                                            ;;
;;  Output file is saved to the same directory as supplied    ;;
;;  input file.                                               ;;
;;------------------------------------------------------------;;
;;  Author: Lee Mac, Copyright © 2011 - www.lee-mac.com       ;;
;;------------------------------------------------------------;;
;;  Arguments:                                                ;;
;;  file   - filename of lsp file to convert                  ;;
;;  styles - list of styling tags (format described below)    ;;
;;  extn   - extension of the output file                     ;;
;;  <>     - Boolean flag determining whether < & > are       ;;
;;           converted to &lt; and &gt; in the output file    ;;
;;------------------------------------------------------------;;
;(LM:LISPStyler "C:\\EasyCutBeta\\Test\\Test.lsp" 
;'(
;   ("[code]"            "[/code]" )  ;; Container
;   ("[color=DARKRED]"   "[/color]")  ;; Quotes/Dots
;   ("[color=RED]"       "[/color]")  ;; Brackets
;   ("[color=#990099]"   "[/color]")  ;; Multiline Comments
;   ("[color=#990099]"   "[/color]")  ;; Single Comments
;   ("[color=#a52a2a]"   "[/color]")  ;; Strings
;   ("[color=BLUE]"      "[/color]")  ;; Protected Symbols
;   ("[color=#009900]"   "[/color]")  ;; Integers
;   ("[color=#009999]"   "[/color]")  ;; Reals
; )
;".html" T)
(defun LM:LISPStyler  (

						;; -- Arguments --
					   
						file    ;; - Filename of LISP file to Convert

						styles  ;; - List of Styles tags for each code item

						extn    ;; - Extension for resultant file (e.g. ".html")

						<>      ;; - T if '<' and '>' are to be replaced with &lt; &gt;

						/

						;; -- Subfunctions --

						*error*
						_read
						_fix<>
						_PadBetween

						;; -- Local Variables --

						_bracket
						_bracketl
						_container
						_containerl
						_integer
						_integerl
						_mcomment
						_mcommentl
						_protected
						_protectedl
						_quote
						_quotel
						_real
						_reall
						_scomment
						_scommentl
						_string
						_stringl
						a
						exceptions
						fl
						i
						ichrs
						l
						lines
						ochrs
						of
						outfile
						s
						str
						w
						wf
						x
					   
					  )
  
  ;;---------------------------------------------------------------;;
  ;; Code based on an algorithm concocted by the genius            ;;
  ;; of ElpanovEvgeniy. Rewritten & modified by Lee Mac 2011 to    ;;
  ;; include line & character reports, and to enable the user to   ;;
  ;; use custom styles.                                            ;;
  ;;                                                               ;;
  ;;---------------------------------------------------------------;;
  ;; Notes on Function Arguments:                                  ;;
  ;;---------------------------------------------------------------;;
  ;;                                                               ;;
  ;;---------------------------------------------------------------;;
  ;; file                                                          ;;
  ;;---------------------------------------------------------------;;
  ;; Full filename of LISP file to convert, forward slashes or     ;;
  ;; double-backslashes may be used in filename.                   ;;
  ;;                                                               ;;
  ;;---------------------------------------------------------------;;
  ;; styles                                                        ;;
  ;;---------------------------------------------------------------;;
  ;; List of tags to enclose various code items, list must be in   ;;
  ;; the following form:                                           ;;
  ;;                                                               ;;
  ;; (                                                             ;;
  ;;   (<container open> <container close>)   e.g. (<pre> </pre>)  ;;
  ;;   (<quote     open> <quote     close>)   quotes/dots          ;;
  ;;   (<bracket   open> <bracket   close>)   parentheses          ;;
  ;;   (<mcomment  open> <mcomment  close>)   multiline comments   ;;
  ;;   (<scomment  open> <scomment  close>)   single comments      ;;
  ;;   (<string    open> <string    close>)   strings              ;;
  ;;   (<protected open> <protected close>)   protected symbols    ;;
  ;;   (<integer   open> <integer   close>)   integers             ;;
  ;;   (<real      open> <real      close>)   reals                ;;
  ;; )                                                             ;;
  ;;                                                               ;;
  ;; If no tag is required for an item, the entry must still be    ;;
  ;; present, as:                                                  ;;
  ;;                                                               ;;
  ;;   ("" "")                                                     ;;
  ;;                                                               ;;
  ;;---------------------------------------------------------------;;
  ;; extn                                                          ;;
  ;;---------------------------------------------------------------;;
  ;; Extension for resultant file - dot must be included.          ;;
  ;;                                                               ;;
  ;; Example:   ".html"                                            ;;
  ;;                                                               ;;
  ;;---------------------------------------------------------------;;
  ;; <>                                                            ;;
  ;;---------------------------------------------------------------;;
  ;; Boolean flag to determine whether the characters '<' and '>'  ;;
  ;; are to be replaced with &lt; and &gt;                         ;;
  ;;                                                               ;;
  ;; If T, '<' and '>' are replaced.                               ;;
  ;;                                                               ;;
  ;;---------------------------------------------------------------;;

  ;;---------------------------------------------------------------;;
  ;; Note that by the nature of the algorithm to determine the     ;;
  ;; type of code item, any user-defined symbols in the current    ;;
  ;; namespace will be interpreted as the datatype to which they   ;;
  ;; point.                                                        ;;
  ;;---------------------------------------------------------------;;
  ;; For this reason, a list of exceptions is required to avoid    ;;
  ;; the incorrect styling of symbols appearing as functions &     ;;
  ;; variables in this program or indeed any other defined         ;;
  ;; functions or global variables.                                ;;
  ;;---------------------------------------------------------------;;
  ;; This list may be extended to suit the user's environment.     ;;
  ;;---------------------------------------------------------------;;

	(setq exceptions

		;; Subfunctions, Arguments & Variables in this Program

		'("*error*"    "_read"
		  "_fix<>"     "_padbetween"

		  "file"       "styles"
		  "extn"       "<>"

		  "_bracket"   "_bracketl"
		  "_container" "_containerl"
		  "_integer"   "_integerl"
		  "_mcomment"  "_mcommentl"
		  "_protected" "_protectedl"
		  "_quote"     "_quotel"
		  "_real"      "_reall"
		  "_scomment"  "_scommentl"
		  "_string"    "_stringl"
		  "a"          "exceptions"
		  "fl"         "i"
		  "ichrs"      "l"
		  "lines"      "ochrs"
		  "of"         "outfile"
		  "s"          "str"
		  "w"          "wf"
		  "x"

		  "lm:lispstyler"
		 )
	)

	;;---------------------------------------------------------------;;

	;; Error Handler

	;;---------------------------------------------------------------;;

	(defun *error* ( msg )
		(mapcar
			(function
				(lambda ( sym ) (and sym (close sym)))
			)
			(list of wf)
		)
    
		(if
			(and msg
				(not
					(member (strcase msg)
					'(
						"CONSOLE BREAK"
						"FUNCTION CANCELLED"
						"QUIT / EXIT ABORT"
					)
				)
				)
			)
			(princ (strcat "\n** Error: " msg " **"))
		)
		(princ)
	)

	;;---------------------------------------------------------------;;

	;; Attempts to read file with supplied filename, returns a list
	;; of strings in the file.

	;;---------------------------------------------------------------;;

	(defun _read ( file / of l )
		(cond
			(
				(setq of (open file "r"))
				(while (car (setq l (cons (read-line of) l))))

				(setq of (close of)) (reverse (cdr l))
			)
		)
	)
	;;---------------------------------------------------------------;;

	;; Substitutes all instances of '<' and '>' with &lt; and &gt; in
	;; supplied string.

	;;---------------------------------------------------------------;;
  
	(defun _fix<> ( string / _stringsubst )

		(defun _stringsubst ( new old string / i nl )
			(setq i 0 nl (strlen new))

			(while (and (< i (strlen string)) (setq i (vl-string-search old string i)))
				(setq string (vl-string-subst new old string i) i (+ i nl))
			)
			string
		)
    
		(_stringsubst "&lt;" "<" (_stringsubst "&gt;" ">" string))
	)

	;;---------------------------------------------------------------;;

	;; String padding function - provides some eye-candy for the
	;; output report.

	;;---------------------------------------------------------------;;

	(defun _PadBetween ( s1 s2 ch ln )
		(if (< (+ (strlen s1) (strlen s2)) ln)
			(_PadBetween (strcat s1 ch) s2 ch ln)
			(strcat s1 s2)
		)
	)

	;;---------------------------------------------------------------;;

	;;---------------------------------------------------------------;;
	;;                        Main Function                          ;;
	;;---------------------------------------------------------------;;

	;;---------------------------------------------------------------;;

	(mapcar 'set
		'(	_container _quote  		_bracket 	_mcomment _scomment  
			_string    _protected	_integer	_real
		)
		styles
	)

	(mapcar 'set
		'(	_containerL	_quoteL		_bracketL		_mcommentL
			_scommentL	_stringL	_protectedL		_integerL	_realL
		)
		(mapcar '(lambda ( x ) (mapcar 'strlen x)) styles)
	)

  ;;---------------------------------------------------------------;;

	(cond
		(
			(not
				(and (setq l (_read file))
					(setq wf (open (setq outfile (strcat (vl-string-translate "/" "\\" (vl-filename-directory file))
															"\\" (vl-filename-base file) extn)) "w")
					)
				)
			)
			(princ "\n** File Error **")
		)
		(t

			(setq 	lines (length l)
					ochrs 0
					ichrs (apply '+ (mapcar 'strlen l))
			)

			(setq s (car l) l (cdr l) str "" i 0)

			(write-line "<style>"                                   wf)
			(write-line "pre.small {"                               wf)
			(write-line "           line-height:0.6;"               wf)
			(write-line "           background-color:#1a1a1ad1;"    wf)
			(write-line "           color:silver;"                  wf)
			(write-line "          }"                               wf)
			(write-line "</style>"                                  wf)

			(write-line (car _container) wf) 
			(write-line "<ol>" wf) 
      
			(setq ochrs (+ ochrs (car _containerL)))

			(while s
				(cond
					((= (setq a (ascii s)) 0) ; Empty String
						(write-line (strcat "<li>" str "</li>") wf)
			            (setq s (car l) l (cdr l) str "")
					)
					((or (= a 32) (= a 9)) ; Space & Tab
						(setq str (strcat str (chr a)) s (substr s 2) ochrs (1+ ochrs) i 0)
					)
					((or (= a 39) (= a 46)) ; ' or .
						(setq str (strcat str (car _quote) (chr a)) s (substr s 2) ochrs (+ ochrs (car _quoteL) 1))
						(while (= (ascii s) 39)
							(setq str (strcat str (substr s 1 1)) s (substr s 2) ochrs (1+ ochrs))
						)
						(setq str (strcat str (cadr _quote)) ochrs (+ ochrs (cadr _quoteL)))
					)
					((< 38 a 42) ; Brackets
						(setq str (strcat str (car _bracket) (chr a)) ochrs (+ ochrs (car _bracketL) 1) s (substr s 2))
						(while (< 39 (ascii s) 42)
							(setq str (strcat str (substr s 1 1)) s (substr s 2) ochrs (1+ ochrs))
						)
						(setq str (strcat str (cadr _bracket)) ochrs (+ ochrs (cadr _bracketL)))
					)
					((= a 59) ; Single or Multiline Comments
						(if (eq (substr s 2 1) "|")
							(progn
								(setq str (strcat str (car _mcomment)) ochrs (+ ochrs (car _mcommentL)))
								(while (and s (not (setq i (vl-string-search "|;" s))))
									(write-line (strcat "<li>" str (if <> (_fix<> s) s) "</li>") wf) 
									(setq ochrs (+ ochrs (strlen (strcat str s))) s (car l) l (cdr l) str "")
								)

								(setq str (strcat str (substr s 1 (+ 2 i)) (cadr _mcomment)) ochrs (+ ochrs (+ 2 i) (cadr _mcommentL)))
                                (setq s (substr s (+ 3 i)))
							)
							(progn
								(write-line (strcat "<li>" str (car _scomment) (if <> (_fix<> s) s) (cadr _scomment) "</li>")  wf)
								(setq ochrs (+ ochrs (car _scommentL) (strlen s) (cadr _scommentL)) s (car l) l (cdr l) str "")
							)
						)
					)
					((= a 34) ; Strings
						(setq str (strcat str (car _string)) ochrs (+ ochrs (car _stringL)) i 0 fl t)
						(while (and s fl)
							(while
								(and s (setq i (vl-string-search "\"" s (setq i (1+ i))))
									(not
										(or
											(zerop i)
												(not (eq (substr s i 1) "\\"))
												(eq (substr s (1- i) 2) "\\\\")
										)				
									)
								)
							)

							(if (null i)
								(setq str   (strcat str (if <> (_fix<> s) s) "\n") ochrs (+ ochrs (strlen s)) s (car l) l (cdr l) i -1)
								(setq str   (strcat str (if <> (_fix<> (substr s 1 (1+ i))) (substr s 1 (1+ i))) (cadr _string))
									  ochrs (+ ochrs (1+ i) (cadr _stringL))
									  s (substr s (+ 2 i)) fl nil i 0
								)
							)
						)
					)
					(
						(progn
							(setq i
								(apply (function min)
									(vl-remove-if (function null)
										(cons (strlen s)
											(mapcar
												(function
													(lambda ( pat )
														(vl-string-search pat s)
													)
												)
												'("(" ")" " " "\t" "'" ";" "\"")
											)
										)
									)
								)
								w (substr s 1 i)
								s (substr s (1+ i))
							)
							(or
								(eq (setq a (type (eval (read w)))) 'SUBR)
								(vl-position (strcase w) '("NIL" "T" "PI"))
								(and a (eq (type (read w)) 'SYM)
									(not
										(vl-position (strcase w t) exceptions)
									)
								)
							)
						)

						(setq str   (strcat str (car _protected) (if <> (_fix<> w) w) (cadr _protected))
							ochrs (+ ochrs (car _protectedL) i (cadr _protectedL))
						)
					)
					((or (eq a 'USUBR) (vl-position (strcase w t) exceptions))
						(setq str (strcat str (if <> (_fix<> w) w)) ochrs (+ ochrs i))
					)
					((eq a 'INT)
						(setq str (strcat str (car _integer) w (cadr _integer)) ochrs (+ ochrs (car _integerL) i (cadr _integerL)))
					)
					((eq a 'REAL)
						(setq str (strcat str (car _real) w (cadr _real)) ochrs (+ ochrs (car _realL) i (cadr _realL)))
					)
					(t
						(setq str (strcat str (if <> (_fix<> w) w)) ochrs (+ ochrs i))
					)
				)
				(if (and s (= (ascii s) 0))
					(progn
						(write-line (strcat "<li>" str "</li>") wf)
						(setq s (car l) l (cdr l) str "" i 0)
					)
				)
			)
			(write-line "</ol>" wf)
			(write-line (cadr _container) wf) 
	  
			(setq wf (close wf) ochrs (+ ochrs (cadr _containerL)))

			(princ
				(strcat
					(_PadBetween "\n" "" "-" 40)
					"\nConversion Report: Successful"
					(_PadBetween "\n" "" "-" 40)
					"\nInput File Statistics"
					(_PadBetween "\n" "" "-" 40)
					(_PadBetween "\nLines"      (itoa lines) "." 35) 
					(_PadBetween "\nCharacters" (itoa ichrs) "." 35)
					(_PadBetween "\n" "" "-" 40)
					"\nOutput File Statistics"
					(_PadBetween "\n" "" "-" 40)
					(_PadBetween "\nLines"      (itoa (+ 2 lines)) "." 35)
					(_PadBetween "\nCharacters" (itoa      ochrs)  "." 35)
					(_PadBetween "\n" "" "-" 40)
					"\n"
				)
			)
		)
	)
	outfile
)
;;------------------------------------------------------------;;
;;  Example calling Functions                                 ;;
;;------------------------------------------------------------;;

;; LISP 2 BBCode (for use in forums)

(defun c:lsp2bbc ( / file )
  ;; © Lee Mac 2011
	(foreach itm (LM:getfiles "Seleziona file" CncPathEasyCut$ "lsp")
		(setq Rtn (LM:LISPStyler itm
									'(
										("[code]"            "[/code]" )  ;; Container
										("[color=DARKRED]"   "[/color]")  ;; Quotes/Dots
										("[color=RED]"       "[/color]")  ;; Brackets
										("[color=#990099]"   "[/color]")  ;; Multiline Comments
										("[color=#990099]"   "[/color]")  ;; Single Comments
										("[color=#a52a2a]"   "[/color]")  ;; Strings
										("[color=BLUE]"      "[/color]")  ;; Protected Symbols
										("[color=#009900]"   "[/color]")  ;; Integers
										("[color=#009999]"   "[/color]")  ;; Reals
									)
								".bbc"
								nil
				)
		)      
	)
)

;; LISP 2 HTML - for use on websites.

(defun c:lsp2html ( / itm Rtn)
  ;; © Lee Mac 2011
	(foreach itm (LM:getfiles "Seleziona file" CncPathEasyCut$ "lsp")
		(setq Rtn (LM:LISPStyler itm 
				'(
					("<pre class=\"small\">" "</pre>") 			;; Container
					("<font color=\"#e33333\">" "</font>")   	;; Quotes/Dots
					("<font color=\"red\">" "</font>")     		;; Brackets
					("<font color=\"#00ff00\">" "</font>")      ;; Multiline Comments
					("<font color=\"#00ff00\">" "</font>")     	;; Single Comments
					("<font color=\"cyan\">" "</font>")  	    ;; Strings
					("<font color=\"#0099ff\">" "</font>")     	;; Protected Symbols
					("<font color=\"orange\">" "</font>")     	;; Integers
					("<font color=\"#e33333\">" "</font>")   	;; Reals
				)
			
				;'(
				;	("<pre class=\"small\">" "</pre>") 			;; Container
				;	("<font color=\"black\">" "</font>")   		;; Quotes/Dots
				;	("<font color=\"red\">" "</font>")     		;; Brackets
				;	("<font color=\"gray\">" "</font>")    		;; Multiline Comments
				;	("<font color=\"gray\">" "</font>")     	;; Single Comments
				;	("<font color=\"DarkOrchid\">" "</font>")  	;; Strings
				;	("<font color=\"blue\">" "</font>")     	;; Protected Symbols
				;	("<font color=\"green\">" "</font>")     	;; Integers
				;	("<font color=\"darkgreen\">" "</font>")   	;; Reals
				;)
			
				;'(
				;  ("<pre>"                 "</pre>" )  ;; Container
				;  ("<span class=\"quot\">" "</span>")  ;; Quotes/Dots
				;  ("<span class=\"brkt\">" "</span>")  ;; Brackets
				;  ("<span class=\"cmt\">"  "</span>")  ;; Multiline Comments
				;  ("<span class=\"cmt\">"  "</span>")  ;; Single Comments
				;  ("<span class=\"str\">"  "</span>")  ;; Strings
				;  ("<span class=\"func\">" "</span>")  ;; Protected Symbols
				;  ("<span class=\"int\">"  "</span>")  ;; Integers
				;  ("<span class=\"rea\">"  "</span>")  ;; Reals
				;)
				".html"
				T
			)
		)
		(if (findfile Rtn) (DefaultBrowser Rtn))
	)
)

;;------------------------------------------------------------;;
;;                       End of File                          ;;
;;------------------------------------------------------------;;
(defun LM:ConvexHull ( lst / ch p0 )
    (cond
        (   (< (length lst) 4) lst)
        (   (setq p0 (car lst))
            (foreach p1 (cdr lst)
                (if (or (< (cadr p1) (cadr p0))
                        (and (= (cadr p1) (cadr p0)) (< (car p1) (car p0)))
                    )
                    (setq p0 p1)
                )
            )
            (setq lst (vl-remove p0 lst))
            (setq lst (append (list p0) lst))
            (setq lst
                (vl-sort lst
                    (function
                        (lambda ( a b / c d )
                              (if (or (equal (setq c (angle p0 a)) (setq d (angle p0 b)) 1e-8) (and (or (equal c 0.0 1e-8) (equal c (* 2 pi) 1e-8)) (or (equal d 0.0 1e-8) (equal d (* 2 pi) 1e-8))))
                                  (< (distance (list (car p0) (cadr p0)) a) (distance (list (car p0) (cadr p0)) b))
                                  (< c d)
                              )
                        )
                    )
                )
            )
            (setq ch (list (cadr lst) (car lst)))
            (foreach pt (cddr lst)
                (setq ch (cons pt ch))
                (while (and (caddr ch) (LM:Clockwise-p (caddr ch) (cadr ch) pt))
                    (setq ch (cons pt (cddr ch)))
                )
            )
            (reverse ch)
        )
    )
)
;
;(defun LM:ConvexHull ( lst / ch p0 )
;    (cond
;        (   (< (length lst) 4) lst)
;        (   (setq p0 (car lst))
;            (foreach p1 (cdr lst)
;                (if (or (< (cadr p1) (cadr p0))
;                        (and (equal (cadr p1) (cadr p0) 1e-8) (< (car p1) (car p0)))
;                    )
;                    (setq p0 p1)
;                )
;            )
;            (setq lst
;                (vl-sort lst
;                    (function
;                        (lambda ( a b / c d )
;                            (if (equal (setq c (angle p0 a)) (setq d (angle p0 b)) 1e-8)
;                               (< (distance p0 a) (distance p0 b))
;                                (< c d)
;                            )
;                        )
;                    )
;                )
;            )
;            (setq ch (list (caddr lst) (cadr lst) (car lst)))
;            (foreach pt (cdddr lst)
;                (setq ch (cons pt ch))
;                (while (and (caddr ch) (LM:Clockwise-p (caddr ch) (cadr ch) pt))
;                    (setq ch (cons pt (cddr ch)))
;                )
;            )
;            ch
;        )
;    )
;)
;
;
;
(defun LM:intersections ( ob1 ob2 mod / lst rtn )
    (if (and (vlax-method-applicable-p ob1 'intersectwith)
             (vlax-method-applicable-p ob2 'intersectwith)
             (setq lst (vlax-invoke ob1 'intersectwith ob2 mod))
        )
        (repeat (/ (length lst) 3)
            (setq rtn (cons (list (car lst) (cadr lst) (caddr lst)) rtn)
                  lst (cdddr lst)
            )
        )
    )
    (reverse rtn)
)