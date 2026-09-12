(defun DefCommand ()
	
	(setvar "pickstyle" 0)
	(setvar "cmdecho" 0)
	(if (findfile "aceattedit.arx")	(arxload "aceattedit.arx"))
	(command  "._undefine"  "_EATTEDIT")
	(command  "._undefine"  "_ATTEDIT")
	; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(defun C:EATTEDIT(/ ss Ename)

		(setq ss (ssget ":E:S:L" '((0 . "INSERT"))))
		(setq Ename  (cdr (assoc -1 (entget (ssname ss 0)))))
		(cond
			((= (CheckIfBlockShape Ename) T)
				(TcEasyCut Ename)
			)
			((= (CheckIfBlockSheet Ename) T)
				(TcEasyCut Ename)
			)
			(t 
				(command ".ACAD_Eattedit.eattedit" Ename)
			)
		) 
		(setq EnameDoubleClickGetInfo$ nil)
		(princ)
	)
	; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(defun C:ATTEDIT(/ ss Ename)

		(setq ss (ssget ":E:S:L" '((0 . "INSERT"))))
		(setq Ename  (cdr (assoc -1 (entget (ssname ss 0)))))
		
		(cond
			((= (CheckIfBlockShape Ename) T)
				(TcEasyCut Ename)
			)
			((= (CheckIfBlockSheet Ename) T)
				(TcEasyCut Ename)
			)
			(t 
				(command ".ACAD_Eattedit.eattedit" Ename)
			)
		) 
		(setq EnameDoubleClickGetInfo$ nil)
		(princ)
	) 
	; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
)
;
;
;
(defun c:commands ( / :setvars :main )

    ;;==========================================================================
    ;;  Commands.lsp
    ;;--------------------------------------------------------------------------
    ;;  \|//  1.02 2018-03-07
    ;;  |Oo|  © 2018 Michael Puckett Some Rights Reserved.
    ;;  |- |  mp@cadanalyst.org
    ;;--------------------------------------------------------------------------
    ;;  1.01  2018-03-05. MP. Initial code.
    ;;  1.02  2018-03-07. MP. Modularized.
    ;;--------------------------------------------------------------------------
   
    (defun :setvars ( lst )
        ;;  Send a cons-pair or cons-pairs lists of (varname . varvalue).
        ;;  eg (setq restore (ue2-setvars '((CMDECHO . 0)(REGENMODE 0))))
        ;;  Returns original values in the same cons-pair construct.
        ;;  >> ((CMDECHO . 1) (REGENMODE . 1))               
        (mapcar
            (function
                (lambda ( p / k r )
                    (setq r (cons (setq k (car p)) (vl-catch-all-apply 'getvar (list k))))
                    (vl-catch-all-apply 'setvar (list k (cdr p)))
                    r
                )
            )
            (if (vl-list-length lst)
                lst
                (list lst)
            )
        )
    )
   
    (defun :main ( / restore flag handle stream lst name )
   
        (setq restore
            (:setvars
               '(   (cmdecho     . 0)
                    (logfilemode . 1)
                    (qaflags     . 2)
                )
            )
        )

        (setq flag (strcat "START CAPTURE: " (rtos (getvar 'cdate) 2 8)))
        (princ (strcat "\n" flag))
        (command ".arx" "_commands")

        (setq handle (open (getvar 'logfilename) "r"))
        (while (setq stream (read-line handle))
            (setq lst (cons stream lst))
        )
        (close handle)
       
        (:setvars restore)
   
        (setq lst (cddr (member flag (reverse lst))))
        (while (eq "" (vl-string-trim " \t\n" (car lst)))
            (setq lst (cdr lst))
        )
       
        (setq
            name   (vl-filename-mktemp "commands.txt")
            handle (open name "w")
        )
        (foreach x lst (princ (strcat x "\n") handle))   
        (close handle)
    
		(EasyCutViewer name)
   
        (princ)
       
    )
   
    (:main)           

)
;
;
;
(defun c:Vars ( / :pad :matching-vars :get-spec :main )

    ;;==========================================================================
    ;;  Vars.lsp
    ;;--------------------------------------------------------------------------
    ;;  \|//  1.07 2018-03-07
    ;;  |Oo|  © 2018 Michael Puckett Some Rights Reserved.
    ;;  |- |  mp@cadanalyst.org
    ;;--------------------------------------------------------------------------
    ;;  1.01  2018-03-05. MP. Initial code.
    ;;  1.02  2018-03-05. MP. Apply constant width to var name column.
    ;;  1.03  2018-03-05. MP. Use getvar instead of capturing screen; no truncation.
    ;;  1.04  2018-03-06. MP. Improve speed: only initial run abuses the log file.
    ;;  1.05  2018-03-06. MP. Add undocumented vars.
    ;;  1.06  2018-03-06. MP. Flag vars in :undocumented that return nil.
    ;;  1.07  2018-03-07. MP. Fixed a missing local declaration.
    ;;--------------------------------------------------------------------------

    (if

        (null
            (vl-every
                (function (lambda (x) (eq 'str (type x))))
                (if (eq 'list (type *getvar-names*)) *getvar-names* '(0))
            )
        )

        ;;  Function get-var-names is defined locally but has and needs global
        ;;  scope. Don't understand why? <trump> Sad! </trump>.

        (defun get-var-names ( / :car-str :unique :undocumented :setvars :main )

            (defun :car-str ( text / lst )
                (substr
                    (setq text (strcase (vl-string-trim " \t\r\n" text)))
                    1
                    (-  (length (setq lst (vl-string->list text)))
                        (length (member 32 lst))
                    )
                )
            )

            (defun :unique ( lst / result )
                (foreach x lst
                    (or
                        (member x result)
                        (setq result (cons x result))
                    )
                )
                (reverse result)
            )

            ;;  Thanks to Owen Wengerd & the internet ...

            (defun :undocumented ( )
               '(   "_LINFO"                ;; Returns nil in 2018, may remove.
                    "_PKSER"
                    "_SERVER"
                    "_VERNUM"
                    "ADCSTATE"
                    "AECENABLEASSOCANCHOR"
                    "AECENABLESECTIONCLEANUP"
                    "AECVCOMPAREIGNOREHATCH"
                    "AECVCOMPAREIGNORETEXT"
                    "AECVCOMPARENEWCOLOR"
                    "AECVCOMPAREOLDCOLOR"
                    "AECVCOMPAREUNCHANGEDCOLOR"
                    "APBOX"
                    "AUXSTAT"
                    "AXISMODE"              ;; Returns nil in 2018, may remove.
                    "AXISUNIT"
                    "BS_BITS"               ;; Returns nil in 2018, may remove.
                    "CLEARTYPE"
                    "CPUTICKS"
                    "DBCSTATE"
                    "DBGLISTALL"            ;; Returns nil in 2018, may remove.
                    "EDITDELETIONEFFECT"    ;; Returns nil in 2018, may remove.
                    "ENTEXTS"
                    "ENTEXTS"
                    "ENTMODS"
                    "FILETABVISIBLE"
                    "FLATLAND"
                    "FORCE_PAGING"
                    "FORCE_PAGING"
                    "GLOBCHECK"
                    "ISFLIPARC"
                    "JWDEBUG"               ;; Returns nil in 2018, may remove.
                    "KESDEBUG"              ;; Returns nil in 2018, may remove.
                    "LAZYLOAD"
                    "LAZYLOAD"
                    "LENGTHENTYPE"
                    "MILLISECS"
                    "NFWSTATE"
                    "NODENAME"
                    "NOMUTT"
                    "OPMSTATE"
                    "OSNAPNODELEGACY"
                    "PHANDLE"
                    "POINTCLOUDEVENTLOG"
                    "POINTCLOUDPERFTRACK"
                    "POINTCLOUDPROGRESSIVEUPDATE"
                    "PRESELECTIONEFFECTTEST"
                    "PRESELECTIONNOTIFICATION"
                    "PRODUCT"
                    "PROGRAM"
                    "QAFLAGS"
                    "QAUCSLOCK"
                    "SHORTCUTMENU"
                    "SMJOURNAL"
                    "SMTHREADHOTMODE"
                    "SMUNFIXEDTRANSFORM"
                    "SPACESWITCH"
                )
            )

            (defun :setvars ( lst )
                ;;  Send a cons-pair or cons-pairs lists of (varname . varvalue).
                ;;  eg (setq restore (ue2-setvars '((CMDECHO . 0)(REGENMODE 0))))
                ;;  Returns original values in the same cons-pair construct.
                ;;  >> ((CMDECHO . 1) (REGENMODE . 1))               
                (mapcar
                    (function
                        (lambda ( p / k r )
                            (setq r (cons (setq k (car p)) (vl-catch-all-apply 'getvar (list k))))
                            (vl-catch-all-apply 'setvar (list k (cdr p)))
                            r
                        )
                    )
                    (if (vl-list-length lst)
                        lst
                        (list lst)
                    )
                )
            )

            (defun :main ( / restore flag handle stream lst )

                (setq restore
                    (:setvars
                       '(   (cmdecho     . 0)
                            (logfilemode . 1)
                            (qaflags     . 2)
                        )
                    )
                )

                (setq flag (strcat "START CAPTURE: " (rtos (getvar 'cdate) 2 8)))
                (princ (strcat "\n" flag))
                (command ".setvar" "_?" "*")

                (setq handle (open (getvar 'logfilename) "r"))
                (while (setq stream (read-line handle))
                    (setq lst (cons stream lst))
                )
                (close handle)

                (:setvars restore)

                (setq lst (cdr (member flag (reverse lst))))
                (while (eq "" (vl-string-trim " \t\n" (car lst)))
                    (setq lst (cdr lst))
                )

                (mapcar 'cadr
                    (vl-sort
                        (mapcar
                            (function (lambda (x) (list (strcase x t) x)))
                            (:unique
                                (append
                                    ;;  add any vars AutoCAD may not normally include
                                    (:undocumented)
                                    (mapcar ':car-str lst)
                                )
                            )
                        )
                        (function (lambda (a b) (< (car a) (car b))))
                    )
                )
            )

            ;;  The following is tempting but lisp cries because of the size of
            ;;  the list.
            ;;
            ;;      (eval (list 'defun 'get-var-names symbol nil (:main)))
            ;;
            ;;  The following isn't sexy but it's reliable as long as no one
            ;;  abuses the global:

            (setq *getvar-names* (:main))

            (defun get-var-names ( ) *getvar-names*)

            *getvar-names*

        )
    )

    (defun :pad ( text len )
        (while (< (strlen text) len)
            (setq text (strcat text " "))
        )
        text
    )

    (defun :matching-vars ( spec )
        (vl-remove-if-not
            (function (lambda (x) (wcmatch x spec)))
            (get-var-names)
        )
    )

    (defun :get-spec ( / spec )
        (if
            (eq ""
                (setq spec
                    (strcase
                        (getstring "\nEnter search pattern <*>: ")
                    )
                )
            )
            "*"
            spec
        )
    )

    (defun :main ( / spec vars len name handle )

        (cond

            (   (null (setq vars (:matching-vars (setq spec (:get-spec)))))
                (princ (strcat "\nNo variables matched pattern '" spec "'."))
            )

            (   (setq
                    len    (1+ (apply 'max (mapcar 'strlen vars)))
                    name   (vl-filename-mktemp "vars.txt")
                    handle (open name "w")
                )

                (princ (strcat "Variables matching pattern '" spec "':\n\n") handle)

                (foreach var vars
                    (princ
                        (strcat
                            (:pad var len)
                            (vl-prin1-to-string (getvar var))
                            "\n"
                        )
                        handle
                    )
                )

                (close handle)
				(EasyCutViewer name)

            )

        )

        (princ)

    )

    (:main)

)
;
;
;
(defun ExistFunction (NameFunction)
	(if NameFunction
		(car (atoms-family 1 (list NameFunction)))
	)
)

