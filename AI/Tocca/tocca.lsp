;;; ============================================================
;;; TOCCA.LSP - Trasla una polilinea chiusa fino al contatto
;;;             con un'altra, in una direzione data.
;;;
;;; Comando: TOCCA
;;;   1. seleziona il poligono da spostare (A)
;;;   2. seleziona il poligono fisso (B)
;;;   3. scegli la direzione: X+ X- Y+ Y- oppure Angolo
;;;
;;; Vale per poligoni concavi e convessi (segmenti rettilinei).
;;; Le polilinee con archi (bulge) vengono rifiutate.
;;; ============================================================

(vl-load-com)

(setq *tc-eps* 1e-9)

;; ---- Prodotto vettoriale 2D --------------------------------
(defun tc:cross (u v)
  (- (* (car u) (cadr v)) (* (cadr u) (car v)))
)

;; ---- Vertici 2D di una LWPOLYLINE --------------------------
(defun tc:verts (en / pts)
  (foreach g (entget en)
    (if (= (car g) 10)
      (setq pts (cons (list (cadr g) (caddr g)) pts))
    )
  )
  (reverse pts)
)

;; ---- Controllo: solo segmenti rettilinei -------------------
(defun tc:has-bulge (en)
  (vl-some
    '(lambda (g) (and (= (car g) 42) (> (abs (cdr g)) 1e-12)))
    (entget en)
  )
)

;; ---- Lati del poligono (sempre chiuso): lista di (q1 q2) ---
(defun tc:edges (pts / res n i)
  (setq n (length pts) i 0)
  (repeat n
    (setq res (cons (list (nth i pts) (nth (rem (1+ i) n) pts)) res))
    (setq i (1+ i))
  )
  (reverse res)
)

;; ---- Distanza minima tt>=0 per cui un vertice di 'pts',
;;      spostato di tt*d, tocca un lato di 'edges'.
;;      Ritorna nil se non c'e' alcun contatto. ----------------
(defun tc:ray (pts edges d / best q1 q2 e den w tt s)
  (foreach ed edges
    (setq q1  (car ed)
          q2  (cadr ed)
          e   (list (- (car q2) (car q1)) (- (cadr q2) (cadr q1)))
          den (tc:cross d e)
    )
    (if (> (abs den) *tc-eps*)          ; salta lati paralleli a d
      (foreach p pts
        (setq w  (list (- (car q1) (car p)) (- (cadr q1) (cadr p)))
              tt (/ (tc:cross w e) den)
              s  (/ (tc:cross w d) den)
        )
        (if (and (>= tt (- *tc-eps*))
                 (>= s  (- *tc-eps*))
                 (<= s  (+ 1.0 *tc-eps*))
            )
          (setq tt (max tt 0.0)
                best (if best (min best tt) tt)
          )
        )
      )
    )
  )
  best
)

;; ---- Distanza di traslazione di A verso d fino al contatto
;;      con B. d deve essere un versore. Ritorna nil se A e B
;;      non si toccheranno mai in quella direzione. -----------
(defun tc:distance (va vb d / r1 r2 dneg)
  (setq dneg (list (- (car d)) (- (cadr d)))
        r1   (tc:ray va (tc:edges vb) d)      ; vertici A -> lati B
        r2   (tc:ray vb (tc:edges va) dneg)   ; vertici B -> lati A
  )
  (cond
    ((and r1 r2) (min r1 r2))
    (r1 r1)
    (r2 r2)
  )
)

;; ---- Selezione di una LWPOLYLINE valida --------------------
(defun tc:pick (msg / sel en)
  (while (not en)
    (setq sel (entsel msg))
    (cond
      ((null sel) (setq en 'annulla))
      ((/= (cdr (assoc 0 (entget (car sel)))) "LWPOLYLINE")
       (princ "\nL'oggetto non e' una LWPOLYLINE."))
      ((tc:has-bulge (car sel))
       (princ "\nLa polilinea contiene archi: non supportata."))
      (T (setq en (car sel)))
    )
  )
  (if (= en 'annulla) nil en)
)

;; ---- Comando principale ------------------------------------
(defun C:TOCCA (/ ea eb va vb kw ang d tt)
  (if (and (setq ea (tc:pick "\nSeleziona il poligono da spostare: "))
           (setq eb (tc:pick "\nSeleziona il poligono fisso: "))
      )
    (progn
      (initget "X+ X- Y+ Y- Angolo")
      (setq kw (getkword "\nDirezione [X+/X-/Y+/Y-/Angolo] <X+>: "))
      (if (null kw) (setq kw "X+"))
      (cond
        ((= kw "X+") (setq d (list  1.0  0.0)))
        ((= kw "X-") (setq d (list -1.0  0.0)))
        ((= kw "Y+") (setq d (list  0.0  1.0)))
        ((= kw "Y-") (setq d (list  0.0 -1.0)))
        (T
         (setq ang (getangle "\nAngolo di traslazione: "))
         (if ang (setq d (list (cos ang) (sin ang))))
        )
      )
      (if d
        (progn
          (setq va (tc:verts ea)
                vb (tc:verts eb)
                tt (tc:distance va vb d)
          )
          (if tt
            (progn
              (vla-move
                (vlax-ename->vla-object ea)
                (vlax-3d-point '(0.0 0.0 0.0))
                (vlax-3d-point (list (* tt (car d)) (* tt (cadr d)) 0.0))
              )
              (princ (strcat "\nTraslato di " (rtos tt 2 6) " unita'."))
            )
            (princ "\nNessun contatto possibile in questa direzione.")
          )
        )
      )
    )
  )
  (princ)
)

(princ "\nComando TOCCA caricato.")
(princ)
