(defun LoadOpenDcl (Path)
	(if Path
		(progn
			(MyLoad (strcat Path "\\OpenDcl\\EasyCutOpenDcl.lsp" ))
			(LoadRuntimeOpenDcl)
			(PrgBr NfileLsp$)
		)
	)
	(princ)
)

