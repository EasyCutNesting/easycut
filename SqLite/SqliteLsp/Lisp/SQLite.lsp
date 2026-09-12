;DSQL_OPEN
;DSQL_CLOSE
;DSQL_CLOSEALL
;DSQL_QUERY
;DSQL_ASSOCQUERY
;DSQL_DML
;DSQL_SCALAR
;DSQL_SCALAR
;DSQL_CMPSTMT
;DSQL_STMTBIND
;DSQL_STMTFNL
;DSQL_VER
;DSQL_SQLITEVER
;DSQL_PRINTF
;DSQL_GETFORMAT
;DSQL_PRINTFX
;DSQL_GETFORMATX
;DSQL_LOADEXT
;DSQL_LASTERR
;DSQL_DUMPERR
;DSQL_KEYWORDS


(DEFUN CHKERR (CMD)
  (IF (NOT CMD)
    (PROGN
      (PRINC (DSQL_LASTERR))
      NIL
    )
   T
  )
)


(SETQ MYDB "C:\\Users\\Dan\\Documents\\test.db")

(DEFUN CREATEDATABSE ()
  (CHKERR (DSQL_OPEN MYDB))
  (CHKERR (DSQL_CLOSE MYDB))
)

(DEFUN C:EnableKeys ( / a db)
  (SETQ DB MYDB)
  (CHKERR (DSQL_OPEN DB))
  (DSQL_QUERY DB "PRAGMA foreign_keys = ON;")
  (SETQ A (DSQL_QUERY DB "PRAGMA foreign_keys;"))
  (CHKERR (DSQL_CLOSE DB))
  A
)

;;; CREATE A NEW TABLE
(DEFUN C:CREATETABLE ( / db)
  (SETQ DB MYDB)
  (CHKERR (DSQL_OPEN DB))
  (CHKERR (DSQL_DML DB "CREATE TABLE MyTable (No int, FirstName char(64), LastName char(64), age int);"))
  (CHKERR (DSQL_CLOSE DB))
)

;;; INSERT DATA
(DEFUN C:ADDSTUFF (/ DB)
  (SETQ DB MYDB)
  (CHKERR (DSQL_OPEN DB))
  (CHKERR (DSQL_DML DB "INSERT INTO MyTable VALUES (1, 'Donald', 'Luck ' , 99);"))
  (CHKERR (DSQL_DML DB "INSERT INTO MyTable VALUES (2, 'Mickey', 'Mouse' , 101);"))
  (CHKERR (DSQL_DML DB "INSERT INTO MyTable VALUES (3, 'Minni' , 'Mouse' , 29);"))
  (CHKERR (DSQL_CLOSE DB))
)

;;; CREATE A TABLE JSON
(DEFUN C:CREATETABLEJ ( / db)
  (SETQ DB MYDB)
  (CHKERR (DSQL_OPEN DB))
  (CHKERR (DSQL_DML DB "CREATE TABLE user (name, phone);"))
  (CHKERR (DSQL_CLOSE DB))
)

;;; INSERT DATA JSON
(DEFUN C:ADDSTUFFJ (/ DB)
  (SETQ DB MYDB)
  (CHKERR (DSQL_OPEN DB))
  (CHKERR (DSQL_DML DB "insert into user (name, phone) values('jenny', json('{\"cell\":\"+491765\", \"home\":\"704-8675309\"}'))"))
  (CHKERR (DSQL_DML DB "insert into user (name, phone) values('oz', json('{\"cell\":\"+491765\", \"home\":\"704-498973\"}'))"))
  (CHKERR (DSQL_DML DB "insert into user (name, phone) values('mick', json('{\"cell\":\"+591765\", \"home\": \"705-598973\"}'))"))
  (CHKERR (DSQL_DML DB "insert into user (name, phone) values('dude', json('{\"cell\":\"+691765\", \"home\":\"704-698973\"}'))"))
  (CHKERR (DSQL_DML DB "insert into user (name, phone) values('sally', json('{\"cell\":\"+591765\", \"home\": \"705-578973\"}'))"))
  (CHKERR (DSQL_DML DB "insert into user (name, phone) values('vicky', json('{\"cell\":\"+691765\", \"home\":\"704-698973\"}'))"))
  (CHKERR (DSQL_CLOSE DB))
)

;;; GET DATA JSON
(DEFUN C:GETMEJ ( / db)
  (SETQ DB MYDB)
  (CHKERR (DSQL_OPEN DB))
  (SETQ A (DSQL_QUERY DB "SELECT user.name FROM user, json_each(user.phone) WHERE json_each.value LIKE '704-%';"))
  (CHKERR (DSQL_CLOSE DB))
  A
)

;;(("name") ("jenny") ("oz") ("dude") ("vicky"))

;;; get data, note all queries are returned in the format
;;; ((col1 name col2 name col3 name)(data1 data2 data3)....)
;;; exeptions are return as
;;; (nil . error message)
(DEFUN C:GETME ( / db)
  (SETQ DB MYDB)
  (CHKERR (DSQL_OPEN DB))
  (SETQ A (DSQL_QUERY DB "SELECT * FROM MyTable;"))
  (CHKERR (DSQL_CLOSE DB))
  A
)

(DEFUN C:GETME2 ( / a db)
  (SETQ DB MYDB)
  (CHKERR (DSQL_OPEN DB))
  (setq a(DSQL_ASSOCQUERY DB "SELECT * FROM MyTable WHERE age=%d;" 101))
  (CHKERR (DSQL_CLOSE DB))
  A
)

(DEFUN C:testME ( / a db)
  (SETQ DB MYDB)
  (CHKERR (DSQL_OPEN DB))
  (SETQ A (DSQL_QUERY DB "select AVG(age) from MyTable;"))
  (CHKERR (DSQL_CLOSE DB))
  A
)


(DEFUN C:GETMEA ( / a db)
  (SETQ DB MYDB)
  (CHKERR (DSQL_OPEN DB))
  (SETQ A (DSQL_ASSOCQUERY DB "SELECT * FROM MyTable;"))
  (CHKERR (DSQL_CLOSE DB))
  A
)

;;; update a record,
(DEFUN C:CHANGEME ( / db)
  (SETQ DB MYDB)
  (CHKERR(DSQL_OPEN DB))
  (CHKERR(DSQL_DML DB "UPDATE MyTable SET LastName='Duck' WHERE No=1;"))
  (CHKERR(DSQL_CLOSE DB))
)
;;; run getme to see the changes

;;; A compiled statement example
(DEFUN C:COMPILESTMT ( / db i)
  (SETQ I 0)  
  (SETQ DB MYDB)
  
  ; CREATE A NEW DB
  (CHKERR(DSQL_OPEN DB))  
  
  ; MAKE A NEW TABLE
  (CHKERR(DSQL_DML DB "create table Test2(No int, Num1 int, Num2 float, Name char(64));")) 
  
  ; START A TRANSACTION
  (CHKERR(DSQL_DML DB "begin transaction;"))
  
  ; this is our compiled statement, we will bind data to ?
  (CHKERR(DSQL_CMPSTMT DB "insert into Test2 values (?, ?, ?, ?);"))
  
  ; ADD OUR VALUES
  (REPEAT 100
    (CHKERR(DSQL_STMTBIND (SETQ I (1+ I)) 87 12.012 "HelloWorld"))
  )  
  
  ; COMMIT THE TRANSACTION
  (CHKERR(DSQL_DML DB "commit transaction;"))
  
  ; We must call this to clear the compiled statement 
  ; and finalize the transaction
  (CHKERR(DSQL_STMTFNL))
  
  ; CLOSE THE DB
  (CHKERR(DSQL_CLOSE DB))
)

;;; check our data



;Progecad 2.000, 

;;; lets run a performance test, create a table and insert 10,000 records
(DEFUN C:BENCH1 ( / db end i start)
  (SETQ I 0)
  (SETVAR "cmdecho" 0)
  (SETQ START (GETVAR "TDUSRTIMER"))
  
  (SETQ DB MYDB)
  (CHKERR(DSQL_OPEN DB))
  (CHKERR(DSQL_DML DB "create table Test1(No int, Name char(64));"))
  (CHKERR(DSQL_DML DB "begin transaction;"))
  (REPEAT 1000
     (CHKERR(DSQL_DML DB 
        (STRCAT "insert into Test1 values (" 
           (ITOA (SETQ I (1+ I))) ", 'Welcome To TheSwamp');")))
  )
  (CHKERR (DSQL_DML  DB "commit transaction;"))
  (CHKERR (DSQL_CLOSE  DB))
  
  (SETQ END (* 86400.0 (- (GETVAR "TDUSRTIMER") START)))
  (PRINC "\n")
  (PRINC END)
  (PRINC)
)
;;; autocad = 1.515 , bricscad = 0.967969 seconds on my old paint

;1.00000
(DEFUN C:BENCH2 ( / db end i pi start)
  (SETQ I 0)
  (SETVAR "cmdecho" 0)
  (SETQ START (GETVAR "TDUSRTIMER"))
  
  (SETQ DB MYDB)
  (CHKERR(DSQL_OPEN DB))
  (CHKERR(DSQL_DML DB "create table Test3(No int, Num1 int, Num2 int, Num3 float);"))
  (CHKERR(DSQL_CMPSTMT DB "insert into Test3 values (?, ?, ?, ?);"))
  (CHKERR(DSQL_DML DB "begin transaction;"))
  (REPEAT 10000
     (CHKERR(DSQL_STMTBIND (SETQ I (1+ I)) 87 12 3.13))
  )
  (CHKERR (DSQL_DML DB "commit transaction;"))
  (DSQL_STMTFNL)
  (CHKERR (DSQL_CLOSE DB))
  
  (SETQ END (* 86400.0 (- (GETVAR "TDUSRTIMER") START)))
  (PRINC "\n")
  (PRINC END)
  (PRINC)
)


(DEFUN C:BENCH3 ( / db end i pi start)
  (SETQ I 0)
  (SETVAR "cmdecho" 0)
  (SETQ START (GETVAR "TDUSRTIMER"))
  
  (SETQ DB MYDB)
  (CHKERR(DSQL_OPEN DB))
  
  (REPEAT 100
    (setq q(DSQL_QUERY MYDB "SELECT * FROM Test3;"))
  )
  (CHKERR (DSQL_CLOSE DB))
  
  (SETQ END (* 86400.0 (- (GETVAR "TDUSRTIMER") START)))
  (PRINC "\n")
  (PRINC END)
  (PRINC)
)


;;; autocad = 1.703 seconds on my old paint
(DEFUN C:BENCH4 ( / db end i start)
  (SETQ I 0)
  (SETVAR "cmdecho" 0)
  (SETQ START (GETVAR "TDUSRTIMER"))
  
  (SETQ DB MYDB)
  (CHKERR(DSQL_OPEN DB))
  (CHKERR(DSQL_DML DB "create table Test4(No int, Num float ,Name char(64));"))
  (CHKERR(DSQL_DML DB "begin transaction;"))
  (REPEAT 10000
     (CHKERR(DSQL_DML MYDB "insert into Test4 values (%d, %.15g, '%s');" (SETQ I (1+ I))  3.14159 "Welcome to the Swamp"))
  )
  (CHKERR (DSQL_DML DB "commit transaction;"))
  (CHKERR (DSQL_CLOSE DB))
  
  (SETQ END (* 86400.0 (- (GETVAR "TDUSRTIMER") START)))
  (PRINC "\n")
  (PRINC END)
  (PRINC)
)


;(DSQL_PRINTF "-%X-" 16777215)
;(DSQL_GETFORMAT (ENTGET(CAR(ENTSEL))))
;(DSQL_PRINTF "(%ld)(%s)(%ld)(%s)(%s)(%d)(%s)(%s)(%s)(%.15g,%.15g,%.15g)(%.15g,%.15g,%.15g)(%.15g,%.15g,%.15g)" (ENTGET(CAR(ENTSEL))))
;(DSQL_GETFORMATX (ENTGET(CAR(ENTSEL))))
;(DSQL_PRINTFX (strcat "(%d,%ld)(%d,%s)(%d,%ld)(%d,%s)(%d,%s)(%d,%d)(%d,%s)(%d,%s)(%d,%s)(%d,%.15g,%.15"
;                      "g,%.15g)(%d,%.15g,%.15g,%.15g)(%d,%.15g,%.15g,%.15g)") (ENTGET(CAR(ENTSEL))))
;(DSQL_DML "C:\\Users\\Daniel\\Documents\\mysqlite.db" "insert into Test4 values (%d, %.15g, '%s');" 9  3.14159 "Welcome to the Swamp")
;(DSQL_PRINTF "insert into Test4 values (%d, %.15g, '%s');" 1  3.14159 "Welcome to the Swamp")
;(DSQL_GETFORMAT (ENTGET(CAR(ENTSEL))))
;(DSQL_PRINTFX "insert into Test4 values (%d, %.15g, '%s');" 1  3.14159 "Welcome to the Swamp")
;(DSQL_GETFORMATX (ENTGET(CAR(ENTSEL))))
;(DSQL_PRINTF "%s %s" T nil)
(DSQL_PRINTF "insert into Test4 values (%d, %.15g, '%s');" 8  3.14159 "Welcome to the Swamp")
;(DSQL_OPEN  "C:\\Users\\Daniel\\Documents\\mysqlite.db")
;(CHKERR(DSQL_DML "C:\\Users\\Daniel\\Documents\\mysqlite.db" "create table 5(No int, Num1 int, Num2 int, Num3 float);"))
;(DSQL_CLOSE "C:\\Users\\Daniel\\Documents\\mysqlite.db")

;//Inconsistency detected by ld.so: dl-close.c: 743: _dl_close: Assertion `map->l_init_called' failed!

;//http://people.mozilla.com/~chofmann/l10n/tree/mozilla/db/sqlite3/sqlite-fix-non-unicode-win.patch



