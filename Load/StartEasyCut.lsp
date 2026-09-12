(vl-load-com)
(setq EasyCutRegistryPath$	"HKEY_CURRENT_USER\\Software\\EasyCut")
;
;
(defun RegistrySetup (/ CheckStatusInstallEasyCut PopulateVariableRegistryEasyCut 
						RemoveVariableRegistryEasyCut FillVariableRegistryEasyCut ValidateFolderEasyCut PutVersion PurgeRegistryEasyCut
						DefaultPathCfg
						DefaultFileCfg
						FileCfg
						FileDxfJob
						ArrayColumn
						ArrayRow
						Leader
						Symula
						SymulaChoiseShape
						Sentinel
						;Internet
						PathOtherBrowser
						MenuCfg
						LstVarOnRegistry
						PathInstaller Version Rtn)
						
						
						
	(defun CheckStatusInstallEasyCut ()
		(if (and (vl-registry-read EasyCutRegistryPath$ "PathInstaller")
				 (vl-registry-read EasyCutRegistryPath$ "Version")
				 (vl-registry-read EasyCutRegistryPath$ "FirstInstaller")
			)
			T
			nil
		)
	)						
	;
	;
	(defun PopulateVariableRegistryEasyCut (ListRegistry / itm)
			(foreach itm ListRegistry
				(vl-registry-write EasyCutRegistryPath$ (cadr itm) (car itm))
			)
	)
	;
	;
	(defun RemoveVariableRegistryEasyCut (ListRegistry / itm)
			(foreach itm ListRegistry
				(vl-registry-delete EasyCutRegistryPath$ (cadr itm))
			)
	)
	;
	;
	(defun FillVariableRegistryEasyCut (ListRegistry / itm)
			(foreach itm ListRegistry
				(if (not (vl-registry-read EasyCutRegistryPath$ (cadr itm))) 
					(vl-registry-write EasyCutRegistryPath$ (cadr itm) (car itm))
				)
			)
	)
	;
	;
	(defun ValidateFolderEasyCut (PathInstaller / Rtn)
	
		(if PathInstaller
			(if (findfile (strcat PathInstaller "\\Dbase\\Release.lsp"))
				(setq Rtn T)
			)
		)
	)
	;
	;
	(defun PutVersion (/ Path rf Rtn)

		(if (setq Path (vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
			(if (setq rf (open (strcat Path "\\Dbase\\Release.lsp") "r"))
				(progn
					(setq Rtn (read-line rf))
					(close rf)
				)
			)
		)
		Rtn
	)
	;
	;
	(defun PurgeRegistryEasyCut (/ LstRegistryInstallCmd itm LstRnt Num FileCfg)
	
		;
		; Remove Configuration +++
		;
		(if (and (vl-registry-read EasyCutRegistryPath$ "PathCfg") (vl-registry-read EasyCutRegistryPath$ "FileCfg"))
			(progn
				(setq FileCfg (strcat (vl-registry-read EasyCutRegistryPath$ "PathCfg") "\\" (vl-registry-read EasyCutRegistryPath$ "FileCfg")))
				(if (and FileCfg (findfile FileCfg))
					(vl-file-delete  FileCfg)
				)
			)
		)
	
		(setq LstRegistryInstallCmd '("FirstInstaller" "PathInstaller" "Version"))
		(foreach itm LstRegistryInstallCmd
			(setq LstRnt (append LstRnt (list (vl-registry-read EasyCutRegistryPath$ itm))))
		)
		(vl-registry-delete EasyCutRegistryPath$)
		
		(setq Num 0)
		(foreach itm LstRegistryInstallCmd
			(vl-registry-write EasyCutRegistryPath$ itm (nth Num LstRnt))
			(setq Num (1+ Num))
		)
	)
	;
	; Set variable on registry EasyCut
	;	
	(setq 	$PathWorkDefault 		(strcat (getenv "USERPROFILE") 	"\\EasyCut")				; PathWork
			$PathSearchDefault 		$PathWorkDefault											; PathSearch
			$PathNcDefault			(strcat $PathWorkDefault 		"\\Cnc")					; PathNc
			$PathInfoDefault		(strcat $PathWorkDefault 		"\\Info")					; PathInfo
			$PathOutputDefault		(strcat $PathWorkDefault 		"\\Output")					; PathOutput
			$PathDocsDefault		(strcat $PathWorkDefault 		"\\Output\\Docs")			; PathDocs
			$PathNestingDefault		(strcat $PathWorkDefault 		"\\Output\\Nesting")		; PathNesting
			$PathDxfJobDefault		$PathWorkDefault											; PathDxfJob
			$PathCfgDefault			(strcat (getenv "LOCALAPPDATA") "\\EasyCut")				; PathCfg
			
			DefaultPathCfg			$PathCfgDefault												; DefaultPathCfg
			DefaultFileCfg			"Default.cfg"												; DefaultFileCfg
			FileCfg					DefaultFileCfg												; FileCfg
			FileDxfJob				""															; FileDxfJob
			ArrayColumn				"1"															; ArrayColumn
			ArrayRow				"2"															; ArrayRow
			Leader					""															; Leader
			Symula					"0"															; Symula
			SymulaChoiseShape		"10"														; SymulaChoiseShape
			Sentinel				"0"															; Sentinel
			;Internet            	""															; Internet
			PathOtherBrowser    	""															; PathOtherBrowser
			MenuCfg					""															; MenuCfg
	)

	(setq 	LstVarOnRegistry (list 	(list $PathWorkDefault 		"PathWork")
									(list $PathSearchDefault 	"PathSearch")
									(list $PathNcDefault		"PathNc")
									(list $PathInfoDefault		"PathInfo")
									(list $PathOutputDefault	"PathOutput")
									(list $PathDocsDefault		"PathDocs")
									(list $PathNestingDefault	"PathNesting")
									(list $PathDxfJobDefault	"PathDxfJob")
									(list $PathCfgDefault		"PathCfg")
			
									(list DefaultPathCfg		"DefaultPathCfg")
									(list DefaultFileCfg		"DefaultFileCfg")
									(list FileCfg				"FileCfg")
									(list FileDxfJob			"FileDxfJob")
									(list ArrayColumn			"ArrayColumn")
									(list ArrayRow				"ArrayRow")
									(list Leader				"Leader")
									(list Symula				"Symula")
									(list SymulaChoiseShape		"SymulaChoiseShape")
									(list Sentinel				"Sentinel")
									;(list Internet            	"Internet")
									(list PathOtherBrowser    	"PathOtherBrowser")
									(list MenuCfg				"MenuCfg")
							)
	)
			
	; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	;
	(if (= (vl-registry-read EasyCutRegistryPath$ "FirstInstaller") "1")
		(PurgeRegistryEasyCut)
	)
	;
	; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	(if (CheckStatusInstallEasyCut)	
		(progn					; InstallEasyCut ha scritto i registri e configurato correttamente AcadDoc.lsp ++++++++++++++++++++++++++++++
			(cond
				((= (vl-registry-read EasyCutRegistryPath$ "FirstInstaller") "1")
					(vl-registry-write EasyCutRegistryPath$ "FirstInstaller" "0")
					(RemoveVariableRegistryEasyCut LstVarOnRegistry)
					(PopulateVariableRegistryEasyCut LstVarOnRegistry)
					(LM:popup "Info" (strcat "Inizializzazione EasyCut") (+ 0 64 4096))
				)
				((= (vl-registry-read EasyCutRegistryPath$ "FirstInstaller") "0")
					(FillVariableRegistryEasyCut LstVarOnRegistry)
				)
			)
			(setq PathInstaller (vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
			(setq Version 		(vl-registry-read EasyCutRegistryPath$ "Version"))
			(setq Rtn T)
		)
		(progn					; InstallEasyCut non ha scritto i registri ma ha configurato correttamente AcadDoc.lsp +++++++++++++++++++++
			(setq PathInstaller (LM:browseforfolder "Seleziona la directory di installazione EasyCut" nil 0))
			(if (ValidateFolderEasyCut PathInstaller)
				(progn
					(vl-registry-write EasyCutRegistryPath$ "PathInstaller"  PathInstaller)
					(vl-registry-write EasyCutRegistryPath$ "Version" (PutVersion))
					(vl-registry-write EasyCutRegistryPath$ "FirstInstaller" "0")
					(RemoveVariableRegistryEasyCut LstVarOnRegistry)
					(PopulateVariableRegistryEasyCut LstVarOnRegistry)
					(LM:popup "Info" (strcat "Inizializzazione EasyCut") (+ 0 64 4096))
					(LM:popup "Release" (strcat "EasyCut " (vl-registry-read EasyCutRegistryPath$ "Version")) (+ 0 64 4096))
					(setq Rtn T)
				)
				(LM:popup "Info" (strcat "Sembra che la directory di EasyCut non esista o incompleta") (+ 0 64 4096))
			)
		)
	)
	Rtn
)
;
;
(defun MyLoad (FileName / *error*)

	(defun *error* (msg)
		(alert (strcat FileName " -> Not Loaded " msg))
	)
	
	(if (findfile FileName)
		(progn
			(princ (strcat "\nLoad --------> " FileName)) 
			(load FileName)
			(princ " -> ok")
		)
		
	)
)
;
;
(defun MyLoadVba (FileName / *error*)

	(defun *error* (msg)
		(alert (strcat FileName " -> Not Loaded " msg))
	)

	(if (findfile FileName)
		(progn
			(princ (strcat "\nLoad --------> " FileName)) 
			(vl-vbaload  FileName)
			(princ " -> ok")
		)
		
	)
)
;
;
(defun PrgBr (Num~)
	(setq Reps~ (+ Reps~ (/ 100.0 Num~)))
	(repeat (fix Reps~) (Progress));Move the Progress Bar
	(setq Reps~ (- Reps~ (fix Reps~)))
)
;
;
(defun c:LoadEC (/ Path Reps~ SetupPathEasyCut SetupFileEasyCut PathEasyCut FileEasyCut)

	(if (RegistrySetup) ; funziona se il file AcadDoc.lsp è stato caricato
		(progn
			;
			(setq Path 	(vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
			(MyLoad (strcat Path "\\Gui\\LoadGui.lsp"))
			(MyLoad (strcat Path "\\Gui\\ProgressBar.lsp"))
			(MyLoad (strcat Path "\\Bin\\LoadBin.lsp"))
			(MyLoad (strcat Path "\\Html\\LoadHtml.lsp"))
			(MyLoad (strcat Path "\\SqLite\\LoadSqLite.lsp"))
			(MyLoad (strcat Path "\\OpenDcl\\LoadOpenDcl.lsp"))
			(MyLoad (strcat Path "\\Excel\\ToolsExcel.lsp"))
			(MyLoad (strcat Path "\\Load\\LoadInstallEasyCut.lsp"))
			
			(setq NfileLsp$ 70)
			(ProgressBar "" "Load EasyCut" 0.1)
			(setq Reps~ 1)
			(LoadGui     		Path)
			(LoadBin     		Path)
			(LoadHtml    		Path)
			(LoadSqLite  		Path)
			(LoadOpenDcl 		Path)
			(LoadInstallEasyCut Path)
			(EndProgressBar)
			;
			; Setup ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(LoadDefaultSetup)
			(setq PathEasyCut 		(vl-registry-read EasyCutRegistryPath$ "PathCfg"))
			(setq FileEasyCut 		(vl-registry-read EasyCutRegistryPath$ "FileCfg"))
			
			(if (findfile (strcat PathEasyCut "\\" FileEasyCut))
				(progn
					(LoadClientSetupEasyCut (strcat PathEasyCut "\\" FileEasyCut))
					(setq NameConfigurationEasyCut$ (strcat PathEasyCut "\\" FileEasyCut))
				)
				(progn
					(setq PathEasyCut 		(vl-registry-read EasyCutRegistryPath$ "DefaultPathCfg"))
					(setq FileEasyCut 		(vl-registry-read EasyCutRegistryPath$ "DefaultFileCfg"))
					(setq NameConfigurationEasyCut$ (strcat PathEasyCut "\\" FileEasyCut))
				)
			)
			
			(setq VersionEasyCut$ 	(vl-registry-read EasyCutRegistryPath$ "Version"))
			(vl-registry-write EasyCutRegistryPath$ "PathCfg" PathEasyCut)
			(vl-registry-write EasyCutRegistryPath$ "FileCfg" FileEasyCut)
			;
			; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(setq BinPathEasyCut$     	  (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Bin\\"  ))  				; archivio Bin
			(setq LibPathEasyCut$     	  (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Lib\\"  ))  				; archivio libreria blocchi
			(setq DbaseEasyCut$ 		  (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Dbase\\"))   				; path DataBase
			(setq LoadEasyCut$ 			  (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Load\\" ))  	 			; path Load

			(setq GuiPathEasyCut$     	  (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Gui\\"  ))  				; archivio interfaccia grafica DCL
			(setq FontPathEasyCut$    	  (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Font\\" ))  				; archivio font

			(setq ExpertNestingEasyCut$   (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Apps\\DxfNest\\" ))  		; archivio DxfNest
			(setq RectPackNestingEasyCut$ (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Apps\\RectPack\\" ))  		; archivio RectPack

			(setq ExampleEasyCut$ 		  (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Example\\"))   			; path esempi

			(SaveSetupEasyCut 			  (strcat PathEasyCut "\\" FileEasyCut) "\nconfigurazione client salvata -> ")
			
			;(startapp (strcat (vl-registry-read EasyCutRegistryPath$ "PathInstaller") "\\Apps\\Banner.exe"))
			
			(DefCommand)
			(EasyCutStartUp)
			(setq Path 				nil
				  Reps~				nil
				  SetupPathEasyCut 	nil
				  SetupFileEasyCut 	nil
				  PathEasyCut 		nil
				  FileEasyCut		nil
			)
			;
			(if (IfOpenDcl)
				(progn
					(MenuOpenDcl)
				)
				(progn
					(princ "\n+------------------------------------------------------------+")
					(princ "\n+ terminato il caricamento scrivere EC per usare il programma")
					(princ "\n+------------------------------------------------------------+")
				)
			)
			;
			(PowerShellDiag T)
		)
	)
	(princ)
)
;
;
(defun C:clsp (/ LstFile itm)

  
	(if (= _PathLsp$_ nil) (setq _PathLsp$_ "c:/"))
	(setq LstFile (LM:getfiles "Seleziona file" _PathLsp$_ "lsp"))
    
	(foreach itm LstFile
         (setq _PathLsp$_ (vl-filename-directory itm))
		 (princ (strcat "\nLoad " itm))
         (load itm)
    )
)
;
;
(defun C:cdcl (/ xx nome_dialog LstFile itm)

  
	(if (= _PathDcl$_ nil) (setq _PathDcl$_ "c:/"))
	(setq LstFile (LM:getfiles "Seleziona file" _PathDcl$_ "dcl"))
	
	(foreach itm LstFile
		 (setq _PathDcl$_ (vl-filename-directory itm))
		 (princ (strcat "\nLoad " itm))
         (setq xx (load_dialog itm))
         (setq nome_dialog (getstring "\nDare il nome della procedura da lanciare  "))
         (new_dialog nome_dialog xx)
         (start_dialog)
         (done_dialog)
         (unload_dialog xx)
      )
)
;
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
;
(princ "\n+------------------------------------------------+")
(princ "\n+ Dalla linea di comando di autocad")
(princ "\n+ scrivere LOADEC per caricare il programma")
(princ "\n+------------------------------------------------+")
(setq EasyCutLoad$ T)
(princ)



