
; Start Load Application                                                             ; EasyCut
; Build 12-08-2026 16-34                                                          ; EasyCut
; Version EasyCut 4.0.0                                               ; EasyCut
(defun SearchAndAddTrsPth (AddPath / TrsPth)                                         ; EasyCut
    (if AddPath                                                                      ; EasyCut
        (if (findfile AddPath)                                                       ; EasyCut
            (progn                                                                   ; EasyCut
                (if (setq TrsPth (getvar 'trustedpaths))                             ; EasyCut
                    (if (not (vl-string-search (strcase AddPath) (strcase TrsPth)))  ; EasyCut
                        (progn                                                       ; EasyCut
                            (setq TrsPth (vl-string-left-trim " " TrsPth))           ; EasyCut
                            (setq TrsPth (vl-string-right-trim  " " TrsPth))         ; EasyCut
                            (cond                                                    ; EasyCut
                                ((or (= TrsPth ".") (= TrsPth ""))                   ; EasyCut
                                  (setq TrsPth AddPath)                              ; EasyCut
                                )                                                    ; EasyCut
                                (t                                                   ; EasyCut
                                  (setq TrsPth (strcat TrsPth ";" AddPath))          ; EasyCut
                                )                                                    ; EasyCut
                            )                                                        ; EasyCut
                            (setvar 'trustedpaths TrsPth)                            ; EasyCut
                        )                                                            ; EasyCut
                    )                                                                ; EasyCut
                )                                                                    ; EasyCut
            )                                                                        ; EasyCut
        )                                                                            ; EasyCut
    )                                                                                ; EasyCut
)                                                                                    ; EasyCut
(SearchAndAddTrsPth  "C:\\EasyCutNesting Beta...")									             ; EasyCut
(if (not EasyCutRegistryPath$) (load  "C:\\EasyCutNesting Beta\\Load\\StartEasyCut.lsp" ""))  			             ; EasyCut
; End Load Application                                                               ; EasyCut
