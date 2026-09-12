;;; ================================================================
;;; PSDIAG.LSP
;;; ================================================================
;;; PowerShell / WScript.Shell compatibility diagnostic
;;;
;;; Comando:
;;;     PSDIAG
;;;
;;; API:
;;;     (PSDIAG:GetPowerShellPrefix)
;;;     (PSDIAG:GetPowerShellCommand)
;;;     (PSDIAG:GetPowerShellPath)
;;;     (PSDIAG:GetMode)
;;;     (PSDIAG:RunPowerShell FilePs TypeExe (list Arg1 Arg2 ...)) 
;;;     (PSDIAG:RunPowerShell "C:\\EasyCutNesting Beta\\Gui\\EasyCutViewer.ps1" 2 (list "C:\\EasyCutNesting Beta\\Gui\\EasyCutViewer.ps1"))
;;;
;;; IMPORTANTE:
;;; PSDIAG esegue solamente test.
;;; Non modifica permanentemente alcuna Execution Policy.
;;;
;;; I test PowerShell vengono eseguiti in modalita' nascosta.
;;; ================================================================
;;; ================================================================
;;; VARIABILI GLOBALI
;;; ================================================================
(setq *psdiag-report* nil)
(setq *psdiag-config* nil)
;; NIL = test reale
(setq *psdiag-simulation* nil)

;;; ================================================================
;;; REPORT
;;; ================================================================
(defun psdiag:add (txt)
	(setq *psdiag-report*
		(append
			*psdiag-report*
			(list txt)
		)
	)
)
;
;
(defun psdiag:result (label value)
	(psdiag:add (strcat label " : " value))
)
;;; ================================================================
;;; QUOTE POWERSHELL
;;; ================================================================
(defun psdiag:ps-quote (s)
	(strcat "'" (vl-string-subst "''" "'" s) "'")
)
;;; ================================================================
;;; NOME FILE
;;; ================================================================
(defun psdiag:get-filename (path)
	(strcat
		(vl-filename-base path)
		(vl-filename-extension path)
	)
)
;;; ================================================================
;;; FILE ESISTENTE
;;; ================================================================
(defun psdiag:file-exists (file)
	(if
		(and file (= (type file) 'STR) (findfile file))
		T
		nil
	)
)
;;; ================================================================
;;; TEMP NAME
;;; ================================================================
(defun psdiag:temp-name (prefix ext)
	(strcat (getvar "TEMPPREFIX") prefix "_" (itoa (fix (getvar "MILLISECS"))) ext)
)
;;; ================================================================
;;; LETTURA FILE TESTO
;;; ================================================================
(defun psdiag:read-file (file / f line result)

	(setq result "")
	(if	(setq f (open file "r"))
		(progn
			(while
				(setq line (read-line f))
				(setq result (strcat result	line "\r\n"))
			)
			(close f)
		)
	)
	result
)
;;; ================================================================
;;; CREAZIONE FILE TESTO
;;; ================================================================
(defun psdiag:write-file (file text / f)

	(setq f (open file "w"))

	(if f
		(progn
			(write-line text f)
			(close f)
			T
		)
		nil
	)
)
;;; ================================================================
;;; CREA SCRIPT POWERSHELL DI TEST
;;; ================================================================
(defun MakeTestPS (LogPath PathTest FileTest FilePs OutFile ErrFile / wf copiedName)
	(setq copiedName (psdiag:get-filename FileTest))
	(setq wf (open FilePs "w"))
	(if wf
		(progn
			;; ------------------------------------------------------------
			;; HEADER
			;; ------------------------------------------------------------
			(write-line	"$ErrorActionPreference = \"Stop\""  wf)
			;; ------------------------------------------------------------
			;; OUTPUT FILES
			;; ------------------------------------------------------------
			(write-line (strcat "$OutFile = " (psdiag:ps-quote OutFile)) wf)
			(write-line (strcat "$ErrFile = " (psdiag:ps-quote ErrFile)) wf)
			;; ------------------------------------------------------------
			;; FUNZIONE OUTPUT
			;; ------------------------------------------------------------
			(write-line "function Write-DiagOutput($Text) {" wf)
			(write-line "    Add-Content -LiteralPath $OutFile -Value $Text -Encoding UTF8"  wf)
			(write-line "}" wf)
			;; ------------------------------------------------------------
			;; START
			;; ------------------------------------------------------------
			(write-line "try {" wf)
			(write-line "    Write-DiagOutput \"PSDIAG_PS1_STARTED\"" wf)
			;; ------------------------------------------------------------
			;; DIRECTORY
			;; ------------------------------------------------------------
			(write-line (strcat "    New-Item -Path " (psdiag:ps-quote PathTest) " -ItemType Directory -Force -ErrorAction Stop | Out-Null") wf)
			(write-line "    Write-DiagOutput \"PSDIAG_DIRECTORY_OK\"" wf)
			;; ------------------------------------------------------------
			;; COPY
			;; ------------------------------------------------------------
			(write-line (strcat "    Copy-Item -Path " (psdiag:ps-quote FileTest) " -Destination " (psdiag:ps-quote PathTest) " -Force -ErrorAction Stop") wf)
			(write-line "    Write-DiagOutput \"PSDIAG_COPY_OK\"" wf)
			;; ------------------------------------------------------------
			;; VERIFY
			;; ------------------------------------------------------------
			(write-line (strcat "    $CopiedFile = Join-Path " (psdiag:ps-quote PathTest) " " (psdiag:ps-quote copiedName)) wf)
			(write-line "    if (-not (Test-Path -LiteralPath $CopiedFile -PathType Leaf)) {"  wf)
			(write-line "        throw \"File copiato ma non trovato: $CopiedFile\"" wf)
			(write-line "    }" wf)
			(write-line "    Write-DiagOutput \"PSDIAG_VERIFY_OK\"" wf)
			;; ------------------------------------------------------------
			;; READ
			;; ------------------------------------------------------------
			(write-line "    $Content = Get-Content -LiteralPath $CopiedFile -Raw -ErrorAction Stop" wf)
			(write-line "    if (-not $Content.Contains('PSDIAG_FILE_TEST_OK')) {" wf)
			(write-line "        throw \"Contenuto del file non corretto\"" wf)
			(write-line "    }" wf)
			(write-line "    Write-DiagOutput \"PSDIAG_READ_OK\"" wf)
			;; ------------------------------------------------------------
			;; SUCCESS
			;; ------------------------------------------------------------
			(write-line "    Write-DiagOutput \"PSDIAG_SUCCESS\"" wf)
			;; ------------------------------------------------------------
			;; CLEANUP
			;; ------------------------------------------------------------
			(write-line (strcat "    Remove-Item -LiteralPath " (psdiag:ps-quote PathTest) " -Recurse -Force -ErrorAction Stop") wf)
			(write-line "    Write-DiagOutput \"PSDIAG_CLEANUP_OK\"" wf)
			;; ------------------------------------------------------------
			;; EXIT 0
			;; ------------------------------------------------------------
			(write-line "    exit 0" wf)
			;; ------------------------------------------------------------
			;; CATCH
			;; ------------------------------------------------------------
			(write-line "}" wf)
			(write-line "catch {" wf)
			(write-line "    $Timestamp = Get-Date -Format \"yyyy-MM-dd HH:mm:ss\"" wf)
			(write-line "    $ErrorMessage = \"[$Timestamp] ERRORE: $($_.Exception.Message)\"" wf)
			(write-line (strcat "    Add-Content -LiteralPath " (psdiag:ps-quote ErrFile) " -Value $ErrorMessage -Encoding UTF8") wf)
			(write-line "    exit 1" wf)
			(write-line "}" wf)
			(close wf)
			FilePs
		)
		nil
	)
)
;;; ================================================================
;;; TROVA POWERSHELL.EXE
;;; ================================================================
(defun psdiag:get-powershell (shell / ps)

	(setq ps (vl-catch-all-apply 'vlax-invoke-method 
								(list shell 'ExpandEnvironmentStrings "%WINDIR%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe")))

	(if (and (not (vl-catch-all-error-p ps))
			(psdiag:file-exists ps)
		)
		ps
		nil
	)
)
;;; ================================================================
;;; PREFISSO POWERSHELL
;;; ================================================================
(defun psdiag:make-prefix (ps mode / policy)
	(setq policy
		(cond
			;; A - STANDARD
			((= mode "A")
				""
			)
			;; B - BYPASS
			((= mode "B")
				"-ExecutionPolicy Bypass "
			)
			;; C - UNRESTRICTED
			((= mode "C")
				"-ExecutionPolicy Unrestricted "
			)
			;; D - REMOTESIGNED
			((= mode "D")
				"-ExecutionPolicy RemoteSigned "
			)
			;; E - ALLSIGNED
			((= mode "E")
				"-ExecutionPolicy AllSigned "
			)
			;; F - RESTRICTED
			((= mode "F")
				"-ExecutionPolicy Restricted "
			)
			(T
				""
			)
		)
	)
	(strcat "\"" ps "\" " "-NoLogo " "-NoProfile " policy "-WindowStyle Hidden " "-File")
)
;;; ================================================================
;;; COMMAND COMPLETO
;;; ================================================================
(defun psdiag:make-command (ps script mode)
	(strcat (psdiag:make-prefix ps mode) " " "\"" script "\"")
)
;;; ================================================================
;;; ESECUZIONE NASCOSTA CON WScript.Shell.Run
;;; ================================================================
;;; WindowStyle = 0
;;; WaitOnReturn = TRUE
;;; ================================================================
(defun psdiag:run-hidden (shell command / result)
	(setq result (vl-catch-all-apply 'vlax-invoke-method
									(list shell 'Run command 0 :vlax-true)))
	(if (vl-catch-all-error-p result)
		nil
		result
	)
)
;;; ================================================================
;;; TEST MODALITA'
;;; ================================================================
(defun psdiag:test-mode (shell ps script mode OutFile ErrFile / cmd exitcode stdout stderr result)
	;; --------------------------------------------------------------\
	;; SIMULAZIONE
	;; --------------------------------------------------------------
	(if (and (= *psdiag-simulation* "A-FAIL-B-PASS") (= mode "A"))
		(progn
			(psdiag:add "  [SIMULAZIONE] TEST A forzato a FAIL") (list 1 "" "PSDIAG_SIMULATED_A_FAIL")
		)
		;; ------------------------------------------------------------
		;; TEST REALE
		;; ------------------------------------------------------------
		(progn
			;; ----------------------------------------------------------
			;; Pulizia output precedente
			;; ----------------------------------------------------------
			(if (psdiag:file-exists OutFile) (vl-file-delete OutFile))
			(if (psdiag:file-exists ErrFile) (vl-file-delete ErrFile))
			;; ----------------------------------------------------------
			;; Comando
			;; ----------------------------------------------------------
			(setq cmd (psdiag:make-command ps script mode))
			;; ----------------------------------------------------------
			;; Esecuzione nascosta
			;; ----------------------------------------------------------
			(setq exitcode (psdiag:run-hidden shell cmd))
			(if (null exitcode)
				(setq exitcode -1)
			)
			;; ----------------------------------------------------------
			;; Lettura output
			;; ----------------------------------------------------------
			(setq stdout (if (psdiag:file-exists OutFile)
							 (psdiag:read-file OutFile)
							  ""
						)
			)
			(setq stderr (if (psdiag:file-exists ErrFile)
							 (psdiag:read-file ErrFile)
							""
						)
			)
			;; ----------------------------------------------------------
			;; Risultato
			;; ----------------------------------------------------------
			(list
				exitcode
				stdout
				stderr
			)
		)
	)
)
;;; ================================================================
;;; VALIDAZIONE RISULTATO
;;; ================================================================

(defun psdiag:valid-result-p (result / stdout markers ok)
	(setq ok T)
	;; --------------------------------------------------------------
	;; EXIT CODE
	;; --------------------------------------------------------------
	(if (or	(null result)
			(/= 0 (nth 0 result))
		)
		(setq ok nil)
		(progn
			(setq stdout (nth 1 result))
			;; ----------------------------------------------------------
			;; MARKER
			;; ----------------------------------------------------------
			(setq markers '("PSDIAG_PS1_STARTED"
							"PSDIAG_DIRECTORY_OK"
							"PSDIAG_COPY_OK"
							"PSDIAG_VERIFY_OK"
							"PSDIAG_READ_OK"
							"PSDIAG_SUCCESS"
							"PSDIAG_CLEANUP_OK"
						)
			)
			(foreach marker markers
				(if  (not (vl-string-search marker stdout))
					(setq ok nil)
				)
			)
		)
	)
	ok
)
;;; ================================================================
;;; STAMPA RISULTATO TEST
;;; ================================================================
(defun psdiag:print-test-result (mode description result / exitcode valid)
	(psdiag:add "")
	(psdiag:add (strcat "TEST " mode " - " description))
	(if result
		(progn
			(setq exitcode (nth 0 result))
			(setq valid    (psdiag:valid-result-p result))
			(psdiag:add    (strcat "ExitCode : " (itoa exitcode)))
			(if valid
				(psdiag:add "RESULT   : PASS")
				(psdiag:add "RESULT   : FAIL")
			)
			;; ----------------------------------------------------------
			;; STDERR
			;; ----------------------------------------------------------
			(if (and (/= exitcode 0)
					 (/= "" (vl-string-trim " \t\r\n" (nth 2 result)))
				)
				(progn
					(psdiag:add  "StdErr :")
					(psdiag:add  (vl-string-trim " \t\r\n" (nth 2 result)))
				)
			)
		)
		(psdiag:add "RESULT   : PROCESS ERROR")
	)
)
;;; ================================================================
;;; SCRIVE REPORT
;;; ================================================================
(defun psdiag:write-report (file / f)

	(setq f (open file "w"))
	(if f 
		(progn
			(foreach line *psdiag-report*
				(write-line line f)
			)
			(close f)
			T
		)
		nil
	)
)
;;; ================================================================
;;; STAMPA REPORT
;;; ================================================================
(defun psdiag:print-report ()

	(princ "\n")
	(foreach line *psdiag-report*
		(princ "\n")
		(princ line)
	)
	(princ "\n")
)
;;; ================================================================
;;; COMANDO PRINCIPALE
;;; ================================================================
(defun PSDIAG (Verbose / shell ps script logps testdir sourcefile reportfile outfile
						 errfile f result results selected selectedPrefix selectedCommand
						 success policyCmd item)

	;; --------------------------------------------------------------
	;; INIT
	;; --------------------------------------------------------------
	(setq *psdiag-report* nil)
	(setq *psdiag-config* nil)
	(setq success T)
	(setq selected nil)
	(setq selectedPrefix nil)
	(setq selectedCommand nil)
	;; --------------------------------------------------------------
	;; TEMP FILES
	;; --------------------------------------------------------------
	(setq script 	 (psdiag:temp-name "PSDIAG" ".ps1"))
	(setq logps  	 (psdiag:temp-name "PSDIAG_PS" ".log"))
	(setq testdir 	 (strcat (getvar "TEMPPREFIX") "PSDIAG_TEST_" (itoa (fix (getvar "MILLISECS")))))
	(setq sourcefile (psdiag:temp-name "PSDIAG_SOURCE" ".txt"))
	(setq outfile    (psdiag:temp-name "PSDIAG_OUT" ".txt"))
	(setq errfile	 (psdiag:temp-name "PSDIAG_ERR" ".txt"))
	(setq reportfile (psdiag:temp-name "PSDIAG_REPORT" ".txt"))
	;; --------------------------------------------------------------
	;; HEADER
	;; --------------------------------------------------------------
	(psdiag:add "================================================")
	(psdiag:add " PSDIAG - POWERSHELL COMPATIBILITY TEST")
	(psdiag:add "================================================")
	(psdiag:add (strcat "AutoCAD : " (getvar "ACADVER")))
	(psdiag:add (strcat "TEMP    : " (getvar "TEMPPREFIX")))
	;; --------------------------------------------------------------
	;; WSCRIPT.SHELL
	;; --------------------------------------------------------------
	(setq shell (vl-catch-all-apply 'vlax-create-object (list "WScript.Shell")))
	(if	(vl-catch-all-error-p shell)
		(progn
			(psdiag:result "WScript.Shell" "FAIL")
			(psdiag:add (vl-catch-all-error-message shell))
			(setq success nil)
		)
		(psdiag:result "WScript.Shell" "OK")
	)
	;; --------------------------------------------------------------
	;; CONTINUA
	;; --------------------------------------------------------------
	(if shell
		(progn
			;; ----------------------------------------------------------
			;; POWERSHELL
			;; ----------------------------------------------------------
			(setq ps (psdiag:get-powershell shell))
			(if ps
				(progn
					(psdiag:result "powershell.exe" "OK")
					(psdiag:add (strcat "Path : " ps))
				)
				(progn
					(psdiag:result "powershell.exe" "FAIL")
					(setq success nil)
				)
			)
			;; ----------------------------------------------------------
			;; FILE SORGENTE
			;; ----------------------------------------------------------
			(if ps
				(progn
					(setq f (open sourcefile "w"))
					(if f
						(progn
							(write-line "PSDIAG_FILE_TEST_OK" f)
							(close f)
							(psdiag:result "File sorgente" "OK")
						)
						(progn
							(psdiag:result "File sorgente" "FAIL")
							(setq success nil)
						)
					)
				)
			)
			;; ----------------------------------------------------------
			;; CREA SCRIPT
			;; ----------------------------------------------------------
			(if ps
				(if (MakeTestPS logps testdir sourcefile script outfile errfile)
					(psdiag:result "Creazione script PS1" "OK")
					(progn
						(psdiag:result "Creazione script PS1" "FAIL")
						(setq success nil)
					)
				)
			)
			;; ----------------------------------------------------------
			;; EXECUTION POLICY
			;; ----------------------------------------------------------
			(if ps
				(progn
					(setq policyCmd (strcat "\""
											ps
											"\" "
											"-NoLogo "
											"-NoProfile "
											"-WindowStyle Hidden "
											"-Command "
											"\"Get-ExecutionPolicy -List | Format-Table -AutoSize\""
									)
					)
					;; ------------------------------------------------------
					;; Anche questo viene eseguito nascosto.
					;; L'output viene catturato tramite file.
					;; ------------------------------------------------------
					(if (psdiag:write-file outfile "")
						(progn
							;; Per la lettura della policy usiamo comunque
							;; un piccolo file PS1 temporaneo.
							(setq policyCmd (strcat "\""
													ps
													"\" "
													"-NoLogo "
													"-NoProfile "
													"-WindowStyle Hidden "
													"-Command "
													"\"Get-ExecutionPolicy -List | Out-File -FilePath '"
													(vl-string-subst "''" "'" outfile)
													"' -Encoding utf8\""
											)
							)
							(psdiag:run-hidden shell policyCmd)
							(psdiag:add "")
							(psdiag:add "================================================")
							(psdiag:add	" EXECUTION POLICY")
							(psdiag:add "================================================")
							(if (psdiag:file-exists outfile)
								(psdiag:add (vl-string-trim " \t\r\n" (psdiag:read-file outfile)))
								(psdiag:add "Impossibile leggere ExecutionPolicy.")
							)
						)
					)
				)
			)
			;; ----------------------------------------------------------
			;; TEST A-F
			;; ----------------------------------------------------------
			(if (and ps (psdiag:file-exists script))
				(progn
					(setq results nil)
					;; ======================================================
					;; A
					;; ======================================================
					(setq result  (psdiag:test-mode shell ps script "A" outfile errfile))
					(setq results (append results (list (list "A" result))))
					(psdiag:print-test-result "A" "STANDARD" result)
					;; ======================================================
					;; B
					;; ======================================================
					(setq result  (psdiag:test-mode shell ps script "B" outfile errfile))
					(setq results (append results (list (list "B" result))))
					(psdiag:print-test-result "B" "BYPASS" result)
					;; ======================================================
					;; C
					;; ======================================================
					(setq result  (psdiag:test-mode shell ps script "C" outfile errfile))
					(setq results (append results (list (list "C" result))))
					(psdiag:print-test-result "C" "UNRESTRICTED" result)
					;; ======================================================
					;; D
					;; ======================================================
					(setq result  (psdiag:test-mode shell ps script "D" outfile errfile))
					(setq results (append results (list (list "D" result))))
					(psdiag:print-test-result "D" "REMOTESIGNED" result)
					;; ======================================================
					;; E
					;; ======================================================
					(setq result  (psdiag:test-mode shell ps script "E" outfile errfile))
					(setq results (append results (list (list "E" result))))
					(psdiag:print-test-result "E" "ALLSIGNED" result)
					;; ======================================================
					;; F
					;; ======================================================
					(setq result  (psdiag:test-mode shell ps script "F" outfile errfile))
					(setq results (append results (list (list "F" result))))
					(psdiag:print-test-result "F" "RESTRICTED" result)
					;; ======================================================
					;; SELEZIONE
					;; ======================================================
					(foreach item results
						(if (and  (not selected) (nth 1 item) (psdiag:valid-result-p (nth 1 item)))
							(progn
								(setq selected         (car item))
								(setq selectedPrefix   (psdiag:make-prefix ps selected))
								(setq selectedCommand  (strcat selectedPrefix " " "\"" script "\""))
							)
						)
					)
					;; ------------------------------------------------------
					;; RISULTATO OPERATIVO
					;; ------------------------------------------------------
					(psdiag:add "")
					(psdiag:add "================================================")
					(psdiag:add " RISULTATO OPERATIVO")
					(psdiag:add "================================================")
					(if selected
						(progn
							(psdiag:add (strcat "Modalita' selezionata : " selected))
							(psdiag:add  "Prefisso PowerShell:")
							(psdiag:add  selectedPrefix)
							(psdiag:add  "Sintassi completa di test:")
							(psdiag:add  selectedCommand)
							;; --------------------------------------------------
							;; CONFIG
							;; --------------------------------------------------
							(setq *psdiag-config* (list	(cons "MODE"       selected)
														(cons "POWERSHELL" ps)
														(cons "PREFIX"     selectedPrefix)
														(cons "COMMAND"    selectedCommand)
													)
							)
						)
						(progn
							(psdiag:add  "NESSUNA MODALITA' HA SUPERATO IL TEST.")
							(setq success nil)
						)
					)
				)
				(setq success nil)
			)
			;; ----------------------------------------------------------
			;; RISULTATO FINALE
			;; ----------------------------------------------------------
			(psdiag:add "")
			(psdiag:add "================================================")
			(if success
				(psdiag:add " PSDIAG RESULT : PASS")
				(psdiag:add " PSDIAG RESULT : FAIL")
			)
			(psdiag:add "================================================")
			;; ----------------------------------------------------------
			;; RELEASE
			;; ----------------------------------------------------------
			(vl-catch-all-apply 'vlax-release-object (list shell))
		)
	)
	;; --------------------------------------------------------------
	;; REPORT
	;; --------------------------------------------------------------
	(psdiag:write-report reportfile)
	;; --------------------------------------------------------------
	;; STAMPA
	;; --------------------------------------------------------------
	(if Verbose
		(progn 
			(psdiag:print-report)
			(princ "")
			(princ "\nReport diagnostico:")
			(princ "\n")
			(princ reportfile)
			(princ)
		)
	)
	;; --------------------------------------------------------------
	;; CLEANUP
	;; --------------------------------------------------------------
	(foreach f (list sourcefile script logps outfile errfile)
		(if (psdiag:file-exists f)
			(vl-file-delete f)
		)
	)

)
;;; ================================================================
;;; API PUBBLICA
;;; ================================================================
;;; ------------------------------------------------
;;; Prefisso PowerShell
;;; ------------------------------------------------
(defun PSDIAG:GetPowerShellPrefix ()
	(cdr (assoc "PREFIX" *psdiag-config*))
)
;;; ------------------------------------------------
;;; Command completo dell'ultimo test
;;; ------------------------------------------------
(defun PSDIAG:GetPowerShellCommand ()
	(cdr (assoc "COMMAND" *psdiag-config*))
)
;;; ------------------------------------------------
;;; Percorso PowerShell
;;; ------------------------------------------------
(defun PSDIAG:GetPowerShellPath ()
	(cdr (assoc "POWERSHELL" *psdiag-config*))
)
;;; ------------------------------------------------
;;; Modalita' selezionata
;;; ------------------------------------------------
(defun PSDIAG:GetMode ()
	(cdr (assoc "MODE" *psdiag-config*))
)
;;; ================================================================
;;; ESECUZIONE SCRIPT POWERSHELL - HIDDEN
;;; ================================================================
;;; Utilizzo:
;;;
;;;     (setq result
;;;       (PSDIAG:RunPowerShell FilePs TypeExe (list arg1 arg2 ...))
;;;     )
;;;
;;; Restituisce:
;;;
;;;     ((EXITCODE . 0)
;;;      (STDOUT . "")
;;;      (STDERR . "")
;;;      (MODE . "A"))
;;;
;;; ================================================================
; esecuzione viewer powershell
; (PSDIAG:RunPowerShell "C:\\EasyCutNesting Beta\\Gui\\EasyCutViewer.ps1" 2 (list "C:\\EasyCutNesting Beta\\Gui\\EasyCutViewer.ps1"))
; test
(defun PSDIAG:TestExe (/ testps f result)
	(setq testps (strcat (getvar "TEMPPREFIX") "PSD_TEST.ps1"))
	(setq f (open testps "w"))
	(write-line "Write-Output 'RUNPOWERSHELL_OK'" f)
	(close f)
	(setq result (PSDIAG:RunPowerShell testps 1 nil))
	(princ result)
	(vl-file-delete testps)
	(princ)
)
;
;
(defun PSDIAG:RunPowerShell (FilePs TypeExe LstArg / shell prefix mode command exitcode err)

  ;; --------------------------------------------------------------
  ;; Verifica configurazione
  ;; --------------------------------------------------------------
	(if (or (null *psdiag-config*) (null FilePs) (not (psdiag:file-exists FilePs)))
		nil
		(progn
			(setq prefix (PSDIAG:GetPowerShellPrefix))
			(setq mode   (PSDIAG:GetMode))
			(if (or (null prefix) (null mode))
				nil
				(progn
					;; ------------------------------------------------------
					;; WScript.Shell
					;; ------------------------------------------------------
					(setq shell (vl-catch-all-apply 'vlax-create-object (list "WScript.Shell")))
					(if (vl-catch-all-error-p shell)
						nil
						(progn
							;; --------------------------------------------------
							;; COMMAND
							;; --------------------------------------------------
							(cond
								((= TypeExe 1)
									(setq command (strcat prefix " " "\"" FilePs "\""))
									(setq exitcode (vl-catch-all-apply 'vlax-invoke-method (list shell 'Run command 0 :vlax-true))) ;esecuzione modalita sincrona
								)
								((= TypeExe 2)
									(setq command (strcat prefix " " "\"" FilePs "\" " "\"" (nth 0 LstArg) "\""))
									(setq exitcode (vl-catch-all-apply 'vlax-invoke-method (list shell 'Run command 0 :vlax-false))) ;esecuzione modalita asincrona
								)
							)
							(if (vl-catch-all-error-p exitcode)
								(progn
									(setq err (vl-catch-all-error-message exitcode))
									(setq exitcode -1)
								)
								(setq err "")
							)
							;; --------------------------------------------------
							;; RELEASE
							;; --------------------------------------------------
							(vl-catch-all-apply 'vlax-release-object (list shell))
							;; --------------------------------------------------
							;; RESULT
							;; --------------------------------------------------
							(list (cons 'EXITCODE exitcode)
								  (cons 'STDOUT "")
								  (cons 'STDERR err)
								  (cons 'MODE mode)
							)
						)
					)
				)
			)
		)
	)
)
;