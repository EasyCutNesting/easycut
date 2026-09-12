(defun LoadSqLite (Path)
	(if Path
		(progn
			(MyLoad (strcat Path "\\SqLite\\EasyCutSQLite.lsp" ))
			(LoadRuntimeSqLiteLsp)
			(PrgBr NfileLsp$)
		)
	)
	(princ)
)

