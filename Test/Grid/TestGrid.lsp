;
; OPENDCL
;
(defun LoadRuntimeOpenDcl (/ AcadPlatform 
						     Path FileOpenDcl FN)

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
	(setq FileOpenDcl (strcat "OpenDCL."
							(AcadPlatform) "."
							(substr (getvar "acadver") 1 2)
							".ARX"
					)
	)
	
	(if (setq FN (findfile 	(strcat Path "\\OpenDCL\\" FileOpenDcl)))
		(arxload FN (strcat "\nError loading " FN))
	)
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

	(if (not (ExistFunction "dcl-Project-Load")) (LoadRuntimeOpenDcl))
	
	(LoadOpenDclLsp)
	(dcl-Project-Load "C:\\EasyCutNesting Beta\\Test\\Grid\\GridDxfChangeInfo.odcl" T)
	(dcl-Form-Show TestGrid/Form1)
	(princ)
)
;
;
(defun c:TestGrid/Form1#OnInitialize (/ Pos itm LstData)

	(setq EnameForm$ (eval (read "TestGrid/Form1")))
	(setq EnameGrid$ (eval (read "TestGrid/Form1/Grid1")))
	
	(dcl-Control-SetWidth  EnameForm$ 1246)
	(dcl-Control-SetHeight EnameForm$ 600)
	
	(dcl-Control-SetHeight EnameGrid$ 520)
	(dcl-Control-SetWidth  EnameGrid$ 1175)

	
	(dcl-Grid-AddColumns TestGrid/Form1/Grid1 
			(list 
				(list "Itm"              	   0 40 )     ; 0 Sinistra 1 Centro 2 Destra 
				(list (nth 0 $TmpLstButtonKey) 0 120)    
				(list (nth 1 $TmpLstButtonKey) 0 300)    
				(list (nth 2 $TmpLstButtonKey) 0 150)    
				(list (nth 3 $TmpLstButtonKey) 0 150)     
 				(list (nth 4 $TmpLstButtonKey) 0 150)    
				(list (nth 5 $TmpLstButtonKey) 0 60 )     
				(list (nth 6 $TmpLstButtonKey) 0 60 )     
				(list (nth 7 $TmpLstButtonKey) 0 60 )     
				(list (nth 8 $TmpLstButtonKey) 0 80 )
			)
	)
	(setq Pos 0)
	(repeat (length $TmpLstTableFiltered)
		(setq $TmpLstTableFiltered (LM:SubstNth (append (list (itoa (1+ Pos))) (nth Pos $TmpLstTableFiltered)) Pos $TmpLstTableFiltered))
		(setq Pos (1+ Pos))
	)
	
	;												 ("NoEdit" "NoEdit"  "str"  "str"  "str"  "int"  "real"  "str"  "str") 
	(dcl-Control-SetColumnStyleList EnameGrid$	(list    0 	      0 	   6      6      6      8      9      6      6 ))
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
  ; Reason 0 = Tasto Invio premuto
  ;; Reason 1 = Tasto ESC o tasto Chiudi (X)
  (if (= Reason 0)
	(progn
		(dcl_Control_SetFocus EnameGrid$)
		T   ; Ritorna T per BLOCCARE la chiusura e restare nel dialogo
	)
    NIL ; Ritorna NIL per permettere la chiusura (per ESC o pulsante X)
  )
)
;
;
(defun c:TestGrid/Form1/ExitForm#OnClicked (/ Pos)

	;
	; Reassembly list++++++++++++
	;
	(setq Pos 0)
	(repeat (length $TmpLstTableFiltered)
		(setq $TmpLstTableFiltered (LM:SubstNth (cdr (nth Pos $TmpLstTableFiltered)) Pos $TmpLstTableFiltered))
		(setq Pos (1+ Pos))
	)
	(dcl-Form-Close TestGrid/Form1/ExitForm)
)
;
;
(defun c:TestGrid/Form1/TextButton1#OnClicked (/ LstTmp Row Column)

	(setq Row 0)
	(setq $TmpLstTableFiltered nil)

	(repeat (dcl-Grid-GetRowCount EnameGrid$)
		(setq Column 1)
		(setq LstTmp nil)
		(repeat (1- (dcl-Grid-GetColumnCount EnameGrid$))
			(setq LstTmp (append LstTmp (list (dcl-Grid-GetCellText EnameGrid$ Row Column))))
			(setq Column (1+ Column))
		)
		(setq $TmpLstTableFiltered (append $TmpLstTableFiltered (list LstTmp)))
		(setq Row (1+ Row))
	)
	(dcl-Form-Close TestGrid/Form1/ExitForm)
)
;

