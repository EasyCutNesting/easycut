;(MyGetField "C:\\deluca\\lavoro" "gigi.txt")
;
;
;
(defun MyGetField (PathStart FileSearch Ext / 	*error* dch dcl des
											GetFileField GetFileOut GetLstFolder UpdateBoxFile UpdateBoxFolder ActionToFolder LM:getfiles:updir LM:getfiles:browseforfolder
											PathS FileS LstFolder LstFile TmpLst Tmp Rtn)


	(defun *error* ( msg )
        (if (= 'file (type des))
            (close des)
        )
        (if (and (= 'int (type dch)) (< 0 dch))
            (unload_dialog dch)
        )
        (if (and (= 'str (type dcl)) (findfile dcl))
            (vl-file-delete dcl)
        )
        (if (and msg (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*")))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )    
	;
	;
	;
	(defun GetFileOut (/ Path File Rtn)
	
		(setq Path  (get_tile "Dir"))
		(setq File (get_tile "FileOut"))
		;(if (and (/= Dir "") (/= File ""))
		;	(setq Rtn (strcat Dir "\\" File))
		;)				
		(list Path File)
	)
	;
	;
	;
	(defun GetFileField (LstFile / File Rtn)

		(if LstFile
			(progn
				(setq File (nth (atoi (get_tile "BoxFiles")) LstFile))
				(if File (set_tile "FileOut" File))
			)
		)
		(GetFileOut)
	)
	;
	;
	;
	(defun GetLstFolder (Path / LstFolder itm Rtn)

		(if Path
			(progn
				(setq LstFolder (vl-directory-files Path nil -1))
				(foreach itm LstFolder			
					(if (not (equal "." itm))
						(setq Rtn (append Rtn (list itm)))
					)
				)
			)
		)
		Rtn
	)
	;
	;
	;
	(defun UpdateBoxFile (Path Ext / LstFile)
	
		(setq LstFile (vl-directory-files Path Ext 1))
		
		(start_list "BoxFiles")
			(mapcar 'add_list LstFile)
		(end_list)
		LstFile
	)
	;
	;
	;
	(defun PurgePath (Path / Rtn Num Loop)
	
		(setq Rtn Path)
		(setq Num (strlen Rtn))
		(setq Loop T)
		(while Loop
			(if (or (= (substr Rtn Num 1) (chr 47) ) (= (substr Rtn Num 1) (chr 92)))
				(setq Rtn (substr Rtn 1 (1- Num)))
				(setq Loop nil)
			)
			(setq Num (1- Num))
			(if (= Num 1) (setq Loop nil))
		)
		Rtn
	)
	;
	;
	;
	(defun UpdateBoxFolder (Path / LstFolder)
	
		(setq LstFolder (GetLstFolder Path))
		(set_tile "Dir" Path)
				
		(start_list "BoxFolders")
			(mapcar 'add_list LstFolder)
		(end_list)
		LstFolder
	)
	;
	;
	;
	(defun ActionToFolder (LstFolders Ext / Folder LstFile LstFolder)
		
	
		(setq Folder (nth (atoi (get_tile "BoxFolders")) LstFolders))
		
		(if (equal ".." Folder)
			(setq PathS	 (LM:getfiles:updir PathS))
			(setq PathS  (strcat PathS "\\" (nth (atoi (get_tile "BoxFolders")) LstFolders)))
		)
		
		
		(setq LstFolder (UpdateBoxFolder 	PathS))
		(setq LstFile 	(UpdateBoxFile 		PathS Ext))
		
		(list LstFolder LstFile)
	)
	;
	;
	;
	(defun LM:getfiles:updir ( dir / Folder)
		(setq Folder (substr dir 1 (vl-string-position 92 dir nil t)))
	)
	;
	;
	;
	(defun LM:getfiles:browseforfolder ( msg dir flg / err fld pth shl slf )
		(setq err
			(vl-catch-all-apply
				(function
					(lambda ( / app hwd )
						(if (setq app (vlax-get-acad-object)
								shl (vla-getinterfaceobject app "shell.application")
								hwd (vl-catch-all-apply 'vla-get-hwnd (list app))
								fld (vlax-invoke-method shl 'browseforfolder (if (vl-catch-all-error-p hwd) 0 hwd) msg flg dir)
							)
							(setq slf (vlax-get-property fld 'self)
								pth (LM:getfiles:fixdir (vlax-get-property slf 'path))
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
	; Main
	;
	(setq PathStart (PurgePath PathStart))
	(if (and (setq dcl (vl-filename-mktemp nil nil ".dcl"))
             (setq des (open dcl "w"))
             (progn
                (foreach x
                   '(
						"handle_folder_list:dialog "
						"{"
						"	key=\"title\";"
						"	label=\"Explorer File\";"
						"	:row {" 
						"		:edit_box {"
						"			label=\"Directory\";"
						"			key=\"Dir\";"
						"		}"
						"		: button {"
						"			key   = \"Brw\";"
						"			label = \"Browse\";"
						"			fixed_width = true;"
						"		}"
						"	}"
						"	:row {"
						"		:boxed_column {"
						"			:list_box {"
						"				label=\"Lista Directory\";"
						"				key=\"BoxFolders\";"
						"				width=50;"
						"			}"
						"		}"
						"		:boxed_column {"
						"			:list_box {"
						"				label=\"Lista File\";"
						"				key=\"BoxFiles\";"
						"				width=50;"
						"			}"
						"		}"
						"	}"
						"	:row {"
						"		:edit_box {"
						"			label=\"File\";"
						"			key=\"FileOut\";"
						"		}"
						"	}"
						"	ok_cancel;"
						"}"   
                    )
                    (write-line x des)
                )
                (setq des (close des))
                (< 0 (setq dch (load_dialog dcl)))
            )
            (new_dialog "handle_folder_list" dch "" (cond ( *handle_folder_list* ) ( '(-1 -1) )))
        )
		(progn
			
			
			(if PathStart
				(if (not (vl-file-directory-p PathStart))
					(setq PathS OutputPathEasyCut$)
					(setq PathS PathStart)
				)
				(setq PathS OutputPathEasyCut$)
			)
			(setq FileS FileSearch)
			
		
			(setq LstFolder (UpdateBoxFolder 	PathS))
			(setq LstFile 	(UpdateBoxFile 		PathS Ext))
			(if PathS (set_tile "Dir" PathS))
			(if FileS (set_tile "FileOut" FileS))
			
			
			(action_tile "BoxFolders" 
				(vl-prin1-to-string	
					'(if (= 4 $reason) 
						(setq TmpLst (ActionToFolder LstFolder Ext)
							  LstFolder (car TmpLst)
						      LstFile 	(cadr TmpLst)
						)
					)
				)
			)
			
			(action_tile "BoxFiles" 
				(vl-prin1-to-string	
					'(setq Rtn (GetFileField LstFile))
				)
			)
			
			(action_tile "Brw"
                (vl-prin1-to-string
                   '(if (setq Tmp (LM:getfiles:browseforfolder "" nil 512))
                        (setq PathS Tmp
							  LstFolder (UpdateBoxFolder 	PathS)
							  LstFile 	(UpdateBoxFile 		PathS Ext)
						)
                    )
                )
            )

			(action_tile "cancel" (strcat 	"(setq Rtn nil)"
											"(setq *handle_folder_list* (done_dialog)) (unload_dialog dch)"))
			
			(action_tile "accept" (strcat 	"(setq Rtn (GetFileOut))"
											"(setq *handle_folder_list* (done_dialog)) (unload_dialog dch)"))
			
			(start_dialog)
		)
	)
	(*error* nil)
	Rtn
)
;
;
;
(defun OkCancel (Text1 Text2 / xx Rtn)
	
		(setq xx (load_dialog (strcat GuiPathEasyCut$ "geocut.dcl")))
		(new_dialog "OkCancel" xx "" (cond ( *OkCancel* ) ( '(-1 -1) )))
		
		(set_tile "prompt1" Text1)
		(set_tile "prompt2" Text2)
		
		(action_tile "accept"   (strcat "(setq Rtn T)"
										"(setq *OkCancel* (done_dialog)) (unload_dialog xx)"
								))
		(action_tile "cancel"   (strcat "(setq Rtn nil)"
										"(setq *OkCancel* (done_dialog)) (unload_dialog xx)"
								))
		(start_dialog)
		Rtn
)
