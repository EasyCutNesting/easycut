(defun EasyCut:GetBoundingBoxPoints (LstPt / Pt X Y MinX MaxX MinY MaxY)

	(if LstPt
		(progn
			(setq Pt  (car LstPt)
				  MinX (car Pt)
				  MaxX (car Pt)
				  MinY (cadr Pt)
				  MaxY (cadr Pt)
			)

			(foreach Pt (cdr LstPt)

				(setq X (car Pt)
					  Y (cadr Pt)
				)

				(if (< X MinX)
					(setq MinX X)
				)

				(if (> X MaxX)
					(setq MaxX X)
				)

				(if (< Y MinY)
					(setq MinY Y)
				)

				(if (> Y MaxY)
					(setq MaxY Y)
				)
			)

			(list
				(cons 'MINX MinX)
				(cons 'MAXX MaxX)
				(cons 'MINY MinY)
				(cons 'MAXY MaxY)
			)
		)
	)
)
;
;
(defun EasyCut:PointOnSegment (Pt P1 P2 Tol / X Y X1 Y1 X2 Y2 Cross)

	(setq X  (car Pt)
		  Y  (cadr Pt)
		  X1 (car P1)
		  Y1 (cadr P1)
		  X2 (car P2)
		  Y2 (cadr P2)
	)

	(setq Cross
		(- (* (- X X1) (- Y2 Y1))
		   (* (- Y Y1) (- X2 X1))
		)
	)

	(and
		(<= (abs Cross) Tol)
		(<= (min X1 X2) (+ X Tol))
		(>= (max X1 X2) (- X Tol))
		(<= (min Y1 Y2) (+ Y Tol))
		(>= (max Y1 Y2) (- Y Tol))
	)
)
;
;
(defun EasyCut:PointInsidePolygon (Pt LstPt / Tol Inside I J P1 P2
										X Y X1 Y1 X2 Y2)

	(setq Tol 1e-9)

	(if (and Pt LstPt (> (length LstPt) 2))
		(progn

			;; Punto sul bordo
			(setq I 0
				  J (1- (length LstPt))
			)

			(while (< I (length LstPt))

				(setq P1 (nth I LstPt)
					  P2 (nth J LstPt)
				)

				(if (EasyCut:PointOnSegment Pt P1 P2 Tol)
					(progn
						(setq Inside T)
						(setq I (length LstPt))
					)
					(progn
						(setq J I
							  I (1+ I)
						)
					)
				)
			)

			;; Se non è sul bordo, controllo interno
			(if (null Inside)
				(progn

					(setq Inside nil
						  I 0
						  J (1- (length LstPt))
						  X (car Pt)
						  Y (cadr Pt)
					)

					(while (< I (length LstPt))

						(setq P1 (nth I LstPt)
							  P2 (nth J LstPt)

							  X1 (car P1)
							  Y1 (cadr P1)

							  X2 (car P2)
							  Y2 (cadr P2)
						)

						(if
							(and
								(/= (> Y1 Y) (> Y2 Y))
								(<
									X
									(+
										X1
										(*
											(- X2 X1)
											(/ (- Y Y1)
											   (- Y2 Y1)
											)
										)
									)
								)
							)
							(setq Inside (not Inside))
						)

						(setq J I
							  I (1+ I)
						)
					)
				)
			)

			Inside
		)
	)
)
;
;
(setq SheetBox
	'(
		(MINX . 0.0)
		(MAXX . 1000.0)
		(MINY . 0.0)
		(MAXY . 500.0)
	)
)
(setq Shape1
	'(
		(20.0 20.0)
		(40.0 20.0)
		(40.0 40.0)
		(20.0 40.0)
	)
)

(setq Shape2
	'(
		(60.0 60.0)
		(80.0 60.0)
		(80.0 80.0)
		(60.0 80.0)
	)
)

(setq LstShape (list Shape1 Shape2))

(defun EasyCut:SegmentsIntersect
	(P1 P2 P3 P4 / Tol Cross1 Cross2 Cross3 Cross4)

	(setq Tol 1e-9)

	(defun Cross (A B C)
		(-
			(*
				(- (car B) (car A))
				(- (cadr C) (cadr A))
			)
			(*
				(- (cadr B) (cadr A))
				(- (car C) (car A))
			)
		)
	)

	(setq Cross1 (Cross P1 P2 P3)
		  Cross2 (Cross P1 P2 P4)
		  Cross3 (Cross P3 P4 P1)
		  Cross4 (Cross P3 P4 P2)
	)

	(cond

		;; P3 o P4 sul segmento P1-P2
		((and
			(<= (abs Cross1) Tol)
			(EasyCut:PointOnSegment P3 P1 P2 Tol)
		 )
			T
		)

		((and
			(<= (abs Cross2) Tol)
			(EasyCut:PointOnSegment P4 P1 P2 Tol)
		 )
			T
		)

		;; P1 o P2 sul segmento P3-P4
		((and
			(<= (abs Cross3) Tol)
			(EasyCut:PointOnSegment P1 P3 P4 Tol)
		 )
			T
		)

		((and
			(<= (abs Cross4) Tol)
			(EasyCut:PointOnSegment P2 P3 P4 Tol)
		 )
			T
		)

		;; Intersezione propria
		((and
			(or
				(and (> Cross1 Tol) (< Cross2 (- Tol)))
				(and (< Cross1 (- Tol)) (> Cross2 Tol))
			)
			(or
				(and (> Cross3 Tol) (< Cross4 (- Tol)))
				(and (< Cross3 (- Tol)) (> Cross4 Tol))
			)
		 )
			T
		)
	)
)
;
;
(defun EasyCut:RectangleFree
	(X1 Y1 X2 Y2 LstShape / RectPt Shape Box MinX MaxX MinY MaxY
							  Pt P1 P2 I J Free)

	(setq Free T)

	;; ------------------------------------------------------------
	;; Vertici del rettangolo
	;; ------------------------------------------------------------

	(setq RectPt
		(list
			(list X1 Y1)
			(list X2 Y1)
			(list X2 Y2)
			(list X1 Y2)
		)
	)

	;; ------------------------------------------------------------
	;; Analizzo tutti i pezzi
	;; ------------------------------------------------------------

	(foreach Shape LstShape

		(if Free
			(progn

				(setq Box (EasyCut:GetBoundingBoxPoints Shape)

					  MinX (cdr (assoc 'MINX Box))
					  MaxX (cdr (assoc 'MAXX Box))
					  MinY (cdr (assoc 'MINY Box))
					  MaxY (cdr (assoc 'MAXY Box))
				)

				;; ------------------------------------------------
				;; 1. Bounding box completamente separati
				;; ------------------------------------------------

				(if (not
						(or
							(< X2 MinX)
							(> X1 MaxX)
							(< Y2 MinY)
							(> Y1 MaxY)
						)
					)
					(progn

						;; --------------------------------------------
						;; 2. Un vertice del pezzo è dentro il
						;;    rettangolo
						;; --------------------------------------------

						(foreach Pt Shape

							(if
								(and
									(<= X1 (car Pt))
									(<= (car Pt) X2)
									(<= Y1 (cadr Pt))
									(<= (cadr Pt) Y2)
								)
								(setq Free nil)
							)
						)

						;; --------------------------------------------
						;; 3. Un vertice del rettangolo è dentro
						;;    il pezzo
						;; --------------------------------------------

						(if Free
							(foreach Pt RectPt

								(if (EasyCut:PointInsidePolygon Pt Shape)
									(setq Free nil)
								)
							)
						)

						;; --------------------------------------------
						;; 4. Intersezione tra lati
						;; --------------------------------------------

						(if Free
							(progn

								(setq I 0)

								(while
									(and
										Free
										(< I (length Shape))
									)

									(setq J (if (= I 0)
												(1- (length Shape))
												(1- I)
										  )
										  P1 (nth J Shape)
										  P2 (nth I Shape)
									)

									;; lato inferiore
									(if (EasyCut:SegmentsIntersect
											P1 P2
											(nth 0 RectPt)
											(nth 1 RectPt)
										)
										(setq Free nil)
									)

									;; lato destro
									(if (and Free
											(EasyCut:SegmentsIntersect
												P1 P2
												(nth 1 RectPt)
												(nth 2 RectPt)
											)
										)
										(setq Free nil)
									)

									;; lato superiore
									(if (and Free
											(EasyCut:SegmentsIntersect
												P1 P2
												(nth 2 RectPt)
												(nth 3 RectPt)
											)
										)
										(setq Free nil)
									)

									;; lato sinistro
									(if (and Free
											(EasyCut:SegmentsIntersect
												P1 P2
												(nth 3 RectPt)
												(nth 0 RectPt)
											)
										)
										(setq Free nil)
									)

									(setq I (1+ I))
								)
							)
						)
					)
				)
			)
		)
	)

	Free
)
;
;
(defun EasyCut:AddUnique (Val Lst /)

	(if (member Val Lst)
		Lst
		(cons Val Lst)
	)
)
;
;
(defun EasyCut:SortNumbers (Lst)

	(vl-sort Lst '<)
)
;
;
(defun EasyCut:GetCandidateCoordinates
	(SheetBox LstShape / XList YList Shape Pt)

	(setq XList
		(list
			(cdr (assoc 'MINX SheetBox))
			(cdr (assoc 'MAXX SheetBox))
		)

		  YList
		(list
			(cdr (assoc 'MINY SheetBox))
			(cdr (assoc 'MAXY SheetBox))
		)
	)

	(foreach Shape LstShape

		(foreach Pt Shape

			(setq XList
				(EasyCut:AddUnique
					(car Pt)
					XList
				)
			)

			(setq YList
				(EasyCut:AddUnique
					(cadr Pt)
					YList
				)
			)
		)
	)

	(list
		(EasyCut:SortNumbers XList)
		(EasyCut:SortNumbers YList)
	)
)
;
;
(defun EasyCut:FindMaxScrapRectangle
	(SheetBox LstShape / Coord XList YList
		SheetMinX SheetMaxX SheetMinY SheetMaxY
		SheetHeight
		X1 X2 Y1 Y2
		MaxWidth MaxHeight
		BestRect BestArea Area)

	;; ------------------------------------------------------------
	;; Coordinate candidate
	;; ------------------------------------------------------------

	(setq Coord
		(EasyCut:GetCandidateCoordinates
			SheetBox
			LstShape
		)
	)

	(setq XList (car Coord)
		  YList (cadr Coord)
	)

	;; ------------------------------------------------------------
	;; Limiti foglio
	;; ------------------------------------------------------------

	(setq SheetMinX (cdr (assoc 'MINX SheetBox))
		  SheetMaxX (cdr (assoc 'MAXX SheetBox))
		  SheetMinY (cdr (assoc 'MINY SheetBox))
		  SheetMaxY (cdr (assoc 'MAXY SheetBox))

		  SheetHeight (- SheetMaxY SheetMinY)

		  BestRect nil
		  BestArea 0.0
	)

	;; ------------------------------------------------------------
	;; X1
	;; ------------------------------------------------------------

	(foreach X1 XList

		;; Larghezza massima possibile partendo da X1
		(setq MaxWidth
			(- SheetMaxX X1)
		)

		;; Se anche usando tutta l'altezza del foglio
		;; non possiamo migliorare BestArea, questa X è inutile.
		(if (> (* MaxWidth SheetHeight) BestArea)

			(foreach X2 XList

				(if (> X2 X1)

					(progn

						(setq MaxWidth (- X2 X1))

						;; ------------------------------------------------
						;; Potatura X2
						;; ------------------------------------------------

						(if (> (* MaxWidth SheetHeight) BestArea)

							(foreach Y1 YList

								;; --------------------------------------------
								;; Altezza massima possibile da Y1
								;; --------------------------------------------

								(setq MaxHeight
									(- SheetMaxY Y1)
								)

								(if (> (* MaxWidth MaxHeight) BestArea)

									(foreach Y2 YList

										(if (> Y2 Y1)

											(progn

												(setq MaxHeight
													(- Y2 Y1)
												)

												;; --------------------------------
												;; Potatura Y2
												;; --------------------------------

												(if (> (* MaxWidth MaxHeight)
													   BestArea)

													;; ----------------------------
													;; Controllo geometrico
													;; ----------------------------

													(if
														(EasyCut:RectangleFree
															X1 Y1 X2 Y2
															LstShape
														)

														(progn

															(setq Area
																(*
																	MaxWidth
																	MaxHeight
																)
															)

															(if (> Area BestArea)

																(progn

																	(setq BestArea Area)

																	(setq BestRect
																		(list
																			(list X1 Y1)
																			(list X2 Y2)
																			Area
																		)
																	)
																)
															)
														)
													)
												)
											)
										)
									)
								)
							)
						)
					)
				)
			)
		)
	)

	BestRect
)

;
;
