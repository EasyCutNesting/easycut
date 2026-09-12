; http://www.connectionstrings.com/
;
;
;
(defun ResetDbaseInternalShape ( / NameDbFile tblName LstRowName ConnectString ConnectionObject Rtn itm IdShape LstIdShape)

	(setq NameDbFile "C:\\EasyCut\\Test\\Dbase\\InShape.mdb") ;access 2002-2003
	(setq tblName "INTERNALSHAPE")
	(setq LstRowName (list "IDSHAPE" "SHAPEDATA" "EXTENDEDDATA"))
	(setq ConnectString (strcat "Provider=MSDASQL;Driver={Microsoft Access Driver (*.mdb)};DBQ=" NameDbFile))
	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
	
	(if ConnectionObject
		(progn
			(setq Rtn (ReadDbase ConnectionObject tblName (nth 0 LstRowName) "*"))
			
			(cond 
				((and (/= Rtn -1) (/= Rtn -2))
					(foreach itm (cdr Rtn)
						(setq IdShape (nth 1 itm))
						(if (not (member IdShape LstIdShape))
							(setq LstIdShape (append LstIdShape (list IdShape)))
						)
					)
					(t
						nil
					)
				)
			)
			
			(foreach itm LstIdShape
				(DeteteRowDbase ConnectionObject tblName (nth 0 LstRowName) itm)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
			
		)
	)
)
;
;
;
(defun ResetDbaseExternalShape ( / NameDbFile tblName LstRowName ConnectString ConnectionObject Rtn itm IdShape LstIdShape)

	(setq NameDbFile "C:\\EasyCut\\Test\\Dbase\\ExShape.mdb") ;access 2002-2003
	(setq tblName "EXTERNALSHAPE")
	(setq LstRowName (list "IDSHAPE" "SHAPEDATA" "EXTENDEDDATA"))
	(setq ConnectString (strcat "Provider=MSDASQL;Driver={Microsoft Access Driver (*.mdb)};DBQ=" NameDbFile))
	(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
	
	(if ConnectionObject
		(progn
			(setq Rtn (ReadDbase ConnectionObject tblName (nth 0 LstRowName) "*"))
			
			(cond 
				((and (/= Rtn -1) (/= Rtn -2))
					(foreach itm (cdr Rtn)
						(setq IdShape (nth 1 itm))
						(if (not (member IdShape LstIdShape))
							(setq LstIdShape (append LstIdShape (list IdShape)))
						)
					)
					(t
						nil
					)
				)
			)
			
			(foreach itm LstIdShape
				(DeteteRowDbase ConnectionObject tblName (nth 0 LstRowName) itm)
			)
			(ADOLISP_DisconnectFromDB ConnectionObject)
			
		)
	)
)
;
;
;
(defun WriteDataInternalShape (EnameShape / NameDbFile tblName LstRowName ConnectString 
											ConnectionObject IdShape LstEnameInternalShape 
											LstDxfCode LstValName itm
											DxfDataN DxfDataE Rtn)


	(setq NameDbFile "C:\\EasyCut\\Test\\Dbase\\InShape.mdb") ;access 2002-2003
	(setq tblName "INTERNALSHAPE")
	(setq LstRowName (list "IDSHAPE" "SHAPEDATA" "EXTENDEDDATA"))
	(setq ConnectString (strcat "Provider=MSDASQL;Driver={Microsoft Access Driver (*.mdb)};DBQ=" NameDbFile))
	
	(if EnameShape
		(progn
			(setq IdShape 				(GetIdShape EnameShape))
			(setq LstEnameInternalShape (GetEnameInternalShapeByDummyEnameSelect EnameShape))
	
			(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
	
			(if ConnectionObject
				(progn
					(DeteteRowDbase ConnectionObject tblName (nth 0 LstRowName) IdShape)
					(foreach itm LstEnameInternalShape
				
						(setq LstDxfCode (DxfCode->String itm))
						
						(if (not (nth 0 LstDxfCode)) (setq DxfDataN "-")  (setq DxfDataN (nth 0 LstDxfCode)))
						(if (not (nth 1 LstDxfCode)) (setq DxfDataE "-")  (setq DxfDataE (nth 1 LstDxfCode)))
							
						(setq LstValName (list IdShape DxfDataN DxfDataE))
						(WriteDbase 	ConnectionObject tblName LstRowName LstValName)
					)
					(ADOLISP_DisconnectFromDB ConnectionObject)
				)
			)
		)
	)
)
;
;
;
(defun WriteDataExternalShape (EnameShape / NameDbFile tblName LstRowName ConnectString 
											ConnectionObject IdShape LstDxfCode LstValName
											DxfDataN DxfDataE Rtn)


	(setq NameDbFile "C:\\EasyCut\\Test\\Dbase\\ExShape.mdb") ;access 2002-2003
	(setq tblName "EXTERNALSHAPE")
	(setq LstRowName (list "IDSHAPE" "SHAPEDATA" "EXTENDEDDATA"))
	(setq ConnectString (strcat "Provider=MSDASQL;Driver={Microsoft Access Driver (*.mdb)};DBQ=" NameDbFile))
	
	(if EnameShape
		(progn
			(setq IdShape (GetIdShape EnameShape))
			(setq LstDxfCode (DxfCode->String Enameshape))
	
			(if (not (nth 0 LstDxfCode)) (setq DxfDataN "-") (setq DxfDataN  (nth 0 LstDxfCode)))
			(if (not (nth 1 LstDxfCode)) (setq DxfDataE "-") (setq DxfDataE (nth 1 LstDxfCode)))
			(setq LstValName (list IdShape DxfDataN DxfDataE))
	
			(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
			(if ConnectionObject 
				(progn
					(DeteteRowDbase ConnectionObject tblName (nth 0 LstRowName) IdShape)
					(WriteDbase 	ConnectionObject tblName LstRowName LstValName) 
					(ADOLISP_DisconnectFromDB ConnectionObject)
				)
			)
		)
	)
	Rtn
)
;
;
;
;
;
; Connecting to the database ...
; 
;(setq ConnectString (strcat "Provider=MSDASQL;Driver={Microsoft Access Driver (*.mdb)};DBQ=" NameDbFile))
;(setq ConnectString (strcat "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" NameDbFile ";Persist Security Info=False"))
;(setq ConnectString (strcat "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" NameDbFile ";Persist Security Info=False"))
;(setq ConnectionObject	(ADOLISP_ConnectToDB ConnectString "admin" ""))
;(ADOLISP_DisconnectFromDB ConnectionObject)
;
;
; ->	(WriteDbase ConnectionObject tblName LstRowName LstValName)
(defun WriteDbase (ConnectionObject tblName LstRowName LstValName)

	(if (and ConnectionObject tblName LstRowName LstValName)
		(if (not (setq Rtn (ADOLISP_DoSQL ConnectionObject (SQLStatementInsert tblName LstRowName LstValName))))
			(setq Rtn -1) 		; Scrittura fallita
		)
	)
	Rtn
)
;
; ->	(ReadDbase ConnectionObject tblName "AUTOCAD_DRAWING" "ABCDEF00")
; ->	(ReadDbase ConnectionObject tblName "AUTOCAD_DRAWING" "*")
(defun ReadDbase (ConnectionObject tblName rowName valueName / Rtn SQLStatement)

	(if (and ConnectionObject tblName rowName valueName)
		(progn
			(if (= valueName "*")
				(setq SQLStatement (strcat "SELECT * FROM " tblName ";"))										;	"SELECT * FROM DESKS;"
				(setq SQLStatement (strcat "SELECT * FROM " tblName " WHERE " rowName " = '" valueName "'"))	;	"SELECT * FROM DESKS WHERE AUTOCAD_HANDLE = 'ABCDEF00'"
			)
			(if (not (setq Rtn (ADOLISP_DoSQL ConnectionObject SQLStatement)))
				(setq Rtn -1) 		; Lettura fallita
				(if (= (length Rtn) 1)
					(setq Rtn -2)	; Valore non trovato
				)
			)
		)
	)
	Rtn
)
;
;
; ->	(DeteteRowDbase ConnectionObject tblName "AUTOCAD_DRAWING" "TESTDRAWING")
(defun DeteteRowDbase (ConnectionObject tblName rowName valueName / Rtn)

	(if (and ConnectionObject tblName rowName valueName)
		(progn
			(setq SQLStatement (strcat "DELETE FROM " tblName " WHERE " rowName "='" valueName "'"))
			(if (not (setq Rtn (ADOLISP_DoSQL ConnectionObject SQLStatement)))
				(setq Rtn -1) 		; Cancellazione fallita
			)
		)
	)
	Rtn
)
;
;
;
(defun SQLStatementInsert (tblName LstRowName LstValName / Rtn conta)

	; "INSERT INTO DESKS (AUTOCAD_HANDLE, AUTOCAD_DRAWING, OCCUPANT, EXTENSION, PROPERTY_NUMBER) VALUES ('ABCDEF00', 'TESTDRAWING', 'Barbara', '123456', '654321')"
	
	(if (and tblName LstRowName LstValName)
		(progn
			(setq Rtn (strcat "INSERT INTO " tblName " ("))
			(setq conta 1)
			(foreach itm LstRowName
				(setq Rtn (strcat Rtn itm))
				(if (< conta (length LstRowName)) (setq Rtn (strcat Rtn ", ")))
				(setq conta (1+ conta))
			)
			(setq Rtn (strcat Rtn ")"))
			
			(setq Rtn (strcat Rtn " VALUES "))
			
			(setq conta 1)
			(setq Rtn (strcat Rtn "("))
			(foreach itm LstValName
				(setq Rtn (strcat Rtn "'" itm "'"))
				(if (< conta (length LstRowName)) (setq Rtn (strcat Rtn ", ")))
				(setq conta (1+ conta))
			)
			(setq Rtn (strcat Rtn ")"))
		)
	)
	Rtn
)
;
;
;
(defun ImportCode ()
	
	(setq NameDbShape "C:\\EasyCut\\Test\\Dbase\\EcShape.mdb") ;access 2000
	(setq tblName "SHAPE")
	(setq LstRowName (list "HANDLE" "ORDER" "PHASE" "MARK" "LISTDATA" "LISTEXTENDEDATA"))

	(setq ConnectString (strcat "Provider=MSDASQL;Driver={Microsoft Access Driver (*.mdb)};DBQ=" NameDbShape))	
	(ReadDbase ConnectionObject tblName "HANDLE" "*")
	(ADOLISP_DisconnectFromDB ConnectionObject)
)

;
;
;
(defun DxfCode->String (EnameShape / LstDxfCode LstDxfCodeExtended NumberDec itm RtnN RtnE)

	
	(if EnameShape
		(progn
			(setq LstDxfCode         			(entget EnameShape))
			(setq LstDxfCodeExtended (assoc -3 	(entget EnameShape (list "*"))))
			(setq NumberDec 8)
			;
			; normal data ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			(if LstDxfCode
				(progn
					(setq RtnN "(")
					(foreach itm LstDxfCode
						(princ itm) (princ "\n")
						(cond
							; -----------------------------------------------------------------
							((= (car itm) 0)	; type entity
								(setq RtnN (strcat RtnN "(0 . \"" (cdr itm) "\")")) 
							)
							((= (car itm) 8)	; layer
								(setq RtnN (strcat RtnN "(8 . \"" (cdr itm) "\")")) 
							)
							((= (car itm) 62)	; color
								(setq RtnN (strcat RtnN "(62 . " (LM:rtos (cdr itm) 2 0) ")"))
							)
							; ----------------------------------------------------------------
							((= (car itm) 90)	; Number of vertices 
								(setq RtnN (strcat RtnN "(90 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 70)	; Flag  default is 0 1 = Closed; 128 = Plinegen 
								(setq RtnN (strcat RtnN "(70 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 43)	; Constant width 
								(setq RtnN (strcat RtnN "(43 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 38)	; Elevation (optional; default = 0)
								(setq RtnN (strcat RtnN "(38 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 39)	; Thickness (optional; default = 0)
								(setq RtnN (strcat RtnN "(39 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 40)	; Starting width  (optional; default = 0)
								(setq RtnN (strcat RtnN "(40 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 41)	; End width  (optional; default = 0)
								(setq RtnN (strcat RtnN "(41 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 42)	; Bulge  (optional; default = 0)
								(setq RtnN (strcat RtnN "(42 . " (LM:rtos (cdr itm) 2 NumberDec) ")"))
							)
							((= (car itm) 10)	; Start
								(if (= (length itm) 4)
									(setq RtnN (strcat RtnN "(10 " 	(LM:rtos (car (cdr itm)) 2 NumberDec) " " 
																	(LM:rtos (cadr (cdr itm)) 2 NumberDec) " " 
																	(LM:rtos (caddr (cdr itm)) 2 NumberDec) ")")) 
								)
								(if (= (length itm) 3)
									(setq RtnN (strcat RtnN "(10 " 	(LM:rtos (car (cdr itm)) 2 NumberDec) " " 
																	(LM:rtos (cadr (cdr itm)) 2 NumberDec) ")")) 
								)
							)
							((= (car itm) 11)	; End
								(if (= (length itm) 4)
									(setq RtnN (strcat RtnN "(10 " 	(LM:rtos (car (cdr itm)) 2 NumberDec) " " 
																	(LM:rtos (cadr (cdr itm)) 2 NumberDec) " " 
																	(LM:rtos (caddr (cdr itm)) 2 NumberDec) ")")) 
								)
								(if (= (length itm) 3)
									(setq RtnN (strcat RtnN "(10 " 	(LM:rtos (car (cdr itm)) 2 NumberDec) " " 
																	(LM:rtos (cadr (cdr itm)) 2 NumberDec) ")")) 
								)
							)

							((= (car itm) 210)	; normal axis
								(setq RtnN (strcat RtnN "(210 " (LM:rtos (car (cdr itm)) 2 NumberDec) " " 
																(LM:rtos (cadr (cdr itm)) 2 NumberDec) " " 
																(LM:rtos (caddr (cdr itm)) 2 NumberDec) ")")) 
							)
						)
					)
					(setq RtnN (strcat RtnN ")"))
				)
			)
			;
			; extended Data  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;
			; (-3 ("PIATTO" (1002 . "{") (1000 . "CE") (1000 . "081264528") (1000 . "2") 
			; (1000 . "178-350") (1000 . "1") (1000 . "C872") (1000 . "300") (1000 . "S355J0") (1000 . "10") (1000 . "18/05/2019") (1000 . "8") (1002 . "}")))
			
			(if LstDxfCodeExtended
				(progn
					(setq RtnE (strcat "(-3 (\"" (nth 0 (nth 1 LstDxfCodeExtended)) "\" "))
					
					(foreach itm (cdr (nth 0 (cdr LstDxfCodeExtended)))
						(princ itm) (princ "\n")
						(setq RtnE (strcat RtnE "(" (LM:rtos (car itm) 2 0) ". \"" (cdr itm) "\")")) 
					)
					(setq RtnE (strcat RtnE ")"))
				)
			)
		)
	)
	;(ExportCode Rtn)
	(list RtnN RtnE)
)


;;; An example of using ADOLISP_Library.lsp

(if (not ADOLISP_ConnectToDB)
  (load "ADOLISP_Library.lsp")
)

(defun C:Example (/ ConnectionObject Result ConnectString SQLStatement
                  TablesList ColumnsList
                 )

  ;; Connecting to the database ...
  (setq ConnectString
         "Provider=MSDASQL;Driver={Microsoft Access Driver (*.mdb)};DBQ=C:\\EasyCut\\Test\\Dbase\\ADOLISP_test.mdb"
  )
  ;; An alternative connect string
  ;(setq ConnectString "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\\EasyCut\\Test\\Dbase\\ADOLISP_test.mdb;Persist Security Info=False")
  
  (prompt (strcat "\n\nConnecting to the database using \n\""
                  ConnectString
                  "\""
          )
  )
  (if (not (setq ConnectionObject
                  (ADOLISP_ConnectToDB ConnectString "admin" "")
           )
      )
    (progn
      (prompt "\nConnection failed!")
      (ADOLISP_ErrorPrinter)
    )
    (prompt "\nResult: succeeded!")
  )
  ;; If we got a connection ...
  (if ConnectionObject
    (progn

      ;; Retrieve some data
      (setq
        SQLStatement "SELECT * FROM DESKS WHERE OCCUPANT = 'Me'"
      )
	  
      (setq
        SQLStatement "SELECT * FROM DESKS WHERE AUTOCAD_HANDLE = 'ABCDEF00'"
      )
      (prompt
        (strcat
          "\n\nExecuting a SELECT statement to retrieve some data:\n\""
          SQLStatement
          "\""
        )
      )
      (if (setq Result (ADOLISP_DoSQL ConnectionObject SQLStatement))
        (progn
          (prompt "\nResult: ")
          (print Result)
        )
        (progn
          (prompt "\nFailed!")
          (ADOLISP_ErrorPrinter)
        )
      )

      ;; Insert a row
      (setq SQLStatement
             "INSERT INTO DESKS (AUTOCAD_HANDLE, AUTOCAD_DRAWING, OCCUPANT, EXTENSION, PROPERTY_NUMBER) VALUES ('ABCDEF00', 'TESTDRAWING', 'Barbara', '123456', '654321')"
      )
      (prompt (strcat "\n\nInserting a row:\n\""
                      SQLStatement
                      "\""
              )
      )
      (if (setq Result (ADOLISP_DoSQL ConnectionObject SQLStatement))
        (prompt "\nResult:\nSucceeded!")
        (progn
          (prompt "\nFailed!")
          (ADOLISP_ErrorPrinter)
        )
      )

      ;; Change a row or rows
      (setq SQLStatement
             "UPDATE DESKS SET OCCUPANT='Me' WHERE AUTOCAD_DRAWING='TESTDRAWING'"
      )
      (prompt (strcat "\n\nChanging a row or rows:\n\""
                      SQLStatement
                      "\""
              )
      )
      (if (setq Result (ADOLISP_DoSQL ConnectionObject SQLStatement))
        (prompt "\nResult:\nSucceeded!")
        (progn
          (prompt "\nFailed!")
          (ADOLISP_ErrorPrinter)
        )
      )

      ;; Delete a row or rows
      (setq SQLStatement
             "DELETE FROM DESKS WHERE AUTOCAD_DRAWING='TESTDRAWING'"
      )
      (prompt (strcat "\n\nDeleting a row or rows:\n\""
                      SQLStatement
                      "\""
              )
      )
      (if (setq Result (ADOLISP_DoSQL ConnectionObject SQLStatement))
        (prompt "\nResult:\nSucceeded!")
        (progn
          (prompt "\nFailed!")
          (ADOLISP_ErrorPrinter)
        )
      )

      ;; Just for grins, see what's in the database
      (prompt "\n\nTables and views in the database:")
      (setq TablesList (ADOLISP_GetTablesAndViews ConnectionObject))
      (print (ADOLISP_GetTablesAndViews ConnectionObject))
      (prompt (strcat "\n\nColumn properties in table "
                      (caar TablesList)
                      ":"
              )
      )
      (setq ColumnsList
             (ADOLISP_GetColumns
               ConnectionObject
               (caar TablesList)
             )
      )
      (foreach Item ColumnsList
        (print Item)
      )

      ;; Disconnect
      (prompt "\n\nDisconnecting from the database\n")
      (ADOLISP_DisconnectFromDB ConnectionObject)
      ;; Although the following is unnecessary in this case (because
      ;; ConnectionObject is a local variable), it's never a _bad_
      ;; idea to NIL-out the connection object.
      (setq ConnectionObject nil)
    )
  )
  (prin1)
)

(prin1)