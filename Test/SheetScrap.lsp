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

(setq Rettangoli (list 	(list 	(list 0.0 0.0)
								(list 12.0 1.0))
						(list 	(list 0.0 0.0)
								(list 4.0 8.0))
						(list	(list 0.0 0.0)
								(list 8.0 2.0))))


(ScrapSheet:rect-sum rettangoli)
;
; ESEMPI +++++++
;
(setq LstRect1
	(list
		(list
			(list 0.0 0.0)
			(list 100.0 50.0)
			5000.0
		)
		(list
			(list 100.0 0.0)
			(list 180.0 50.0)
			4000.0
		)
	)
)
(setq LstRect2
	(list
		(list
			(list 0.0 0.0)
			(list 100.0 40.0)
		)
		(list
			(list 0.0 40.0)
			(list 40.0 100.0)
		)
	)
)
(setq LstRect3
	(list
		(list
			(list 0.0 0.0)
			(list 100.0 40.0)
		)
		(list
			(list 101.0 41.0)
			(list 200.0 80.0)
		)
	)
)
(setq LstRect4
	(list
		(list
			(list 0.0 0.0)
			(list 100.0 100.0)
		)
		(list
			(list 0.0 0.0)
			(list 200.0 50.0)
		)
		(list
			(list 0.0 0.0)
			(list 50.0 200.0)
		)
	)
)


(setq LstPolygon1
	(EasyCut:RectanglesToPolygons LstRect1)
)
(setq LstPolygon2
	(EasyCut:RectanglesToPolygons LstRect2)
)
(setq LstPolygon3
	(EasyCut:RectanglesToPolygons LstRect3)
)
(setq LstPolygon4
	(EasyCut:RectanglesToPolygons LstRect4)
)