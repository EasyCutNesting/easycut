;questi sono i dati che ho verificato
;SheetBox ((MINX . 0.0) (MAXX . 1000.0) (MINY . 0.0) (MAXY . 500.0))
;LstShape (((20.0 20.0) (40.0 20.0) (40.0 40.0) (20.0 40.0)) ((60.0 60.0) (80.0 60.0) (80.0 80.0) (60.0 80.0)))
;(EasyCut:FindMaxScrapRectangle SheetBox LstShape) ((60.0 0.0) (1000.0 40.0) 37600.0)
;però dovrei ottenere ((0.0 80.0) (1000.0 500.0) 420000.0)

(setq SheetBox
	'(
		(MINX . 0.0)
		(MAXX . 12.0)
		(MINY . 0.0)
		(MAXY . 8.0)
	)
)
(setq Shape1
	'(
		(4.0 2.0)
		(7.0 4.0)
	)
)
(setq Shape2
	'(
		(8.0 1.0)
		(11.0 3.0)
	)
)	  
(setq Shape3
	'(
		(6.0 5.0)
		(9.0 7.0)
	)
)
(setq LstShape (list Shape1 Shape2 Shape3))

;(foreach itm (EasyCut:FindScrapRectangles SheetBox LstShape)
;
;	; ((0.0 80.0) (1000.0 500.0) 420000.0)
;	(EasyCut:DrawScrapRectangle itm 3 1)
;)
;
;
(defun EasyCut:ChoiseScrap (SheetBox LstShape / FindRect
												LstRect Loop gr code data LstPos itm)

	(defun FindRect (LstRect Pt / Pos P1 P2 X1 X2 Y1 Y2 LstRtn)
		
		(setq Pos 0)
		(repeat (length LstRect)
			(setq 	P1 (nth 0 (nth Pos LstRect))
					P2 (nth 1 (nth Pos LstRect))
					X1 (car P1)
					Y1 (cadr P1)
					X2 (car P2)
					Y2 (cadr P2)
			)
			(if (and (>= (car  Pt) X1)
					 (<= (car  Pt) X2)
					 (>= (cadr Pt) Y1)
					 (<= (cadr Pt) Y2)
				)
				(setq LstRtn (cons Pos LstRtn))
			)
			(setq Pos (1+ Pos))
		)
		LstRtn
	)
	;
	; Main 
	;
	(setq LstRect (EasyCut:FindScrapRectangles SheetBox LstShape))
	(setq Loop T)
	
	(while Loop
		(setq gr (grread 't 15 0) code (car gr) data (cadr gr))
		(cond
			((= Code 2)
				(if (member data '(13 32 69 101)) ; enter space E e
					(progn
						(redraw)
						(setq Loop nil)
					)
				)
			)
			((and (member Code '(5 3)) (listp Data))  ; Mouse rolling
				
				(if (= Code 5)
					(progn
						(redraw)
						(if (setq LstPos (FindRect LstRect Data))
							(foreach itm LstPos
								(EasyCut:DrawScrapRectangle (nth itm LstRect) 3 1)
							)
						)
					)
				)
				
				(if (= Code 3)						  ; Left click mouse
					(progn
						(redraw)
						(setq Loop nil)
					)
				)
			)
		)
	)
)
;
;
(defun EasyCut:DrawScrapRectangle (Rect Color Highlight / P1 P2 X1 Y1 X2 Y2)

	(if (and Rect (>= (length Rect) 2))

		(progn

			(setq P1 (nth 0 Rect)
				  P2 (nth 1 Rect)

				  X1 (car P1)
				  Y1 (cadr P1)

				  X2 (car P2)
				  Y2 (cadr P2)
			)

			;; Angoli del rettangolo
			(setq P1 (list X1 Y1 0.0)
				  P2 (list X2 Y1 0.0)
				  P3 (list X2 Y2 0.0)
				  P4 (list X1 Y2 0.0)
			)

			;; Lato inferiore
			(grdraw P1 P2 Color Highlight)

			;; Lato destro
			(grdraw P2 P3 Color Highlight)

			;; Lato superiore
			(grdraw P3 P4 Color Highlight)

			;; Lato sinistro
			(grdraw P4 P1 Color Highlight)

			Rect
		)
	)
)
;
;
(defun EasyCut:AddUnique
  (Value Lst /)

  (if (member Value Lst)
    Lst
    (cons Value Lst)
  )
)
;
;
(defun EasyCut:SortNumbers
  (Lst)

  (vl-sort
    Lst
    '(lambda (A B)
       (< A B)
     )
  )
)
;
;
(defun EasyCut:GetCandidateCoordinates
  (SheetBox LstShape
   / XList YList
     MinX MaxX MinY MaxY
     Shape P1 P2)

  ;; Coordinate del foglio
  (setq MinX (cdr (assoc 'MINX SheetBox))
        MaxX (cdr (assoc 'MAXX SheetBox))
        MinY (cdr (assoc 'MINY SheetBox))
        MaxY (cdr (assoc 'MAXY SheetBox))
  )

  (setq XList (list MinX MaxX)
        YList (list MinY MaxY)
  )

  ;; Coordinate degli shape rettangolari
  (foreach Shape LstShape

    (setq P1 (nth 0 Shape)
          P2 (nth 1 Shape)
    )

    (setq XList
      (EasyCut:AddUnique (car P1) XList)
    )

    (setq XList
      (EasyCut:AddUnique (car P2) XList)
    )

    (setq YList
      (EasyCut:AddUnique (cadr P1) YList)
    )

    (setq YList
      (EasyCut:AddUnique (cadr P2) YList)
    )
  )

  (list
    (EasyCut:SortNumbers XList)
    (EasyCut:SortNumbers YList)
  )
)
;
;
(defun EasyCut:RectanglesOverlap
  (Rect1 Rect2
   / A1 B1 A2 B2
     X1Min X1Max Y1Min Y1Max
     X2Min X2Max Y2Min Y2Max)

  (setq A1 (nth 0 Rect1)
        B1 (nth 1 Rect1)

        A2 (nth 0 Rect2)
        B2 (nth 1 Rect2)
  )

  (setq X1Min (min (car A1) (car B1))
        X1Max (max (car A1) (car B1))
        Y1Min (min (cadr A1) (cadr B1))
        Y1Max (max (cadr A1) (cadr B1))

        X2Min (min (car A2) (car B2))
        X2Max (max (car A2) (car B2))
        Y2Min (min (cadr A2) (cadr B2))
        Y2Max (max (cadr A2) (cadr B2))
  )

  ;; Uso di < e >:
  ;; se due rettangoli condividono soltanto un bordo,
  ;; non vengono considerati sovrapposti.
  (and
    (< X1Min X2Max)
    (> X1Max X2Min)
    (< Y1Min Y2Max)
    (> Y1Max Y2Min)
  )
)
;
;
(defun EasyCut:RectangleFree
  (X1 Y1 X2 Y2 LstShape
   / Candidate
     Shape
     Rtn)

  (setq Candidate
    (list
      (list X1 Y1)
      (list X2 Y2)
    )
  )

  (setq Rtn T)

  (foreach Shape LstShape

    (if
      (EasyCut:RectanglesOverlap Candidate Shape)
      (setq Rtn nil)
    )
  )

  Rtn
)
;
;
(defun EasyCut:RectangleContained-p
  (Rect1 Rect2
   / A1 B1 A2 B2
     X1Min X1Max Y1Min Y1Max
     X2Min X2Max Y2Min Y2Max)

  (setq A1 (nth 0 Rect1)
        B1 (nth 1 Rect1)

        A2 (nth 0 Rect2)
        B2 (nth 1 Rect2)
  )

  (setq X1Min (min (car A1) (car B1))
        X1Max (max (car A1) (car B1))
        Y1Min (min (cadr A1) (cadr B1))
        Y1Max (max (cadr A1) (cadr B1))

        X2Min (min (car A2) (car B2))
        X2Max (max (car A2) (car B2))
        Y2Min (min (cadr A2) (cadr B2))
        Y2Max (max (cadr A2) (cadr B2))
  )

  ;; Contenimento stretto:
  ;; rettangoli uguali non vengono considerati contenuti.
  (and
    (<= X2Min X1Min)
    (<= X1Max X2Max)
    (<= Y2Min Y1Min)
    (<= Y1Max Y2Max)

    (or
      (< X2Min X1Min)
      (< X1Max X2Max)
      (< Y2Min Y1Min)
      (< Y1Max Y2Max)
    )
  )
)
;
;
(defun EasyCut:RemoveContainedRectangles
  (LstRect
   / Result
     Rect
     Other
     Contained)

  (setq Result nil)

  (foreach Rect LstRect

    (setq Contained nil)

    (foreach Other LstRect

      (if
        (and
          (not (equal Rect Other 1e-8))
          (EasyCut:RectangleContained-p Rect Other)
        )
        (setq Contained T)
      )
    )

    (if (not Contained)
      (setq Result
        (cons Rect Result)
      )
    )
  )

  Result
)
;
;
(defun EasyCut:SortScrapRectangles
  (LstRect)

  (vl-sort
    LstRect

    '(lambda (R1 R2 / A1 A2 P1 P2)

       (setq A1 (caddr R1)
             A2 (caddr R2)

             P1 (car R1)
             P2 (car R2)
       )

       (cond
         ;; Prima area decrescente
         ((/= A1 A2)
          (> A1 A2)
         )

         ;; Poi X iniziale crescente
         ((/= (car P1) (car P2))
          (< (car P1) (car P2))
         )

         ;; Poi Y iniziale crescente
         ((/= (cadr P1) (cadr P2))
          (< (cadr P1) (cadr P2))
         )

         ;; Poi X finale crescente
         ((/= (car (cadr R1)) (car (cadr R2)))
          (<
            (car (cadr R1))
            (car (cadr R2))
          )
         )

         ;; Infine Y finale crescente
         (T
          (<
            (cadr (cadr R1))
            (cadr (cadr R2))
          )
         )
       )
     )
  )
)
;
;
(defun EasyCut:FindScrapRectangles
  (SheetBox LstShape
   / Coords
     XList YList
     X1 X2 Y1 Y2
     Rect Area
     LstRect)

  (setq LstRect nil)

  ;; Coordinate candidate
  (setq Coords
    (EasyCut:GetCandidateCoordinates
      SheetBox
      LstShape
    )
  )

  (setq XList (nth 0 Coords)
        YList (nth 1 Coords)
  )

  ;; Tutte le combinazioni possibili
  (foreach X1 XList

    (foreach X2 XList

      (if (> X2 X1)

        (foreach Y1 YList

          (foreach Y2 YList

            (if (> Y2 Y1)

              ;; Verifica che il rettangolo sia libero
              (if
                (EasyCut:RectangleFree
                  X1 Y1 X2 Y2 LstShape
                )

                (progn
                  (setq Area
                    (*
                      (- X2 X1)
                      (- Y2 Y1)
                    )
                  )

                  (setq Rect
                    (list
                      (list X1 Y1)
                      (list X2 Y2)
                      Area
                    )
                  )

                  (setq LstRect
                    (cons Rect LstRect)
                  )
                )
              )
            )
          )
        )
      )
    )
  )

  ;; Elimina i rettangoli contenuti in altri rettangoli
  (setq LstRect
    (EasyCut:RemoveContainedRectangles LstRect)
  )

  ;; Ordina per area decrescente
  (EasyCut:SortScrapRectangles LstRect)
)
;
;