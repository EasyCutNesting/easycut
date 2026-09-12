(defun FormsOpenFileDialog (/ FilePs Result StdOut)

    (setq FilePs (strcat (getenv "TEMP") "\\FormsOpenFileDialog.ps1"))
    (if (findfile FilePs)
        (progn
            (setq Result (PSDIAG:RunPowerShell FilePs 3 nil))
            (if (= 0 (cdr (assoc 'EXITCODE Result)))
                (progn
                    (setq StdOut (cdr (assoc 'STDOUT Result)))
                    (if (and StdOut (/= StdOut ""))
                        StdOut
                        nil
                    )
                )
                nil
            )
        )
        nil
    )
)