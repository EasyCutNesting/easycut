(defun LOADSQLITELSP (/ FN)

	(defun AcadPlatform (/ proc_arch str)
		(if (and (setq proc_arch (getenv "PROCESSOR_ARCHITECTURE"))
				 (< 1 (strlen proc_arch))
				 (eq "64" (substr proc_arch (1- (strlen proc_arch))))
			)
			(setq str "x64")
			(setq str "x32")
		)
		str
	)
	(if (= (substr (getvar "acadver") 6) "Bricscad")
		(progn
			(and (not (= 'EXRXSUBR (type dsql_query)))
				(setq FN (findfile (strcat "C:\\EasyCut\\SqLite\\test\\SQLiteLsp[1.4.1.20201103]\\SQLiteLspSrc\\SqliteLsp\\SQLiteBIN\\SQLiteLspv"
                                    (substr (getvar "_vernum") 1 2)
                                    (AcadPlatform)
                                    ".ARX"
                            )
                ))
				(arxload FN (strcat "\nError loading " FN))
			)
		)
		(progn
			(and (not (= 'EXRXSUBR (type dsql_query)))
				(setq FN (findfile (strcat "C:\\EasyCut\\SqLite\\test\\SQLiteLsp[1.4.1.20201103]\\SQLiteLspSrc\\SqliteLsp\\SQLiteBIN\\SQLiteLsp"
                                    (substr (getvar "acadver") 1 2)
                                    (AcadPlatform)
                                    ".ARX"
                            )
						)
				)
				(arxload FN (strcat "\nError loading " FN))
			)
			(if (not (= 'EXRXSUBR (type dsql_query)))
				(progn (dcl_messagebox
					   "Can't Find SQLiteLspXX.ARX, Make sure its loaded"
					   "Cancel"
					   2
					   2
				   )
				   (exit)
				)
			)
		)
	)
)