(vl-load-com)

(defun c:TESTNAV2
       (/ sh url)

  (setq url
    (strcat
      "file:///"
      (vl-string-subst
        "/"
        "\\"
        (strcat
          (getenv "TEMP")
          "\\VLISP_ASCII_VIEWER.html"
        )
      )
      "?test="
      (itoa (getvar "MILLISECS"))
    )
  )

  (setq sh
    (vl-catch-all-apply
      'vlax-create-object
      (list "WScript.Shell")
    )
  )

  (if
    (vl-catch-all-error-p sh)

    (princ
      "\nERRORE WScript.Shell."
    )

    (progn

      ;; -----------------------------------------------------------
      ;; ALT+TAB
      ;; -----------------------------------------------------------

      (vl-catch-all-apply
        'vlax-invoke-method
        (list
          sh
          'SendKeys
          "%{TAB}"
        )
      )

      ;; -----------------------------------------------------------
      ;; CTRL+L
      ;; -----------------------------------------------------------

      (vl-catch-all-apply
        'vlax-invoke-method
        (list
          sh
          'SendKeys
          "^l"
        )
      )

      ;; -----------------------------------------------------------
      ;; URL
      ;; -----------------------------------------------------------

      (vl-catch-all-apply
        'vlax-invoke-method
        (list
          sh
          'SendKeys
          url
        )
      )

      ;; -----------------------------------------------------------
      ;; INVIO
      ;; -----------------------------------------------------------

      (vl-catch-all-apply
        'vlax-invoke-method
        (list
          sh
          'SendKeys
          "~"
        )
      )

      (vlax-release-object sh)

      (princ
        "\nTESTNAV2 completato."
      )
    )
  )

  (princ)
)