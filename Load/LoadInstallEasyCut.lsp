(defun LoadInstallEasyCut (Path)

	(if Path
		(progn
			(MyLoad (strcat Path "\\Load\\InstallEasyCut.lsp"))
			(PrgBr NfileLsp$)
		)
	)
	(princ)
)
