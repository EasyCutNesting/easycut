```lisp
(vl-load-com)

;;; ================================================================
;;;              VLISP ASCII VIEWER - TEST 1
;;; ================================================================
;;;
;;; Un solo file HTML
;;; Nessun iframe
;;; Nessun PowerShell
;;;
;;; COMANDO:
;;;     ASCII
;;;
;;; ================================================================


(defun ASCII:GetTempFolder ()

  (getenv "TEMP")
)


;;; ================================================================
;;; FILE HTML UNICO
;;; ================================================================

(defun ASCII:GetViewerFile ()

  (strcat
    (ASCII:GetTempFolder)
    "\\VLISP_ASCII_VIEWER.html"
  )
)


;;; ================================================================
;;; ESCAPE HTML
;;; ================================================================

(defun ASCII:HtmlEscape (s)

  (if
    (null s)
    (setq s "")
  )

  (setq s
    (vl-string-subst
      "&amp;"
      "&"
      s
    )
  )

  (setq s
    (vl-string-subst
      "&lt;"
      "<"
      s
    )
  )

  (setq s
    (vl-string-subst
      "&gt;"
      ">"
      s
    )
  )

  (setq s
    (vl-string-subst
      "&quot;"
      "\""
      s
    )
  )

  s
)


;;; ================================================================
;;; CREA HTML
;;; ================================================================

(defun ASCII:CreateHTML
       (filename / f line fin)

  (setq f
    (open
      (ASCII:GetViewerFile)
      "w"
    )
  )

  (if
    (null f)

    (progn

      (princ
        "\nERRORE: impossibile creare il file HTML."
      )

      nil
    )

    (progn

      ;; ==========================================================
      ;; DOCTYPE
      ;; ==========================================================

      (write-line
        "<!DOCTYPE html>"
        f
      )

      (write-line
        "<html lang=\"it\">"
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
        "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">"
        f
      )

      (write-line
        "<title>VLISP ASCII VIEWER</title>"
        f
      )


      ;; ==========================================================
      ;; STILE
      ;; ==========================================================

      (write-line
        "<style>"
        f
      )

      (write-line
        "*{box-sizing:border-box;}"
        f
      )

      (write-line
        "html,body{margin:0;padding:0;width:100%;height:100%;background:#17191c;color:#e5e9ed;}"
        f
      )

      (write-line
        "body{font-family:Segoe UI,Arial,sans-serif;overflow:hidden;}"
        f
      )

      (write-line
        ".viewer{height:100vh;width:100%;display:flex;flex-direction:column;}"
        f
      )

      ;; ----------------------------------------------------------
      ;; DIV SUPERIORE
      ;; ----------------------------------------------------------

      (write-line
        ".filebox{height:82px;min-height:82px;background:#252a30;border-bottom:1px solid #414850;padding:13px 20px;}"
        f
      )

      (write-line
        ".label{font-size:10px;font-weight:700;letter-spacing:1.5px;color:#78a9d5;text-transform:uppercase;margin-bottom:7px;}"
        f
      )

      (write-line
        ".filename{font-family:Consolas,'Courier New',monospace;font-size:13px;color:#f1f3f5;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}"
        f
      )

      ;; ----------------------------------------------------------
      ;; DIV CONTENUTO
      ;; ----------------------------------------------------------

      (write-line
        ".contentbox{flex:1;min-height:0;padding:16px 20px 20px 20px;}"
        f
      )

      (write-line
        ".content{width:100%;height:100%;overflow:auto;background:#0f1113;border:1px solid #3b4249;border-radius:7px;padding:18px;box-shadow:0 4px 16px rgba(0,0,0,.35);}"
        f
      )

      (write-line
        "pre{margin:0;font-family:Consolas,'Courier New',monospace;font-size:13px;line-height:1.5;color:#dce2e7;white-space:pre;}"
        f
      )

      ;; ----------------------------------------------------------
      ;; SCROLLBAR
      ;; ----------------------------------------------------------

      (write-line
        "::-webkit-scrollbar{width:10px;height:10px;}"
        f
      )

      (write-line
        "::-webkit-scrollbar-track{background:#181b1f;}"
        f
      )

      (write-line
        "::-webkit-scrollbar-thumb{background:#464e56;border-radius:5px;}"
        f
      )

      (write-line
        "::-webkit-scrollbar-thumb:hover{background:#59636d;}"
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


      ;; ==========================================================
      ;; BODY
      ;; ==========================================================

      (write-line
        "<body>"
        f
      )

      (write-line
        "<div class=\"viewer\">"
        f
      )


      ;; ==========================================================
      ;; DIV 1 - NOME FILE
      ;; ==========================================================

      (write-line
        "<div class=\"filebox\">"
        f
      )

      (write-line
        "<div class=\"label\">FILE ASCII</div>"
        f
      )

      (write-line
        "<div class=\"filename\">"
        f
      )

      (write-line
        (ASCII:HtmlEscape filename)
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


      ;; ==========================================================
      ;; DIV 2 - CONTENUTO
      ;; ==========================================================

      (write-line
        "<div class=\"contentbox\">"
        f
      )

      (write-line
        "<div class=\"content\">"
        f
      )

      (write-line
        "<pre>"
        f
      )


      ;; ==========================================================
      ;; LEGGE FILE ASCII
      ;; ==========================================================

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
              (ASCII:HtmlEscape line)
              f
            )
          )

          (close fin)
        )

        (write-line
          "ERRORE: impossibile aprire il file ASCII."
          f
        )
      )


      ;; ==========================================================
      ;; CHIUSURA DIV
      ;; ==========================================================

      (write-line
        "</pre>"
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
        "</div>"
        f
      )

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

  ;; ---------------------------------------------------------------
  ;; Richiesta nome file
  ;; ---------------------------------------------------------------

  (setq nome
    (getstring
      T
      "\nInserisci nome/percorso del file ASCII: "
    )
  )

  (if
    (= nome "")

    (princ
      "\nOperazione annullata."
    )

    (progn

      ;; -----------------------------------------------------------
      ;; Cerca il file
      ;; -----------------------------------------------------------

      (setq file
        (findfile nome)
      )

      (if
        (null file)

        (princ
          (strcat
            "\nFile non trovato: "
            nome
          )
        )

        (progn

          ;; -------------------------------------------------------
          ;; Crea HTML
          ;; -------------------------------------------------------

          (if
            (ASCII:CreateHTML file)

            (progn

              ;; ---------------------------------------------------
              ;; URL
              ;; ---------------------------------------------------

              (setq url
                (strcat
                  "file:///"
                  (vl-string-subst
                    "/"
                    "\\"
                    (ASCII:GetViewerFile)
                  )
                )
              )

              ;; ---------------------------------------------------
              ;; BROWSER AutoCAD
              ;; ---------------------------------------------------

              (command
                "_.BROWSER"
                url
              )

              (princ
                (strcat
                  "\nVisualizzato: "
                  file
                )
              )
            )
          )
        )
      )
    )
  )

  (princ)
)


;;; ================================================================
;;; PULIZIA
;;; ================================================================

(defun c:ASCII:CLEARCACHE
       (/ file)

  (setq file
    (ASCII:GetViewerFile)
  )

  (if
    (findfile file)

    (vl-file-delete file)
  )

  (princ
    "\nFile temporaneo del viewer eliminato."
  )

  (princ)
)


;;; ================================================================
;;; MESSAGGIO CARICAMENTO
;;; ================================================================

(princ
  "\nVLISP ASCII VIEWER - TEST 1 caricato."
)

(princ
  "\nComando: ASCII"
)

(princ)
```
