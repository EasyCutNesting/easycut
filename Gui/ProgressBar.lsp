;-------------------------------------------------------------------------------
; Program Name: ProgressBar.lsp [Progress Bar R3]
; Created By:   Terry Miller (Email: terrycadd@yahoo.com)
;               (URL: http://web2.airmail.net/terrycad)
; Date Created: 6-20-04
; Function:     Progress Bar functions to be used in loops
;-------------------------------------------------------------------------------
; Revision History
; Rev  By     Date    Description
;-------------------------------------------------------------------------------
; 1    TM    6-20-04  Initial version
; 2    TM    2-20-05  Divided initial function into three functions, ProgressBar,
;                     Progress, and EndProgressBar to be used in loops.
; 3    TM    1-20-07  Updated progress bar dialog design.
;-------------------------------------------------------------------------------
; c:PB-Demo - ProgressBar demo functions for an information message only
;-------------------------------------------------------------------------------
(defun c:PB-Demo ( / List@ Reps~)
  (ProgressBar "" "Processing calculations..." 0.5);Title$, Message$, Percent of *Speed# variable
  (repeat 100 (Progress))
  (EndProgressBar)
  (princ)
);defun c:PB-Demo
;-------------------------------------------------------------------------------
; c:PB-Demo1 - ProgressBar demo functions with a foreach loop example
;-------------------------------------------------------------------------------
(defun c:PB-Demo1 ( / List@ Reps~)
  (repeat 500 (setq List@ (append List@ (list ""))));Create a long list
  (ProgressBar "" "" 0.5);Title$, Message$, Percent of *Speed# variable
  (setq Reps~ 1)
  ;The following may be a repeat, a foreach or a while loop
  (foreach Item List@ ;This is a redundant example
    ;Process something here
    (setq Reps~ (+ Reps~ (/ 100.0 (length List@))))
    (repeat (fix Reps~) (Progress));Move the Progress Bar
    (setq Reps~ (- Reps~ (fix Reps~)))
  );foreach
  (EndProgressBar);Close the Progress Bar
);defun c:PB-Demo1
;-------------------------------------------------------------------------------
; c:PB-Demo2 - ProgressBar demo functions with a repeat loop example
;-------------------------------------------------------------------------------
(defun c:PB-Demo2 ( / List@ Reps~ SS&)
  (princ "\nSelect objects for demo selection set.")
  (if (setq SS& (ssget))
    (progn
      (ProgressBar "" "Load Cad3d software..." 0.25)
      (setq Reps~ 1)
      
      (repeat (sslength SS&);This is a redundant example
        
        (setq Reps~ (+ Reps~ (/ 100.0 (sslength SS&))))
        (repeat (fix Reps~) (Progress));Move the Progress Bar
        (setq Reps~ (- Reps~ (fix Reps~)))
      )
      (EndProgressBar)
    )
  )
)
;-------------------------------------------------------------------------------
; c:PB-Demo3 - ProgressBar demo functions with a while loop example
;-------------------------------------------------------------------------------
(defun c:PB-Demo3 ( / FileName% PathFilename$ Reps# Text$)
  (if (setq PathFilename$ (findfile "ACAD.pgp"))
    (progn
      (setq FileName% (open PathFilename$ "r"))
      (ProgressBar "" "Load Cad3d software..." 0.5)
      (setq Reps# 1)
      ;The following may be a repeat, a foreach or a while loop
      (while (setq Text$ (read-line FileName%))
        ;Process something here
        (if (= (rem Reps# 4) 0);Every fourth time
          (Progress);Move the Progress Bar
        );if
        (setq Reps# (1+ Reps#))
      );while
      (close FileName%)
      (EndProgressBar);Close the Progress Bar
    );progn
  );if
);defun c:PB-Demo3

;-------------------------------------------------------------------------------
; ProgressBar - Progress Bar
; Arguments: 3
;   Title$ = Dialog title
;   Message$ = Message to display
;   Delay~ - Percentage of *Speed# variable
; Example: (ProgressBar "Program Message" "Processing information..." 0.5)
;-------------------------------------------------------------------------------
(defun ProgressBar (Title$ Message$ Delay~)

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
	(write-line "        width = 58.92; fixed_width = true;"				des)
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
	(if (not *Speed#) (Speed))
  
  ;(strcat disk$ path_prog$ "/tools/progressbar/ProgressBar.dcl")
  ;(setq *Dcl_Id% (load_dialog "c:\\cad3d\\tmp\\ProgressBar.dcl"))
  
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
);defun ProgressBar
;-------------------------------------------------------------------------------
; Progress - Move the Progress Bar
;-------------------------------------------------------------------------------
(defun Progress (/ Complete$)
  (setq *Inc# (1+ *Inc#))
  (if (= (rem *Inc# 2) 1)
    (setq *Xpt# (+ *Xpt# 7))
  );if
  (start_image "ProgressBar")
  (if (> *Inc# 100)
    (progn
      (setq *Inc# 0 *Xpt# -4)
      (start_image "ProgressBar")
      (fill_image 3 3 (- *X# 5) (- *Y# 5) -14)
    );progn
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
    );progn
  );if
  (end_image)
  (setq Complete$ (strcat (itoa (fix (+ *Inc# 0.5))) "% Complete..."))
  (set_tile "Complete" Complete$)
  (delay *Delay~)
  (action_tile "cancel" "(done_dialog)(exit)")
  (if (= *Inc# 100)(delay 10));Delay to show complete
  (princ)
);defun Progress
;-------------------------------------------------------------------------------
; EndProgressBar - Close Progress Bar dialog and clear variables
;-------------------------------------------------------------------------------
(defun EndProgressBar ( )
  (setq *Delay~ (* *Delay~ 0.5));Speed up bars remaining
  (if (and (> *Inc# 0)(< *Inc# 100))
    (repeat (- 100 *Inc#) (Progress))
  );if
  (done_dialog)
  (start_dialog)
  (unload_dialog *Dcl_Id%)
  (vl-file-delete *dcl%)
  (setq *Dcl_Id% nil *Delay~ nil *Inc# nil *X# nil *Xpt# nil *Y# nil)
  ;(alert "1111")
  (princ)
);defun EndProgressBar
;-------------------------------------------------------------------------------
; Speed - Determines the approximate computer processing speed and sets the
; global variable *speed# which may be used in delay loops while in dialogs.
;-------------------------------------------------------------------------------
(defun Speed (/ Cdate~ Cnt# NewSecond# OldSecond#)
  (setq Cdate~ (getvar "CDATE"))
  (setq NewSecond# (fix (* (- (* (- Cdate~ (fix Cdate~)) 100000)(fix (* (- Cdate~ (fix Cdate~)) 100000))) 10)))
  (repeat 2
    (setq Cnt# 0)
    (setq OldSecond# NewSecond#)
    (while (= NewSecond# OldSecond#)
      (setq Cdate~ (getvar "CDATE"))
      (setq NewSecond# (fix (* (- (* (- Cdate~ (fix Cdate~)) 100000)(fix (* (- Cdate~ (fix Cdate~)) 100000))) 10)))
      (setq Cnt# (1+ Cnt#))
    );while
  );repeat
  (setq *Speed# Cnt#)
  (princ)
);defun Speed
;-------------------------------------------------------------------------------
; delay - time delay function
; Arguments: 1
;   Percent~ - Percentage of *Speed# variable
; Returns: time delay
;-------------------------------------------------------------------------------
(defun delay (Percent~ / Number~)
  (if (not *Speed#) (Speed))
  (repeat (fix (* *Speed# Percent~)) (setq Number~ pi))
  (princ)
);defun delay
;-------------------------------------------------------------------------------
(princ);End of ProgressBar.lsp
