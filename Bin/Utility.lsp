;	 (none) Single pick point point1 (ssget '(10 15)) or (ssget)
;	"C" Crossing point1 point2 (ssget "C" '(1 1) '(2 2))
;	"CC" Crossing Circle point1 point2 (ssget "CC" '(1 1) '(2 2))
;	"CP" Crossing Polygon points-list (ssget "CP" ptlist)
;	"F" Fence points-list (ssget "F" ptlist)
;	"I" Implied none (ssget "I")
;	"L" Last none (ssget "L")
;	"O" Outside points-list (ssget "O" ptlist)
;	"OC" Outside Circle point1 point2 (ssget "OC" '(1 1) '(2 2))
;	"OP" Outside Polygon points-list (ssget "OP" ptlist)
;	"P" Previous none (ssget "P")
;	"PO" POint point1 (ssget "PO" '(1 1))
;	"W" Window point1 point2 (ssget "W" '(1 1) '(2 2))
;	"WP" Window Polygon points-list (ssget "WP" ptlist)
;	"X" All none (ssget "X") 
;
;
;(defun GetNumberDec ( x ) non stabile
;
;	(if (= (type x) 'REAL)
;		(progn
;			
;			(setq x (- x (fix x))) 
;			(if (= x 0)
;				0
;				(   (lambda ( s ) (- (strlen s) (cond ((vl-string-position 46 s nil t)) ((1- (strlen s)))) 1))
;					(vl-string-right-trim "0" (LM:rtos x 2 12))
;				)
;			)
;		)
;	)
;)
;
(defun C:ESEGUI_ADMIN (/ shellApp)
  (vl-load-com)
  (setq shellApp (vla-getinterfaceobject (vlax-get-acad-object) "Shell.Application"))
  
  ;; Parametri di ShellExecute:
  ;; 1. Il file da eseguire
  ;; 2. Eventuali argomenti
  ;; 3. La cartella di lavoro
  ;; 4. "runas" (questo attiva la richiesta di privilegi admin)
  ;; 5. 1 = Finestra normale
  (vlax-invoke shellApp 'ShellExecute "C:\\EasyCutNesting Beta\\Release\\Output\\5.1.3\\install.cmd" "" "" "runas" 1)
  
  (vlax-release-object shellApp)
  (princ "\nRichiesta di elevazione inviata.")
  (princ)
)
;
; Porcedure SERVER ------------------------------------------------------------------------------------------------------
;
(defun UpdateReleaseEasyCut (UrlVersion Verbose / 	*error* GetLastVersion ParseVersion <Version ProgNumber Assemble7zCmd
													Flag UrlVersion UrlDownload
													FolderDownload FileWildCard Extension 
													InfoVersion LastVersion CountFile itm Pos LstFileDownload)

	;
    (defun *error* (msg)
      (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
          (princ (strcat "\n** Error: " msg " **")))
      (princ)
    )
	;
	(defun GetLastVersion (url Verbose) 
		(ReadServerFile Url Verbose)
	)
	;
	(defun ParseVersion (version / token) ; helper to convert version string to list
		(if (setq token (vl-string-position 46 version))
			(cons (atoi (substr version 1 token)) (ParseVersion (substr version (+ 2 token))))
			(list (atoi version))
		)
	)
	;
	(defun <Version (left right) ; compare version lists
		(cond
			( (null left)
				(not (null right))
			)
			( (< (car left) (car right)))
			( (= (car left) (car right))
				(<version (cdr left) (cdr right))
			)
		)
	)
	;
	(defun ProgNumber (Num NumCar)
		(if (and Num NumCar)
			(progn
				(setq Rtn (itoa Num))
				;; Aggiunge zeri finché la stringa non è lunga 3 caratteri
				(while (< (strlen Rtn) NumCar)
					(setq Rtn (strcat "0" Rtn))
				)
			)
		)
	)
	;
	(defun Assemble7zCmd (Folder LstFile FileDest Verbose / StringFile itm CommandBatch Shell Rtn)
	
		(if (and Folder LstFile FileDest)
			(progn
			
				(if (findfile FileDest) (vl-file-delete FileDest))
				(setq StringFile "")
				(foreach itm LstFile
					(if (= StringFile "")
						(setq StringFile (strcat "\"" Folder "\\" itm "\""))
						(setq StringFile (strcat StringFile " + " "\"" Folder "\\" itm "\""))
					)
				)
				(if Verbose 
					(setq CommandBatch (strcat "cmd.exe /k copy /b /y " StringFile " \"" FileDest "\""))
					(setq CommandBatch (strcat "cmd.exe /c copy /b /y " StringFile " \"" FileDest "\""))
				)
				(if (setq Shell (vlax-create-object "WScript.Shell"))
					(progn
						(if Verbose 
							(setq Rtn (vlax-invoke-method shell 'Run CommandBatch 1 :vlax-true))
							(setq Rtn (vlax-invoke-method shell 'Run CommandBatch 0 :vlax-true))
						)
						(foreach itm LstFile
							(vl-file-delete (strcat Folder "\\" itm))
						)
						(vlax-release-object shell)
					)
				)
			)
		)
		Rtn
	)
	;
	(defun InstalUpDateVersion ()
		(setq shell (vla-getinterfaceobject (vlax-get-acad-object) "Shell.Application"))
		;; Parametri: "percorso_file", "argomenti", "cartella_lavoro", "operazione", modo_finestra
		;; modo_finestra: 0 = Nascosta, 1 = Normale
		(vlax-invoke shell 'ShellExecute (strcat (getenv "TEMP") "\\UpdateEasyCut.cmd" "open" 1))
		(vlax-release-object shell)
	)
	;
	; Main +++
	;
	(if (TestConnection "https://www.easycutnesting.it/" Verbose)
		(progn
			;(setq UrlVersion  		 "https://EasyCutProject.altervista.org/wp-content/EasyCut/Download/version.txt")
			;(setq UrlDownload 		 "https://EasyCutProject.altervista.org/wp-content/EasyCut/Download/")
			;(setq UrlVersion  		 "https://adlproeng.altervista.org/EasyCut/Download/version.txt")
			;(setq UrlDownload 		 "https://adlproeng.altervista.org/EasyCut/Download/")
			(setq FolderDownload 	 (getenv "TEMP"))
			(setq FileWildCard		 "EasyCut_")
			(setq Extension          ".7z.")
			
			(if (CheckRemoteFile UrlVersion Verbose)
				(progn
					(setq InfoVersion (splitxt (GetLastVersion UrlVersion Verbose) " "))
					(setq LastVersion (car InfoVersion))
					(setq CountFile   (cadr InfoVersion))
					(setq UrlDownload (strcat "https://github.com/EasyCutNesting/easycut/releases/download/" LastVersion "/"))
					
					(setq Pos 1)
					(repeat (atoi CountFile)
						; EasyCut_5.1.3.7z.001
						(setq LstFileDownload (append LstFileDownload (list (strcat FileWildCard LastVersion Extension (ProgNumber Pos 3)))))
						(setq Pos (1+ Pos))
					)
				)
			)
			
			(if (<version (ParseVersion VersionEasyCut$) (ParseVersion LastVersion))
				(progn
					(foreach itm LstFileDownload
						(setq Flag T)
						(if (not (CheckRemoteFile (strcat UrlDownload itm) nil))
							(setq Flag nil)
						)
					)
					(if Flag 
						(if (= (LM:popup "avvertimento" "I file sono disponibili per il download \n vuoi proseguire ?" (+ 1 32 4096)) 1)
							(progn
								(DeleteFilesWildCard (getenv "TEMP") (strcat FileWildCard LastVersion Extension "*"))
								(StartProgressBar "Download EasyCut" (atoi CountFile)) 
								
								(foreach itm LstFileDownload
									(UpDateProgressBar)
									;(if (= (DownloadServerFileCmd 	(strcat UrlDownload itm) 
									;								(strcat FolderDownload "\\" itm) Verbose) 1)
									;
									(if (not (DownloadServerFileActiveX (strcat UrlDownload itm) 
																   		(strcat FolderDownload "\\" itm) Verbose))
										(progn
											(setq Flag nil)
											(LM:popup "Errore" "Download EasyCut fallito" (+ 0 16 4096))
											(exit)
										)
									)
								)
								(ClearProgressBar)
								(LM:popup "avvertimento" "Download EasyCut terminato" (+ 0 64 4096))
							)
							(progn
								(setq Flag nil)
								(princ "\n")
							)
						)
					)
					(if Flag
						(progn
							(Assemble7zCmd (getenv "TEMP") LstFileDownload (strcat (getenv "TEMP") "\\" FileWildCard LastVersion ".7z") Verbose )
							(if (setq wf (open (strcat (getenv "TEMP") "\\" FileWildCard LastVersion ".info") "w"))
								(progn
									(princ (strcat (getenv "TEMP") "\\" FileWildCard LastVersion ".7z") wf)
									(princ (strcat "\n" LastVersion) wf)
									(close wf)
									(InstalUpDateVersion)
								)
							)
						)
					)
				)
			)
		)
	)
)
;
; --------------------------------------------------------------------------------------------------------------
;
(defun Double->SimpleDouble (Value Accuracy / Rtn)
	(atof (Rtos Value 2 Accuracy))
)
;
(defun RemoveNthList (lst lstnth / pos itm)
			
	(setq pos 0)
	(foreach itm (vl-sort lstnth '<)
		(setq lst (LM:RemoveNth (- itm pos) lst))
		(setq pos (+ pos 1))
	)
	lst
			
)
;
(defun RemoveNthNestedList (lst ntlst / a i ret)
	(foreach e lst
	   (setq i -1)
	   (while (< (setq i (1+ i)) (length e))
			(if (not(member i ntlst)) (setq a (cons (nth i e) a)))
	   )
	   (setq ret (cons (reverse a) ret) a nil)
	)
	(reverse ret)
)
;
(defun Guid  (/ tl g)
		(if (setq tl (vlax-get-or-create-object "Scriptlet.TypeLib"))
			(progn 
				(setq g (vlax-get tl 'Guid)) 
				(vlax-release-object tl) 
				(substr g 1 (1+ (vl-string-search "}" g))) 				
			)
		)
)
;
(defun GetNameBlock (EnameBlock)
	(vlax-get-property (vlax-ename->vla-object EnameBlock) 
		(if (vlax-property-available-p (vlax-ename->vla-object EnameBlock) 'effectivename)
			'effectivename 'name
		)
	)
)
;
(defun DmpObject (/ en)
	(setq en (ssname (ssget) 0))
	(if en
		(vlax-dump-object (vlax-ename->vla-object en))
	)
)
;
(defun DmpEname (/ en)
	(entget (ssname (ssget) 0))
)
;
(defun ExistEname (Ename)
	(if Ename
		(if (entget Ename)
			T
		)
	)
)
;
(defun FillSsel (Ssel)
	
	(if (= (type Ssel) 'PICKSET)
		(> (sslength Ssel) 0)
	)
)
;
(defun GetNth (List Value)
	(if (and List Value)
		(if (member Value List)
			(- (length List) (length (member Value List)))
		)
	)
)
;
(defun GetNths ( x l / i )
    (setq i -1)
    (vl-remove nil (mapcar '(lambda ( y ) (setq i (1+ i)) (if (= x y) i)) l))
)
;
(defun NumToProg (Intero Cifre / Zeri Rtn)

	(if (and Intero Cifre)
		(progn
			(setq Zeri (- Cifre (strlen (rtos Intero 2 0))))
			(setq Rtn "")
			(if (> Zeri 0)
				(repeat Zeri
					(setq Rtn (strcat Rtn "0"))
				)
			)
			(setq Rtn (strcat Rtn  (rtos Intero 2 0)))
		)
	)
	Rtn
)
;
(defun CombineList ( l r )
   (cond
       (   (< r 2)
           (mapcar 'list l)
       )
       (   l
           (append
               (mapcar '(lambda ( x ) (cons (car l) x)) (CombineList (cdr l) (1- r)))
               (CombineList (cdr l) r)
           )
       )
   )
)
;
(defun MemberWithAccuracy ( expr lst Accuracy)
		(vl-member-if '(lambda ( x ) (equal x expr Accuracy)) lst)
)
;
(defun FindNthValToList (ListItm Val Fuzz / Loop Num Rtn)
	
	(if (and ListItm val)
		(progn
			(setq Loop T)
			(setq Num 0)
			(while Loop
				(if (equal (nth Num ListItm) Val Fuzz)
					(setq Rtn Num
						  Loop nil
					)
				)
				(setq Num (1+ Num))
				(if (= Num (length ListItm)) (setq Loop nil))
			)
		)
	)
	Rtn
)
;
(defun EqualValueOnList (Lst1 Lst2 / Rtn)

	(if (and Lst1 Lst2)
		(if (= (length Lst1) (length Lst2))
			(progn 
				(setq Rtn T)
				(foreach itm Lst1
						(if (not (member itm Lst2)) (setq Rtn nil))
				)
			)
		)
	)
	Rtn
)
;
(defun ListEqual (lst / first)
	(setq first (car lst))
	(vl-every '(lambda (x) (equal first x)) (cdr lst))
)
;
(defun Wait (Seconds / Stop)

	;(command "_DELAY" (* Seconds 1000.0))
    (setq Stop (+ (getvar "DATE") (/ Seconds 86400.0)))
    (while (> Stop (getvar "DATE"))
           ;(princ)
     )
)
;
(defun Blink (LstEname Count _Delay_ / delay)
;
; Make an entity blink
; Given an ename, hide the entity then redraw it
; Function will repeat this process 'count times
; Entity will be hidden 'delay seconds
;

	(defun re-draw (lst code)
		(mapcar (function (lambda (x) (redraw x code))) lst)
	)

	;(setq delay 0.02) ;set your defaults here	
	(repeat Count
		(re-draw LstEname 4) ;hide
		(Wait _Delay_)
		(re-draw lstEname 3) ;show
		(Wait _Delay_)	
	)
	(re-draw LstEname 4)
)
;
;
(defun LwVertices ( e )

	(if (member (assoc 210 e) e)
		(progn
			(setq Rtn (LM:lwvertices e))
			(setq elev (cdr (assoc 38 e)))
			(foreach itm Rtn
				(setq Rtn (subst (subst (append (list 10) (Trans (append (cdr (nth 0 itm)) (list Elev)) (cdr (assoc 210 e)) 0)) (nth 0 itm) itm) itm Rtn))
			)
		)
	)
	Rtn
)
;
;
(defun MyEqualPoint (P1 P2 Fuzz)

	(if (and P1 P2 Fuzz)
		(progn
			(if (= (length P1) 2) (setq P1 (append P1 (list 0.0)))) 
			(if (= (length P2) 2) (setq P2 (append P2 (list 0.0)))) 
			(equal P1 P2 Fuzz)
		)
	)
)
;
;
(defun DeleteEntity (LstEname / itm)
	(foreach itm LstEname
		(if (and itm (entget itm))
			(entdel  itm)
		)
	)

)
;
;
(defun DeleteObject (LstObject / obj)
	(foreach obj LstObject
		(if (and obj (not (vlax-erased-p obj)))
			(vla-delete obj)
		)
	)
)
;
;
(defun DeleteSsel (Ssel / Conta)

	(setq Conta 0)
	(if Ssel
		(repeat (sslength Ssel)
			(if (entget (ssname Ssel Conta)) (entdel  (ssname Ssel Conta)))
			(setq Conta (1+ Conta))
		)
	)
)
;
;
(defun LstEname->LstObj (LstEname / itm Rtn)
	
	(foreach itm LstEname
		(setq Rtn (append Rtn (list (vlax-ename->vla-object itm))))
	)
	Rtn
)
;
;
(defun LstObj->LstEname (LstObj / itm Rtn)
	
	(foreach itm LstObj
		(setq Rtn (append Rtn (list (vlax-vla-object->ename itm))))
	)
	Rtn
)
;
;
(defun LstObj->Ssget (LstObj / itm Rtn)
	
	(if LstObj
		(progn
			(setq Rtn (ssadd))
			(foreach itm LstObj
				(if (not (vlax-erased-p itm)) 
					(ssadd (vlax-vla-object->ename itm) Rtn)
				)
			)
		)
	)
	Rtn
)
;
;
(defun LstEname->Ssget (LstEname / itm Rtn)

	(if LstEname
		(progn
			(setq Rtn (ssadd))
			(foreach itm LstEname
				(if (entget itm)
					(ssadd itm Rtn)
				)
			)
		)
	)
	Rtn
)
;
;
(defun MergeSSel (LstSSel / Rtn)
	(foreach itm LstSSel
		(setq Rtn (append Rtn (LM:ss->ent itm)))
	)
	(LstEname->Ssget Rtn)
)
;
;
(defun GetNameEname (Ename)
	(if Ename	
		(if (entget Ename) 
			(cdr (assoc 0 (entget Ename)))
		)
	)
)
;
;
(defun GetNameObject (Object)
	(if Object 	
		(if (not (vlax-erased-p Object))
			(vlax-get-property Object 'ObjectName)
		)
	)
)
;
;
(defun MergeSelectionSets ( ListOfSSs / Lst nSS )

	(if (apply 'and (mapcar '(lambda (x) (= 'PICKSET (type x))) ListOfSSs))
		(progn
			(setq Rtn (ssadd))
			(mapcar 
				(function 
					(lambda (x / i) 
						(repeat (setq i (sslength x))
							(ssadd (ssname x (setq i (1- i))) Rtn)
						)
					)
				)
				ListOfSSs
			)
		)
	)
	Rtn
)
;
;
(defun ReplaceNthChar (n a Str / Rtn itm)
	;(ReplaceNthChar 2 "u" "123456") -> "1u3456"
	(if (and n a Str)
		(progn
			(setq LstStr (mapcar 'chr (vl-string->list Str)))
			(setq Rtn "")
			(foreach itm (LM:SubstNth  a (- n 1) LstStr)
				(setq Rtn (strcat Rtn itm))
			)
		)
	)
	Rtn
)
;
;
(defun ReplaceChar  (n o str)
	;(ReplaceChar  "u" "1" "1123456") -> "uu23456"
    (vl-list->string
        (mapcar '(lambda (x)
					(if (= x (ascii o))
						(ascii n)
						x))
			(vl-string->list str)
        )
    )
)
;
;
(defun vl-remove-blanks (string)
	(vl-list->string
		(vl-remove 32 (vl-string->list string ))
	)
)
;
;
(defun Rtoc ( n p / foo d l )
    (defun foo ( l n )
        (if (or (not (cadr l)) (= 46 (cadr l)))
            l
            (if (zerop (rem n 3))
                (vl-list* (car l) 44 (foo (cdr l) (1+ n)))
                (cons (car l) (foo (cdr l) (1+ n)))
            )
        )
    )
    (setq d (getvar 'dimzin))
    (setvar 'dimzin 0)
    (setq l (vl-string->list (rtos (abs n) 2 p)))
    (setvar 'dimzin d)
	(if (= (car l) 48)
		(vl-list->string l)
		(vl-list->string
			(append (if (minusp n) '(45))
				(foo l (- 3 (rem (fix (/ (log (abs n)) (log 10))) 3)))
			)
		)
	)
)
;
;
(defun GetReal_ (Val Dec / Rtn)

	(cond
		((= (type Val) 'STR)
			(GetReal_ (atof Val) Dec)
		)
		((= (type Val) 'INT)
			(atof (LM:rtos Val 2 Dec))
		)
		((= (type Val) 'REAL)
			(atof (LM:rtos Val 2 Dec))
		)
	)
)
;
;
(defun EnameCenter (Ename / LocalDimBox)
	(setq LocalDimBox (ucs-bbox Ename))
	(car (div (car (nth 0 LocalDimBox)) (cadr (nth 0 LocalDimBox))
			  (car (nth 1 LocalDimBox)) (cadr (nth 1 LocalDimBox)) 
			  1
		)
	)
)
;
;
;
(defun GetCoordinateDummyEname (EnameDummy / LstCo Num Rtn)
	
	(if EnameDummy
		(progn
			(setq LstCo (vlax-get (vlax-ename->vla-object EnameDummy) 'coordinates))
			(setq Num 0)
			(repeat (/ (length LstCo) 2)
				(setq Rtn (append Rtn (list (list (nth Num LstCo) (nth (1+ Num) LstCo)))))
				(setq Num (+ 2 Num))
			)
		)
	)
	Rtn
)
;
;
;
(defun get_vertices_dummy (ename den / lista_co totlength density curlen)

			(setq totlength (vlax-get-property (vlax-ename->vla-object ename) 'length))
			;(setq density (* totlength (/ 1.0 100.0)))
			(setq density (* totlength den))
			(setq CurLen density)
			
			(setq lista_co (list (vlax-curve-getStartPoint ename)))
			(setq CurLen (+ CurLen density))
			(while (<= CurLen totlength)
				(setq lista_co (append lista_co (list (vlax-curve-getpointatdist ename CurLen))))
				(setq CurLen (+ CurLen density))
			)
			lista_co
)	
;
;
;
(defun get_vertices_dummy02 (EnameShape MaxDist / GetPtDivArc 
												  Clock CoLwPl LastPt ContaV Pstart Pend Bulge Out Ndiv Rtn)

	(defun GetPtDivArc (ObjArc MaxDist / LgArc Radius DistDivide Ndi Prg Out)

			(setq LgArc  	 (vla-get-ArcLength ObjArc)
				  Radius 	 (vla-get-Radius ObjArc)
				  Ndi 		 (fix (/ LgArc MaxDist))
			)
				
			(if (= Ndi 0) (setq Ndi 1))
			
			(setq DistDivide (/ LgArc Ndi)
				  Prg DistDivide
			)
			(repeat (- Ndi 1)
				(if (not Out)
					(setq Out (list (vlax-curve-getPointAtDist ObjArc Prg)))
					(setq Out (append Out (list (vlax-curve-getPointAtDist ObjArc Prg))))
				)
				(setq Prg (+ Prg DistDivide))
			)
			Out
	)
	;
	; Main
	;
	(if (and EnameShape MaxDist)
		(progn
			(setq Clock 	(ClockWeisEname EnameShape))
			(setq CoLwPl 	(LM:lwvertices (entget EnameShape)))
			(setq CoLwPl 	(append CoLwPl (list (list (nth 0 (nth 0 CoLwPl)) (cons 40 0.0) (cons 41 0.0) (cons 42 0.0)))))
			;
			; estraggo i punti di controllo
			;
			(setq ContaV 0)
			(repeat (- (length CoLwPl) 1)
				(setq Pstart (cdr (car (nth (+ ContaV 0) CoLwPl))))
				(setq Pend   (cdr (car (nth (+ ContaV 1) CoLwPl))))
				(setq Bulge  (cdr (assoc 42 (nth (+ ContaV 0) CoLwPl))))

				(setq Rtn (append Rtn (list Pstart)))

				(cond
					((/= bulge 0) ; ------------------------------------------------------------> arco
						(setq ObArc (LwPBulgeToArc Pstart Pend Bulge)
							  Out 	(GetPtDivArc ObArc MaxDist)
						)
						(vla-Delete ObArc)
						(cond
							((= Clock 3) 	; percorrenza oraria
								(if (< bulge 0)
									(setq out (reverse out))
								)
							)
							((= Clock 2) 	; percorrenza antioraria
								(if (< bulge 0)
									(setq out (reverse out))
								)
							)
						)
						(setq Rtn (append Rtn Out))
					)
					(t			; ------------------------------------------------------------> segmento
						(setq Ndiv 	(fix (/ (distance Pstart Pend) MaxDist)))
						(setq Rtn (append Rtn (Div (car Pstart) (cadr Pstart) (car Pend) (cadr Pend) Ndiv)))
					)
				)
				(setq ContaV (1+ ContaV))
			)
		)
	)
	Rtn
)
;
;(vla-boolean (vlax-ename->vla-object (getent)) acIntersection (vlax-ename->vla-object (getent)))
;
(defun BooleanShape (Ename1 Action Ename2 / Go1 Go2 EnameRegion1 EnameRegion2 Go1 Go2 Rtn)

	;acUnion			0
	;acIntersection		1
	;acSubtraction		2
	
	(if (and (= (type Ename1) 'ENAME) (= (type Ename2) 'ENAME) Action)
		(progn
			(cond 
				((= (vlax-get-property (vlax-ename->vla-object Ename1) 'ObjectName) "AcDbPolyline")
					(if (= (vla-get-closed (vlax-ename->vla-object Ename1)) :vlax-true)
						(setq Go1 T)
					)
				)
				((= (vlax-get-property (vlax-ename->vla-object Ename1) 'ObjectName) "AcDbCircle")
					(setq Go1 T)
				)
				((= (vlax-get-property (vlax-ename->vla-object Ename1) 'ObjectName) "AcDbEllipse")
					(setq Go1 T)
				)
			)
			
			(cond 
				((= (vlax-get-property (vlax-ename->vla-object Ename2) 'ObjectName) "AcDbPolyline")
					(if (= (vla-get-closed (vlax-ename->vla-object Ename2)) :vlax-true)
						(setq Go2 T)
					)
				)
				((= (vlax-get-property (vlax-ename->vla-object Ename2) 'ObjectName) "AcDbCircle")
					(setq Go2 T)
				)
				((= (vlax-get-property (vlax-ename->vla-object Ename2) 'ObjectName) "AcDbEllipse")
					(setq Go2 T)
				)
			)
		)
	)
	
	(if (and Go1 Go2)
		(progn
			(setq EnameRegion1 (AddRegion Ename1))
			(setq EnameRegion2 (AddRegion Ename2))
			
			(vla-boolean (vlax-ename->vla-object EnameRegion1) Action (vlax-ename->vla-object EnameRegion2))
			
			(cond
				((= Action 0)
					(setq Rtn (RegionToPolyLine EnameRegion1 T))
				)
				((= Action 1)
					(if (entget EnameRegion1) 
						(setq Rtn (RegionToPolyLine EnameRegion1 T))
					)
				)
				((= Action 2)
					(if (entget EnameRegion1) 
						(progn 
							(if (not (zerop (vla-get-area (vlax-ename->vla-object EnameRegion1))))
								(setq Rtn (RegionToPolyLine EnameRegion1 T))
							)
						)
					)
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun BoundingBoxLstEname ( LstEname / bb ur ll)
  
	(foreach e LstEname
		(vla-getBoundingBox (vlax-ename->vla-object e) 'll 'ur)
        (setq bb (cons (vlax-safearray->list ur)
                       (cons (vlax-safearray->list ll) bb))
        )
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
(defun text-box ( enx off / mxv b h j l m n o p r w )

	;; Text Box  -  gile / Lee Mac
	;; Returns an OCS point list describing a rectangular frame surrounding
	;; the supplied text or mtext entity with optional offset
	;; enx - [lst] Text or MText DXF data list
	;; off - [rea] offset (may be zero)
	
	;; Matrix x Vector  -  Vladimir Nesterovsky
	;; Args: m - nxn matrix, v - vector in R^n
	(defun mxv ( m v )
		(mapcar '(lambda ( r ) (apply '+ (mapcar '* r v))) m)
	)
	;
	;Main
	;
    (if
        (setq l
            (cond
                (   (= "TEXT" (cdr (assoc 0 enx)))
                    (setq b (cdr (assoc 10 enx))
                          r (cdr (assoc 50 enx))
                          l (textbox enx)
                    )
                    (list
                        (list (- (caar  l) off) (- (cadar  l) off))
                        (list (+ (caadr l) off) (- (cadar  l) off))
                        (list (+ (caadr l) off) (+ (cadadr l) off))
                        (list (- (caar  l) off) (+ (cadadr l) off))
                    )
                )
                (   (= "MTEXT" (cdr (assoc 0 enx)))
                    (setq n (cdr (assoc 210 enx))
                          b (trans  (cdr (assoc 10 enx)) 0 n)
                          r (angle '(0.0 0.0 0.0) (trans (cdr (assoc 11 enx)) 0 n))
                          w (cdr (assoc 42 enx))
                          h (cdr (assoc 43 enx))
                          j (cdr (assoc 71 enx))
                          o (list
                                (cond
                                    ((member j '(2 5 8)) (/ w -2.0))
                                    ((member j '(3 6 9)) (- w))
                                    (0.0)
                                )
                                (cond
                                    ((member j '(1 2 3)) (- h))
                                    ((member j '(4 5 6)) (/ h -2.0))
                                    (0.0)
                                )
                            )
                    )
                    (list
                        (list (- (car o)   off) (- (cadr o)   off))
                        (list (+ (car o) w off) (- (cadr o)   off))
                        (list (+ (car o) w off) (+ (cadr o) h off))
                        (list (- (car o)   off) (+ (cadr o) h off))
                    )
                )
            )
        )
        (   (lambda ( m ) (mapcar '(lambda ( p ) (mapcar '+ (mxv m p) b)) l))
            (list
                (list (cos r) (sin (- r)) 0.0)
                (list (sin r) (cos r)     0.0)
               '(0.0 0.0 1.0)
            )
        )
    )
)
;
;
(defun GeoText (EnameText / InfoText)
	(if EnameText
		(progn
			(setq InfoText (text-box (entget EnameText) 0.0))
			(list (distance (car InfoText)  (cadr InfoText))
				  (distance (cadr InfoText) (caddr InfoText)))	
		)
	)
)
;
;
;
(defun ucs-bbox	(obj / LstExplode ObyCopy LstObj Explode Rtn)

		;(setq LstExplode '("AcDbOrdinateDimension" "AcDbRotatedDimension"))
		(setq LstExplode '("AcDbOrdinateDimension"))
		
		(and (= (type obj) 'ENAME)
			(setq obj (vlax-ename->vla-object obj))
		)
		
		(if (member (vlax-get-property obj 'ObjectName) LstExplode)
			(progn
				(setq Explode T)
				(setq ObyCopy (vla-copy obj))
				(Open_Block_Entity)
				(command "_.explode" (vlax-vla-object->ename ObyCopy))
				(setq LstObj (LstEname->LstObj (Close_Block_Entity)))
			)
			(setq LstObj (list obj))
		)
		
		(setq Rtn (UcsBoundingBoxLstEname (LstObj->LstEname LstObj)))

		(if Explode
			(foreach itm LstObj
				(vla-delete itm)
			)
		)

		(list (car Rtn) (caddr Rtn))
)
;
;
;
(defun UcsBoundingBoxLstEname (LstEname / UCS2WCSMatrix WCS2UCSMatrix
										  LstExplode ObyCopy LstObj itx
										  e obj bb ll bb)

		(defun UCS2WCSMatrix ()
			(vlax-tmatrix (append (mapcar '(lambda (vector origin) (append (trans vector 1 0 t) (list origin)))
                                      (list '(1 0 0) '(0 1 0) '(0 0 1)) (trans '(0 0 0) 0 1))
                                      (list '(0 0 0 1)))
			)
		)
		;
		(defun WCS2UCSMatrix ()
			(vlax-tmatrix (append (mapcar '(lambda (vector origin) (append (trans vector 0 1 t) (list origin)))
                                     (list '(1 0 0) '(0 1 0) '(0 0 1)) (trans '(0 0 0) 1 0))
                                     (list '(0 0 0 1))))
		)
		;
		; Main ++++++
		;
		;(setq LstExplode '("AcDbOrdinateDimension" "AcDbRotatedDimension"))
		(setq LstExplode '("AcDbOrdinateDimension"))
		(foreach e LstEname

			(setq obj (vlax-ename->vla-object e))
			(if (member (vlax-get-property obj 'ObjectName) LstExplode)
				(progn
					(setq ObyCopy (vla-copy obj))
					(Open_Block_Entity)
					(command "_.explode" (vlax-vla-object->ename ObyCopy))
					(setq LstObj (LstEname->LstObj (Close_Block_Entity)))
					(foreach itx LstObj
						(vla-TransformBy itx (UCS2WCSMatrix))
						(vla-getBoundingBox itx 'll 'ur)
						(vla-TransformBy itx (WCS2UCSMatrix))
						(vla-delete itx)
						(setq bb (cons (vlax-safearray->list ur) (cons (vlax-safearray->list ll) bb)))
					)
				)
				(progn
					(vla-TransformBy obj (UCS2WCSMatrix))
					(vla-getBoundingBox obj 'll 'ur)
					(vla-TransformBy obj (WCS2UCSMatrix))
					(setq bb (cons (vlax-safearray->list ur) (cons (vlax-safearray->list ll) bb)))
				)
			)
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
(defun FilterEntitySelectionByObjectName (Ssel LstObjectName / Obj Num Itm Rtn)

	(if (and Ssel LstObjectName)
		
		(progn
			(setq Num 0)
			(repeat (sslength Ssel)
				(if (entget (ssname Ssel Num))
					(progn
						(setq Obj (vlax-ename->vla-object (ssname Ssel Num)))
						(foreach Itm LstObjectName
							(if (= (vlax-get-property Obj 'ObjectName) Itm)
								(progn
									(if (not Rtn) (setq Rtn (ssadd)))
									(ssadd (ssname Ssel Num) Rtn)
								)
							)
						)
					)
				)
				(setq Num (1+ Num))
			)
		)
	)
	Rtn
)
;
;
;
(defun FilterEntitySelectionByName (Ssel LstName / Itm Rtn)

	(if (and Ssel LstName)
		(foreach itm (LM:ss->ent Ssel)
			(if (entget itm)
				(if (member (cdr (assoc 0 (entget itm))) LstName)
					(progn
						(if (not Rtn) (setq Rtn (ssadd)))
						(ssadd itm Rtn)
					)
				)
			)
		)
	)
	Rtn
)
;
;
;
(defun AcadVersion (/ Rtn)
	(cond
		((= (atof (getvar 'AcadVer)) 25.0) (setq Rtn 2021))
		((= (atof (getvar 'AcadVer)) 24.0) (setq Rtn 2020))
		((= (atof (getvar 'AcadVer)) 23.0) (setq Rtn 2019))
		((= (atof (getvar 'AcadVer)) 22.0) (setq Rtn 2018))
		((= (atof (getvar 'AcadVer)) 21.0) (setq Rtn 2017))
		((= (atof (getvar 'AcadVer)) 20.1) (setq Rtn 2016))
		((= (atof (getvar 'AcadVer)) 20.0) (setq Rtn 2015))
		((= (atof (getvar 'AcadVer)) 19.1) (setq Rtn 2014))
		((= (atof (getvar 'AcadVer)) 19.0) (setq Rtn 2013))
		((= (atof (getvar 'AcadVer)) 18.2) (setq Rtn 2012))
		((= (atof (getvar 'AcadVer)) 18.1) (setq Rtn 2011))
		((= (atof (getvar 'AcadVer)) 18.0) (setq Rtn 2010))
		((= (atof (getvar 'AcadVer)) 17.2) (setq Rtn 2009))
		((= (atof (getvar 'AcadVer)) 17.1) (setq Rtn 2008))
		((= (atof (getvar 'AcadVer)) 17.0) (setq Rtn 2007))
		(T (alert "Unknown version of AutoCAD detected."))
	)
	Rtn
)
;
;
;
(defun Today ( / d yr mo day)
 
     (setq d  (rtos (getvar "CDATE") 2 6)
           yr (substr d 1 4)
           mo (substr d 5 2)
          day (substr d 7 2)
     ) 
     (strcat day "/" mo "/" yr)
)
;
;
;
(defun Time (/ Date+Time Hr Mn Lupe)
	
	(setq Lupe (getvar "LUPREC"))
	(setvar "LUPREC" 8)

	(setq Date+Time (rtos (getvar "CDATE"))
		  Hr (substr Date+Time 10 2)
		  Mn (substr Date+Time 12 2)
	)
	(setvar "LUPREC" Lupe)
	
	(strcat Hr ":" Mn)
)
;
;
;
(defun MinSec (Timing / minuti secondi Rtn)

	(setq 	minuti (fix Timing)
			secondi (* (- Timing minuti) 60.0)
			Rtn (strcat (rtos minuti 2 0) " min "  (rtos secondi 2 0) " sec")
	)

)
;
;
;
(defun CurDate (bOuput / cdate_val YYYY M D HH MM SS MS)
	  ; Get the current date/time
	  (setq cdate_val (LM:rtos (getvar "CDATE") 2 8))

	  ; Break up the string into its separate parts
	  (setq YYYY (substr cdate_val 1 4)
			M    (substr cdate_val 5 2)
			D    (substr cdate_val 7 2)
			HH   (substr cdate_val 10 2)
			MM   (substr cdate_val 12 2)
			SS   (substr cdate_val 14 2)
			MS   (substr cdate_val 16 2)
	  )

	  ; Output the current date and time to the Command
	  ; prompt or return the formatted output as a string
	  (if bOuput
		(progn
		  (prompt (strcat "\nDate: " M "/" D "/" YYYY
						  "\nTime: " HH ":" MM ":" SS
				  )
		  )
		  (princ)
		)
		(strcat YYYY "_" M "_" D "-" HH "." MM "." SS)
		;(strcat M  D  YYYY "-" HH  MM  SS)
	  )
)
;
;
;
(defun VpCoords ( )
    (   (lambda (offset)
            (   (lambda (viewctr)
                    (list
                        (mapcar '- viewctr offset)
                        (mapcar '+ viewctr offset)
                    )
                )
                (getvar "viewctr")
            )
        )
        (   (lambda (halfHeight aspectRatio)
                (list
                    (* halfHeight aspectRatio)
                    halfHeight
                )
            )
            (* 0.5 (getvar "viewsize"))
            (apply '/ (getvar "screensize"))
        )
    )
)
;
;
;
(defun CheckExistStyle (NameStyle / Rtn)

	(if (tblsearch "STYLE" NameStyle)
		(setq Rtn T)
	)
	Rtn
)
;
;
;
(defun RemoveEntity (Ssel LstNameEntityToCheck / Ssel Itm Name LstData LstEname)
	(if (and Ssel LstNameEntityToCheck)
		(foreach Itm (LM:ss->ent Ssel)
			(if (setq LstData (entget Itm))
				(if (member (cdr (assoc 0 LstData)) LstNameEntityToCheck) 
					(entdel Itm)
					(setq LstEname (append LstEname (list Itm)))
				)
			)
		)
	)
	(LstEname->Ssget LstEname)
)
;
;
;
(defun GetLstBlock (NameBlock / Sselect i Rtn)

	(if NameBlock
		(if (setq SSelect (ssget "_X" (list '(67 . 0) '(0 . "INSERT") (cons 2 (apply 'strcat (cons NameBlock (mapcar '(lambda ( x ) (strcat ",`" x))
																															(LM:getanonymousreferences NameBlock))))))))
			(repeat (setq i (sslength Sselect))
				(setq Rtn (append Rtn (list (ssname Sselect (setq i (1- i))))))
			)
		)
	)
    Rtn
)
;
;
;
(defun RenameNameBlock (EnameBlock NewName / EnameChange)

	(if (and EnameBlock NewName)
		(if (not (tblobjname "block" NewName))
			(progn 
				(setq EnameChange (cdr (assoc 330 (entget (tblobjname "block" (cdr (assoc 2 (entget EnameBlock))))))))
				(entmod (subst (cons 2 NewName) (assoc 2 (entget EnameChange)) (entget EnameChange)))
			)
		)
	)
)
;
;
;
(defun SetAttributeValueNestedBlock (NameBlock NameBlockNested Tag Val / ename)

	(setq Ename (tblobjname "block" NameBlock))
	(while Ename
		(if (and (= (cdr (assoc 0 (entget Ename))) "INSERT") 
				 (= (strcase (cdr (assoc 2 (entget Ename)))) (strcase NameBlockNested))
			)
			(LM:vl-setattributevalue (vlax-ename->vla-object Ename) Tag Val)
		)
		(setq Ename (entnext Ename))
	)
	(vla-Regen (vla-get-activedocument (vlax-get-acad-object)) acActiveViewport)
)
;
;
;
(defun obj2blk (bNme pt ss / i ent Rtn)

  ;; Lee Mac  ~  11.02.10

	(if (and bNme pt ss)
		(progn
			(entmake (list (cons 0 "BLOCK") (cons 10 pt) (cons 2 bNme) (cons 70 0)))
			(setq i -1)
			(while (setq ent (ssname ss (setq i (1+ i))))
				(entmake (entget ent))
				(entdel ent)
			)
			(entmake (list (cons 0 "ENDBLK") (cons 8 "0")))
			(entmake (list (cons 0 "INSERT") (cons 2 bNme) (cons 10 pt)))
			(setq Rtn (entlast))
		)
	)
	Rtn
	
)
;
;
;
(defun Regen_ ()
	(vla-regen (vla-get-ActiveDocument (vlax-get-acad-object)) acAllViewports)
)
;
;
;
(defun GetBlockList (/ count theblk Rtn)
	(setq count 1)
	(while (setq theblk (tblnext "BLOCK" (null theblk)))
		(setq Rtn (append Rtn (list (cdr (assoc 2 theblk)))))
	)
	Rtn
)
;
;
;
(defun InsertBomWithoutMessage (NameBlock Point / Rtn Osnap)
	(if (and NameBlock Point)
		(progn
			(command "_.-insert" NameBlock "_none" Point "" "" "")
			(setq EnameBlock (entlast))	
			(setq LstEname (mapcar 'vlax-vla-object->ename (vlax-safearray->list (vlax-variant-value (vla-Explode (vlax-ename->vla-object EnameBlock))))))
			(entdel EnameBlock)
			(PurgeBlock (vl-filename-base NameBlock))
			LstEname
		)
	)
)
;
;
;
(defun InsertBlock (NameBlock Point Flag / InsertionPt Doc ModelSpace BlockObj NameBlock ExplodeObj Rtn)

	(if (and NameBlock Point)
		(progn
			(setq InsertionPt (vlax-3d-point Point))
			(setq Doc (vla-get-activedocument (vlax-get-acad-object)))
			(setq ModelSpace (vla-get-ModelSpace Doc))
			(setq BlockObj   (vla-InsertBlock ModelSpace InsertionPt NameBlock 1 1 1 0))
			(setq NameBlock  (vla-get-EffectiveName BlockObj))
			(if Flag
				(progn
					(setq Rtn (nth 0 (vlax-safearray->list  (vlax-variant-value (vla-Explode BlockObj)))))
					(vla-Delete BlockObj)
					(PurgeBlock NameBlock)
				)
				(setq Rtn BlockObj)
			)
		)
	)
	Rtn
)
;
;
;
(defun ImportDxf (FileDxf Pt Stream / EnameBlock LstEname Doc Rtn)

	(if	(and FileDxf Pt)
		(if ECVersionDxfCreated$		
			(progn
				(setq Doc (vla-get-ActiveDocument (vlax-get-acad-object)))
				(Open_Block_Entity)
				(vla-Import Doc FileDxf (vlax-3d-point Pt) 1)
				(setq Rtn (Close_Block_Entity))
			)
			(setq Rtn (Dxf2Entity FileDxf Pt Stream))
		)
		(alert (strcat "[ImportDxf] " FileDxf " File o punto inserimento mancante"))
	)
	Rtn
)
;
;
;
(defun MyPurge (LstItem / PurgeAll x)
	; (MyPurge '("BLOCK" "GROUP"))
	; '("BLOCK" "GROUP" "MLINESTYLE" "Tablestyles" "LAYER" "DIMSTYLE" "STYLE" "LTYPE" "PLOTSTYLES" "Visualstyles" "MATERIALS")
	(defun PurgeAll (ptype mask / PurgeAllAux
								  ValCmdecho tcnt cnt)

		(defun PurgeAllAux (/ cnt)
			(setq cnt 0)
			(command "._PURGE" ptype mask "Yes")
			(while (= (getvar "CMDACTIVE") 1) (command "Yes") (setq cnt (1+ cnt)))
			cnt
		)
		;
		; Main
		;
		(if (not mask)(setq mask "*"))
		(if (= "ALL" ptype) (command "-purge" "reg" mask "no"))
		(if (not ptype) (setq ptype "All"))
		
		(setq ValCmdecho (getvar "cmdecho"))
		(setvar "Cmdecho" 0)
			;(vla-sendcommand (vla-get-activedocument (vlax-get-acad-object)) "._UNDO _BEGIN ")
			(command "._UNDO" "BEGIN")
				(setq tcnt 0)
				(while (> (setq cnt (PurgeAllAux)) 0) (setq tcnt (+ tcnt cnt)))
			;(vla-sendcommand (vla-get-activedocument (vlax-get-acad-object)) "._UNDO _END ")
			(command "._UNDO" "_END")
		(setvar "Cmdecho" ValCmdecho)
		
		;(if (> tcnt 0)
		;	(princ (strcat "\n(" (itoa tcnt) ") " (if (= (strcase ptype) "ALL")	"item"	ptype)	(if (/= 1 tcnt)	"s"	"")	" purged."))
		;)
		;(princ)
	)
	;
	; Main
	;
	;
	(foreach x LstItem
		(if (= x "GROUP") 
			(PurgeAllGroupUnentity) 
			(PurgeAll x nil)
		)
	)
)
;
;
;
(defun PurgeBlock (NameBlock)
  (if (vl-catch-all-error-p
        (vl-catch-all-apply
          'vla-delete
          (list (vl-catch-all-apply
                  'vla-item
                  (list (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object))) NameBlock)
                )
          )
        )
      )
    nil ; name cannot be purged or doesn't exist
    T ; name purged
  )
)
;
;
;
(defun PurgeBlockLoop ( / itm Rtn)

	(foreach itm (GetBlockList)
		(if (setq Rtn (PurgeBlock itm)) (PurgeBlockLoop))
	)
)
;
;
;
(defun AttributeFill (BlockObj List)
  (mapcar
    '(lambda (a v) (vla-put-textstring a v))
    
    (vlax-safearray->list
      (vlax-variant-value (vla-getattributes BlockObj))
    )
    List
  ) 
)
;
;
;
(defun Close_Block_Entity (/ out_lista_ent new_ent) 
		;
		; ricerca tutte le entita partendo da $ADL_back_entity$
		;
		(setq ent_rif $ADL_back_entity$)
		(setq out_lista_ent nil)
		(while (setq new_ent (entnext ent_rif)) 
				(if new_ent 
					(progn
						(setq out_lista_ent (append out_lista_ent (list new_ent)))
						(setq ent_rif new_ent)               
					)
				)
		) 
		(if (entget $ADL_back_entity$) (entdel $ADL_back_entity$))
		(setq $ADL_back_entity$ nil)
		out_lista_ent
)
;
;
;
(defun Open_Block_Entity (/ ucsx ucsy T11 T21 T31 T12 T22 T32 T13 T23 T33 cos_dir back_entity objdel)
		(setq $ADL_back_entity$
			(entmakex
				(list
					(cons 0 "LINE")
					(cons 100 "AcDbEntity")
					(cons 67 0)
					(cons 8 $LayerDinamicInfoEasyCut)
					(cons 100 "AcDbLine")	
					(cons 10 (list 0.0 0.0 0.0))
					(cons 11 (list 1.0 0.0 0.0))
					(cons 210 (list 0.0 0.0 1.0))
				)
			)
		)
)
;
; Progress Bar Tools ------------------
(defun StartProgressBar (Text Num / LoadAceUiProgress)

	(if (boundp 'acet-ui-progress)
		(progn
			(acet-ui-progress Text Num)
			(setq $ProgBar$ 1)
		)
	)
)
;
(defun UpDateProgressBar ()
	(if (boundp 'acet-ui-progress)
		(progn
			(acet-ui-progress $ProgBar$)
			(setq $ProgBar$ (1+ $ProgBar$))
		)
	)
)
;
(defun ClearProgressBar ()

	(if (boundp 'acet-ui-progress)
		(progn
			(acet-ui-progress)
			(setq $ProgBar$ nil)
		)
	)
)
;
(defun StartProgressBarDcl (Key Num)

	(start_image Key)	(fill_image 0 0 (dimx_tile Key) (dimy_tile Key) -15) (end_image)
	(setq $ProgBarDclNum$ Num)
	(setq $ProgBarDcl$ 1)
)
;
(defun UpDateProgressBarDcl (Key)

	(start_image Key) (fill_image 0 0 (/ (* $ProgBarDcl$ (dimx_tile Key)) $ProgBarDclNum$) (dimy_tile Key) 253) (end_image)
	(setq $ProgBarDcl$ (1+ $ProgBarDcl$))
)
;
(defun ClearProgressBarDcl (Key)

	(start_image Key) (fill_image 0 0 (dimx_tile Key) (dimy_tile Key) -15) (end_image)
)
;
; Layout Tools ------------------------
;
(defun SetupLayout ( / AcadObj DisObj)
	(setq AcadObj (vlax-get-Acad-Object))
    (setq DisObj (vla-get-Display (vla-get-Preferences AcadObj)))
    (vla-put-ShortCutMenuDisplay  (vla-get-User (vla-get-Preferences AcadObj)) 0)
    (mapcar
        '(lambda (x)
            (vlax-put DisObj x 0)
        )
        '(
            "DisPlayScreenMenu"
            "DisplayScrollbars"
            "LayoutCreateViewport"
            "LayoutDisplayMargins"
            "LayoutDisplayPaper"
            "LayoutDisplayPaperShadow"
            "LayoutShowPlotSetup"
        )
    )
  ;(vla-regen (vla-get-activedocument (vlax-get-acad-object)) acActiveViewport)

  (princ)
)
;
(defun SetColorlayout (LayoutName LstRgb / RGBToTrueColor Disp)

	; Rgb (0 0 0)       nero
	; Rgb (255 255 255) bianco

	(defun RGBToTrueColor (rgb / r g b tcol)
		(setq r (lsh (car rgb) 16))
		(setq g (lsh (cadr rgb) 8))
		(setq b (caddr rgb))
		(setq tcol (+ (+ r g) b))
	)

	(setq Disp (vla-get-display (vla-get-preferences (vlax-get-acad-object))))
	;(vla-put-GraphicsWinModelBackgrndColor Disp  (RGBToTrueColor LstRgb))
	(vla-put-GraphicsWinLayoutBackgrndColor Disp (RGBToTrueColor  Lstrgb))
)
;
(defun NewLayout (LayoutName / *adoc* Rtn)
 
	(setq *adoc* (cond (*adoc*) ((vla-get-ActiveDocument (vlax-get-acad-object)))))
	(if (not (member (strcase LayoutName) (mapcar 'strcase (layoutlist))))
		(progn
			(if (vl-catch-all-error-p (setq LayoutName (vl-catch-all-apply (function vla-add) (list (vla-get-layouts *adoc*) LayoutName))))
			(vl-catch-all-error-message LayoutName) LayoutName)
			(setq Rtn T)
		)
	)
	Rtn
)
;
(defun DeleteLayout (LayoutName / vp Rtn)

	(if (not (vl-catch-all-error-p (setq vp (vl-catch-all-apply 'vla-item (list (vla-get-layouts (vla-get-activedocument (vlax-get-acad-object))) LayoutName)))))
		(progn
			(setq Rtn T)
			(vla-delete vp)
		)
	)
	Rtn
)
;
(defun RenameLayout (NewName OldName / Rtn)
	
	(setq Rtn T)
	(if (member (strcase OldName) (mapcar 'strcase (layoutlist)))
		(if (not (member (strcase NewName) (mapcar 'strcase (layoutlist))))
			(vla-put-name (vla-item (vla-get-layouts (vla-get-activedocument (vlax-get-acad-object))) OldName) NewName)
			(setq Rtn nil)
		)
		(setq Rtn nil)
	)
	Rtn
)
;
(defun LayoutActive ()
	(getvar "ctab")
)
;
(defun ChangeLayout (LayoutName / Rtn)
	
	(setq Rtn T)
	(if (member (strcase LayoutName) (mapcar 'strcase (layoutlist)))
		(setvar "ctab" LayoutName)
		(setq Rtn nil)
	)
)
;
(defun GoToModelLayout (/ Rtn)
	
	(setq Rtn T)
	(if (= (getvar 'tilemode) 0)
		(setvar 'tilemode 1)
		(setq Rtn nil)
	)
	Rtn
)
;
(defun IsModelSpace (/ Rtn)
	
	(if (= (getvar 'tilemode) 1)
		(setq Rtn T)
	)
	Rtn
)
;
(defun DeleteLayout (LayoutName / layout)

	(vlax-for layout (vla-get-layouts (vla-get-ActiveDocument (vlax-get-acad-object)))
		(if	(= (strcase (vla-get-name layout)) (strcase LayoutName))
			(vla-delete layout)
		)
	)
)
;
(defun DeleteObjectLayout (LayoutName / doc layouts x i)

	(setq 	doc 	(vla-get-activedocument (vlax-get-acad-object))
			layouts (vlax-get doc 'Layouts)
	)
	(vlax-for x layouts
		(if (= (strcase (vla-get-name x)) (strcase LayoutName))
			(vlax-for i (vlax-get x 'Block)
				(vla-delete i)
			)
		)
	)
)
;
(defun CreateViewPort (Center Width Height Scale / acadObject acadDocument PaperSpace ObjViewport Rtn)

	(if (and Center Width Height)
		(progn
			(setq acadObject   (vlax-get-acad-object))				;get autocad object
			(setq acadDocument (vla-get-activedocument acadObject))	;get autocad document object
			(setq PaperSpace   (vla-get-paperspace acaddocument))	;get the paperspace object
		  
			(setq ObjViewport (vla-addpviewport 						;add viewport to the paperspace object
									PaperSpace 
									(vlax-3d-point Center) 
									Width 
									Height))
		  
			;(vla-put-viewporton  ObjViewport :vlax-true)			; turn on the viewport
			(vla-put-customscale ObjViewport Scale)					; Change the custom scale setting to 1:10 scale = 0.1
			;(vla-put-visible ObjViewport :vlax-false)            	; rendo il frame invisibile
			(vla-display ObjViewport :vlax-true)					; Turn the viewport on, by default it is off
			

			(setq Rtn (vlax-vla-object->ename  ObjViewport))
		)
	)
	Rtn
)
;
(defun MakeViewSheet (EnameSheet / DataView)

	(if EnameSheet
		(progn
			(setq DataView (EnameSheetToDataView EnameSheet))
			(MakeView (GetIdSheet EnameSheet) (car DataView) (cadr DataView) (caddr DataView))
		)
	)
)
;
(defun MakeViewBomShape (EnameBomShape / DataView)

	(if EnameBomShape
		(progn
			(setq DataView (EnameBomShapeToDataView EnameBomShape))
			(MakeView (LM:vl-getattributevalue (vlax-ename->vla-object EnameBomShape) "IDSHAPE") (car DataView) (cadr DataView) (caddr DataView))
		)
	)
)
;
(defun DeleteViews (NameView / Rtn)

	(setq Rtn T)
	(if NameView
		(vla-delete (vla-item (vla-get-views (vla-get-activedocument (vlax-get-acad-object))) NameView))
		(setq Rtn nil)
	)
	Rtn
)
;
(defun MakeView (NameView CenterPoint Width Height / doc viewObj Point)
 
	; CenterPoint (list x y) no zeta
	(if (and NameView CenterPoint Width Height)
		(progn
			(setq doc     (vla-get-activedocument (vlax-get-acad-object)))
			(setq viewObj (vla-add (vla-get-views doc) NameView))
			(setq Point (vlax-make-safearray vlax-vbDouble '(0 . 1)))
			(vlax-safearray-fill Point CenterPoint)
			(vla-put-center viewObj Point)
			(vla-put-width  viewObj Width)
			(vla-put-height viewObj Height)
		)
	)
)
;
(defun EnameSheetToDataView (EnameSheet / MarginAround EnameBlock DimSheet Width Height Center Rtn)

	(if EnameSheet
		(progn
			(setq MarginAround 100.0)
			;(setq EnameRule  (GetEnameRuleByEnameSheet EnameSheet))
			(setq EnameBlock (GetEnameBlockSheetById   (GetIdSheet EnameSheet)))
			;(setq DimSheet   (BoundingBoxLstEname (list  EnameRule EnameBlock EnameSheet)))
			(setq DimSheet   (BoundingBoxLstEname (list EnameBlock EnameSheet)))
			(setq Width      (+ (abs (- (car  (car DimSheet))   (car  (cadr DimSheet)))) (* 2.0 MarginAround)))
			(setq Height     (+ (abs (- (cadr (caddr DimSheet)) (cadr (cadr DimSheet)))) (* 2.0 MarginAround)))
			(setq Center     (div (car (car DimSheet)) (cadr (car DimSheet)) (car (caddr DimSheet)) (cadr (caddr DimSheet)) 1))
			(setq Rtn		 (list (list (car (car Center)) (cadr (car Center))) Width Height))
		)
	)
	Rtn
)
;
(defun EnameBomShapeToDataView (EnameBomShape / MarginAround DimBom Width Height Center Rtn)

	(if EnameBomShape
		(progn
			(setq MarginAround 3.0)
			(setq DimBom     (BoundingBoxLstEname (list EnameBomShape)))
			(setq Width      (+ (abs (- (car  (car DimBom))   (car  (cadr DimBom)))) (* 2.0 MarginAround)))
			(setq Height     (+ (abs (- (cadr (caddr DimBom)) (cadr (cadr DimBom)))) (* 2.0 MarginAround)))
			(setq Center     (div (car (car DimBom)) (cadr (car DimBom)) (car (caddr DimBom)) (cadr (caddr DimBom)) 1))
			(setq Rtn		 (list (list (car (car Center)) (cadr (car Center))) Width Height))
		)
	)
	Rtn
)
;
(defun CopyToLayout (LstEname LayoutName / aDoc LayoutCollection MoveObject itm VarVariant Rtn)

	(if (and LstEname LayoutName)
		(progn
			(setq aDoc	   			(vla-get-activedocument (vlax-get-acad-object)))
			(setq LayoutCollection 	(vla-get-layouts adoc))
			(setq MoveObject 		(mapcar 'vlax-ename->vla-object LstEname))
			
			; Copy entity ----------------------
			
			;(foreach itm MoveObject
				(setq VarVariant(vlax-variant-value 
									(vla-copyobjects aDoc 
											(vlax-make-variant 
													(vlax-safearray-fill 
															(vlax-make-safearray vlax-vbObject 
																	(cons 0 (1- (length MoveObject)))) MoveObject)) 
																							(vla-get-block (vla-item LayoutCollection LayoutName)))))
																							
				;(setq Rtn (append Rtn (mapcar 'vlax-vla-object->ename (vlax-safearray->list VarVariant))))
				(setq Rtn (mapcar 'vlax-vla-object->ename (vlax-safearray->list VarVariant)))
			;)
		)
	)
	Rtn
)	
;
