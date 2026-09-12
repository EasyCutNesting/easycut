(defun test1 ()
	(setq ename (car (entsel)))
	(setq aa (PutPosLineMessageShape ename))
	(PutLineMessageShape Ename "C" aa)
)
(defun test2 ()
	(setq LstCode (GetLineMessageShape (ssget)))
	(CloneShapeOnSheet (car LstCode))
	(entdel (car (car LstCode)))
)
;
;
;

;
;
;

;
;
;

;
;
;

;
;
;
;
;
;

;
;
;

;
;
;
