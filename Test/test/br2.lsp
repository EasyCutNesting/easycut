```lisp
(vl-load-com)

;;; ================================================================
;;;       VLISP ASCII VIEWER - TEST LETTURA FILE LOCALE
;;; ================================================================

(setq *ASCII-TEST-OPEN* nil)


;;; ================================================================
;;; FILE VIEWER
;;; ================================================================

(defun ASCII:TestViewerFile ()

  (strcat
    (getenv "TEMP")
    "\\VLISP_ASCII_TEST_VIEWER.html"
  )
)


;;; ================================================================
;;; FILE DATI
;;; ================================================================

(defun ASCII:TestDataFile ()

  (strcat
    (getenv "TEMP")
    "\\VLISP_ASCII_TEST_DATA.txt"
  )
)


;;; ================================================================
;;; ESCAPE HTML
;;; ================================================================

(defun ASCII:TestEscape (s)

  (if
    (null s)
    (setq s "")
  )

  (setq s
    (vl-string-subst "&amp;" "&" s)
  )

  (setq s
    (vl-string-subst "&lt;" "<" s)
  )

  (setq s
    (vl-string-subst "&gt;" ">" s)
  )

  s
)


;;; ================================================================
;;; CREA FILE DATI
;;; ================================================================

(defun ASCII:TestCreateData
       (filename / f fin line)

  (setq f
    (open
      (ASCII:TestDataFile)
      "w"
    )
  )

  (if
    (null f)

    nil

    (progn

      (setq fin
        (open
          filename
          "r"
        )
      )

      (if
        fin

        (progn

          (while
            (setq line
              (read-line fin)
            )

            (write-line
              line
              f
            )
          )

          (close fin)
        )

        (write-line
          "ERRORE LETTURA FILE"
          f
        )
      )

      (close f)

      T
    )
  )
)


;;; ================================================================
;;; CREA VIEWER
;;; ================================================================

(defun ASCII:TestCreateViewer
       (filename / f dataurl)

  (setq f
    (open
      (ASCII:TestViewerFile)
      "w"
    )
  )

  (if
    (null f)

    nil

    (progn

      ;; ------------------------------------------------------------
      ;; URL DEL FILE DATI
      ;; ------------------------------------------------------------

      (setq dataurl
        (strcat
          "file:///"
          (vl-string-subst
            "/"
            "\\"
            (ASCII:TestDataFile)
          )
        )
      )


      ;; ------------------------------------------------------------
      ;; HTML
      ;; ------------------------------------------------------------

      (write-line
        "<!DOCTYPE html>"
        f
      )

      (write-line
        "<html>"
        f
      )

      (write-line
        "<head>"
        f
      )

      (write-line
        "<meta charset=\"UTF-8\">"
        f
      )

      (write-line
        "<title>VLISP ASCII TEST</title>"
        f
      )

      ;; ------------------------------------------------------------
      ;; CSS
      ;; ------------------------------------------------------------

      (write-line
        "<style>"
        f
      )

      (write-line
        "html,body{margin:0;width:100%;height:100%;background:#17191c;color:#e5e9ed;font-family:Segoe UI,Arial;}"
        f
      )

      (write-line
        ".viewer{height:100%;display:flex;flex-direction:column;}"
        f
      )

      (write-line
        ".header{height:80px;background:#252a30;border-bottom:1px solid #414850;padding:14px 20px;}"
        f
      )

      (write-line
        ".label{font-size:10px;color:#78a9d5;font-weight:bold;letter-spacing:1.5px;}"
        f
      )

      (write-line
        ".filename{font-family:Consolas,monospace;font-size:13px;margin-top:8px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}"
        f
      )

      (write-line
        ".content{flex:1;padding:16px 20px 20px;min-height:0;}"
        f
      )

      (write-line
        "pre{height:100%;margin:0;padding:18px;overflow:auto;background:#0f1113;border:1px solid #3b4249;border-radius:7px;font-family:Consolas,'Courier New',monospace;font-size:13px;line-height:1.5;white-space:pre;color:#dce2e7;}"
        f
      )

      (write-line
        "</style>"
        f
      )

      (write-line
        "</head>"
        f
      )


      ;; ------------------------------------------------------------
      ;; BODY
      ;; ------------------------------------------------------------

      (write-line
        "<body>"
        f
      )

      (write-line
        "<div class=\"viewer\">"
        f
      )

      (write-line
        "<div class=\"header\">"
        f
      )

      (write-line
        "<div class=\"label\">FILE ASCII - TEST</div>"
        f
      )

      (write-line
        "<div class=\"filename\">"
        f
      )

      (write-line
        (ASCII:TestEscape filename)
        f
      )

      (write-line
        "</div>"
        f
      )

      (write-line
        "</div>"
        f
      )

      (write-line
        "<div class=\"content\">"
        f
      )

      (write-line
        "<pre id=\"contenuto\">Caricamento...</pre>"
        f
      )

      (write-line
        "</div>"
        f
      )

      (write-line
        "</div>"
        f
      )


      ;; ============================================================
      ;; JAVASCRIPT
      ;; ============================================================

      (write-line
        "<script>"
        f
      )

      ;; ------------------------------------------------------------
      ;; URL
      ;; ------------------------------------------------------------

      (write-line
        (strcat
          "const dataFile='"
          dataurl
          "';"
        )
        f
      )

      ;; ------------------------------------------------------------
      ;; LETTURA
      ;; ------------------------------------------------------------

      (write-line
        "function leggiFile(){"
        f
      )

      (write-line
        "fetch(dataFile+'?v='+Date.now())"
        f
      )

      (write-line
        ".then(r=>{if(!r.ok)throw new Error('HTTP '+r.status);return r.text();})"
        f
      )

      (write-line
        ".then(t=>{document.getElementById('contenuto').textContent=t;})"
        f
      )

      (write-line
        ".catch(e=>{document.getElementById('contenuto').textContent='ERRORE LETTURA FILE LOCALE:\\n'+e;});"
        f
      )

      (write-line
        "}"
        f
      )

      ;; ------------------------------------------------------------
      ;; PRIMA LETTURA
      ;; ------------------------------------------------------------

      (write-line
        "leggiFile();"
        f
      )

      ;; ------------------------------------------------------------
      ;; CONTROLLO OGNI SECONDO
      ;; ------------------------------------------------------------

      (write-line
        "setInterval(leggiFile,1000);"
        f
      )

      (write-line
        "</script>"
        f
      )

      ;; ------------------------------------------------------------
      ;; FINE
      ;; ------------------------------------------------------------

      (write-line
        "</body>"
        f
      )

      (write-line
        "</html>"
        f
      )

      (close f)

      T
    )
  )
)


;;; ================================================================
;;; COMANDO ASCII
;;; ================================================================

(defun c:ASCII
       (/ nome file url)

  (setq nome
    (getstring
      T
      "\nInserisci nome/percorso del file ASCII: "
    )
  )

  (if
    (/= nome "")

    (progn

      (setq file
        (findfile nome)
      )

      (if
        file

        (progn

          ;; --------------------------------------------------------
          ;; Aggiorna FILE DATI
          ;; --------------------------------------------------------

          (ASCII:TestCreateData file)

          ;; --------------------------------------------------------
          ;; Prima apertura
          ;; --------------------------------------------------------

          (if
            (not *ASCII-TEST-OPEN*)

            (progn

              (ASCII:TestCreateViewer file)

              (setq url
                (strcat
                  "file:///"
                  (vl-string-subst
                    "/"
                    "\\"
                    (ASCII:TestViewerFile)
                  )
                  "?v="
                  (itoa (getvar "MILLISECS"))
                )
              )

              (command
                "_.BROWSER"
                url
              )

              (setq
                *ASCII-TEST-OPEN*
                T
              )

              (princ
                "\nViewer TEST aperto."
              )
            )

            (princ
              "\nFile dati aggiornato. NON viene richiamato BROWSER."
            )
          )
        )

        (princ
          "\nFile non trovato."
        )
      )
    )
  )

  (princ)
)


;;; ================================================================
;;; RESET TEST
;;; ================================================================

(defun c:ASCII:TESTRESET
       (/ f)

  (setq f
    (ASCII:TestViewerFile)
  )

  (if
    (findfile f)
    (vl-file-delete f)
  )

  (setq f
    (ASCII:TestDataFile)
  )

  (if
    (findfile f)
    (vl-file-delete f)
  )

  (setq
    *ASCII-TEST-OPEN*
    nil
  )

  (princ
    "\nTest resettato."
  )

  (princ)
)


(princ
  "\nVLISP ASCII TEST caricato."
)

(princ
  "\nComandi: ASCII / ASCII:TESTRESET"
)

(princ)
```
