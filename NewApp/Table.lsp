
(vla-put-StyleName (vlax-ename->vla-object (getent)) "EasyCutTableStyle")
(MakeTable "New" 5 5 0.5 30)

(defun MakeTable (TitleTable NumRows NumColumns RowHeight ColWidth / objtable sp doc)

	(setq sp (vlax-3d-point '(0 0 0))) ; or use getpoint
	(setq doc  (vla-get-activedocument (vlax-get-acad-object) ))
	(setq vgms (vla-get-modelspace doc))
	(setq objtable (vla-addtable vgms sp NumRows NumColumns RowHeight ColWidth))
	
	(vla-settext objtable 0 0 TitleTable)
	;(vla-settext objtable 1 0 "A") 
	;(vla-settext objtable 1 1 "B") 
	;(vla-settext objtable 1 2 "C")
	;(vla-settext objtable 1 3 "D")
	;(vla-settext objtable 1 4 "E")
	;(vla-settext objtable 2 0 "1")
	;(vla-settext objtable 3 0 "2")
	;(vla-settext objtable 4 0 "3")
	(vla-setcolumnwidth objtable 0 15) ; 0 is first column
	(vla-setcolumnwidth objtable 1 30)
	(vla-setcolumnwidth objtable 2 60)
)

(defun c:CreateTableStyle()

   ;; Get the AutoCAD application and current document
   (setq acad (vlax-get-acad-object))
   (setq doc (vla-get-ActiveDocument acad))
   
   ;; Get the Dictionaries collection and the TableStyle dictionary
   (setq dicts (vla-get-Dictionaries doc))
   (setq dictObj (vla-Item dicts "acad_tablestyle"))
   
   ;; Create a custom table style
   (setq key "MyTableStyle"
         class "AcDbTableStyle")
   (setq custObj (vla-AddObject dictObj key class))

   ;; Set the name and description for the style
   (vla-put-Name custObj "EasyCutTableStyle")
   (vla-put-Description custObj "Easy Cut Nesting Bars")

   ;; Sets the bit flag value for the style
   (vla-put-BitFlags custObj 1)

   ;; Sets the direction of the table, top to bottom or bottom to top
   (vla-put-FlowDirection custObj acTableTopToBottom)

   ;; Sets the supression of the table header
   (vla-put-HeaderSuppressed custObj :vlax-false)

   ;; Sets the horizontal margin for the table cells
   (vla-put-HorzCellMargin custObj 0.22)

   ;; Sets the supression of the table title
   (vla-put-TitleSuppressed custObj :vlax-false)

   ;; Sets the vertical margin for the table cells
   (vla-put-VertCellMargin custObj 0.22)

   ;; Set the alignment for the Data, Header, and Title rows
   (vla-SetAlignment custObj (+ acTitleRow acHeaderRow) acMiddleCenter)
   (vla-SetAlignment custObj acDataRow acMiddleCenter)
 
   ;; Set the background color for the Header and Title rows
   (setq colObj (vlax-create-object (strcat "autocad.accmcolor." (substr (getvar 'acadver) 1 2))))
   (vla-SetRGB colObj 98 136 213)
   (vla-SetBackgroundColor custObj (+ acHeaderRow acTitleRow) colObj)

   ;; Clear the background color for the Data rows
   (vla-SetBackgroundColorNone custObj acDataRow :vlax-true)

   ;; Set the bottom grid color for the Title row
   (vla-SetRGB colObj 0 0 255)
   (vla-SetGridColor custObj acHorzBottom acTitleRow colObj)
   
   ;; Set the bottom grid lineweight for the Title row
   ;(vla-SetGridLineWeight tableStyle acHorzBottom acTitleRow acLnWt025)
   (vla-SetGridLineWeight custObj acHorzBottom acTitleRow acLnWt025)
   
   ;; Set the inside grid lines visible for the data and header rows
   (vla-SetGridVisibility custObj acHorzInside  (+ acDataRow acHeaderRow) :vlax-true)

   ;; Set the text height for the Title, Header and Data rows
   (vla-SetTextHeight custObj acTitleRow 1.5)
   (vla-SetTextHeight custObj (+ acDataRow acHeaderRow) 1.0)

   ;; Set the text height and style for the Title row
   (vla-SetTextStyle custObj (+ acDataRow acHeaderRow acTitleRow) "EasyCutStyle")

   ;; Release the color object
   (vlax-release-object colObj)

)



(defun c:tab2lst ( / sel )
   (if (setq sel (ssget "_+.:E:S" '((0 . "ACAD_TABLE"))))
       (tab2lst (vlax-ename->vla-object (ssname sel 0)))
   )
)
(defun tab2lst ( obj / col lst row tmp )
   (repeat (setq row (vla-get-rows obj))
       (repeat (setq row (1- row) col (vla-get-columns obj))
           (setq tmp (cons (vla-gettext obj row (setq col (1- col))) tmp))
       )
       (setq lst (cons tmp lst) tmp nil)
   )
   lst
)


; ACAD_Table Sort by Column
; 1. Use GetCell and collect the rows below (to skip the title and headers)
; 2. Sort by Nth (sort the rows by nth element (column)) using custom sorting function 
; Grread not required
 
; 1. Pick Column To Sort By (only the rows below the picked cell gonna be sorted)
; 2. ACAD_TABLE->Matrix_List
; 3. SortByNth using custom sorting function
; 4. RePopulate ACAD_TABLE using the new Matrix List 
 
(defun C:test ( / SortByNth GetCellVals GetAllTableCells Lst->PopulateAcad_Table *error* osm cell acDoc AllCells FirstHalf SecondHalf FirstHalfVals SecondHalfVals SecondSortedVals )
  
  
  
  ; This could be used to map into the table's cells 
  ; Lee Mac ; https://www.theswamp.org/index.php?topic=52935.msg577618#msg577618
  (defun mapncar ( n f l ) (if (< 0 n) (mapcar '(lambda ( x ) (mapncar (1- n) f x)) l) (mapcar 'f l) ) )
  
  ; (SortByNth 0 (lambda (L) (SortStringWithNumberAsNumber L)) L)
  ; This one combines (SortByNth_vl-sort) and (SortByNth_SortingFoo)
  ; Sort Matrix Assoc List By Nth - by applying list-sorting function as a foo
  (defun SortByNth ( n foo L / nL snL )
    (setq nL (mapcar '(lambda (x) (nth n x)) L)) ; List of nth atoms to be sorted
    (setq snL (apply (function foo) (list nL))) ; List of sorted nth atoms
    (vl-sort L '(lambda (a b) (< (vl-position (nth n a) snL) (vl-position (nth n b) snL))))
  ); SortByNth
  
  (defun GetCellVals (L) (mapcar (function (lambda (x) (apply 'vla-GetText x))) L))
  
  (defun GetAllTableCells ( obj / col lst row tmp ) ; Based on Lee Mac's Example
    (repeat (setq row (vla-get-rows obj)) (repeat (setq row (1- row) col (vla-get-columns obj)) (setq tmp (cons (list obj row (setq col (1- col))) tmp)) )
      (setq lst (cons tmp lst) tmp nil)
    )
    lst
  ); defun GetAllTableCells
  
  (defun Lst->PopulateAcad_Table ( o L / r c ) ; Based on Lee Mac's Example
    (cond 
      ( (and (eq (type o) 'VLA-OBJECT) (eq (vla-get-ObjectName o) "AcDbTable"))
        (vla-put-RegenerateTableSuppressed o :vlax-true)
        (setq r 0) (foreach itm L (setq c 0) (foreach x itm (vla-SetCellValue o r c x) (setq c (1+ c)) ) (setq r (1+ r)) )
        (vla-put-RegenerateTableSuppressed o :vlax-false)
      )
    ); cond
  ); defun Lst->PopulateAcad_Table
  
  (defun *error* ( m )
    (and osm (setvar 'osmode osm))
    (and m (princ m)) (princ)
  ); defun *error*
  
  (and
    (setq osm (getvar 'osmode))
    (setvar 'osmode 0)
  ); and
  
  (cond 
    ( (not (setq cell (GetTableCell "Specify Table Cell to Start Sorting From By its Column"))) (princ "\nTable Cell not specified.") ) ; (o r c)
    (T 
      (setq acDoc (vla-get-ActiveDocument (vlax-get-acad-object))) (or (vla-EndundoMark acDoc) (vla-StartUndoMark acDoc))
      (setq AllCells (GetAllTableCells (car cell)))
      (setq FirstHalf  (vl-remove-if-not (function (lambda (x) (> (cadr cell) (cadar x)))) AllCells))
      (setq SecondHalf  (vl-remove-if-not (function (lambda (x) (<= (cadr cell) (cadar x)))) AllCells)) ; To be sorted
      (setq FirstHalfVals (mapcar 'GetCellVals FirstHalf))
      (setq SecondHalfVals (mapcar 'GetCellVals SecondHalf))
      (setq SecondSortedVals (SortByNth (caddr cell) (lambda (L) (SortStringWithNumberAsNumber L)) SecondHalfvals))
      (and (progn (initget "Yes No") (= "Yes" (cond ((getkword "\nReverse sorting? [Yes/No] <No>: ")) ("No")))) (setq SecondSortedVals (reverse SecondSortedVals)))
      (vla-put-RegenerateTableSuppressed (car cell) :vlax-true) 
      (Lst->PopulateAcad_Table (car cell)   (append FirstHalfVals SecondSortedVals))
      (vla-put-RegenerateTableSuppressed (car cell) :vlax-false)
      (vla-EndundoMark acDoc)
    ); T 
  ); cond
  (*error* nil)
  (princ)
); defun
 
 
 
; http://www.theswamp.org/index.php?topic=16564.msg207439#msg207439
;; Usage (SortStringWithNumberAsNumber '("A9" "A1" "A10" "B11" "B2" "B05"))
;; Return ("A1" "A9" "A10" "B2" "B05" "B11") 
(defun SortStringWithNumberAsNumber (ListOfString)
  ;;; Function Normalize (add 0 befor number) number in string
  ;;; Count normalize symbols set in variable count
  (defun NormalizeNumberInString (str / ch i pat ret count buf)
    (setq i     0
      pat   '("0" "1" "2" "3" "4" "5" "6" "7" "8" "9")
      ret   ""
      count 4 ;_Count normalize symbols
    ) ;_ end of setq
    (while (/= (setq ch (substr str (setq i (1+ i)) 1)) "")
      (if (vl-position ch pat)
        (progn
          (setq buf ch) ;_ end of setq
          (while
            (vl-position (setq ch (substr str (setq i (1+ i)) 1)) pat)
            (setq buf (strcat buf ch))
          ) ;_ end of while
          (while (< (strlen buf) count) (setq buf (strcat "0" buf)))
          (setq ret (strcat ret buf))
        ) ;_ end of progn
      ) ;_ end of if
      (setq ret (strcat ret ch))
    ) ;_ end of while
    ret
  ) ;_ end of defun
  (mapcar '(lambda (x) (nth x ListOfString)) (vl-sort-i (mapcar 'NormalizeNumberInString ListOfString) '<)) 
) ;_ end of defun
 
 
; (if (setq cell (GetTableCell nil)) (apply '(lambda (o r c) (vlax-invoke o 'GetCellValue r c)) cell)) ; will return the vlax-variant-value
; (if (setq cell (GetTableCell nil)) (apply 'vla-GetCellValue cell)) ; will return variant
; _$ (GetTableCell nil) -> (#<VLA-OBJECT IAcadTable 0000010540176cd8> 2 2) ; Example, returns a list of (o r c)
(defun GetTableCell ( msg / HitTest GetAcadTableObjects atL Stop p r )
  
  (defun HitTest ( pt lst ) ; Lee Mac
    (if (and (vl-consp pt) (vl-every 'numberp pt))
      (vl-some
        (function
          (lambda ( o / r c )
            (if (eq :vlax-true (vla-HitTest o (vlax-3D-point (trans pt 1 0)) (vlax-3D-point (trans (getvar 'VIEWDIR) 1 0)) 'r 'c)) (list o r c) )
          )
        )
        lst
      ); vl-some
    ); if
  ); defun HitTest
  
  (defun GetAcadTableObjects ( / SS i L )
    (if (setq SS (ssget "X" (list '(0 . "ACAD_TABLE") (if (= 1 (getvar 'cvport)) (cons 410 (getvar 'ctab)) '(410 . "Model")))))
      (repeat (setq i (sslength SS)) (setq L (cons (vlax-ename->vla-object (ssname SS (setq i (1- i)))) L)) )
    ); if
  ); defun GetAcadTableObjects
  
  (if (setq atL (GetAcadTableObjects))
    (while (not Stop) 
      (initget "eXit") (setq p (getpoint (strcat "\n" (if (eq 'STR (type msg)) msg "Specify Table Cell") " or [eXit]: ")))
      (cond 
        ( (eq 'STR (type p)) (setq Stop T) )
        ( (not (setq r (HitTest p atL))) (princ "\nInvalid point.") )
        (T (setq Stop T))
      ); cond
    ); while
    (princ "\nNo ACAD_TABLEs found in this drwaing.")
  ); if
  r
); defun GetTableCell