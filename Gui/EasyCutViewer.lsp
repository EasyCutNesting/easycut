(defun EasyCutViewer (FileName / FullNameEditor Ext)

	(setq Ext (strcase (vl-filename-extension ECFileViewer$) T))
	
	(if (= Ext ".exe")
		(if (setq FullNameEditor (SearchEditor ECFileViewer$))
			(setq ECFileViewer$ FullNameEditor)
			(progn
				(if (not (= (strcase ECFileViewer$) "notepad.exe"))
					(setq ECFileViewer$ "notepad.exe")
					(progn
						(princ (strcat "\n[EasyCutViewer] Editor " ECFileViewer$ " non trovato !"))
						(princ (strcat "\n[EasyCutViewer] Utilizzo l'editor interno di EasyCut " EasyCutViewer.ps1))
					)
				)
			)
		)
	)
	;
	; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(cond 
		((= Ext ".exe")
			(EasyCutViewerNotePad FileName)
		)
		((= Ext ".ps1")
			(StartScriptViewer (strcat GuiPathEasyCut$ ECFileViewer$) FileName)
		)
		(T
			(alert "impossibile definire l'editor")
		)
	)
)
;
;
;
(defun StartScriptViewer (Script FileName)
	(if (findfile Script)
		(if (PSDIAG:CheckPowerShell)
			(PSDIAG:RunPowerShell Script 2 (list FileName))
			(princ (strcat "\nErrore: Impossibile eseguire Powershell "))
		)
		(princ (strcat "\nErrore: Impossibile trovare lo script in: " Script))
	)
)
;
;
;;; ============================================================
(setq *ECV-LOG-FILE*
  (strcat (getenv "TEMP") "\\AutoCAD_Log.txt")
)
(setq *ECV-BB-SESSION-KEY*
  "EasyCutViewer.SessionInitialized"
)
;; ------------------------------------------------------------
;; INIZIALIZZA IL LOG UNA SOLA VOLTA PER SESSIONE AUTOCAD
;;
;; vl-bb-* mantiene lo stato nel blackboard di Visual LISP,
;; quindi un semplice APPLOAD dello stesso LSP durante la sessione
;; non provoca automaticamente il reset.
;; ------------------------------------------------------------
;; ------------------------------------------------------------
;; FUNZIONE PRINCIPALE
;; Esempio:
;;(EasyCutViewer "C:\\Temp\\Taglio_01.log")
;; ------------------------------------------------------------
(defun EasyCutViewerNotePad (file / ECV-DataOra ECV-NomeFile ECV-AprilLog ECV-InizializzaSessione ECV-AggiungiFile)

	(defun ECV-DataOra ( / )
		(menucmd "M=$(edtime,$(getvar,date),DD/MM/YYYY HH:MM:SS)")
	)
	;
	;
	(defun ECV-NomeFile (file / p)
		(setq p (strlen file))
		(while
			(and
				(> p 0)
				(/= (substr file p 1) "\\")
				(/= (substr file p 1) "/")
			)
			(setq p (1- p))
		)
		(substr file (1+ p))
	)
	;
	;
	(defun ECV-AprilLog ( / )
		(if (findfile *ECV-LOG-FILE*)
			;(startapp "notepad.exe" *ECV-LOG-FILE*)
			(startapp ECFileViewer$ *ECV-LOG-FILE*)
		)
	)
	;
	;
	(defun ECV-InizializzaSessione ( / f )
		(if (not (vl-bb-ref *ECV-BB-SESSION-KEY*))
			(progn
				(setq f (open *ECV-LOG-FILE* "w"))
				(if f
					(progn
						(write-line "==================== SESSIONE AUTOCAD ===================="	f)
						(write-line (strcat "Avvio: " (ECV-DataOra))					         	f)
						(write-line "" f)
						(close f)
						(vl-bb-set *ECV-BB-SESSION-KEY* T)
						T
					)
					nil
				)
			)
			T
		)
	)
	;
	;
	(defun ECV-AggiungiFile (file / src dst riga nome)
	
		(if (not (findfile file))
			nil
			(progn
				(setq nome (ECV-NomeFile file))
				(setq src  (open file "r"))
				;(setq dst  (open *ECV-LOG-FILE* "a"))
				(setq dst  (open *ECV-LOG-FILE* "w"))
				(if (and src dst)
					(progn
						;; Separatore: una sola riga
						(write-line (strcat "==================== " (ECV-DataOra) " | " nome " ====================")	dst)
						(write-line "" 																					dst)
						;; Copia il contenuto del file sorgente
						(while (setq riga (read-line src))
							(write-line riga dst)
						)
						(write-line "" dst)
						(close src)
						(close dst)
						T
					)
					(progn
						(if src (close src))
						(if dst (close dst))
						nil
					)
				)
			)
		)
	)
	;
	; Main
	;
	(cond
		((not (and file (= (type file) 'STR)))
			(princ "\nEasyCutViewer: specificare il percorso di un file.")
			nil
		)
		((not (findfile file))
			(princ (strcat "\nEasyCutViewer: file non trovato: " file))
			nil
		)
		((not (ECV-InizializzaSessione))
			(princ "\nEasyCutViewer: impossibile inizializzare il log di sessione.")
			nil
		)
		((not (ECV-AggiungiFile file))
			(princ "\nEasyCutViewer: impossibile leggere o aggiornare il log.")
			nil
		)
		(T
			(ECV-AprilLog)
			T
		)
	)
)
;; ------------------------------------------------------------
;; COMANDO FACOLTATIVO: ECVLOG
;; Apre il log corrente senza aggiungere nulla.
;; ------------------------------------------------------------
(defun c:ECVLOG ( / )
  (if (findfile *ECV-LOG-FILE*)
    (ECV-AprilLog)
    (princ "\nEasyCutViewer: nessun log di sessione presente.")
  )
)
;
;
;
(defun SearchEditor (exe / 	sh risultato pathList pos path chiave valore cartelle risultato)

	;; 1. Ricerca diretta
	(if (findfile exe)
		(setq risultato (findfile exe))
	)
	;; 2. PATH Windows
	(if (not risultato)
		(progn
			(setq pathList (getenv "PATH"))
			(while (and pathList (not risultato))
				(setq pos (vl-string-search ";" pathList))
				(if pos
					(progn
						(setq path (substr pathList 1 pos))
						(setq pathList (substr pathList (+ pos 2)))
					)
					(progn
						(setq path pathList)
						(setq pathList nil)
					)
				)
				(if (and path
						(/= path "")
						(findfile (strcat path "\\" exe))
					)
					(setq risultato (findfile (strcat path "\\" exe)))
				)
			)
		)
	)
	;; 3. Registro Windows - App Paths
	(if (not risultato)
		(progn
			(setq sh
				(vl-catch-all-apply
					'vlax-create-object
					(list "WScript.Shell")
				)
			)
			(if (not (vl-catch-all-error-p sh))
				(progn
					(foreach chiave
						(list
							(strcat "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\App Paths\\" exe "\\")
							(strcat "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\App Paths\\" exe "\\")
							(strcat "HKEY_LOCAL_MACHINE\\Software\\WOW6432Node\\Microsoft\\Windows\\CurrentVersion\\App Paths\\" exe "\\")
						)
						(if (not risultato)
							(progn
								(setq valore
									(vl-catch-all-apply
										'vlax-invoke-method
										(list sh 'RegRead chiave)
									)
								)
								(if (and (not (vl-catch-all-error-p valore))
										(= (type valore) 'STR)
										(/= valore "")
										(findfile valore)
									)
									(setq risultato (findfile valore))
								)
							)
						)
					)
					(vlax-release-object sh)
				)
			)
		)
	)
	;; 4. Cartelle standard
	(if (not risultato)
		(progn
			(setq cartelle
				(list
					(getenv "WINDIR")
					(strcat (getenv "WINDIR") "\\System32")
					(getenv "ProgramFiles")
					(getenv "ProgramFiles(x86)")
					(strcat (getenv "ProgramFiles") "\\Notepad++")
					(strcat (getenv "ProgramFiles(x86)") "\\Notepad++")
					(strcat (getenv "LOCALAPPDATA") "\\Programs\\Notepad++")
					(strcat (getenv "ProgramFiles") "\\Microsoft Office\\root\\Office16")
					(strcat (getenv "ProgramFiles(x86)") "\\Microsoft Office\\root\\Office16")
					(strcat (getenv "ProgramFiles") "\\Microsoft Office\\Office16")
					(strcat (getenv "ProgramFiles(x86)") "\\Microsoft Office\\Office16")
				)
			)
			(foreach path cartelle
				(if (and (not risultato)
						path
						(/= path "")
						(findfile (strcat path "\\" exe))
					)
					(setq risultato (findfile (strcat path "\\" exe)))
				)
			)
		)
	)
	risultato
)