(defun SetExcelValue ()
	(setq ProcessExcelActive$ 	nil
		  MyXL$ 				nil 
		  MyBook$ 				nil 
		  MySheet$ 				nil 
		  MySheets$ 			nil 
		  MyCell$ 				nil
	)
)
;
;
;
(defun PrintExcelValue ()
	(princ "\nProcess Active ") (princ ProcessExcelActive$)
	(princ "\nApplication    ") (princ MyXL$)
	(princ "\nBook           ") (princ MyBook$)
	(princ "\nSheet Active   ") (princ MySheet$)
	(princ "\nSheet List     ") (princ MySheets$)
	(princ "\nValue Cell     ") (princ MyCell$)
)
;
;
;
(defun IsProcessExcelActive	(/)
	(if (vlax-get-object "Excel.Application")
		T
		nil
	)
)
;
;
;	
(defun OpenExcel (Exfile)

	(if (findfile Exfile)
		(progn
			(SetExcelValue)
			(setq ProcessExcelActive$ (IsProcessExcelActive))
			(setq MyXL$ (vlax-get-or-create-object "Excel.Application"))
			(if MyXL$
				(progn
					(setq VisibleProcess$ (vlax-get-property MyXL$ 'Visible))
					(setq AlertProcess$   (vlax-get-property MyXL$ 'DisplayAlerts))
					(vlax-put-property MyXL$ 'Visible       :vlax-false)
					(vlax-put-property MyXL$ 'DisplayAlerts :vlax-false)
					(setq MyBook$ (vl-catch-all-apply 'vla-open (list (vlax-get-property MyXL$ "WorkBooks") Exfile)))
				)
			)
		)
	)
)
;
;
;		
(defun CloseExcel ()

	(vl-catch-all-apply 'vlax-invoke-method (list MyBook$ "Close"))
	(if (not ProcessExcelActive$)
		(vl-catch-all-apply 'vlax-invoke-method (list MyXL$ "Quit"))
		(progn
			(vlax-put-property MyXL$ 'Visible       VisibleProcess$)
			(vlax-put-property MyXL$ 'DisplayAlerts AlertProcess$)
		)
	)
	(if MySheet$ (vlax-release-object MySheet$))
	(if MyBook$  (vlax-release-object MyBook$))
	(if MyXL$    (vlax-release-object MyXL$))
	(SetExcelValue)
	(gc)
)
;
;
;
(defun ActiveSheet (Sheet)
	(if Sheet
		(progn
			(setq MySheet$ (vl-catch-all-apply 'vlax-get-property (list (vlax-get-property MyBook$ "Sheets") "Item" Sheet)))
			(if (not (vl-catch-all-error-p MySheet$))
				(vlax-invoke-method MySheet$ "Activate")
				(setq MySheet$ nil)
			)
		)
		(setq MySheet$ nil)
	)
)
;
;
;
(defun GetCell (Cell / MyRange)

 	(if Cell
		(progn
			(setq MyRange  (vlax-get-property  (vlax-get-property MySheet$ 'Cells) "Range" Cell))
			(setq MyCell$  (vlax-variant-value (vlax-get-property MyRange 'Value2)))
		)
	)
)
;
;
;
(defun GetListSheet (/ itm)
	(setq MySheets$ nil)
	(vlax-for itm (vlax-get-property MyBook$ "Sheets")
		(setq MySheets$ (cons (vlax-get-property itm "Name") MySheets$))
	)
	(setq MySheets$ (reverse MySheets$))
)
;
;
;
(defun Test ()

	(setq ExcelFile "C:\\EasyCutBeta\\Note\\Access Data.xlsx")
	(if (findfile ExcelFile)
		(progn
			(OpenExcel "C:\\EasyCutBeta\\Note\\Access Data.xlsx")
			(GetListSheet)
			(ActiveSheet "Foglio1")
			(GetCell "B4")
			(PrintExcelValue)
			(CloseExcel)
		)
	)		
)
;
;
;
(defun ReadCells (LstColl LstRow / Rtn LstTmp Row Coll)

	
	(if (and LstColl LstRow)
		(foreach Row LstRow
			(foreach Coll LstColl
				(if (/= Coll "N.D.")
					(setq LstTmp (cons (GetCell (strcat Coll Row)) LstTmp))
					(setq LstTmp (cons nil LstTmp))
				)
			)
			(setq Rtn (append Rtn (list (reverse LstTmp))))
			(setq LstTmp nil)
		)
	)
	Rtn
)
;
;
;
