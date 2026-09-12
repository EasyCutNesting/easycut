;(OpenFileDialog  '("C:\\Users\\delucaa\\Documents" "install.dwg" "*.dwg|*.zip|*.*" "FileDialog" nil T))
(defun OpenFileDialog (LstParameter / MakeButtons UpDateButtons GetFileOut GetFileField GetLstFolder UpdateBoxFile PurgePath UpdateBoxFolder
									  UpdatePopUp ActionToFolder LM:getfiles:updir LM:getfiles:browseforfolder SortList SortBox BoxToList ListToBox MakeDclFile
									  PathStart LstButtonFolderKey LstButtonFileKey TypeDataFolder TypeDataFile FileDcl xx PathS FileS Filter Title MultiSelect ForceSelect
									  LstExt LstFolder LstFile  
									  Rtn Tmp)

	; Lst Parameter
	;
	;	0 InitialDirectory
	;   1 FileName
	;   2 Filter
	;   3 Title
	;   4 Multiselect
	;	5 ForceSelect
	;
	(defun MakeButtons (LstButtonKey LstStatusButton / XVect YVect Num Key XKey YKey XMKey YMKey X Y)
		
		(setq XVect (list (list -6 6 0)
						  (list -6 6 0)
					))
		(setq YVect (list (list -2 -2 2)
						  (list 2 2 -2)
					))
		(setq Num 0)
		(foreach Key LstButtonKey
			(setq XKey  (dimx_tile Key))
			(setq YKey  (dimy_tile Key))
			(setq XMKey (/ (dimx_tile Key) 2))
			(setq YMKey (/ (dimy_tile Key) 2))
			(start_image Key) 
			(fill_image 0 0 XKey YKey -15)
			(cond 
				((= (nth Num LstStatusButton) 1)
					(setq X (nth 0 XVect))
					(setq Y (nth 0 YVect))
				)	
				((= (nth Num LstStatusButton) -1)
					(setq X (nth 1 XVect))
					(setq Y (nth 1 YVect))
				)	
			)
			(if (and X Y)
				(progn
					(vector_image (+ XMKey (nth 0 X)) (+ YMKey (nth 0 Y)) (+ XMKey (nth 1 X)) (+ YMKey (nth 1 Y)) 250)
					(vector_image (+ XMKey (nth 1 X)) (+ YMKey (nth 1 Y)) (+ XMKey (nth 2 X)) (+ YMKey (nth 2 Y)) 250)
					(vector_image (+ XMKey (nth 2 X)) (+ YMKey (nth 2 Y)) (+ XMKey (nth 0 X)) (+ YMKey (nth 0 Y)) 250)
				)
			)
			(end_image)
			(setq Num (1+ Num))
			(setq X nil) (setq Y nil)
		)
	)
	;
	(defun UpDateButtons (Key LstButtonKey LstStatusButton / NthVal Num Rtn)
		(if (and Key LstStatusButton LstButtonKey)
			(progn
				(setq NthVal (GetNth LstButtonKey Key))
				(cond
					((= (nth NthVal LstStatusButton) 0)
						(setq Rtn (LM:SubstNth 1 NthVal LstStatusButton))
					)
					((= (nth NthVal LstStatusButton) 1)
						(setq Rtn (LM:SubstNth -1 NthVal LstStatusButton))
					)
					((= (nth NthVal LstStatusButton) -1)
						(setq Rtn (LM:SubstNth 1 NthVal LstStatusButton))
					)
				)
				(setq Num 0)
				(repeat (length LstStatusButton)
					(if (/= Num NthVal) (setq Rtn (LM:SubstNth 0 Num Rtn)))
					(setq Num (1+ Num))
				)
				(MakeButtons LstButtonKey Rtn)
			)
		)
		Rtn
	)
	;
	(defun GetFileOut (/ Path File)
	
		(setq Path  (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile     "Dir"))))
		(setq File  (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "FileOut"))))
		
		(list Path File)
	)
	;
	(defun GetFileField (LstFile / Files itm)

		(if LstFile
			(progn
				(foreach itm (LM:str->lst (get_tile "BoxFiles") " ")
					(setq Files (cons (car (nth (atoi itm) LstFile)) Files))
				)
				(if Files 
					(set_tile "FileOut" (LM:lst->str Files "*"))
				)
			)
		)
		;(if LstFile
		;	(progn
		;		(setq File (car (nth (atoi (get_tile "BoxFiles")) LstFile)))
		;		(if File (set_tile "FileOut" File))
		;	)
		;)
		(GetFileOut)
	)
	;
	(defun GetLstFolder (Path / itm Rtn)

		(if Path
			(foreach itm (vl-directory-files Path nil -1)			
				(if (not (equal "." itm))
					(setq Rtn (append Rtn (list itm)))
				)
			)
		)
		Rtn
	)
	;
	(defun UpdateBoxFile (Path Ext LstSortFile LstTypeData / File LstFile SplitFile FileSize Size LstInfoSort LstBox Rtn)


		(foreach File (vl-directory-files Path Ext 1)
			(cond 
				((= Ext "*.*")
					(setq LstFile (append LstFile (list File)))
				)
				(T
					(if (= (strcat "." (strcase (nth 1 (splitxt Ext ".")))) (strcase (vl-filename-extension File)))
						(setq LstFile (append LstFile (list File)))
					)
				)
			)
		)
		(foreach File LstFile
			(setq FileSize    (GetFileSize (strcat Path "\\" File)))
			(cond 
				((= FileSize 0)							(setq Size 0))
					((and (> FileSize 0) (<= FileSize 1000))(setq Size 1))
				(T 										(setq Size (/ FileSize 1000)))
			)
			(setq LstInfoSort (append LstInfoSort (list (list	File																					; Str
																(LM:FormatDate (rtos (GetFileLastModified (strcat Path "\\" File)) 2 15) "DD.MO.YYYY")	; Date
																(GetFileType (strcat Path "\\" File))													; Str
																(strcat "Kb  " (rtoc Size 0))															; Int
														))))
															
		)
		
		(setq LstBox (ListToBox (SortList LstInfoSort LstSortFile LstTypeData)))
		(start_list "BoxFiles")
			(mapcar 'add_list LstBox)
			(end_list)
		(setq Rtn (BoxToList LstBox))
	)
	;
	(defun PurgePath (Path / SplitPath)
	
		(defun SplitPath (Path Char)
			(if (and Path Char)
				(LM:lst->str (SpliTxt Path Char) Char)
			)
		)
		(if Path
			(if (/= Path "")
				(SplitPath (LM:StringSubst "\\" "/" Path) "\\")
			)
		)
	)
	;
	(defun UpdateBoxFolder (Path LstSortFolder LstTypeData / DotFolder Folder Folder LstInfoSort 
															 LstBox TypFld Rtn)
	

		;(setq AssocTypeFolder '((16 . "<DIR>") 
		;						(17 . "<DIR>") 
		;						(18 . "<DIR>") 
		;						(19 . "<DIR>") 
		;						(20 . "<DIR>") 
		;						(22 . "<DIR>") 
		;						(48 . "<DIR>")
		;						(49 . "<DIR>") 
		;						(50 . "<DIR>") 
		;						(1046 . "<LNK>")))
		(setq DotFolder (list ".." " " "UpLevel"))

		(foreach Folder (GetLstFolder Path)
		
			(cond 
				((= Folder "..")
					(cond 
						((= (GetFolderAttributes (strcat Path "\\" Folder)) 1046)
							(setq TypFld "<LNK>")
						)
						(t
							(setq TypFld "<DIR>")
						)
					)
							
					(setq DotFolder (list Folder 
										  " "
										  TypFld))
				)
				(t
					(cond 
						((= (GetFolderAttributes (strcat Path "\\" Folder)) 1046)
							(setq TypFld "<LNK>")
						)
						(t
							(setq TypFld "<DIR>")
						)
					)

					(setq LstInfoSort (append LstInfoSort (list (list Folder																		 			 ; Str
																	  (LM:FormatDate (rtos (GetFolderLastModified (strcat Path "\\" Folder)) 2 15) "DD.MO.YYYY") ; Date
																	  TypFld				 ; Str
																))))
				)
			)
		)
		(if LstInfoSort
			(setq LstBox (ListToBox (cons DotFolder (SortList LstInfoSort LstSortFolder LstTypeData))))
			(setq LstBox (ListToBox (list DotFolder)))
		)
		(set_tile "Dir" Path)
		(start_list "BoxFolders")
			(mapcar 'add_list LstBox)
		(end_list)
		(setq Rtn (BoxToList LstBox))
	)
	;
	(defun UpdatePopUp (Filter / ItmExt LstPop LstExt)
	
		(foreach ItmExt (setq LstExt (Splitxt Filter "|"))
		
			(setq LstExt (append LstExt (list ItmExt)))
			(if (= ItmExt "*.*")
				(setq LstPop (append LstPop (list (strcat "All Files ("  ItmExt ")"))))
				(setq LstPop (append LstPop (list (strcat "Files (" ItmExt ")"))))
			)
		)
		
		(start_list "FilterFile")
			(mapcar 'add_list LstPop)
		(end_list)
		LstExt
	)
	;
	(defun PathYourSelf (LstFolders / PathS LstFl itm Rtn)
	
		(setq PathS  (strcat (get_tile "Dir") "\\" (car (nth (atoi (get_tile "BoxFolders")) LstFolders))))
		(setq LstFl (vl-directory-files Paths nil -1))
		
		(setq Rtn T)
		(if LstFl
			(progn 
				(setq LstFl (LM:RemoveOnce "." LstFl))
				(if (= (length LstFl) (length LstFolders))
					(foreach itm LstFolders
						(if (not (member (car itm) LstFl))
							(setq Rtn nil)
						)
					)
					(setq Rtn nil)
				)
			)
		)
		Rtn
	)
	;
	(defun ActionToFolder (LstFolders Ext LstSortFile LstSortFolder TypeDataFolder TypeDataFile / Folder PathS LstFile LstFolder)
		
		(if (not (PathYourSelf LstFolders))
			(progn
				;(setq Folder (nth (atoi (get_tile "BoxFolders")) LstFolders))
				(setq Folder (car (nth (atoi (get_tile "BoxFolders")) LstFolders)))
				
				(if (equal ".." Folder)
					(setq PathS	 (LM:getfiles:updir (get_tile "Dir")))
					(setq PathS  (strcat (get_tile "Dir") "\\" (car (nth (atoi (get_tile "BoxFolders")) LstFolders))))
				)
				(setq LstFolder (UpdateBoxFolder PathS LstSortFolder TypeDataFolder))
				(setq LstFile 	(UpdateBoxFile 	 PathS Ext LstSortFile TypeDataFile))
			)
			(progn
				(setq Folder (car (nth (atoi (get_tile "BoxFolders")) LstFolders)))
				(if (equal ".." Folder)
					(progn
						(setq PathS	 (LM:getfiles:updir (get_tile "Dir")))
						(setq LstFolder (UpdateBoxFolder PathS LstSortFolder TypeDataFolder))
						(setq LstFile 	(UpdateBoxFile 	 PathS Ext LstSortFile TypeDataFile))
					)
				)
			)
		)
		(if LstFolder
			(list LstFolder LstFile)
			nil
		)
	)
	;
	(defun LM:getfiles:updir ( dir / Folder)
		(setq Folder (substr dir 1 (vl-string-position 92 dir nil t)))
	)
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
	(defun SortList (LstTableNesting LstSort LstTypeData / DateToInt ByteToInt
														   TypeSort NthSort Num itm Rtn Var1 Var2)
	
		(defun DateToInt (Date / LstDate Rtn)
			(if Date
				(progn
					(setq LstDate (SpliTxt Date "."))
					(setq Rtn (atoi (strcat (caddr LstDate) (cadr LstDate) (car LstDate))))
				)
			)
			Rtn
		)
		;
		(defun ByteToInt (Byte / ValByte Rtn)
			(if Byte
				(progn
					(setq ValByte (cadr (SpliTxt Byte " ")))
					(setq Rtn     (atoi (LM:StringSubst "" "," ValByte)))
				)
			)
			Rtn
		)
		;
		; Main
		;
		(if (and LstTableNesting LstSort LstTypeData)
			(progn
				(setq Num 0)
				(foreach itm LstSort
					(cond
						((= itm -1) (setq TypeSort itm  NthSort Num))
						((= itm  1) (setq TypeSort itm  NthSort Num))
					)
					(setq Num (1+ Num))
				)
			
				(setq Rtn
					(vl-sort LstTableNesting 
					(function 
							(lambda (e1 e2)
								(cond
									((= (nth NthSort LstTypeData) "String")
										(setq Var1 (strcase (nth NthSort e1) t))
										(setq Var2 (strcase (nth NthSort e2) t))
									)
									((= (nth NthSort LstTypeData) "Date")
										(setq Var1 (DateToInt (nth NthSort e1)))
										(setq Var2 (DateToInt (nth NthSort e2)))
									)
									((= (nth NthSort LstTypeData) "Byte")
										(setq Var1 (ByteToInt (nth NthSort e1)))
										(setq Var2 (ByteToInt (nth NthSort e2)))
									)
									(T
										(setq Var1 (nth NthSort e1))
										(setq Var2 (nth NthSort e2))
									)
								)
								(cond
									((= TypeSort -1)
										(< Var1 Var2)
									)
									((= TypeSort  1)
										(> Var1 Var2)
									)
								)
							)
						)
					)
				)
			)
		)
		Rtn
	)
	;
	(defun SortBox (LstTableNesting LstSort Key LstTypeData / LstBox)
	
		(if (and LstTableNesting LstSort Key LstTypeData)
			(progn
				(if (= (car (car LstTableNesting)) "..")
					(setq LstBox (ListToBox (cons (car LstTableNesting) (SortList (cdr LstTableNesting) LstSort LstTypeData))))
					(setq LstBox (ListToBox (SortList LstTableNesting LstSort LstTypeData)))
				)
			
				(start_list Key)
					(mapcar 'add_list LstBox)
				(end_list)
			)
		)
		(BoxToList LstBox)
	)
	;
	(defun BoxToList (LstBox / itm Rtn)
		(foreach itm LstBox
			(setq Rtn (append Rtn (list (LM:str->lst itm "\t"))))
		)
	)
	;
	(defun ListToBox (LstBox / itm Rtn)
		(foreach itm LstBox
			(setq Rtn (append Rtn (list (LM:lst->str itm "\t"))))
		)
		Rtn
	)
	;
	(defun MakeDclFile (LstParameter / Title MultiSelect x des dcl)
	
		; Lst Parameter
		;
		;	0 InitialDirectory
		;   1 FileName
		;   2 Filter
		;   3 Title
		;   4 MultiSelect
		;	5 ForceSelect
		;
		(if (not (setq Title       (nth 3 LstParameter))) (setq Title "FileDialog"))
		(if (not (setq MultiSelect (nth 4 LstParameter))) (setq MultiSelect "false") (setq MultiSelect "true"))
			
		(if (and (setq dcl (vl-filename-mktemp nil nil ".dcl"))
				 (setq des (open dcl "w"))
			 )
			 (progn
				
				(foreach x
					 (list
						"handle_folder_list:dialog"
						"{"
						(strcat "label=\"" Title "\";")
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
						"			label=\"Lista Directory\";"
						"			:row {"
						"				:text_part {width=35; fixed_width=true; label=\"Name\"; }"
						"				:text_part {width=12; fixed_width=true; label=\"Mod.\"; }"
						"				:text_part {width=10; fixed_width=true; label=\"Tipo\";	}"
						"			}"
						"			:row {"
						"				:image_button {key=\"BtFolder1\";  height=1.2; width=35.0;  vertical_margin=none; horizontal_margin=none;}"
						"				:image_button {key=\"BtFolder2\";  height=1.2; width=12.0;  vertical_margin=none; horizontal_margin=none;}"
						"				:image_button {key=\"BtFolder3\";  height=1.2; width=10.0;  vertical_margin=none; horizontal_margin=none;}"
						"			}"
						"			:list_box {"
						"				key=\"BoxFolders\";"
						"				width=57;"
						"				height=35;"
						"				fixed_width=true;"
						"				vertical_margin=none;"
						"				horizontal_margin=none;"
						"				tabs = \"35 47\";"
						"			}"
						"		}"
						"		:boxed_column {"
						"			label=\"Lista File\";"
						"			:row {"
						"				:text_part {width=58; fixed_width=true; label=\"Name\"; }"
						"				:text_part {width=12; fixed_width=true; label=\"Mod.\";	}"
						"				:text_part {width=30; fixed_width=true; label=\"Tipo\";	}"
						"				:text_part {width=15; fixed_width=true; label=\"Dim.\";	}"
						"			}"
						"			:row {"
						"				:image_button {key=\"BtFile1\";  height=1.2; width=58.0;  vertical_margin=none; horizontal_margin=none;}"
						"				:image_button {key=\"BtFile2\";  height=1.2; width=12.0;  vertical_margin=none; horizontal_margin=none;}"
						"				:image_button {key=\"BtFile3\";  height=1.2; width=30.0;  vertical_margin=none; horizontal_margin=none;}"
						"				:image_button {key=\"BtFile4\";  height=1.2; width=15.0;  vertical_margin=none; horizontal_margin=none;}"
						"			}"
						"			:list_box {"
						"				key=\"BoxFiles\";"
						"				width=115;"
						"				height=35;"
						"				fixed_width=true;"
						"				vertical_margin=none;"
						"				horizontal_margin=none;"
						"				tabs = \"58 70 100\";"
						(strcat 	   "multiple_select = " MultiSelect ";")
						"			}"
						"		}"
						"	}"
						"	:row {"
						"		:edit_box {"
						"			label=\"Nome File\";"
						"			key=\"FileOut\";"
						"		}"
						"		:popup_list {key = \"FilterFile\"; value = \"0\"; width=20; fixed_width=true;}"
						"	}"
						"	ok_cancel;"
						"}"
                    )
                    (write-line x des)
                )
                (setq des (close des))	
			)
		)
		dcl
	)
	;
	; Main ++++++++
	;
	(if (or (not (nth 0 LstParameter)) (= (nth 0 LstParameter) ""))
		(setq PathS (getenv "USERPROFILE"))
		(setq PathS (nth 0 LstParameter))
	)
	(if (not (setq FileS       (nth 1 LstParameter))) (setq FileS ""))
	(if (not (setq Filter      (nth 2 LstParameter))) (setq Filter "*.*"))
	(if (not (setq Title       (nth 3 LstParameter))) (setq Title "FileDialog"))
	(if (not (setq MultiSelect (nth 4 LstParameter))) (setq MultiSelect nil) (setq MultiSelect T))
	(if (not (setq ForceSelect (nth 5 LstParameter))) (setq ForceSelect nil) (setq ForceSelect T))
	
	(setq PathS (PurgePath PathS))
	(setq LstButtonFolderKey '("BtFolder1" "BtFolder2" "BtFolder3"))
	(setq LstButtonFileKey   '("BtFile1"   "BtFile2"   "BtFile3"   "BtFile4"))
	(setq TypeDataFolder     '("String"    "Date"      "String"))
	(setq TypeDataFile       '("String"    "Date"      "String"    "Byte"))

	(if (not LstSortFolder$)
		(setq LstSortFolder$ '(1 0 0))
	)
	(if (not LstSortFile$)
		(setq LstSortFile$ 	 '(1 0 0 0))
	)
	(if (not BtFile$)
		(setq BtFile$ "BtFile1")
	)
	(if (not BtFolder$)
		(setq BtFolder$ "BtFolder1")
	)
	(setq FileDcl (MakeDclFile LstParameter))
	(if (not FileDcl) (exit))
	
    (setq xx (load_dialog FileDcl))
    (new_dialog "handle_folder_list" xx "" (cond ( *handle_folder_list* ) ( '(-1 -1) )))
			
	(set_tile "Dir" PathS)
	(set_tile "FileOut" FileS)
	
	(setq LstExt    (UpdatePopUp Filter))
	(setq LstFolder (UpdateBoxFolder PathS LstSortFolder$ TypeDataFolder))
	(setq LstFile 	(UpdateBoxFile 	 PathS (car LstExt) LstSortFile$ TypeDataFile))
	(MakeButtons LstButtonFileKey    LstSortFile$)
	(MakeButtons LstButtonFolderKey  LstSortFolder$)

	(action_tile "BtFolder1" (vl-prin1-to-string '(setq LstSortFolder$ (UpDateButtons "BtFolder1" LstButtonFolderKey LstSortFolder$)
														BtFolder$ "BtFolder1"
														LstFolder (SortBox LstFolder LstSortFolder$ "BoxFolders" TypeDataFolder))))
	(action_tile "BtFolder2" (vl-prin1-to-string '(setq LstSortFolder$ (UpDateButtons "BtFolder2" LstButtonFolderKey LstSortFolder$)
														BtFolder$ "BtFolder2"
														LstFolder (SortBox LstFolder LstSortFolder$ "BoxFolders" TypeDataFolder))))
	(action_tile "BtFolder3" (vl-prin1-to-string '(setq LstSortFolder$ (UpDateButtons "BtFolder3" LstButtonFolderKey LstSortFolder$)
														BtFolder$ "BtFolder3"
														LstFolder (SortBox LstFolder LstSortFolder$ "BoxFolders" TypeDataFolder))))
														
	(action_tile "BtFile1" 	(vl-prin1-to-string  '(setq LstSortFile$ (UpDateButtons "BtFile1" LstButtonFileKey LstSortFile$)
														BtFile$ "BtFile1"
														LstFile (SortBox LstFile LstSortFile$ "BoxFiles" TypeDataFile))))
	(action_tile "BtFile2" 	(vl-prin1-to-string  '(setq LstSortFile$ (UpDateButtons "BtFile2" LstButtonFileKey LstSortFile$)
														BtFile$ "BtFile2"
														LstFile (SortBox LstFile LstSortFile$ "BoxFiles" TypeDataFile))))
	(action_tile "BtFile3" 	(vl-prin1-to-string  '(setq LstSortFile$ (UpDateButtons "BtFile3" LstButtonFileKey LstSortFile$)
														BtFile$ "BtFile3"
														LstFile (SortBox LstFile LstSortFile$ "BoxFiles" TypeDataFile))))
	(action_tile "BtFile4" 	(vl-prin1-to-string  '(setq LstSortFile$ (UpDateButtons "BtFile4" LstButtonFileKey LstSortFile$)
														BtFile$ "BtFile4"
														LstFile (SortBox LstFile LstSortFile$ "BoxFiles" TypeDataFile))))
	
	(action_tile "Dir" 
		(vl-prin1-to-string	
			'(if (setq Tmp (PurgePath (get_tile "Dir")))
				(if (vl-file-directory-p Tmp)
					(if (vl-directory-files Tmp "*.*" 1)
						(setq PathS Tmp
							  LstFolder (UpdateBoxFolder PathS LstSortFolder$ TypeDataFolder)
							  LstFile   (UpdateBoxFile   PathS (nth (atoi (get_tile "FilterFile")) LstExt) LstSortFile$ TypeDataFile)
						)
					)
					(progn
						(alert (strcat "Folder " Tmp "  ???"))
						(set_tile "Dir" PathS)
					)
				)
				(progn
					(alert "Folder ???")
					(set_tile "Dir" PathS)
				)
			)
		)
	)
	(action_tile "BoxFolders" 
		(vl-prin1-to-string	
			'(if (= 4 $reason) 
				(if (setq Tmp (ActionToFolder LstFolder (nth (atoi (get_tile "FilterFile")) LstExt) LstSortFile$ LstSortFolder$ TypeDataFolder TypeDataFile))
					(setq LstFolder (car  Tmp)
						  LstFile 	(cadr Tmp)
					)
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
					  LstFolder (UpdateBoxFolder 	PathS LstSortFolder$ TypeDataFolder)
					  LstFile 	(UpdateBoxFile 		PathS (nth (atoi (get_tile "FilterFile")) LstExt) LstSortFile$ TypeDataFile)
				)
             )
		)
    )
	(action_tile "FilterFile" 
		(vl-prin1-to-string
			'(setq LstFile (UpdateBoxFile (get_tile "Dir") (nth (atoi (get_tile "FilterFile")) LstExt) LstSortFile$ TypeDataFile))
		
		)
	)
	(action_tile "cancel" (strcat 	"(setq Rtn nil)
									 (setq *handle_folder_list* (done_dialog)) (unload_dialog xx)"))
									
	(action_tile "accept" 
		(vl-prin1-to-string '(if ForceSelect
								(if (= (vl-string-right-trim " \t" (vl-string-left-trim " \t" (get_tile "FileOut"))) "")
									(LM:popup "Errore" "Devi selezionare un file" (+ 0 16 4096))
									(progn
										(setq Rtn (GetFileOut))
										(setq *handle_folder_list* (done_dialog))
										(unload_dialog xx)
									)
								)
								(progn
									(setq Rtn (GetFileOut))
									(setq *handle_folder_list* (done_dialog))
									(unload_dialog xx)
								)
		))
	)
	(start_dialog)
	(vl-file-delete FileDcl)
	Rtn
)
;
; File +++++++++++++++++++++++++++++++++++
;
(defun GetFileCreated ( file / fs fObj Rtn)
  
	(setq fs (vlax-create-object "Scripting.FileSystemObject"))
	(if (/= (vlax-invoke fs 'FileExists file) 0)
		(progn
			(setq fObj (vlax-invoke-method fs 'GetFile file))
            (setq Rtn  (+ 2415019 (vlax-get fObj 'DateCreated)))
			(vlax-release-object fObj)
		)
	)
	(vlax-release-object fs)
	Rtn
)
;
;
;
(defun GetFileLastModified ( file / fs fObj Rtn)

	(setq fs (vlax-create-object "Scripting.FileSystemObject"))
	(if (/= (vlax-invoke fs 'FileExists file) 0)
		(progn
			(setq fObj (vlax-invoke-method fs 'GetFile file))
            (setq Rtn  (+ 2415019 (vlax-get fObj 'DateLastModified)))
			(vlax-release-object fObj)
		)
	)
	(vlax-release-object fs)
	Rtn
)
;
;
;
(defun GetFileSize ( file / fs fObj Rtn)

	(setq fs (vlax-create-object "Scripting.FileSystemObject"))
	(if (/= (vlax-invoke fs 'FileExists file) 0)
		(progn
			(setq fObj (vlax-invoke-method fs 'GetFile file))
            (setq Rtn  (vlax-get fObj 'Size))
			(vlax-release-object fObj)
		)
	)
	(vlax-release-object fs)
	Rtn
)
;
;
;
(defun GetFileType ( file / fs fObj Rtn)
  
	(setq fs (vlax-create-object "Scripting.FileSystemObject"))
	(if (/= (vlax-invoke fs 'FileExists file) 0)
		(progn
			(setq fObj (vlax-invoke-method fs 'GetFile file))
            (setq Rtn  (vlax-get fObj 'Type))
			(vlax-release-object fObj)
		)
	)
	(vlax-release-object fs)
	Rtn
)
;
; Folders +++++++++++++++++++++++++++++++++++
;
(defun GetFolderCreated (path / fs folder Rtn)
  (setq fs (vlax-get-or-create-object "Scripting.FileSystemObject"))
  (if (/= (vlax-invoke fs 'FolderExists path) 0)
    (progn
      (setq folder (vlax-invoke fs 'GetFolder path))
      (setq Rtn (+ 2415019  (vlax-get folder 'DateCreated))) ;Gets a Julian date number
      (vlax-release-object folder)
    )
  )
  (vlax-release-object fs)
  Rtn
)
;
;
;
(defun GetFolderLastModified (path / fs folder Rtn)
  (setq fs (vlax-get-or-create-object "Scripting.FileSystemObject"))
  (if (/= (vlax-invoke fs 'FolderExists path) 0)
    (progn
      (setq folder (vlax-invoke fs 'GetFolder path))
     (setq Rtn (+ 2415019  (vlax-get folder 'DateLastModified))) ;Gets a Julian date number
      (vlax-release-object folder)
    )
  )
  (vlax-release-object fs)
  Rtn
)
;
;
;
(defun GetFolderSize (path / fs folder Rtn)
  (setq fs (vlax-get-or-create-object "Scripting.FileSystemObject"))
  (if (/= (vlax-invoke fs 'FolderExists path) 0)
    (progn
      (setq folder (vlax-invoke fs 'GetFolder path))
      (setq Rtn (vlax-get folder 'Size)) ;Gets size
      (vlax-release-object folder)
    )
  )
  (vlax-release-object fs)
  Rtn
)
;
;
;
(defun GetFolderType (path / fs folder Rtn)
  (setq fs (vlax-get-or-create-object "Scripting.FileSystemObject"))
  (if (/= (vlax-invoke fs 'FolderExists path) 0)
    (progn
      (setq folder (vlax-invoke fs 'GetFolder path))
      (setq Rtn (vlax-get folder 'Type)) ;Gets Type
      (vlax-release-object folder)
    )
  )
  (vlax-release-object fs)
  Rtn
)
;
;
;
(defun GetFolderAttributes (path / fs folder Rtn)
  (setq fs (vlax-get-or-create-object "Scripting.FileSystemObject"))
  (if (/= (vlax-invoke fs 'FolderExists path) 0)
    (progn
      (setq folder (vlax-invoke fs 'GetFolder path))
      (setq Rtn (vlax-get folder 'Attributes)) ;Gets Attributes
      (vlax-release-object folder)
    )
  )
  (vlax-release-object fs)
  Rtn
)
;
;
;
(defun LM:FormatDate ( date format )
  (menucmd (strcat "m=$(edtime," date "," format ")"))
  ;(LM:FormatDate (rtos x 2 15) "DD.MO.YYYY HH:MM:SS"))
)
;
;
;