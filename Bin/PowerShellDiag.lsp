;;; ================================================================
;;; PowerShellDiag.LSP
;;; ================================================================
;;; PowerShell / WScript.Shell compatibility diagnostic
;;;
;;; MODIFICA:
;;; La configurazione diagnostica viene ora valorizzata anche quando
;;; PowerShell e' presente ma nessuna modalita' di esecuzione supera
;;; il test.
;;;
;;; STATUS:
;;;   READY            = PowerShell utilizzabile
;;;   BLOCKED          = powershell.exe presente ma nessuna modalita'
;;;                      ha superato il test
;;;   NO_POWERSHELL    = powershell.exe non trovato
;;;   NO_WSCRIPT_SHELL = WScript.Shell non disponibile
;;;
;;; API:
;;;   (PSDIAG:GetPowerShellPrefix)
;;;   (PSDIAG:GetPowerShellCommand)
;;;   (PSDIAG:GetPowerShellPath)
;;;   (PSDIAG:GetMode)
;;;   (PSDIAG:GetStatus)
;;;   (PSDIAG:RunPowerShell FilePs TypeExe (list Arg1 Arg2 ...))
;;;
;;;                    PSDIAG
;;;                       │
;;;             ┌─────────┴─────────┐
;;;             │                   │
;;;       WScript OK          WScript FAIL
;;;             │                   │
;;;             │             NO_WSCRIPT_SHELL
;;;             │
;;;       PowerShell?
;;;        /         \
;;;      NO           SI
;;;      │             │
;;;NO_POWERSHELL     test A-F
;;;                    │
;;;              ┌─────┴─────┐
;;;              │           │
;;;            PASS         FAIL
;;;              │           │
;;;            READY       BLOCKED
;;; ================================================================
(setq *psdiag-report* nil)
(setq *psdiag-config* nil)
(setq *psdiag-simulation* nil)
;;; ================================================================
;;; COMANDO PRINCIPALE
;;; ================================================================
(defun PSDIAG (Verbose / psdiag:test-mode
						 psdiag:run-hidden
						 psdiag:temp-name
						 psdiag:read-file
						 psdiag:write-file
						 psdiag:add
						 psdiag:result
						 psdiag:MakeTestPS
						 psdiag:ps-quote
						 psdiag:get-filename
						 psdiag:make-prefix
						 psdiag:make-command
						 psdiag:valid-result-p
						 psdiag:print-test-result
						 psdiag:write-report
						 psdiag:print-report
						 psdiag:Get-PowerShell
						 psdiag:file-exists
						 shell ps script logps testdir sourcefile
						 reportfile outfile errfile f result results
						 selected selectedPrefix selectedCommand
						 success policyCmd item status)


	(defun psdiag:test-mode	(shell ps script mode OutFile ErrFile / cmd exitcode stdout stderr)
		(if (and (= *psdiag-simulation* "A-FAIL-B-PASS") (= mode "A"))
			(progn
				(psdiag:add " [SIMULAZIONE] TEST A forzato a FAIL")
				(list 1 "" "PSDIAG_SIMULATED_A_FAIL")
			)
			(progn
				(if (psdiag:file-exists OutFile)
					(vl-file-delete OutFile)
				)
				(if (psdiag:file-exists ErrFile)
					(vl-file-delete ErrFile)
				)
				(setq cmd (psdiag:make-command ps script mode))
				(setq exitcode (psdiag:run-hidden shell cmd))
				(if (null exitcode)
					(setq exitcode -1)
				)
				(setq stdout (if (psdiag:file-exists OutFile) (psdiag:read-file OutFile) ""))
				(setq stderr (if (psdiag:file-exists ErrFile) (psdiag:read-file ErrFile) ""))
				(list exitcode stdout stderr)
			)
		)
	)
	;
	(defun psdiag:run-hidden (shell command / result)
		(setq result (vl-catch-all-apply 'vlax-invoke-method (list shell 'Run command 0 :vlax-true)))
		(if (vl-catch-all-error-p result)
			nil
			result
		)
	)
	;
	(defun psdiag:temp-name (prefix ext)
		(strcat
			(getvar "TEMPPREFIX")
			prefix "_"
			(itoa (fix (getvar "MILLISECS")))
			ext
		)
	)
	;
	(defun psdiag:read-file (file / f line result)
		(setq result "")
		(if (setq f (open file "r"))
			(progn
				(while (setq line (read-line f))
					(setq result (strcat result line "\r\n"))
				)
				(close f)
			)
		)
		result
	)
	;
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
	;
	(defun psdiag:add (txt)
		(setq *psdiag-report*
			(append *psdiag-report* (list txt)))
	)
	;
	(defun psdiag:result (label value)
	  (psdiag:add (strcat label " : " value))
	)
	;
	(defun psdiag:MakeTestPS (LogPath PathTest FileTest FilePs OutFile ErrFile / wf copiedName)

		(setq copiedName (psdiag:get-filename FileTest))
		(setq wf (open FilePs "w"))
		(if wf
			(progn
				(write-line "$ErrorActionPreference = \"Stop\"" 																							wf)
				(write-line (strcat "$OutFile = " (psdiag:ps-quote OutFile)) 																				wf)
				(write-line (strcat "$ErrFile = " (psdiag:ps-quote ErrFile)) 																				wf)
				(write-line "function Write-DiagOutput($Text) {" 																							wf)
				(write-line "  Add-Content -LiteralPath $OutFile -Value $Text -Encoding UTF8" 																wf)
				(write-line "}" 																															wf)
				(write-line "try {" 																														wf)
				(write-line "  Write-DiagOutput \"PSDIAG_PS1_STARTED\"" 																					wf)
				(write-line (strcat "  New-Item -Path " (psdiag:ps-quote PathTest) " -ItemType Directory -Force -ErrorAction Stop | Out-Null") 				wf)
				(write-line "  Write-DiagOutput \"PSDIAG_DIRECTORY_OK\""	 																				wf)
				(write-line (strcat "  Copy-Item -Path " (psdiag:ps-quote FileTest) " -Destination " (psdiag:ps-quote PathTest) " -Force -ErrorAction Stop") wf)
				(write-line "  Write-DiagOutput \"PSDIAG_COPY_OK\"" 																						wf)
				(write-line (strcat "  $CopiedFile = Join-Path " (psdiag:ps-quote PathTest) " " (psdiag:ps-quote copiedName)) 								wf)
				(write-line "  if (-not (Test-Path -LiteralPath $CopiedFile -PathType Leaf)) {" 															wf)
				(write-line "    throw \"File copiato ma non trovato: $CopiedFile\"" 																		wf)
				(write-line "  }" 																															wf)
				(write-line "  Write-DiagOutput \"PSDIAG_VERIFY_OK\"" 																						wf)
				(write-line "  $Content = Get-Content -LiteralPath $CopiedFile -Raw -ErrorAction Stop" 														wf)
				(write-line "  if (-not $Content.Contains('PSDIAG_FILE_TEST_OK')) {" 																		wf)
				(write-line "    throw \"Contenuto del file non corretto\"" 																				wf)
				(write-line "  }" 																															wf)
				(write-line "  Write-DiagOutput \"PSDIAG_READ_OK\"" 																						wf)
				(write-line "  Write-DiagOutput \"PSDIAG_SUCCESS\"" 																						wf)
				(write-line (strcat "  Remove-Item -LiteralPath " (psdiag:ps-quote PathTest) " -Recurse -Force -ErrorAction Stop") 							wf)
				(write-line "  Write-DiagOutput \"PSDIAG_CLEANUP_OK\"" 																						wf)
				(write-line "  exit 0" 																														wf)
				(write-line "}" 																															wf)
				(write-line "catch {" 																														wf)
				(write-line "  $Timestamp = Get-Date -Format \"yyyy-MM-dd HH:mm:ss\"" 																		wf)
				(write-line "  $ErrorMessage = \"[$Timestamp] ERRORE: $($_.Exception.Message)\"" 															wf)
				(write-line (strcat "  Add-Content -LiteralPath " (psdiag:ps-quote ErrFile) " -Value $ErrorMessage -Encoding UTF8") 						wf)
				(write-line "  exit 1" 																														wf)
				(write-line "}" 																															wf)
				(close wf)
				FilePs
			)
			nil
		)
	)
	;
	(defun psdiag:ps-quote (s)
		(strcat "'" (vl-string-subst "''" "'" s) "'")
	)
	;
	(defun psdiag:get-filename (path)
		(strcat
			(vl-filename-base path)
			(vl-filename-extension path)
		)
	)
	;
	(defun psdiag:make-prefix (ps mode / policy)
		(setq policy (cond
						((= mode "A") "")
						((= mode "B") "-ExecutionPolicy Bypass ")
						((= mode "C") "-ExecutionPolicy Unrestricted ")
						((= mode "D") "-ExecutionPolicy RemoteSigned ")
						((= mode "E") "-ExecutionPolicy AllSigned ")
						((= mode "F") "-ExecutionPolicy Restricted ")
						(T "")
					)
		)
		(strcat "\"" ps "\" " "-NoLogo " "-NoProfile " policy "-WindowStyle Hidden " "-File")
	)
	;
	(defun psdiag:make-command (ps script mode)
		(strcat (psdiag:make-prefix ps mode) " \"" script "\"")
	)
	;
	(defun psdiag:valid-result-p (result / stdout markers ok)
		(setq ok T)
		(if (or (null result) (/= 0 (nth 0 result)))
			(setq ok nil)
			(progn
				(setq stdout (nth 1 result))
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
					(if (not (vl-string-search marker stdout))
						(setq ok nil)
					)
				)
			)
		)
		ok
	)
	;
	(defun psdiag:print-test-result (mode description result / exitcode valid)
		(psdiag:add "")
		(psdiag:add (strcat "TEST " mode " - " description))
		(if result
			(progn
				(setq exitcode (nth 0 result))
				(setq valid (psdiag:valid-result-p result))
				(psdiag:add (strcat "ExitCode : " (itoa exitcode)))
				(if valid
					(psdiag:add "RESULT : PASS")
					(psdiag:add "RESULT : FAIL")
				)
				(if (and (/= exitcode 0) (/= "" (vl-string-trim " \t\r\n" (nth 2 result))))
					(progn
						(psdiag:add "StdErr :")
						(psdiag:add (vl-string-trim " \t\r\n" (nth 2 result)))
					)
				)
			)
			(psdiag:add "RESULT : PROCESS ERROR")
		)
	)
	;
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
	;
	(defun psdiag:file-exists (file)
		(if	(and file (= (type file) 'STR) (findfile file))
			T
			nil
		)
	)
	;
	(defun psdiag:print-report ()
		(princ "\n")
		(foreach line *psdiag-report*
			(princ "\n")
			(princ line)
		)
		(princ "\n")
	)
	;
	(defun psdiag:Get-PowerShell (/ ps windir)
		(setq windir (getenv "WINDIR"))
		(if windir
			(progn
				(setq ps (strcat	windir "\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"))
				(if (psdiag:file-exists ps)
					ps
					nil
				)
			)
			nil
		)
	)
	;
	; Main
	;
	(setq *psdiag-report* nil)
	(setq *psdiag-config* nil)

	(setq success T)
	(setq selected nil)
	(setq selectedPrefix nil)
	(setq selectedCommand nil)
	(setq status "UNKNOWN")

	(setq script     (psdiag:temp-name "PSDIAG" ".ps1"))
	(setq logps      (psdiag:temp-name "PSDIAG_PS" ".log"))
	(setq testdir    (strcat (getvar "TEMPPREFIX") "PSDIAG_TEST_" (itoa (fix (getvar "MILLISECS")))))
	(setq sourcefile (psdiag:temp-name "PSDIAG_SOURCE" ".txt"))
	(setq outfile    (psdiag:temp-name "PSDIAG_OUT" ".txt"))
	(setq errfile    (psdiag:temp-name "PSDIAG_ERR" ".txt"))
	(setq reportfile (psdiag:temp-name "PSDIAG_REPORT" ".txt"))

	(psdiag:add "================================================")
	(psdiag:add " PSDIAG - POWERSHELL COMPATIBILITY TEST")
	(psdiag:add "================================================")
	(psdiag:add (strcat "AutoCAD : " (getvar "ACADVER")))
	(psdiag:add (strcat "TEMP    : " (getvar "TEMPPREFIX")))
	;;; ---------------------------------------------------------------
	;;; WScript.Shell
	;;; ---------------------------------------------------------------
	(setq shell (vl-catch-all-apply 'vlax-create-object (list "WScript.Shell")))
	(if (vl-catch-all-error-p shell)
		(progn
			(psdiag:result "WScript.Shell" "FAIL")
			(psdiag:add (vl-catch-all-error-message shell))
			(setq status "NO_WSCRIPT_SHELL")
			(setq success nil)
		)
		(progn
			(psdiag:result "WScript.Shell" "OK")
			;;; -------------------------------------------------------------
			;;; PowerShell
			;;; -------------------------------------------------------------
			(setq ps (psdiag:get-powershell))
			(if ps
				(progn
					(psdiag:result "powershell.exe" "OK")
					(psdiag:add (strcat "Path : " ps))
				)
				(progn
					(psdiag:result "powershell.exe" "FAIL")
					(psdiag:add "Percorso standard non trovato.")
					(setq status "NO_POWERSHELL")
					(setq success nil)
				)
			)
			;;; -------------------------------------------------------------
			;;; File sorgente
			;;; -------------------------------------------------------------
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
			;;; -------------------------------------------------------------
			;;; Creazione script PS1
			;;; -------------------------------------------------------------
			(if ps
				(if (psdiag:MakeTestPS logps testdir sourcefile script outfile errfile)
					(psdiag:result "Creazione script PS1" "OK")
					(progn
						(psdiag:result "Creazione script PS1" "FAIL")
						(setq success nil)
					)
				)
			)
			;;; -------------------------------------------------------------
			;;; Execution Policy
			;;; -------------------------------------------------------------
			(if ps
				(progn
					(if (psdiag:write-file outfile "")
						(progn
							(setq policyCmd (strcat "\"" ps "\" " "-NoLogo " "-NoProfile " "-WindowStyle Hidden " "-Command "
													"\"Get-ExecutionPolicy -List | Out-File -FilePath '" (vl-string-subst "''" "'" outfile)
													"' -Encoding utf8\""
											)
							)
							(psdiag:run-hidden shell policyCmd)
							(psdiag:add "")
							(psdiag:add "================================================")
							(psdiag:add " EXECUTION POLICY")
							(psdiag:add "================================================")
							(if (psdiag:file-exists outfile)
								(psdiag:add (vl-string-trim " \t\r\n" (psdiag:read-file outfile)))
								(psdiag:add "Impossibile leggere ExecutionPolicy.")
							)
						)
					)
				)
			)
			;;; -------------------------------------------------------------
			;;; Test A-F
			;;; -------------------------------------------------------------
			(if (and ps (psdiag:file-exists script))
				(progn
					(setq results nil)
					(setq result  (psdiag:test-mode shell ps script "A" outfile errfile))
					(setq results (append results (list (list "A" result))))
					(psdiag:print-test-result "A" "STANDARD" result)
					(setq result  (psdiag:test-mode shell ps script "B" outfile errfile))
					(setq results (append results (list (list "B" result))))
					(psdiag:print-test-result "B" "BYPASS" result)
					(setq result  (psdiag:test-mode shell ps script "C" outfile errfile))
					(setq results (append results (list (list "C" result))))
					(psdiag:print-test-result "C" "UNRESTRICTED" result)
					(setq result  (psdiag:test-mode shell ps script "D" outfile errfile))
					(setq results (append results (list (list "D" result))))
					(psdiag:print-test-result "D" "REMOTESIGNED" result)
					(setq resultc (psdiag:test-mode shell ps script "E" outfile errfile))
					(setq results (append results (list (list "E" result))))
					(psdiag:print-test-result "E" "ALLSIGNED" result)
					(setq result  (psdiag:test-mode shell ps script "F" outfile errfile))
					(setq results (append results (list (list "F" result))))
					(psdiag:print-test-result "F" "RESTRICTED" result)
					;;; ----------------------------------------------------------
					;;; Selezione prima modalita' funzionante
					;;; ----------------------------------------------------------
					(foreach item results
						(if (and (not selected) (nth 1 item) (psdiag:valid-result-p (nth 1 item)))
							(progn
								(setq selected (car item))
								(setq selectedPrefix
								(psdiag:make-prefix ps selected))
								(setq selectedCommand (strcat selectedPrefix " \"" script "\""))
							)
						)
					)
					;;; ----------------------------------------------------------
					;;; CONFIGURAZIONE
					;;; ----------------------------------------------------------
					(if selected
						(setq status "READY")
						(progn
							(setq status "BLOCKED")
							(psdiag:add "")
							(psdiag:add "NESSUNA MODALITA' HA SUPERATO IL TEST.")
							(setq success nil)
						)
					)
				)
			)
			;;; -------------------------------------------------------------
			;;; Risultato operativo
			;;; -------------------------------------------------------------
			(psdiag:add "")
			(psdiag:add "================================================")
			(psdiag:add " RISULTATO OPERATIVO")
			(psdiag:add "================================================")
			(psdiag:add (strcat "STATUS : " status))
			(if selected
				(progn
					(psdiag:add (strcat "Modalita' selezionata : " selected))
					(psdiag:add "Prefisso PowerShell:")
					(psdiag:add selectedPrefix)
					(psdiag:add "Sintassi completa di test:")
					(psdiag:add selectedCommand)
				)
				(progn
					(if ps
						(psdiag:add "PowerShell presente, ma non utilizzabile dai test PSDIAG.")
						(psdiag:add "PowerShell non disponibile.")
					)
				)
			)
		)
	)
	;;; ---------------------------------------------------------------
	;;; Stato finale: se PowerShell e' presente ma nessuna modalita'
	;;; e' stata selezionata, l'ambiente e' da considerare BLOCKED.
	;;; ---------------------------------------------------------------
	(if (and ps (not selected)
			(or (= status "UNKNOWN") (= status "BLOCKED"))
		)
		(setq status "BLOCKED")
	)
	;;; ---------------------------------------------------------------
	;;; Configurazione sempre disponibile
	;;; ---------------------------------------------------------------
	(setq *psdiag-config*
		(list
			(cons "MODE" selected)
			(cons "POWERSHELL" ps)
			(cons "PREFIX" selectedPrefix)
			(cons "COMMAND" selectedCommand)
			(cons "STATUS" status)
			(cons "VBS" nil)
		)
	)	
	;;; ---------------------------------------------------------------
	;;; Risultato finale
	;;; ---------------------------------------------------------------
	(psdiag:add "")
	(psdiag:add "================================================")
	(if success
		(psdiag:add " PSDIAG RESULT : PASS")
		(psdiag:add " PSDIAG RESULT : FAIL")
	)
	(psdiag:add "================================================")
	(if shell (vl-catch-all-apply 'vlax-release-object (list shell)))
	(psdiag:write-report reportfile)
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
    (foreach f (list sourcefile script logps outfile errfile)
        (if (psdiag:file-exists f) (vl-file-delete f))
    )
	success
)
;;; ================================================================
;;; COMANDO AUTOCAD
;;; ================================================================
(defun PowerShellDiag (Verbose)
  (PSDIAG Verbose)
  (PSDIAG:TestVBS Verbose)
)
;;; ================================================================
;;; API PUBBLICA
;;; ================================================================
(defun PSDIAG:GetPowerShellPrefix ()
	(cdr (assoc "PREFIX" *psdiag-config*))
)
(defun PSDIAG:GetPowerShellCommand ()
	(cdr (assoc "COMMAND" *psdiag-config*))
)
(defun PSDIAG:GetPowerShellPath ()
	(cdr (assoc "POWERSHELL" *psdiag-config*))
)
(defun PSDIAG:GetMode ()
	(cdr (assoc "MODE" *psdiag-config*))
)
(defun PSDIAG:GetStatus ()
	(cdr (assoc "STATUS" *psdiag-config*))
)
(defun PSDIAG:GetVBSStatus ()
	(cdr (assoc "VBS" *psdiag-config*))
)
(defun PSDIAG:CheckPowerShell ()
	(and *psdiag-config*
		(PSDIAG:GetPowerShellPrefix)
		(PSDIAG:GetMode)
		(= "READY" (PSDIAG:GetStatus))
	)
)
(defun PSDIAG:CheckPowerShellVBS ()
	(and *psdiag-config*
		(PSDIAG:GetPowerShellPrefix)
		(PSDIAG:GetMode)
		(= "READY" (PSDIAG:GetVBSStatus))
	)
)
(defun PSDIAG:TestExe (/ testps f result)
	(setq testps (strcat (getvar "TEMPPREFIX") "PSD_TEST.ps1"))
	(setq f (open testps "w"))
	(if f
		(progn
			(write-line "Write-Output 'RUNPOWERSHELL_OK'" f)
			(close f)
			(setq result (PSDIAG:RunPowerShell testps 1 nil))
			(princ result)
			(if (and testps (= (type testps) 'STR) (findfile testps)) (vl-file-delete testps))
		)
	)
)
;;; ================================================================
;;; ESECUZIONE SCRIPT POWERSHELL - HIDDEN
;;; ================================================================
;;; Restituisce:
;;;   ((EXITCODE . 0)
;;;    (STDOUT . "")
;;;    (STDERR . "")
;;;    (MODE . "A"))
;;;
;;; Se PSDIAG non ha determinato una configurazione utilizzabile:
;;;   NIL
;;; ================================================================
;
(defun PSDIAG:RunPowerShell (FilePs TypeExe LstArg / shell prefix mode command exitcode err stdout stderr exec objOut objErr)
	
	;;; ============================================================
	;;; Verifica configurazione
	;;; ============================================================
	(if (or
			(null *psdiag-config*)
			(null FilePs)
			(and
				(/= TypeExe 3)
				(/= TypeExe 4)
				(not (and FilePs (= (type FilePs) 'STR) (findfile FilePs)))
			)
		)
		nil
		(progn
			
			(setq prefix (PSDIAG:GetPowerShellPrefix))
			(setq mode   (PSDIAG:GetMode))
			
			;;; ====================================================
			;;; Esecuzione consentita solo con STATUS READY
			;;; ====================================================
			(if (or
					(/= "READY" (PSDIAG:GetStatus))
					(null prefix)
					(null mode)
				)
				nil
				(progn
					
					;;; =================================================
					;;; Creazione WScript.Shell
					;;; =================================================
					(setq shell
						(vl-catch-all-apply
							'vlax-create-object
							(list "WScript.Shell")
						)
					)
					
					(if (vl-catch-all-error-p shell)
						nil
						(progn
							
							(setq
								exitcode -1
								err      ""
								stdout   ""
								stderr   ""
								exec     nil
								objOut   nil
								objErr   nil
							)
							
							(cond
								
								;;; ========================================
								;;; TypeExe = 1
								;;; Esegue uno script PowerShell
								;;; ========================================
								((= TypeExe 1)
									
									(setq command
										(strcat
											prefix
											" \""
											FilePs
											"\""
										)
									)
									
									(setq exitcode
										(vl-catch-all-apply
											'vlax-invoke-method
											(list
												shell
												'Run
												command
												0
												:vlax-true
											)
										)
									)
								)
								
								
								;;; ========================================
								;;; TypeExe = 2
								;;; Esegue uno script PowerShell
								;;; con un argomento
								;;; ========================================
								((= TypeExe 2)
									
									(if (and LstArg (nth 0 LstArg))
										(progn
											
											(setq command
												(strcat
													prefix
													" \""
													FilePs
													"\" \""
													(nth 0 LstArg)
													"\""
												)
											)
											
											(setq exitcode
												(vl-catch-all-apply
													'vlax-invoke-method
													(list
														shell
														'Run
														command
														0
														:vlax-false
													)
												)
											)
										)
										
										(setq exitcode -1)
									)
								)
								
								
								;;; ========================================
								;;; TypeExe = 3
								;;; Esegue un comando PowerShell inline
								;;;
								;;; FilePs = comando PowerShell
								;;; LstArg non utilizzato
								;;;
								;;; Usa Exec per catturare STDOUT/STDERR
								;;; ========================================
								((= TypeExe 3)
									
									(setq command
										(strcat
											"\""
											(cdr (assoc "POWERSHELL" *psdiag-config*))
											"\""
											" -NoLogo"
											" -NoProfile"
											" -WindowStyle Hidden"
											" -Command \""
											FilePs
											"\""
										)
									)
									
									(setq exec
										(vl-catch-all-apply
											'vlax-invoke-method
											(list
												shell
												'Exec
												command
											)
										)
									)
									
									(if (vl-catch-all-error-p exec)
										(progn
											(setq err
												(vl-catch-all-error-message exec)
											)
											(setq exitcode -1)
										)
										(progn
											
											;;; STDOUT
											(setq objOut
												(vl-catch-all-apply
													'vlax-get-property
													(list exec 'StdOut)
												)
											)
											
											(if (not (vl-catch-all-error-p objOut))
												(progn
													(setq stdout
														(vl-catch-all-apply
															'vlax-invoke-method
															(list objOut 'ReadAll)
														)
													)
													
													(if (vl-catch-all-error-p stdout)
														(setq stdout "")
													)
												)
											)
											
											
											;;; STDERR
											(setq objErr
												(vl-catch-all-apply
													'vlax-get-property
													(list exec 'StdErr)
												)
											)
											
											(if (not (vl-catch-all-error-p objErr))
												(progn
													(setq stderr
														(vl-catch-all-apply
															'vlax-invoke-method
															(list objErr 'ReadAll)
														)
													)
													
													(if (vl-catch-all-error-p stderr)
														(setq stderr "")
													)
												)
											)
											
											
											;;; ExitCode
											(setq exitcode
												(vl-catch-all-apply
													'vlax-get-property
													(list exec 'ExitCode)
												)
											)
											
											(if (vl-catch-all-error-p exitcode)
												(setq exitcode -1)
											)
										)
									)
								)
								
								
								;;; ========================================
								;;; TypeExe = 4
								;;; Esegue uno script PowerShell con -File
								;;; e cattura STDOUT/STDERR
								;;;
								;;; FilePs = file .PS1
								;;; LstArg non utilizzato
								;;; ========================================
								((= TypeExe 4)
									
									(setq command
										(strcat
											"\""
											(cdr (assoc "POWERSHELL" *psdiag-config*))
											"\""
											" -NoLogo"
											" -NoProfile"
											" -WindowStyle Hidden"
											" -File \""
											FilePs
											"\""
										)
									)
									
									(setq exec
										(vl-catch-all-apply
											'vlax-invoke-method
											(list
												shell
												'Exec
												command
											)
										)
									)
									
									(if (vl-catch-all-error-p exec)
										(progn
											(setq err
												(vl-catch-all-error-message exec)
											)
											(setq exitcode -1)
										)
										(progn
											
											;;; STDOUT
											(setq objOut
												(vl-catch-all-apply
													'vlax-get-property
													(list exec 'StdOut)
												)
											)
											
											(if (not (vl-catch-all-error-p objOut))
												(progn
													(setq stdout
														(vl-catch-all-apply
															'vlax-invoke-method
															(list objOut 'ReadAll)
														)
													)
													
													(if (vl-catch-all-error-p stdout)
														(setq stdout "")
													)
												)
											)
											
											
											;;; STDERR
											(setq objErr
												(vl-catch-all-apply
													'vlax-get-property
													(list exec 'StdErr)
												)
											)
											
											(if (not (vl-catch-all-error-p objErr))
												(progn
													(setq stderr
														(vl-catch-all-apply
															'vlax-invoke-method
															(list objErr 'ReadAll)
														)
													)
													
													(if (vl-catch-all-error-p stderr)
														(setq stderr "")
													)
												)
											)
											
											
											;;; ExitCode
											(setq exitcode
												(vl-catch-all-apply
													'vlax-get-property
													(list exec 'ExitCode)
												)
											)
											
											(if (vl-catch-all-error-p exitcode)
												(setq exitcode -1)
											)
										)
									)
								)
								
								
								;;; ========================================
								;;; TypeExe non valido
								;;; ========================================
								(T
									(setq exitcode -1)
									(setq err "TypeExe non valido")
								)
							)
							
							
							;;; =================================================
							;;; Gestione errore COM
							;;; =================================================
							(if (vl-catch-all-error-p exitcode)
								(progn
									(setq err
										(vl-catch-all-error-message exitcode)
									)
									(setq exitcode -1)
								)
							)
							
							
							;;; =================================================
							;;; Rilascio oggetti COM
							;;; =================================================
							(if objOut
								(vl-catch-all-apply
									'vlax-release-object
									(list objOut)
								)
							)
							
							(if objErr
								(vl-catch-all-apply
									'vlax-release-object
									(list objErr)
								)
							)
							
							(if exec
								(vl-catch-all-apply
									'vlax-release-object
									(list exec)
								)
							)
							
							(vl-catch-all-apply
								'vlax-release-object
								(list shell)
							)
							
							
							;;; =================================================
							;;; Risultato
							;;; =================================================
							(list
								(cons 'EXITCODE exitcode)
								(cons 'STDOUT stdout)
								(cons 'STDERR
									(if (/= stderr "")
										stderr
										err
									)
								)
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
;
(defun PSDIAG:TestVBS (Verbose / FileVbs FilePs FileChk Stream Prefix PosQuote PrefixExe PrefixArg Rtn)
	;;; ============================================================
	;;; Stato iniziale
	;;; ============================================================
	(if (assoc "VBS" *psdiag-config*)
		(setq *psdiag-config*
			(subst
				(cons "VBS" nil)
				(assoc "VBS" *psdiag-config*)
				*psdiag-config*
			)
		)
		(setq *psdiag-config*
			(append
				*psdiag-config*
				(list (cons "VBS" nil))
			)
		)
	)
	(setq Rtn nil)
	;;; ============================================================
	;;; Verifica configurazione
	;;; ============================================================
	(if (and
			*psdiag-config*
			(setq Prefix (PSDIAG:GetPowerShellPrefix))
		)
		(progn
			;;; ====================================================
			;;; Estrazione EXE e argomenti dal PREFIX
			;;; ====================================================
			(setq PosQuote (vl-string-search (chr 34) Prefix 1))
			(if PosQuote
				(progn
					(setq PrefixExe (substr	Prefix 2 (- PosQuote 1)))
					(setq PrefixArg (vl-string-left-trim " " (substr Prefix (+ PosQuote 2))))
					;;; =================================================
					;;; File temporanei
					;;; =================================================
					(setq FileVbs (vl-filename-mktemp "PSDIAG_VBS.vbs"))
					(setq FilePs  (vl-filename-mktemp "PSDIAG_VBS.ps1"))
					(setq FileChk (vl-filename-mktemp "PSDIAG_VBS.chk"))
					;;; =================================================
					;;; PowerShell script
					;;; =================================================
					(setq Stream (open FilePs "w"))
					(if Stream
						(progn
							(write-line (strcat	"New-Item -Path " (chr 34) FileChk (chr 34)	" -ItemType File -Force | Out-Null") Stream)
							(close Stream)
							;;; ==========================================
							;;; VBScript wrapper
							;;; ==========================================
							(setq Stream (open FileVbs "w"))
							(if Stream
								(progn
									(write-line	"Set WshShell = CreateObject(\"WScript.Shell\")" Stream)
									(write-line
										(strcat
											"WshShell.Run Chr(34) & "
											(chr 34) PrefixExe (chr 34)
											" & Chr(34) & "
											(chr 34) " "
											PrefixArg " "
											(chr 34) " & Chr(34) & "
											(chr 34) FilePs
											(chr 34) " & Chr(34), 0, False"
										) Stream
									)
									(close Stream)
									;;; ======================================
									;;; Avvio WScript
									;;; ======================================
									(startapp (strcat "wscript.exe " (chr 34) FileVbs (chr 34)))
									;;; ======================================
									;;; Attesa esecuzione PowerShell
									;;; ======================================
									(while
										(not (findfile FileChk))
										(princ "")
									)
									(setq Rtn T)
								)
							)
						)
					)
				)
			)
		)
	)
	;;; ============================================================
	;;; Aggiornamento stato VBS
	;;; ============================================================
	(if *psdiag-config*
		(setq *psdiag-config*
			(subst
				(cons
					"VBS"
					(if Rtn
						"READY"
						"BLOCKED"
					)
				)
				(assoc "VBS" *psdiag-config*)
				*psdiag-config*
			)
		)
	)
	(if Verbose
		(progn
			(princ "\n================================================")
			(if Rtn
				(princ "\n PSDIAG:TestVBS RESULT : READY")
				(princ "\n PSDIAG:TestVBS RESULT : BLOCKED")
			)
			(princ "\n================================================")
		)
	)
	;;; ============================================================
	;;; Cleanup
	;;; ============================================================
	(if (and FileVbs (findfile FileVbs))
		(vl-file-delete FileVbs)
	)
	(if (and FilePs (findfile FilePs))
		(vl-file-delete FilePs)
	)
	(if (and FileChk (findfile FileChk))
		(vl-file-delete FileChk)
	)
	Rtn
)
;
;
(defun PSDIAG:RunPowerShellVBS	(FilePs TypeExe LstArg / FileVbs Stream Prefix PosQuote PrefixExe 
														 PrefixArg Command shell exitcode)

	;;; ============================================================
	;;; Verifica configurazione
	;;; ============================================================
	(if (or (null *psdiag-config*)
			(null FilePs)
			(null (PSDIAG:GetPowerShellPrefix))
			(/= "READY" (PSDIAG:GetVBSStatus))
		)
		nil
		(progn
			(setq Prefix (PSDIAG:GetPowerShellPrefix))
			;;; ====================================================
			;;; Per ora supportiamo solo TypeExe = 1
			;;; ====================================================
			(if (/= TypeExe 1)
				nil
				(progn
					;;; ============================================
					;;; Estrazione EXE e argomenti dal PREFIX
					;;; ============================================
					(setq PosQuote (vl-string-search (chr 34) Prefix 1))
					(if PosQuote
						(progn
							(setq PrefixExe (substr Prefix 2 (- PosQuote 1)))
							(setq PrefixArg (vl-string-left-trim " " (substr Prefix	(+ PosQuote 2))))
							;;; ====================================
							;;; File VBS
							;;; ====================================
							(setq FileVbs (vl-filename-mktemp "PSDIAG_RUNVBS.vbs"))
							;;; ====================================
							;;; Creazione VBS
							;;; ====================================
							(setq Stream (open FileVbs "w"))
							(if Stream
								(progn
									(write-line	"Set WshShell = CreateObject(\"WScript.Shell\")" Stream)
									(write-line
										(strcat
											"WshShell.Run Chr(34) & "
											(chr 34)
											PrefixExe
											(chr 34)
											" & Chr(34) & "
											(chr 34)
											" "
											PrefixArg
											" "
											(chr 34)
											" & Chr(34) & "
											(chr 34)
											FilePs
											(chr 34)
											" & Chr(34), 0, True"
										)
										Stream
									)
									(close Stream)
									;;; =================================
									;;; WScript.Shell
									;;; =================================
									(setq shell	(vl-catch-all-apply	'vlax-create-object	(list "WScript.Shell")))
									(if (vl-catch-all-error-p shell)
										(setq exitcode -1)
										(progn
											(setq Command (strcat "wscript.exe " (chr 34) FileVbs (chr 34)))
											;;; =========================
											;;; Avvio VBS nascosto
											;;; =========================
											(setq exitcode (vl-catch-all-apply 'vlax-invoke-method (list shell 'Run Command 0 :vlax-true)))
											(if	(vl-catch-all-error-p exitcode) 
												(setq exitcode -1)
											)
											(vl-catch-all-apply	'vlax-release-object (list shell))
										)
									)
									;;; =================================
									;;; Cleanup
									;;; =================================
									(if (findfile FileVbs)
										(vl-file-delete FileVbs)
									)
									;;; =================================
									;;; Risultato
									;;; =================================
									(list
										(cons 'EXITCODE exitcode)
										(cons 'STDOUT "")
										(cons 'STDERR "")
										(cons 'MODE (PSDIAG:GetMode))
									)
								)
								nil
							)
						)
						nil
					)
				)
			)
		)
	)
)
;
;!*psdiag-config*
;(("MODE" . "A") 
; ("POWERSHELL" . "C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe") 
; ("PREFIX" . "\"C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe\" -NoLogo -NoProfile -WindowStyle Hidden -File") 
; ("COMMAND" . "\"C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe\" -NoLogo -NoProfile -WindowStyle Hidden -File \"C:\\Users\\adl20\\AppData\\Local\\Temp\\PSDIAG_288487484.ps1\"") 
; ("STATUS" . "READY") ("VBS" . "READY")
;)
