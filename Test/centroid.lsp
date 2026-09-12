(defun c:pc ( / acdoc acspc acsel pl bl ) (vl-load-com) 
 (setq acdoc (vla-get-ActiveDocument (vlax-get-acad-object))
       acspc (vlax-get-property acdoc (if (= 1 (getvar 'CVPORT)) 'Paperspace 'Modelspace))
 )
 (if (ssget '((0 . "LWPOLYLINE") (-4 . "&=") (70 . 1)))
   (progn
     (vlax-for obj (setq acsel (vla-get-ActiveSelectionSet acdoc))
       (vlax-invoke acspc 'addpoint
         (trans
           (progn
             (setq pl nil bl nil)
             (foreach a (reverse (entget (vlax-vla-object->ename obj)))
               (cond ((= (car a) 10) (setq pl (cons (cdr a) pl)))
                     ((= (car a) 42) (setq bl (cons (cdr a) bl)))
                     ); _  cond
               ); _  foreach
      ;;;(eea-centroid-solid-lw pl bl)
        [color="red"]  (reverse(cons (vla-get-elevation obj)(reverse (eea-centroid-solid-lw pl bl))));;;VVA MOD 2015-03-29[/color]
             )
           1 0)
       )
     )
     (vla-delete acsel)
   )
 )
 (princ)
)

(defun eea-centroid-solid-lw (pl bl / A1)
;|
***********************************************************************
by ElpanovEvgeniy
Library function, 
Centroids (center of masses) of region, inside [polilinii], which has arched segments.
pl - list of the apexes of [polilinii] (code 10)
bl - list of tangents fourth of angle of the arched segments of [polilinii] (code 42)
Date of the creation      2000 - 2005
Last editorial staff 08.06.2009
URL http://elpanov.com/index.php?id=46

*********************************************************************
Library of function.
Centroid (the of center of of weights) of region, inside of a of polyline, having of arc of segments
pl - list of point
bl - list of bulge
Date of of creation   2000 - 2005 years.
Last of edit 08.06.2009
**********************************************************************
(setq e  (car (entsel "\n Select LWPOLYLINE "))
     pl nil
     bl nil
) ;_  setq
(foreach a (reverse (entget e))
(cond ((= (car a) 10) (setq pl (cons (cdr a) pl)))
      ((= (car a) 42) (setq bl (cons (cdr a) bl)))
) ;_  cond
) ;_  foreach
(eea-centroid-solid-lw pl bl)
*****************************************************************
(defun c:test (/ e bl pl)
(setq e (car (entsel "\n Select LWPOLYLINE ")))
(foreach a (reverse (entget e))
 (cond ((= (car a) 10) (setq pl (cons (cdr a) pl)))
       ((= (car a) 42) (setq bl (cons (cdr a) bl)))
 ) ;_  cond
) ;_  foreach
(entmakex (list '(0 . "point")
                '(62 . 1)
                (cons 10 (eea-centroid-solid-lw pl bl))
                (assoc 210 (entget e))
          ) ;_  list
) ;_  entmakex
) ;_  defun
*******************************************************************
|;
(setq a1 0)
(mapcar
 (function /)
 (apply
  (function mapcar)
  (cons
   (function +)
   (mapcar
    (function
     (lambda (p1 p2 b / A BB C I S)
      (setq i  (/ (- (* (car p1) (cadr p2)) (* (car p2) (cadr p1))) 2)
            a1 (+ i a1)
            i  (/ i 3)
      ) ;_  setq
      (if (zerop b)
       (mapcar (function (lambda (a b) (* (+ a b) i))) p1 p2)
       (progn
        (setq c  (distance p1 p2)
              bb (* b b)
              a  (/ (* c c (- (* (atan b) (1+ bb) (1+ bb)) (* b (- 1 bb)))) (* 8 bb))
              a1 (+ a a1)
              s  (/ (- (* b c c) (* 3 a (- 1 bb))) (* 12 a b))
        ) ;_  setq
        (mapcar (function (lambda (a b c d) (+ (* (+ a b) i) (* d (+ (/ (+ a b) 2) c)))))
                p1
                p2
                (list (* (- (cadr p2) (cadr p1)) s) (* (- (car p2) (car p1)) -1 s))
                (list a a)
        ) ;_  mapcar
       ) ;_  progn
      ) ;_  if
     ) ;_  lambda
    ) ;_  function
    (cons (last pl) pl)
    pl
    (cons (last bl) bl)
   ) ;_  mapcar
  ) ;_  cons
 ) ;_  apply
 (list a1 a1)
) ;_  mapcar
) ;_  defun