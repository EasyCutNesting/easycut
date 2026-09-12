
;;; An example of using ADOLISP_Library.lsp

(if (not ADOLISP_ConnectToDB)
  (load "ADOLISP_Library.lsp")
)

(defun C:Example (/ ConnectionObject Result ConnectString SQLStatement
                  TablesList ColumnsList
                 )

  ;; Connecting to the database ...
  (setq ConnectString
         "Provider=MSDASQL;Driver={Microsoft Access Driver (*.mdb)};DBQ=C:\\EasyCut\\Test\\DataBase\\ADOLISP_test.mdb"
  )
  ;; An alternative connect string
  (setq ConnectString 
		"Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\\EasyCut\\Test\\DataBase\\ADOLISP_test.mdb;Persist Security Info=False")
  
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
        SQLStatement "SELECT * FROM DESKS WHERE AUTOCAD_HANDLE = '2A'"
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