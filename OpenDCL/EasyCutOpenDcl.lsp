;
; OPENDCL
;
(defun LoadRuntimeOpenDcl (/ AcadPlatform 
						     Platform Path FileOpenDcl FN)

	(defun AcadPlatform (/ str)
		(if (and (setq proc_arch (getenv "PROCESSOR_ARCHITECTURE"))
				 (< 1 (strlen proc_arch))
				 (eq "64" (substr proc_arch (1- (strlen proc_arch))))
			)
			(setq str "x64")
			(setq str "x32")
		)
		str
	)
	;
	;
	(setq Path (vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
	(if (= (strcase (setq Platform (AcadPlatform))) "X32")
		(setq FileOpenDcl 	(strcat "OpenDCL."
								(substr (getvar "acadver") 1 2)
								".ARX"
							)
		)
		(setq FileOpenDcl 	(strcat "OpenDCL."
								Platform "."
								(substr (getvar "acadver") 1 2)
								".ARX"
							)
		)
	)
	;
	(if (setq FN (findfile 	(strcat Path "\\OpenDCL\\OpenDclLsp\\OpenDclBin\\" FileOpenDcl)))
		(arxload FN (strcat "\nError loading " FN))
	)
)
;
;
(defun UnLoadRuntimeOpenDcl (/ AcadPlatform 
						     Platform Path FileOpenDcl FN)

	(defun AcadPlatform (/ str)
		(if (and (setq proc_arch (getenv "PROCESSOR_ARCHITECTURE"))
				 (< 1 (strlen proc_arch))
				 (eq "64" (substr proc_arch (1- (strlen proc_arch))))
			)
			(setq str "x64")
			(setq str "x32")
		)
		str
	)
	;
	;
	(setq Path (vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
	(if (= (strcase (setq Platform (AcadPlatform))) "X32")
		(setq FileOpenDcl 	(strcat "OpenDCL."
								(substr (getvar "acadver") 1 2)
								".ARX"
							)
		)
		(setq FileOpenDcl 	(strcat "OpenDCL."
								Platform "."
								(substr (getvar "acadver") 1 2)
								".ARX"
							)
		)
	)
	;
	(if (setq FN (findfile 	(strcat Path "\\OpenDCL\\OpenDclLsp\\OpenDclBin\\" FileOpenDcl)))
		(arxunload FN (strcat "\nError loading " FN))
	)
)
;
;
(defun IfOpenDcl ()
	(boundp 'dcl-Project-Load)
)
;
;(ViewerOpenDcl "C:\\EasyCutNesting Beta\\Tmp\\SetupEasyCut01.ps1")
(defun ViewerOpenDcl (FileName / cmdecho Path)

	;; Ensure OpenDCL Runtime is (quietly) loaded
	(setq cmdecho (getvar "CMDECHO"))
	(setvar "CMDECHO" 0)
	(command "_OPENDCL")
	(setvar "CMDECHO" cmdecho)
	(setq FileNameViewerOpenDcl$ FileName) 

	(setq Path (vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
	(dcl-Project-Load (strcat Path "\\OpenDCL\\OpenDCLLsp\\ODcl\\ViewerModless.odcl") T)
	(dcl-Form-Show ViewerModless/Form1)
)
;
;
(defun c:ViewerModless/Form1#OnInitialize (/ LeggiFileTesto Contenuto)

	 
	(defun LeggiFileTesto (NomeFile / f riga testo)
		(if (setq f (open NomeFile "r"))
			(progn
				(setq testo "")
				(while (setq riga (read-line f))
					(setq testo (strcat testo riga "\r\n"))
				)
				(close f)
				testo
			)
			nil
		)
	)

	(setq Contenuto (LeggiFileTesto FileNameViewerOpenDcl$))
	(if Contenuto
		(dcl-Control-SetText ViewerModless/Form1/TextBox1 Contenuto)
	)
)
;
;
(defun c:ViewerModless/Form1/TextButton1#OnClicked (/)
  (dcl-Form-Close ViewerModless/Form1/TextButton1)
)
;
;
(defun Dialog01ModifiedLstShapeOpenDcl (LstTableFiltered LstNth LstButtonKey LstTypeValue LstDimButton LstModeData)
																										  
	;(setq cmdecho (getvar "CMDECHO"))
	;(setvar "CMDECHO" 0)
	;(command "_OPENDCL")
	;(setvar "CMDECHO" cmdecho)
	
	; Global variable
	(setq $TmpLstTableFiltered	LstTableFiltered)
	(setq $TmpLstNth			LstNth)
	(setq $TmpLstButtonKey		LstButtonKey) 
	(setq $TmpLstTypeValue		LstTypeValue)
	(setq $TmpLstDimButton		LstDimButton)
	(setq $TmpLstModeData		LstModeData)
	;(if (not (ExistFunction "dcl-Project-Load")) (LoadRuntimeOpenDcl))
	
	

	(setq Path (vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
	(dcl-Project-Load (strcat Path "\\OpenDCL\\OpenDCLLsp\\ODcl\\GridDxfChangeInfo.odcl") T)
	(dcl-Form-Show GridDxfChangeInfo/Form1)
	(princ)
)
;
;
(defun c:TestGrid/Form1#OnInitialize (/ itm LstData)

	(setq EnameForm$ (eval (read "GridDxfChangeInfo/Form1")))
	(setq EnameGrid$ (eval (read "GridDxfChangeInfo/Form1/Grid1")))
	
	(dcl-Control-SetWidth  EnameForm$ 1246)
	(dcl-Control-SetHeight EnameForm$ 600)
	
	(dcl-Control-SetHeight EnameGrid$ 520)
	(dcl-Control-SetWidth  EnameGrid$ 1175)

	
	(dcl-Grid-AddColumns EnameGrid$ 
			(list 
				(list "Itm"              	   0 40 )     ; 0 Sinistra 1 Centro 2 Destra 
				(list (nth 0 $TmpLstButtonKey) 0 100)     ; Id -20
				(list (nth 1 $TmpLstButtonKey) 0 300)    
				(list (nth 2 $TmpLstButtonKey) 0 150)    
				(list (nth 3 $TmpLstButtonKey) 0 150)     
 				(list (nth 4 $TmpLstButtonKey) 0 170)    
				(list (nth 5 $TmpLstButtonKey) 0 60 )     
				(list (nth 6 $TmpLstButtonKey) 0 60 )     
				(list (nth 7 $TmpLstButtonKey) 0 60 )     
				(list (nth 8 $TmpLstButtonKey) 0 80 )
			)
	)
	
	(setq $TmpLstTableFiltered (AddIndex $TmpLstTableFiltered))
	;												 ("NoEdit" "NoEdit"  "str"  "str"  "str"  "str"  "int"  "real"  "str"  "str") 
	(dcl-Control-SetColumnStyleList EnameGrid$	(list    0 	      0 	   6      6      6      6	   8      9      6      0 ))
 	(foreach itm $TmpLstNth
		(setq LstData (append LstData (list (nth (atoi itm) $TmpLstTableFiltered))))
	)
	(dcl-Grid-FillList 				EnameGrid$	LstData)
	
	;	Style Description 
	;		-1 Undefined 
	;		0 No style set 
	;		1 Check box 
	;		2 Option button 
	;		3 Toggle Icon (see SetCellImages) 
	;		4 Ellipsis button 
	;		5 Pick button 
	;		6 Text 
	;		7 Angle 
	;		8 Integer 
	;		9 Unit (affected by DIMZIN system variable) 
	;		10 Upper case text 
	;		11 Lower case text 
	;		12 Password 
	;		13 Multiline text 
	;		14 Currency 
	;		15 Date 
	;		16 Time 
	;		17 Percentage 
	;		18 Dropdown list 
	;		19 Arrows 
	;		20 AutoCAD colors 
	;		21 Text styles 
	;		22 Plot styles 
	;		23 Plot style tables 
	;		24 Plotters 
	;		25 Fonts 
	;		26 Drives 
	;		27 Layers 
	;		28 Dimension styles 
	;		29 Image/text dropdown list 
	;		30 AutoCAD color 
	;		31 Truecolor 
	;		32 Lineweight 
	;		33 Linetype 
	;		34 Folders 
	;		35 Files (see SetCellDropList) 
	;		36 Dropdown combo list 
	;		37 Dropdown angles combo list 
	;		38 Dropdown integers combo list 
	;		39 Dropdown units combo list (affected by DIMZIN system variable) 
	;		40 Dropdown upper case text combo list 
	;		41 Dropdown lower case text combo list 
	;		42 AutoCAD symbol name 
	;		43 Dropdown AutoCAD symbol name combo list 
	;(dcl-Grid-AddRow TestGrid/Form1/Grid1 "1" "Vite Brugola" "0.50" "0.50" "0.50" "0.50" "0.50" "0.50")
	;(dcl-Grid-AddRow TestGrid/Form1/Grid1 "2" "Vite Brugola" "0.50" "0.50" "0.50" "0.50" "0.50" "0.50")
	;(dcl-Grid-AddRow TestGrid/Form1/Grid1 "3" "Vite Brugola" "0.50" "0.50" "0.50" "0.50" "0.50" "0.50")
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 0 1 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 0 2 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 0 3 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 0 4 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 0 5 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 0 6 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 0 7 6)

	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 1 1 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 1 2 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 1 3 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 1 4 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 1 5 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 1 6 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 1 7 6)

	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 2 1 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 2 2 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 2 3 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 2 4 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 2 5 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 2 6 6)
	;(dcl-Grid-SetCellStyle TestGrid/Form1/Grid1 2 7 6)
)
;
;
(defun c:TestGrid/Form1#OnCancelClose (Reason /)
  ;; Reason 0 = Tasto Invio premuto
  ;; Reason 1 = Tasto ESC o tasto Chiudi (X)
	(cond
		((= Reason 0)
			(dcl_Control_SetFocus EnameGrid$)
			T   ; Ritorna T per BLOCCARE la chiusura e restare nel dialogo
		)	
		((= Reason 1)
			(setq $TmpLstTableFiltered (RemoveIndex $TmpLstTableFiltered))
			(dcl-Form-Close GridDxfChangeInfo/Form1/ExitForm)
			;T
		)
		(t
			NIL ; Ritorna NIL per permettere la chiusura (per ESC o pulsante X)
		)
	)
)
;
;
(defun c:TestGrid/Form1/ExitForm#OnClicked (/ Pos itm)

	;
	; Reassembly list++++++++++++
	;
	(setq $TmpLstTableFiltered (RemoveIndex $TmpLstTableFiltered))
	(dcl-Form-Close GridDxfChangeInfo/Form1/ExitForm)
)
;
;
(defun c:TestGrid/Form1/TextButton1#OnClicked (/ itm LstTmp Row Column)


	(setq $TmpLstTableFiltered (RemoveIndex $TmpLstTableFiltered))

	(setq Row 0)
	(repeat (dcl-Grid-GetRowCount EnameGrid$)
		(setq Column 0)
		(setq LstTmp nil)
		(repeat (dcl-Grid-GetColumnCount EnameGrid$)
			(if (= Column 0)
					(setq itm (atoi (dcl-Grid-GetCellText EnameGrid$ Row Column)))
					(setq LstTmp (append LstTmp (list (dcl-Grid-GetCellText EnameGrid$ Row Column))))
			)
			(setq Column (1+ Column))
		)
		(setq $TmpLstTableFiltered (LM:SubstNth LstTmp (1- itm) $TmpLstTableFiltered)) 
		(setq Row (1+ Row))
	)
	;(princ $TmpLstTableFiltered)
	(dcl-Form-Close GridDxfChangeInfo/Form1/ExitForm)
)
;
;
(defun RemoveIndex (Lst / Pos itm)

	(setq Pos 0)
	(foreach itm Lst
		(setq Lst (LM:SubstNth (cdr itm) Pos Lst))
		(setq Pos (1+ Pos))
	)
	Lst
)
;
;
(defun AddIndex (Lst / Pos itm)
	(setq Pos 1)
	(foreach itm Lst
		(setq Lst (LM:SubstNth (append (list (itoa Pos)) itm) (1- Pos) Lst))
		(setq Pos (1+ Pos))
	)
	Lst
)
;
;
; Perview DWG
;
;
(defun ShowDwgOpenDcl (LstFileDwg)
																										  
	; Global variable
	;			  0    1       2       3       4    5      6        7       8
 	;(list (list Id FileDwg FileDxf Commessa Fase Nome Quantita Spessore Materiale))
	
	(setq $TmpLstFileDwg	LstFileDwg)
	(setq Path (vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
	(dcl-Project-Load (strcat Path "\\OpenDCL\\OpenDCLLsp\\ODcl\\PreviewDwg.odcl") T)
	(dcl-Form-Show PreviewDwg/Form1)
	(princ)
)
;
;
(defun c:PreviewDwg/Form1#OnInitialize (/ Col0Width Col1Width itm ListBox)
	
	;			  0    1       2       3       4    5      6        7       8
 	;(list (list Id FileDwg FileDxf Commessa Fase Nome Quantita Spessore Materiale))

	(setq EnameForm$ 			(eval (read "PreviewDwg/Form1")))
	(setq EnameBlockView$ 		(eval (read "PreviewDwg/Form1/BlockView1")))
	(setq EnameListBox$ 		(eval (read "PreviewDwg/Form1/ListBox1")))
	(setq EnameTBox1$			(eval (read "PreviewDwg/Form1/TextBox1")))
	(setq EnameTBox2$			(eval (read "PreviewDwg/Form1/TextBox2")))
	(setq EnameTBox3$			(eval (read "PreviewDwg/Form1/TextBox3")))
	(setq EnameTBox4$			(eval (read "PreviewDwg/Form1/TextBox4")))
	(setq EnameTBox5$			(eval (read "PreviewDwg/Form1/TextBox5")))
	(setq EnameTBox6$			(eval (read "PreviewDwg/Form1/TextBox6")))

	(setq PosDwg$ 0)
	(setq Record (nth PosDwg$ $TmpLstFileDwg))
	(PreviewDwg_Fill_BlockView 	Record)
	(PreviewDwg_Fill_TextBox	Record)
	;
	; Make List Box
	;
	(foreach itm $TmpLstFileDwg
		(dcl-ListBox-AddString EnameListBox$ (strcat (nth 0 itm) "\t" 
													  (vl-filename-base (nth 2 itm))))
	)
	(dcl-ListBox-SetCurSel EnameListBox$	PosDwg$)
	(dcl-Control-SetFocus EnameListBox$)
	
)
;
;
(defun PreviewDwg_Fill_TextBox (Record)

	(dcl-Control-SetText EnameTBox1$ (nth 3 Record))
	(dcl-Control-SetText EnameTBox2$ (nth 4 Record))
	(dcl-Control-SetText EnameTBox3$ (nth 5 Record))
	(dcl-Control-SetText EnameTBox4$ (nth 6 Record))
	(dcl-Control-SetText EnameTBox5$ (nth 7 Record))
	(dcl-Control-SetText EnameTBox6$ (nth 8 Record))

)
;
;
(defun PreviewDwg_Fill_BlockView (Record)

	(dcl-BlockView-LoadDwg EnameBlockView$ (cadr Record))
	(dcl-Control-SetFocus  EnameBlockView$)
)
;
;
(defun c:PreviewDwg/Form1/ExitForm#OnClicked (/)
	(dcl-Form-Close PreviewDwg/Form1/ExitForm)
)
;
;
(defun c:PreviewDwg/Form1/ReloadDwg#OnClicked (/)
	
	(dcl-BlockView-LoadDwg EnameBlockView$ (cadr (nth PosDwg$ $TmpLstFileDwg)))
	(dcl-Control-SetFocus  EnameBlockView$)
  
)
;
;
(defun c:PreviewDwg/Form1/rew#OnClicked (/ Record)

	(cond
		((= PosDwg$ 0)
			(setq PosDwg$ PosDwg$)
		)
		(t
			(setq PosDwg$ (1- PosDwg$))
		)
	)
	(setq Record (nth PosDwg$ $TmpLstFileDwg))
	(PreviewDwg_Fill_BlockView 	Record)
	(PreviewDwg_Fill_TextBox 	Record)
	(dcl-ListBox-SetCurSel EnameListBox$ PosDwg$)
)
;
;
(defun c:PreviewDwg/Form1/fwd#OnClicked (/ Record)
	(cond
		((= PosDwg$ (1- (length $TmpLstFileDwg)))
			(setq PosDwg$ PosDwg$)
		)
		(t
			(setq PosDwg$ (1+ PosDwg$))
		)
	)
	(setq Record (nth PosDwg$ $TmpLstFileDwg))
	(PreviewDwg_Fill_BlockView 	Record)
	(PreviewDwg_Fill_TextBox 	Record)
	(dcl-ListBox-SetCurSel EnameListBox$ PosDwg$)

)
;
;
(defun c:PreviewDwg/Form1/ListBox1#OnSelChanged (ItemIndexOrCount Value /)
	(setq PosDwg$ ItemIndexOrCount)
	(setq Record (nth PosDwg$ $TmpLstFileDwg))
	(PreviewDwg_Fill_BlockView 	Record)
	(PreviewDwg_Fill_TextBox 	Record)
	(dcl-Control-SetFocus EnameListBox$)
)
;
;
; Menu Modeless
;
;
(defun MenuOpenDcl (/ *error*)
			
	(defun *error* (msg)
		(while (< 0 (getvar "cmdactive")) (command))
		;; do error stuff
		(if (dcl-Form-IsActive Menu/Form1)
			(dcl-Form-Close Menu/Form1)
		)
		(princ (strcat "\nApplication Error: " (itoa (getvar "errno")) " :- " msg))
		(princ)
	)
	;
	;
	(setq Path (vl-registry-read EasyCutRegistryPath$ "PathInstaller"))
	(dcl-Project-Load (strcat Path "\\OpenDCL\\OpenDCLLsp\\ODcl\\Menu.odcl") T)
	(dcl-Form-Show Menu/Form1)
	
	;(princ)
)
;
;
(defun OpenDclSaveCfgMenu ()
	(vl-registry-write EasyCutRegistryPath$ "MenuCfg" 
			(LM:lst->str (list  PrgApp$ 
								PrgImport$ 
								PrgSql$ 
								PrgSearch$ 
								PrgTrigger$ 
								PrgSetup$ 
								PrgSAndS$ 
								PrgTools$ 
								PrgReport$ 
								PrgNestingExpert$ 
								PrgNestingSimple$ 
								PrgNestingTools$ 
								PrgNestingBar$) "-")
	)
)
;
;
(defun OpenDclSetCfgMenu ()
	(setq PrgApp$ 				"0"
		  PrgImport$ 			"0"
		  PrgSql$ 				"0"
		  PrgSearch$ 			"0"
		  PrgTrigger$			"0"
		  PrgSetup$				"0"
		  PrgSAndS$				"0"
		  PrgTools$				"0"
		  PrgReport$			"0"
		  PrgNestingExpert$ 	"0"
		  PrgNestingSimple$		"0"
		  PrgNestingTools$		"0"
		  PrgNestingBar$		"0"
	)
)
;
;
(defun OpenDclRestoreCfgMenu (/ Cfg LstMenu)
	(setq LstMenu (LM:str->lst (vl-registry-read EasyCutRegistryPath$ "MenuCfg") "-"))
	(setq PrgApp$ 				(nth 0  LstMenu)
		  PrgImport$ 			(nth 1  LstMenu)
		  PrgSql$ 				(nth 2  LstMenu)
		  PrgSearch$ 			(nth 3  LstMenu)
		  PrgTrigger$			(nth 4  LstMenu)
		  PrgSetup$				(nth 5  LstMenu)
		  PrgSAndS$				(nth 6  LstMenu)
		  PrgTools$				(nth 7  LstMenu)
		  PrgReport$			(nth 8  LstMenu)
		  PrgNestingExpert$ 	(nth 9  LstMenu)
		  PrgNestingSimple$		(nth 10 LstMenu)
		  PrgNestingTools$		(nth 11 LstMenu)
		  PrgNestingBar$		(nth 12 LstMenu)
	)
)
;
;
(defun c:Menu/Form1#OnInitialize (/ SaveCfgMenu SetCfgMenu RestoreCfgMenu 
									itm VarDwg)

	; Main
	;
	;(setq DefaultMenuEasyCut$ MainMenu)
	(setq VarDwg (SaveVarDwg))
	(setvar "FILEDIA" 1)
	(DefVarDwg)
	(StartReactors nil)
	(if (= (vl-registry-read EasyCutRegistryPath$ "MenuCfg") "")
		(progn
			(OpenDclSetCfgMenu)
			(OpenDclSaveCfgMenu)
		)
		(OpenDclRestoreCfgMenu)
	)
	(dcl-Control-SetCaption Menu/Form1/Label1 VersionEasyCut$)

	(setq LstVisible$ (list T nil nil))
	(setq EnameVisibleOnTab1$ (list (eval (read "Menu/Form1/Frame1"		))		; 0
									(eval (read "Menu/Form1/Frame2"		))		; 1
									(eval (read "Menu/Form1/Frame3"		))		; 2
									(eval (read "Menu/Form1/Frame4"		))		; 3
									(eval (read "Menu/Form1/Frame5"		))		; 4
									(eval (read "Menu/Form1/Frame6"		))		; 5
									(eval (read "Menu/Form1/Frame7"		))		; 6
									(eval (read "Menu/Form1/Button1"	))		; 7
									(eval (read "Menu/Form1/Button2"	))		; 8
									(eval (read "Menu/Form1/Button3"	))		; 9
									(eval (read "Menu/Form1/Button4"	))		; 10
									(eval (read "Menu/Form1/Button5"	))		; 11
									(eval (read "Menu/Form1/Button6"	))		; 12
									(eval (read "Menu/Form1/Button7"	))		; 13
									(eval (read "Menu/Form1/Button8"	))		; 14
									(eval (read "Menu/Form1/Button9"	))		; 15
									(eval (read "Menu/Form1/Button10"	))		; 16
									(eval (read "Menu/Form1/Button11"	))		; 17
									(eval (read "Menu/Form1/Button12"	))		; 18
									(eval (read "Menu/Form1/ComboBox1"	))		; 19
									(eval (read "Menu/Form1/ComboBox2"	))		; 20
									(eval (read "Menu/Form1/ComboBox3"	))		; 21
									(eval (read "Menu/Form1/ComboBox4"	))		; 22
									(eval (read "Menu/Form1/ComboBox5"	))		; 23
									(eval (read "Menu/Form1/ComboBox6"	))		; 24
									(eval (read "Menu/Form1/ComboBox7"	))		; 25
									(eval (read "Menu/Form1/ComboBox8"	))		; 26 
									(eval (read "Menu/Form1/ComboBox9"	))		; 27
									(eval (read "Menu/Form1/ComboBox10"	))		; 28
									(eval (read "Menu/Form1/ComboBox11"	))		; 29
									(eval (read "Menu/Form1/ComboBox12"	))))	; 30
									
									
									
	(setq EnameVisibleOnTab2$ (list (eval (read "Menu/Form1/Frame8"))
									(eval (read "Menu/Form1/Button13"))
									(eval (read "Menu/Form1/ComboBox13"))))
									
	;(setq EnameVisibleOnTab3$ (list (eval (read "Menu/Form1/TextButton2"))))
	;
	(setq EnameTabStrip$			(eval (read "Menu/Form1/TabStrip1")))
	;
	; Fill Combo
	;
	; Setup ++++++++++++++++
	(setq PopupSetup$ 		  '("01   Menu Setup" 						"02   Visualizza Variabili" 		"03   Carica Default Setup"	))
	(setq MacroSetup$ 	 	  '("01   GuiSetupEasyCut" 					"02   CheckVarEasyCut" 				"03   LoadDefaultSetup"		))
	; Import - Export ++++++
	(setq PopupImport$ 		  '("01   Importa formato Dstv" 			"02   Importa formato Cam" 			"03   Importa formato Xls"
								"04   Importa formato Dxf"																				))
	(setq MacroImport$ 		  '("01   ImportShapeDstv" 					"02   ImportShapeCam" 				"03   ImportShapeXls"
								"04   ImportShapeDxf"																					))
	
	(setq PopupSql$			  '("01   Esporta Controni SqLite"			"02   Esporta Lamiere SqLite"		"03   Importa Controni SqLite"	
								"04   Importa Lamiere SqLite"																			))
	(setq MacroSql$			  '("01   ExportShapeToSql" 				"02   ExportSheetToSql" 			"03   ImportShapeFromSql" 		
								"04   ImportSheetFromSql"																				))
	; Search +++++++++++++++
	(setq PopupSearch$ 		  '("01   Cerca Pezzi su Lamiere"			"02   Cerca Pezzi Archivio"										))
	(setq MacroSearch$ 		  '("01   GuiFindShapeOnSheet" 				"02   GuiFindShape"												))
	; Shape & Sheet ++++++++
	(setq PopupSAndS$ 		  '("01   Gestione contorni"				"02   Forma"						"03   Inserisci lamiera"
								"04   Inserisci stock lamiere" 			"05   Info dinamico"											))
	(setq MacroSAndS$ 		  '("01   ManagementShape" 					"02   TcEasyCut" 					"03   TsEasyCut"
								"04   CreateStockSheet" 				"05    DinamicInfo"												))
	; Trigger ++++++++++++++
	(setq PopupTrigger$		  '("01   Attacco Manuale"					"02   Attacco Automatico"			"03   Attacco Lamiera"
								"04   Elimina Attacco"					"05   Crea Micro"					"06   Elimina Micro"		))
	(setq MacroTrigger$		  '("01   ManualTrigger"					"02   AutoTrigger"					"03   SheetTrigger"
								"04   DeleteTrigger"					"05   MakeMicro"					"06   RemoveMicro" 			))
	; Tools ++++++++++++++++
	(setq PopupTools$ 		  '("01   Inserisci contorno"				"02   Tetrix"						"03   Serie"
								"04   Flessione"																						))
	(setq MacroTools$ 		  '("01   FineTunning" 						"02   ToolMove" 					"03   ArrayShape"
								"04   Flex"																								))
	; Nesting ++++++++++++++

	;(setq PopupNestingExpert$ '("01   Nesting Expert" 					"02   Importa Nesting"											))
	;(setq PopupNestingExpert$ '("01   Nesting Expert" 					"02   Nesting Rettangoli"			"03   Nesting Sezionatrice"	))
	;(setq MacroNestingExpert$ '("01   ExpertNesting" 					"02   ImportNestingExpert"										))

	(setq PopupNestingExpert$ '("01   Nesting Compresso"				"02   Nesting Sezionatrice"			"03   Nesting Semplice"		))
	(setq MacroNestingExpert$ '("01   ExpertNesting" 					"02   RectPackNesting"				"03   SimpleNesting"		))

	(setq PopupNestingSimple$ '("01   Nesting Rettangoli" 																				))
	(setq MacroNestingSimple$ '("01   SimpleNesting"																					))

	(setq PopupNestingBar$ 	  '("01   Nesting Barre"																					))
	(setq MacroNestingBar$ 	  '("01   NestingBar"																						))


	(setq PopupNestingTools$  '("01   Calcolo Disponibilita' Lamiere"	"02   Sequenza Taglio"				"03   PartProgamm Lamiera"
								"04   PartProgamm Contorno"				"05   Sfrido"													))
	(setq MacroNestingTools$  '("01   GuiAvailabilitySheet" 			"02   GuiSequenceCut"				"03   PostProcessorSheet"
								"04   PostProcessorShape" 				"05   GuiScrapSheet"											))
	(setq PopupReport$ 		  '("01   Report Utilizzo Lamiera"			"02   Report Sconto Nesting"		"03   Report Sconto Lamiera"
								"04   Report Sconto Pezzi"				"05   Report Lamiera" 				"06   Gestione Report"		))
	(setq MacroReport$ 		  '("01   InfoCutSheet" 					"02   MergeNesting" 				"03   MergeSheet" 			
								"04   MergeShape" 						"05   ReportSheet" 					"06   ManagerReportSheet"	))
	; Macro ++++++++++++++++
	(setq PopupApp$			  '("01   Versione Autocad"					"02   Info Oggetti"					"03   Info Ename"					
								"04   Zoom Handle"						"05   Semplifica polilinea"			"06   Segmenti->Archi"
								"07   Inserisci vertice polilinea" 		"08   Visualizza AcadDoc.lsp" 		"09   Ridimensiona Finestra"
								"10   Codice a barre 39" 				"11   Codice a barre 128"			"12   Crea stile dimensione"
								"13   Quota automatica contorni"		"14   Quota Leader"					"15   Encript"
								"16   Reactor"																							))
	(setq MacroApp$			  '("01   AcadVersion" 						"02   InfoObject" 					"03   InfoEname"
								"04   ZoomHandle"						"05   LwPolySimple" 				"06   PolyLineMergeToArc"	
								"07   AddVertexPolyline" 				"08   ShowAcadDoc"					"09   ResizeWindowDrawing"
								"10   Barcode39" 						"11   Barcode128"					"12   DimensionStyle"
								"13   Dimension"						"14   LeaderCoo" 					"15   Codex" 
								"16   Reactor"																							))
	; Set TAB1
	(dcl-ComboBox-AddList (nth 19 EnameVisibleOnTab1$) PopupSetup$		  ) (dcl-ComboBox-SetCurSel (nth 19 EnameVisibleOnTab1$) (atoi PrgSetup$))
	(dcl-ComboBox-AddList (nth 20 EnameVisibleOnTab1$) PopupImport$		  ) (dcl-ComboBox-SetCurSel (nth 20 EnameVisibleOnTab1$) (atoi PrgImport$))
	(dcl-ComboBox-AddList (nth 21 EnameVisibleOnTab1$) PopupSql$		  ) (dcl-ComboBox-SetCurSel (nth 21 EnameVisibleOnTab1$) (atoi PrgSql$))
	(dcl-ComboBox-AddList (nth 22 EnameVisibleOnTab1$) PopupSearch$		  ) (dcl-ComboBox-SetCurSel (nth 22 EnameVisibleOnTab1$) (atoi PrgSearch$))
	(dcl-ComboBox-AddList (nth 23 EnameVisibleOnTab1$) PopupSAndS$		  ) (dcl-ComboBox-SetCurSel (nth 23 EnameVisibleOnTab1$) (atoi PrgSAndS$))
	(dcl-ComboBox-AddList (nth 24 EnameVisibleOnTab1$) PopupTrigger$	  ) (dcl-ComboBox-SetCurSel (nth 24 EnameVisibleOnTab1$) (atoi PrgTrigger$))
	(dcl-ComboBox-AddList (nth 25 EnameVisibleOnTab1$) PopupTools$		  ) (dcl-ComboBox-SetCurSel (nth 25 EnameVisibleOnTab1$) (atoi PrgTools$))
	(dcl-ComboBox-AddList (nth 26 EnameVisibleOnTab1$) PopupNestingExpert$) (dcl-ComboBox-SetCurSel (nth 26 EnameVisibleOnTab1$) (atoi PrgNestingExpert$))
	(dcl-ComboBox-AddList (nth 27 EnameVisibleOnTab1$) PopupNestingSimple$) (dcl-ComboBox-SetCurSel (nth 27 EnameVisibleOnTab1$) (atoi PrgNestingSimple$))
	(dcl-ComboBox-AddList (nth 28 EnameVisibleOnTab1$) PopupNestingBar$	  ) (dcl-ComboBox-SetCurSel (nth 28 EnameVisibleOnTab1$) (atoi PrgNestingBar$))
	(dcl-ComboBox-AddList (nth 29 EnameVisibleOnTab1$) PopupNestingTools$ ) (dcl-ComboBox-SetCurSel (nth 29 EnameVisibleOnTab1$) (atoi PrgNestingTools$))
	(dcl-ComboBox-AddList (nth 30 EnameVisibleOnTab1$) PopupReport$		  ) (dcl-ComboBox-SetCurSel (nth 30 EnameVisibleOnTab1$) (atoi PrgReport$))
	; Set Tab2
	(dcl-ComboBox-AddList (nth 2  EnameVisibleOnTab2$) PopupApp$		  ) (dcl-ComboBox-SetCurSel (nth 2  EnameVisibleOnTab2$) (atoi PrgApp$))

	(foreach itm EnameVisibleOnTab1$
		(dcl-Control-SetVisible itm T)
	)
	(foreach itm EnameVisibleOnTab2$
		(dcl-Control-SetVisible itm nil)
	)
	;(foreach itm EnameVisibleOnTab3$
	;	(dcl-Control-SetVisible itm nil)
	;)
	;(dcl-TabStrip-SetCurSel EnameTabStrip$ 0)
	;(princ)
	
	(dcl-Control-SetVisible (eval (read "Menu/Form1/Button9"	)) nil)
	(dcl-Control-SetVisible (eval (read "Menu/Form1/ComboBox9"	)) nil)
	(dcl-Control-SetVisible (eval (read "Menu/Form1/DownloadEasyCut")) nil)
)
;
;
(defun c:Menu/Form1/TabStrip1#OnSelChanging (ItemIndex /)
	(setq Previus$ ItemIndex)

)
;
;
(defun c:Menu/Form1/TabStrip1#OnChanged (ItemIndex / itm)
;
	(setq Actual$ ItemIndex)
	(setq LstVisible$ (LM:SubstNth nil Previus$ LstVisible$))
	(setq LstVisible$ (LM:SubstNth T   Actual$  LstVisible$))
	;(princ LstVisible$) (terpri)
	
	(foreach itm EnameVisibleOnTab1$
		(dcl-Control-SetVisible itm nil)
	)
	(foreach itm EnameVisibleOnTab2$
		(dcl-Control-SetVisible itm nil)
	)
	(foreach itm EnameVisibleOnTab3$
		(dcl-Control-SetVisible itm nil)
	)
	;
	;
	(foreach itm EnameVisibleOnTab1$
		(dcl-Control-SetVisible itm (car LstVisible$))
	)
	(foreach itm EnameVisibleOnTab2$
		(dcl-Control-SetVisible itm (cadr LstVisible$))
	)	
	(foreach itm EnameVisibleOnTab3$
		(dcl-Control-SetVisible itm (caddr LstVisible$))
	)	
	
	(dcl-Control-SetVisible (eval (read "Menu/Form1/Button9"	)) nil)
	(dcl-Control-SetVisible (eval (read "Menu/Form1/ComboBox9"	)) nil)
	(dcl-Control-SetVisible (eval (read "Menu/Form1/DownloadEasyCut")) nil)

)
;
;
(defun c:Menu/Form1#OnClose (UpperLeftX UpperLeftY /)
	(ResetGlobalVariable)
)
;
;
(defun ResetGlobalVariable ()
	(setq EnameVisibleOnTab1$ 	nil
	      EnameVisibleOnTab2$ 	nil
	      EnameVisibleOnTab3$ 	nil
	      EnameTabStrip$		nil
	      LstVisible$ 			nil
	      PopupSetup$ 			nil
	      MacroSetup$ 			nil
          PopupImport$ 			nil
          MacroImport$ 			nil
		  PopupSql$ 			nil
		  MacroSql$ 			nil
		  PopupSearch$ 			nil
		  MacroSearch$ 			nil
		  PopupSAndS$ 			nil
		  MacroSAndS$ 			nil
		  PopupTrigger$ 		nil
		  MacroTrigger$ 		nil
		  PopupTools$ 			nil
		  MacroTools$ 			nil
		  PopupNestingExpert$ 	nil
		  MacroNestingExpert$ 	nil
		  PopupNestingSimple$ 	nil
		  MacroNestingSimple$ 	nil
		  PopupNestingBar$ 		nil
		  MacroNestingBar$ 		nil
		  PopupNestingTools$ 	nil
		  MacroNestingTools$ 	nil
		  PopupReport$ 			nil
		  MacroReport$ 			nil
		  PopupApp$ 			nil
		  MacroApp$ 			nil
	)
)
;
;
(defun c:Menu/Form1/DownloadEasyCut#OnClicked (/)
  (UpdateVersionEasyCut nil)
)
;
;
(defun c:Menu/Form1/ComboBox1#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgSetup$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (setq CmdApp (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgSetup$) MacroSetup$) " ")) ")"))
  (eval (read CmdApp))
)
;
;
(defun c:Menu/Form1/ComboBox2#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgImport$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (setq CmdApp (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgImport$) MacroImport$) " ")) ")"))
  (eval (read CmdApp))
)
;
;
(defun c:Menu/Form1/ComboBox3#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgSql$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (setq CmdApp (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgSql$) MacroSql$) " ")) ")"))
  (eval (read CmdApp))
)
;
;
(defun c:Menu/Form1/ComboBox4#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgSearch$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (setq CmdApp (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgSearch$) MacroSearch$) " ")) ")"))
  (eval (read CmdApp))
)
;
;
(defun c:Menu/Form1/ComboBox5#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgSAndS$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (setq CmdApp (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgSAndS$) MacroSAndS$) " ")) ")"))
  (eval (read CmdApp))
)
;
;
(defun c:Menu/Form1/ComboBox6#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgTrigger$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (setq CmdApp (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgTrigger$) MacroTrigger$) " ")) ")"))
  (eval (read CmdApp))
)
;
;
(defun c:Menu/Form1/ComboBox7#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgTools$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (setq CmdApp (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgTools$) MacroTools$) " ")) ")"))
  (eval (read CmdApp))
)
;
;
(defun c:Menu/Form1/ComboBox8#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgNestingExpert$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgNestingExpert$) MacroNestingExpert$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/ComboBox9#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgNestingSimple$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgNestingSimple$) MacroNestingSimple$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/ComboBox10#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgNestingBar$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgNestingBar$) MacroNestingBar$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/ComboBox11#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgNestingTools$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgNestingTools$) MacroNestingTools$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/ComboBox12#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgReport$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgReport$) MacroReport$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/ComboBox13#OnSelChanged (ItemIndexOrCount Value / CmdApp)
  (setq PrgApp$ (itoa ItemIndexOrCount))
  (OpenDclSaveCfgMenu)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgApp$) MacroApp$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/Button1#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgSetup$) MacroSetup$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/Button2#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgImport$) MacroImport$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/Button3#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgSql$) MacroSql$) " ")) ")")))
)	
;
;
(defun c:Menu/Form1/Button4#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgSearch$) MacroSearch$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/Button5#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgSAndS$) MacroSAndS$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/Button6#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgTrigger$) MacroTrigger$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/Button7#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgTools$) MacroTools$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/Button8#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgNestingExpert$) MacroNestingExpert$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/Button9#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgNestingSimple$) MacroNestingSimple$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/Button10#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgNestingBar$) MacroNestingBar$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/Button11#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgNestingTools$) MacroNestingTools$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/Button12#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgReport$) MacroReport$) " ")) ")")))
)
;
;
(defun c:Menu/Form1/Button13#OnClicked (/)
  (eval (read (strcat "(c:PopList" (cadr (SpliTxt (nth (atoi PrgApp$) MacroApp$) " ")) ")")))
)
;+++++++++++++++++++++++++++++