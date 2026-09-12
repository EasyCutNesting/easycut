(defun LoadDosLib (Path / ISX64
						  CADver arxlist DOSLibname a loadedAtStartup)
	;
	;
	(defun ISX64 (/ proc_arch) ;; from Owen Wengard
		(and
			(setq proc_arch (getenv "PROCESSOR_ARCHITECTURE"))
			(< 1 (strlen proc_arch))
			(eq "64" (substr proc_arch (1- (strlen proc_arch))))
		)
	)
	;
	; Main
	;
	(if Path
		(progn
			(setq CADver (substr (getvar "acadver") 1 2)) ;; i.e., "17", "18", etc.
			(setq arxlist (arx))
			(if (isX64)
				(setq DOSLibname (strcat "doslib" CADver "x64.arx"))
				(setq DOSLibname (strcat "doslib" CADver ".arx"))
			)
			(foreach a arxlist (if (equal a DOSLibname) (setq loadedAtStartup T) ))
			(if (not loadedAtStartup)
				(vl-cmdf "._arx" "_load" (findfile (strcat Path "\\DOSLib 9.0\\" DOSLibname)))
			)
		)
	)
	(princ)
)

