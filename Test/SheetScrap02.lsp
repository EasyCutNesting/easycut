;;; ============================================================
;;; SOMMARECT.LSP - Unione booleana di rettangoli (lati // X e Y)
;;; Comando: SOMMARECT
;;; Semplificazioni: rettangoli con lati paralleli agli assi,
;;; risultato senza fori (se ci fossero, i contorni interni
;;; verrebbero comunque disegnati come polilinee separate).
;;;
;;; Metodo: compressione delle coordinate.
;;;  1. Si raccolgono tutte le X e Y dei rettangoli (uniche, ordinate)
;;;  2. Si crea una griglia di celle: cella piena se contenuta
;;;     in almeno un rettangolo
;;;  3. Si estraggono i lati di bordo delle celle piene (orientati)
;;;  4. Si concatenano i lati in contorni chiusi
;;;  5. Si eliminano i vertici allineati
;;; ============================================================
(setq *rs-fuzz* 1e-8)
;; Ordina e toglie i duplicati (con tolleranza)
(defun rs:uniq-sort (lst / res)
  (foreach v (vl-sort lst '<)
    (if (or (null res) (> (- v (car res)) *rs-fuzz*))
      (setq res (cons v res))
    )
  )
  (reverse res)
)

;; Cella (i,j) della griglia: T se piena, nil se vuota o fuori griglia
(defun rs:cell (g i j)
  (and (>= i 0) (>= j 0)
       (< i (length g))
       (nth j (nth i g))
  )
)

;; Toglie i vertici intermedi di tratti rettilinei (punti = coppie di indici)
(defun rs:simplify (pts / n i p c nx res)
  (setq n (length pts) i 0)
  (repeat n
    (setq p  (nth (rem (+ i n -1) n) pts)
          c  (nth i pts)
          nx (nth (rem (1+ i) n) pts)
    )
    (if (not (or (= (car p) (car c) (car nx))
                 (= (cadr p) (cadr c) (cadr nx))
             )
        )
      (setq res (cons c res))
    )
    (setq i (1+ i))
  )
  (reverse res)
)

;; Funzione principale
;; rects = lista di (xmin ymin xmax ymax)
;; ritorna una lista di contorni; ogni contorno = lista di punti (x y)
(defun rs:union (rects / xs ys g col i j cx cy edges e start cur loop out)
  (setq xs (rs:uniq-sort (append (mapcar 'car rects) (mapcar 'caddr rects)))
        ys (rs:uniq-sort (append (mapcar 'cadr rects) (mapcar 'cadddr rects)))
  )

  ;; 1) griglia di celle piene
  (setq g nil i 0)
  (repeat (1- (length xs))
    (setq col nil
          j   0
          cx  (/ (+ (nth i xs) (nth (1+ i) xs)) 2.0)
    )
    (repeat (1- (length ys))
      (setq cy (/ (+ (nth j ys) (nth (1+ j) ys)) 2.0))
      (setq col
        (cons
          (if (vl-some
                '(lambda (r)
                   (and (< (car r) cx (caddr r))
                        (< (cadr r) cy (cadddr r))
                   )
                 )
                rects
              )
            T
            nil
          )
          col
        )
      )
      (setq j (1+ j))
    )
    (setq g (cons (reverse col) g))
    (setq i (1+ i))
  )
  (setq g (reverse g))

  ;; 2) lati di bordo, orientati in senso antiorario (materiale a sinistra)
  (setq edges nil i 0)
  (repeat (length g)
    (setq j 0)
    (repeat (length (car g))
      (if (rs:cell g i j)
        (progn
          (if (not (rs:cell g i (1- j)))       ; sotto vuoto
            (setq edges (cons (list (list i j) (list (1+ i) j)) edges)))
          (if (not (rs:cell g (1+ i) j))       ; destra vuota
            (setq edges (cons (list (list (1+ i) j) (list (1+ i) (1+ j))) edges)))
          (if (not (rs:cell g i (1+ j)))       ; sopra vuoto
            (setq edges (cons (list (list (1+ i) (1+ j)) (list i (1+ j))) edges)))
          (if (not (rs:cell g (1- i) j))       ; sinistra vuota
            (setq edges (cons (list (list i (1+ j)) (list i j)) edges)))
        )
      )
      (setq j (1+ j))
    )
    (setq i (1+ i))
  )

  ;; 3) concatenazione dei lati in contorni chiusi
  (while edges
    (setq e     (car edges)
          edges (cdr edges)
          start (car e)
          cur   (cadr e)
          loop  (list start)
    )
    (while (not (equal cur start))
      (setq loop (cons cur loop))
      (setq e (assoc cur edges))          ; lato che parte da cur
      (if e
        (setq edges (vl-remove e edges)
              cur   (cadr e))
        (setq cur start)                  ; sicurezza: non dovrebbe capitare
      )
    )
    ;; 4) semplificazione e conversione indici -> coordinate
    (setq loop (rs:simplify (reverse loop)))
    (setq out
      (cons
        (mapcar '(lambda (p) (list (nth (car p) xs) (nth (cadr p) ys))) loop)
        out
      )
    )
  )
  (reverse out)
)
;; ------------------------------------------------------------
;; FUNZIONE PUBBLICA
;; (rect-sum rettangoli)
;;   rettangoli : lista di ((xmin ymin) (xmax ymax))
;;                (i due angoli possono essere in qualsiasi ordine)
;;   ritorna    : lista di contorni, ognuno = lista di punti (x y)
;;
;; Esempio:
;;   (rect-sum '(((0 0) (4 2)) ((2 1) (6 5))))
;;   -> (((0 0) (4 0) (4 1) (6 1) (6 5) (2 5) (2 2) (0 2)))
;;
;; Se il risultato e' un solo contorno: (car (rect-sum ...))
;; ------------------------------------------------------------
(defun rect-sum (rects)
  (rs:union
    (mapcar
      '(lambda (r / p1 p2)
         (setq p1 (car r) p2 (cadr r))
         (list (min (car p1) (car p2))
               (min (cadr p1) (cadr p2))
               (max (car p1) (car p2))
               (max (cadr p1) (cadr p2))
         )
       )
      rects
    )
  )
)
;; Estrae ((xmin ymin) (xmax ymax)) da una LWPOLYLINE rettangolare, altrimenti nil
(defun rs:rect-from-ent (ed / pts xs ys)
  (foreach d ed
    (if (= (car d) 10) (setq pts (cons (cdr d) pts)))
  )
  (if (= (length pts) 4)
    (progn
      (setq xs (rs:uniq-sort (mapcar 'car pts))
            ys (rs:uniq-sort (mapcar 'cadr pts))
      )
      (if (and (= (length xs) 2) (= (length ys) 2))
        (list (list (car xs) (car ys)) (list (cadr xs) (cadr ys)))
      )
    )
  )
)
;; Disegna una polilinea chiusa
(defun rs:make-pline (pts layer)
  (entmake
    (append
      (list '(0 . "LWPOLYLINE")
            '(100 . "AcDbEntity")
            (cons 8 layer)
            '(100 . "AcDbPolyline")
            (cons 90 (length pts))
            '(70 . 1)
      )
      (mapcar '(lambda (p) (cons 10 p)) pts)
    )
  )
)
;; Comando
(defun c:SOMMARECT (/ ss i ed r rects skip loops kw)
  (prompt "\nSeleziona i rettangoli (polilinee chiuse a 4 vertici, lati // agli assi): ")
  (if (setq ss (ssget '((0 . "LWPOLYLINE"))))
    (progn
      (setq i 0 skip 0)
      (repeat (sslength ss)
        (setq ed (entget (ssname ss i)))
        (if (setq r (rs:rect-from-ent ed))
          (setq rects (cons r rects))
          (setq skip (1+ skip))
        )
        (setq i (1+ i))
      )
      (if (> skip 0)
        (prompt (strcat "\n" (itoa skip) " oggetti ignorati (non sono rettangoli ortogonali)."))
      )
      (if rects
        (progn
          (setq loops (rect-sum rects))
          (foreach l loops (rs:make-pline l (getvar "CLAYER")))
          (prompt (strcat "\nCreati " (itoa (length loops)) " contorni."))
          (initget "Si No")
          (setq kw (getkword "\nCancellare i rettangoli originali? [Si/No] <No>: "))
          (if (= kw "Si")
            (progn
              (setq i 0)
              (repeat (sslength ss)
                (if (rs:rect-from-ent (entget (ssname ss i)))
                  (entdel (ssname ss i))
                )
                (setq i (1+ i))
              )
            )
          )
        )
        (prompt "\nNessun rettangolo valido selezionato.")
      )
    )
  )
  (princ)
)
;
;
(prompt "\nCaricato: SOMMARECT (unione booleana di rettangoli).")
(princ)
