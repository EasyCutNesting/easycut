
; Start Load Application                                                             ; EasyCut
; Build 13-09-2026 19-03                                                          ; EasyCut
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
(SearchAndAddTrsPth  "C:\\Users\\adl20\\Desktop\\EasyCutNesting Beta...")									             ; EasyCut
(if (not EasyCutRegistryPath$) (load  "C:\\Users\\adl20\\Desktop\\EasyCutNesting Beta\\Load\\StartEasyCut.lsp" ""))  			             ; EasyCut
; End Load Application                                                               ; EasyCut
