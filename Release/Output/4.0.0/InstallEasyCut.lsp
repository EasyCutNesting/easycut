(defun c:CheckUnstallEasyCut (/ FileDialog xx)

	(setq FileDialog (MakeDialogCheckInstall))
	(setq xx (load_dialog FileDialog))
	(new_dialog "CheckInstallEasyCut" xx "" (cond ( *CheckInstalEasyCut* ) ( '(-1 -1) )))
	(CheckInstallEasyCut)
	(action_tile "accept"    "(setq *CheckInstalEasyCut* (done_dialog)) (unload_dialog xx) (vl-file-delete FileDialog)")
	(start_dialog)
)
;
(defun c:InstallEasyCut (/ CheckUnpackEasyCut 
						   LstPackFile InfoUnpack FileDialog xx Flag PathEasyCut itm PathRoaming)


	(defun CheckUnpackEasyCut (DestinationFolder InfoUnpack / CompareListsUnpacked FileUnpack FilePack)
		
		(defun CompareListsUnpacked (FilePack FileUnpack / Pos1 itm FileEliminated)
			;; 1. Trova gli elementi comuni (presenti in entrambe)
			(setq Pos1 0)
			(foreach itm FilePack
				(if (member itm FileUnpack)
					(setq Pos1 (1+ Pos1))
				)
			)
			;; 2. Trova gli elementi eliminati (presenti in A ma non in B)
			(foreach itm FilePack
				(if (not (member itm FileUnpack))
					(setq FileEliminated (cons itm FileEliminated))
				)
			)
			(if FileEliminated
				(progn
					(princ (strcat "\n n. File compressi    " (rtos (length FilePack)        2 0)))
					(princ (strcat "\n n. File scompattati  " (rtos (length FileUnpack)      2 0)))
					(princ (strcat "\n n. File non presenti " (rtos (length FileEliminated)  2 0)))
					(princ "\n +-----------------------+")
					(princ "\n  Lista file non presenti")
					(princ "\n +-----------------------+\n")
					(princ FileEliminated)
					nil
				)
				T
			)
		)		
		;
		; Main
		;
		(if (and DestinationFolder InfoUnpack)
			(progn
				; InfoUnpack (("4.0.0" "19" "1483") ("SqLite\\EasyCutSQLite.lsp" "SqLite\\LoadSqLite.lsp" ...)( 
				(setq FileUnpack (Get-Recursive-File-List DestinationFolder))
				(setq FilePack   (cadr InfoUnpack))
				(CompareListsUnpacked FilePack FileUnpack)
			)
		)
	)
	;
	; Main
	;
;	(if (setq LstPackFile (DownloadReleaseEasyCut "https://github.com/EasyCutNesting/easycut/releases/latest/download/version.txt" nil))
	(if (setq LstPackFile (DownloadReleaseEasyCut "https://github.com/EasyCutNesting/easycut" nil))
		(progn
			(UninstallEasyCut)
			(UnpackEasyCutVersionWindows (car LstPackFile) (strcat LocalPathInstallEasyCut$ "\\EasyCut"))
			(setq Flag  (CheckUnpackEasyCut (strcat LocalPathInstallEasyCut$ "\\EasyCut") (cadr LstPackFile)))
		)
	)
	;
	(if Flag
		(progn
			(LM:popup "Avvertimento" 	(strcat "Il file " (car LstPackFile) " e' sato estratto correttamente\n"
												"nella cartella " (strcat LocalPathInstallEasyCut$ "\\EasyCut")
										)
										(+ 0 64 4096))

			(setq PathEasyCut  (strcat LocalPathInstallEasyCut$ "\\EasyCut"))
			;(foreach itm (RecursiveFindFilesWildcard PathEasyCut "*.exe")
			;	(UnblockExe itm)
			;)

			(setq FileDialog (MakeDialogInstall))
			(setq xx (load_dialog FileDialog))
			(new_dialog "InstallEasyCut" xx "" (cond ( *InstalEasyCut* ) ( '(-1 -1) )))
			; -------------------------------------------------------------------------
			(if (findfile AcdDoc$)
				(setq PathRoaming (vl-filename-directory (findfile AcdDoc$)))
				(setq PathRoaming (AddRoaming (strcat PathEasyCut "\\Support") T))
			)
			; --------------------------------------------------------------------------
			(if (and (ControlRegistry)
					 (ControlAcadDoc PathRoaming)
					 (ControlPathEasyCut PathEasyCut)
				)
				(mode_tile "Install" 0)
				(mode_tile "Install" 1)
			)
			(action_tile "Install"   "(if (InstallEasyCut PathEasyCut PathRoaming) (done_dialog)) (unload_dialog xx) (vl-file-delete FileDialog)")
			(action_tile "Cancel"    "(setq *InstalEasyCut* (done_dialog)) (unload_dialog xx) (vl-file-delete FileDialog)")
			(start_dialog)
		)
		(LM:popup "Errore" (strcat "Il file " (car LstPackFile) " non e' sato estratto\n"
									"Possibili anomalie :\n"
									"L'estrazione e' stata interrotta\n"
									"Il file ZIP e' danneggiato\n"
									"Alcuni file sono starti rimossi dall'Antivirus\n"
									"Non hai i permessi di scrittura") (+ 0 16 4096))
	)
)
;
(defun C:UninstallEasyCut (/ AcadDoc PathInstaller FileDialog xx)

	;
	; Main
	;
	(setq FileDialog (MakeDialogUninstall))
	(if (findfile FileDialog)
		(progn
			(setq xx (load_dialog FileDialog))
			(new_dialog "UnInstallEasyCut" xx "" (cond ( *UnInstalEasyCut* ) ( '(-1 -1) )))
			
			(start_list "Registry")			
				(mapcar 'add_list (PopulateLstRegistry (vl-registry-descendents "HKEY_CURRENT_USER\\Software\\EasyCut" T)))
			(end_list)

			(if (not (setq AcadDoc (findfile AcdDoc$)))
				(setq AcadDoc "AcadDoc.lsp assente")
			)
			(if (not (setq PathInstaller (FindPathInstallerEasyCut)))
				(setq  PathInstaller "PathInstaller assente")
			)
			(if (not (setq TrustedPaths (getvar 'Trustedpaths)))
				(setq  TrustedPaths "TrustedPaths assente")
			)
			(set_tile "AcadDocControl"  		AcadDoc)
			(set_tile "TrustedpathsControl"		TrustedPaths)
			(set_tile "FolderEasyCutControl"	PathInstaller)
			(if (IsPathEasyCutPreferenceActive)
				(set_tile "FolderEasyCutPreference"	(strcat PathInstaller "\\Support"))
			)
			(action_tile "uninstall"	"(UninstallEasyCut) (RefreshDialogInstallerEasyCut) (setq C:Loadec nil)")
			(action_tile "cancel"   	"(setq *UnInstalEasyCut* (done_dialog)) (unload_dialog xx) (vl-file-delete FileDialog)")
			(start_dialog)
		)
	)
)
;
(defun UtilityInstall ()

	;
	;
	(defun UnblockExe (FileName / Wsh CheckCommand UnblockCommand ExitCode)
		;(vlax-invoke-method wsh 'Run "powershell.exe -NoExit -Command \"Get-Item -LiteralPath 'C:\\EasyCutNesting Beta\\Apps\\RectPack\\RectPack.exe' -Stream 'Zone.Identifier'\"" 1 :vlax-true)
		(if (findfile FileName)
			(progn
				(setq Wsh (vlax-get-or-create-object "WScript.Shell"))
				(setq CheckCommand 
						(strcat "powershell.exe -Command \"if (Get-Item -LiteralPath '" 
								FileName 
								"' -Stream 'Zone.Identifier' -ErrorAction SilentlyContinue) { exit 1 } else { exit 0 }\""
						)
				)
				(if (= (vlax-invoke-method wsh 'Run CheckCommand 0 :vlax-true) 1)
					(progn
						(princ "\n[UnblockExe] Rilevato blocco di sicurezza Windows. Sblocco in corso...")
						(setq UnblockCommand (strcat "powershell.exe -Command \"Unblock-File -LiteralPath '" FileName "'\""))
						(setq ExitCode 		 (vlax-invoke-method wsh 'Run UnblockCommand 0 :vlax-true))
						(if (= ExitCode 0)
							(princ "\n[UnblockExe] Il file è stato sbloccato correttamente.")
							(alert (strcat "UnblockExe Errore di sblocco! PowerShell ha restituito il codice: " (itoa ExitCode) "\nVerifica i permessi di amministrazione."))
						)
					)
					(princ (strcat "\n[UnblockExe] Sicurezza verificata: il file " FileName " e' gia' sbloccato."))
				)
				(vlax-release-object Wsh)
			)
		)
	)
	;
	(defun CheckInstallEasyCut (/ LstAcadRegistry LstAcadDoc LstTrusted LstPathPreference LstPathEasyCut)

		(if (not (CheckTraceRegistryEasyCut))
			(setq LstAcadRegistry (list "Nessuna traccia di EasyCut" 		(car ImagesInstall$)))
			(setq LstAcadRegistry (list "Traccie presenti di EasyCut"  		(cadr ImagesInstall$)))
		)
		(if (not (CheckTraceEasyCutOnAcadDoc))
			(setq LstAcadDoc (list "Nessuna traccia di EasyCut" 			(car ImagesInstall$)))
			(setq LstAcadDoc (list "Traccie presenti di EasyCut"  			(cadr ImagesInstall$)))
		)	
		(if (not (CheckTraceEasyCutOnTrusted))
			(setq LstTrusted (list "Nessuna traccia di EasyCut" 			(car ImagesInstall$)))
			(setq LstTrusted (list "Traccie presenti di EasyCut"  			(cadr ImagesInstall$)))
		)
		(if (not (CheckTraceEasyCutOnPreference))
			(setq  LstPathPreference (list "Nessuna traccia di EasyCut" 	(car ImagesInstall$)))
			(setq  LstPathPreference (list "Traccie presenti di EasyCut"  	(cadr ImagesInstall$)))
		)
		(if (not (ChechTracePathEasyCut))
			(setq  LstPathEasyCut (list "Nessuna traccia di EasyCut" 		(car ImagesInstall$)))
			(setq  LstPathEasyCut (list "Traccie presenti di EasyCut"  		(cadr ImagesInstall$)))
		)
		
		(set_tile "EasyCutRegistryControl"	(car  LstAcadRegistry))
		(LM:DisplayBitmap "Chk1" 			(cadr LstAcadRegistry))

		(set_tile "EasyCutAcadDocControl" 	(car  LstAcadDoc))
		(LM:DisplayBitmap "Chk2" 			(cadr LstAcadDoc))

		(set_tile "EasyCutTrusted" 			(car  LstTrusted))
		(LM:DisplayBitmap "Chk3" 			(cadr LstTrusted))

		(set_tile "EasyCutPreference" 		(car  LstPathPreference))
		(LM:DisplayBitmap "Chk4" 			(cadr LstPathPreference))

		(set_tile "EasyCutFolder" 			(car  LstPathEasyCut))
		(LM:DisplayBitmap "Chk5" 			(cadr LstPathEasyCut))

	)
	;
	(defun LM:str->lst ( str del / pos )
		(if (setq pos (vl-string-search del str))
			(cons (substr str 1 pos) (LM:str->lst (substr str (+ pos 1 (strlen del))) del))
			(list str)
		)
	)
	;
	(defun SearchAndAddTrsPth (AddPath / TrsPth)                                         ; EasyCut
		(if AddPath                                                                      ; EasyCut
			(if (findfile AddPath)                                                       ; EasyCut
				(progn                                                                   ; EasyCut
					(if (setq TrsPth (getvar 'trustedpaths))                             ; EasyCut
						(if (not (vl-string-search (strcase AddPath) (strcase TrsPth)))  ; EasyCut
							(progn                                                       ; EasyCut
								(setq TrsPth (vl-string-left-trim " " TrsPth))           ; EasyCut
								(setq TrsPth (vl-string-right-trim  " " TrsPth))         ; EasyCut
								(cond                                                    ; EasyCut
									((or (= TrsPth ".") (= TrsPth ""))                   ; EasyCut
									  (setq TrsPth AddPath)                              ; EasyCut
									)                                                    ; EasyCut
									(t                                                   ; EasyCut
									  (setq TrsPth (strcat TrsPth ";" AddPath))          ; EasyCut
									)                                                    ; EasyCut
								)                                                        ; EasyCut
								(setvar 'trustedpaths TrsPth)                            ; EasyCut
							)                                                            ; EasyCut
						)                                                                ; EasyCut
					)                                                                    ; EasyCut
				)                                                                        ; EasyCut
			)                                                                            ; EasyCut
		)                                                                                ; EasyCut
	)                
	;
	(defun LM:browseforfolder ( msg dir bit / err fld pth shl slf )

		; Browse for Folder  -  Lee Mac
		; Displays a dialog prompting the user to select a folder.
		; msg - [str] message to display at top of dialog
		; dir - [str] [optional] root directory (or nil)
		; bit - [int] bit-coded flag specifying dialog display settings
		; Returns: [str] Selected folder filepath, else nil.
		
		; bit data
		; 0		Standard behaviour (Default)
		; 1		Only file system folders can be selected.If this bit is set, the OK button is disabled if the user selects a folder that doesn't belong to the file system.
		; 2		The user is prohibited from browsing below the domain within a network
		; 4		Room for status text is provided under the dialog box
		; 8		Returns file system ancestors only. An ancestor is a subfolder that is beneath the root folder. If the user selects an ancestor of the root folder that is not part of the file system, the OK button is greyed.
		; 16	Shows an edit box in the dialog box for the user to type the name of an item.
		; 32	Validate the name typed in the edit box.
		; 64	Enable drag-and-drop capability within the dialog box, reordering, shortcut menus, new folders, delete, and other shortcut menu commands.
		; 128	The browse dialog box can display URLs.
		; 256	When combined with flag 64, adds a usage hint to the dialog box, in place of the edit box.
		; 512	Suppresses display of the New Folder button
		; 1024	When the selected item is a shortcut, return the PIDL of the shortcut itself rather than its target.
		; 4096	Enables the user to browse the network branch for computer names. If the user selects anything other than a computer, the OK button is greyed.
		; 8192	Enables the user to browse the network branch for printer names. If the user selects anything other than a printer, the OK button is greyed.
		; 16384	Allows browsing for everything: the browse dialog box displays files as well as folders.
		; 32768	If combined with flag 64, the browse dialog box can display shareable resources on remote systems.
		; 65536	Windows 7 & later: Allow folder junctions such as a library or a compressed file with a .zip file name extension to be browsed.
		(setq err
			(vl-catch-all-apply
				(function
					(lambda ( / app hwd )
						(if (setq app (vlax-get-acad-object)
								  shl (vla-getinterfaceobject app "shell.application")
								  hwd (vl-catch-all-apply 'vla-get-hwnd (list app))
								  fld (vlax-invoke-method shl 'browseforfolder (if (vl-catch-all-error-p hwd) 0 hwd) msg bit dir)
							)
							(setq slf (vlax-get-property fld 'self)
								  pth (vlax-get-property slf 'path)
								  pth (vl-string-right-trim "\\" (vl-string-translate "/" "\\" pth))
							)
						)
					)
				)
			)
		)
		(if slf (vlax-release-object slf))
		(if fld (vlax-release-object fld))
		(if shl (vlax-release-object shl))
		(if (vl-catch-all-error-p err)
			(prompt (vl-catch-all-error-message err))
			pth
		)
	)
	;
	(defun LM:popup ( ttl msg bit / wsh rtn )

	;		(LM:popup "avvertimento" "Il file esite \n vuoi sovrascriverlo ?" (+ 1 48 4096))
	;
	;
	;		Buttons
	;		Value	Description
	;		0	Display OK button
	;		1	Display OK and Cancel buttons
	;		2	Display Abort, Retry, and Ignore buttons.
	;		3	Display Yes, No, and Cancel buttons.
	;		4	Display Yes and No buttons.
	;		5	Display Retry and Cancel buttons.
	;		6	Display Cancel, Try Again, and Continue buttons.

	;		Icons
	;		Value	Description
	;		16	Display Stop Mark icon.
	;		32	Display Question Mark icon.
	;		48	Display Exclamation Mark icon.
	;		64	Display Information Mark icon.

	;		Other
	;		Value	Description
	;		256	The second button is the default button.
	;		512	The third button is the default button.
	;		4096	The message box is a system modal message box and appears in a topmost window.
	;		524288	The text is right-justified.
	;		1048576	The message and content text display in right-to-left reading order.

	;		Return Values
	;		The following table lists the integer value returned when the associated button is pressed to dismiss the message box.
	;		Value	Description
	;		1	OK button
	;		2	Cancel button
	;		3	Abort button
	;		4	Retry button
	;		5	Ignore button
	;		6	Yes button
	;		7	No button
	;		10	Try Again button
	;		11	Continue button

		(if (setq wsh (vlax-create-object "wscript.shell"))
			(progn
				(setq rtn (vl-catch-all-apply 'vlax-invoke-method (list wsh 'popup msg 0 ttl bit)))
				(vlax-release-object wsh)
				(if (not (vl-catch-all-error-p rtn)) rtn)
			)
		)
	)
	;
	(defun LM:DisplayBitmap ( key lst / i j s x y )
		(setq s (fix (sqrt (length lst))))
		(repeat (setq i s)
			(setq j 1)
			(repeat s
				(setq x (cons j x)
					  y (cons i y)
					  j (1+ j)
				)
			)
			(setq i (1- i))
		)
		(start_image key)
		(fill_image 0 0 (dimx_tile key) (dimy_tile key) -15)
		(mapcar 'vector_image x y x y lst)
		(end_image)
	)
	;
	(defun CheckWriteRegistry ()
		
		(if (vl-registry-write EasyCutRegistryPath$ "Write" "T")
			(progn
				(vl-registry-delete EasyCutRegistryPath$ "Write")
				T
			)
			nil
		)
	)
	;
	(defun WriteRegistryEasyCut (PathEasyCut)

		(vl-registry-write EasyCutRegistryPath$ "FirstInstaller" "1")
		(vl-registry-write EasyCutRegistryPath$ "PathInstaller" PathEasyCut)
		(vl-registry-write EasyCutRegistryPath$ "Version" 		(PutVersion PathEasyCut))
		
	)
	;
	(defun CheckWriteAcadDoc (PathRoaming / Stream)
		;
		; Return:	1 File not found
		;			2 File read-only
		;			3 File normal
		;
		(if (findfile (strcat PathRoaming "\\" AcdDoc$))
			(if (setq Stream (open (findfile (strcat PathRoaming "\\" AcdDoc$)) "a"))
				(progn
					(close Stream)
					3
				)
				2
			)
			1
		)
	)
	;
	(defun PutVersion (PathInstaller / Path rf Version)

		(if (setq rf (open (strcat PathInstaller "\\Dbase\\Release.lsp") "r"))
			(progn
				(setq Version (read-line rf))
				(close rf)
			)
		)
		Version
	)
	;
	(defun MyDate+MyTime (/ LM:str->lst
							Lupe MyDate MyTime)

		(defun LM:str->lst ( str del / pos )
			(if (setq pos (vl-string-search del str))
				(cons (substr str 1 pos) (LM:str->lst (substr str (+ pos 1 (strlen del))) del))
				(list str)
			)
		)

		(setq Lupe (getvar "LUPREC"))
		(setvar "LUPREC" 	6)
		(setq MyDate		(car  (LM:str->lst (rtos (getvar "CDATE")) ".")))
		(setq MyTime		(cadr (LM:str->lst (rtos (getvar "CDATE")) ".")))
		(setvar "LUPREC" 	Lupe)
		(list MyDate MyTime)
	)
	;
	(defun RemoveOldInstallEasyCut (/ FileNameAcadDoc FullNameAcadDoc MyDate MyTime PathAcaDoc FullNameAcadDocSave Stream LineRead LstLine itm)
		;
		(setq FileNameAcadDoc AcdDoc$)
		(if (setq FullNameAcadDoc (findfile FileNameAcadDoc))
			(progn
				(setq PathAcaDoc 			(substr FullNameAcadDoc 1 (- (strlen FullNameAcadDoc) (strlen FileNameAcadDoc))))
				(setq FullNameAcadDocSave  	(strcat PathAcaDoc (car (MyDate+MyTime)) "-" (cadr (MyDate+MyTime)) FileNameAcadDoc))
				(vl-file-copy FullNameAcadDoc FullNameAcadDocSave)
						
				(if (setq Stream (open FullNameAcadDoc "r"))
					(progn
						(setq LineRead 	(read-line Stream))
						(while LineRead
							(setq LstLine (append LstLine (list LineRead)))
							(setq LineRead 	(read-line Stream))
						)
						(close Stream)
					)
				)
				(if LstLine
					(if (setq Stream (open FullNameAcadDoc "w"))
						(progn
							(foreach itm LstLine
								(if (not (vl-string-search (strcase "EasyCut") (strcase itm)))
									(write-line itm Stream)
								)
							)
							(close Stream)
						)
					)	
				)
			)
		)
	)
	;
	(defun AddSetupEasyCut (PathInstaller AcadDoc / LM:StringSubst
													Stream LineRead LstLine itm)

		(defun LM:StringSubst ( new old str / inc len )
			(setq len (strlen new)
				  inc 0
			)
			(while (setq inc (vl-string-search old str inc))
				(setq str (vl-string-subst new old str inc)
					  inc (+ inc len)
				)
			)
			str
		)
		;
		;
		;
		(if (and PathInstaller AcadDoc)
			(progn
				(setq Stream (open (strcat PathInstaller "\\Dbase\\SetupAcadDoc.lsp") "r"))
				(setq LineRead 	(read-line Stream))
				(while LineRead
					(setq LstLine (append LstLine (list LineRead)))
					(setq LineRead 	(read-line Stream))
				)
				(close Stream)
				
				(setq Stream (open (findfile AcadDoc) "a"))
				
				; Head

				(write-line ";Start Load Application                  ; EasyCut"  Stream)
				(write-line (strcat ";Build " (car (MyDate+MyTime)) " " (cadr (MyDate+MyTime)) "                   ; EasyCut") Stream)
				(write-line (strcat ";Version EasyCut " (PutVersion PathInstaller) "    ; EasyCut") Stream)
				(foreach itm LstLine
					(write-line itm Stream)
				)
				;(setq PathInstaller (LM:StringSubst "/" "\\" Pathinstaller))
				;(write-line (strcat "(SearchAndAddTrsPth \"" PathInstaller "/..." "\"" ")                                          ; EasyCut")  Stream)
				;(write-line (strcat "(if (not EasyCutRegistryPath$) (load \"" PathInstaller "/Load/StartEasyCut.lsp\" ""\"\"))     ; EasyCut")  Stream)
				
				(setq PathInstaller (LM:StringSubst "\\\\" "\\" Pathinstaller))
				(write-line (strcat "(SearchAndAddTrsPth \"" PathInstaller "\\\\..." "\"" ")                                          ; EasyCut")  Stream)
				(write-line (strcat "(if (not EasyCutRegistryPath$) (load \"" PathInstaller "\\\\Load\\\\StartEasyCut.lsp\" ""\"\"))    ; EasyCut")  Stream)

				(write-line ";End Load Application                                                                ; EasyCut\n" Stream)
				(close Stream)
			)
		)
	)
	;
	(defun UpdateAcadDoc (PathInstaller FileNameAcadDoc)

		(if (and PathInstaller (findfile FileNameAcadDoc))
			(progn
				(RemoveOldInstallEasyCut)
				(AddSetupEasyCut PathInstaller FileNameAcadDoc)
			)
		)
			
	)
	;
	(defun ValidateFolderEasyCut (PathEasyCut)
		(if PathEasyCut
			(if (findfile (strcat PathEasyCut "\\Dbase\\Release.lsp"))
				T
			)
		)
	)
	;
	(defun ValidateRegistryEasyCut (PathEasyCut)
		(if PathEasyCut
			(and (vl-registry-write EasyCutRegistryPath$ "PathInstaller" 	PathEasyCut)
				 (vl-registry-write EasyCutRegistryPath$ "Version" 		 	(PutVersion))
				 (vl-registry-write EasyCutRegistryPath$ "FirstInstaller"  	"1")
				)
		)
	)
	;
	(defun ConfigEasyCut (PathEasyCut / PathInstaller Rtn)

		(if PathEasyCut
			(progn
				(WriteRegistryEasyCut PathEasyCut)
				(UpdateAcadDoc PathEasyCut AcdDoc$)
				(SearchAndAddTrsPth (strcat PathEasyCut "\\..."))
				(load (strcat PathEasyCut "\\Load\\StartEasyCut.lsp" ""))
				T
			)
			nil
		)
	)
	;
	(defun ControlRegistry ()
		(if (CheckWriteRegistry)
			(progn
				(set_tile "RegistryControl" "Controllo registro EasyCut terminato")
				(LM:DisplayBitmap "Chk1" (car ImagesInstall$))
				T
			)
			(progn
				(set_tile "RegistryControl" "Impossibile scrivere il valore nella chiave EasyCut")
				(LM:DisplayBitmap "Chk1" (cadr ImagesInstall$))
				nil
			)
		)	
	)
	;
	(defun ControlAcadDoc (PathRoaming / Rtn)
		(if PathRoaming
			(progn
				(setq Rtn (CheckWriteAcadDoc (strcat PathRoaming)))
				(cond 
					((= Rtn 1) 
						(if (MakeFileAcadDoc PathRoaming)
							(progn
								(LM:DisplayBitmap "Chk2" (car ImagesInstall$))
								(set_tile "AcadDocControl" (strcat "File " (findfile AcdDoc$) " creato"))
								T
							)
							(progn
								(LM:DisplayBitmap "Chk2" (cadr ImagesInstall$))
								(set_tile "AcadDocControl" (strcat "File " AcdDoc$ " non creato"))
								nil
							)
						)
					)
					((= Rtn 2) 
						(set_tile "AcadDocControl" (strcat "File " AcdDoc$ " protetto da scrittura"))  
						(LM:DisplayBitmap "Chk2" (cadr ImagesInstall$)) 
						nil
					)
					((= Rtn 3) 
						(set_tile "AcadDocControl" (strcat "File " (findfile AcdDoc$) " esistente"))    
						(LM:DisplayBitmap "Chk2" (car  ImagesInstall$)) 
						T
					)
				)	
			)
		)
	)
	;
	(defun ControlPathEasyCut (PathEasyCut)
	
		(if (ValidateFolderEasyCut PathEasyCut)
			(progn
				(set_tile "FolderEasyCut"   PathEasyCut)
				(LM:DisplayBitmap "Chk3"	(car ImagesInstall$))
				T
			)
			(progn
				(set_tile "FolderEasyCut"   "Definire la posizione di EASYCUT")
				(LM:DisplayBitmap "Chk3"	(cadr ImagesInstall$))
				nil
			)
		)
	)
	;
	(defun MakeFileAcadDoc (PathRoaming / Stream Rtn)

		(if (setq Stream (open (strcat PathRoaming "\\" AcdDoc$) "w"))
			(progn
				(close Stream)
				(setq Rtn (findfile (strcat PathRoaming "\\" AcdDoc$)))
			)
		)
		Rtn
	)
	;
	(defun CreateDirRecursive (path)
 
		(setq path (vl-string-translate "/" "\\" path)) ; Uniforma le barre
		(if (not (vl-file-directory-p path))
			(progn
				(CreateDirRecursive (vl-filename-directory path)) ; Chiama se stessa per la cartella superiore
				(vl-mkdir path) ; Crea la cartella corrente
			)
		)
	)
	;
	(defun AddRoaming (PathEasyCutSupport Verbose / Flag currentPaths)


		(if PathEasyCutSupport
			(if (not (findfile PathEasyCutSupport))
				(setq Flag (CreateDirRecursive PathEasyCutSupport))
				(setq Flag T)
			)
		)
		
		(if Flag	
			(progn
				;; --- AGGIUNGI IL PERCORSO AD AUTOCAD ---
				(setq currentPaths (vla-get-SupportPath (vla-get-Files (vla-get-Preferences (vlax-get-acad-object)))))
				;; Verifica se il percorso è già presente per evitare duplicati
				(if (not (vl-string-search (strcase PathEasyCutSupport) (strcase currentPaths)))
					(progn
						(vla-put-SupportPath 
							(vla-get-Files (vla-get-Preferences (vlax-get-acad-object))) 
							(strcat currentPaths ";" PathEasyCutSupport)
						)
						(if Verbose (princ (strcat "\nPercorso aggiunto: " PathEasyCutSupport)))
						PathEasyCutSupport
					)
					(progn
						(if Verbose (princ "\nIl percorso e' già presente nelle Opzioni."))
						PathEasyCutSupport
					)
				)
			)
		)
	)
	;
	(defun InstallEasyCut (PathEasyCut PathRoaming)
	
		(if (and (ControlRegistry)
				 (ControlAcadDoc PathRoaming)
				 (ControlPathEasyCut PathEasyCut)
			)
			(if (setq Rtn (ConfigEasyCut PathEasyCut))
				(progn
					(LM:popup "avvertimento" (strcat "EasyCut installato con successo\n"
													 "+-----------------------------------------------------+\n"
													 "+ Dalla linea di comando di autocad\n"
													 "+ scrivere LOADEC per caricare il programma\n"
													 "+-----------------------------------------------------+") (+ 0 64 4096))
					T
				)
				(progn
					(LM:popup "avvertimento" "EasyCut non e' stato installato correttamente" (+ 0 16 4096))
					nil
				)
			)
		)
	)
	;
	(defun MakeDialogCheckInstall (/ Dcl Des)
	
		(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
		(setq Des (open Dcl "w"))
		(write-line "CheckInstallEasyCut:dialog {"																								Des)
		(write-line "   label=\"Install EasyCut\";"																								Des)
		(write-line "   :boxed_column {"																										Des)
		(write-line "       :row {"																												Des)
		(write-line "           :text   {width=15;   fixed_width=true; label=\"Registri\"; key=\"Fase1\";}"										Des)
		(write-line "           :text   {width=50;   fixed_width=true; label=\"Controllo registri\"; key=\"EasyCutRegistryControl\";}"			Des)
		(write-line "           :spacer {width=5;    fixed_width=true;}"																		Des)
		(write-line "           :image  {width=2.75; fixed_width=true; key=\"Chk1\";  fixed_height = true; aspect_ratio = 1.0; color = -15;}"	Des)
		(write-line "      }"																													Des)
		(write-line "      :row {"																												Des)
		(write-line "           :text   {width=15;   fixed_width=true; label=\"AcadDoc\"; key=\"Fase2\";}"										Des)
		(write-line "           :text   {width=50;   fixed_width=true; label=\"Controllo AcadDoc\"; key=\"EasyCutAcadDocControl\";}"			Des)
		(write-line "           :spacer {width=5;    fixed_width=true;}"																		Des)
		(write-line "           :image  {width=2.75; fixed_width=true; key=\"Chk2\"; fixed_height = true; aspect_ratio = 1.0; color = -15;}"	Des)
		(write-line "      }"																													Des)
		(write-line "      :row {"																												Des)
		(write-line "           :text   {width=15;   fixed_width=true; label=\"EasyCut Trusted\"; key=\"Fase3\";}"								Des)
		(write-line "           :text   {width=50;   fixed_width=true; label=\"Controllo EasyCut Trusted\"; key=\"EasyCutTrusted\";}"			Des)
		(write-line "           :spacer {width=5;    fixed_width=true;}"																		Des)
		(write-line "           :image  {width=2.75; fixed_width=true; key=\"Chk3\";  fixed_height = true; aspect_ratio = 1.0; color = -15;}"	Des)
		(write-line "      }"																													Des)
		(write-line "      :row {"																												Des)
		(write-line "           :text   {width=15;   fixed_width=true; label=\"EasyCut Preference\"; key=\"Fase4\";}"							Des)
		(write-line "           :text   {width=50;   fixed_width=true; label=\"Controllo EasyCut Preference\"; key=\"EasyCutPreference\";}"		Des)
		(write-line "           :spacer {width=5;    fixed_width=true;}"																		Des)
		(write-line "           :image  {width=2.75; fixed_width=true; key=\"Chk4\";  fixed_height = true; aspect_ratio = 1.0; color = -15;}"	Des)
		(write-line "      }"																													Des)
		(write-line "      :row {"																												Des)
		(write-line "           :text   {width=15;   fixed_width=true; label=\"EasyCut Folder\"; key=\"Fase5\";}"								Des)
		(write-line "           :text   {width=50;   fixed_width=true; label=\"Controllo Easy Cut Folder\"; key=\"EasyCutFolder\";}"			Des)
		(write-line "           :spacer {width=5;    fixed_width=true;}"																		Des)
		(write-line "           :image  {width=2.75; fixed_width=true; key=\"Chk5\";  fixed_height = true; aspect_ratio = 1.0; color = -15;}"	Des)
		(write-line "      }"																													Des)
		(write-line "   }"																														Des)
		(write-line "   ok_only;"																												Des)
		(write-line "}"																															Des)
		(write-line "exit_mybutton:retirement_button {"																							Des)
		(write-line "   label     = \"Esci\";"																									Des)
		(write-line "   key       = \"cancel\";"																								Des)
		(write-line "   is_cancel = true;"																										Des)
		(write-line "}"																															Des)
		(write-line "check_mybutton:retirement_button {"																						Des)
		(write-line "   label     = \"Controlla EasyCut\";"																						Des)
		(write-line "   key       = \"check\";"																									Des)
		(write-line "}"																															Des)
		(write-line "check_exit : column {"																										Des)	
		(write-line "    : row {"																												Des)
		(write-line "        fixed_width = true;"																								Des)
		(write-line "        alignment = centered;"																								Des)
		(write-line "        check_mybutton;"																									Des)
		(write-line "        :spacer { width = 2; }"																							Des)
		(write-line "        exit_mybutton;"																									Des)
		(write-line "    }"																														Des)
		(write-line "}"																															Des)
		(close Des)
		;(EasyCutViewer Dcl)
		Dcl
	)
	;
	(defun MakeDialogInstall (/ Dcl Des)
		(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
		(setq Des (open Dcl "w"))
		(write-line "InstallEasyCut:dialog {"																									Des)
		(write-line "   label=\"Install EasyCut\";"																								Des)
		(write-line "   :boxed_column {"																										Des)
		(write-line "       :row {"																												Des)
		(write-line "           :text   {width=15;   fixed_width=true; label=\"Registri\"; key=\"Fase1\";}"										Des)
		(write-line "           :text   {width=100;  fixed_width=true; label=\"Controllo registri\"; key=\"RegistryControl\";}"					Des)
		(write-line "           :spacer {width=5;    fixed_width=true;}"																		Des)
		(write-line "           :image  {width=2.75; fixed_width=true; key=\"Chk1\";  fixed_height = true; aspect_ratio = 1.0; color = -15;}"	Des)
		(write-line "      }"																													Des)
		(write-line "      :row {"																												Des)
		(write-line "           :text   {width=15;   fixed_width=true; label=\"AcadDoc\"; key=\"Fase2\";}"										Des)
		(write-line "           :text   {width=100;  fixed_width=true; label=\"Controllo AcadDoc\"; key=\"AcadDocControl\";}"					Des)
		(write-line "           :spacer {width=5;    fixed_width=true;}"																		Des)
		(write-line "           :image  {width=2.75; fixed_width=true; key=\"Chk2\"; fixed_height = true; aspect_ratio = 1.0; color = -15;}"	Des)
		(write-line "      }"																													Des)
		(write-line "      :row {"																												Des)
		(write-line "           :text   {width=15;   fixed_width=true; label=\"EasyCut Folder\"; key=\"Fase3\";}"								Des)
		(write-line "           :text   {width=100;  fixed_width=true; key=\"FolderEasyCut\";}"													Des)
		(write-line "           :spacer {width=5;    fixed_width=true;}"																		Des)
		(write-line "           :image  {width=2.75; fixed_width=true; key=\"Chk3\";  fixed_height = true; aspect_ratio = 1.0; color = -15;}"	Des)
		;(write-line "           :button {width=5;    fixed_width=true; label=\"...\"; key=\"ButtonFolder\";}"									Des)
		(write-line "      }"																													Des)
		(write-line "   }"																														Des)
		(write-line "   install_exit;"																											Des)
		(write-line "}"																															Des)
		(write-line "exit_mybutton:retirement_button {"																							Des)
		(write-line "   label     = \"Esci\";"																									Des)
		(write-line "   key       = \"cancel\";"																								Des)
		(write-line "   is_cancel = true;"																										Des)
		(write-line "}"																															Des)
		(write-line "install_mybutton:retirement_button {"																						Des)
		(write-line "   label     = \"Installa EasyCut\";"																						Des)
		(write-line "   key       = \"Install\";"																								Des)
		(write-line "}"																															Des)
		(write-line "install_exit : column {"																									Des)	
		(write-line "    : row {"																												Des)
		(write-line "        fixed_width = true;"																								Des)
		(write-line "        alignment = centered;"																								Des)
		(write-line "        install_mybutton;"																									Des)
		(write-line "        :spacer { width = 2; }"																							Des)
		(write-line "        exit_mybutton;"																									Des)
		(write-line "    }"																														Des)
		(write-line "}"																															Des)
		(close Des)
		;(EasyCutViewer Dcl)
		Dcl
	)
	;
	(defun UnpackEasyCutVersionWindows (ArchivePath DestinationFolder / flagFile psCmd wshShell)

		(if (and ArchivePath DestinationFolder)
			(progn
				(if (not (vl-file-directory-p DestinationFolder))(vl-mkdir DestinationFolder))

				(if (findfile ArchivePath)
					(progn
						; --------------------------------------------------------------------------------------------------
						(setq sh (vlax-create-object "Shell.Application"))
						(setq dest (vlax-invoke-method sh 'NameSpace DestinationFolder))
						(setq zip (vlax-invoke-method sh 'NameSpace ArchivePath))
						(setq items (vlax-invoke-method zip 'Items))
						(vlax-invoke-method dest 'CopyHere items 16)
						(vlax-release-object sh)
						;---------------------------------------------------------------------------------------------------
					)
				)
			)
		)
	)
	;
	(defun UnpackEasyCutVersion7z (ArchivePath DestinationFolder / WsShell ExePath Cmd)
		(if (and ArchivePath DestinationFolder)
			(progn
				(setq ExePath "C:\\Program Files\\7-Zip\\7zG.exe")
				(if (findfile ExePath)
					(progn
						(setq WsShell (vlax-create-object "WScript.Shell"))
						;; x      = estrazione con percorsi completi
						;; -o     = cartella di destinazione (senza spazio dopo -o)
						;; -y     = rispondi "Sì" a tutte le domande (sovrascrittura)
						(setq Cmd (strcat "\"" ExePath "\" x \"" ArchivePath "\" -o\"" DestinationFolder "\" -y"))
						;; 3. Esecuzione Sincrona
						;; 0          = finestra nascosta
						;; 1          = finestra normale
						;; :vlax-true = ATTENDE la fine del processo
						(vlax-invoke-method WsShell 'Run cmd 1 :vlax-true)
						(vlax-release-object WsShell)
						T
					)
					nil
				)
			)
		)
	)
	;
	(defun Get-Recursive-File-List (FolderPath / Get-Relative-List)

		(defun Get-Relative-List (CurrentPath RootPath / itm fileList subFolders subPath RelativePath)
			(if CurrentPath
				(progn
					(if (/= (substr CurrentPath (strlen CurrentPath)) "\\")
						(setq CurrentPath (strcat CurrentPath "\\"))
					)
					;; 1. FILES
					(setq fileList (vl-directory-files CurrentPath "*" 1))
					(foreach itm fileList
						(setq RelativePath (cons (substr (strcat CurrentPath itm) (1+ (strlen RootPath))) RelativePath))
					)
					;; 2. SUBFOLDERS
					(setq subFolders (vl-directory-files CurrentPath "*" -1))
					(foreach itm subFolders
						(if (and (/= itm ".") (/= itm ".."))
							(progn
								(setq subPath (strcat CurrentPath itm "\\"))
								(setq RelativePath (append (Get-Relative-List subPath RootPath) RelativePath))
							)
						)
					)
					RelativePath
				)
			)
		)
		(if FolderPath
			(progn
				;; Assicura il backslash alla radice prima di iniziare
				(if (/= (substr FolderPath (strlen FolderPath)) "\\")
					(setq FolderPath (strcat FolderPath "\\"))
				)
				(reverse (Get-Relative-List FolderPath FolderPath))
			)
		)
	)
	;
	(defun StartProgressBar (Text Num / LoadAceUiProgress)

		(if (boundp 'acet-ui-progress)
			(progn
				(acet-ui-progress Text Num)
				(setq $ProgBar$ 1)
			)
		)
	)
	;
	(defun UpDateProgressBar ()
		(if (boundp 'acet-ui-progress)
			(progn
				(acet-ui-progress $ProgBar$)
				(setq $ProgBar$ (1+ $ProgBar$))
			)
		)
	)
	;
	(defun ClearProgressBar ()

		(if (boundp 'acet-ui-progress)
			(progn
				(acet-ui-progress)
				(setq $ProgBar$ nil)
			)
		)
	)
	;
	(defun DclProgressBar (Title$ Message$ Delay~)

		(setq *dcl% (vl-filename-mktemp nil nil ".dcl"))
		(setq des (open *dcl% "w"))
		
		(write-line "ProgressBar : dialog {"									des)
		(write-line "  key = \"Title\";"										des)
		(write-line "  label = \"\";"											des)
		(write-line "  spacer;"													des)
		(write-line "  : text {"												des)
		(write-line "    key = \"Message\";"									des)
		(write-line "    label = \"\";"											des)
		(write-line "  }"														des)
		(write-line "  : row {"													des)
		(write-line "    : column {"											des)
		(write-line "      : spacer { height = 0.12; fixed_height = true;}"		des)
		(write-line "      : image {"											des)
		(write-line "        key = \"ProgressBar\";"							des)
		(write-line "        width = 44.5; fixed_width = true;"					des)
		(write-line "        height = 1.51; fixed_height = true;"				des)
		(write-line "        aspect_ratio = 1;"									des)
		(write-line "        color = -15;"										des)
		(write-line "        vertical_margin = none;"							des)
		(write-line "      }"													des)
		(write-line "      spacer;"												des)
		(write-line "    }"														des)
		(write-line "    cancel_button;"										des)
		(write-line "  }"														des)
		(write-line "  : text {"												des)
		(write-line "    key = \"Complete\";"									des)
		(write-line "    label = \"\";"											des)
		(write-line "  }"														des)
		(write-line "}"															des)
		(close des)

		(setq *Delay~ Delay~)
		(if (not *Speed#) (DclSpeed))

		(setq *Dcl_Id% (load_dialog *dcl%))
		(new_dialog "ProgressBar" *Dcl_Id%)
		(if (= Title$ "")(setq Title$ "AutoCAD Message"))
		(if (= Message$ "")(setq Message$ "Processing information..."))
		(set_tile "Title" (strcat " " Title$))
		(set_tile "Message" Message$)
		(setq *X# (1- (dimx_tile "ProgressBar")))
		(setq *Y# (1- (dimy_tile "ProgressBar")))
		(start_image "ProgressBar")
		(vector_image 0 2 2 0 8)
		(vector_image 2 0 (- *X# 2) 0 8)
		(vector_image (- *X# 2) 0 *X# 2 8)
		(vector_image *X# 2 *X# (- *Y# 2) 8)
		(vector_image (- *X# 2) *Y# *X# (- *Y# 2) 8)
		(vector_image (- *X# 2) *Y# 2 *Y# 8)
		(vector_image 2 *Y# 0 (- *Y# 2) 8)
		(vector_image 0 (- *Y# 2) 0 2 8)
		(end_image)
		(setq *Inc# 0 *Xpt# -4)
		(princ)
	)
	;
	(defun DclProgress (/ Complete$)
		(setq *Inc# (1+ *Inc#))
		(if (= (rem *Inc# 2) 1)
			(setq *Xpt# (+ *Xpt# 7))
		)
		(start_image "ProgressBar")
		(if (> *Inc# 100)
			(progn
				(setq *Inc# 0 *Xpt# -4)
				(start_image "ProgressBar")
				(fill_image 3 3 (- *X# 5) (- *Y# 5) -14)
			)
			(progn
				(vector_image *Xpt#  3 (+ *Xpt# 4)  3 120)
				(vector_image *Xpt#  4 (+ *Xpt# 4)  4 110)
				(vector_image *Xpt#  5 (+ *Xpt# 4)  5 110)
				(vector_image *Xpt#  6 (+ *Xpt# 4)  6 100)
				(vector_image *Xpt#  7 (+ *Xpt# 4)  7 100)
				(vector_image *Xpt#  8 (+ *Xpt# 4)  8  90)
				(vector_image *Xpt#  9 (+ *Xpt# 4)  9  90)
				(vector_image *Xpt# 10 (+ *Xpt# 4) 10  90)
				(vector_image *Xpt# 11 (+ *Xpt# 4) 11  90)
				(vector_image *Xpt# 12 (+ *Xpt# 4) 12 100)
				(vector_image *Xpt# 13 (+ *Xpt# 4) 13 100)
				(vector_image *Xpt# 14 (+ *Xpt# 4) 14 110)
				(vector_image *Xpt# 15 (+ *Xpt# 4) 15 110)
				(vector_image *Xpt# 16 (+ *Xpt# 4) 16 120)
			)
		)
		(end_image)
		(setq Complete$ (strcat (itoa (fix (+ *Inc# 0.5))) "% Complete..."))
		(set_tile "Complete" Complete$)
		(Dcldelay *Delay~)
		(action_tile "cancel" "(done_dialog)(exit)")
		(if (= *Inc# 100)(Dcldelay 10));Delay to show complete
	)
	;
	(defun DclPrgBr (Num~)
		(setq Reps~ (+ Reps~ (/ 100.0 Num~)))
		(repeat (fix Reps~) (DclProgress));Move the Progress Bar
		(setq Reps~ (- Reps~ (fix Reps~)))
	)
	;
	(defun DclEndProgressBar ( )
		(setq *Delay~ (* *Delay~ 0.5));Speed up bars remaining
		(if (and (> *Inc# 0)(< *Inc# 100))
			(repeat (- 100 *Inc#) (Progress))
		)
		(done_dialog)
		(start_dialog)
		(unload_dialog *Dcl_Id%)
		(vl-file-delete *dcl%)
		(setq *Dcl_Id% nil *Delay~ nil *Inc# nil *X# nil *Xpt# nil *Y# nil)
		(princ)
	)
	;
	(defun DclSpeed (/ Cdate~ Cnt# NewSecond# OldSecond#)
		(setq Cdate~ (getvar "CDATE"))
		(setq NewSecond# (fix (* (- (* (- Cdate~ (fix Cdate~)) 100000)(fix (* (- Cdate~ (fix Cdate~)) 100000))) 10)))
		(repeat 2
			(setq Cnt# 0)
			(setq OldSecond# NewSecond#)
			(while (= NewSecond# OldSecond#)
				(setq Cdate~ (getvar "CDATE"))
				(setq NewSecond# (fix (* (- (* (- Cdate~ (fix Cdate~)) 100000)(fix (* (- Cdate~ (fix Cdate~)) 100000))) 10)))
				(setq Cnt# (1+ Cnt#))
			)
		)
		(setq *Speed# Cnt#)
		(princ)
	)
	;
	(defun Dcldelay (Percent~ / Number~)
		(if (not *Speed#) (DclSpeed))
		(repeat (fix (* *Speed# Percent~)) (setq Number~ pi))
		(princ)
	)
	;
	(defun StartPopupPS (MainText SlaveText / Cmd)
  
	;; 1. Configura i percorsi (Script e file temporaneo per il PID)
		(setq $EasyCutPopupScriptPath$ 	(strcat (getenv "TEMP") "\\EasyCutPopup.ps1"))
		(setq $EasyCutPopupPidPath$ 	(strcat (getenv "TEMP") "\\EasyCutPopup_Pid.txt"))
	 
		;; 1.1 Crea il file scriptPath
		(if (MakeScriptPS $EasyCutPopupScriptPath$ MainText SlaveText)
			(progn
				;; Rimuove un eventuale vecchio file PID residuo
				(if (findfile $EasyCutPopupPidPath$) (vl-file-delete $EasyCutPopupPidPath$))
				;; 2. Comando pulito accettato dall'antivirus
				(setq Cmd (strcat "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File \"" $EasyCutPopupScriptPath$ "\""))
				;; 3. Esecuzione nascosta (Parametro 0 = Finestra invisibile)
				(setq $wshShell$ (vlax-create-object "WScript.Shell"))
				(vlax-invoke-method $wshShell$ 'Run Cmd 0 :vlax-false)
			)
		)
	)
	;
	(defun ClosePopupPS ( / fileId pidStr)

		;; 5. RECUPERA IL PID DALL'ARCHIVIO TEMPORANEO E CHIUDI IL POPUP
		(if (findfile $EasyCutPopupPidPath$)
			(progn
				;; Legge il file scritto da PowerShell
				(setq fileId (open $EasyCutPopupPidPath$ "r"))
				(setq pidStr (read-line fileId))
				(close fileId)
		  
				;; Chiude il processo in modo mirato tramite il PID estratto
				(vlax-invoke-method $wshShell$ 'Run (strcat "taskkill /f /pid " pidStr) 0 :vlax-false)
		  
				;; Cancella il file temporaneo per pulizia
				(vl-file-delete $EasyCutPopupPidPath$)
				(vl-file-delete $EasyCutPopupScriptPath$)
				;; (princ (strcat "\nPopup con PID " pidStr " chiuso correttamente.\n"))
			)
			(princ "\nErrore: Impossibile trovare il file temporaneo del PID.\n")
		)
		(if $wshShell$
			(progn
				(vlax-release-object $wshShell$)
				(setq $wshShell$ nil)
			)
		)
		(setq $EasyCutPopupPidPath$ nil) 
	)
	;
	(defun MakeScriptPS (FileName MainText SlaveText / Stream)
		(setq Stream (open FileName "w"))
		(if Stream
			(progn
				(write-line "$PID | Out-File -FilePath \"$env:TEMP\\EasyCutPopup_Pid.txt\" -Encoding ascii -Force" 					Stream)
				(write-line "Add-Type -AssemblyName PresentationFramework" 															Stream)
				(write-line "# 1. CREAZIONE DELLA FINESTRA (Stile Flat / Frameless)" 												Stream)
				(write-line "$form = New-Object System.Windows.Window" 																Stream)
				(write-line "$form.Width = 420" 																					Stream)
				(write-line "$form.Height = 160" 																					Stream)
				(write-line "$form.WindowStartupLocation = \"CenterScreen\""												 		Stream)
				(write-line "$form.Topmost = $true" 																				Stream)
				(write-line "$form.ResizeMode = \"NoResize\"" 																		Stream)
				(write-line "$form.WindowStyle = \"None\"" 																			Stream)
				(write-line "$form.AllowsTransparency = $true" 																		Stream)
				(write-line "$form.Background = \"Transparent\" # Permette l'arrotondamento degli angoli del bordo" 				Stream)
				(write-line "# 2. CONTENITORE PRINCIPALE (StackPanel per disporre gli elementi in verticale)" 						Stream)
				(write-line "$panel = New-Object System.Windows.Controls.StackPanel" 												Stream)
				(write-line "$panel.VerticalAlignment = \"Center\"" 																Stream)
				(write-line "$panel.Margin = \"25\"" 																				Stream)
				(write-line "# 3. TESTO PRINCIPALE" 																				Stream)
				(write-line "$textTitle = New-Object System.Windows.Controls.TextBlock" 											Stream)
				(write-line (strcat "$textTitle.Text = \"" MainText "\"")															Stream)
				(write-line "$textTitle.FontFamily = \"Segoe UI\"" 																	Stream)
				(write-line "$textTitle.FontSize = 14" 																				Stream)
				(write-line "$textTitle.FontWeight = \"Bold\"" 																		Stream)
				(write-line "$textTitle.Foreground = \"#107C41\" # Verde professionale (cambia in \"#0078D4\" per il blu Windows)" 	Stream)
				(write-line "$textTitle.HorizontalAlignment = \"Center\"" 															Stream)
				(write-line "$textTitle.Margin = \"0,0,0,5\"" 																		Stream)
				(write-line "# 4. SOTTOTESTO"		 																				Stream)
				(write-line "$textSub = New-Object System.Windows.Controls.TextBlock" 												Stream)
				(write-line (strcat "$textSub.Text = \"" SlaveText "\"")															Stream)
				(write-line "$textSub.FontFamily = \"Segoe UI\"" 																	Stream)
				(write-line "$textSub.FontSize = 12" 																				Stream)
				(write-line "$textSub.Foreground = \"#CCCCCC\" # Grigio chiaro per il testo secondario" 							Stream)
				(write-line "$textSub.HorizontalAlignment = \"Center\"" 															Stream)
				(write-line "$textSub.Margin = \"0,0,0,20\"" 																		Stream)
				(write-line "# 5. BARRA DI AVANZAMENTO ANIMATA (Indeterminata)" 													Stream)
				(write-line "$progressBar = New-Object System.Windows.Controls.ProgressBar" 										Stream)
				(write-line "$progressBar.Height = 4" 																				Stream)
				(write-line "$progressBar.IsIndeterminate = $true # Crea l'animazione a scorrimento continuo" 						Stream)
				(write-line "$progressBar.Foreground = \"#107C41\"  # Colore della barra animata" 									Stream)
				(write-line "$progressBar.Background = \"#333333\"  # Sfondo della barra vuota" 									Stream)
				(write-line "$progressBar.BorderThickness = \"0\"" 																	Stream)
				(write-line "# Assemblaggio degli elementi nel pannello" 															Stream)
				(write-line "$null = $panel.Children.Add($textTitle)" 																Stream)
				(write-line "$null = $panel.Children.Add($textSub)" 																Stream)
				(write-line "$null = $panel.Children.Add($progressBar)"		 														Stream)
				(write-line "# 6. BORDO ESTERNO CON ANGOLI ARROTONDATI (Contenitore estetico)" 										Stream)
				(write-line "$border = New-Object System.Windows.Controls.Border" 													Stream)
				(write-line "$border.BorderThickness = \"1\"" 																		Stream)
				(write-line "$border.BorderBrush = \"#444444\"       # Bordo grigio scuro sottile" 									Stream)
				(write-line "$border.Background = \"#1E1E1E\"        # Sfondo antracite scuro (Stile CAD)" 							Stream)
				(write-line "$border.CornerRadius = \"8\"             # Curvatura degli angoli (in pixel)" 							Stream)
				(write-line "$border.Child = $panel" 																				Stream)
				(write-line "# Assegna il bordo alla finestra" 																		Stream)
				(write-line "$form.Content = $border" 																				Stream)
				(write-line "# Mostra la finestra dialog" 																			Stream)
				(write-line "$form.ShowDialog()" 																					Stream)
				(close Stream)
			)
		)
		Stream
	)
	;
)
;
(defun UtilityUnInstall ()
	;
	(defun FindPathInstallerEasyCut (/ PathInstaller)
		(if (not (setq PathInstaller (vl-registry-READ EasyCutRegistryPath$ "PathInstaller")))
			(setq PathInstaller  (findfile (strcat LocalPathInstallEasyCut$ "\\EasyCut")))
		)
		PathInstaller
	)
	;
	(defun UnLoadRuntimeArxApp (LstApp / FindSubStringInListString itm ArxFile)
	
		(defun FindSubStringInListString (SubString ListString)
			(vl-remove-if-not
				'(lambda (voce)
					;; Usa * per indicare che la stringa può avere caratteri prima e dopo
					(wcmatch (strcase voce) (strcase (strcat "*" SubString "*")))
				)
				ListString
			)
		)
		(foreach itm LstApp
			(if (setq ArxFile (FindSubStringInListString itm (arx)))
				(arxunload (car ArxFile)(strcat "\nError unloading " (car ArxFile)))
			)
		)
	)
	;
	(defun UninstallEasyCut (/ PathInstaller)
	
		(setq PathInstaller (FindPathInstallerEasyCut))
		(if Pathinstaller
			(if (not (wcmatch (strcase Pathinstaller) "*BETA*"))
				(DeleteDir PathInstaller)
			)
		)

		(UnLoadRuntimeArxApp (list "SQLiteLsp" "OpenDcl"))
		(RemoveRegistryEasyCut)
		(RemoveOldInstallEasyCut)
		(RemoveTrustedEasyCut)
		(RemoveFolderPreference)

	)
	;
	(defun PopulateLstRegistry (LstRegistry / itm Rtn)
		(foreach itm LstRegistry
			(if (vl-registry-read EasyCutRegistryPath$ itm)
				(setq Rtn (append Rtn (list (strcat itm "\t" (vl-registry-read EasyCutRegistryPath$ itm) "\tAttivo"))))
				(setq Rtn (append Rtn (list (strcat itm "\t" "vuoto" "\tRegistro non esiste"))))
			)
		)
		Rtn
	)
	;
	(defun RefreshDialogInstallerEasyCut (/ LstAcadDoc LstTrusted LstPathInstaller LstPathPreference)
	
		(start_list "Registry")			
		(mapcar 'add_list (PopulateLstRegistry (vl-registry-descendents "HKEY_CURRENT_USER\\Software\\EasyCut" T)))
		(end_list)
		
		(if (findfile AcdDoc$)
			(if (not (CheckTraceEasyCutOnAcadDoc))
				(setq LstAcadDoc (list "[AcadDoc.lsp] Eliminato traccie EasyCut" (car ImagesInstall$)))
				(setq LstAcadDoc (list "[AcadDoc.lsp] Traccie presenti EasyCut"  (cadr ImagesInstall$)))
			)	
			(setq LstAcadDoc (list "[AcadDoc.lsp] Assente" (car ImagesInstall$)))
		)
		
		(if (not (CheckTraceEasyCutOnTrusted))
			(setq LstTrusted (list "[Trusted] Eliminato traccie EasyCut" (car ImagesInstall$)))
			(setq LstTrusted (list "[Trusted] Traccie presenti EasyCut"  (cadr ImagesInstall$)))
		)
		
		(if (not (FindPathInstallerEasyCut))
			(setq  LstPathInstaller (list "[PathInstallerEasyCut] Assente" (car ImagesInstall$)))
			(setq  LstPathInstaller (list "[PathInstallerEasyCut] Presente" (cadr ImagesInstall$)))
		)
		
		(if (not (CheckTraceEasyCutOnPreference))
			(setq  LstPathPreference (list "[PathPreference] Eliminato traccie EasyCut" (car ImagesInstall$)))
			(setq  LstPathPreference (list "[PathPreference] Traccie presenti EasyCut"  (cadr ImagesInstall$)))
		)
	
		
		(set_tile "AcadDocControl" 				(car  LstAcadDoc))
		(LM:DisplayBitmap "Chk1" 				(cadr LstAcadDoc))

		(set_tile "TrustedpathsControl" 		(car  LstTrusted))
		(LM:DisplayBitmap "Chk2" 				(cadr LstTrusted))

		(set_tile "FolderEasyCutControl" 		(car  LstPathInstaller))
		(LM:DisplayBitmap "Chk3" 				(cadr LstPathInstaller))

		(set_tile "FolderEasyCutPreference" 	(car  LstPathPreference))
		(LM:DisplayBitmap "Chk4" 				(cadr LstPathPreference))
	)
	;
	(defun CheckTraceEasyCutOnAcadDoc (/ FileNameAcadDoc Stream LineRead LstLine itm Rtn)
	
		(setq FileNameAcadDoc (findfile AcdDoc$))
		(if FileNameAcadDoc
			(if (setq Stream (open FileNameAcadDoc "r"))
				(progn
					(setq LineRead 	(read-line Stream))
					(while LineRead
						(setq LstLine (append LstLine (list LineRead)))
						(setq LineRead 	(read-line Stream))
					)
					(close Stream)
					(foreach itm LstLine
						(if (vl-string-search (strcase "EasyCut") (strcase itm))
							(setq Rtn T)
						)
					)
				)
			)
		)
		Rtn
	)
	;
	(defun CheckTraceEasyCutOnTrusted (/ TrustedPath Rtn)
		(setq TrustedPath (getvar 'trustedpaths))
		(if TrustedPath
			(if (vl-string-search (strcase "EasyCut") (strcase TrustedPath))
				(setq Rtn T)
			)
		)
	)
	;
	(defun CheckTraceEasyCutOnPreference ()
		(if (vl-string-search (strcase "EasyCut") (strcase (getenv "ACAD")))
			T
			nil
		)
	)
	;
	(defun ChechTracePathEasyCut ()
		(FindPathInstallerEasyCut)
	)
	;
	(defun CheckTraceRegistryEasyCut ()
		(vl-registry-descendents "HKEY_CURRENT_USER\\Software\\EasyCut" T)
	)
	;
	(defun MakeDialogUninstall (/ Dcl Des)
		(setq Dcl (vl-filename-mktemp nil nil ".dcl"))
		(setq Des (open Dcl "w"))
		(write-line "UnInstallEasyCut:dialog"																											Des)
		(write-line "   {"																																Des)
		(write-line "       label=\"UnInstall EasyCut\";"																								Des)
		(write-line "       :boxed_column {label=\"Registry\";"																							Des)
		(write-line "           :row { fixed_width=true;"																								Des)
		(write-line "                  :text_part {width=21;  fixed_width=true; label=\" Nome\"; }"														Des)
		(write-line "                  :text_part {width=85;  fixed_width=true; label=\"Valore\";}"														Des)
		(write-line "                  :text_part {width=10;  fixed_width=true; label=\"Stato\"; }"														Des)
		(write-line "           }"																														Des)
		(write-line "           :list_box {"																											Des)
		(write-line "                       key = \"Registry\";"																						Des)
		(write-line "                       width = 120.0;"																								Des)
		(write-line "                       height = 20.0;"																								Des)
		(write-line "                       fixed_width = true;"																						Des)
		(write-line "                       fixed_height = true;"																						Des)
		(write-line "                       tabs = \"20 100\";"																							Des)
		(write-line "           }"																														Des)
		(write-line "           :row {"																													Des)
		(write-line "                   :text   {width=20;    fixed_width=true; label=\"AcadDoc\";}"													Des)
		(write-line "                   :text   {width=90;    fixed_width=true; key=\"AcadDocControl\";}"												Des)
		(write-line "                   :spacer {width=5;     fixed_width=true;}"																		Des)
		(write-line "                   :image  {width=2.75;  fixed_width=true; key=\"Chk1\"; fixed_height = true; aspect_ratio = 1.0; color = -15;}"	Des)
		(write-line "           }"																														Des)
		(write-line "           :row {"																													Des)
		(write-line "                   :text   {width=20;    fixed_width=true; label=\"Trustedpaths\";}"												Des)
		(write-line "                   :text   {width=90;    fixed_width=true; key=\"TrustedpathsControl\";}"											Des)
		(write-line "                   :spacer {width=5;     fixed_width=true;}"																		Des)
		(write-line "                   :image  {width=2.75;  fixed_width=true; key=\"Chk2\"; fixed_height = true; aspect_ratio = 1.0; color = -15;}"	Des)
		(write-line "           }"																														Des)
		(write-line "           :row {"																													Des)
		(write-line "                   :text   {width=20;   fixed_width=true; label=\"EasyCut Folder Installer \";}"									Des)
		(write-line "                   :text   {width=90;   fixed_width=true; key=\"FolderEasyCutControl\";}"											Des)
		(write-line "                   :spacer {width=5;    fixed_width=true;}"																		Des)
		(write-line "                   :image  {width=2.75; fixed_width=true; key=\"Chk3\";  fixed_height = true; aspect_ratio = 1.0; color = -15;}"	Des)
		(write-line "           }"																														Des)
		(write-line "           :row {"																													Des)
		(write-line "                   :text   {width=20;   fixed_width=true; label=\"Folder Preference \";}"											Des)
		(write-line "                   :text   {width=90;   fixed_width=true; key=\"FolderEasyCutPreference\";}"										Des)
		(write-line "                   :spacer {width=5;    fixed_width=true;}"																		Des)
		(write-line "                   :image  {width=2.75; fixed_width=true; key=\"Chk4\";  fixed_height = true; aspect_ratio = 1.0; color = -15;}"	Des)
		(write-line "           }"																														Des)
		(write-line "       }"																															Des)
		(write-line "       uninstall_exit;"																											Des)
		(write-line "}"																																	Des)
		(write-line "exit_mybutton:retirement_button {"																									Des)
		(write-line "   label     = \"Esci\";"																											Des)
		(write-line "   key       = \"cancel\";"																										Des)
		(write-line "   is_cancel = true;"																												Des)
		(write-line "}"																																	Des)
		(write-line "uninstall_mybutton:retirement_button {"																							Des)
		(write-line "   label     = \"Elimina EasyCut\";"																								Des)
		(write-line "   key       = \"uninstall\";"																										Des)
		(write-line "}"																																	Des)
		(write-line "uninstall_exit : column {"																											Des)	
		(write-line "    : row {"																														Des)
		(write-line "        fixed_width = true;"																										Des)
		(write-line "        alignment = centered;"																										Des)
		(write-line "        uninstall_mybutton;"																										Des)
		(write-line "        :spacer { width = 2; }"																									Des)
		(write-line "        exit_mybutton;"																											Des)
		(write-line "    }"																																Des)
		(write-line "}"																																	Des)
		(close Des)
		;(EasyCutViewer Dcl)
		Dcl
	)
	;
	(defun IsPathEasyCutPreferenceActive (/ currentPaths)
		(setq currentPaths (getenv "ACAD"))
		(if (vl-string-search (strcase "EasyCut") (strcase currentPaths))
			T
			nil
		)
	)
	;
	(defun RemoveFolderPreference (/ itm StrAcad)
		(setq StrAcad "")
		(foreach itm (splitxt (getenv "ACAD") ";")
			(if (not (wcmatch (strcase itm) (strcase "*EasyCut*")))
				(setq StrAcad (strcat StrAcad itm ";"))		
			)
		)
		(if (not (= StrAcad ""))
			(setenv "ACAD" (vl-string-right-trim ";" StrAcad))
		)
	)
	;
	(defun DeleteDir (Path / fso Rtn)
		; return
		;	T    	Successo
		;	nil  	Fallimento (es. file aperti o permessi negati)
		;	-1 		La cartella non esiste
		;	-2 		Il nome della cartella è nil
		
		(if Path
			(if (vl-file-directory-p Path)
				(progn
					(setq fso (vlax-get-or-create-object "Scripting.FileSystemObject"))
					(setq Rtn 
						(if (not (vl-catch-all-error-p (vl-catch-all-apply 'vlax-invoke (list fso 'DeleteFolder Path :vlax-true))))
							T    ; Successo
							nil  ; Fallimento (es. file aperti o permessi negati)
						)
					)
					(vlax-release-object fso)
				)
				(setq Rtn -1) ; La cartella non esiste
			)
			(setq Rtn -2) ; Il nome della cartella è nil
		)
		Rtn
	)
	;
	(defun RemoveRegistryEasyCut ()
			;; Prima elimina in modo ciclico tutte le sottochiavi esistenti
			(foreach sottochiave (vl-registry-descendents EasyCutRegistryPath$)
				(CancellaChiaveRicorsiva (strcat EasyCutRegistryPath$ "\\" sottochiave))
			)
			;; Quando la chiave è finalmente vuota da altre cartelle, la elimina definitivamente
			(vl-registry-delete EasyCutRegistryPath$)
	)
	;
	(defun RemoveTrustedEasyCut (/ LstTrustedPath Flag itm StrLstTrust)
	
		(if (getvar 'trustedpaths)
			(progn
				(setq LstTrustedPath (getvar 'trustedpaths))
				(setq Flag T)
				(if LstTrustedPath
					(foreach itm (LM:str->lst LstTrustedPath ";")
						(if (not (vl-string-search (strcase "EasyCut") (strcase itm)))
							(if Flag
								(progn
									(setq StrLstTrust itm)
									(setq Flag nil)
								)
								(setq StrLstTrust (strcat StrLstTrust ";" itm))
							)
						)
					)
				)
				(if StrLstTrust 
					(setvar 'trustedpaths StrLstTrust)
					(setvar 'trustedpaths "")
				)
				T
			)
		)
	)
)	
;
(defun ServerUtility ()

	(defun DownloadReleaseEasyCut (Url Verbose / *error* GetLastVersion ProgNumber Assemble7zCmd
														 UrlVersion Flag UrlDownload
														 FolderDownload FileWildCard Extension 
														 InfoVersion LastVersion CountZip CountFile itm Pos LstFileDownload LstPackFile)

		;
		(defun *error* (msg)
		  (or (wcmatch (strcase msg) "*BREAK,*CANCEL*,*EXIT*")
			  (princ (strcat "\n** Error: " msg " **")))
		  (princ)
		)
		;
		(defun GetLastVersion (url Verbose) 
			(ReadServerFile Url Verbose)
		)
		;
		(defun ProgNumber (Num NumCar)
			(if (and Num NumCar)
				(progn
					(setq Rtn (itoa Num))
					;; Aggiunge zeri finché la stringa non è lunga 3 caratteri
					(while (< (strlen Rtn) NumCar)
						(setq Rtn (strcat "0" Rtn))
					)
				)
			)
		)
		;
		(defun Assemble7zCmd (Folder LstFile FileDest Verbose / StringFile itm CommandBatch Shell Rtn)
		
			(if (and Folder LstFile FileDest)
				(progn
				
					(if (findfile FileDest) (vl-file-delete FileDest))
					(setq StringFile "")
					(foreach itm LstFile
						(if (= StringFile "")
							(setq StringFile (strcat "\"" Folder "\\" itm "\""))
							(setq StringFile (strcat StringFile " + " "\"" Folder "\\" itm "\""))
						)
					)
					(if Verbose 
						(setq CommandBatch (strcat "cmd.exe /k copy /b /y " StringFile " \"" FileDest "\""))
						(setq CommandBatch (strcat "cmd.exe /c copy /b /y " StringFile " \"" FileDest "\""))
					)
					(if (setq Shell (vlax-create-object "WScript.Shell"))
						(progn
							(if Verbose 
								(setq Rtn (vlax-invoke-method shell 'Run CommandBatch 1 :vlax-true))
								(setq Rtn (vlax-invoke-method shell 'Run CommandBatch 0 :vlax-true))
							)
							(foreach itm LstFile
								(vl-file-delete (strcat Folder "\\" itm))
							)
							(vlax-release-object shell)
						)
					)
				)
			)
			Rtn
		)
		;
		(defun GetInfoVersion (UrlVersion Verbose / Rf Pos Line InfoVersion LastVersion CountZip CountFile LstFile Rtn)
			(if UrlVersion
				(progn
					(if (findfile (strcat (getenv "TEMP") "\\version.txt")) (vl-file-delete (strcat (getenv "TEMP") "\\version.txt")))
					(DownloadServerFileActiveX UrlVersion (strcat (getenv "TEMP") "\\version.txt") Verbose)
					(setq Rf (open (strcat (getenv "TEMP") "\\version.txt") "r"))
					(if Rf 
						(progn
							(setq Pos 1)
							(setq Line (read-line Rf))
							(while Line 
								(cond 
									((= Pos 1)
										(setq InfoVersion (splitxt Line " "))
										(setq LastVersion (car   InfoVersion))
										(setq CountZip    (cadr  InfoVersion))
										(setq CountFile   (caddr InfoVersion))
										(setq Rtn (list LastVersion CountZip CountFile))
										(setq Pos (1+ Pos))
									)
									(T
										;+ Apps\Banner.exe
										(if (= (substr Line 1 1) "+")
											(setq LstFile (cons (substr Line 3) LstFile))
										)
									)
								)
								(setq Line (read-line Rf))
							)
							(close Rf)
							(setq LstFile (reverse LstFile))
							(setq Rtn (list Rtn LstFile))
						)
					)
				)
			)
			Rtn
		)
		;
		; Main +++
		;
		(if (TestConnection "https://www.easycutnesting.it/" Verbose)
			(progn
				;(setq Url 				 "https://github.com/EasyCutNesting/easycut")
				;(setq UrlVersion  		 "https://github.com/EasyCutNesting/easycut/releases/latest/download/version.txt")
				;(setq UrlDownload 		 "https://github.com/EasyCutNesting/easycut/releases/download/5.1.3/")
				;(setq UrlVersion  		 "https://EasyCutProject.altervista.org/wp-content/EasyCut/Download/version.txt")
				;(setq UrlDownload 		 "https://EasyCutProject.altervista.org/wp-content/EasyCut/Download/")
				;(setq UrlVersion  		 "https://adlproeng.altervista.org/EasyCut/Download/version.txt")
				;(setq UrlDownload 		 "https://adlproeng.altervista.org/EasyCut/Download/")
				
				(setq UrlVersion  (strcat Url "/releases/latest/download/version.txt"))
				
				(StartPopupPS "CONNESSIONE AL SERVER" "verifica release")
				
				(setq FolderDownload 	 (getenv "TEMP"))
				(setq FileWildCard		 "EasyCut_")
				(setq Extension          ".zip")
				
				(if (CheckRemoteFile UrlVersion Verbose)
					(progn
						(setq InfoVersion (GetInfoVersion UrlVersion Verbose))
						;(setq InfoVersion (splitxt (GetLastVersion UrlVersion Verbose) " "))
						(setq LastVersion (car (car InfoVersion)))
						(setq CountZip    (cadr (car InfoVersion)))
						(setq CountFile   (caddr (car InfoVersion)))
						;(setq UrlDownload (strcat "https://github.com/EasyCutNesting/easycut/releases/download/" LastVersion "/"))
						(setq UrlDownload (strcat Url "/releases/download/" LastVersion "/"))
						(setq Pos 1)
						(repeat (atoi CountZip)
							; EasyCut_5.1.3.zip.001
							(setq LstFileDownload (append LstFileDownload (list (strcat FileWildCard LastVersion Extension "." (ProgNumber Pos 3)))))
							(setq Pos (1+ Pos))
						)
					)
				)
				
				(foreach itm LstFileDownload
					(setq Flag T)
					(if (not (CheckRemoteFile (strcat UrlDownload itm) nil))
						(setq Flag nil)
					)
				)
				
				(ClosePopupPS)
				
				(if Flag 
					(if (= (LM:popup "avvertimento" "I file sono disponibili per il download \n vuoi proseguire ?" (+ 1 32 4096)) 1)
						(progn

							(DeleteFilesWildCard (getenv "TEMP") (strcat FileWildCard LastVersion Extension "." "*"))
							; --------------------------------------------------------+
							(StartProgressBar "Download EasyCut" (atoi CountZip))
							(setq NfileLsp$ (atoi CountZip))
							(DclProgressBar "" "Load EasyCut" 0.1) (setq Reps~ 1)
							; --------------------------------------------------------+
							
							(foreach itm LstFileDownload

								; --------------------------------------------------------+
								(UpDateProgressBar)
								(DclPrgBr NfileLsp$)
								; --------------------------------------------------------+

								(if (not (DownloadServerFileActiveX (strcat UrlDownload itm) 
																	(strcat FolderDownload "\\" itm) Verbose))
									(progn
										(setq Flag nil)
										(LM:popup "Errore" "Download EasyCut fallito" (+ 0 16 4096))
										(exit)
									)
								)
							)
							; --------------------------------------------------------+
							(ClearProgressBar)
							(DclEndProgressBar)
							; --------------------------------------------------------+
							(LM:popup "avvertimento" "Download EasyCut terminato" (+ 0 64 4096))
						)
						(progn
							(setq Flag nil)
							(princ "\n")
						)
					)
				)
				(if Flag
					(progn
						(if (Assemble7zCmd (getenv "TEMP") LstFileDownload (strcat (getenv "TEMP") "\\" FileWildCard LastVersion Extension) Verbose)
							(setq LstPackFile 	(list (strcat (getenv "TEMP") "\\" FileWildCard LastVersion Extension) 
														InfoVersion
												)
							)
						)
					)
				)
			)
		)
		LstPackFile
	)
	;
	(defun DeleteFilesWildcard (Folder WildCardFile / Fso)
		; (DeleteFilesWildcard (getenv "TEMP") "\\*7z*")
		(if (setq Fso (vlax-create-object "Scripting.FileSystemObject"))
			(progn
				(vl-catch-all-apply
					'(lambda ()
						;; Il metodo DeleteFile di FSO supporta i wildcard (* e ?)
						(vlax-invoke-method Fso 'DeleteFile (strcat Folder "//" WildCardFile) :vlax-true)
					)
				)
				(vlax-release-object fso)
			)
		)
	)
	;
	(defun FindFilesWildcard (Folder WildCardFile / Fso Rtn)

		; (FindFilesWildcard (getenv "TEMP") "*7z*")
		(if (and Folder WildCardFile)
			(if (setq Fso (vlax-create-object "Scripting.FileSystemObject"))
				(progn
					(vlax-for file (vlax-get-property (vlax-invoke-method fso 'GetFolder Folder) 'Files)
						(if (wcmatch (strcase (vlax-get-property file 'Name)) (strcase WildCardFile))
							(setq Rtn (append Rtn (list (vlax-get-property file 'Name))))
						)
					)
					(vlax-release-object fso)
				)
			)
		)
		Rtn
	)
	;
	(defun RecursiveFindFilesWildcard (Folder WildCardFile / Fso Rtn _Search)
		;; Esempio d'uso: (RecursiveFindFilesWildcard "C:\\EasyCutNesting Beta" "*RectPack*")
		(defun _Search (CurrentFolder)
			(vlax-for file (vlax-get-property CurrentFolder 'Files)
				(if (wcmatch (strcase (vlax-get-property file 'Name)) (strcase WildCardFile))
					(setq Rtn (append Rtn (list (vlax-get-property file 'Path))))
				)
			)
			(vlax-for subfolder (vlax-get-property CurrentFolder 'SubFolders)
				(_Search subfolder)
			)
		)
		;
		; Main
		;
		(if (and Folder WildCardFile)
			(if (setq Fso (vlax-create-object "Scripting.FileSystemObject"))
				(progn
					(if (vlax-invoke-method fso 'FolderExists Folder)
						(_Search (vlax-invoke-method fso 'GetFolder Folder))
					)
					(vlax-release-object fso)
				)
			)
		)
		Rtn
	)

	;
	(defun GetDownloadsPath ( / path)
		(setq path (vl-registry-read 
				   "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders" 
				   "{374DE290-123F-4565-9164-39C4925E467B}"))
	  
		;; Se il percorso contiene %USERPROFILE%, lo sostituiamo con il percorso reale
		(if (and path (vl-string-search "%USERPROFILE%" path))
			(setq path (vl-string-subst (getenv "USERPROFILE") "%USERPROFILE%" path))
		)
		path
	)
	;
	(defun CreateHttp () ; create and return WinHttpRequest object
		(cond
			((vlax-create-object "WinHttp.WinHttpRequest.5.1"))
			((vlax-create-object "WinHttp.WinHttpRequest.5"))
		)
	)
	;
	(defun OpenGetHttp (url return Verbose / http result) ; perform HTTP request
		(setq http (CreateHttp))
		(setq result
			(vl-catch-all-apply
				(function
					(lambda ()
						(vlax-invoke-method http "Open" "GET" url :vlax-false)
						;(vlax-invoke-method http "SetRequestHeader" "User-Agent" "OpenDCL AllSamples")
						(vlax-invoke-method http "Send")
						(vlax-get-property http return)
					)
				)
			)
		)
		(vlax-release-object http)
		(if (vl-catch-all-error-p result)
			(progn 
				(if Verbose (princ (strcat "\n[OpenGetHttp] ERROR: " (vl-catch-all-error-message result))))
				(setq result nil)
			)
			(if Verbose (princ "\n[OpenGetHttp] Reading completed"))
		)
		result
	)
	;
	(defun ServerResponse (webObj / Status)
		(if webObj
			(progn
				(setq Status (vlax-get-property webObj 'Status))
				(cond
					((= Status 200)	(setq Rtn (list Status "[ServerResponse] 200 Connessione riuscita")))
					((= Status 201)	(setq Rtn (list Status "[ServerResponse] 201 (Created): La richiesta ha portato alla creazione di una nuova risorsa")))
					((= Status 204)	(setq Rtn (list Status "[ServerResponse] 204 (No Content): Richiesta elaborata, ma non c'e' contenuto da restituire")))
					((= Status 301)	(setq Rtn (list Status "[ServerResponse] 301 (Moved Permanently): La risorsa e' stata spostata definitivamente a un nuovo indirizzo")))
					((= Status 302) (setq Rtn (list Status "[ServerResponse] 302 (Found): Spostamento temporaneo della risorsa")))
					((= Status 304)	(setq Rtn (list Status "[ServerResponse] 304 (Not Modified): La risorsa non e' cambiata dall'ultima richiesta (usato per la cache)")))
					((= Status 400) (setq Rtn (list Status "[ServerResponse] 400 (Bad Request): La richiesta non e' valida o e' scritta in modo errato")))
					((= Status 401)	(setq Rtn (list Status "[ServerResponse] 401 (Unauthorized): Mancano le credenziali di autorizzazione")))
					((= Status 403) (setq Rtn (list Status "[ServerResponse] 403 (Forbidden): Accesso vietato alla risorsa richiesta")))
					((= Status 404)	(setq Rtn (list Status "[ServerResponse] 404 (Not Found): La risorsa (pagina o file) non esiste sul server")))
					((= Status 429)	(setq Rtn (list Status "[ServerResponse] 429 (Too Many Requests): L'utente ha inviato troppe richieste in un breve intervallo di tempo")))
					((= Status 500) (setq Rtn (list Status "[ServerResponse] 500 (Internal Server Error): Errore generico lato server")))
					((= Status 502) (setq Rtn (list Status "[ServerResponse] 502 (Bad Gateway): Un server intermedio ha ricevuto una risposta non valida da un server a monte")))
					((= Status 503)	(setq Rtn (list Status "[ServerResponse] 503 (Service Unavailable): Il server e' sovraccarico o in manutenzione temporanea")))
					((= Status 504)	(setq Rtn (list Status "[ServerResponse] 504 (Gateway Timeout): Il server ha atteso troppo a lungo una risposta da un altro server")))
					(t
						(setq Rtn (list Status "[ServerResponse] (Errore Generico): Non catalogato"))
					)
				)
			)
		)
	)
	;
	(defun CheckRemoteFile (Url Verbose / winhttp url status exists Rtn)

		; (CheckRemoteFile "https://adlproeng.altervista.org/EasyCut/Download/version.txt" T)

		(if (setq winhttp (CreateHttp))
			(progn
				(if Verbose (princ (strcat "\n[CheckRemoteFile] Verify file exist : " url )))
				;; Utilizziamo "HEAD" invece di "GET" per non scaricare il file
				(vlax-invoke-method winhttp 'Open "HEAD" url :vlax-false)
		  
				;; Invio della richiesta con gestione errori base
				(if (vl-catch-all-error-p (setq err (vl-catch-all-apply 'vlax-invoke-method (list winhttp 'Send))))
					(princ (strcat "\n[CheckRemoteFile] Error connecting: " (vl-catch-all-error-message err)))
					(progn
						;; Recupera lo stato HTTP (200 = Esiste, 404 = Non trovato)
						(setq status (vlax-get-property winhttp 'Status))
			  
						(if (= status 200)
							(progn 
								(setq Rtn T)
								(setq exists "Ok")
							)
							(setq exists (strcat "[CheckRemoteFile] Error file not found (Error: " (itoa status) ")"))
						)
						(if Verbose (princ (strcat " --> " exists)))
					)
				)
		  
				;; Rilascia l'oggetto
				(vlax-release-object winhttp)
			)
			(if Verbose (princ "\n[CheckRemoteFile] Error: Unable to initialize WinHttp.WinHttpRequest.5.1"))
		)
		Rtn
	)
	;
	(defun ReadServerFile (Url Verbose)
		
		;
		; (ReadServerFile "https://adlproeng.altervista.org/visetvirtus/testconnection/test.txt" T)
		;
		(OpenGetHttp Url "ResponseText" Verbose)
	)
	;
	(defun DownloadServerFileCmd (Url DestFile Verbose / Shell CommandBatch Rtn)
		;; 1. Definisci l'URL del file da scaricare
		;(setq Url "https://adlproeng.altervista.org/EasyCut/Download/version.txt")
		;; 2. Definisci il percorso locale dove salvare il file
		;; Nota: Usa i doppi backslash \\ per i percorsi Windows in LISP
		;(setq DestFile (strcat (getenv "TEMP") "\\file_scaricato.txt"))
	  
		;; 3. Costruisci la stringa del comando cURL
		;; L'opzione -o (minuscola) permette di specificare il nome del file locale
		;; L'opzione -L è utile se l'URL ha dei reindirizzamenti (redirect)
		(if Verbose 
			(setq CommandBatch (strcat "cmd.exe /k curl -L -o \"" DestFile "\" " Url))
			(setq CommandBatch (strcat "cmd.exe /c curl -L -o \"" DestFile "\" " Url))
		)
		
		(if (setq Shell (vlax-create-object "WScript.Shell"))
			(progn
				(if Verbose 
					(setq Rtn (vlax-invoke-method shell 'Run CommandBatch 1 :vlax-true))
					(setq Rtn (vlax-invoke-method shell 'Run CommandBatch 0 :vlax-true))
				)
				(vlax-release-object shell)
			)
		)
		Rtn
	)
	;
	(defun DownloadServerFileActiveX (Url OutPutFileName Verbose / WriteFile DownloadServerFile) ; download File via HTTP, return responsebody
		;
		; es URL "https://adlproeng.altervista.org/visetvirtus/testconnection/test.txt" 
		;
		; (DownloadFileFromWeb "https://adlproeng.altervista.org/visetvirtus/testconnection/test.txt" (strcat (getenv "TEMP") "\\FileWeb.itxt") T)
		;
		;
		;
		(defun DownloadServerFile (Url Verbose / Result) ; download MSI via HTTP, return responsebody
		
			(if Verbose (princ "\n[DownloadServerFile] Downloading file..."))
			(setq Result (OpenGetHttp url "ResponseBody" Verbose))
			(if Result
				(if (and Result (= (type result) 'VARIANT) (not (zerop (vlax-variant-type result))))
					(if Verbose (princ "\n[DownloadServerFile] Downloaded successfully!"))
					(progn
						(if Verbose (princ "\n[DownloadServerFile] ERROR: The server's response did not contain any data!"))
						(setq Result nil)
					)
				)
			)
			Result
		)	
		;
		(defun WriteFile (Url OutPutFileName Verbose / result fso) ; write downloaded File to temp folder, return file path
		
			(if (setq result (DownloadServerFile Url Verbose))
				(progn
					(setq fso (vlax-create-object "Scripting.FileSystemObject"))
					(setq result
					(vl-catch-all-apply
						(function
							(lambda (/ tempfolder filepath adostream filestream)
								(if Verbose (princ "\n[WriteFile] Copying files to disk..."))
								
								;(setq tempfolder (vlax-invoke-method fso "GetSpecialFolder" 2))
								;(setq filepath (strcat (vlax-get-property tempfolder "Path") "\\" FileName))
								;(vlax-release-object tempfolder)
								;(setq filepath (strcat (vlax-get-property tempfolder "Path") "\\" FileName))
								
								(cond
									((setq adostream (vlax-create-object "ADODB.Stream"))
										(setq result 
											(vl-catch-all-apply
												(function
													(lambda ()
														(if (= :vlax-true (vlax-invoke-method fso "FileExists" OutPutFileName))
															(vlax-invoke-method fso "DeleteFile" OutPutFileName :vlax-true)
														)
														(vlax-put adostream "Type" 1) ;1 = binary
														(vlax-invoke adostream "Open")
														(vlax-invoke-method adostream "Write" result)
														(vlax-put adostream "Position" 0)
														(vlax-invoke adostream "SaveToFile" OutPutFileName)
														(vlax-invoke-method adostream "Close")
														OutPutFileName
													)
												)
											)
										)
										(vlax-release-object adostream)
									)
									((setq filestream (vlax-invoke-method fso "CreateTextFile" OutPutFileName :vlax-true :vlax-false))
										(setq result
											(vl-catch-all-apply
												(function
													(lambda ()
														(foreach element (vlax-safearray->list (vlax-variant-value result))
															(vlax-invoke filestream "Write" (chr (+ 256 (logand 255 element))))
														)
														(vlax-invoke-method filestream "Close")
														OutPutFileName
													)
												)
											)
										)
										(vlax-release-object filestream)
									)
								)
								(if (vl-catch-all-error-p result)
									(progn 
										(if Verbose (princ (strcat "\n[WriteFile] ERROR: " (vl-catch-all-error-message result)))) 
										(setq OutPutFileName nil)
									)
									(if Verbose (princ "\n[WriteFile] File copied successfully!"))
								)
								OutPutFileName
							)
						)
					)
				)
				(if fso (vlax-release-object fso))
					(if (vl-catch-all-error-p result)
						(progn 
							(if Verbose (princ (strcat "\n[WriteFile] ERROR: " (vl-catch-all-error-message result))))
							(setq result nil)
						)
					)
					result
				)
			)
			result
		)
		;
		;
		; Main ++++
		;
		(if (CheckRemoteFile Url Verbose)
			(WriteFile Url OutPutFileName Verbose) 
		)
	)
	;
	(defun TestConnection (Url Verbose / WebObj Res Msg Rtn)

		; (TestConnection "https://www.google.com" T)
		
		
		(setq WebObj (CreateHttp))
	  
		;; Tenta l'apertura e l'invio
		(vlax-invoke-method webObj 'Open "GET" Url :vlax-false)
		(setq Res (vl-catch-all-apply 'vlax-invoke-method (list webObj 'Send)))

		(cond
			;; CASO 1: Errore critico (Rete assente o dominio errato)
			((vl-catch-all-error-p Res)
				(if Verbose 
					(progn
						(setq Msg (vl-catch-all-error-message res))
						(princ (strcat "\n[TestConnection] Connection error: " Msg))
						(princ "\n[TestConnection] Possible cause: Unplugged cable, DNS failure, or malformed URL.")
					)
				)
			)
			;; CASO 2: Connessione riuscita, controllo risposta del server
			(t
				(setq Rtn (ServerResponse WebObj))
				(if Verbose (princ (strcat "\n"(cadr Rtn))))
				(if (= (car Rtn) 200) (setq Rtn t))
			)
		)
		(if WebObj (vlax-release-object WebObj))
		Rtn
	)
	;
	(defun SpliTxt (testo char / ncar glo temp a bak)
	;
	; procedura per la suddivisione di un testo
	; testo  .......= testo da esaminare
	; char .........= carattere separatore
	;
	(setq ncar (strlen testo) glo 1 temp "" bak nil)
	;
	 (while (<= glo ncar)
	   (setq a (substr testo glo 1))
	   (if (/= a char)
		   (progn
			 (while (and (/= a char) (<= glo ncar))
				(setq temp (strcat temp a) glo (+ 1 glo) a (substr testo glo 1))
			 )
			 (setq bak (append bak (list temp)) temp "")
		   )
		   (setq glo (+ 1 glo))
	   )
	 )

	 (if (= bak nil) 
		 (setq bak (list ""))
	 )

	 (setq bak bak)
	)
	; --------------------------------------------------------------------------------------------------------------
)
;
(UtilityInstall)
;
(UtilityUnInstall)
;
(ServerUtility)
;
(setq LocalPathInstallEasyCut$ (strcat (getenv "LocalAppData") "\\Programs"))
(if (not (findfile LocalPathInstallEasyCut$)) (CreateDirRecursive LocalPathInstallEasyCut$))
(setq EasyCutRegistryPath$ "HKEY_CURRENT_USER\\Software\\EasyCut")
(setq ImagesInstall$
        '(
            (
                -15 088 095 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                088 073 081 073 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                088 083 073 081 097 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                251 093 083 073 081 099 -15 -15 -15 -15 -15 -15 -15 -15 -15 -15
                009 079 083 083 073 073 253 -15 -15 -15 -15 -15 -15 -15 -15 -15
                -15 -15 088 083 083 073 083 -15 -15 -15 -15 -15 -15 -15 -15 -15
                -15 -15 -15 096 084 095 093 088 -15 -15 -15 -15 -15 -15 -15 -15
                -15 -15 -15 -15 094 084 084 084 086 -15 -15 -15 -15 254 097 -15
				-15 -15 -15 -15 -15 084 084 084 084 085 -15 -15 254 097 009 252
                -15 -15 -15 -15 -15 098 084 084 084 096 087 253 088 093 009 085
                -15 -15 -15 -15 -15 069 094 084 084 084 084 084 084 084 081 254
                -15 -15 -15 -15 -15 -15 098 094 094 084 084 084 084 084 097 -15
                -15 -15 -15 -15 -15 -15 251 096 094 094 084 084 084 084 009 -15
                -15 -15 -15 -15 -15 -15 -15 099 098 096 094 084 094 087 -15 -15
                -15 -15 -15 -15 -15 -15 -15 008 099 096 096 098 -15 -15 -15 -15
                -15 -15 -15 -15 -15 -15 -15 -15 253 251 -15 -15 -15 -15 -15 -15
			)
			(
                -15 -15 -15 -15 -15 -15 -15 -15	-15 -15 -15 -15 254 015 015 -15
                -15 253 025 -15 -15 -15 -15 -15	-15 -15 -15 019 021 021 021 254
                254 251 015 013 009 -15 -15 -15	-15 -15 028 021 021 021 015 -15
                -15 009 251 026 021 023 -15 -15	254 016 021 021 021 028 254 -15
                -15 -15 254 008 028 021 017 254	026 021 021 015 253 -15 -15 -15
                -15 -15 -15 -15 252 019 021 026	021 011 008 254 -15 -15 -15 -15
                -15 -15 -15 -15 -15 252 026 021	015 009 -15 -15 -15 -15 -15 -15
                -15 -15 -15 -15 254 016 012 028	013 026 -15 -15 -15 -15 -15 -15
                -15 -15 -15 254 016 022 025 008	016 022 024 -15 -15 -15 -15 -15
                -15 -15 -15 026 022 035 -15 254	251 022 022 016 -15 -15 -15 -15
                -15 -15 017 022 027 -15 -15 -15	009 019 022 022 026 -15 -15 -15
                -15 253 022 019 -15 -15 -15 -15	-15 008 024 022 022 023 -15 -15
                254 024 028 -15 -15 -15 -15 -15	-15 009 019 022 022 022 -15 -15
                017 018 -15 -15 -15 -15 -15 -15	-15 -15 252 016 013 013 253 -15
                253 -15 -15 -15 -15 -15 -15 -15	-15 -15 254 251 026 013 009 -15
                -15 -15 -15 -15 -15 -15 -15 -15	-15 -15 -15 254 008 253 -15 -15
			)
		)
)	
(setq AcdDoc$ "acaddoc.lsp")
(textscr)
(if (not (vl-registry-read "HKEY_CURRENT_USER\\Software\\EasyCut" "Version"))
	(progn
		(princ "\n-------------------------------------------------------")
		(princ "\nIl file di configurazione di EasyCut e' stato caricato")
		(princ "\nper installare EasyCut digita InstallEasyCut")
		(princ "\n-------------------------------------------------------\n")
		(princ)
		(LM:popup "Informazione" "Il file di configurazione di EasyCut e' stato caricato \n per installare EasyCut digita InstallEasyCut" (+ 0 64 4096))
	)
)